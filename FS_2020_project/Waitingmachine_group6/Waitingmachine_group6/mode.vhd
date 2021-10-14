library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mode is
	  Port ( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  addr2, addr3 : in STD_LOGIC_VECTOR (4 downto 0); -- data에서 가져옴
			  data0, data1, data2, data3, data4 : in  STD_LOGIC_VECTOR (7 downto 0);-- data에서 가져옴 : 다음 4개의 번호
			  mydata : in STD_LOGIC_VECTOR(7 downto 0);-- data에서 가져옴, 지금 데이터
			  mode : in STD_LOGIC_VECTOR (2 downto 0); -- data에서 가져옴, big switch 번호
           w_enable : in  STD_LOGIC; --lcd display에서 들어옴
           data_out : out  STD_LOGIC; -- lcd display로 들어감. 데이터가 나갔는지 여부만 확인
           addr : out  STD_LOGIC_VECTOR (4 downto 0); -- lcd display로 내보냄. 레지스터 번호
           data : out  STD_LOGIC_VECTOR (7 downto 0)); -- lcd display로 내보냄. 해당 레지스터에 들어갈 값
end mode;

architecture Behavioral of mode is

	type reg is array ( 0 to 31) of std_logic_vector(7 downto 0);
	signal reg_file: reg;
	
	signal cnt : std_logic_vector(4 downto 0);--default
	signal tot_num : std_logic_vector(4 downto 0); -- 남은 사람수 확인 용
	signal num_1: std_logic_vector(4 downto 0); -- 남은 사람수의 1의 자리
	signal ahead : std_logic_vector(4 downto 0);
	--signal now_calling : std_logic_vector(7 downto 0); -- 지금 불러야 하는 번호

begin

