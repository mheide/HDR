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
	
	counter : process (clk_i, rst_n_i) is
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
					ack1 <= '0';
					ack2 <= '0';
					ack3 <= '0';
					ack4 <= '0';
					end_flag <= '0';
					sdo <= '1';
					sclk <= '1';
				when 1 =>
					sd <= i2c_data_i;
					sdo <= '0';
				when 2 => sclk <= '0';
				when 3 => sdo <= sd(31);
				when 4 => sdo <= sd(30);
				when 5 => sdo <= sd(29);
				when others => null;
			end case;

		end if;
	end process main_prc;

end architecture Behavioral;
