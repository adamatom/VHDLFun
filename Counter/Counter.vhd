library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Switches_LEDs is
	Port (
		switches : in STD_LOGIC_VECTOR(7 downto 0);
		LEDs : out STD_LOGIC_VECTOR(7 downto 0);
		clk : in STD_LOGIC
	);
end Switches_LEDs;
-- This project demonstates a process synchronized to the clk. The top four bits of 
-- LEDs will show the top four bits of the count, which increments at 32MHz.
architecture Behavioral of Switches_LEDs is
	signal counter : STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
begin
	clk_proc: process(clk)
	begin
		if rising_edge(clk) then
			counter <= counter+1;
		end if;
	end process;
	LEDs <= counter(29 downto 22);
end Behavioral;