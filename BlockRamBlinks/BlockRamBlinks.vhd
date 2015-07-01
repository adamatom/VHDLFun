library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BlockRamBlinks is
    Port ( clk : in  STD_LOGIC;
           LEDs : out  STD_LOGIC_VECTOR (7 downto 0));
end BlockRamBlinks;

architecture Behavioral of BlockRamBlinks is

COMPONENT counter
  PORT (
    clk : IN STD_LOGIC;
    q : OUT STD_LOGIC_VECTOR(29 DOWNTO 0)
  );
END COMPONENT;

COMPONENT patternROM
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal count : STD_LOGIC_VECTOR(29 downto 0);
begin
count30 : counter
  PORT MAP (
    clk => clk,
    q => count
  );
lookup : patternROM
  PORT MAP (
    clka => clk,
    ena => '1',
    addra => count(29 downto 20),
    douta => LEDs
  );
end Behavioral;

