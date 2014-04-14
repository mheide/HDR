-- Revision History :
-- --------------------------------------------------------------------
--   Ver  :| Author            :| Mod. Date :| Changes Made:
--   V1.0 :| Peli Li           :| 07/19/2010:| Initial Revision
--   V2.0 :| M.Heide & M.Kunz    :| 09/06/2013:| HDR Components
-- --------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE4_D5M_TLVL is
    generic(
        c_pictures_count : integer := 2;
        c_pix_bits       : integer := 24
    );
    port(
        --clock
        gclkin        : in    std_logic;
        GCLKOUT_FPGA  : out   std_logic;
        OSC_50_BANK2  : in    std_logic;
        OSC_50_BANK3  : in    std_logic;
        OSC_50_BANK4  : in    std_logic;
        OSC_50_BANK5  : in    std_logic;
        OSC_50_BANK6  : in    std_logic;
        OSC_50_BANK7  : in    std_logic;
        PLL_CLKIN_p   : in    std_logic;
        --external pll
        MAX_I2C_SCLK  : out   std_logic;
        MAX_I2C_SDAT  : inout std_logic;
        --sma
        SMA_CLKIN_p   : in    std_logic;
        SMA_CLKOUT_p  : out   std_logic;
        LED           : out   std_logic_vector(7 downto 0);
        --buttons
        BUTTON        : in    std_logic_vector(3 downto 0);
        CPU_RESET_n   : in    std_logic;
        EXT_IO        : in    std_logic;
        --dip switch
        SW            : in    std_logic_vector(7 downto 0);
        --slide switch
        SLIDE_SW      : in    std_logic_vector(3 downto 0);
        --seven segment
        SEG0_D        : out   std_logic_vector(6 downto 0);
        SEG0_DP       : out   std_logic;
        SEG1_D        : out   std_logic_vector(6 downto 0);
        SEG1_DP       : out   std_logic;
        --temperature
        TEMP_INT_n    : in    std_logic;
        TEMP_SMCLK    : out   std_logic;
        TEMP_SMDAT    : in    std_logic;
        --current
        CSENSE_ADC_FO : out   std_logic;
        CSENSE_CS_n   : out   std_logic_vector(1 downto 0);
        CSENSE_SCK    : out   std_logic;
        CSENSE_SDI    : out   std_logic;
        CSENSE_SDO    : in    std_logic;
        --fan
        FAN_CTRL      : out   std_logic;
        --eeprom
        EEP_SCL       : out   std_logic;
        EEP_SDA       : inout std_logic;
        --sdcard
        SD_CLK        : out   std_logic;
        SD_CMD        : in    std_logic;
        SD_DAT        : in    std_logic_vector(3 downto 0);
        SD_WP_n       : in    std_logic;
        --enthernet
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
        --flash and sram
        FSM_A         : out   std_logic_vector(25 downto 1);
        FSM_D         : inout std_logic_vector(15 downto 0);
        --flash control
        FLASH_ADV_n   : out   std_logic;
        FLASH_CE_n    : out   std_logic;
        FLASH_CLK     : out   std_logic;
        FLASH_OE_n    : out   std_logic;
        FLASH_RESET_n : out   std_logic;
        FLASH_RYBY_n  : in    std_logic;
        FLASH_WE_n    : out   std_logic;
        --ssram control
        SSRAM_ADV     : out   std_logic;
        SSRAM_BWA_n   : out   std_logic;
        SSRAM_BWB_n   : out   std_logic;
        SSRAM_CE_n    : out   std_logic;
        SSRAM_CKE_n   : out   std_logic;
        SSRAM_CLK     : out   std_logic;
        SSRAM_OE_n    : out   std_logic;
        SSRAM_WE_n    : out   std_logic;
        --ust otg
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
        --ddr2 sodimm
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
        --D5M-cam
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
        --dvi
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
        --hsmc i2c
        HSMC_SCL      : out   std_logic;
        HSMC_SDA      : inout std_logic
    );
end entity DE4_D5M_TLVL;

