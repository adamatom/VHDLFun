library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.STD_LOGIC_ARITH.ALL;
    use IEEE.STD_LOGIC_UNSIGNED.ALL;
library unisim;
	use unisim.vcomponents.all;
entity Squares is
    Port(
        --A : out  STD_LOGIC_VECTOR (15 downto 0);
        --B : out  STD_LOGIC_VECTOR (15 downto 0);
        C : out  STD_LOGIC_VECTOR (0 downto 0);
        clk : in STD_LOGIC
    );
end Squares;

architecture Behavioral of Squares is

component TwentyMHClock
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  clk_40MHz          : out    std_logic;
  clk_200MHz          : out    std_logic;
  clk_80MHz          : out    std_logic;
  clk_160MHz          : out    std_logic
 );
end component;

signal counter : STD_LOGIC_VECTOR(47 downto 0) := (others => '0');
signal clk40mhz, clk200MHz, clk80MHz, clk160MHz : std_logic;

begin

    
    TwentyMHz : TwentyMHClock port map (-- Clock in ports
        CLK_IN1 => clk,
        -- Clock out ports
        clk_40MHz => clk40MHz,
        clk_200MHz => clk200MHz,
        clk_80MHz => clk80MHz,
        clk_160MHz => clk160MHz
    );
    
    i_oddr : oddr2
    generic map
    (
        ddr_alignment => "c1",    -- sets output alignment to "none", "c0", "c1"
        init          => '0',     -- sets initial state of the q output to '0' or '1'
        srtype        => "async"  -- specifies "sync" or "async" set/reset
    )
    port map
    (
        q  => C(0),
        c0 => clk80MHz,
        c1 => not clk80MHz,
        ce => '1',
        d0 => '1',
        d1 => '0',
        r  => '0',
        s  => '0'
    );

    --Counter to drive blinking pins 
    --count: process(clk40MHz,clk80MHz,clk160MHz,clk200MHz)
   --     begin
  --          if rising_edge(clk160MHz) then    
--
   --             counter <= counter+1;
   --         end if;
  --  end process;
    --Pins are connected to the counter to cause blinking at varying frequencies 

  --  A <= counter(35 downto 20);
  --  B <= counter(31 downto 16);
  --  C <= counter(15 downto 0);  
 
end Behavioral;
