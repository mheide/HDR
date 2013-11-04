library ieee;
use ieee.std_logic_1164.all;

entity i2c_ccd_exp_control is
	generic(
		c_increment          : natural := 1;
		c_image_count        : natural := 2;
		c_pixel_width        : integer := 12;
		c_exposures_count    : integer := 5;
		c_exposure_bit_width : integer := 16;
		c_i2c_reglen         : integer := 24);
	port(
		clk_i      : in    std_logic;
		rst_n_i    : in    std_logic;
		fval_i     : in    std_logic;   -- frame valid
		hex4_o     : out   std_logic_vector(6 downto 0);
		hex5_o     : out   std_logic_vector(6 downto 0);
		hex6_o     : out   std_logic_vector(6 downto 0);
		hex7_o     : out   std_logic_vector(6 downto 0);
		i2c_sclk_o : out   std_logic;
		i2c_sdat   : inout std_logic
	);
end entity i2c_ccd_exp_control;

architecture RTL of i2c_ccd_exp_control is
	component emul_i2c_controller
		generic(max_clocks : natural := 10;
			    end_clocks : natural := 5;
			    ack_clocks : natural := 3);
		port(CLOCK    : in    std_logic;
			 I2C_SCLK : out   std_logic;
			 I2C_SDAT : inout std_logic;
			 I2C_DATA : in    std_logic_vector(31 downto 0);
			 GO       : in    std_logic;
			 TEND     : out   std_logic;
			 ACK      : out   std_logic;
			 RESET    : in    std_logic);
	end component emul_i2c_controller;

	component exposure_scheduler
		generic(c_increment          : natural := 1;
			    c_image_count        : natural := 2;
			    c_pixel_width        : integer := 12;
			    c_exposures_count    : integer := 5;
			    c_exposure_bit_width : integer := 16);
		port(clk_i      : in  std_logic;
			 rst_n      : in  std_logic;
			 fval_i     : in  std_logic;
			 enable_i   : in  std_logic;
			 exposure_o : out std_logic_vector(c_exposure_bit_width - 1 downto 0));
	end component exposure_scheduler;

	signal enable                   : std_logic                                           := '0'; -- enable exposures scheduler
	signal exposure                 : std_logic_vector(c_exposure_bit_width - 1 downto 0) := (others => '0');
	signal m_i2c_clk_div            : natural                                             := 0;
	signal m_i2c_data               : std_logic_vector(31 downto 0)                       := (others => '0');
	signal m_i2c_ctrl_clk           : std_logic                                           := '0';
	signal m_i2c_go                 : std_logic                                           := '0';
	signal m_i2c_end                : std_logic                                           := '0';
	signal m_i2c_ack                : std_logic                                           := '0';
	signal lut_data                 : std_logic_vector(23 downto 0)                       := (others => '0');
	signal lut_index                : natural range 0 to 25                               := 0;
	signal i2c_reset                : std_logic                                           := '0';
	-- CCD parameter
	constant sensor_start_row       : std_logic_vector(c_i2c_reglen - 1 downto 0)         := x"010000";
	constant sensor_start_column    : std_logic_vector(c_i2c_reglen - 1 downto 0)         := x"020000";
	-- 640x480
	constant de2_sensor_row_size    : std_logic_vector(c_i2c_reglen - 1 downto 0)         := x"03077F";
	constant de2_sensor_column_size : std_logic_vector(c_i2c_reglen - 1 downto 0)         := x"0409FF";
	-- 1280x1024
	constant de4_sensor_row_size    : std_logic_vector(c_i2c_reglen - 1 downto 0)         := x"0307FF";
	constant de4_sensor_column_size : std_logic_vector(c_i2c_reglen - 1 downto 0)         := x"0409FF";

	constant sensor_row_mode    : std_logic_vector(c_i2c_reglen - 1 downto 0) := x"220011";
	constant sensor_column_mode : std_logic_vector(c_i2c_reglen - 1 downto 0) := x"230011";

	signal rstart_stimulus : natural range 0 to 25000 := 0; --counter
	type exposure_state_t is (init_delay, -- init lut_data_configuration
		delay,                          -- delay between frame valid
		change,                         -- change exposure on active frame valid
		restart                         -- restart ccd exposure register
);

	signal exposure_state, exposure_state_next : exposure_state_t := init_delay;

	type i2c_setup_t is (init, send, complete);
	signal m_setup_st : i2c_setup_t := init;
	--------------------------------------------------------------------------------
	---------------------S I M U L A T I O N----------------------------------------
	--constant c_rstart_threshold : natural := 15;
	--constant lut_size           : natural := 5;
	--constant i2c_freq           : natural := 10000000;  -- 10 MHz
	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	--------------------R E A L  H A R D W A R E------------------------------------
	constant c_rstart_threshold : natural := 22000; -- clocks count to restart ccd at 50 MHz pclk
	constant lut_size           : natural := 25;
	constant i2c_freq           : natural := 400000; -- 400 kHz i2c clock
	constant clk_freq           : natural := 50000000; -- 50 MHz system clock
	constant clk_freq_bracket   : natural := clk_freq / i2c_freq;
	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	--------------------PLL - C O N F I G - DE 4 BOARD------------------------------
	-- 75 MHz pixel clock
	constant c_de4_pll_m_factor  : std_logic_vector(c_i2c_reglen - 1 downto 0) := x"111803";
	constant c_de4_pll_p_dividor : std_logic_vector(c_i2c_reglen - 1 downto 0) := x"120001";
	--------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	--------------------PLL - C O N F I G - DE 2 BOARD------------------------------
	-- 75 MHz pixel clock
	constant c_de2_pll_m_factor  : std_logic_vector(c_i2c_reglen - 1 downto 0) := x"113C05";
	constant c_de2_pll_p_dividor : std_logic_vector(c_i2c_reglen - 1 downto 0) := x"120001";
