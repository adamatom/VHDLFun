library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Switches_LEDs is
	Port ( 
		switch_0 : in STD_LOGIC;
		switch_1 : in STD_LOGIC;
		LED_0 : out STD_LOGIC;
		LED_1 : out STD_LOGIC;
		notLED_0 : out STD_LOGIC;
		notLED_1 : out STD_LOGIC
	);
end Switches_LEDs;

architecture Behavioral of Switches_LEDs is
begin
	LED_0 <= switch_0;
	LED_1 <= switch_1;
	notLED_0 <= not switch_0;
	notLED_1 <= not switch_1;
end Behavioral;