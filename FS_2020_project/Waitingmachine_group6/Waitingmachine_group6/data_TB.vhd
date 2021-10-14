---------------------------------------------------------------------------------
-- second module : data's TB
-- Hwang Onyu
---------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY data_TB IS
END data_TB;
 
ARCHITECTURE behavior OF data_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data
    PORT( FPGA_RSTB : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  addr2 : out STD_LOGIC_VECTOR (4 downto 0); --mode 2에서 온 손님 번호
           addr3 : out  STD_LOGIC_VECTOR (4 downto 0); -- mode 3에서 온 호출 번호
           data0, data1, data2, data3, data4 : out  STD_LOGIC_VECTOR (7 downto 0);-- next 4개 번호
			  mydata : out STD_LOGIC_VECTOR (7 downto 0);
			  mode : out STD_LOGIC_VECTOR (1 downto 0);-- 이 모듈에서 모드 인식 후 다른 모듈로 전달. 
           load_b1 : in  STD_LOGIC; -- b1 switch, 모드1
           load_b2 : in  STD_LOGIC; -- b2 switch, 모드2
			  load_b3 : in  STD_LOGIC; -- b3 switch, 모드3
           load_s1 : in  STD_LOGIC; -- s1 switch, 첫째자리 넣을 때
           load_s2 : in  STD_LOGIC; -- s2 switch, 둘째자리 넣을 때
			  load_s3 : in  STD_LOGIC; -- s3 switch, 해당 번호 도착 의미
           number : in  STD_LOGIC_VECTOR (3 downto 0); --operand
			  push_ent : in STD_LOGIC); 
    END COMPONENT;
    

   --Inputs
   signal FPGA_RSTB : std_logic := '0';
   signal CLK : std_logic := '0';
   signal load_b1 : std_logic := '0';
   signal load_b2 : std_logic := '0';
   signal load_b3 : std_logic := '0';
   signal load_s1 : std_logic := '0';
   signal load_s2 : std_logic := '0';
   signal load_s3 : std_logic := '0';
   signal number : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal addr2 : std_logic_vector(4 downto 0);
   signal addr3 : std_logic_vector(4 downto 0);
   signal data1 : std_logic_vector(7 downto 0);
   signal data2 : std_logic_vector(7 downto 0);
   signal data3 : std_logic_vector(7 downto 0);
   signal data4 : std_logic_vector(7 downto 0);
   signal mode : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 250 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data PORT MAP (
          FPGA_RSTB => FPGA_RSTB,
          CLK => CLK,
          addr2 => addr2,
          addr3 => addr3,
          data1 => data1,
          data2 => data2,
          data3 => data3,
          data4 => data4,
          mode => mode,
          load_b1 => load_b1,
          load_b2 => load_b2,
          load_b3 => load_b3,
          load_s1 => load_s1,
          load_s2 => load_s2,
          load_s3 => load_s3,
          number => number
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
	load_b1 <= '1';
	load_b2 <= '1';
	load_b3 <= '1';
	load_s1 <= '1';
	load_s2 <= '1';
	load_s3 <= '1';
	
	wait for 10 ms;
	FPGA_RSTB <= '1';
	
	-- ram(1)에 56 입력
	wait for 10 ms;
	load_b2 <= '0';
	wait for 10 ms;
	load_b2 <= '1';
	number <= "0101";
	wait for 10 ms;
	load_s1 <= '0';
	wait for 10 ms;
	load_s1 <= '1';
	wait for 10 ms;
	number <= "0110";
	wait for 10 ms;
	load_s2 <= '0';
	wait for 100ms;
	load_s2 <= '1';
	
	-- ram(2)에 43 입력
	wait for 10 ms;
	load_b2 <= '0';
	wait for 10 ms;
	load_b2 <= '1';
	number <= "0100";
	wait for 10 ms;
	load_s1 <= '0';
	wait for 10 ms;
	load_s1 <= '1';
	wait for 10 ms;
	number <= "0011";
	wait for 10 ms;
	load_s2 <= '0';
	wait for 100ms;
	load_s2 <= '1';
	
	
	
	-- ram(3)에 21 입력
	
	wait for 10 ms;
	load_b2 <= '0';
	wait for 10 ms;
	load_b2 <= '1';
	number <= "0010";
	wait for 10 ms;
	load_s1 <= '0';
	wait for 10 ms;
	load_s1 <= '1';
	wait for 10 ms;
	number <= "0001";
	wait for 10 ms;
	load_s2 <= '0';
	wait for 100ms;
	load_s2 <= '1';
	
	
	-- ram(4)에 19 입력
	wait for 10 ms;
	load_b2 <= '0';
	wait for 10 ms;
	load_b2 <= '1';
	number <= "0001";
	wait for 10 ms;
	load_s1 <= '0';
	wait for 10 ms;
	load_s1 <= '1';
	wait for 10 ms;
	number <= "1001";
	wait for 10 ms;
	load_s2 <= '0';
	wait for 100ms;
	load_s2 <= '1';
	
	wait for 20 ms;
	load_b3 <= '0';
	wait for 10 ms;
	load_b3 <= '1';
	wait for 10 ms;
	load_s3 <= '0';
	wait for 10 ms;
	load_s3 <= '1';
	

	wait for 20 ms;
	load_b3 <= '0';
	wait for 10 ms;
	load_b3 <= '1';
	wait for 10 ms;
	load_s3 <= '0';
	wait for 10 ms;
	load_s3 <= '1';
	
	wait for 20 ms;
	load_b3 <= '0';
	wait for 10 ms;
	load_b3 <= '1';
	wait for 10 ms;
	load_s3 <= '0';
	wait for 10 ms;
	load_s3 <= '1';



      wait;
   end process;

END;