--------------------------------------------------------------------------------

begin
	enable    <= '0' when exposure_state = init_delay else '1';
	i2c_reset <= rst_n_i;

	i2c_clk_ctrl : process(clk_i, rst_n_i) is
	begin
		if rst_n_i = '0' then           --asynchronous reset (active low)
			m_i2c_ctrl_clk <= '0';
			m_i2c_clk_div  <= 0;
		elsif rising_edge(clk_i) then
			if m_i2c_clk_div < clk_freq_bracket then
				m_i2c_clk_div <= m_i2c_clk_div + 1;
			else
				m_i2c_clk_div  <= 0;
				m_i2c_ctrl_clk <= not m_i2c_ctrl_clk;
			end if;
		end if;
	end process i2c_clk_ctrl;

	i2c_control : emul_i2c_controller port map(
			CLOCK    => m_i2c_ctrl_clk,
			I2C_SCLK => i2c_sclk_o,
			I2C_SDAT => i2c_sdat,
			I2C_DATA => m_i2c_data,
			GO       => m_i2c_go,
			TEND     => m_i2c_end,
			ACK      => m_i2c_ack,
			RESET    => i2c_reset
		);

	exposure_sched : component exposure_scheduler
		generic map(c_increment          => c_increment,
			        c_image_count        => c_image_count,
			        c_pixel_width        => c_pixel_width,
			        c_exposures_count    => c_exposures_count,
			        c_exposure_bit_width => c_exposure_bit_width)
		port map(clk_i      => m_i2c_ctrl_clk,
			     rst_n      => rst_n_i,
			     fval_i     => fval_i,
			     enable_i   => enable,
			     exposure_o => exposure);

	conf_ctrl_proc : process(m_i2c_ctrl_clk, rst_n_i) is
	begin
		if i2c_reset = '0' then         -- asynchronous reset (active low)
			lut_index      <= 0;
			m_setup_st     <= init;
			m_i2c_go       <= '0';
			exposure_state <= init_delay;
		elsif m_i2c_ctrl_clk'event and m_i2c_ctrl_clk = '1' then -- rising clock edge
			case m_setup_st is
				when init =>
					if lut_index < lut_size then
						exposure_state <= init_delay;
						m_i2c_data     <= x"BA" & lut_data;
						m_i2c_go       <= '1';
						m_setup_st     <= send;
					elsif exposure_state = delay then
						exposure_state <= exposure_state_next;
					elsif exposure_state = change then
						m_i2c_data <= x"BA09" & exposure;
						m_i2c_go   <= '1';
						m_setup_st <= send;
					elsif exposure_state = restart then
						m_i2c_data <= x"BA0B0001";
						m_i2c_go   <= '1';
						m_setup_st <= send;
					else
						exposure_state <= delay;
					end if;
				when send =>
					if m_i2c_end = '1' then
						if m_i2c_ack = '0' then
							m_setup_st <= complete;
						else
							m_setup_st <= init;
						end if;
						m_i2c_go <= '0';
					else
						m_setup_st <= send;
					end if;
				when complete =>
					if lut_index < lut_size then
						lut_index  <= lut_index + 1;
						m_setup_st <= init;
					elsif exposure_state_next = change then
						m_setup_st <= complete;
					else
						m_setup_st     <= init;
						exposure_state <= delay;
					end if;
			end case;
		end if;
	end process conf_ctrl_proc;

	-- restart exposure with new value 20 clocks since falling edge of frame valid
	fst_state_next : process(m_i2c_ctrl_clk, rst_n_i) is
	begin
		if rst_n_i = '0' then           --asynchronous reset (active low)
			rstart_stimulus     <= 0;
			exposure_state_next <= delay;
		elsif rising_edge(m_i2c_ctrl_clk) then
			if fval_i = '1' then
				if exposure_state /= init_delay then
					if exposure_state_next = delay then
						exposure_state_next <= change;
					--elsif exposure_state_next = change then
					--  if rstart_stimulus < c_rstart_threshold then
					--    rstart_stimulus <= rstart_stimulus + 1;
					--  else
					--    exposure_state_next <= restart;
					--    rstart_stimulus     <= 0;
					--  end if;
					end if;
				end if;
			elsif exposure_state_next = change then
				exposure_state_next <= restart;
			elsif exposure_state_next = restart then
				if rstart_stimulus < 20 then
					rstart_stimulus <= rstart_stimulus + 1;
				else
					exposure_state_next <= delay;
					rstart_stimulus     <= 0;
				end if;
			else
				exposure_state_next <= delay;
			end if;
		end if;
	end process fst_state_next;

	conf_data_lut_proc : process(clk_i, rst_n_i) is
	begin
		if rst_n_i = '0' then           --active low
			lut_data <= (others => '0');
		elsif rising_edge(clk_i) then
			case lut_index is
				when 0      => lut_data <= (others => '0');
				when 1      => lut_data <= x"20C000"; --mirror row and columns
				when 2      => lut_data <= x"09" & exposure;
				when 3      => lut_data <= x"050000"; -- h-blanking
				when 4      => lut_data <= x"060019"; -- v-blanking
				when 5      => lut_data <= x"0A8000"; -- change latch
				when 6      => lut_data <= x"2B0013"; -- green 1 gain
				when 7      => lut_data <= x"2D019C"; -- blue gain
				when 8      => lut_data <= x"2D019C"; -- red gain
				when 9      => lut_data <= x"2E0013"; -- green 2 gain
				when 10     => lut_data <= x"100051"; -- set up power on
				when 11     => lut_data <= c_de4_pll_m_factor; -- pll m factor / n divider
				when 12     => lut_data <= c_de4_pll_p_dividor; -- pll p1 divider
				when 13     => lut_data <= x"100053"; -- set use pll
				when 14     => lut_data <= x"980000"; -- disable calibration
				when 15     => lut_data <= x"A00000"; -- test pattern control
				when 16     => lut_data <= x"A10000"; -- test green pattern value
				when 17     => lut_data <= x"A20FFF"; -- test red pattern value
				when 18     => lut_data <= sensor_start_row;
				when 19     => lut_data <= sensor_start_column;
				when 20     => lut_data <= de4_sensor_row_size;
				when 21     => lut_data <= de4_sensor_column_size;
				when 22     => lut_data <= sensor_row_mode; --bin mode
				when 23     => lut_data <= sensor_column_mode; --bin mode
				when 24     => lut_data <= x"4901A8"; -- row black target
				when others => lut_data <= (others => '0');
			end case;
		end if;
	end process conf_data_lut_proc;

	process(clk_i, rst_n_i)
	begin
		if rst_n_i = '0' then           --asynchronous (active low)
			hex4_o <= (others => '0');
		elsif clk_i'event and clk_i = '1' then
			case exposure(3 downto 0) is
				when x"0"   => hex4_o <= not b"0111111";
				when x"1"   => hex4_o <= not b"0000110";
				when x"2"   => hex4_o <= not b"1011011";
				when x"3"   => hex4_o <= not b"1001111";
				when x"4"   => hex4_o <= not b"1100110";
				when x"5"   => hex4_o <= not b"1101101";
				when x"6"   => hex4_o <= not b"1111101";
				when x"7"   => hex4_o <= not b"0000111";
				when x"8"   => hex4_o <= not b"1111111";
				when x"9"   => hex4_o <= not b"1100111";
				when x"A"   => hex4_o <= not b"1110111";
				when x"B"   => hex4_o <= not b"1111100";
				when x"C"   => hex4_o <= not b"0111001";
				when x"D"   => hex4_o <= not b"1011110";
				when x"E"   => hex4_o <= not b"1111001";
				when x"F"   => hex4_o <= not b"1110001";
				when others => hex4_o <= (others => '1');
			end case;
		end if;
	end process;

	process(clk_i, rst_n_i)
	begin                               -- process
		if rst_n_i = '0' then           --asynchronous reset (active low)
			hex5_o <= (others => '0');
		elsif clk_i'event and clk_i = '1' then
			case exposure(7 downto 4) is
				when x"0"   => hex5_o <= not b"0111111";
				when x"1"   => hex5_o <= not b"0000110";
				when x"2"   => hex5_o <= not b"1011011";
				when x"3"   => hex5_o <= not b"1001111";
				when x"4"   => hex5_o <= not b"1100110";
				when x"5"   => hex5_o <= not b"1101101";
				when x"6"   => hex5_o <= not b"1111101";
				when x"7"   => hex5_o <= not b"0000111";
				when x"8"   => hex5_o <= not b"1111111";
				when x"9"   => hex5_o <= not b"1100111";
				when x"A"   => hex5_o <= not b"1110111";
				when x"B"   => hex5_o <= not b"1111100";
				when x"C"   => hex5_o <= not b"0111001";
				when x"D"   => hex5_o <= not b"1011110";
				when x"E"   => hex5_o <= not b"1111001";
				when x"F"   => hex5_o <= not b"1110001";
				when others => hex5_o <= (others => '1');
			end case;
		end if;
	end process;

	process(clk_i, rst_n_i)
	begin                               -- process
		if rst_n_i = '0' then
			hex6_o <= (others => '1');
		elsif clk_i'event and clk_i = '1' then
			case exposure(11 downto 8) is
				when x"0"   => hex6_o <= not b"0111111";
				when x"1"   => hex6_o <= not b"0000110";
				when x"2"   => hex6_o <= not b"1011011";
				when x"3"   => hex6_o <= not b"1001111";
				when x"4"   => hex6_o <= not b"1100110";
				when x"5"   => hex6_o <= not b"1101101";
				when x"6"   => hex6_o <= not b"1111101";
				when x"7"   => hex6_o <= not b"0000111";
				when x"8"   => hex6_o <= not b"1111111";
				when x"9"   => hex6_o <= not b"1100111";
				when x"A"   => hex6_o <= not b"1110111";
				when x"B"   => hex6_o <= not b"1111100";
				when x"C"   => hex6_o <= not b"0111001";
				when x"D"   => hex6_o <= not b"1011110";
				when x"E"   => hex6_o <= not b"1111001";
				when x"F"   => hex6_o <= not b"1110001";
				when others => hex6_o <= (others => '1');
			end case;
		end if;
	end process;

	process(clk_i, rst_n_i)
	begin                               -- process
		if rst_n_i = '0' then
			hex7_o <= (others => '1');
		elsif clk_i'event and clk_i = '1' then
			case exposure(15 downto 12) is
				when x"0"   => hex7_o <= not b"0111111";
				when x"1"   => hex7_o <= not b"0000110";
				when x"2"   => hex7_o <= not b"1011011";
				when x"3"   => hex7_o <= not b"1001111";
				when x"4"   => hex7_o <= not b"1100110";
				when x"5"   => hex7_o <= not b"1101101";
				when x"6"   => hex7_o <= not b"1111101";
				when x"7"   => hex7_o <= not b"0000111";
				when x"8"   => hex7_o <= not b"1111111";
				when x"9"   => hex7_o <= not b"1100111";
				when x"A"   => hex7_o <= not b"1110111";
				when x"B"   => hex7_o <= not b"1111100";
				when x"C"   => hex7_o <= not b"0111001";
				when x"D"   => hex7_o <= not b"1011110";
				when x"E"   => hex7_o <= not b"1111001";
				when x"F"   => hex7_o <= not b"1110001";
				when others => hex7_o <= (others => '1');
			end case;
		end if;
	end process;

end architecture RTL;
