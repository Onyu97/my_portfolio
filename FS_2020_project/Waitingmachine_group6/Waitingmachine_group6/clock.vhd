library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock is 
    Port ( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           DIGIT : out  STD_LOGIC_VECTOR (6 downto 1);-- ���� �г� �̸�
           SEG_A : out  STD_LOGIC;
           SEG_B : out  STD_LOGIC;
           SEG_C : out  STD_LOGIC;
           SEG_D : out  STD_LOGIC;
           SEG_E : out  STD_LOGIC;
           SEG_F : out  STD_LOGIC;
           SEG_G : out  STD_LOGIC;
           SEG_DP : out  STD_LOGIC;
			  addr2 : in STD_LOGIC_VECTOR (4 downto 0); --mode 2���� �� �մ� ��ȣ
           addr3 : in  STD_LOGIC_VECTOR (4 downto 0); -- mode 3���� �� ȣ�� ��ȣ
			  mode : in STD_LOGIC_VECTOR(2 downto 0);
			  push_ent : out STD_LOGIC);
end clock;

architecture Behavioral of clock is

signal s01_clk : STD_LOGIC; -- 60�� �� ���� �Ѿ
signal hr01_cnt, hr10_cnt : STD_LOGIC_VECTOR(3 downto 0);
signal min01_cnt, min10_cnt : STD_LOGIC_VECTOR(3 downto 0);
signal sec01_cnt, sec10_cnt : STD_LOGIC_VECTOR(3 downto 0);


signal sel : STD_LOGIC_VECTOR(2 downto 0);
signal data : STD_LOGIC_VECTOR(3 downto 0);
signal seg : STD_LOGIC_VECTOR(7 downto 0);


signal tot_num, tot_num_5bit : STD_LOGIC_VECTOR (4 downto 0);
signal push_ent_temp : std_logic;

begin
----------------------------------------------------------------------------------
	-- 1. �г� ��ȣ ���� �� �� �г� ���� ���ڿ� ���� ��°� ����
	
	process(sel)
	begin 
		case sel is
			when "000" => -- ���� ù��° ���� �г�
				DIGIT <= "000001"; 
				data <= hr10_cnt;
			when "001" => -- 2��° �г�
				DIGIT <= "000010";
				data <= hr01_cnt;
			when "010" => -- 3��° �г�
				DIGIT <= "000100";
				data <= min10_cnt;
			when "011" => -- 4��° �г�
				DIGIT <= "001000";
				data <= min01_cnt;
			when "100" => -- 5��° �г�
				DIGIT <= "010000";
				data <= sec10_cnt;
			when "101" => -- 6��° �г�
				DIGIT <= "100000";
				data <= sec01_cnt;
			when others => null;
		end case;
	end process;