-------------------------------------------------------------------------
--1. mode에 따라 각자 넣기
	
	-- 들어갈 사람 몇 명 남았음?
	tot_num <= (addr2-addr3) when (addr2 > addr3) else "00000";
	
	-- addr2 가 버튼 2 누르는 순간 카운트 되기 때문에 그건 제외해야함 
	ahead <= (addr2 - addr3 -1) when (addr2 > addr3) else "00000";
	
	process(FPGA_RSTB, CLK) 
	begin
		if (FPGA_RSTB = '0') or (mode = "00") then 
			for i in 0 to 31 loop
				reg_file(i) <= X"20"; -- space 넣기
			end loop;
			
		elsif (CLK='1' and CLK'event) then
		
		-- mode 1
			if mode = "001" then 
				

				
				
				reg_file(0) <= X"3C"; --<
				reg_file(1) <= data1(7 downto 4) + X"30"; 
				reg_file(2) <= data1(3 downto 0) + X"30";
				reg_file(3) <= X"3E"; -->
				
				reg_file(4) <= X"3C"; --<
				reg_file(5) <= data2(7 downto 4) + X"30";
				reg_file(6) <= data2(3 downto 0) + X"30";
				reg_file(7) <= X"3E"; -->

				reg_file(8) <= X"3C"; --<--
				reg_file(9) <= data3(7 downto 4) + X"30";
				reg_file(10) <= data3(3 downto 0) + X"30";
				reg_file(11) <= X"3E"; -->
				
				reg_file(12) <= X"3C"; --<
				reg_file(13) <= data4(7 downto 4) + X"30";
				reg_file(14) <= data4(3 downto 0) + X"30";
				reg_file(15) <= X"3E"; -->
				
				
				reg_file(16) <= X"54"; --T
				reg_file(17) <= X"4F"; --o
				reg_file(18) <= X"54"; --t
				reg_file(19) <= X"41"; --a
				reg_file(20) <= X"4C"; --l
				reg_file(21) <= X"20"; --space
				reg_file(22) <= X"4E"; --n
				reg_file(23) <= X"55"; --u
				reg_file(24) <= X"4D"; --m
				reg_file(25) <= X"42"; --b
				reg_file(26) <= X"45"; --e
				reg_file(27) <= X"52"; --r
				reg_file(28) <= X"3A"; -- :
				
				if tot_num > "11101" then --29 보다 크면
					reg_file(29) <= X"33"; -- 첫자리 3
					num_1 <= tot_num - "11110"; -- (-30)
					reg_file(30) <= num_1 + X"30";
					
				elsif tot_num > "10011" then -- 19보다 클 때 
					reg_file(29) <= X"32"; -- 첫자리 2
					num_1 <= tot_num - "10100"; -- (-20)
					reg_file(30) <= num_1 + X"30";
				
				elsif tot_num > "1001" then-- 9보다 클 때 
					reg_file(29) <= X"31"; -- 첫자리 2
					num_1 <= tot_num - "01010"; -- (-20)
					reg_file(30) <= num_1 + X"30";
				
				else -- 9보다 작을 때 
					reg_file(29) <= X"30";
					reg_file(30) <= tot_num + X"30";
				end if;
				reg_file(31) <= X"20"; --space
				
		--mode 2
			elsif mode = "010" then
				
			
				reg_file(0) <= X"59"; --Y
				reg_file(1) <= X"4F"; --O
				reg_file(2) <= X"55"; --U
				reg_file(3) <= X"52"; --R
				reg_file(4) <= X"4E"; --N
				reg_file(5) <= X"55"; --U
				reg_file(6) <= X"4D"; --M
				reg_file(7) <= X"42"; --B
				reg_file(8) <= X"45"; --E
				reg_file(9) <= X"52"; --R
				reg_file(10) <= X"3A"; --:
				reg_file(11) <= mydata(7 downto 4) + X"30";
				reg_file(12) <= mydata(3 downto 0) + X"30";
				reg_file(13) <= X"20"; --space
				reg_file(14) <= X"20"; --space
				reg_file(15) <= X"20"; --space
				
				if ahead > "11101" then --29 보다 크면
					reg_file(16) <= X"33"; -- 첫자리 3
					num_1 <= ahead - "11110"; -- (-30)
					reg_file(17) <= num_1 + X"30";
					
				elsif ahead > "10011" then -- 19보다 클 때 
					reg_file(16) <= X"32"; -- 첫자리 2
					num_1 <= ahead - "10100"; -- (-20)
					reg_file(17) <= num_1 + X"30";
				
				elsif ahead > "1001" then-- 9보다 클 때 
					reg_file(16) <= X"31"; -- 첫자리 2
					num_1 <= ahead - "01010"; -- (-20)
					reg_file(17) <= num_1 + X"30";
				
				else -- 9보다 작을 때 
					reg_file(16) <= X"30";
					reg_file(17) <= ahead + X"30";
				end if;
			
				reg_file(18) <= X"20"; --space
				reg_file(19) <= X"50"; --p
				reg_file(20) <= X"45"; --e
				reg_file(21) <= X"4F"; --o
				reg_file(22) <= X"50"; --p
				reg_file(23) <= X"4C"; --l
				reg_file(24) <= X"45"; --e
				reg_file(25) <= X"20"; --space
				reg_file(26) <= X"41"; --a
				reg_file(27) <= X"48"; --h
				reg_file(28) <= X"45"; --e
				reg_file(29) <= X"41"; --a
				reg_file(30) <= X"44"; --d
				reg_file(31) <= X"20"; --space
					
				
			-- 이미 mode3를 누르면 카운트가 되기 때문에 다음 데이터가 아닌 현재 데이터를 가져와야 한다. 	
			elsif mode = "011" then
				
				reg_file(0) <= X"43"; --C
				reg_file(1) <= X"41"; --A
				reg_file(2) <= X"4C"; --L
				reg_file(3) <= X"4C"; --L
				reg_file(4) <= X"49"; --I
				reg_file(5) <= X"4E"; --N
				reg_file(6) <= X"47"; --G
				reg_file(7) <= X"3A"; --:
				reg_file(8) <= data0(7 downto 4) + X"30";
				reg_file(9) <= data0(3 downto 0) + X"30";
				reg_file(10) <= X"20"; 
				reg_file(11) <= X"20";
				reg_file(12) <= X"20";
				reg_file(13) <= X"20";
				reg_file(14) <= X"20";
				reg_file(15) <= X"20";
				reg_file(16) <= X"20";
				reg_file(17) <= X"20";
				reg_file(18) <= X"20";
				reg_file(19) <= X"20";
				reg_file(20) <= X"20"; --space
				reg_file(21) <= X"20";
				reg_file(22) <= X"20";
				reg_file(23) <= X"20";
				reg_file(24) <= X"20";
				reg_file(25) <= X"20";
				reg_file(26) <= X"20";
				reg_file(27) <= X"20";
				reg_file(28) <= X"20";
				reg_file(29) <= X"20";
				reg_file(30) <= X"20";
				reg_file(31) <= X"20";
				
			elsif mode = "100" then
				
				
				reg_file(0) <= X"45"; --E
				reg_file(1) <= X"4E"; --N
				reg_file(2) <= X"54"; --T
				reg_file(3) <= X"45"; --E
				reg_file(4) <= X"52"; --R
				reg_file(5) <= X"45"; --E
				reg_file(6) <= X"44"; --D
				reg_file(7) <= X"20"; 
				reg_file(8) <= X"20"; 
				reg_file(9) <= X"20"; 
				reg_file(10) <= X"20"; 
				reg_file(11) <= X"20";
				reg_file(12) <= X"20";
				reg_file(13) <= X"20";
				reg_file(14) <= X"20";
				reg_file(15) <= X"20";
				reg_file(16) <= X"20";
				reg_file(17) <= X"20";
				reg_file(18) <= X"20";
				reg_file(19) <= X"20";
				reg_file(20) <= X"20"; --space
				reg_file(21) <= X"20";
				reg_file(22) <= X"20";
				reg_file(23) <= X"20";
				reg_file(24) <= X"20";
				reg_file(25) <= X"20";
				reg_file(26) <= X"20";
				reg_file(27) <= X"20";
				reg_file(28) <= X"20";
				reg_file(29) <= X"20";
				reg_file(30) <= X"20";
				reg_file(31) <= X"20";
			end if;
		end if;
	end process;
	
----------------------------------------------------------------------------------
--2. 	실제 모듈에 출력
	process(FPGA_RSTB, CLK) 
	begin
		if (FPGA_RSTB = '0') then 
			cnt <= (others => '0');
			data_out <= '0'; 
			
		elsif (CLK='1' and CLK'event) then 
			if (w_enable = '1') then 
				data <= reg_file(conv_integer(cnt)); 
				addr <= cnt; 
				data_out <= '1';				
				if cnt = X"1F" then -- 31
					cnt <= (others => '0');
				else 
					cnt <= cnt + 1; 
				end if;
			else
				data_out <= '0'; 
			end if;
		end if;
	end process;
	
----------------------------------------------------------------------------------
--3. 	mode 3에서 다음 번호 출력






end Behavioral;

