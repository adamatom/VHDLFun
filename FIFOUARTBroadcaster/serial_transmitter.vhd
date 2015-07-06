library ieee;
use ieee.std_logic_1164.all;

-- This entity broadcasts a byte onto the UART tx line. It uses the two process architecture.
-- When told to send a byte, it will do it, assert a "I did it" signal, and wait for RST to 
--  allow for the next byte.
entity serial_transmitter is
    port ( RST : in  std_logic;
           BAUDCLK : in  std_logic;                          -- Baud rate clock input
           DATA_START : in std_logic;
           DATA_BYTE : in  std_logic_vector (7 downto 0);    -- Byte to be sent
           DATA_SENT : out std_logic;                        -- Indicate that byte has been sent
           SERIAL_OUT : out  std_logic);
end serial_transmitter;

architecture RTL of serial_transmitter is
    type tx_state is (tx_idle, tx_start, bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7, tx_stop1, tx_stop2);
    signal current_state : tx_state := tx_idle;
    signal next_state: tx_state;
begin

    -- Next state process
    sequential : process (BAUDCLK, RST)
    begin
        if rst = '1' then
            current_state <= tx_idle;
        elsif rising_edge(BAUDCLK) then
            current_state <= next_state;
        end if;
    end process;

    combinatorial : process (current_state, DATA_START, DATA_BYTE) -- ISE says data_reg should be included in the sensitivity list. seems odd
    begin
        case current_state is
            when tx_idle =>
                SERIAL_OUT <= '1';
                DATA_SENT <= '0';
                next_state <= tx_idle;
                if DATA_START = '1' then
                    next_state <= tx_start;
                end if;

        -- Start bit
            when tx_start =>
                SERIAL_OUT <= '0';
                DATA_SENT <= '0';
                next_state <= bit0;

            when bit0 =>    -- Send the least significat bit
                SERIAL_OUT <= DATA_BYTE(0);
                DATA_SENT <= '0';
                next_state <= bit1;

            when bit1 =>
                SERIAL_OUT <= DATA_BYTE(1);
                DATA_SENT <= '0';
                next_state <= bit2;

            when bit2 =>
                SERIAL_OUT <= DATA_BYTE(2);
                DATA_SENT <= '0';
                next_state <= bit3;

            when bit3 =>
                SERIAL_OUT <= DATA_BYTE(3);
                DATA_SENT <= '0';
                next_state <= bit4;

            when bit4 =>
                SERIAL_OUT <= DATA_BYTE(4);
                DATA_SENT <= '0';
                next_state <= bit5;

            when bit5 =>
                SERIAL_OUT <= DATA_BYTE(5);
                DATA_SENT <= '0';
                next_state <= bit6;

            when bit6 =>
                SERIAL_OUT <= DATA_BYTE(6);
                DATA_SENT <= '0';
                next_state <= bit7;

            when bit7 =>    -- Send the most significat bit
                SERIAL_OUT <= DATA_BYTE(7);
                DATA_SENT <= '0';
                next_state <= tx_stop1;


            when tx_stop1 =>
                SERIAL_OUT <= '1';
                DATA_SENT <= '0';
                next_state <= tx_stop2;

            when tx_stop2 =>    -- Stop here and wait for other reset
                SERIAL_OUT <= '1';
                DATA_SENT <= '1';
                next_state <= tx_stop2;

        end case;
    end process;

end RTL;

