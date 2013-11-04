library ieee;
use ieee.std_logic_1164.all;

entity i2c_controller is
	port(
		clk_i       : in    std_logic;
		rst_n_i     : in    std_logic;
		go_i        : in    std_logic;
		i2c_data_i  : in    std_logic_vector(31 downto 0);
		i2c_sclk_o  : out   std_logic;
		i2c_sdat_io : inout std_logic;
		ack_o       : out   std_logic;
		end_o       : out   std_logic
	);
end entity i2c_controller;

architecture Behavioral of i2c_controller is
	signal sdo                         : std_logic                     := '0';
	signal sclk                        : std_logic                     := '0';
	signal end_flag                    : std_logic                     := '0';
	signal sd                          : std_logic_vector(31 downto 0) := (others => '0');
	signal sd_counter                  : natural range 0 to 41         := 0;
	signal ack, ack1, ack2, ack3, ack4 : std_logic                     := '0';

begin
	ack <= '1' when ack1 = '1' or ack2 = '1' or ack3 = '1' or ack4 = '1' else '0';

	sclk_prc : process is
	begin
		if sclk = '1' then
			i2c_sclk_o <= '1';
		elsif sd_counter > 3 and sd_counter < 40 then
			i2c_sclk_o <= not clk_i;
		else
			i2c_sclk_o <= '0';
		end if;
	end process sclk_prc;

	counter : process(clk_i, rst_n_i) is
	begin
		if rst_n_i = '0' then
			sd_counter <= 41;
		elsif rising_edge(clk_i) then
			if go_i = '0' then
				sd_counter <= 0;
			elsif sd_counter < 41 then
				sd_counter <= sd_counter + 1;
			end if;
		end if;
	end process counter;

	main_prc : process(clk_i, rst_n_i) is
	begin
		if rst_n_i = '0' then
			sclk     <= '1';
			sdo      <= '1';
			end_flag <= '1';
			ack1     <= '0';
			ack2     <= '0';
			ack3     <= '0';
			ack4     <= '0';
		elsif rising_edge(clk_i) then
			case sd_counter is
				when 0 =>
					ack1     <= '0';
					ack2     <= '0';
					ack3     <= '0';
					ack4     <= '0';
					end_flag <= '0';
					sdo      <= '1';
					sclk     <= '1';
				when 1 =>
					sd          <= i2c_data_i;
					sdo         <= '0';
				when 2 => sclk  <= '0';
				when 3 => sdo   <= sd(31);
				when 4 => sdo   <= sd(30);
				when 5 => sdo   <= sd(29);
				when 6 => sdo   <= sd(28);
				when 7 => sdo   <= sd(27);
				when 8 => sdo   <= sd(26);
				when 9 => sdo   <= sd(25);
				when 10 => sdo  <= sd(24);
				when 11 => sdo  <= '1'; --ack
				when 12 => sdo  <= sd(23);
					ack1        <= i2c_sdat_io;
				when 13 => sdo  <= sd(22);
				when 14 => sdo  <= sd(21);
				when 15 => sdo  <= sd(20);
				when 16 => sdo  <= sd(19);
				when 17 => sdo  <= sd(18);
				when 18 => sdo  <= sd(17);
				when 19 => sdo  <= sd(16);
				when 20 => sdo  <= '1'; --ack
				when 21 => sdo  <= sd(15);
					ack2        <= i2c_sdat_io;
				when 22 => sdo  <= sd(14);
				when 23 => sdo  <= sd(13);
				when 24 => sdo  <= sd(12);
				when 25 => sdo  <= sd(11);
				when 26 => sdo  <= sd(10);
				when 27 => sdo  <= sd(9);
				when 28 => sdo  <= sd(8);
				when 29 => sdo  <= '1'; --ack
				when 30 => sdo  <= sd(7);
				when 31 => sdo  <= sd(6);
				when 32 => sdo  <= sd(5);
				when 33 => sdo  <= sd(4);
				when 34 => sdo  <= sd(3);
				when 35 => sdo  <= sd(2);
				when 36 => sdo  <= sd(1);
				when 37 => sdo  <= sd(0);
				when 38 => sdo  <= '1'; --ack
				when 39 => sdo  <= '0';
					sclk        <= '0';
					ack4        <= i2c_sdat_io;
				when 40 => sclk <= '1';
				when 41 => sdo  <= '1';
					end_flag    <= '1';
				when others => null;
			end case;

		end if;
	end process main_prc;

end architecture Behavioral;
