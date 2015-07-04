
library ieee;
use ieee.std_logic_1164.all;

use work.pkgDefinitions.all;

entity byte_bit_transmitter is
  port(
        TX : out  std_logic;
        DATA_EN: in std_logic;
        DATA_IN: in std_logic_vector(7 downto 0);
        DATA_SENT: out std_logic;
        CLK : in std_logic
      );
end byte_bit_transmitter;

architecture Behavioral of byte_bit_transmitter is

  component serial_transmitter is
    port ( rst : in  STD_LOGIC;                                     -- Reset input
           baudClk : in  STD_LOGIC;                                 -- Baud rate clock input
           data_byte : in  STD_LOGIC_VECTOR ((nBits-1) downto 0);   -- Byte to be sent
           data_sent : out STD_LOGIC;                               -- Indicate that byte has been sent
           serial_out : out  STD_LOGIC
         );
  end component;

  signal data_in_buf: std_logic_vector(7 downto 0) := (others => '0');
  signal char: std_logic_vector(7 downto 0) := (others => '0');
  signal tx_rst: std_logic := '1';
  signal sent: std_logic;

  signal count_char: integer range 0 to 9 := 0;

  type state is (idle, loading, waiting, reset_transmitter, next_bit); -- idle: wait for command. loading: load sender with byte. waiting: waiting for sender confirmation
  signal transmitter_state: state := idle;

  
begin

  serial_inst: serial_transmitter 
  port map(
            RST => tx_rst,
            BAUDCLK => CLK,
            DATA_BYTE => char,
            DATA_SENT => sent,
            SERIAL_OUT => TX
          );

  DATA_SENT <= sent;
  process(CLK, DATA_EN)
  begin
    if rising_edge(CLK) then
      case transmitter_state is
        when idle =>
          tx_rst <= '1';
          count_char <= 0;
          if DATA_EN = '1' then
            transmitter_state <= loading;
            data_in_buf <= DATA_IN;
          end if;
        when loading =>
          tx_rst <= '0';
          if count_char = 9 then -- eight bits sent, lets print a newline
            char <= X"0A";
          elsif count_char = 8 then
            char <= X"0D";
          else
            if data_in_buf(7 - count_char) = '0' then -- send bits of byte
              char <= X"30";
            else
              char <= X"31";
             end if;
          end if;
          transmitter_state <= waiting;
        when waiting =>
          tx_rst <= '0'; 
          if sent = '1' then
            transmitter_state <= reset_transmitter;
          end if;
        when reset_transmitter =>
          tx_rst <= '1'; -- clock out the reset
          transmitter_state <= next_bit;
        when next_bit =>
          tx_rst <= '1';
          if count_char = 9 and DATA_EN = '0' then -- done sending eight bits and new line, go back to waiting for a command
            transmitter_state <= idle;
          elsif count_char < 9 then
            count_char <= count_char + 1;
            transmitter_state <= loading;
          end if;
      end case;
    end if;
  end process;

end Behavioral;

