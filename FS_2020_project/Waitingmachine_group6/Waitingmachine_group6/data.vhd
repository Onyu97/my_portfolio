library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity data is
	 Port ( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  addr2 : out STD_LOGIC_VECTOR (4 downto 0); --mode 2에서 온 손님 번호
           addr3 : out  STD_LOGIC_VECTOR (4 downto 0); -- mode 3에서 온 호출 번호
           data0, data1, data2, data3, data4 : out  STD_LOGIC_VECTOR (7 downto 0);-- next 4개 번호
			  mydata : out STD_LOGIC_VECTOR (7 downto 0);
			  mode : out STD_LOGIC_VECTOR (2 downto 0);-- 이 모듈에서 모드 인식 후 다른 모듈로 전달. 
           load_b1 : in  STD_LOGIC; -- b1 switch, 모드1
           load_b2 : in  STD_LOGIC; -- b2 switch, 모드2
			  load_b3 : in  STD_LOGIC; -- b3 switch, 모드3
           load_s1 : in  STD_LOGIC; -- s1 switch, 첫째자리 넣을 때
           load_s2 : in  STD_LOGIC; -- s2 switch, 둘째자리 넣을 때
			  load_s3 : in  STD_LOGIC; -- s3 switch, 해당 번호 도착 의미
           number : in  STD_LOGIC_VECTOR (3 downto 0); --operand
			  push_ent : in STD_LOGIC); 
end data;

architecture Behavioral of data is

type nums is array ( 0 to 31) of std_logic_vector(7 downto 0);
signal ram: nums;
--일부러 ram(0) 0으로 설정하고 비워놓았다. 만약에 cnt3이 31일 경우 다음 것이 존재하지 않으므로 그 경우에는 
--ram(0)에 저장된 0값을 가져오도록 하였다. 

signal numwhole : std_logic_vector (7 downto 0);-- 실제 2자리 번호
signal cnt2, cnt3 : std_logic_vector(4 downto 0); -- 카운트
signal temp_mode : std_logic_vector(2 downto 0); --mode용 중간 시그널
signal cnt3_1, cnt3_2, cnt3_3, cnt3_4 : std_logic_vector(4 downto 0);
signal pretempcnt2, tempcnt2, pretempcnt3, tempcnt3, prepush_ent : std_logic;-- 중복 카운트 막기 위한 조치



begin

	addr2 <= cnt2;
	addr3 <= cnt3;
	mode <= temp_mode;
	mydata <= ram(conv_integer(cnt2));-- 현재 내가 입력하고 있는 데이터
	
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
	--1. 번호 수집 및 모드 설정

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
	--2. cnt2, cnt3 값 지정 : 각 버튼을 눌렀을 때만 증가

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
				-- 전 입력과 다르고, mode가 2번일 때
				if cnt2 > "11111" then
					cnt2 <= "00000"; 
				else 
					cnt2 <= cnt2 + 1;
				end if;
				
			elsif (pretempcnt3 /= tempcnt3 and tempcnt3 = '1') or (prepush_ent /= push_ent and push_ent = '1') then
				-- 전 입력과 다르고, mode가 3번일 때
				if cnt3 > "11111" then
					cnt3 <= "00000"; 
				else 
					cnt3 <= cnt3 + 1;
				end if;
				
			end if;
		end if;
	end process;


	----------------------------------------------------------------------------------
	--3. ram에 넣기 : ram값 입력

	process(FPGA_RSTB, CLK)
	begin
		if (FPGA_RSTB = '0') then 
			for i in 0 to 31 loop
				ram(i) <= "00000000";  -- 모두 0 삽입
			end loop;
		elsif (CLK='1' and CLK'event) then
			ram(conv_integer(cnt2)) <= numwhole;
		end if;
	end process;

















end Behavioral;

