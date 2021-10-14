
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity waitinglist is
	Port ( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           LCD_A : out  STD_LOGIC_VECTOR (1 downto 0);
           LCD_EN : out  STD_LOGIC;
           LCD_D : out  STD_LOGIC_VECTOR (7 downto 0);
			  DIGIT : out  STD_LOGIC_VECTOR (6 downto 1);-- 숫자 패널 이름
           SEG_A : out  STD_LOGIC;
           SEG_B : out  STD_LOGIC;
           SEG_C : out  STD_LOGIC;
           SEG_D : out  STD_LOGIC;
           SEG_E : out  STD_LOGIC;
           SEG_F : out  STD_LOGIC;
           SEG_G : out  STD_LOGIC;
           SEG_DP : out  STD_LOGIC;
           load_b1 : in  STD_LOGIC;
           load_b2 : in  STD_LOGIC;
           load_b3 : in  STD_LOGIC;
           load_s1: in  STD_LOGIC;
           load_s2 : in  STD_LOGIC;
			  load_s3 : in  STD_LOGIC;
           number : in  STD_LOGIC_VECTOR (3 downto 0));-- operand 
end waitinglist;

architecture Behavioral of waitinglist is

	component data
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
	end component;
	
	component mode
		Port ( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  addr2, addr3 : in STD_LOGIC_VECTOR (4 downto 0); -- data에서 가져옴
			  data0, data1, data2, data3, data4 : in  STD_LOGIC_VECTOR (7 downto 0);-- data에서 가져옴
			  mydata : in STD_LOGIC_VECTOR(7 downto 0);-- data에서 가져옴, 지금 데이터
			  mode : in STD_LOGIC_VECTOR (2 downto 0); -- data에서 가져옴, big switch 번호
           w_enable : in  STD_LOGIC; --lcd display에서 들어옴
           data_out : out  STD_LOGIC; -- lcd display로 들어감. 데이터가 나갔는지 여부만 확인
           addr : out  STD_LOGIC_VECTOR (4 downto 0); -- lcd display로 내보냄. 레지스터 번호
           data : out  STD_LOGIC_VECTOR (7 downto 0)); -- lcd display로 내보냄. 해당 레지스터에 들어갈 값
	end component;
	
	component LCD_display
		Port ( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           LCD_A : out  STD_LOGIC_VECTOR (1 downto 0);
           LCD_EN : out  STD_LOGIC;
           LCD_D : out  STD_LOGIC_VECTOR (7 downto 0);
           data_out : in  STD_LOGIC; -- mode에서 들어옴 값이 들어왔나만 표시
           addr : in  STD_LOGIC_VECTOR (4 downto 0); -- mode에서 들어옴, 해당 디스플레이 위치 표시
           data : in  STD_LOGIC_VECTOR (7 downto 0); -- mode에서 들어옴, 해당 디스플레이에 들어갈 코드 표시
           w_enable : out  STD_LOGIC); --1이면 쓰고 있는거, 0이면 안 쓰는 거
	end component;
	
	component clock 
	    Port ( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           DIGIT : out  STD_LOGIC_VECTOR (6 downto 1);-- 숫자 패널 이름
           SEG_A : out  STD_LOGIC;
           SEG_B : out  STD_LOGIC;
           SEG_C : out  STD_LOGIC;
           SEG_D : out  STD_LOGIC;
           SEG_E : out  STD_LOGIC;
           SEG_F : out  STD_LOGIC;
           SEG_G : out  STD_LOGIC;
           SEG_DP : out  STD_LOGIC;
			  addr2 : in STD_LOGIC_VECTOR (4 downto 0); --mode 2에서 온 손님 번호
           addr3 : in  STD_LOGIC_VECTOR (4 downto 0); -- mode 3에서 온 호출 번호
			  mode : in STD_LOGIC_VECTOR(2 downto 0);
			  push_ent : out STD_LOGIC);
		end component;

	signal data_reg, data0_reg, data1_reg, data2_reg, data3_reg, data4_reg : std_logic_vector (7 downto 0);
	signal mode_reg : std_logic_vector (2 downto 0);
	signal addr2_reg, addr3_reg : std_logic_vector (4 downto 0);
	signal data_out_reg, w_enable_reg: std_logic;
	signal addr_reg : std_logic_vector (4 downto 0);
	signal mydata_reg : std_logic_vector(7 downto 0);
	signal push_ent_reg : std_logic;


begin
	dataport : data port map(FPGA_RSTB, CLK, addr2_reg, addr3_reg, data0_reg,
							data1_reg, data2_reg, data3_reg, data4_reg, mydata_reg, mode_reg,
							load_b1, load_b2, load_b3, load_s1, load_s2, load_s3, number, push_ent_reg);
							
	modeport : mode port map(FPGA_RSTB, CLK, addr2_reg, addr3_reg, data0_reg, data1_reg, 
							data2_reg, data3_reg, data4_reg, mydata_reg, mode_reg,
							w_enable_reg, data_out_reg, addr_reg, data_reg);
	
	LCD_displayport : LCD_display port map(FPGA_RSTB, CLK ,LCD_A, LCD_EN, LCD_D,
							data_out_reg, addr_reg, data_reg, w_enable_reg);
	
	clockport : clock port map(FPGA_RSTB, CLK, DIGIT, SEG_A, SEG_B, SEG_C, SEG_D, SEG_E,
							SEG_F, SEG_G, SEG_DP, addr2_reg, addr3_reg, mode_reg, push_ent_reg);
	

end Behavioral;

