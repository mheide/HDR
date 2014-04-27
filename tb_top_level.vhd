library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end entity tb_top_level;

architecture testbench of tb_top_level is
    component mt47h128m8
        PORT(
            ODT     : IN    std_ulogic := 'U';
            CK      : IN    std_ulogic := 'U';
            CKNeg   : IN    std_ulogic := 'U';
            CKE     : IN    std_ulogic := 'U';
            CSNeg   : IN    std_ulogic := 'U';
            RASNeg  : IN    std_ulogic := 'U';
            CASNeg  : IN    std_ulogic := 'U';
            WENeg   : IN    std_ulogic := 'U';
            BA0     : IN    std_ulogic := 'U';
            BA1     : IN    std_ulogic := 'U';
            BA2     : IN    std_ulogic := 'U';
            A0      : IN    std_ulogic := 'U';
            A1      : IN    std_ulogic := 'U';
            A2      : IN    std_ulogic := 'U';
            A3      : IN    std_ulogic := 'U';
            A4      : IN    std_ulogic := 'U';
            A5      : IN    std_ulogic := 'U';
            A6      : IN    std_ulogic := 'U';
            A7      : IN    std_ulogic := 'U';
            A8      : IN    std_ulogic := 'U';
            A9      : IN    std_ulogic := 'U';
            A10     : IN    std_ulogic := 'U';
            A11     : IN    std_ulogic := 'U';
            A12     : IN    std_ulogic := 'U';
            A13     : IN    std_ulogic := 'U';
            DQ0     : INOUT std_ulogic := 'U';
            DQ1     : INOUT std_ulogic := 'U';
            DQ2     : INOUT std_ulogic := 'U';
            DQ3     : INOUT std_ulogic := 'U';
            DQ4     : INOUT std_ulogic := 'U';
            DQ5     : INOUT std_ulogic := 'U';
            DQ6     : INOUT std_ulogic := 'U';
            DQ7     : INOUT std_ulogic := 'U';
            RDQS    : INOUT std_ulogic := 'U';
            RDQSNeg : OUT   std_ulogic := 'U';
            DQS     : INOUT std_ulogic := 'U';
            DQSNeg  : INOUT std_ulogic := 'U'
        );
    end component;

    component DE4_D5M_TLVL
        port(gclkin        : in    std_logic;
             GCLKOUT_FPGA  : out   std_logic;
             OSC_50_BANK2  : in    std_logic;
             OSC_50_BANK3  : in    std_logic;
             OSC_50_BANK4  : in    std_logic;
             OSC_50_BANK5  : in    std_logic;
             OSC_50_BANK6  : in    std_logic;
             OSC_50_BANK7  : in    std_logic;
             PLL_CLKIN_p   : in    std_logic;
             MAX_I2C_SCLK  : out   std_logic;
             MAX_I2C_SDAT  : inout std_logic;
             SMA_CLKIN_p   : in    std_logic;
             SMA_CLKOUT_p  : out   std_logic;
             LED           : out   std_logic_vector(7 downto 0);
             BUTTON        : in    std_logic_vector(3 downto 0);
             CPU_RESET_n   : in    std_logic;
             EXT_IO        : in    std_logic;
             SW            : in    std_logic_vector(7 downto 0);
             SLIDE_SW      : in    std_logic_vector(3 downto 0);
             SEG0_D        : out   std_logic_vector(6 downto 0);
             SEG0_DP       : out   std_logic;
             SEG1_D        : out   std_logic_vector(6 downto 0);
             SEG1_DP       : out   std_logic;
             TEMP_INT_n    : in    std_logic;
             TEMP_SMCLK    : out   std_logic;
             TEMP_SMDAT    : in    std_logic;
             CSENSE_ADC_FO : out   std_logic;
             CSENSE_CS_n   : out   std_logic_vector(1 downto 0);
             CSENSE_SCK    : out   std_logic;
             CSENSE_SDI    : out   std_logic;
             CSENSE_SDO    : in    std_logic;
             FAN_CTRL      : out   std_logic;
             EEP_SCL       : out   std_logic;
             EEP_SDA       : inout std_logic;
             SD_CLK        : out   std_logic;
             SD_CMD        : in    std_logic;
             SD_DAT        : in    std_logic_vector(3 downto 0);
             SD_WP_n       : in    std_logic;
             ETH_INT_n     : in    std_logic_vector(3 downto 0);
             ETH_MDC       : out   std_logic_vector(3 downto 0);
             ETH_MDIO      : inout std_logic_vector(3 downto 0);
             ETH_PSE_INT_n : in    std_logic;
             ETH_PSE_RST_n : out   std_logic;
             ETH_PSE_SCK   : out   std_logic;
             ETH_PSE_SDA   : inout std_logic;
             ETH_RST_n     : out   std_logic;
             ETH_RX_p      : in    std_logic_vector(3 downto 0);
             ETH_TX_p      : out   std_logic_vector(3 downto 0);
             FSM_A         : out   std_logic_vector(25 downto 1);
             FSM_D         : inout std_logic_vector(15 downto 0);
             FLASH_ADV_n   : out   std_logic;
             FLASH_CE_n    : out   std_logic;
             FLASH_CLK     : out   std_logic;
             FLASH_OE_n    : out   std_logic;
             FLASH_RESET_n : out   std_logic;
             FLASH_RYBY_n  : in    std_logic;
             FLASH_WE_n    : out   std_logic;
             SSRAM_ADV     : out   std_logic;
             SSRAM_BWA_n   : out   std_logic;
             SSRAM_BWB_n   : out   std_logic;
             SSRAM_CE_n    : out   std_logic;
             SSRAM_CKE_n   : out   std_logic;
             SSRAM_CLK     : out   std_logic;
             SSRAM_OE_n    : out   std_logic;
             SSRAM_WE_n    : out   std_logic;
             OTG_A         : out   std_logic_vector(17 downto 1);
             OTG_CS_n      : out   std_logic;
             OTG_D         : inout std_logic_vector(31 downto 0);
             OTG_DC_DACK   : out   std_logic;
             OTG_DC_DREQ   : in    std_logic;
             OTG_DC_IRQ    : in    std_logic;
             OTG_HC_DACK   : out   std_logic;
             OTG_HC_DREQ   : in    std_logic;
             OTG_HC_IRQ    : in    std_logic;
             OTG_OE_n      : out   std_logic;
             OTG_RESET_n   : out   std_logic;
             OTG_WE_n      : out   std_logic;
             m1_ddr2_addr     : out   std_logic_vector(13 downto 0);
             m1_ddr2_ba       : out   std_logic_vector(2 downto 0);
             m1_ddr2_cas_n    : out   std_logic_vector(0 downto 0);
             m1_ddr2_cke      : out   std_logic_vector(0 downto 0);
             m1_ddr2_clk      : inout std_logic_vector(1 downto 0);
             m1_ddr2_clk_n    : inout std_logic_vector(1 downto 0);
             m1_ddr2_cs_n     : out   std_logic_vector(0 downto 0);
             m1_ddr2_dm       : out   std_logic_vector(7 downto 0);
             m1_ddr2_dq       : inout std_logic_vector(63 downto 0);
             m1_ddr2_dqs      : inout std_logic_vector(7 downto 0);
             m1_ddr2_dqsn     : inout std_logic_vector(7 downto 0);
             m1_ddr2_odt      : out   std_logic_vector(0 downto 0);
             m1_ddr2_ras_n    : out   std_logic_vector(0 downto 0);
             m1_ddr2_sa       : out   std_logic_vector(1 downto 0);
             m1_ddr2_scl      : out   std_logic_vector(0 downto 0);
             m1_ddr2_sda      : in    std_logic_vector(0 downto 0);
             m1_ddr2_we_n     : out   std_logic_vector(0 downto 0);
             m1_ddr2_oct_rup  : in    std_logic;
             m1_ddr2_oct_rnd  : in    std_logic;
             D5M_D         : in    std_logic_vector(11 downto 0);
             D5M_RESETn    : out   std_logic;
             D5M_FVAL      : in    std_logic;
             D5M_LVAL      : in    std_logic;
             D5M_PIXLCLK   : in    std_logic;
             D5M_SCLK      : out   std_logic;
             D5M_SDATA     : inout std_logic;
             D5M_STROBE    : in    std_logic;
             D5M_TRIGGER   : out   std_logic;
             D5M_XCLKIN    : out   std_logic;
             DVI_EDID_WP   : out   std_logic;
             DVI_RX_CLK    : in    std_logic;
             DVI_RX_CTL    : in    std_logic_vector(3 downto 1);
             DVI_RX_D      : in    std_logic_vector(23 downto 0);
             DVI_RX_DDCSCL : in    std_logic;
             DVI_RX_DDCSDA : in    std_logic;
             DVI_RX_DE     : in    std_logic;
             DVI_RX_HS     : in    std_logic;
             DVI_RX_SCDT   : in    std_logic;
             DVI_RX_VS     : in    std_logic;
             DVI_TX_CLK    : out   std_logic;
             DVI_TX_CTL    : out   std_logic_vector(3 downto 1);
             DVI_TX_D      : out   std_logic_vector(23 downto 0);
             DVI_TX_DDCSCL : inout std_logic;
             DVI_TX_DDCSDA : inout std_logic;
             DVI_TX_DE     : out   std_logic;
             DVI_TX_DKEN   : out   std_logic;
             DVI_TX_HS     : out   std_logic;
             DVI_TX_HTPLG  : out   std_logic;
             DVI_TX_ISEL   : out   std_logic;
             DVI_TX_MSEN   : out   std_logic;
             DVI_TX_PD_N   : out   std_logic;
             DVI_TX_SCL    : out   std_logic;
             DVI_TX_SDA    : inout std_logic;
             DVI_TX_VS     : out   std_logic;
             HSMC_SCL      : out   std_logic;
             HSMC_SDA      : inout std_logic);
    end component DE4_D5M_TLVL;

    signal ddr2_odt             : std_logic_vector(0 downto 0);
    signal ddr2_clk, ddr2_clk_n : std_logic_vector(1 downto 0);
    signal ddr2_cke             : std_logic_vector(0 downto 0);
    signal ddr2_cs_n            : std_logic_vector(0 downto 0);
    signal ddr2_ras_n           : std_logic_vector(0 downto 0);
    signal ddr2_cas_n           : std_logic_vector(0 downto 0);
    signal ddr2_we_n            : std_logic_vector(0 downto 0);
    signal ddr2_ba              : std_logic_vector(2 downto 0);
    signal ddr2_addr            : std_logic_vector(13 downto 0);
    signal ddr2_dq              : std_logic_vector(63 downto 0);
    signal ddr2_dm              : std_logic_vector(7 downto 0);
    signal ddr2_dqs, ddr2_dqs_n : std_logic_vector(7 downto 0);

    signal clock              : std_logic := '0';
    constant pictures_count : integer   := 2;
    constant pix_bits       : integer   := 24;
    constant c_period         : time      := 12.5 ns;
    --camera
    signal D5M_D              : std_logic_vector(11 downto 0);
    signal D5M_RESETn         : std_logic;
    signal D5M_FVAL           : std_logic;
    signal D5M_LVAL           : std_logic;
    signal D5M_PIXLCLK        : std_logic;
    signal D5M_SCLK           : std_logic;
    signal D5M_SDATA          : std_logic;
    signal D5M_STROBE         : std_logic;
    signal D5M_TRIGGER        : std_logic;
    signal D5M_XCLKIN         : std_logic;
    --DVI
    signal DVI_EDID_WP        : std_logic;
    signal DVI_RX_CLK         : std_logic;
    signal DVI_RX_CTL         : std_logic_vector(3 downto 1);
    signal DVI_RX_D           : std_logic_vector(23 downto 0);
    signal DVI_RX_DDCSCL      : std_logic;
    signal DVI_RX_DDCSDA      : std_logic;
    signal DVI_RX_DE          : std_logic;
    signal DVI_RX_HS          : std_logic;
    signal DVI_RX_SCDT        : std_logic;
    signal DVI_RX_VS          : std_logic;
    signal DVI_TX_CLK         : std_logic;
    signal DVI_TX_CTL         : std_logic_vector(3 downto 1);
    signal DVI_TX_D           : std_logic_vector(23 downto 0);
    signal DVI_TX_DDCSCL      : std_logic;
    signal DVI_TX_DDCSDA      : std_logic;
    signal DVI_TX_DE          : std_logic;
    signal DVI_TX_DKEN        : std_logic;
    signal DVI_TX_HS          : std_logic;
    signal DVI_TX_HTPLG       : std_logic;
    signal DVI_TX_ISEL        : std_logic;
    signal DVI_TX_MSEN        : std_logic;
    signal DVI_TX_PD_N        : std_logic;
    signal DVI_TX_SCL         : std_logic;
    signal DVI_TX_SDA         : std_logic;
    signal DVI_TX_VS          : std_logic;
    --hsmc i2c 
    signal HSMC_SCL           : std_logic;
    signal HSMC_SDA           : std_logic;
    --unused inout's
    signal PLL_CLKIN_p        : std_logic;
    signal ETH_INT_n          : std_logic_vector(3 downto 0);
    signal ETH_PSE_INT_n      : std_logic;
    signal ETH_RST_n          : std_logic;
    signal SSRAM_CLK          : std_logic;
    signal MAX_I2C_SDAT : std_logic;
    signal ETH_MDC : std_logic_vector(3 downto 0);
    signal ETH_PSE_SDA : std_logic;
    signal FSM_D : std_logic_vector(15 downto 0);
    signal OTG_D : std_logic_vector(31 downto 0);
    signal ETH_MDIO : std_logic_vector(3 downto 0);
