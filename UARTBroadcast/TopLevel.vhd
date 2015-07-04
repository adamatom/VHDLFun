library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top_level is
    port(
            TX: out  std_logic;
            CLK: in std_logic
        );
end top_level;

architecture Behavioral of top_level is

    component byte_bit_transmitter is
        port( 
                TX : out  std_logic;
                DATA_EN: in std_logic;
                DATA_IN: in std_logic_vector(7 downto 0);
                CLK : in std_logic
            );
    end component;

    signal clocks: std_logic_vector(1 downto 0);

    signal tx_in: std_logic_vector(7 downto 0);
    signal tx_send: std_logic := '0';
    signal tx_clk: std_logic;

    signal data_send_clk: std_logic_vector(1 downto 0);

    signal count: std_logic_vector(31 downto 0) := (others => '0');
    signal pul_count : std_logic_vector(7 downto 0) := (others => '0');
    signal pul_check: std_logic_vector(5 downto 0) := (others => '0');

begin

    process(CLK)
    begin
        if rising_edge(CLK) then
            count <= count + 1;
        end if;
    end process;

    tx_clk <= count(3);
    data_send_clk <= count(21 downto 20);

    bt_inst: byte_bit_transmitter
    port map(
                TX => TX,
                DATA_IN => tx_in,
                DATA_EN => tx_send,
                CLK => tx_clk
            );

    process(CLK)
    begin
        if rising_edge(CLK) then
            case data_send_clk is
                when "10" =>
                    tx_in <= count(29 downto 22);
                    tx_send <= '1';
                when others =>
                    tx_send <= '0';
            end case;
        end if;
    end process;


end Behavioral;

