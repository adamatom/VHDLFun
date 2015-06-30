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

architecture Behavioral of Switches_LEDs is
    signal counter : STD_LOGIC_VECTOR(29 downto 0) := (others => '0');
    signal incHighNext : STD_LOGIC := '0';
begin
    LEDs <= counter(29 downto 22);
    clk_proc: process(clk, counter)
        begin
        if rising_edge(clk) then
            counter(29 downto 15) <= counter(29 downto 15)+incHighNext;
            if counter(14 downto 0) = "111111111111110" then
                incHighNext <= '1';
            else
                incHighNext <= '0';
            end if;
            counter(14 downto 0) <= counter(14 downto 0)+1;
        end if;
    end process;
end Behavioral;