library ieee;
use ieee.std_logic_1164.all;
architecture RTL of DE4_D5M_TLVL is
    signal Read_DATA1         : std_logic_vector(15 downto 0);
    signal Read_DATA2         : std_logic_vector(15 downto 0);
    signal Read_DATA1_SODIMM1 : std_logic_vector(15 downto 0);
    signal Read_DATA2_SODIMM1 : std_logic_vector(15 downto 0);
    signal VGA_CTRL_CLK       : std_logic;
    signal mCCD_DATA          : std_logic_vector(11 downto 0);
    signal mCCD_DVAL          : std_logic;
    signal mCCD_DVAL_d        : std_logic;
    signal X_Cont             : std_logic_vector(15 downto 0);
    signal Y_Cont             : std_logic_vector(15 downto 0);
    signal X_ADDR             : std_logic_vector(9 downto 0);
    signal Frame_Cont         : std_logic_vector(31 downto 0);
    signal DLY_RST_0          : std_logic;
    signal DLY_RST_1          : std_logic;
    signal DLY_RST_2          : std_logic;
    signal DLY_RST_3          : std_logic;
    signal DLY_RST_4          : std_logic;
    signal Read               : std_logic;
    signal rCCD_DATA          : std_logic_vector(11 downto 0);
    signal rCCD_LVAL          : std_logic;
    signal rCCD_FVAL          : std_logic;
    signal sCCD_R             : std_logic_vector(11 downto 0);
    signal sCCD_G             : std_logic_vector(11 downto 0);
    signal sCCD_B             : std_logic_vector(11 downto 0);
    signal sCCD_DVAL          : std_logic;
    signal oVGA_R             : std_logic_vector(9 downto 0);
    signal oVGA_G             : std_logic_vector(9 downto 0);
    signal oVGA_B             : std_logic_vector(9 downto 0);
    signal rClk               : std_logic_vector(1 downto 0);
    --power on start
    signal auto_start         : std_logic;
    --ddr2
    signal ip_init_done       : std_logic;
    signal reset_n            : std_logic;
    signal wrt_full_port0     : std_logic;
    signal wrt_full_port1     : std_logic;
    --dvi
    signal reset_n_dvi        : std_logic;
    signal pll_100M           : std_logic;
    signal pll_100K           : std_logic;
    signal gen_sck            : std_logic;
    signal gen_i2s            : std_logic;
    signal gen_ws             : std_logic;
    signal D5M_PIXLCLKn       : std_logic;
    --concat color ports to 32 - bit input stream to ddr2
    signal iWriteData         : std_logic_vector(31 downto 0);
    --external pll config
    signal clk1_set_wr        : std_logic_vector(3 downto 0);
    signal clk2_set_wr        : std_logic_vector(3 downto 0);
    signal clk3_set_wr        : std_logic_vector(3 downto 0);
    signal rstn               : std_logic;
    signal conf_ready         : std_logic;
    signal counter_max        : std_logic;
    signal counter_inc        : std_logic_vector(7 downto 0);
    signal auto_set_counter   : std_logic_vector(7 downto 0) := (others => '0');
    signal conf_wr            : std_logic;

    component ddr2_multi_port
        port(
            ddr2_status_local_init_done          : out   std_logic; --             ddr2_status.local_init_done
            ddr2_status_local_cal_success        : out   std_logic; --                        .local_cal_success
            ddr2_status_local_cal_fail           : out   std_logic; --                        .local_cal_fail
            clk_50                               : in    std_logic                     := '0'; --           clk_50_clk_in.clk
            read_port1_conduit_end_iRST_n_F      : in    std_logic                     := '0'; --  read_port1_conduit_end.iRST_n_F
            read_port1_conduit_end_iCLK_F        : in    std_logic                     := '0'; --                        .iCLK_F
            read_port1_conduit_end_iREAD_ACK_F   : in    std_logic                     := '0'; --                        .iREAD_ACK_F
            read_port1_conduit_end_oREAD_DATA_F  : out   std_logic_vector(31 downto 0); --                        .oREAD_DATA_F
            read_port1_conduit_end_oEMPTY_F      : out   std_logic; --                        .oEMPTY_F
            read_port1_conduit_end_oPORT_READY_F : out   std_logic; --                        .oPORT_READY_F
            read_port1_conduit_end_iIP_INIT_DONE : in    std_logic                     := '0'; --                        .iIP_INIT_DONE
            read_port1_conduit_end_c_state       : out   std_logic_vector(3 downto 0); --                        .c_state
            read_port1_conduit_end_error         : out   std_logic; --                        .error
            iRST_n_F_to_the_Read_Port0           : in    std_logic                     := '0'; --  Read_Port0_conduit_end.iRST_n_F
            iCLK_F_to_the_Read_Port0             : in    std_logic                     := '0'; --                        .iCLK_F
            iREAD_ACK_F_to_the_Read_Port0        : in    std_logic                     := '0'; --                        .iREAD_ACK_F
            oREAD_DATA_F_from_the_Read_Port0     : out   std_logic_vector(31 downto 0); --                        .oREAD_DATA_F
            oEMPTY_F_from_the_Read_Port0         : out   std_logic; --                        .oEMPTY_F
            oPORT_READY_F_from_the_Read_Port0    : out   std_logic; --                        .oPORT_READY_F
            iIP_INIT_DONE_to_the_Read_Port0      : in    std_logic                     := '0'; --                        .iIP_INIT_DONE
            c_state_from_the_Read_Port0          : out   std_logic_vector(3 downto 0); --                        .c_state
            error_from_the_Read_Port0            : out   std_logic; --                        .error
            ddr2_memory_mem_a                    : out   std_logic_vector(13 downto 0); --             ddr2_memory.mem_a
            ddr2_memory_mem_ba                   : out   std_logic_vector(2 downto 0); --                        .mem_ba
            ddr2_memory_mem_ck                   : out   std_logic_vector(1 downto 0); --                        .mem_ck
            ddr2_memory_mem_ck_n                 : out   std_logic_vector(1 downto 0); --                        .mem_ck_n
            ddr2_memory_mem_cke                  : out   std_logic_vector(0 downto 0); --                        .mem_cke
            ddr2_memory_mem_cs_n                 : out   std_logic_vector(0 downto 0); --                        .mem_cs_n
            ddr2_memory_mem_dm                   : out   std_logic_vector(7 downto 0); --                        .mem_dm
            ddr2_memory_mem_ras_n                : out   std_logic_vector(0 downto 0); --                        .mem_ras_n
            ddr2_memory_mem_cas_n                : out   std_logic_vector(0 downto 0); --                        .mem_cas_n
            ddr2_memory_mem_we_n                 : out   std_logic_vector(0 downto 0); --                        .mem_we_n
            ddr2_memory_mem_dq                   : inout std_logic_vector(63 downto 0) := (others => '0'); --                        .mem_dq
            ddr2_memory_mem_dqs                  : inout std_logic_vector(7 downto 0)  := (others => '0'); --                        .mem_dqs
            ddr2_memory_mem_dqs_n                : inout std_logic_vector(7 downto 0)  := (others => '0'); --                        .mem_dqs_n
            ddr2_memory_mem_odt                  : out   std_logic_vector(0 downto 0); --                        .mem_odt
            ddr2_global_reset_reset_n            : in    std_logic                     := '0'; --       ddr2_global_reset.reset_n
            iRST_n_F_to_the_Write_Port0          : in    std_logic                     := '0'; -- Write_Port0_conduit_end.iRST_n_F
            iCLK_F_to_the_Write_Port0            : in    std_logic                     := '0'; --                        .iCLK_F
            iWRITE_F_to_the_Write_Port0          : in    std_logic                     := '0'; --                        .iWRITE_F
            iWRITE_DATA_F_to_the_Write_Port0     : in    std_logic_vector(31 downto 0) := (others => '0'); --                        .iWRITE_DATA_F
            oFULL_F_from_the_Write_Port0         : out   std_logic; --                        .oFULL_F
            iFLUSH_REQ_F_to_the_Write_Port0      : in    std_logic                     := '0'; --                        .iFLUSH_REQ_F
            oFLUSH_BUSY_F_from_the_Write_Port0   : out   std_logic; --                        .oFLUSH_BUSY_F
            iIP_INIT_DONE_to_the_Write_Port0     : in    std_logic                     := '0'; --                        .iIP_INIT_DONE
            c_state_flush_from_the_Write_Port0   : out   std_logic_vector(4 downto 0); --                        .c_state_flush
            wrusedw_from_the_Write_Port0         : out   std_logic_vector(8 downto 0); --                        .wrusedw
            c_state_from_the_Write_Port0         : out   std_logic_vector(3 downto 0); --                        .c_state
            ddr2_phy_clk_out                     : out   std_logic; --          sysclk_out_clk.clk
            reset_n                              : in    std_logic                     := '0'; --     clk_50_clk_in_reset.reset_n
            ddr2_oct_rdn                         : in    std_logic                     := '0'; --                ddr2_oct.rdn
            ddr2_oct_rup                         : in    std_logic                     := '0' --                        .rup
        );
    end component;

    component Reset_Delay
        port(
            iCLK   : std_logic;
            iRST   : std_logic;
            orst_o : std_logic;
            orst_1 : std_logic;
            oRST_2 : std_logic;
            oRST_3 : std_logic;
            oRST_4 : std_logic
        );
    end component;

    component CCD_Capture
        port(
            oDATA       : out std_logic_vector(11 downto 0);
            oX_Cont     : out std_logic_vector(15 downto 0);
            oY_Cont     : out std_logic_vector(15 downto 0);
            oFrame_Cont : out std_logic_vector(31 downto 0);
            iDATA       : in  std_logic_vector(11 downto 0);
            iFVAL       : in  std_logic;
            iLVAL       : in  std_logic;
            iSTART      : in  std_logic;
            iEND        : in  std_logic;
            iCLK        : in  std_logic;
            iRST        : in  std_logic
        );
    end component;

    component RAW2RGB
        port(
            iCLK    : in  std_logic;
            iRST_n  : in  std_logic;
            iData   : in  std_logic_vector(11 downto 0);
            iDval   : in  std_logic;
            oRed    : out std_logic_vector(11 downto 0);
            oGreen  : out std_logic_vector(11 downto 0);
            oBlue   : out std_logic_vector(11 downto 0);
            oDval   : out std_logic;
            iZoom   : in  std_logic;
            iX_Cont : in  std_logic_vector(15 downto 0);
            iY_Cont : in  std_logic_vector(15 downto 0)
        );
    end component;

    component ext_pll_ctrl
        port(
            osc_50      : in    std_logic;
            rstn        : in    std_logic;
            clk1_set_wr : in    std_logic_vector(3 downto 0);
            clk1_set_rd : out   std_logic_vector(3 downto 0);
            clk2_set_wr : in    std_logic_vector(3 downto 0);
            clk2_set_rd : out   std_logic_vector(3 downto 0);
            clk3_set_wr : in    std_logic_vector(3 downto 0);
            clk3_set_rd : out   std_logic_vector(3 downto 0);
            conf_wr     : in    std_logic;
            conf_rd     : in    std_logic;
            conf_ready  : out   std_logic;
            max_sclk    : out   std_logic;
            max_sdat    : inout std_logic
        );
    end component;

    --ddr2 map signals
    signal ddr2_addr   : std_logic_vector(15 downto 0);
    signal ddr2_ba     : std_logic_vector(2 downto 0); --bank address
    signal ddr2_cas_n  : std_logic;     --cas latency
    signal ddr2_cas_nv : std_logic_vector(0 downto 0);
    signal ddr2_cke    : std_logic_vector(0 downto 0); --clock enable
    signal ddr2_clk    : std_logic_vector(1 downto 0); --diff. clock
    signal ddr2_clk_n  : std_logic_vector(1 downto 0); --diff. clock
    signal ddr2_cs_n   : std_logic_vector(0 downto 0); --command signal
    signal ddr2_dm     : std_logic_vector(7 downto 0); --drive mode
    signal ddr2_dq     : std_logic_vector(63 downto 0); --data queue
    signal ddr2_dqs    : std_logic_vector(7 downto 0); --strobe
    signal ddr2_dqsn   : std_logic_vector(7 downto 0);
    signal ddr2_odt    : std_logic_vector(0 downto 0);
    signal ddr2_ras_n  : std_logic;
    signal ddr2_ras_nv : std_logic_vector(0 downto 0);
    signal ddr2_sa     : std_logic_vector(1 downto 0);
    signal ddr2_scl    : std_logic;
    signal ddr2_sda    : std_logic;
    signal ddr2_we_n   : std_logic;
    signal ddr2_wenv   : std_logic_vector(0 downto 0);

    --ddr2 multi port signals
    signal read_rstn     : std_logic;
    signal read_clk      : std_logic;   --vpg_pclk in early verilog design
    signal readp_ack     : std_logic_vector(1 downto 0); --vpg_de in early design
    signal read_data_1_2 : std_logic_vector(31 downto 0);
    signal readp_empty   : std_logic_vector(1 downto 0);
    signal readp_ready   : std_logic_vector(1 downto 0);
    signal ipinit_done   : std_logic;

