library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity top_level is
    port(
            TX: out  std_logic;
            CLK: in std_logic
        );
end top_level;

architecture Structural of top_level is

    component baud_clock
        port (
                 CLK32_IN           : in     std_logic;
                 CLK2_OUT          : out    std_logic;
                 CLK32_OUT          : out std_logic;
                 RST             : in     std_logic
             );
    end component;

    component data_generator is
        port(
                CLK         : in std_logic;
                RST         : in std_logic;

                DATA        : out std_logic_vector(7 downto 0);
                DATA_VALID  : out std_logic -- The data byte should be read now. Will be deassert on next clock.
            );
    end component;

    component FIFO
        port (
                 clk : IN STD_LOGIC;
                 srst : IN STD_LOGIC;

                 din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
                 wr_en : IN STD_LOGIC;
                 full : OUT STD_LOGIC;

                 rd_en : IN STD_LOGIC;
                 dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
                 empty : OUT STD_LOGIC
             );
    end component;

    component byte_transmitter is
        port(
                CLK                 : in std_logic;
                RST                 : in std_logic;

                DISPLAY_BYTE        : in std_logic_vector(7 downto 0);
                DISPLAY_BYTE_VALID  : in std_logic;
                IDLE                : out std_logic;

                TX_DATA_VALID       : out std_logic;
                TX_DATA             : out std_logic_vector(7 downto 0);
                TX_DATA_SENT        : in std_logic
            );
    end component;

    component serial_transmitter is
        port (
                RST : in  std_logic;
                BAUDCLK : in  std_logic;                          -- Baud rate clock input
                DATA_START : in std_logic;
                DATA_BYTE : in  std_logic_vector (7 downto 0);    -- Byte to be sent
                DATA_SENT : out std_logic;                        -- Indicate that byte has been sent

                SERIAL_OUT : out  std_logic
            );
    end component;

    signal clk32 : std_logic;
    signal clk2 : std_logic;
    signal gen_data : std_logic_vector(7 downto 0);
    signal gen_valid : std_logic;
    signal fifo_empty : std_logic;
    signal fifo_not_empty : std_logic;
    signal fifo_data : std_logic_vector(7 downto 0);
    signal byte_transmitter_idle : std_logic;
    signal byte_transmitter_not_idle : std_logic;
    signal byte_transmitter_valid : std_logic;
    signal byte_transmitter_data : std_logic_vector(7 downto 0);
    signal serial_transmitter_sent : std_logic;

begin

    -- invert a couple of signals
    byte_transmitter_not_idle <= not byte_transmitter_idle;
    fifo_not_empty <= not fifo_empty;

    baud_instance : baud_clock
    port map (
                 CLK32_IN => CLK,
                 CLK2_OUT => clk2,
                 CLK32_OUT => clk32,
                 RST  => '0'
             );

    generator_instance : data_generator
    port map (
                CLK => clk32,
                RST => '0',
                DATA => gen_data,
                DATA_VALID => gen_valid
            );

    -- todo: setup BUFG for clock fanout
    -- pump TX into obuf
    fifo_instance : FIFO
    port map (
                 clk => clk32,
                 srst => '0',
                 din => gen_data,
                 wr_en => gen_valid,
                 rd_en => byte_transmitter_not_idle,
                 dout => fifo_data,
                 full => open,  -- dont care if we lose some bytes.
                 empty => fifo_empty
             );

    byte_transmitter_instance : byte_transmitter
    port map (
                CLK => clk32,
                RST => '0',
                DISPLAY_BYTE => fifo_data,
                DISPLAY_BYTE_VALID => fifo_not_empty,
                IDLE => byte_transmitter_idle,

                TX_DATA_VALID => byte_transmitter_valid,
                TX_DATA => byte_transmitter_data,
                TX_DATA_SENT => serial_transmitter_sent
             );

    serial_transmitter_instance : serial_transmitter
    port map (
                BAUDCLK => clk2,
                RST => byte_transmitter_idle,
                DATA_START => byte_transmitter_valid,
                DATA_BYTE => byte_transmitter_data,
                DATA_SENT => serial_transmitter_sent,
                SERIAL_OUT => TX
             );

end Structural;

