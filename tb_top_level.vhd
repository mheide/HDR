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
        generic(c_pictures_count : integer := 2;
                c_pix_bits       : integer := 24);
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
             dimm_addr     : out   std_logic_vector(13 downto 0);
             dimm_ba       : out   std_logic_vector(2 downto 0);
             dimm_cas_n    : out   std_logic_vector(0 downto 0);
             dimm_cke      : out   std_logic_vector(1 downto 0);
             dimm_clk      : inout std_logic_vector(1 downto 0);
             dimm_clk_n    : inout std_logic_vector(1 downto 0);
             dimm_cs_n     : out   std_logic_vector(1 downto 0);
             dimm_dm       : out   std_logic_vector(7 downto 0);
             dimm_dq       : inout std_logic_vector(63 downto 0);
             dimm_dqs      : inout std_logic_vector(7 downto 0);
             dimm_dqsn     : inout std_logic_vector(7 downto 0);
             dimm_odt      : out   std_logic_vector(1 downto 0);
             dimm_ras_n    : out   std_logic_vector(0 downto 0);
             dimm_sa       : out   std_logic_vector(1 downto 0);
             dimm_scl      : out   std_logic_vector(0 downto 0);
             dimm_sda      : in    std_logic_vector(0 downto 0);
             dimm_we_n     : out   std_logic_vector(0 downto 0);
             dimm_oct_rup  : in    std_logic;
             dimm_oct_rnd  : in    std_logic;
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
    
    signal ddr2_odt : std_logic_vector(1 downto 0);
    signal ddr2_clk, ddr2_clk_n : std_logic_vector(1 downto 0);
    signal ddr2_cke : std_logic_vector(1 downto 0);
    signal ddr2_cs_n : std_logic_vector(1 downto 0);
    signal ddr2_ras_n : std_logic_vector(0 downto 0);
    signal ddr2_cas_n : std_logic_vector(0 downto 0);
    signal ddr2_we_n : std_logic_vector(0 downto 0);
    signal ddr2_ba : std_logic_vector(2 downto 0);
    signal ddr2_addr : std_logic_vector(13 downto 0);
    signal ddr2_dq : std_logic_vector(63 downto 0);
    signal ddr2_dqs, ddr2_dqs_n : std_logic;
