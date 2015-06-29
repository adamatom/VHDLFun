library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Switches_LEDs is
	Port ( 
		switch_0 : in STD_LOGIC;
		switch_1 : in STD_LOGIC;
		LED_0 : out STD_LOGIC
	);
end Switches_LEDs;

-- just testing out some logic; Hello, world!
architecture Behavioral of Switches_LEDs is
begin
	LED_0 <= not switch_0 and switch_1;
end Behavioral;