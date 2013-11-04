--I2C Controller emulator

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity emul_i2c_controller is
  
  generic (
    max_clocks : natural := 10;         -- clock since go up to end
    end_clocks : natural := 5;          -- end signal clocks duration counter
    ack_clocks : natural := 3);         -- ack signal clocks counter

  port (
    CLOCK    : in    std_logic;         -- i2c controller clock
    I2C_SCLK : out   std_logic;
    I2C_SDAT : inout std_logic;
    I2C_DATA : in    std_logic_vector(31 downto 0);
    GO       : in    std_logic;         -- go transfer
    TEND     : out   std_logic;         -- end transfer
    ACK      : out   std_logic;
    RESET    : in    std_logic);        -- asynchronous reset (active high)

end emul_i2c_controller;

architecture emulation of emul_i2c_controller is
  signal max_counter : natural := 0;
  signal end_counter : natural := 0;
  signal ack_counter : natural := 0;
  
begin  -- emulation
  I2C_SCLK <= CLOCK;
  I2C_SDAT <= '0';
  end_ack_proc : process (CLOCK, RESET)
  begin  -- process end_ack_proc
    if RESET = '0' then                     -- asynchronous reset (active low)
      TEND        <= '0';
      ACK         <= '0';
      max_counter <= 0;
      end_counter <= 0;
      ack_counter <= 0;
    elsif CLOCK'event and CLOCK = '1' then  -- rising clock edge
      if GO = '1' then
        if max_counter < max_clocks then
          max_counter <= max_counter + 1;
        elsif end_counter < end_clocks then
          TEND        <= '1';
          end_counter <= end_counter + 1;
          if ack_counter < ack_clocks then
            ACK         <= '0';
            ack_counter <= ack_counter + 1;
          end if;
        else
          TEND <= '0';
          ACK <= '1';
          max_counter <= 0;
          end_counter <= 0;
          ack_counter <= 0;
        end if;
      else
        TEND        <= '0';
        ACK         <= '0';
        max_counter <= 0;
        end_counter <= 0;
        ack_counter <= 0;
        
      end if;
    end if;
  end process end_ack_proc;

end architecture;