----------------------------------------------------------------------------------
	-- 2. reset, �г� ���� ��� ����
	
	process(FPGA_RSTB,CLK)
		-- ���� �Է�
		variable seg_clk_cnt : integer range 0 to 200;
	begin 
		
		if (FPGA_RSTB = '0') then -- reset ��ư ������ 0���� ���ư���
			sel <= "000"; 
			seg_clk_cnt := 0;
		
		elsif ( CLK'event and CLK = '1') then
			-- 200�� * 4MHz = 50us�� �ֱ⸦ ������ �ȴ�. 
			
			if (seg_clk_cnt = 200) then
				seg_clk_cnt := 0; -- ���ο� clock �����
				-- clock�� 200���� �Ǿ��� ���� sel �� ��ȭ��
				
				-- �� ���� 6���� �г� ǥ�ð� �Ұ����ؼ�
				-- �ϳ��� ���ư��鼭 ǥ����
				if (sel = "101") then 
				-- ������ �����гα��� ���� sel�� �ٽ� ù �гη� ���ư���
					sel <= "000"; 
				else
					sel <= sel + 1;
				end if;
				
			else
				seg_clk_cnt := seg_clk_cnt + 1;
			end if;
		end if;
	end process;
----------------------------------------------------------------------------------
	-- 3. �� ���ڸ� ����� ���� ������ ����
	
	--dp g f e d c b a ����
	process(data)
	begin 
		case data is
			when "0000" => --number 0
				seg <= "00111111";
			when "0001" => --number 1
				seg <= "00000110";
			when "0010" => --number 2
				seg <= "01011011";
			when "0011" => --number 3
				seg <= "01001111";
			when "0100" => --number 4
				seg <= "01100110";
			when "0101" => --number 5
				seg <= "01101101";
			when "0110" => --number 6
				seg <= "01111101";
			when "0111" => --number 7
				seg <= "00000111";
			when "1000" => --number 8
				seg <= "01111111";
			when "1001" => --number 9
				seg <= "01100111";
			when "1010" => --number 10 : ��ĭ
				seg <= "00000000";
			when others => null;
		end case;
	end process;
----------------------------------------------------------------------------------
	-- 4. out signal �� ���ν�ȣ ����
	
	SEG_A <= seg(0);
	SEG_B <= seg(1);
	SEG_C <= seg(2);
	SEG_D <= seg(3);
	SEG_E <= seg(4);
	SEG_F <= seg(5);
	SEG_G <= seg(6);
	SEG_DP <= seg(7);
----------------------------------------------------------------------------------
	-- 5. clock ����� : 4MHZ -> 0.5sec
	
	process(FPGA_RSTB,CLK)
		-- 250ns = 1/4,000,000
		-- 250ns * 2,000,000 = 0.5
		variable count_clk : integer range 0 to 2000000;--2,000,000
		
		begin 
			if (FPGA_RSTB = '0') then
			
				s01_clk <= '1';
				count_clk := 0;
				
			elsif( CLK'event and CLK = '1') then
			
				if (count_clk = 2000000) then -- 2,000,000
					-- new clock reset
					count_clk := 0;
					-- ���� ���� clock�� 0�̸� 1��, 1�̸� 0���� ������Ų��. 
					
					s01_clk <= not s01_clk;

				else
					count_clk := count_clk + 1;
				
				end if;
			end if;
	end process;

----------------------------------------------------------------------------------
--6. mode 3���� count �����ϱ�



	tot_num <= (addr2-addr3) when (addr2 > addr3) else "00000";

	process(FPGA_RSTB, s01_clk)	
	
	variable h10_cnt, h01_cnt, m10_cnt, m01_cnt, s10_cnt, s01_cnt : STD_LOGIC_VECTOR (3 downto 0);	
	
	begin
		if (FPGA_RSTB = '0') then --reset : 00:00:00
			
			s01_cnt := "0000"; 
			s10_cnt := "0000"; 
			m01_cnt := "0000"; 
			m10_cnt := "0000"; 
			h01_cnt := "0000"; 
			h10_cnt := "0000"; 
		elsif (s01_clk = '1' and s01_clk'event) then
			if (mode="001" or mode = "010") then
				s01_cnt := "0000"; 
				s10_cnt := "0000"; 
				m01_cnt := "0000";
				h10_cnt := "0000";
				if (tot_num < "00110") then
					h01_cnt := "0000"; 					
					m10_cnt := tot_num(3 downto 0);
				elsif (tot_num < "01100") then
					h01_cnt := "0001";
					m10_cnt := tot_num(3 downto 0) - "0110";
				elsif (tot_num < "10010") then
					h01_cnt := "0010";
					tot_num_5bit <= tot_num - "01100";
					m10_cnt := tot_num_5bit(3 downto 0);
				elsif (tot_num < "11000") then
					h01_cnt := "0011";
					tot_num_5bit <= tot_num - "10010";
					m10_cnt := tot_num_5bit(3 downto 0);
				else --��� 4�ð�
					h01_cnt := "0100";
					m10_cnt := "0000";
				end if;
			elsif (mode="011") then 
				m01_cnt := "0000"; 
				m10_cnt := "0000"; 
				h01_cnt := "0000"; 
				h10_cnt := "0000";
				if (s01_cnt = "0000") then
					if (s10_cnt = "0011") then
						s01_cnt := "1001";
						s10_cnt := "0010";
						push_ent_temp <= '0';
					elsif (s10_cnt = "0010") then
						s01_cnt := "1001";
						s10_cnt := "0001";
					elsif (s10_cnt = "0001") then
						s01_cnt := "1001";
						s10_cnt := "0000";
					else
						s01_cnt := "0000";
						s10_cnt := "0011";
					end if;
				elsif (s01_cnt = "0001" and s10_cnt = "0000") then
					push_ent_temp <= '1';
					s01_cnt := s01_cnt -1;
				else
					s01_cnt := s01_cnt -1;
				end if;
			end if;
		end if;
			
		sec01_cnt<=s01_cnt; 
		sec10_cnt<=s10_cnt;
		min01_cnt<=m01_cnt;
		min10_cnt<=m10_cnt;
		hr01_cnt<=h01_cnt;
		hr10_cnt<=h10_cnt;
	
	end process;
	push_ent <= push_ent_temp;


	
end Behavioral;