begin
    Read_DATA1 <= read_data_1_2(31 downto 16);
    Read_DATA2 <= read_data_1_2(15 downto 0);

    D5M_PIXLCLKn <= not D5M_PIXLCLK;

    iWriteData <= '0' & sCCD_G(11 downto 7) & sCCD_B(11 downto 2) & '0' & sCCD_G(6 downto 2) & sCCD_R(11 downto 2);

    reset_n      <= button(0);
    d5m_trigger  <= '1';
    D5M_RESETn   <= DLY_RST_0;
    dvi_tx_isel  <= '0';
    DVI_TX_SCL   <= '1';
    DVI_TX_HTPLG <= '1';
    DVI_TX_SDA   <= '1';
    DVI_TX_PD_N  <= '1';
    auto_start   <= '1' when (BUTTON(0) and DLY_RST_3 and not DLY_RST_4) = '1' else '0';

    clk1_set_wr <= x"4";
    clk2_set_wr <= x"4";
    clk3_set_wr <= x"4";

    rstn        <= BUTTON(0);
    counter_max <= '1' when auto_set_counter = x"FF" else '0';
    counter_inc <= std_logic_vector(unsigned(auto_set_counter) + 1);

    process(OSC_50_BANK2, rstn) is
    begin
        if rstn = '0' then
            auto_set_counter <= (others => '0');
            conf_wr          <= '0';
        elsif rising_edge(OSC_50_BANK2) then
            if counter_max = '1' then
                conf_wr <= '1';
            else
                auto_set_counter <= counter_inc;
            end if;
        end if;
    end process;

    ddr2_mp : ddr2_multi_port port map(
            ddr2_status_local_init_done          => open,
            ddr2_status_local_cal_success        => open,
            ddr2_status_local_cal_fail           => open,
            clk_50                               => gclkin,
            read_port1_conduit_end_iRST_n_F      => '0',
            read_port1_conduit_end_iCLK_F        => '0',
            read_port1_conduit_end_iREAD_ACK_F   => '0',
            read_port1_conduit_end_oREAD_DATA_F  => open,
            read_port1_conduit_end_oEMPTY_F      => open,
            read_port1_conduit_end_oPORT_READY_F => open,
            read_port1_conduit_end_iIP_INIT_DONE => '0',
            read_port1_conduit_end_c_state       => open,
            read_port1_conduit_end_error         => open,
            iRST_n_F_to_the_Read_Port0           => read_rstn,
            iCLK_F_to_the_Read_Port0             => read_clk,
            iREAD_ACK_F_to_the_Read_Port0        => readp_ack(0),
            oREAD_DATA_F_from_the_Read_Port0     => read_data_1_2,
            oEMPTY_F_from_the_Read_Port0         => readp_empty(0),
            oPORT_READY_F_from_the_Read_Port0    => readp_ready(0),
            iIP_INIT_DONE_to_the_Read_Port0      => ip_init_done,
            c_state_from_the_Read_Port0          => open,
            error_from_the_Read_Port0            => open,
            ddr2_memory_mem_a                    => dimm_addr(13 downto 0),
            ddr2_memory_mem_ba                   => dimm_ba,
            ddr2_memory_mem_ck                   => dimm_clk,
            ddr2_memory_mem_ck_n                 => dimm_clk_n,
            ddr2_memory_mem_cke                  => dimm_cke,
            ddr2_memory_mem_cs_n                 => dimm_cs_n,
            ddr2_memory_mem_dm                   => dimm_dm,
            ddr2_memory_mem_ras_n                => dimm_ras_n,
            ddr2_memory_mem_cas_n                => dimm_cas_n,
            ddr2_memory_mem_we_n                 => dimm_we_n,
            ddr2_memory_mem_dq                   => dimm_dq,
            ddr2_memory_mem_dqs                  => dimm_dqs,
            ddr2_memory_mem_dqs_n                => dimm_dqsn,
            ddr2_memory_mem_odt                  => dimm_odt,
            ddr2_global_reset_reset_n            => BUTTON(0),
            iRST_n_F_to_the_Write_Port0          => BUTTON(0),
            iCLK_F_to_the_Write_Port0            => D5M_PIXLCLKn,
            iWRITE_F_to_the_Write_Port0          => sCCD_DVAL,
            iWRITE_DATA_F_to_the_Write_Port0     => iWriteData,
            oFULL_F_from_the_Write_Port0         => wrt_full_port0,
            iFLUSH_REQ_F_to_the_Write_Port0      => '0',
            oFLUSH_BUSY_F_from_the_Write_Port0   => open,
            iIP_INIT_DONE_to_the_Write_Port0     => ip_init_done,
            c_state_flush_from_the_Write_Port0   => open,
            wrusedw_from_the_Write_Port0         => open,
            c_state_from_the_Write_Port0         => open,
            ddr2_phy_clk_out                     => open,
            reset_n                              => reset_n,
            ddr2_oct_rdn                         => dimm_oct_rnd,
            ddr2_oct_rup                         => dimm_oct_rup
        );

    Rst_Delay : Reset_Delay port map(
            iCLK   => OSC_50_BANK2,
            iRST   => BUTTON(0),
            orst_o => DLY_RST_0,
            orst_1 => DLY_RST_1,
            oRST_2 => DLY_RST_2,
            oRST_3 => DLY_RST_3,
            oRST_4 => DLY_RST_4
        );

    d5m_read : process(D5M_PIXLCLK, DLY_RST_1) is
    begin
        if DLY_RST_1 = '0' then         --active low
            rCCD_DATA <= (others => '0');
            rCCD_FVAL <= '0';
            rCCD_LVAL <= '0';
        elsif rising_edge(D5M_PIXLCLK) then
            rCCD_DATA <= D5M_D;
            rCCD_FVAL <= D5M_FVAL;
            rCCD_LVAL <= D5M_LVAL;
        end if;
    end process d5m_read;

    ccd : CCD_Capture
        port map(oDATA       => mCCD_DATA,
                 oX_Cont     => X_Cont,
                 oY_Cont     => Y_Cont,
                 oFrame_Cont => Frame_Cont,
                 iDATA       => rCCD_DATA,
                 iFVAL       => rCCD_FVAL,
                 iLVAL       => rCCD_LVAL,
                 iSTART      => auto_start,
                 iEND        => BUTTON(2),
                 iCLK        => D5M_PIXLCLKn,
                 iRST        => DLY_RST_2);

    rawToRGB : component RAW2RGB
        port map(iCLK    => D5M_PIXLCLK,
                 iRST_n  => DLY_RST_1,
                 iData   => mCCD_DATA,
                 iDval   => mCCD_DVAL,
                 oRed    => sCCD_R,
                 oGreen  => sCCD_G,
                 oBlue   => sCCD_B,
                 oDval   => sCCD_DVAL,
                 iZoom   => '0',
                 iX_Cont => X_Cont,
                 iY_Cont => Y_Cont);

end architecture RTL;
