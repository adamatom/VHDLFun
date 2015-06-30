
-- VHDL Instantiation Created from source file Switches_LEDs.vhd -- 20:44:12 06/29/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT Switches_LEDs
	PORT(
		switches : IN std_logic_vector(7 downto 0);
		clk : IN std_logic;          
		LEDs : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_Switches_LEDs: Switches_LEDs PORT MAP(
		switches => ,
		LEDs => ,
		clk => 
	);


