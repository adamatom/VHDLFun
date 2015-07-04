library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity top_level is
    port(
            TX: out  std_logic;
            CLK: in std_logic;
            FLASH_SCLK : out STD_LOGIC;
            FLASH_CS   : out STD_LOGIC;
            FLASH_SO   : in  STD_LOGIC;
            FLASH_SI   : out STD_LOGIC
        );
end top_level;

architecture Behavioral of top_level is

    component byte_bit_transmitter is
        port( 
                TX : out  std_logic;
                DATA_EN: in std_logic;
                DATA_IN: in std_logic_vector(7 downto 0);
                DATA_SENT: out std_logic;
                CLK : in std_logic
            );
    end component;

    signal tx_in: std_logic_vector(7 downto 0);
    signal tx_send: std_logic := '0';
    signal tx_clk: std_logic;

    type state is (enable_cs, read_byte, display_byte);
    signal reader_state: state := enable_cs;

    constant read_status_cmd    : std_logic_vector(7 downto 0)  := x"05";
    constant read_status_clocks : unsigned(5 downto 0) := "010000";

    -- command bit gets changed every other clock transition
    signal cmd_sr  : std_logic_vector(15 downto 0) := read_status_cmd & x"00";

    -- counter to keep track of when we have data - first byte is available after 8 ticks
    signal clocks_to_byte : unsigned(5 downto 0) := read_status_clocks;

    signal byte : std_logic_vector(7 downto 0 );
    signal count : std_logic_vector(31 downto 0) := x"00000000";
    signal data_sr : std_logic_vector( 7 downto 0);
    signal sent : std_logic;
    signal cs_delay : std_logic_vector(2 downto 0) := "000";
begin
    flash_sclk <= CLK;
    tx_clk <= count(3);
    process(CLK)
    begin
        if rising_edge(CLK) then
            count <= count + 1;
        end if;
    end process;

    bt_inst: byte_bit_transmitter
    port map(
                TX => TX,
                DATA_IN => tx_in,
                DATA_EN => tx_send,
                DATA_SENT => sent,
                CLK => tx_clk
            );

    process(CLK)
    begin
        if falling_edge(CLK) then
            case reader_state is
                when enable_cs =>
                    tx_send <= '0';
                    cs_delay <= cs_delay + 1;
                    if cs_delay >= "111" then
                        reader_state <= read_byte;
                    else
                        flash_cs <= '1';
                    end if;
                when read_byte =>
                    cs_delay <= "000";
                    tx_send <= '0';
                    
                    flash_cs   <= '0';
                    flash_si   <= cmd_sr(15);
                    data_sr <= data_sr(6 downto 0) &  flash_so;
                    cmd_sr <= cmd_sr(14 downto 0) &'0';
                    
                    if clocks_to_byte = "000000" then -- done shifting registers
                        reader_state <= display_byte;
                        byte      <= data_sr;
                        clocks_to_byte <= read_status_clocks; -- reset for next time
                    else
                        clocks_to_byte <= clocks_to_byte-1;
                    end if;
                when display_byte =>
                    tx_send <= '1';
                    flash_cs   <= '1';
                    tx_in <= byte;
                    reader_state <= enable_cs;
                    cmd_sr <= read_status_cmd & x"00"; -- reload shift register

            end case;
        end if;
    end process;


end Behavioral;

