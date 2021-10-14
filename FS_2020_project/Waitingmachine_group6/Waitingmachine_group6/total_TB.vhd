
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY total_TB IS
END total_TB;
 
ARCHITECTURE behavior OF total_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT waitinglist
    PORT(
         FPGA_RSTB : IN  std_logic;
         CLK : IN  std_logic;
         LCD_A : OUT  std_logic_vector(1 downto 0);
         LCD_EN : OUT  std_logic;
         LCD_D : OUT  std_logic_vector(7 downto 0);
         DIGIT : OUT  std_logic_vector(6 downto 1);
         SEG_A : OUT  std_logic;
         SEG_B : OUT  std_logic;
         SEG_C : OUT  std_logic;
         SEG_D : OUT  std_logic;
         SEG_E : OUT  std_logic;
         SEG_F : OUT  std_logic;
         SEG_G : OUT  std_logic;
         SEG_DP : OUT  std_logic;
         load_b1 : IN  std_logic;
         load_b2 : IN  std_logic;
         load_b3 : IN  std_logic;
         load_s1 : IN  std_logic;
         load_s2 : IN  std_logic;
         load_s3 : IN  std_logic;
         number : IN  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal FPGA_RSTB : std_logic := '0';
   signal CLK : std_logic := '0';
   signal load_b1 : std_logic := '1';
   signal load_b2 : std_logic := '1';
   signal load_b3 : std_logic := '1';
   signal load_s1 : std_logic := '1';
   signal load_s2 : std_logic := '1';
   signal load_s3 : std_logic := '1';
   signal number : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal LCD_A : std_logic_vector(1 downto 0);
   signal LCD_EN : std_logic;
   signal LCD_D : std_logic_vector(7 downto 0);
   signal DIGIT : std_logic_vector(6 downto 1);
   signal SEG_A : std_logic;
   signal SEG_B : std_logic;
   signal SEG_C : std_logic;
   signal SEG_D : std_logic;
   signal SEG_E : std_logic;
   signal SEG_F : std_logic;
   signal SEG_G : std_logic;
   signal SEG_DP : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 0.1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: waitinglist PORT MAP (
          FPGA_RSTB => FPGA_RSTB,
          CLK => CLK,
          LCD_A => LCD_A,
          LCD_EN => LCD_EN,
          LCD_D => LCD_D,
          DIGIT => DIGIT,
          SEG_A => SEG_A,
          SEG_B => SEG_B,
          SEG_C => SEG_C,
          SEG_D => SEG_D,
          SEG_E => SEG_E,
          SEG_F => SEG_F,
          SEG_G => SEG_G,
          SEG_DP => SEG_DP,
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
      -- hold reset state for 100 ns.
		wait for 10 ns;
		FPGA_RSTB<='1';
		
		
      wait for 50 ns;	
		
		load_b3 <= '0';
		
		wait for 300 ns;	
		
		load_b3 <= '1';
      
      -- insert stimulus here 

      wait;
   end process;

END;