begin
    clk_generator : process is
    begin
        clock <= '0';
        wait for c_period / 2;
        clock <= '1';
        wait for c_period / 2;
    end process clk_generator;

    D5M_XCLKIN <= clock;
    D5M_PIXLCLK <= clock;
    D5M_FVAL <= '1';
    D5M_LVAL <= '1';
    D5M_D <= (others => '1');



    d5m_top_lvl : DE4_D5M_TLVL
        --generic map(c_pictures_count => pictures_count,
          --          c_pix_bits       => pix_bits)
        port map(gclkin        => clock,
                 GCLKOUT_FPGA  => open,
                 OSC_50_BANK2  => clock,
                 OSC_50_BANK3  => clock,
                 OSC_50_BANK4  => clock,
                 OSC_50_BANK5  => clock,
                 OSC_50_BANK6  => clock,
                 OSC_50_BANK7  => clock,
                 PLL_CLKIN_p   => '0',
                 MAX_I2C_SCLK  => open,
                 MAX_I2C_SDAT  => MAX_I2C_SDAT,
                 SMA_CLKIN_p   => '0',
                 SMA_CLKOUT_p  => open,
                 LED           => open,
                 BUTTON        => "1111",
                 CPU_RESET_n   => '1',
                 EXT_IO        => '0',
                 SW            => "00000000",
                 SLIDE_SW      => "0000",
                 SEG0_D        => open,
                 SEG0_DP       => open,
                 SEG1_D        => open,
                 SEG1_DP       => open,
                 TEMP_INT_n    => '0',
                 TEMP_SMCLK    => open,
                 TEMP_SMDAT    => '0',
                 CSENSE_ADC_FO => open,
                 CSENSE_CS_n   => open,
                 CSENSE_SCK    => open,
                 CSENSE_SDI    => open,
                 CSENSE_SDO    => '0',
                 FAN_CTRL      => open,
                 EEP_SCL       => open,
                 EEP_SDA       => open,
                 SD_CLK        => open,
                 SD_CMD        => '0',
                 SD_DAT        => "0000",
                 SD_WP_n       => '0',
                 ETH_INT_n     => ETH_INT_n,
                 ETH_MDC       => ETH_MDC,
                 ETH_MDIO      => ETH_MDIO,
                 ETH_PSE_INT_n => ETH_PSE_INT_n,
                 ETH_PSE_RST_n => open,
                 ETH_PSE_SCK   => open,
                 ETH_PSE_SDA   => ETH_PSE_SDA,
                 ETH_RST_n     => ETH_RST_n,
                 ETH_RX_p      => "0000",
                 ETH_TX_p      => open,
                 FSM_A         => open,
                 FSM_D         => FSM_D,
                 FLASH_ADV_n   => open,
                 FLASH_CE_n    => open,
                 FLASH_CLK     => open,
                 FLASH_OE_n    => open,
                 FLASH_RESET_n => open,
                 FLASH_RYBY_n  => '0',
                 FLASH_WE_n    => open,
                 SSRAM_ADV     => open,
                 SSRAM_BWA_n   => open,
                 SSRAM_BWB_n   => open,
                 SSRAM_CE_n    => open,
                 SSRAM_CKE_n   => open,
                 SSRAM_CLK     => SSRAM_CLK,
                 SSRAM_OE_n    => open,
                 SSRAM_WE_n    => open,
                 OTG_A         => open,
                 OTG_CS_n      => open,
                 OTG_D         => OTG_D,
                 OTG_DC_DACK   => open,
                 OTG_DC_DREQ   => '0',
                 OTG_DC_IRQ    => '0',
                 OTG_HC_DACK   => open,
                 OTG_HC_DREQ   => '0',
                 OTG_HC_IRQ    => '0',
                 OTG_OE_n      => open,
                 OTG_RESET_n   => open,
                 OTG_WE_n      => open,
                 m1_ddr2_addr     => ddr2_addr,
                 m1_ddr2_ba       => ddr2_ba,
                 m1_ddr2_cas_n    => ddr2_cas_n,
                 m1_ddr2_cke      => ddr2_cke,
                 m1_ddr2_clk      => ddr2_clk,
                 m1_ddr2_clk_n    => ddr2_clk_n,
                 m1_ddr2_cs_n     => ddr2_cs_n,
                 m1_ddr2_dm       => ddr2_dm,
                 m1_ddr2_dq       => ddr2_dq,
                 m1_ddr2_dqs      => ddr2_dqs,
                 m1_ddr2_dqsn     => ddr2_dqs_n,
                 m1_ddr2_odt      => ddr2_odt,
                 m1_ddr2_ras_n    => ddr2_ras_n,
                 m1_ddr2_sa       => open,
                 m1_ddr2_scl      => open,
                 m1_ddr2_sda      => "0",
                 m1_ddr2_we_n     => ddr2_we_n,
                 m1_ddr2_oct_rup  => '0',
                 m1_ddr2_oct_rnd  => '0',
                 D5M_D         => D5M_D,
                 D5M_RESETn    => D5M_RESETn,
                 D5M_FVAL      => D5M_FVAL,
                 D5M_LVAL      => D5M_LVAL,
                 D5M_PIXLCLK   => D5M_PIXLCLK,
                 D5M_SCLK      => D5M_SCLK,
                 D5M_SDATA     => D5M_SDATA,
                 D5M_STROBE    => D5M_STROBE,
                 D5M_TRIGGER   => D5M_TRIGGER,
                 D5M_XCLKIN    => D5M_XCLKIN,
                 DVI_EDID_WP   => DVI_EDID_WP,
                 DVI_RX_CLK    => DVI_RX_CLK,
                 DVI_RX_CTL    => DVI_RX_CTL,
                 DVI_RX_D      => DVI_RX_D,
                 DVI_RX_DDCSCL => DVI_RX_DDCSCL,
                 DVI_RX_DDCSDA => DVI_RX_DDCSDA,
                 DVI_RX_DE     => DVI_RX_DE,
                 DVI_RX_HS     => DVI_RX_HS,
                 DVI_RX_SCDT   => DVI_RX_SCDT,
                 DVI_RX_VS     => DVI_RX_VS,
                 DVI_TX_CLK    => DVI_TX_CLK,
                 DVI_TX_CTL    => DVI_TX_CTL,
                 DVI_TX_D      => DVI_TX_D,
                 DVI_TX_DDCSCL => DVI_TX_DDCSCL,
                 DVI_TX_DDCSDA => DVI_TX_DDCSDA,
                 DVI_TX_DE     => DVI_TX_DE,
                 DVI_TX_DKEN   => DVI_TX_DKEN,
                 DVI_TX_HS     => DVI_TX_HS,
                 DVI_TX_HTPLG  => DVI_TX_HTPLG,
                 DVI_TX_ISEL   => DVI_TX_ISEL,
                 DVI_TX_MSEN   => DVI_TX_MSEN,
                 DVI_TX_PD_N   => DVI_TX_PD_N,
                 DVI_TX_SCL    => DVI_TX_SCL,
                 DVI_TX_SDA    => DVI_TX_SDA,
                 DVI_TX_VS     => DVI_TX_VS,
                 HSMC_SCL      => HSMC_SCL,
                 HSMC_SDA      => HSMC_SDA);

end architecture;
