--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:36:36 07/04/2015
-- Design Name:   
-- Module Name:   /home/adam/projects/VHDLFun/ReadFlashRegister/test_top_level.vhd
-- Project Name:  ReadFlashRegister
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_level
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_top_level IS
END test_top_level;
 
ARCHITECTURE behavior OF test_top_level IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_level
    PORT(
         TX : OUT  std_logic;
         CLK : IN  std_logic;
         FLASH_SCLK : OUT  std_logic;
         FLASH_CS : OUT  std_logic;
         FLASH_SO : IN  std_logic;
         FLASH_SI : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal FLASH_SO : std_logic := '0';

 	--Outputs
   signal TX : std_logic;
   signal FLASH_SCLK : std_logic;
   signal FLASH_CS : std_logic;
   signal FLASH_SI : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
   constant FLASH_SCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_level PORT MAP (
          TX => TX,
          CLK => CLK,
          FLASH_SCLK => FLASH_SCLK,
          FLASH_CS => FLASH_CS,
          FLASH_SO => FLASH_SO,
          FLASH_SI => FLASH_SI
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   FLASH_SCLK_process :process
   begin
		FLASH_SCLK <= '0';
		wait for FLASH_SCLK_period/2;
		FLASH_SCLK <= '1';
		wait for FLASH_SCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
