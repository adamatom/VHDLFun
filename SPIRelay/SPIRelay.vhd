library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
    use UNISIM.VComponents.all;

entity SPIRelay is
    Port ( OPTICS_SCLKp : in  STD_LOGIC;
           OPTICS_SCLKn : in  STD_LOGIC;
           OPTICS_MISOp : out  STD_LOGIC;
           OPTICS_MISOn : out  STD_LOGIC;
           OPTICS_MOSIp : in  STD_LOGIC;
           OPTICS_MOSIn : in  STD_LOGIC;
           OPTICS_CS : in  STD_LOGIC;
           SPI1_SCLK : out  STD_LOGIC;  -- copy 1 of SPI bus
           SPI1_MISO : in  STD_LOGIC;
           SPI1_MOSI : out  STD_LOGIC;
           SPI1_CS : out  STD_LOGIC;
           SPI2_SCLK : out  STD_LOGIC;  -- copy 2 of SPI bus
           SPI2_MISO : in  STD_LOGIC;
           SPI2_MOSI : out  STD_LOGIC;
           SPI2_CS : out  STD_LOGIC);
end SPIRelay;

architecture Behavioral of SPIRelay is
begin
    --clk_proc: process( OPTICS_SCLKp, OPTICS_SCLKn)
    --begin
    --    if rising_edge( OPTICS_SCLKp ) and falling_edge( OPTICS_SCLKn ) then    
    --    end if;
    --end process;
    SPI1_CS <= OPTICS_CS;
    SPI2_CS <= OPTICS_CS;
    SPI1_MOSI <= OPTICS_MOSIp and not OPTICS_MOSIn;
    SPI2_MOSI <= OPTICS_MOSIp and not OPTICS_MOSIn;
    OPTICS_MISOp <= SPI1_MISO or SPI2_MISO;  -- SPI1 and SPI2 collaborate to act as one SPI slave
    OPTICS_MISOn <= SPI1_MISO nor SPI2_MISO; 
    
    ODDR2_inst1 : ODDR2  -- generate SPI1_SCLK
    generic map(
        DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
        INIT => '0', -- Sets initial state of the Q output to '0' or '1'
        SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
    port map (
        Q => SPI1_SCLK, -- 1-bit output data
        C0 => OPTICS_SCLKp, -- 1-bit clock input
        C1 => OPTICS_SCLKn, -- 1-bit clock input
        CE => '1',  -- 1-bit clock enable input
        D0 => '1',   -- 1-bit data input (associated with C0)
        D1 => '0',   -- 1-bit data input (associated with C1)
        R => '0',    -- 1-bit reset input
        S => '0'     -- 1-bit set input
    );
    
    ODDR2_inst2 : ODDR2  -- generate SPI2_SCLK
    generic map(
        DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
        INIT => '0', -- Sets initial state of the Q output to '0' or '1'
        SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
    port map (
        Q => SPI2_SCLK, -- 1-bit output data
        C0 => OPTICS_SCLKp, -- 1-bit clock input
        C1 => OPTICS_SCLKn, -- 1-bit clock input
        CE => '1',  -- 1-bit clock enable input
        D0 => '1',   -- 1-bit data input (associated with C0)
        D1 => '0',   -- 1-bit data input (associated with C1)
        R => '0',    -- 1-bit reset input
        S => '0'     -- 1-bit set input
    );

end Behavioral;

