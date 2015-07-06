library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_generator is
    port(
            CLK         : in std_logic;
            RST         : in std_logic;

            DATA        : out std_logic_vector(7 downto 0);
            DATA_VALID  : out std_logic -- The data byte should be read now. Will be deassert on next clock.
        );
end data_generator;

architecture RTL of data_generator is
begin
    data_generator : process(CLK, RST)

        variable count : integer;
        variable data_reg : std_logic_vector(7 downto 0);
        variable data_valid_reg : std_logic;

        procedure init_regs is       -- init of register variables only
        begin
            count := 0;
            data_reg := x"00";
            data_valid_reg := '0';
        end procedure init_regs;

        procedure update_ports is
        begin -- purpose: synthesize a wire from the register to the port
            DATA <= data_reg;
            DATA_VALID <= data_valid_reg;
        end procedure update_ports;

        procedure update_regs is
        begin  -- purpose: call the procedures above in the desired order
            count := count + 1; -- clk is 32MHz. We want an update at 4Hz.
            if count = 8_000_000 then  -- 32MHz/4Hz = 8000000
                data_reg := std_logic_vector( unsigned(data_reg) + 1);
                data_valid_reg := '1';
            else
                data_valid_reg := '0';
            end if;
        end procedure update_regs;

    begin -- this is Mike Treseler's default template.
        if RST = '1' then
            init_regs;
        elsif rising_edge(CLK) then
            update_regs;
        end if;
        update_ports;
    end process;
end RTL;
