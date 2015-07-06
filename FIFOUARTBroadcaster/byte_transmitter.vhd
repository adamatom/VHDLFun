library ieee;
use ieee.std_logic_1164.all;

-- this code uses Mike Treseler's single process concept: http://myplace.frontier.com/~miketreseler/uart.vhd
-- Not MT stated that he doesn't like combinatorial code... hence variables are used
entity byte_transmitter is
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
end byte_transmitter;

architecture Behavioral of byte_transmitter is
  -- nothing needed here with single process method
begin
  byte_transmitter : process(CLK, RST)
    type state is (idle, loading, reset_transmitter, next_bit); -- idle: wait for command. loading: load sender with byte. waiting: waiting for sender confirmation

    variable transmitter_state  : state;
    -- register the input byte when we notice DATA_EN is asserted and the state is idle.
    variable display_reg        : std_logic_vector(7 downto 0);
    -- register how many bytes we have sent so we can pretty print with newlines.
    variable count_char         : integer range 0 to 9;

    -- register outputs
    variable idle_reg           : std_logic;
    variable tx_valid_reg       : std_logic;
    variable tx_data_reg        : std_logic_vector(7 downto 0);


    procedure idle_state is
    begin
      idle_reg := '1';
      count_char := 0;
      tx_valid_reg := '0';
      if DISPLAY_BYTE_VALID = '1' then
        idle_reg := '0';
        transmitter_state := loading;
        display_reg := DISPLAY_BYTE;
      end if;
    end procedure;

    procedure loading_state is
    begin
        tx_valid_reg := '1';
        case count_char is
          when 9 => tx_data_reg := x"0A";
          when 8 => tx_data_reg := x"0D";
          when others => 
            if display_reg(7 - count_char) = '0' then -- send bits of byte
              tx_data_reg := X"30";
            else
              tx_data_reg := X"31";
            end if;
        end case;
        if TX_DATA_SENT = '1' then
          transmitter_state := reset_transmitter;
        end if;
    end procedure;

    procedure reset_transmitter_state is
    begin
      tx_valid_reg := '0'; -- clock out the reset
      transmitter_state := next_bit;
    end procedure;

    procedure next_bit_state is
    begin
      if count_char = 9 then -- done sending eight bits and new line, go back to waiting for a command
        transmitter_state := idle;
      else -- if count_char < 9 then
        count_char := count_char + 1;
        transmitter_state := loading;
      end if;
    end procedure;

    procedure init_regs is       -- init of register variables only
    begin
      transmitter_state := idle;
      display_reg := x"00";
      count_char := 0;
      idle_reg := '0';
      tx_valid_reg := '0';
      tx_data_reg := x"00";
    end procedure init_regs;

    procedure update_ports is
    begin -- purpose: synthesize a wire from the register to the port
      IDLE <= idle_reg;
      TX_DATA_VALID <= tx_valid_reg;
      TX_DATA <= tx_data_reg;
    end procedure update_ports;

    procedure update_regs is
    begin  -- purpose: call the procedures above in the desired order
      case transmitter_state is
        when idle =>                idle_state;
        when loading =>             loading_state;
        when reset_transmitter =>   reset_transmitter_state;
        when next_bit =>            next_bit_state;
      end case;
    end procedure update_regs;

  begin -- this is Mike Treseler's default template.
    if RST = '1' then
      init_regs;
    elsif rising_edge(CLK) then
      update_regs;
    end if;
    update_ports;
  end process;

end Behavioral;