begin
    ddr2_u0 : mt47h128m8 port map(
        ODT     => ddr2_odt(0),
        CK      => ddr2_clk(0),
        CKNeg   => ddr2_clk_n(0),
        CKE     => ddr2_cke(0),
        CSNeg   => ddr2_cs_n(0),
        RASNeg  => ddr2_ras_n,
        CASNeg  => ddr2_cas_n,
        WENeg   => ddr2_we_n,
        BA0     => ddr2_ba(0),
        BA1     => ddr2_ba(1),
        BA2     => ddr2_ba(2),
        A0      => ddr2_addr(0),
        A1      => ddr2_addr(1),
        A2      => ddr2_addr(2),
        A3      => ddr2_addr(3),
        A4      => ddr2_addr(4),
        A5      => ddr2_addr(5),
        A6      => ddr2_addr(6),
        A7      => ddr2_addr(7),
        A8      => ddr2_addr(8),
        A9      => ddr2_addr(9),
        A10     => ddr2_addr(10),
        A11     => ddr2_addr(11),
        A12     => ddr2_addr(12),
        A13     => ddr2_addr(13),
        DQ0     => ddr2_dq(0),
        DQ1     => ddr2_dq(1),
        DQ2     => ddr2_dq(2),
        DQ3     => ddr2_dq(3),
        DQ4     => ddr2_dq(4),
        DQ5     => ddr2_dq(5),
        DQ6     => ddr2_dq(6),
        DQ7     => ddr2_dq(7),
        RDQS    => open,
        RDQSNeg => open,
        DQS     => ddr2_dqs,
        DQSNeg  => ddr2_dqs_n
    );
    
    ddr2_u1 : mt47h128m8
        port map(ODT     => ddr2_odt(0),
                 CK      => ddr2_clk(0),
                 CKNeg   => ddr2_clk_n(0),
                 CKE     => ddr2_cke(0),
                 CSNeg   => ddr2_cs_n(0),
                 RASNeg  => ddr2_ras_n(0),
                 CASNeg  => ddr2_cas_n(0),
                 WENeg   => ddr2_we_n(0),
                 BA0     => ddr2_ba(0),
                 BA1     => ddr2_ba(1),
                 BA2     => ddr2_ba(2),
                 A0      => ddr2_addr(0),
                 A1      => ddr2_addr(1),
                 A2      => ddr2_addr(2),
                 A3      => ddr2_addr(3),
                 A4      => ddr2_addr(4),
                 A5      => ddr2_addr(5),
                 A6      => ddr2_addr(6),
                 A7      => ddr2_addr(7),
                 A8      => ddr2_addr(8),
                 A9      => ddr2_addr(9),
                 A10     => ddr2_addr(10),
                 A11     => ddr2_addr(11),
                 A12     => ddr2_addr(12),
                 A13     => ddr2_addr(13),
                 DQ0     => ddr2_dq(8),
                 DQ1     => ddr2_dq(9),
                 DQ2     => ddr2_dq(10),
                 DQ3     => ddr2_dq(11),
                 DQ4     => ddr2_dq(12),
                 DQ5     => ddr2_dq(13),
                 DQ6     => ddr2_dq(14),
                 DQ7     => ddr2_dq(15),
                 RDQS    => open,
                 RDQSNeg => open,
                 DQS     => ddr2_dqs,
                 DQSNeg  => ddr2_dqs_n);
    
    ddr2_u2 : mt47h128m8
        port map(ODT     => ddr2_odt(0),
                 CK      => ddr2_clk(0),
                 CKNeg   => ddr2_clk_n(0),
                 CKE     => ddr2_cke(0),
                 CSNeg   => ddr2_cs_n(0),
                 RASNeg  => ddr2_ras_n(0),
                 CASNeg  => ddr2_cas_n(0),
                 WENeg   => ddr2_we_n(0),
                 BA0     => ddr2_ba(0),
                 BA1     => ddr2_ba(1),
                 BA2     => ddr2_ba(2),
                 A0      => ddr2_addr(0),
                 A1      => ddr2_addr(1),
                 A2      => ddr2_addr(2),
                 A3      => ddr2_addr(3),
                 A4      => ddr2_addr(4),
                 A5      => ddr2_addr(5),
                 A6      => ddr2_addr(6),
                 A7      => ddr2_addr(7),
                 A8      => ddr2_addr(8),
                 A9      => ddr2_addr(9),
                 A10     => ddr2_addr(10),
                 A11     => ddr2_addr(11),
                 A12     => ddr2_addr(12),
                 A13     => ddr2_addr(13),
                 DQ0     => ddr2_dq(16),
                 DQ1     => ddr2_dq(17),
                 DQ2     => ddr2_dq(18),
                 DQ3     => ddr2_dq(19),
                 DQ4     => ddr2_dq(20),
                 DQ5     => ddr2_dq(21),
                 DQ6     => ddr2_dq(22),
                 DQ7     => ddr2_dq(23),
                 RDQS    => open,
                 RDQSNeg => open,
                 DQS     => ddr2_dqs,
                 DQSNeg  => ddr2_dqs_n);

    ddr2_u3 : mt47h128m8
        port map(ODT     => ddr2_odt(0),
                 CK      => ddr2_clk(0),
                 CKNeg   => ddr2_clk_n(0),
                 CKE     => ddr2_cke(0),
                 CSNeg   => ddr2_cs_n(0),
                 RASNeg  => ddr2_ras_n(0),
                 CASNeg  => ddr2_cas_n(0),
                 WENeg   => ddr2_we_n(0),
                 BA0     => ddr2_ba(0),
                 BA1     => ddr2_ba(1),
                 BA2     => ddr2_ba(2),
                 A0      => ddr2_addr(0),
                 A1      => ddr2_addr(1),
                 A2      => ddr2_addr(2),
                 A3      => ddr2_addr(3),
                 A4      => ddr2_addr(4),
                 A5      => ddr2_addr(5),
                 A6      => ddr2_addr(6),
                 A7      => ddr2_addr(7),
                 A8      => ddr2_addr(8),
                 A9      => ddr2_addr(9),
                 A10     => ddr2_addr(10),
                 A11     => ddr2_addr(11),
                 A12     => ddr2_addr(12),
                 A13     => ddr2_addr(13),
                 DQ0     => ddr2_dq(24),
                 DQ1     => ddr2_dq(25),
                 DQ2     => ddr2_dq(26),
                 DQ3     => ddr2_dq(27),
                 DQ4     => ddr2_dq(28),
                 DQ5     => ddr2_dq(29),
                 DQ6     => ddr2_dq(30),
                 DQ7     => ddr2_dq(31),
                 RDQS    => open,
                 RDQSNeg => open,
                 DQS     => ddr2_dqs,
                 DQSNeg  => ddr2_dqs_n);
                 
    ddr2_u4 : mt47h128m8
        port map(ODT     => ddr2_odt(1),
                 CK      => ddr2_clk(1),
                 CKNeg   => ddr2_clk_n(1),
                 CKE     => ddr2_cke(1),
                 CSNeg   => ddr2_cs_n(1),
                 RASNeg  => ddr2_ras_n(0),
                 CASNeg  => ddr2_cas_n(0),
                 WENeg   => ddr2_we_n(0),
                 BA0     => ddr2_ba(0),
                 BA1     => ddr2_ba(1),
                 BA2     => ddr2_ba(2),
                 A0      => ddr2_addr(0),
                 A1      => ddr2_addr(1),
                 A2      => ddr2_addr(2),
                 A3      => ddr2_addr(3),
                 A4      => ddr2_addr(4),
                 A5      => ddr2_addr(5),
                 A6      => ddr2_addr(6),
                 A7      => ddr2_addr(7),
                 A8      => ddr2_addr(8),
                 A9      => ddr2_addr(9),
                 A10     => ddr2_addr(10),
                 A11     => ddr2_addr(11),
                 A12     => ddr2_addr(12),
                 A13     => ddr2_addr(13),
                 DQ0     => ddr2_dq(32),
                 DQ1     => ddr2_dq(33),
                 DQ2     => ddr2_dq(34),
                 DQ3     => ddr2_dq(35),
                 DQ4     => ddr2_dq(36),
                 DQ5     => ddr2_dq(37),
                 DQ6     => ddr2_dq(38),
                 DQ7     => ddr2_dq(39),
                 RDQS    => open,
                 RDQSNeg => open,
                 DQS     => ddr2_dqs,
                 DQSNeg  => ddr2_dqs_n);

    ddr2_u5 : mt47h128m8
        port map(ODT     => ddr2_odt(1),
                 CK      => ddr2_clk(1),
                 CKNeg   => ddr2_clk_n(1),
                 CKE     => ddr2_cke(1),
                 CSNeg   => ddr2_cs_n(1),
                 RASNeg  => ddr2_ras_n(0),
                 CASNeg  => ddr2_cas_n(0),
                 WENeg   => ddr2_we_n(0),
                 BA0     => ddr2_ba(0),
                 BA1     => ddr2_ba(1),
                 BA2     => ddr2_ba(2),
                 A0      => ddr2_addr(0),
                 A1      => ddr2_addr(1),
                 A2      => ddr2_addr(2),
                 A3      => ddr2_addr(3),
                 A4      => ddr2_addr(4),
                 A5      => ddr2_addr(5),
                 A6      => ddr2_addr(6),
                 A7      => ddr2_addr(7),
                 A8      => ddr2_addr(8),
                 A9      => ddr2_addr(9),
                 A10     => ddr2_addr(10),
                 A11     => ddr2_addr(11),
                 A12     => ddr2_addr(12),
                 A13     => ddr2_addr(13),
                 DQ0     => ddr2_dq(40),
                 DQ1     => ddr2_dq(41),
                 DQ2     => ddr2_dq(42),
                 DQ3     => ddr2_dq(43),
                 DQ4     => ddr2_dq(44),
                 DQ5     => ddr2_dq(45),
                 DQ6     => ddr2_dq(46),
                 DQ7     => ddr2_dq(47),
                 RDQS    => open,
                 RDQSNeg => open,
                 DQS     => ddr2_dqs,
                 DQSNeg  => ddr2_dqs_n);

    ddr2_u6 : mt47h128m8
        port map(ODT     => ddr2_odt(1),
                 CK      => ddr2_clk(1),
                 CKNeg   => ddr2_clk_n(1),
                 CKE     => ddr2_cke(1),
                 CSNeg   => ddr2_cs_n(1),
                 RASNeg  => ddr2_ras_n(0),
                 CASNeg  => ddr2_cas_n(0),
                 WENeg   => ddr2_we_n(0),
                 BA0     => ddr2_ba(0),
                 BA1     => ddr2_ba(1),
                 BA2     => ddr2_ba(2),
                 A0      => ddr2_addr(0),
                 A1      => ddr2_addr(1),
                 A2      => ddr2_addr(2),
                 A3      => ddr2_addr(3),
                 A4      => ddr2_addr(4),
                 A5      => ddr2_addr(5),
                 A6      => ddr2_addr(6),
                 A7      => ddr2_addr(7),
                 A8      => ddr2_addr(8),
                 A9      => ddr2_addr(9),
                 A10     => ddr2_addr(10),
                 A11     => ddr2_addr(11),
                 A12     => ddr2_addr(12),
                 A13     => ddr2_addr(13),
                 DQ0     => ddr2_dq(48),
                 DQ1     => ddr2_dq(49),
                 DQ2     => ddr2_dq(50),
                 DQ3     => ddr2_dq(51),
                 DQ4     => ddr2_dq(52),
                 DQ5     => ddr2_dq(53),
                 DQ6     => ddr2_dq(54),
                 DQ7     => ddr2_dq(55),
                 RDQS    => open,
                 RDQSNeg => open,
                 DQS     => ddr2_dqs,
                 DQSNeg  => ddr2_dqs_n);

    ddr2_u7 : mt47h128m8
        port map(ODT     => ddr2_odt(1),
                 CK      => ddr2_clk(1),
                 CKNeg   => ddr2_clk_n(1),
                 CKE     => ddr2_cke(1),
                 CSNeg   => ddr2_cs_n(1),
                 RASNeg  => ddr2_ras_n(0),
                 CASNeg  => ddr2_cas_n(0),
                 WENeg   => ddr2_we_n(0),
                 BA0     => ddr2_ba(0),
                 BA1     => ddr2_ba(1),
                 BA2     => ddr2_ba(2),
                 A0      => ddr2_addr(0),
                 A1      => ddr2_addr(1),
                 A2      => ddr2_addr(2),
                 A3      => ddr2_addr(3),
                 A4      => ddr2_addr(4),
                 A5      => ddr2_addr(5),
                 A6      => ddr2_addr(6),
                 A7      => ddr2_addr(7),
                 A8      => ddr2_addr(8),
                 A9      => ddr2_addr(9),
                 A10     => ddr2_addr(10),
                 A11     => ddr2_addr(11),
                 A12     => ddr2_addr(12),
                 A13     => ddr2_addr(13),
                 DQ0     => ddr2_dq(56),
                 DQ1     => ddr2_dq(57),
                 DQ2     => ddr2_dq(58),
                 DQ3     => ddr2_dq(59),
                 DQ4     => ddr2_dq(60),
                 DQ5     => ddr2_dq(61),
                 DQ6     => ddr2_dq(62),
                 DQ7     => ddr2_dq(63),
                 RDQS    => open,
                 RDQSNeg => open,
                 DQS     => ddr2_dqs,
                 DQSNeg  => ddr2_dqs_n);
                 

end architecture;
