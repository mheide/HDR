library ieee;
use ieee.std_logic_1164.all;

entity DE4_D5M_TLVL is
	generic(
		c_pictures_count : integer := 2;
		c_pix_bits       : integer := 24
	);
	port(
		gclkin        : in    std_logic;
		GCLKOUT_FPGA  : out   std_logic;
		OSC_50_BANK2  : in    std_logic;
		OSC_50_BANK3  : in    std_logic;
		OSC_50_BANK4  : in    std_logic;
		OSC_50_BANK5  : in    std_logic;
		OSC_50_BANK6  : in    std_logic;
		OSC_50_BANK7  : in    std_logic;
		PLL_CLKIN_p   : in    std_logic;
		BUTTON        : in    std_logic_vector(3 downto 0);
		CPU_RESET_n   : in    std_logic;
		EXT_IO        : in    std_logic;
		SW            : in    std_logic_vector(7 downto 0);
		SLIDE_SW      : in    std_logic_vector(3 downto 0);
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
		DVI_TX_DE     : out   std_logic;
		DVI_TX_DKEN   : out   std_logic;
		DVI_TX_HS     : out   std_logic;
		DVI_TX_HTPLG  : out   std_logic;
		DVI_TX_ISEL   : out   std_logic;
		DVI_TX_MSEN   : out   std_logic;
		DVI_TX_PD_N   : out   std_logic;
		DVI_TX_SCL    : out   std_logic;
		DVI_TX_SDA    : out   std_logic
	);
end entity DE4_D5M_TLVL;

architecture RTL of DE4_D5M_TLVL is
	signal read_rstn          : std_logic;
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
	signal auto_start         : std_logic;
	signal ip_init_done       : std_logic;
	signal reset_n            : std_logic;
	signal wrt_full_port0     : std_logic;
	signal wrt_full_port1     : std_logic;
	signal reset_n_dvi        : std_logic;
	signal pll_100M           : std_logic;
	signal pll_100K           : std_logic;
	signal gen_sck            : std_logic;
	signal gen_i2s            : std_logic;
	signal gen_ws             : std_logic;

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
			iRST        : in std_logic
		);
	end component;
	
	component RAW2RGB
		port(
			iCLK : in std_logic;
			iRST_n : in std_logic;
			iData : in std_logic_vector(11 downto 0);
			iDval : in std_logic;
			oRed : out std_logic_vector(11 downto 0);
			oGreen : out std_logic_vector(11 downto 0);
			oBlue : out std_logic_vector(11 downto 0);
			oDval : out std_logic;
			iZoom : in std_logic;
			iX_Cont : in std_logic_vector(15 downto 0);
			iY_Cont : in std_logic_vector(15 downto 0)
		);
	end component;

begin
	reset_n      <= button(0);
	d5m_trigger  <= '1';
	D5M_RESETn   <= DLY_RST_0;
	dvi_tx_isel  <= '0';
	DVI_TX_SCL   <= '1';
	DVI_TX_HTPLG <= '1';
	DVI_TX_SDA   <= '1';
	DVI_TX_PD_N  <= '1';
	auto_start   <= '1' when (BUTTON(0) and DLY_RST_3 and not DLY_RST_4) = '1'
		else '0';

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
			     iCLK        => not D5M_PIXLCLK,
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
