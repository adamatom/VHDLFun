LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_Switches_LEDs IS
END tb_Switches_LEDs;
 
ARCHITECTURE behavior OF tb_Switches_LEDs IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Switches_LEDs
    PORT(
         switches : IN  std_logic_vector(7 downto 0);
         LEDs : OUT  std_logic_vector(7 downto 0);
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal switches : std_logic_vector(7 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal LEDs : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Switches_LEDs PORT MAP (
          switches => switches,
          LEDs => LEDs,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*100;
      
      -- try reset
      switches(5) <= '1' ;

      wait;
   end process;

END;
