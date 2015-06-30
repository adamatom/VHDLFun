
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_SPIRelay IS
END TB_SPIRelay;
 
ARCHITECTURE behavior OF TB_SPIRelay IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SPIRelay
    PORT(
         OPTICS_SCLKp : IN  std_logic;
         OPTICS_SCLKn : IN  std_logic;
         OPTICS_MISOp : OUT  std_logic;
         OPTICS_MISOn : OUT  std_logic;
         OPTICS_MOSIp : IN  std_logic;
         OPTICS_MOSIn : IN  std_logic;
         OPTICS_CS : IN  std_logic;
         SPI1_SCLK : OUT  std_logic;
         SPI1_MISO : IN  std_logic;
         SPI1_MOSI : OUT  std_logic;
         SPI1_CS : OUT  std_logic;
         SPI2_SCLK : OUT  std_logic;
         SPI2_MISO : IN  std_logic;
         SPI2_MOSI : OUT  std_logic;
         SPI2_CS : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal OPTICS_SCLKp : std_logic := '0';
   signal OPTICS_SCLKn : std_logic := '0';
   signal OPTICS_MOSIp : std_logic := '0';
   signal OPTICS_MOSIn : std_logic := '0';
   signal OPTICS_CS : std_logic := '1';
   signal SPI1_MISO : std_logic := '0';
   signal SPI2_MISO : std_logic := '0';

 	--Outputs
   signal OPTICS_MISOp : std_logic;
   signal OPTICS_MISOn : std_logic;
   signal SPI1_SCLK : std_logic;
   signal SPI1_MOSI : std_logic;
   signal SPI1_CS : std_logic;
   signal SPI2_SCLK : std_logic;
   signal SPI2_MOSI : std_logic;
   signal SPI2_CS : std_logic;

   -- Clock period definitions
   constant OPTICS_SCLK_period : time := 62.5 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SPIRelay PORT MAP (
          OPTICS_SCLKp => OPTICS_SCLKp,
          OPTICS_SCLKn => OPTICS_SCLKn,
          OPTICS_MISOp => OPTICS_MISOp,
          OPTICS_MISOn => OPTICS_MISOn,
          OPTICS_MOSIp => OPTICS_MOSIp,
          OPTICS_MOSIn => OPTICS_MOSIn,
          OPTICS_CS => OPTICS_CS,
          SPI1_SCLK => SPI1_SCLK,
          SPI1_MISO => SPI1_MISO,
          SPI1_MOSI => SPI1_MOSI,
          SPI1_CS => SPI1_CS,
          SPI2_SCLK => SPI2_SCLK,
          SPI2_MISO => SPI2_MISO,
          SPI2_MOSI => SPI2_MOSI,
          SPI2_CS => SPI2_CS
        );

   -- Clock process definitions
   OPTICS_SCLK_process :process
   begin
		OPTICS_SCLKp <= '1';
        OPTICS_SCLKn <= '0';
		wait for OPTICS_SCLK_period/2;
		OPTICS_SCLKp <= '0';
        OPTICS_SCLKn <= '1';
		wait for OPTICS_SCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		

      wait for OPTICS_SCLK_period*10;
      
      wait for OPTICS_SCLK_period/2;  -- on clock falling edge, assert chip select
      OPTICS_CS <= '0';
      
      OPTICS_MOSIp <= '1';  -- and master writes a 1
      OPTICS_MOSIn <= '0';
      
      wait for OPTICS_SCLK_period/2; -- on rising edge, slave writes back a 1
      SPI2_MISO <= '1';
      
      wait for OPTICS_SCLK_period/2;  -- master done with bit
      OPTICS_MOSIp <= '0';  -- and master writes a 1
      OPTICS_MOSIn <= '1';
      
      wait for OPTICS_SCLK_period/2;  -- slave done with bit
      SPI2_MISO <= '0';
      

      wait;
   end process;

END;
