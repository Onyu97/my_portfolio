library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity data is
	 Port ( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  addr2 : out STD_LOGIC_VECTOR (4 downto 0); --mode 2���� �� �մ� ��ȣ
           addr3 : out  STD_LOGIC_VECTOR (4 downto 0); -- mode 3���� �� ȣ�� ��ȣ
           data0, data1, data2, data3, data4 : out  STD_LOGIC_VECTOR (7 downto 0);-- next 4�� ��ȣ
			  mydata : out STD_LOGIC_VECTOR (7 downto 0);
			  mode : out STD_LOGIC_VECTOR (2 downto 0);-- �� ��⿡�� ��� �ν� �� �ٸ� ���� ����. 
           load_b1 : in  STD_LOGIC; -- b1 switch, ���1
           load_b2 : in  STD_LOGIC; -- b2 switch, ���2
			  load_b3 : in  STD_LOGIC; -- b3 switch, ���3
           load_s1 : in  STD_LOGIC; -- s1 switch, ù°�ڸ� ���� ��
           load_s2 : in  STD_LOGIC; -- s2 switch, ��°�ڸ� ���� ��
			  load_s3 : in  STD_LOGIC; -- s3 switch, �ش� ��ȣ ���� �ǹ�
           number : in  STD_LOGIC_VECTOR (3 downto 0); --operand
			  push_ent : in STD_LOGIC); 
end data;

architecture Behavioral of data is

type nums is array ( 0 to 31) of std_logic_vector(7 downto 0);
signal ram: nums;
--�Ϻη� ram(0) 0���� �����ϰ� ������Ҵ�. ���࿡ cnt3�� 31�� ��� ���� ���� �������� �����Ƿ� �� ��쿡�� 
--ram(0)�� ����� 0���� ���������� �Ͽ���. 

signal numwhole : std_logic_vector (7 downto 0);-- ���� 2�ڸ� ��ȣ
signal cnt2, cnt3 : std_logic_vector(4 downto 0); -- ī��Ʈ
signal temp_mode : std_logic_vector(2 downto 0); --mode�� �߰� �ñ׳�
signal cnt3_1, cnt3_2, cnt3_3, cnt3_4 : std_logic_vector(4 downto 0);
signal pretempcnt2, tempcnt2, pretempcnt3, tempcnt3, prepush_ent : std_logic;-- �ߺ� ī��Ʈ ���� ���� ��ġ



begin

	addr2 <= cnt2;
	addr3 <= cnt3;
	mode <= temp_mode;
	mydata <= ram(conv_integer(cnt2));-- ���� ���� �Է��ϰ� �ִ� ������
	
	cnt3_1 <= "00000" when (cnt3 = "11111") else (cnt3 + 1);
	cnt3_2 <= "00000" when (cnt3 = "11110") else (cnt3 + 2);
	cnt3_3 <= "00000" when (cnt3 = "11101") else (cnt3 + 3);
	cnt3_4 <= "00000" when (cnt3 = "11100") else (cnt3 + 4);
	
	data0 <= ram(conv_integer(cnt3));
	data1 <= ram(conv_integer(cnt3_1));
	data2 <= ram(conv_integer(cnt3_2));
	data3 <= ram(conv_integer(cnt3_3));
	data4 <= ram(conv_integer(cnt3_4));
	


	----------------------------------------------------------------------------------
	--1. ��ȣ ���� �� ��� ����

	process(FPGA_RSTB, CLK)
	begin
		if FPGA_RSTB = '0' then
			numwhole <= (others => '0');
			temp_mode <= "000";
			tempcnt2<='0';
			tempcnt3<='0';
		elsif (CLK='1' and CLK'event) then
			if load_s1 = '0' then
				numwhole(7 downto 4) <= number;
				
			elsif load_s2 = '0' then
				numwhole(3 downto 0) <= number;
				tempcnt2 <= '0';
				
			elsif load_s3 = '0' then
				tempcnt3 <= '0';
				temp_mode <= "100";
				
				
			elsif load_b1 = '0' then
				temp_mode <= "001";
				
			elsif load_b2 = '0' then
				temp_mode <= "010";
				tempcnt2 <= '1';
			
				
			elsif load_b3 = '0' then
				temp_mode <= "011";
				tempcnt3 <= '1';
				
				
			end if;
		end if;
	end process;


	

	
	----------------------------------------------------------------------------------
	--2. cnt2, cnt3 �� ���� : �� ��ư�� ������ ���� ����

	process(FPGA_RSTB, CLK) 
	begin 
		if FPGA_RSTB ='0' then 
			cnt2 <= (others => '0');
			cnt3 <= (others => '0');

			
		elsif (CLK='1' and CLK'event) then
			pretempcnt2 <= tempcnt2;
			pretempcnt3 <= tempcnt3;
			prepush_ent <= push_ent;
			
			if (pretempcnt2 /= tempcnt2 and tempcnt2 = '1') then
				-- �� �Է°� �ٸ���, mode�� 2���� ��
				if cnt2 > "11111" then
					cnt2 <= "00000"; 
				else 
					cnt2 <= cnt2 + 1;
				end if;
				
			elsif (pretempcnt3 /= tempcnt3 and tempcnt3 = '1') or (prepush_ent /= push_ent and push_ent = '1') then
				-- �� �Է°� �ٸ���, mode�� 3���� ��
				if cnt3 > "11111" then
					cnt3 <= "00000"; 
				else 
					cnt3 <= cnt3 + 1;
				end if;
				
			end if;
		end if;
	end process;


	----------------------------------------------------------------------------------
	--3. ram�� �ֱ� : ram�� �Է�

	process(FPGA_RSTB, CLK)
	begin
		if (FPGA_RSTB = '0') then 
			for i in 0 to 31 loop
				ram(i) <= "00000000";  -- ��� 0 ����
			end loop;
		elsif (CLK='1' and CLK'event) then
			ram(conv_integer(cnt2)) <= numwhole;
		end if;
	end process;

















end Behavioral;

