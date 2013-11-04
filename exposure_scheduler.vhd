--Scheduler in order to change exposure
--for each next image in round robin wise

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity exposure_scheduler is
	generic(
		c_increment          : natural := 1;
		c_image_count        : natural := 2;
		c_pixel_width        : integer := 12;
		c_exposures_count    : integer := 5;
		c_exposure_bit_width : integer := 16
	);
	port(
		clk_i      : in  std_logic;
		rst_n      : in  std_logic;
		fval_i     : in  std_logic;
		enable_i   : in  std_logic;
--		button_i   : in  std_logic;
--		dipsw_i    : in  std_logic_vector(7 downto 0);
--		sldsw_i    : in  std_logic_vector(3 downto 0);
		exposure_o : out std_logic_vector(c_exposure_bit_width - 1 downto 0)
	);
end entity;

architecture Behavioral of exposure_scheduler is
	-- default -- exposure start value
	constant c_def_exp         : std_logic_vector(c_exposure_bit_width - 1 downto 0) := x"0250";
	-- offset between exposure values (bright,  middle, dark, etc.)
	constant c_offset          : natural                                             := 10;
	--signal   offset            : std_logic_vector(c_exposure_bit_width-1 downto 0) := x"000A";
	-- change value of exposures
	constant c_exposure_change : std_logic_vector(c_exposure_bit_width - 1 downto 0) := x"0020";

	signal exposure_state      : std_logic_vector(c_image_count - 1 downto 0) := (others => '0');
	signal exposure_state_next : std_logic_vector(c_image_count - 1 downto 0) := (others => '0');
	type exposures_type is array (0 to c_exposures_count - 1) of std_logic_vector(c_exposure_bit_width - 1 downto 0);
	constant c_exposures : exposures_type := (c_def_exp,
		                                      std_logic_vector(unsigned(c_def_exp) + to_unsigned(c_offset, c_exposure_bit_width - 1)),
		                                      std_logic_vector(unsigned(c_def_exp) + to_unsigned(c_offset * 2, c_exposure_bit_width - 1)),
		                                      std_logic_vector(unsigned(c_def_exp) + to_unsigned(c_offset * 3, c_exposure_bit_width - 1)),
		                                      std_logic_vector(unsigned(c_def_exp) + to_unsigned(c_offset * 4, c_exposure_bit_width - 1))
	);
	signal exposures : exposures_type := c_exposures;
begin
	exposure_o <= exposures(to_integer(unsigned(exposure_state)))(c_exposure_bit_width - 1 downto 0);

	-- purpose: define dip switch as one exposure value depend on slide switch state
	-- type   : sequential
	-- inputs : clk_i, rst_n, sldsw_i, dipsw_i
	-- outputs: exposures
--	def_exp_proc : process(clk_i, rst_n)
--	begin                               -- process def_exp_proc
--		if rst_n = '0' then             -- asynchronous reset (active low)
--			exposures <= c_exposures;
--		elsif clk_i'event and clk_i = '1' then -- rising clock edge
--			if button_i = '1' then
--				case sldsw_i is
--					when "0001" => exposures(0)(7 downto 0) <= dipsw_i(7 downto 0);
--					when "0010" => exposures(1)(7 downto 0) <= dipsw_i(7 downto 0);
--					when "0011" => exposures(2)(7 downto 0) <= dipsw_i(7 downto 0);
--					when "0100" => exposures(3)(7 downto 0) <= dipsw_i(7 downto 0);
--					when "0101" => exposures(4)(7 downto 0) <= dipsw_i(7 downto 0);
--					when "1001" => exposures(0)(15 downto 8) <= dipsw_i(7 downto 0);
--					when "1010" => exposures(1)(15 downto 8) <= dipsw_i(7 downto 0);
--					when "1011" => exposures(2)(15 downto 8) <= dipsw_i(7 downto 0);
--					when "1100" => exposures(3)(15 downto 8) <= dipsw_i(7 downto 0);
--					when "1101" => exposures(4)(15 downto 8) <= dipsw_i(7 downto 0);
--					when others => null;
--				end case;
--			end if;
--		end if;
--	end process def_exp_proc;

	-- purpose: state machine to change exposure for curren camera image
	-- type   : sequential
	-- inputs : clk_i, rst_n, exposure_state
	-- outputs: exposure_state, exposure_o
	exposure_st_machine_proc : process(clk_i, rst_n)
	begin                               -- process exposure_st_machine_proc
		if rst_n = '0' then             -- asynchronous reset (active low)
			exposure_state      <= (others => '0');
			exposure_state_next <= (others => '0');
		elsif clk_i'event and clk_i = '1' then -- rising clock edge
			if enable_i = '1' then
				if fval_i = '1' then
					if unsigned(exposure_state) < c_image_count then
						exposure_state_next <= std_logic_vector(unsigned(exposure_state) + c_increment);
					else
						exposure_state      <= (others => '0');
						exposure_state_next <= std_logic_vector(unsigned(exposure_state) + c_increment);
					end if;
				else
					exposure_state <= exposure_state_next;
				end if;
			else
				exposure_state <= (others => '0');
			end if;
		end if;
	end process exposure_st_machine_proc;

end architecture;
