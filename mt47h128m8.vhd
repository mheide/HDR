--------------------------------------------------------------------------------
--  File Name: mt47h128m8.vhd
--------------------------------------------------------------------------------
--  Copyright (C) 2006-2009 Free Model Foundry; http://www.FreeModelFoundry.com
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License version 2 as
--  published by the Free Software Foundation.
--
--  MODIFICATION HISTORY:
--
--  version: |  author:         | mod date: | changes made:
--    V1.0     D.Randjelovic      06 Mar 15   Initial release
--    V1.1     B.Colakovic        08 Aug 27   CKE condition added
--    V1.2     S.Petrovic         09 Apr 01   Corrected write burst, to avoid
--                                            undefined write at high frequency
--
--------------------------------------------------------------------------------
--  PART DESCRIPTION:
--
--  Library:    RAM
--  Technology: CMOS
--  Part:       MT47H128M8
--
--  Description: 1Gb (16 Meg x 8 x 8 banks) DDR2 SDRAM
--------------------------------------------------------------------------------

LIBRARY IEEE;      USE IEEE.std_logic_1164.ALL;

                   USE IEEE.VITAL_timing.ALL;
                   USE IEEE.VITAL_primitives.ALL;

                   USE STD.textio.ALL;

LIBRARY FMF;       USE FMF.gen_utils.ALL;
                   USE FMF.conversions.ALL;

--------------------------------------------------------------------------------
-- ENTITY DECLARATION
--------------------------------------------------------------------------------
ENTITY mt47h128m8 IS
    GENERIC (
        -- tipd delays: interconnect path delays
        tipd_ODT          : VitalDelayType01 := VitalZeroDelay01;
        tipd_CK           : VitalDelayType01 := VitalZeroDelay01;
        tipd_CKNeg        : VitalDelayType01 := VitalZeroDelay01;
        tipd_CKE          : VitalDelayType01 := VitalZeroDelay01;
        tipd_CSNeg        : VitalDelayType01 := VitalZeroDelay01;
        tipd_RASNeg       : VitalDelayType01 := VitalZeroDelay01;
        tipd_CASNeg       : VitalDelayType01 := VitalZeroDelay01;
        tipd_WENeg        : VitalDelayType01 := VitalZeroDelay01;
        tipd_BA0          : VitalDelayType01 := VitalZeroDelay01;
        tipd_BA1          : VitalDelayType01 := VitalZeroDelay01;
        tipd_BA2          : VitalDelayType01 := VitalZeroDelay01;
        tipd_A0           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A1           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A2           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A3           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A4           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A5           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A6           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A7           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A8           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A9           : VitalDelayType01 := VitalZeroDelay01;
        tipd_A10          : VitalDelayType01 := VitalZeroDelay01;
        tipd_A11          : VitalDelayType01 := VitalZeroDelay01;
        tipd_A12          : VitalDelayType01 := VitalZeroDelay01;
        tipd_A13          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ0          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ1          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ2          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ3          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ4          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ5          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ6          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQ7          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQS          : VitalDelayType01 := VitalZeroDelay01;
        tipd_DQSNeg       : VitalDelayType01 := VitalZeroDelay01;
        tipd_RDQS         : VitalDelayType01 := VitalZeroDelay01;
        tipd_RDQSNeg      : VitalDelayType01 := VitalZeroDelay01;

        -- tpd delays
        tpd_CK_DQ0        : VitalDelayType01Z := UnitDelay01Z; -- tAC(max), tHZ
        tpd_CK_DQ1        : VitalDelayType := UnitDelay; -- tAC(min)
        tpd_CK_DQS        : VitalDelayType01Z := UnitDelay01Z; -- tDQSCK(max)

        -- tsetup values
        tsetup_DQ0_DQS    : VitalDelayType := UnitDelay; -- tDSb
        tsetup_A0_CK      : VitalDelayType := UnitDelay; -- tISb
        tsetup_DQS_CK_CL3_negedge_posedge: VitalDelayType := UnitDelay; -- tDSS
        tsetup_DQS_CK_CL4_negedge_posedge: VitalDelayType := UnitDelay; -- tDSS
        tsetup_DQS_CK_CL5_negedge_posedge: VitalDelayType := UnitDelay; -- tDSS
        tsetup_DQS_CK_CL6_negedge_posedge: VitalDelayType := UnitDelay; -- tDSS

        -- thold values
        thold_DQ0_DQS     : VitalDelayType := UnitDelay; -- tDHb
        thold_A0_CK       : VitalDelayType := UnitDelay; -- tIHb
        thold_DQS_CK_CL3_posedge_posedge : VitalDelayType := UnitDelay; -- tDSH
        thold_DQS_CK_CL4_posedge_posedge : VitalDelayType := UnitDelay; -- tDSH
        thold_DQS_CK_CL5_posedge_posedge : VitalDelayType := UnitDelay; -- tDSH
        thold_DQS_CK_CL6_posedge_posedge : VitalDelayType := UnitDelay; -- tDSH

        -- tpw values
        tpw_CK_CL3_posedge: VitalDelayType := UnitDelay; -- tCHAVG
        tpw_CK_CL3_negedge: VitalDelayType := UnitDelay; -- tCLAVG
        tpw_CK_CL4_posedge: VitalDelayType := UnitDelay; -- tCHAVG
        tpw_CK_CL4_negedge: VitalDelayType := UnitDelay; -- tCLAVG
        tpw_CK_CL5_posedge: VitalDelayType := UnitDelay; -- tCHAVG
        tpw_CK_CL5_negedge: VitalDelayType := UnitDelay; -- tCLAVG
        tpw_CK_CL6_posedge: VitalDelayType := UnitDelay; -- tCHAVG
        tpw_CK_CL6_negedge: VitalDelayType := UnitDelay; -- tCLAVG
        tpw_A0_CL3        : VitalDelayType := UnitDelay; -- tIPW
        tpw_A0_CL4        : VitalDelayType := UnitDelay; -- tIPW
        tpw_A0_CL5        : VitalDelayType := UnitDelay; -- tIPW
        tpw_A0_CL6        : VitalDelayType := UnitDelay; -- tIPW
        tpw_DQ0_CL3       : VitalDelayType := UnitDelay; -- tDIPW
        tpw_DQ0_CL4       : VitalDelayType := UnitDelay; -- tDIPW
        tpw_DQ0_CL5       : VitalDelayType := UnitDelay; -- tDIPW
        tpw_DQ0_CL6       : VitalDelayType := UnitDelay; -- tDIPW
        tpw_DQS_normCL3_posedge : VitalDelayType := UnitDelay; -- tDQSH
        tpw_DQS_normCL3_negedge : VitalDelayType := UnitDelay; -- tDQSL
        tpw_DQS_normCL4_posedge : VitalDelayType := UnitDelay; -- tDQSH
        tpw_DQS_normCL4_negedge : VitalDelayType := UnitDelay; -- tDQSL
        tpw_DQS_normCL5_posedge : VitalDelayType := UnitDelay; -- tDQSH
        tpw_DQS_normCL5_negedge : VitalDelayType := UnitDelay; -- tDQSL
        tpw_DQS_normCL6_posedge : VitalDelayType := UnitDelay; -- tDQSH
        tpw_DQS_normCL6_negedge : VitalDelayType := UnitDelay; -- tDQSL
        tpw_DQS_preCL3_negedge  : VitalDelayType := UnitDelay; -- tWPRE
        tpw_DQS_preCL4_negedge  : VitalDelayType := UnitDelay; -- tWPRE
        tpw_DQS_preCL5_negedge  : VitalDelayType := UnitDelay; -- tWPRE
        tpw_DQS_preCL6_negedge  : VitalDelayType := UnitDelay; -- tWPRE
        tpw_DQS_postCL3_negedge : VitalDelayType := UnitDelay; -- tWPST
        tpw_DQS_postCL4_negedge : VitalDelayType := UnitDelay; -- tWPST
        tpw_DQS_postCL5_negedge : VitalDelayType := UnitDelay; -- tWPST
        tpw_DQS_postCL6_negedge : VitalDelayType := UnitDelay; -- tWPST

        -- tperiod values
        tperiod_CK_CL3    : VitalDelayType := UnitDelay; -- tCKAVG(min)
        tperiod_CK_CL4    : VitalDelayType := UnitDelay; -- tCKAVG(min)
        tperiod_CK_CL5    : VitalDelayType := UnitDelay; -- tCKAVG(min)
        tperiod_CK_CL6    : VitalDelayType := UnitDelay; -- tCKAVG(min)

        -- tskew values
        tskew_CK_DQS_CL3_posedge_posedge: VitalDelayType := UnitDelay; -- tDQSS
        tskew_CK_DQS_CL4_posedge_posedge: VitalDelayType := UnitDelay; -- tDQSS
        tskew_CK_DQS_CL5_posedge_posedge: VitalDelayType := UnitDelay; -- tDQSS
        tskew_CK_DQS_CL6_posedge_posedge: VitalDelayType := UnitDelay; -- tDQSS

        -- tdevice values: values for internal delays
        tdevice_tRC       : VitalDelayType    := 54 ns; -- tRC
        tdevice_tRRD      : VitalDelayType    := 10 ns; -- tRRD
        tdevice_tRCD      : VitalDelayType    := 12 ns; -- tRCD
        tdevice_tFAW      : VitalDelayType    := 50 ns; -- tFAW
        tdevice_tRASMIN   : VitalDelayType    := 40 ns; -- tRAS(min)
        tdevice_tRASMAX   : VitalDelayType    := 70 us; -- tRAS(max)
        tdevice_tRTP      : VitalDelayType    := 7.5 ns; -- tRTP
        tdevice_tWR       : VitalDelayType    := 15 ns; -- tWR
        tdevice_tWTR      : VitalDelayType    := 7.5 ns; -- tWTR
        tdevice_tRP       : VitalDelayType    := 12 ns; -- tRP
        tdevice_tRFCMIN   : VitalDelayType    := 127.5 ns; -- tRFC(min)
        tdevice_tRFCMAX   : VitalDelayType    := 70 us; -- tRFC(max)
        tdevice_REFPer    : VitalDelayType    := 64 ms; -- refresh period
        tdevice_tCKAVGMAX : VitalDelayType    := 8 ns; -- tCKAVG(max)

        -- generic control parameters
        InstancePath      : string    := DefaultInstancePath;
        TimingChecksOn    : boolean   := DefaultTimingChecks;
        MsgOn             : boolean   := DefaultMsgOn;
        XOn               : boolean   := DefaultXon;

        -- memory file to be loaded
        mem_file_name     : string    := "none";
        UserPreload       : boolean   := FALSE;

        -- For FMF SDF technology file usage
        TimingModel       : string    := DefaultTimingModel
    );
    PORT (
        ODT             : IN    std_ulogic := 'U';
        CK              : IN    std_ulogic := 'U';
        CKNeg           : IN    std_ulogic := 'U';
        CKE             : IN    std_ulogic := 'U';
        CSNeg           : IN    std_ulogic := 'U';
        RASNeg          : IN    std_ulogic := 'U';
        CASNeg          : IN    std_ulogic := 'U';
        WENeg           : IN    std_ulogic := 'U';
        BA0             : IN    std_ulogic := 'U';
        BA1             : IN    std_ulogic := 'U';
        BA2             : IN    std_ulogic := 'U';
        A0              : IN    std_ulogic := 'U';
        A1              : IN    std_ulogic := 'U';
        A2              : IN    std_ulogic := 'U';
        A3              : IN    std_ulogic := 'U';
        A4              : IN    std_ulogic := 'U';
        A5              : IN    std_ulogic := 'U';
        A6              : IN    std_ulogic := 'U';
        A7              : IN    std_ulogic := 'U';
        A8              : IN    std_ulogic := 'U';
        A9              : IN    std_ulogic := 'U';
        A10             : IN    std_ulogic := 'U';
        A11             : IN    std_ulogic := 'U';
        A12             : IN    std_ulogic := 'U';
        A13             : IN    std_ulogic := 'U';
        DQ0             : INOUT std_ulogic := 'U';
        DQ1             : INOUT std_ulogic := 'U';
        DQ2             : INOUT std_ulogic := 'U';
        DQ3             : INOUT std_ulogic := 'U';
        DQ4             : INOUT std_ulogic := 'U';
        DQ5             : INOUT std_ulogic := 'U';
        DQ6             : INOUT std_ulogic := 'U';
        DQ7             : INOUT std_ulogic := 'U';
        RDQS            : INOUT std_ulogic := 'U';
        RDQSNeg         : OUT   std_ulogic := 'U';
        DQS             : INOUT std_ulogic := 'U';
        DQSNeg          : INOUT std_ulogic := 'U'
    );
    ATTRIBUTE VITAL_LEVEL0 OF mt47h128m8 : ENTITY IS TRUE;
END mt47h128m8;

--------------------------------------------------------------------------------
-- ARCHITECTURE DECLARATION
--------------------------------------------------------------------------------
ARCHITECTURE vhdl_behavioral OF mt47h128m8 IS
    ATTRIBUTE VITAL_LEVEL0 OF vhdl_behavioral : ARCHITECTURE IS TRUE;

    CONSTANT PartID         : string := "MT47H128M8";
    CONSTANT BankNum        : natural := 7;
    CONSTANT MaxData        : natural := 16#FF#;
    CONSTANT MemSize        : natural := 16#FFFFFF#;
    CONSTANT RowNum         : natural := 16#3FFF#;
    CONSTANT ColNum         : natural := 16#3FF#;

    -- ipd
    SIGNAL ODT_ipd          : std_ulogic := 'U';
    SIGNAL CK_ipd           : std_ulogic := 'U';
    SIGNAL CKNeg_ipd        : std_ulogic := 'U';
    SIGNAL CKE_ipd          : std_ulogic := 'U';
    SIGNAL CSNeg_ipd        : std_ulogic := 'U';
    SIGNAL RASNeg_ipd       : std_ulogic := 'U';
    SIGNAL CASNeg_ipd       : std_ulogic := 'U';
    SIGNAL WENeg_ipd        : std_ulogic := 'U';
    SIGNAL BA0_ipd          : std_ulogic := 'U';
    SIGNAL BA1_ipd          : std_ulogic := 'U';
    SIGNAL BA2_ipd          : std_ulogic := 'U';
    SIGNAL A0_ipd           : std_ulogic := 'U';
    SIGNAL A1_ipd           : std_ulogic := 'U';
    SIGNAL A2_ipd           : std_ulogic := 'U';
    SIGNAL A3_ipd           : std_ulogic := 'U';
    SIGNAL A4_ipd           : std_ulogic := 'U';
    SIGNAL A5_ipd           : std_ulogic := 'U';
    SIGNAL A6_ipd           : std_ulogic := 'U';
    SIGNAL A7_ipd           : std_ulogic := 'U';
    SIGNAL A8_ipd           : std_ulogic := 'U';
    SIGNAL A9_ipd           : std_ulogic := 'U';
    SIGNAL A10_ipd          : std_ulogic := 'U';
    SIGNAL A11_ipd          : std_ulogic := 'U';
    SIGNAL A12_ipd          : std_ulogic := 'U';
    SIGNAL A13_ipd          : std_ulogic := 'U';
    SIGNAL DQ0_ipd          : std_ulogic := 'U';
    SIGNAL DQ1_ipd          : std_ulogic := 'U';
    SIGNAL DQ2_ipd          : std_ulogic := 'U';
    SIGNAL DQ3_ipd          : std_ulogic := 'U';
    SIGNAL DQ4_ipd          : std_ulogic := 'U';
    SIGNAL DQ5_ipd          : std_ulogic := 'U';
    SIGNAL DQ6_ipd          : std_ulogic := 'U';
    SIGNAL DQ7_ipd          : std_ulogic := 'U';
    SIGNAL RDQS_ipd         : std_ulogic := 'U';
    SIGNAL DQS_ipd          : std_ulogic := 'U';
    SIGNAL DQSNeg_ipd       : std_ulogic := 'U';

    -- nwv
    SIGNAL ODT_nwv          : std_ulogic := 'U';
    SIGNAL CK_nwv           : std_ulogic := 'U';
    SIGNAL CKNeg_nwv        : std_ulogic := 'U';
    SIGNAL CKE_nwv          : std_ulogic := 'U';
    SIGNAL CSNeg_nwv        : std_ulogic := 'U';
    SIGNAL RASNeg_nwv       : std_ulogic := 'U';
    SIGNAL CASNeg_nwv       : std_ulogic := 'U';
    SIGNAL WENeg_nwv        : std_ulogic := 'U';
    SIGNAL BA0_nwv          : std_ulogic := 'U';
    SIGNAL BA1_nwv          : std_ulogic := 'U';
    SIGNAL BA2_nwv          : std_ulogic := 'U';
    SIGNAL A0_nwv           : std_ulogic := 'U';
    SIGNAL A1_nwv           : std_ulogic := 'U';
    SIGNAL A2_nwv           : std_ulogic := 'U';
    SIGNAL A3_nwv           : std_ulogic := 'U';
    SIGNAL A4_nwv           : std_ulogic := 'U';
    SIGNAL A5_nwv           : std_ulogic := 'U';
    SIGNAL A6_nwv           : std_ulogic := 'U';
    SIGNAL A7_nwv           : std_ulogic := 'U';
    SIGNAL A8_nwv           : std_ulogic := 'U';
    SIGNAL A9_nwv           : std_ulogic := 'U';
    SIGNAL A10_nwv          : std_ulogic := 'U';
    SIGNAL A11_nwv          : std_ulogic := 'U';
    SIGNAL A12_nwv          : std_ulogic := 'U';
    SIGNAL A13_nwv          : std_ulogic := 'U';
    SIGNAL DQ0_nwv          : std_ulogic := 'U';
    SIGNAL DQ1_nwv          : std_ulogic := 'U';
    SIGNAL DQ2_nwv          : std_ulogic := 'U';
    SIGNAL DQ3_nwv          : std_ulogic := 'U';
    SIGNAL DQ4_nwv          : std_ulogic := 'U';
    SIGNAL DQ5_nwv          : std_ulogic := 'U';
    SIGNAL DQ6_nwv          : std_ulogic := 'U';
    SIGNAL DQ7_nwv          : std_ulogic := 'U';
    SIGNAL RDQS_nwv         : std_ulogic := 'U';
    SIGNAL DQS_nwv          : std_ulogic := 'U';
    SIGNAL DQSNeg_nwv       : std_ulogic := 'U';

    ---  internal delays
    SIGNAL tRC_in      : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tRC_out     : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tRRD_in          : std_ulogic := '1';
    SIGNAL tRRD_out         : std_ulogic := '1';
    SIGNAL tRCD_in     : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '0');
    SIGNAL tRCD_out    : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '0');
    SIGNAL tFAW_in          : std_ulogic_vector(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tFAW_out         : std_ulogic_vector(3 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tRASMIN_in  : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tRASMIN_out : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tRASMAX_in  : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '0');
    SIGNAL tRASMAX_out : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '0');
    SIGNAL tRTP_in     : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tRTP_out    : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tWR_in      : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tWR_out     : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tWTR_in     : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tWTR_out    : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '1');
    SIGNAL tRP_in      : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '0');
    SIGNAL tRP_out     : std_ulogic_vector(BankNum DOWNTO 0) := (OTHERS => '0');
    SIGNAL tRFCMIN_in       : std_ulogic := '0';
    SIGNAL tRFCMIN_out      : std_ulogic := '0';
    SIGNAL tRFCMAX_in       : std_ulogic := '0';
    SIGNAL tRFCMAX_out      : std_ulogic := '0';
    SIGNAL tXSNR_in         : std_ulogic := '0';
    SIGNAL tXSNR_out        : std_ulogic := '0';
    SIGNAL REFPer_in        : std_ulogic := '0';
    SIGNAL REFPer_out       : std_ulogic := '0';
    SIGNAL tCKAVGMAX_in     : std_ulogic := '0';
    SIGNAL tCKAVGMAX_out    : std_ulogic := '0';
    SIGNAL tWPSTMAX_in      : std_ulogic := '0';
    SIGNAL tWPSTMAX_out     : std_ulogic := '0';

BEGIN

    ----------------------------------------------------------------------------
    -- Internal Delays
    ----------------------------------------------------------------------------
    TRC      : VitalBuf(tRC_out(0),  tRC_in(0),  (tdevice_tRC - 1 ns,
                                                                    UnitDelay));
    TRC1     : VitalBuf(tRC_out(1),  tRC_in(1),  (tdevice_tRC - 1 ns,
                                                                    UnitDelay));
    TRC2     : VitalBuf(tRC_out(2),  tRC_in(2),  (tdevice_tRC - 1 ns,
                                                                    UnitDelay));
    TRC3     : VitalBuf(tRC_out(3),  tRC_in(3),  (tdevice_tRC - 1 ns,
                                                                    UnitDelay));
    TRC4     : VitalBuf(tRC_out(4),  tRC_in(4),  (tdevice_tRC - 1 ns,
                                                                    UnitDelay));
    TRC5     : VitalBuf(tRC_out(5),  tRC_in(5),  (tdevice_tRC - 1 ns,
                                                                    UnitDelay));
    TRC6     : VitalBuf(tRC_out(6),  tRC_in(6),  (tdevice_tRC - 1 ns,
                                                                    UnitDelay));
    TRC7     : VitalBuf(tRC_out(7),  tRC_in(7),  (tdevice_tRC - 1 ns,
                                                                    UnitDelay));
    TRRD     : VitalBuf(tRRD_out,    tRRD_in,    (tdevice_tRRD - 1 ns,
                                                                    UnitDelay));
    TRCD     : VitalBuf(tRCD_out(0), tRCD_in(0), (tdevice_tRCD - 1 ns,
                                                                    UnitDelay));
    TRCD1    : VitalBuf(tRCD_out(1), tRCD_in(1), (tdevice_tRCD - 1 ns,
                                                                    UnitDelay));
    TRCD2    : VitalBuf(tRCD_out(2), tRCD_in(2), (tdevice_tRCD - 1 ns,
                                                                    UnitDelay));
    TRCD3    : VitalBuf(tRCD_out(3), tRCD_in(3), (tdevice_tRCD - 1 ns,
                                                                    UnitDelay));
    TRCD4    : VitalBuf(tRCD_out(4), tRCD_in(4), (tdevice_tRCD - 1 ns,
                                                                    UnitDelay));
    TRCD5    : VitalBuf(tRCD_out(5), tRCD_in(5), (tdevice_tRCD - 1 ns,
                                                                    UnitDelay));
    TRCD6    : VitalBuf(tRCD_out(6), tRCD_in(6), (tdevice_tRCD - 1 ns,
                                                                    UnitDelay));
    TRCD7    : VitalBuf(tRCD_out(7), tRCD_in(7), (tdevice_tRCD - 1 ns,
                                                                    UnitDelay));
    TFAW     : VitalBuf(tFAW_out(0), tFAW_in(0), (tdevice_tFAW - 2 ns,
                                                                    UnitDelay));
    TFAW1    : VitalBuf(tFAW_out(1), tFAW_in(1), (tdevice_tFAW - 2 ns,
                                                                    UnitDelay));
    TFAW2    : VitalBuf(tFAW_out(2), tFAW_in(2), (tdevice_tFAW - 2 ns,
                                                                    UnitDelay));
    TFAW3    : VitalBuf(tFAW_out(3), tFAW_in(3), (tdevice_tFAW - 2 ns,
                                                                    UnitDelay));
    TRASMIN  : VitalBuf(tRASMIN_out(0), tRASMIN_in(0), (tdevice_tRASMIN - 1 ns,
                                                                    UnitDelay));
    TRASMIN1 : VitalBuf(tRASMIN_out(1), tRASMIN_in(1), (tdevice_tRASMIN - 1 ns,
                                                                    UnitDelay));
    TRASMIN2 : VitalBuf(tRASMIN_out(2), tRASMIN_in(2), (tdevice_tRASMIN - 1 ns,
                                                                    UnitDelay));
    TRASMIN3 : VitalBuf(tRASMIN_out(3), tRASMIN_in(3), (tdevice_tRASMIN - 1 ns,
                                                                    UnitDelay));
    TRASMIN4 : VitalBuf(tRASMIN_out(4), tRASMIN_in(4), (tdevice_tRASMIN - 1 ns,
                                                                    UnitDelay));
    TRASMIN5 : VitalBuf(tRASMIN_out(5), tRASMIN_in(5), (tdevice_tRASMIN - 1 ns,
                                                                    UnitDelay));
    TRASMIN6 : VitalBuf(tRASMIN_out(6), tRASMIN_in(6), (tdevice_tRASMIN - 1 ns,
                                                                    UnitDelay));
    TRASMIN7 : VitalBuf(tRASMIN_out(7), tRASMIN_in(7), (tdevice_tRASMIN - 1 ns,
                                                                    UnitDelay));
    TRASMAX  : VitalBuf(tRASMAX_out(0), tRASMAX_in(0), (tdevice_tRASMAX - 1 ns,
                                                                    UnitDelay));
    TRASMAX1 : VitalBuf(tRASMAX_out(1), tRASMAX_in(1), (tdevice_tRASMAX - 1 ns,
                                                                    UnitDelay));
    TRASMAX2 : VitalBuf(tRASMAX_out(2), tRASMAX_in(2), (tdevice_tRASMAX - 1 ns,
                                                                    UnitDelay));
    TRASMAX3 : VitalBuf(tRASMAX_out(3), tRASMAX_in(3), (tdevice_tRASMAX - 1 ns,
                                                                    UnitDelay));
    TRASMAX4 : VitalBuf(tRASMAX_out(4), tRASMAX_in(4), (tdevice_tRASMAX - 1 ns,
                                                                    UnitDelay));
    TRASMAX5 : VitalBuf(tRASMAX_out(5), tRASMAX_in(5), (tdevice_tRASMAX - 1 ns,
                                                                    UnitDelay));
    TRASMAX6 : VitalBuf(tRASMAX_out(6), tRASMAX_in(6), (tdevice_tRASMAX - 1 ns,
                                                                    UnitDelay));
    TRASMAX7 : VitalBuf(tRASMAX_out(7), tRASMAX_in(7), (tdevice_tRASMAX - 1 ns,
                                                                    UnitDelay));
    TRTP     : VitalBuf(tRTP_out(0), tRTP_in(0), (tdevice_tRTP - 1 ns,
                                                                    UnitDelay));
    TRTP1    : VitalBuf(tRTP_out(1), tRTP_in(1), (tdevice_tRTP - 1 ns,
                                                                    UnitDelay));
    TRTP2    : VitalBuf(tRTP_out(2), tRTP_in(2), (tdevice_tRTP - 1 ns,
                                                                    UnitDelay));
    TRTP3    : VitalBuf(tRTP_out(3), tRTP_in(3), (tdevice_tRTP - 1 ns,
                                                                    UnitDelay));
    TRTP4    : VitalBuf(tRTP_out(4), tRTP_in(4), (tdevice_tRTP - 1 ns,
                                                                    UnitDelay));
    TRTP5    : VitalBuf(tRTP_out(5), tRTP_in(5), (tdevice_tRTP - 1 ns,
                                                                    UnitDelay));
    TRTP6    : VitalBuf(tRTP_out(6), tRTP_in(6), (tdevice_tRTP - 1 ns,
                                                                    UnitDelay));
    TRTP7    : VitalBuf(tRTP_out(7), tRTP_in(7), (tdevice_tRTP - 1 ns,
                                                                    UnitDelay));
    TWR      : VitalBuf(tWR_out(0), tWR_in(0), (tdevice_tWR - 1 ns,
                                                                    UnitDelay));
    TWR1     : VitalBuf(tWR_out(1), tWR_in(1), (tdevice_tWR - 1 ns,
                                                                    UnitDelay));
    TWR2     : VitalBuf(tWR_out(2), tWR_in(2), (tdevice_tWR - 1 ns,
                                                                    UnitDelay));
    TWR3     : VitalBuf(tWR_out(3), tWR_in(3), (tdevice_tWR - 1 ns,
                                                                    UnitDelay));
    TWR4     : VitalBuf(tWR_out(4), tWR_in(4), (tdevice_tWR - 1 ns,
                                                                    UnitDelay));
    TWR5     : VitalBuf(tWR_out(5), tWR_in(5), (tdevice_tWR - 1 ns,
                                                                    UnitDelay));
    TWR6     : VitalBuf(tWR_out(6), tWR_in(6), (tdevice_tWR - 1 ns,
                                                                    UnitDelay));
    TWR7     : VitalBuf(tWR_out(7), tWR_in(7), (tdevice_tWR - 1 ns,
                                                                    UnitDelay));
    TWTR     : VitalBuf(tWTR_out(0), tWTR_in(0), (tdevice_tWTR - 1 ns,
                                                                    UnitDelay));
    TWTR1    : VitalBuf(tWTR_out(1), tWTR_in(1), (tdevice_tWTR - 1 ns,
                                                                    UnitDelay));
    TWTR2    : VitalBuf(tWTR_out(2), tWTR_in(2), (tdevice_tWTR - 1 ns,
                                                                    UnitDelay));
    TWTR3    : VitalBuf(tWTR_out(3), tWTR_in(3), (tdevice_tWTR - 1 ns,
                                                                    UnitDelay));
    TWTR4    : VitalBuf(tWTR_out(4), tWTR_in(4), (tdevice_tWTR - 1 ns,
                                                                    UnitDelay));
    TWTR5    : VitalBuf(tWTR_out(5), tWTR_in(5), (tdevice_tWTR - 1 ns,
                                                                    UnitDelay));
    TWTR6    : VitalBuf(tWTR_out(6), tWTR_in(6), (tdevice_tWTR - 1 ns,
                                                                    UnitDelay));
    TWTR7    : VitalBuf(tWTR_out(7), tWTR_in(7), (tdevice_tWTR - 1 ns,
                                                                    UnitDelay));
    TRP      : VitalBuf(tRP_out(0), tRP_in(0), (tdevice_tRP - 1 ns,
                                                                    UnitDelay));
    TRP1     : VitalBuf(tRP_out(1), tRP_in(1), (tdevice_tRP - 1 ns,
                                                                    UnitDelay));
    TRP2     : VitalBuf(tRP_out(2), tRP_in(2), (tdevice_tRP - 1 ns,
                                                                    UnitDelay));
    TRP3     : VitalBuf(tRP_out(3), tRP_in(3), (tdevice_tRP - 1 ns,
                                                                    UnitDelay));
    TRP4     : VitalBuf(tRP_out(4), tRP_in(4), (tdevice_tRP - 1 ns,
                                                                    UnitDelay));
    TRP5     : VitalBuf(tRP_out(5), tRP_in(5), (tdevice_tRP - 1 ns,
                                                                    UnitDelay));
    TRP6     : VitalBuf(tRP_out(6), tRP_in(6), (tdevice_tRP - 1 ns,
                                                                    UnitDelay));
    TRP7     : VitalBuf(tRP_out(7), tRP_in(7), (tdevice_tRP - 1 ns,
                                                                    UnitDelay));
    TRFCMIN  : VitalBuf(tRFCMIN_out, tRFCMIN_in, (tdevice_tRFCMIN - 1 ns,
                                                                    UnitDelay));
    TRFCMAX  : VitalBuf(tRFCMAX_out, tRFCMAX_in, (tdevice_tRFCMAX - 1 ns,
                                                                    UnitDelay));
    TXSNR    : VitalBuf(tXSNR_out,   tXSNR_in,   (tdevice_tRFCMIN + 9 ns,
                                                                    UnitDelay));
    REFPER   : VitalBuf(REFPer_out,  REFPer_in,  (tdevice_REFPer - 1 ns,
                                                                    UnitDelay));
    TCKAVGMAX: VitalBuf(tCKAVGMAX_out, tCKAVGMAX_in, (tdevice_tCKAVGMAX - 1 ns,
                                                                    UnitDelay));

    ----------------------------------------------------------------------------
    -- Wire Delays
    ----------------------------------------------------------------------------
    WireDelay : BLOCK
    BEGIN
        w_01 : VitalWireDelay (ODT_ipd, ODT, tipd_ODT);
        w_02 : VitalWireDelay (CK_ipd, CK, tipd_CK);
        w_03 : VitalWireDelay (CKNeg_ipd, CKNeg, tipd_CKNeg);
        w_04 : VitalWireDelay (CKE_ipd, CKE, tipd_CKE);
        w_05 : VitalWireDelay (CSNeg_ipd, CSNeg, tipd_CSNeg);
        w_06 : VitalWireDelay (RASNeg_ipd, RASNeg, tipd_RASNeg);
        w_07 : VitalWireDelay (CASNeg_ipd, CASNeg, tipd_CASNeg);
        w_08 : VitalWireDelay (WENeg_ipd, WENeg, tipd_WENeg);
        w_09 : VitalWireDelay (BA0_ipd, BA0, tipd_BA0);
        w_10 : VitalWireDelay (BA1_ipd, BA1, tipd_BA1);
        w_11 : VitalWireDelay (BA2_ipd, BA2, tipd_BA2);
        w_12 : VitalWireDelay (A0_ipd, A0, tipd_A0);
        w_13 : VitalWireDelay (A1_ipd, A1, tipd_A1);
        w_14 : VitalWireDelay (A2_ipd, A2, tipd_A2);
        w_15 : VitalWireDelay (A3_ipd, A3, tipd_A3);
        w_16 : VitalWireDelay (A4_ipd, A4, tipd_A4);
        w_17 : VitalWireDelay (A5_ipd, A5, tipd_A5);
        w_18 : VitalWireDelay (A6_ipd, A6, tipd_A6);
        w_19 : VitalWireDelay (A7_ipd, A7, tipd_A7);
        w_20 : VitalWireDelay (A8_ipd, A8, tipd_A8);
        w_21 : VitalWireDelay (A9_ipd, A9, tipd_A9);
        w_22 : VitalWireDelay (A10_ipd, A10, tipd_A10);
        w_23 : VitalWireDelay (A11_ipd, A11, tipd_A11);
        w_24 : VitalWireDelay (A12_ipd, A12, tipd_A12);
        w_25 : VitalWireDelay (A13_ipd, A13, tipd_A13);
        w_26 : VitalWireDelay (DQ0_ipd, DQ0, tipd_DQ0);
        w_27 : VitalWireDelay (DQ1_ipd, DQ1, tipd_DQ1);
        w_28 : VitalWireDelay (DQ2_ipd, DQ2, tipd_DQ2);
        w_29 : VitalWireDelay (DQ3_ipd, DQ3, tipd_DQ3);
        w_30 : VitalWireDelay (DQ4_ipd, DQ4, tipd_DQ4);
        w_31 : VitalWireDelay (DQ5_ipd, DQ5, tipd_DQ5);
        w_32 : VitalWireDelay (DQ6_ipd, DQ6, tipd_DQ6);
        w_33 : VitalWireDelay (DQ7_ipd, DQ7, tipd_DQ7);
        w_34 : VitalWireDelay (RDQS_ipd, RDQS, tipd_RDQS);
        w_35 : VitalWireDelay (DQS_ipd, DQS, tipd_DQS);
        w_36 : VitalWireDelay (DQSNeg_ipd, DQSNeg, tipd_DQSNeg);
    END BLOCK;

    ODT_nwv        <= To_UX01(ODT_ipd);
    CK_nwv         <= To_UX01(CK_ipd);
    CKNeg_nwv      <= To_UX01(CKNeg_ipd);
    CKE_nwv        <= To_UX01(CKE_ipd);
    CSNeg_nwv      <= To_UX01(CSNeg_ipd);
    RASNeg_nwv     <= To_UX01(RASNeg_ipd);
    CASNeg_nwv     <= To_UX01(CASNeg_ipd);
    WENeg_nwv      <= To_UX01(WENeg_ipd);
    BA0_nwv        <= To_UX01(BA0_ipd);
    BA1_nwv        <= To_UX01(BA1_ipd);
    BA2_nwv        <= To_UX01(BA2_ipd);
    A0_nwv         <= To_UX01(A0_ipd);
    A1_nwv         <= To_UX01(A1_ipd);
    A2_nwv         <= To_UX01(A2_ipd);
    A3_nwv         <= To_UX01(A3_ipd);
    A4_nwv         <= To_UX01(A4_ipd);
    A5_nwv         <= To_UX01(A5_ipd);
    A6_nwv         <= To_UX01(A6_ipd);
    A7_nwv         <= To_UX01(A7_ipd);
    A8_nwv         <= To_UX01(A8_ipd);
    A9_nwv         <= To_UX01(A9_ipd);
    A10_nwv        <= To_UX01(A10_ipd);
    A11_nwv        <= To_UX01(A11_ipd);
    A12_nwv        <= To_UX01(A12_ipd);
    A13_nwv        <= To_UX01(A13_ipd);
    DQ0_nwv        <= To_UX01(DQ0_ipd);
    DQ1_nwv        <= To_UX01(DQ1_ipd);
    DQ2_nwv        <= To_UX01(DQ2_ipd);
    DQ3_nwv        <= To_UX01(DQ3_ipd);
    DQ4_nwv        <= To_UX01(DQ4_ipd);
    DQ5_nwv        <= To_UX01(DQ5_ipd);
    DQ6_nwv        <= To_UX01(DQ6_ipd);
    DQ7_nwv        <= To_UX01(DQ7_ipd);
    RDQS_nwv       <= To_UX01(RDQS_ipd);
    DQS_nwv        <= To_UX01(DQS_ipd);
    DQSNeg_nwv     <= To_UX01(DQSNeg_ipd);

    ----------------------------------------------------------------------------
    -- Main Behavior Block
    ----------------------------------------------------------------------------
    Behavior: BLOCK

        PORT (
            ODT            : IN    std_ulogic := 'U';
            CK             : IN    std_ulogic := 'U';
            CKNeg          : IN    std_ulogic := 'U';
            CKE            : IN    std_ulogic := 'U';
            CSNeg          : IN    std_ulogic := 'U';
            RASNeg         : IN    std_ulogic := 'U';
            CASNeg         : IN    std_ulogic := 'U';
            WENeg          : IN    std_ulogic := 'U';
            DM             : IN    std_ulogic := 'U';
            BAIn           : IN    std_logic_vector(2 DOWNTO 0) :=
                                               (OTHERS => 'U');
            AIn            : IN    std_logic_vector(13 DOWNTO 0) :=
                                               (OTHERS => 'U');
            DQIn           : IN    std_logic_vector(7 DOWNTO 0) :=
                                               (OTHERS => 'U');
            DQOut          : OUT   std_ulogic_vector(7 DOWNTO 0) :=
                                               (OTHERS => 'Z');
            RDQSOut        : OUT   std_ulogic := 'Z';
            RDQSNegOut     : OUT   std_ulogic := 'Z';
            DQSIn          : IN    std_ulogic := 'U';
            DQSOut         : OUT   std_ulogic := 'Z';
            DQSNegIn       : IN    std_ulogic := 'U';
            DQSNegOut      : OUT   std_ulogic := 'Z'
        );

        PORT MAP (
            ODT       => ODT_nwv,
            CK        => CK_nwv,
            CKNeg     => CKNeg_nwv,
            CKE       => CKE_nwv,
            CSNeg     => CSNeg_nwv,
            RASNeg    => RASNeg_nwv,
            CASNeg    => CASNeg_nwv,
            WENeg     => WENeg_nwv,
            DM        => RDQS_nwv,
            BAIn(0)   => BA0_nwv,
            BAIn(1)   => BA1_nwv,
            BAIn(2)   => BA2_nwv,
            AIn(0)    => A0_nwv,
            AIn(1)    => A1_nwv,
            AIn(2)    => A2_nwv,
            AIn(3)    => A3_nwv,
            AIn(4)    => A4_nwv,
            AIn(5)    => A5_nwv,
            AIn(6)    => A6_nwv,
            AIn(7)    => A7_nwv,
            AIn(8)    => A8_nwv,
            AIn(9)    => A9_nwv,
            AIn(10)   => A10_nwv,
            AIn(11)   => A11_nwv,
            AIn(12)   => A12_nwv,
            AIn(13)   => A13_nwv,
            DQIn(0)   => DQ0_nwv,
            DQIn(1)   => DQ1_nwv,
            DQIn(2)   => DQ2_nwv,
            DQIn(3)   => DQ3_nwv,
            DQIn(4)   => DQ4_nwv,
            DQIn(5)   => DQ5_nwv,
            DQIn(6)   => DQ6_nwv,
            DQIn(7)   => DQ7_nwv,
            DQOut(0)  => DQ0,
            DQOut(1)  => DQ1,
            DQOut(2)  => DQ2,
            DQOut(3)  => DQ3,
            DQOut(4)  => DQ4,
            DQOut(5)  => DQ5,
            DQOut(6)  => DQ6,
            DQOut(7)  => DQ7,
            RDQSOut   => RDQS,
            RDQSNegOut=> RDQSNeg,
            DQSIn     => DQS_nwv,
            DQSOut    => DQS,
            DQSNegIn  => DQSNeg_nwv,
            DQSNegOut => DQSNeg
        );

        --zero delay signals
        SIGNAL DQOut_zd : std_logic_vector(7 DOWNTO 0) := (OTHERS => 'Z');
        SIGNAL DQSOut_zd : std_logic := 'Z';
        SIGNAL DQSNegOut_zd : std_logic := 'Z';

        --differential inputs
        SIGNAL CKDiff : std_logic := 'Z';
        SIGNAL RDQSDiff : std_logic := 'Z';
        SIGNAL DQSDiff  : std_logic := 'Z';

        --DLL implementation
        SIGNAL CKPeriod : time := 3 ns;
        SIGNAL CKInt : std_ulogic := '0';
        SIGNAL CKtemp : std_ulogic := '1';
        SIGNAL CKHalfPer : time := 0 ns;
        SIGNAL CKDLLDelay: time := 0 ns;

        SIGNAL CK_stable : boolean := FALSE;
        SIGNAL PoweredUp : boolean := FALSE;
        SIGNAL In_d : boolean := FALSE;      --delay before first precharge all
        SIGNAL Init_delay : boolean := FALSE;--command during initialization
        SIGNAL Initialized : boolean := FALSE;--initialization completed
        SIGNAL DLL_delay : std_logic := '0';       --delay between DLL
        SIGNAL DLL_delay_elapsed : boolean := TRUE;--reset and read command
        SIGNAL In_data : std_ulogic := '0';--start of write operation
        SIGNAL preamble_gen : std_logic := 'Z';--preamble before read operation
        SIGNAL Out_data : std_logic := 'Z';--start of read operation

        -- timing check violation
        SIGNAL Viol : X01 := '0';

        --burst sequences
        TYPE sequence IS ARRAY (0 TO 7) OF integer RANGE -7 TO 7;
        TYPE seqtab   IS ARRAY (0 TO 7) OF sequence;
        CONSTANT seq0 : sequence := (0, 1, 2, 3, 4, 5, 6, 7);
        CONSTANT seq1 : sequence := (0, 1, 2,-1, 4, 5, 6, 3);
        CONSTANT seq2 : sequence := (0, 1,-2,-1, 4, 5, 2, 3);
        CONSTANT seq3 : sequence := (0,-3,-2,-1, 4, 1, 2, 3);
        CONSTANT seq4 : sequence := (0, 1, 2, 3,-4,-3,-2,-1);
        CONSTANT seq5 : sequence := (0, 1, 2,-1,-4,-3,-2,-5);
        CONSTANT seq6 : sequence := (0, 1,-2,-1,-4,-3,-6,-5);
        CONSTANT seq7 : sequence := (0,-3,-2,-1,-4,-7,-6,-5);
        CONSTANT seq  : seqtab   := (seq0, seq1, seq2, seq3, seq4, seq5, seq6,
                                     seq7);
        CONSTANT inl0 : sequence := (0, 1, 2, 3, 4, 5, 6, 7);
        CONSTANT inl1 : sequence := (0,-1, 2, 1, 4, 3, 6, 5);
        CONSTANT inl2 : sequence := (0, 1,-2,-1, 4, 5, 2, 3);
        CONSTANT inl3 : sequence := (0,-1,-2,-3, 4, 3, 2, 1);
        CONSTANT inl4 : sequence := (0, 1, 2, 3,-4,-3,-2,-1);
        CONSTANT inl5 : sequence := (0,-1, 2, 1,-4,-5,-2,-3);
        CONSTANT inl6 : sequence := (0, 1,-2,-1,-4,-3,-6,-5);
        CONSTANT inl7 : sequence := (0,-1,-2,-3,-4,-5,-6,-7);
        CONSTANT inl  : seqtab   := (inl0, inl1, inl2, inl3, inl4, inl5, inl6,
                               inl7);

        --memory definition
        TYPE MemStore IS ARRAY (0 TO MemSize) OF integer RANGE -2 TO MaxData;
        TYPE MemBlock IS ARRAY (0 TO BankNum) OF MemStore;
        SHARED VARIABLE Mem    : MemBlock;

        --mode registers
        SHARED VARIABLE MR : std_logic_vector(12 DOWNTO 0) := (OTHERS => '0');
        SHARED VARIABLE EMR : std_logic_vector(12 DOWNTO 0);
        SHARED VARIABLE EMR2 : std_logic_vector(12 DOWNTO 0);
        SHARED VARIABLE EMR3 : std_logic_vector(12 DOWNTO 0);

        SHARED VARIABLE burst_len : natural RANGE 4 TO 8;--burst length

        SHARED VARIABLE active_forbid : boolean := FALSE;--more than 4 active
                                                         --commands during tFAW

        --bank, row and column of scheduled read or write operation
        SHARED VARIABLE current_bank : natural RANGE 0 TO BankNum;
        SHARED VARIABLE current_row : natural RANGE 0 TO RowNum;
        SHARED VARIABLE current_column : natural RANGE 0 TO ColNum;

        --bank, row and column of read operation that starts
        SHARED VARIABLE read_bank : natural RANGE 0 TO BankNum;
        SHARED VARIABLE read_row : natural RANGE 0 TO RowNum;
        SHARED VARIABLE read_column : natural RANGE 0 TO ColNum;

        TYPE write_sch_type IS ARRAY (0 TO 10) OF boolean;
        TYPE write_sch_bank_type IS ARRAY (0 TO BankNum) OF write_sch_type;
        --all scheduled reads within all banks
        SHARED VARIABLE read_sch : write_sch_bank_type :=
                                                  (OTHERS => (OTHERS => FALSE));
        --reads that should be preceeded by preamble
        SHARED VARIABLE preamble : write_sch_bank_type :=
                                                  (OTHERS => (OTHERS => TRUE));

        TYPE wait_read_type IS ARRAY (0 TO 10) OF std_ulogic;
        TYPE wait_read_bank_type IS ARRAY (0 TO BankNum) OF wait_read_type;
        --wait_read triggers process that counts remaining cycles to the
        --beggining of scheduled read when aditive latency has elapsed, and
        --read_delay keeps information of number of remaining cycles
        SIGNAL wait_read : wait_read_bank_type;
        SHARED VARIABLE read_delay : natural RANGE 0 TO 7;

        --needed for check if all rows were refreshed during refresh period
        SIGNAL Ref_per_start : std_ulogic := '0';
        SIGNAL Ref_per_expired : std_ulogic := '0';

        SHARED VARIABLE CK_rise : time := 0 ns;
        SHARED VARIABLE CK_period : time := 0 ns;

        TYPE Bank_state_type IS (precharged, refreshing, MRsetting, activating,
                                 active, reading, readingAP, writting,
                                 writtingAP, precharging, prechall);
        TYPE Bank_state_array_type IS ARRAY (0 TO BankNum) OF Bank_state_type;
        SHARED VARIABLE Curr_bank_state : Bank_state_array_type;
        SHARED VARIABLE Next_bank_state : Bank_state_array_type;

        SHARED VARIABLE SR_cond : boolean := FALSE;--self refresh can be entered
        SIGNAL SelfRefresh : boolean := FALSE;--self refresh active
        SIGNAL SR_exit : boolean := FALSE;--CKE high, self refresh exit
        SHARED VARIABLE SR_enter_cycle : boolean := FALSE;--clock can be
                                                          --turned off

        SIGNAL Pre_PD : boolean := FALSE;--precharge power down active
        SIGNAL Act_PD : boolean := FALSE;--active power down active
        SHARED VARIABLE Read_Start : boolean := FALSE;--read burst in progress,
        SIGNAL ReadStart : boolean := FALSE;          --no pd entry

        SIGNAL Reset : boolean := FALSE;--reset function active
        SHARED VARIABLE Reset_enter_cycle : boolean := FALSE;--clocks can be
                                                             --turned off

        SIGNAL SimulationEnd : boolean := FALSE;

        SIGNAL preamble_check : boolean := FALSE;
        SIGNAL postamble_check : boolean := FALSE;
        SIGNAL skew_check : boolean := FALSE;

        FUNCTION bool_to_nat(tm : boolean)
        RETURN natural IS
            VARIABLE Temp : natural;
        BEGIN
            Temp := 0;
            IF tm THEN
                Temp := 1;
            END IF;
            RETURN Temp;
        END bool_to_nat;

    BEGIN

    CK_DLL: PROCESS(CKDiff)
        VARIABLE Previous : time := 0 ns;
        VARIABLE TmpPer : time := 0 ns;
    BEGIN
        IF rising_edge(CKDiff) THEN
            TmpPer := NOW - Previous;
            IF TmpPer > 0 ns THEN
                CKPeriod <= TmpPer;
            END IF;
            Previous := NOW;
            CKHalfPer <= CKPeriod / 2;
            CKDLLDelay <= CKPeriod - tpd_CK_DQ1;
        END IF;
    END PROCESS CK_DLL;

    CK_temp: PROCESS(CKDiff) -- generating internal clock from DLL
    BEGIN
        CKtemp <= NOT CKDiff AFTER CKHalfPer;
    END PROCESS CK_temp;

    CKInt <= TRANSPORT CKtemp AFTER CKDLLDelay;

    Power_up: PROCESS(CK_stable)
    BEGIN
        IF CK_stable THEN
            PoweredUp <= TRUE AFTER 200 us;
        END IF;
    END PROCESS Power_up;

    Init_d: PROCESS(In_d)
    BEGIN
        IF In_d THEN
            Init_delay <= TRUE AFTER 400 ns;
        ELSE
            Init_delay <= FALSE;
        END IF;
    END PROCESS Init_d;

    DLLdelay: PROCESS(DLL_delay, CKDiff)
        VARIABLE cnt : natural;
    BEGIN
        IF rising_edge(DLL_delay) THEN
            cnt := 0;
            DLL_delay_elapsed <= FALSE;
        ELSIF rising_edge(CKDiff) AND NOT DLL_delay_elapsed THEN
            cnt := cnt + 1;
            IF cnt = 199 THEN
                DLL_delay_elapsed <= TRUE;
            END IF;
        END IF;
    END PROCESS DLLdelay;

    ----------------------------------------------------------------------------
    -- Main Behavior Process
    ----------------------------------------------------------------------------
    VITALBehaviour: PROCESS(CKDiff, DQSDiff, DQSIn, DQIn,
                            DM, ODT, CKE, CSNeg, RASNeg, CASNeg,
                            WENeg, BAIn, AIn)

        -- Timing Check Variables
        VARIABLE Tviol_DQ0_DQS     : X01 := '0';
        VARIABLE TD_DQ0_DQS        : VitalTimingDataType;

        VARIABLE Tviol_DQ0_DQS1    : X01 := '0';
        VARIABLE TD_DQ0_DQS1       : VitalTimingDataType;

        VARIABLE Tviol_DQ1_DQS     : X01 := '0';
        VARIABLE TD_DQ1_DQS        : VitalTimingDataType;

        VARIABLE Tviol_DQ1_DQS1    : X01 := '0';
        VARIABLE TD_DQ1_DQS1       : VitalTimingDataType;

        VARIABLE Tviol_DM0_DQS     : X01 := '0';
        VARIABLE TD_DM0_DQS        : VitalTimingDataType;

        VARIABLE Tviol_DM0_DQS1    : X01 := '0';
        VARIABLE TD_DM0_DQS1       : VitalTimingDataType;

        VARIABLE Tviol_DM1_DQS     : X01 := '0';
        VARIABLE TD_DM1_DQS        : VitalTimingDataType;

        VARIABLE Tviol_DM1_DQS1    : X01 := '0';
        VARIABLE TD_DM1_DQS1       : VitalTimingDataType;

        VARIABLE Tviol_ODT_CK      : X01 := '0';
        VARIABLE TD_ODT_CK         : VitalTimingDataType;

        VARIABLE Tviol_CKE_CK      : X01 := '0';
        VARIABLE TD_CKE_CK         : VitalTimingDataType;

        VARIABLE Tviol_CSNeg_CK    : X01 := '0';
        VARIABLE TD_CSNeg_CK       : VitalTimingDataType;

        VARIABLE Tviol_RASNeg_CK   : X01 := '0';
        VARIABLE TD_RASNeg_CK      : VitalTimingDataType;

        VARIABLE Tviol_CASNeg_CK   : X01 := '0';
        VARIABLE TD_CASNeg_CK      : VitalTimingDataType;

        VARIABLE Tviol_WENeg_CK    : X01 := '0';
        VARIABLE TD_WENeg_CK       : VitalTimingDataType;

        VARIABLE Tviol_BA0_CK      : X01 := '0';
        VARIABLE TD_BA0_CK         : VitalTimingDataType;

        VARIABLE Tviol_A0_CK       : X01 := '0';
        VARIABLE TD_A0_CK          : VitalTimingDataType;

        VARIABLE Tviol_DQS_CK3     : X01 := '0';
        VARIABLE TD_DQS_CK3        : VitalTimingDataType;

        VARIABLE Tviol_DQS_CK4     : X01 := '0';
        VARIABLE TD_DQS_CK4        : VitalTimingDataType;

        VARIABLE Tviol_DQS_CK5     : X01 := '0';
        VARIABLE TD_DQS_CK5        : VitalTimingDataType;

        VARIABLE Tviol_DQS_CK6     : X01 := '0';
        VARIABLE TD_DQS_CK6        : VitalTimingDataType;

        VARIABLE Tviol_DQS1_CK3    : X01 := '0';
        VARIABLE TD_DQS1_CK3       : VitalTimingDataType;

        VARIABLE Tviol_DQS1_CK4    : X01 := '0';
        VARIABLE TD_DQS1_CK4       : VitalTimingDataType;

        VARIABLE Tviol_DQS1_CK5    : X01 := '0';
        VARIABLE TD_DQS1_CK5       : VitalTimingDataType;

        VARIABLE Tviol_DQS1_CK6    : X01 := '0';
        VARIABLE TD_DQS1_CK6       : VitalTimingDataType;

        VARIABLE Pviol_A03         : X01 := '0';
        VARIABLE PD_A03            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_A04         : X01 := '0';
        VARIABLE PD_A04            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_A05         : X01 := '0';
        VARIABLE PD_A05            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_A06         : X01 := '0';
        VARIABLE PD_A06            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_ODT3        : X01 := '0';
        VARIABLE PD_ODT3           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_ODT4        : X01 := '0';
        VARIABLE PD_ODT4           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_ODT5        : X01 := '0';
        VARIABLE PD_ODT5           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_ODT6        : X01 := '0';
        VARIABLE PD_ODT6           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CSNeg3      : X01 := '0';
        VARIABLE PD_CSNeg3         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CSNeg4      : X01 := '0';
        VARIABLE PD_CSNeg4         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CSNeg5      : X01 := '0';
        VARIABLE PD_CSNeg5         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CSNeg6      : X01 := '0';
        VARIABLE PD_CSNeg6         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_RASNeg3     : X01 := '0';
        VARIABLE PD_RASNeg3        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_RASNeg4     : X01 := '0';
        VARIABLE PD_RASNeg4        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_RASNeg5     : X01 := '0';
        VARIABLE PD_RASNeg5        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_RASNeg6     : X01 := '0';
        VARIABLE PD_RASNeg6        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CASNeg3     : X01 := '0';
        VARIABLE PD_CASNeg3        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CASNeg4     : X01 := '0';
        VARIABLE PD_CASNeg4        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CASNeg5     : X01 := '0';
        VARIABLE PD_CASNeg5        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CASNeg6     : X01 := '0';
        VARIABLE PD_CASNeg6        : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_WENeg3      : X01 := '0';
        VARIABLE PD_WENeg3         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_WENeg4      : X01 := '0';
        VARIABLE PD_WENeg4         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_WENeg5      : X01 := '0';
        VARIABLE PD_WENeg5         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_WENeg6      : X01 := '0';
        VARIABLE PD_WENeg6         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQ03        : X01 := '0';
        VARIABLE PD_DQ03           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQ04        : X01 := '0';
        VARIABLE PD_DQ04           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQ05        : X01 := '0';
        VARIABLE PD_DQ05           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQ06        : X01 := '0';
        VARIABLE PD_DQ06           : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DM3         : X01 := '0';
        VARIABLE PD_DM3            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DM4         : X01 := '0';
        VARIABLE PD_DM4            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DM5         : X01 := '0';
        VARIABLE PD_DM5            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DM6         : X01 := '0';
        VARIABLE PD_DM6            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS13       : X01 := '0';
        VARIABLE PD_DQS13          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS14       : X01 := '0';
        VARIABLE PD_DQS14          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS15       : X01 := '0';
        VARIABLE PD_DQS15          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS16       : X01 := '0';
        VARIABLE PD_DQS16          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS113      : X01 := '0';
        VARIABLE PD_DQS113         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS114      : X01 := '0';
        VARIABLE PD_DQS114         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS115      : X01 := '0';
        VARIABLE PD_DQS115         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS116      : X01 := '0';
        VARIABLE PD_DQS116         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS23       : X01 := '0';
        VARIABLE PD_DQS23          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS24       : X01 := '0';
        VARIABLE PD_DQS24          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS25       : X01 := '0';
        VARIABLE PD_DQS25          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS26       : X01 := '0';
        VARIABLE PD_DQS26          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS213      : X01 := '0';
        VARIABLE PD_DQS213         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS214      : X01 := '0';
        VARIABLE PD_DQS214         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS215      : X01 := '0';
        VARIABLE PD_DQS215         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS216      : X01 := '0';
        VARIABLE PD_DQS216         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS33       : X01 := '0';
        VARIABLE PD_DQS33          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS34       : X01 := '0';
        VARIABLE PD_DQS34          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS35       : X01 := '0';
        VARIABLE PD_DQS35          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS36       : X01 := '0';
        VARIABLE PD_DQS36          : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS313      : X01 := '0';
        VARIABLE PD_DQS313         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS314      : X01 := '0';
        VARIABLE PD_DQS314         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS315      : X01 := '0';
        VARIABLE PD_DQS315         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_DQS316      : X01 := '0';
        VARIABLE PD_DQS316         : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CK3         : X01 := '0';
        VARIABLE PD_CK3            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CK4         : X01 := '0';
        VARIABLE PD_CK4            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CK5         : X01 := '0';
        VARIABLE PD_CK5            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Pviol_CK6         : X01 := '0';
        VARIABLE PD_CK6            : VitalPeriodDataType := VitalPeriodDataInit;

        VARIABLE Violation         : X01 := '0';

    BEGIN

    ----------------------------------------------------------------------------
    -- Timing Check Section
    ----------------------------------------------------------------------------
    IF (TimingChecksOn) THEN

        -- Setup/Hold Check between DQIn and DQSDiff
        VitalSetupHoldCheck (
            TestSignal      => DQIn,
            TestSignalName  => "DQIn",
            RefSignal       => DQSDiff,
            RefSignalName   => "DQSDiff",
            SetupHigh       => tsetup_DQ0_DQS,
            SetupLow        => tsetup_DQ0_DQS,
            HoldHigh        => thold_DQ0_DQS,
            HoldLow         => thold_DQ0_DQS,
            CheckEnabled    => DQIn /= DQOut_zd AND EMR(10) = '0',
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQ0_DQS,
            Violation       => Tviol_DQ0_DQS
        );

        -- Setup/Hold Check between DQIn and DQSIn
        VitalSetupHoldCheck (
            TestSignal      => DQIn,
            TestSignalName  => "DQIn",
            RefSignal       => DQSIn,
            RefSignalName   => "DQSIn",
            SetupHigh       => tsetup_DQ0_DQS,
            SetupLow        => tsetup_DQ0_DQS,
            HoldHigh        => thold_DQ0_DQS,
            HoldLow         => thold_DQ0_DQS,
            CheckEnabled    => DQIn /= DQOut_zd,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQ0_DQS1,
            Violation       => Tviol_DQ0_DQS1
        );

        -- Setup/Hold Check between DQIn and DQSDiff
        VitalSetupHoldCheck (
            TestSignal      => DQIn,
            TestSignalName  => "DQIn",
            RefSignal       => DQSDiff,
            RefSignalName   => "DQSDiff",
            SetupHigh       => tsetup_DQ0_DQS,
            SetupLow        => tsetup_DQ0_DQS,
            HoldHigh        => thold_DQ0_DQS,
            HoldLow         => thold_DQ0_DQS,
            CheckEnabled    => DQIn /= DQOut_zd AND EMR(10) = '0',
            RefTransition   => '\',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQ1_DQS,
            Violation       => Tviol_DQ1_DQS
        );

        -- Setup/Hold Check between DQIn and DQSIn
        VitalSetupHoldCheck (
            TestSignal      => DQIn,
            TestSignalName  => "DQIn",
            RefSignal       => DQSIn,
            RefSignalName   => "DQSIn",
            SetupHigh       => tsetup_DQ0_DQS,
            SetupLow        => tsetup_DQ0_DQS,
            HoldHigh        => thold_DQ0_DQS,
            HoldLow         => thold_DQ0_DQS,
            CheckEnabled    => DQIn /= DQOut_zd,
            RefTransition   => '\',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQ1_DQS1,
            Violation       => Tviol_DQ1_DQS1
        );

        -- Setup/Hold Check between DM and DQSDiff
        VitalSetupHoldCheck (
            TestSignal      => DM,
            TestSignalName  => "DM",
            RefSignal       => DQSDiff,
            RefSignalName   => "DQSDiff",
            SetupHigh       => tsetup_DQ0_DQS,
            SetupLow        => tsetup_DQ0_DQS,
            HoldHigh        => thold_DQ0_DQS,
            HoldLow         => thold_DQ0_DQS,
            CheckEnabled    => EMR(10) = '0' AND EMR(11) = '0',
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DM0_DQS,
            Violation       => Tviol_DM0_DQS
        );

        -- Setup/Hold Check between DM and DQSIn
        VitalSetupHoldCheck (
            TestSignal      => DM,
            TestSignalName  => "DM",
            RefSignal       => DQSIn,
            RefSignalName   => "DQSIn",
            SetupHigh       => tsetup_DQ0_DQS,
            SetupLow        => tsetup_DQ0_DQS,
            HoldHigh        => thold_DQ0_DQS,
            HoldLow         => thold_DQ0_DQS,
            CheckEnabled    => EMR(11) = '0',
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DM0_DQS1,
            Violation       => Tviol_DM0_DQS1
        );

        -- Setup/Hold Check between DM and DQSDiff
        VitalSetupHoldCheck (
            TestSignal      => DM,
            TestSignalName  => "DM",
            RefSignal       => DQSDiff,
            RefSignalName   => "DQSDiff",
            SetupHigh       => tsetup_DQ0_DQS,
            SetupLow        => tsetup_DQ0_DQS,
            HoldHigh        => thold_DQ0_DQS,
            HoldLow         => thold_DQ0_DQS,
            CheckEnabled    => EMR(10) = '0' AND EMR(11) = '0',
            RefTransition   => '\',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DM1_DQS,
            Violation       => Tviol_DM1_DQS
        );

        -- Setup/Hold Check between DM and DQSIn
        VitalSetupHoldCheck (
            TestSignal      => DM,
            TestSignalName  => "DM",
            RefSignal       => DQSIn,
            RefSignalName   => "DQSIn",
            SetupHigh       => tsetup_DQ0_DQS,
            SetupLow        => tsetup_DQ0_DQS,
            HoldHigh        => thold_DQ0_DQS,
            HoldLow         => thold_DQ0_DQS,
            CheckEnabled    => EMR(11) = '0',
            RefTransition   => '\',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DM1_DQS1,
            Violation       => Tviol_DM1_DQS1
        );

        -- Setup/Hold Check between ODT and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => ODT,
            TestSignalName  => "ODT",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupHigh       => tsetup_A0_CK,
            SetupLow        => tsetup_A0_CK,
            HoldHigh        => thold_A0_CK,
            HoldLow         => thold_A0_CK,
            CheckEnabled    => TRUE,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_ODT_CK,
            Violation       => Tviol_ODT_CK
        );

        -- Setup/Hold Check between CKE and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => CKE,
            TestSignalName  => "CKE",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupHigh       => tsetup_A0_CK,
            SetupLow        => tsetup_A0_CK,
            HoldHigh        => thold_A0_CK,
            HoldLow         => thold_A0_CK,
            CheckEnabled    => TRUE,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_CKE_CK,
            Violation       => Tviol_CKE_CK
        );

        -- Setup/Hold Check between CSNeg and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => CSNeg,
            TestSignalName  => "CSNeg",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupHigh       => tsetup_A0_CK,
            SetupLow        => tsetup_A0_CK,
            HoldHigh        => thold_A0_CK,
            HoldLow         => thold_A0_CK,
            CheckEnabled    => TRUE,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_CSNeg_CK,
            Violation       => Tviol_CSNeg_CK
        );

        -- Setup/Hold Check between RASNeg and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => RASNeg,
            TestSignalName  => "RASNeg",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupHigh       => tsetup_A0_CK,
            SetupLow        => tsetup_A0_CK,
            HoldHigh        => thold_A0_CK,
            HoldLow         => thold_A0_CK,
            CheckEnabled    => TRUE,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_RASNeg_CK,
            Violation       => Tviol_RASNeg_CK
        );

        -- Setup/Hold Check between CASNeg and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => CASNeg,
            TestSignalName  => "CASNeg",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupHigh       => tsetup_A0_CK,
            SetupLow        => tsetup_A0_CK,
            HoldHigh        => thold_A0_CK,
            HoldLow         => thold_A0_CK,
            CheckEnabled    => TRUE,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_CASNeg_CK,
            Violation       => Tviol_CASNeg_CK
        );

        -- Setup/Hold Check between WENeg and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => WENeg,
            TestSignalName  => "WENeg",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupHigh       => tsetup_A0_CK,
            SetupLow        => tsetup_A0_CK,
            HoldHigh        => thold_A0_CK,
            HoldLow         => thold_A0_CK,
            CheckEnabled    => TRUE,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_WENeg_CK,
            Violation       => Tviol_WENeg_CK
        );

        -- Setup/Hold Check between BAIn and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => BAIn,
            TestSignalName  => "BAIn",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupHigh       => tsetup_A0_CK,
            SetupLow        => tsetup_A0_CK,
            HoldHigh        => thold_A0_CK,
            HoldLow         => thold_A0_CK,
            CheckEnabled    => TRUE,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_BA0_CK,
            Violation       => Tviol_BA0_CK
        );

        -- Setup/Hold Check between AIn and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => AIn,
            TestSignalName  => "AIn",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupHigh       => tsetup_A0_CK,
            SetupLow        => tsetup_A0_CK,
            HoldHigh        => thold_A0_CK,
            HoldLow         => thold_A0_CK,
            CheckEnabled    => TRUE,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_A0_CK,
            Violation       => Tviol_A0_CK
        );

        -- Setup/Hold Check between DQSDiff and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupLow        => tsetup_DQS_CK_CL3_negedge_posedge,
            HoldHigh        => thold_DQS_CK_CL3_posedge_posedge,
            CheckEnabled    => EMR(10) = '0' AND DQSDiff /= DQSOut_zd AND
                               (DQSIn = '0' OR DQSIn = '1') AND
                               NOT postamble_check AND In_data = '1' AND
                               to_nat(MR(6 DOWNTO 4)) = 3,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQS_CK3,
            Violation       => Tviol_DQS_CK3
        );

        -- Setup/Hold Check between DQSDiff and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupLow        => tsetup_DQS_CK_CL4_negedge_posedge,
            HoldHigh        => thold_DQS_CK_CL4_posedge_posedge,
            CheckEnabled    => EMR(10) = '0' AND DQSDiff /= DQSOut_zd AND
                               (DQSIn = '0' OR DQSIn = '1') AND
                               NOT postamble_check AND In_data = '1' AND
                               to_nat(MR(6 DOWNTO 4)) = 4,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQS_CK4,
            Violation       => Tviol_DQS_CK4
        );

        -- Setup/Hold Check between DQSDiff and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupLow        => tsetup_DQS_CK_CL5_negedge_posedge,
            HoldHigh        => thold_DQS_CK_CL5_posedge_posedge,
            CheckEnabled    => EMR(10) = '0' AND DQSDiff /= DQSOut_zd AND
                               (DQSIn = '0' OR DQSIn = '1') AND
                               NOT postamble_check AND In_data = '1' AND
                               to_nat(MR(6 DOWNTO 4)) = 5,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQS_CK5,
            Violation       => Tviol_DQS_CK5
        );

        -- Setup/Hold Check between DQSDiff and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupLow        => tsetup_DQS_CK_CL6_negedge_posedge,
            HoldHigh        => thold_DQS_CK_CL6_posedge_posedge,
            CheckEnabled    => EMR(10) = '0' AND DQSDiff /= DQSOut_zd AND
                               (DQSIn = '0' OR DQSIn = '1') AND
                               NOT postamble_check AND In_data = '1' AND
                               to_nat(MR(6 DOWNTO 4)) = 6,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQS_CK6,
            Violation       => Tviol_DQS_CK6
        );

        -- Setup/Hold Check between DQSIn and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupLow        => tsetup_DQS_CK_CL3_negedge_posedge,
            HoldHigh        => thold_DQS_CK_CL3_posedge_posedge,
            CheckEnabled    => DQSIn /= DQSOut_zd AND (DQSIn = '0' OR
                               DQSIn = '1') AND NOT postamble_check AND
                               In_data = '1' AND to_nat(MR(6 DOWNTO 4)) = 3,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQS1_CK3,
            Violation       => Tviol_DQS1_CK3
        );

        -- Setup/Hold Check between DQSIn and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupLow        => tsetup_DQS_CK_CL4_negedge_posedge,
            HoldHigh        => thold_DQS_CK_CL4_posedge_posedge,
            CheckEnabled    => DQSIn /= DQSOut_zd AND (DQSIn = '0' OR
                               DQSIn = '1') AND NOT postamble_check AND
                               In_data = '1' AND to_nat(MR(6 DOWNTO 4)) = 4,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQS1_CK4,
            Violation       => Tviol_DQS1_CK4
        );

        -- Setup/Hold Check between DQSIn and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupLow        => tsetup_DQS_CK_CL5_negedge_posedge,
            HoldHigh        => thold_DQS_CK_CL5_posedge_posedge,
            CheckEnabled    => DQSIn /= DQSOut_zd AND (DQSIn = '0' OR
                               DQSIn = '1') AND NOT postamble_check AND
                               In_data = '1' AND to_nat(MR(6 DOWNTO 4)) = 5,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQS1_CK5,
            Violation       => Tviol_DQS1_CK5
        );

        -- Setup/Hold Check between DQSIn and CKDiff
        VitalSetupHoldCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            RefSignal       => CKDiff,
            RefSignalName   => "CKDiff",
            SetupLow        => tsetup_DQS_CK_CL6_negedge_posedge,
            HoldHigh        => thold_DQS_CK_CL6_posedge_posedge,
            CheckEnabled    => DQSIn /= DQSOut_zd AND (DQSIn = '0' OR
                               DQSIn = '1') AND NOT postamble_check AND
                               In_data = '1' AND to_nat(MR(6 DOWNTO 4)) = 6,
            RefTransition   => '/',
            HeaderMsg       => InstancePath & PartID,
            TimingData      => TD_DQS1_CK6,
            Violation       => Tviol_DQS1_CK6
        );

        -- PulseWidth Check for AIn(0)
        VitalPeriodPulseCheck (
            TestSignal      => AIn(0),
            TestSignalName  => "AIn(0)",
            PulseWidthLow   => tpw_A0_CL3,
            PulseWidthHigh  => tpw_A0_CL3,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_A03,
            Violation       => Pviol_A03
        );

        -- PulseWidth Check for AIn(0)
        VitalPeriodPulseCheck (
            TestSignal      => AIn(0),
            TestSignalName  => "AIn(0)",
            PulseWidthLow   => tpw_A0_CL4,
            PulseWidthHigh  => tpw_A0_CL4,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_A04,
            Violation       => Pviol_A04
        );

        -- PulseWidth Check for AIn(0)
        VitalPeriodPulseCheck (
            TestSignal      => AIn(0),
            TestSignalName  => "AIn(0)",
            PulseWidthLow   => tpw_A0_CL5,
            PulseWidthHigh  => tpw_A0_CL5,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_A05,
            Violation       => Pviol_A05
        );

        -- PulseWidth Check for AIn(0)
        VitalPeriodPulseCheck (
            TestSignal      => AIn(0),
            TestSignalName  => "AIn(0)",
            PulseWidthLow   => tpw_A0_CL6,
            PulseWidthHigh  => tpw_A0_CL6,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_A06,
            Violation       => Pviol_A06
        );

        -- PulseWidth Check for ODT
        VitalPeriodPulseCheck (
            TestSignal      => ODT,
            TestSignalName  => "ODT",
            PulseWidthLow   => tpw_A0_CL3,
            PulseWidthHigh  => tpw_A0_CL3,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_ODT3,
            Violation       => Pviol_ODT3
        );

        -- PulseWidth Check for ODT
        VitalPeriodPulseCheck (
            TestSignal      => ODT,
            TestSignalName  => "ODT",
            PulseWidthLow   => tpw_A0_CL4,
            PulseWidthHigh  => tpw_A0_CL4,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_ODT4,
            Violation       => Pviol_ODT4
        );

        -- PulseWidth Check for ODT
        VitalPeriodPulseCheck (
            TestSignal      => ODT,
            TestSignalName  => "ODT",
            PulseWidthLow   => tpw_A0_CL5,
            PulseWidthHigh  => tpw_A0_CL5,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_ODT5,
            Violation       => Pviol_ODT5
        );

        -- PulseWidth Check for ODT
        VitalPeriodPulseCheck (
            TestSignal      => ODT,
            TestSignalName  => "ODT",
            PulseWidthLow   => tpw_A0_CL6,
            PulseWidthHigh  => tpw_A0_CL6,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_ODT6,
            Violation       => Pviol_ODT6
        );

        -- PulseWidth Check for CSNeg
        VitalPeriodPulseCheck (
            TestSignal      => CSNeg,
            TestSignalName  => "CSNeg",
            PulseWidthLow   => tpw_A0_CL3,
            PulseWidthHigh  => tpw_A0_CL3,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CSNeg3,
            Violation       => Pviol_CSNeg3
        );

        -- PulseWidth Check for CSNeg
        VitalPeriodPulseCheck (
            TestSignal      => CSNeg,
            TestSignalName  => "CSNeg",
            PulseWidthLow   => tpw_A0_CL4,
            PulseWidthHigh  => tpw_A0_CL4,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CSNeg4,
            Violation       => Pviol_CSNeg4
        );

        -- PulseWidth Check for CSNeg
        VitalPeriodPulseCheck (
            TestSignal      => CSNeg,
            TestSignalName  => "CSNeg",
            PulseWidthLow   => tpw_A0_CL5,
            PulseWidthHigh  => tpw_A0_CL5,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CSNeg5,
            Violation       => Pviol_CSNeg5
        );

        -- PulseWidth Check for CSNeg
        VitalPeriodPulseCheck (
            TestSignal      => CSNeg,
            TestSignalName  => "CSNeg",
            PulseWidthLow   => tpw_A0_CL6,
            PulseWidthHigh  => tpw_A0_CL6,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CSNeg6,
            Violation       => Pviol_CSNeg6
        );

        -- PulseWidth Check for RASNeg
        VitalPeriodPulseCheck (
            TestSignal      => RASNeg,
            TestSignalName  => "RASNeg",
            PulseWidthLow   => tpw_A0_CL3,
            PulseWidthHigh  => tpw_A0_CL3,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_RASNeg3,
            Violation       => Pviol_RASNeg3
        );

        -- PulseWidth Check for RASNeg
        VitalPeriodPulseCheck (
            TestSignal      => RASNeg,
            TestSignalName  => "RASNeg",
            PulseWidthLow   => tpw_A0_CL4,
            PulseWidthHigh  => tpw_A0_CL4,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_RASNeg4,
            Violation       => Pviol_RASNeg4
        );

        -- PulseWidth Check for RASNeg
        VitalPeriodPulseCheck (
            TestSignal      => RASNeg,
            TestSignalName  => "RASNeg",
            PulseWidthLow   => tpw_A0_CL5,
            PulseWidthHigh  => tpw_A0_CL5,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_RASNeg5,
            Violation       => Pviol_RASNeg5
        );

        -- PulseWidth Check for RASNeg
        VitalPeriodPulseCheck (
            TestSignal      => RASNeg,
            TestSignalName  => "RASNeg",
            PulseWidthLow   => tpw_A0_CL6,
            PulseWidthHigh  => tpw_A0_CL6,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_RASNeg6,
            Violation       => Pviol_RASNeg6
        );

        -- PulseWidth Check for CASNeg
        VitalPeriodPulseCheck (
            TestSignal      => CASNeg,
            TestSignalName  => "CASNeg",
            PulseWidthLow   => tpw_A0_CL3,
            PulseWidthHigh  => tpw_A0_CL3,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CASNeg3,
            Violation       => Pviol_CASNeg3
        );

        -- PulseWidth Check for CASNeg
        VitalPeriodPulseCheck (
            TestSignal      => CASNeg,
            TestSignalName  => "CASNeg",
            PulseWidthLow   => tpw_A0_CL4,
            PulseWidthHigh  => tpw_A0_CL4,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CASNeg4,
            Violation       => Pviol_CASNeg4
        );

        -- PulseWidth Check for CASNeg
        VitalPeriodPulseCheck (
            TestSignal      => CASNeg,
            TestSignalName  => "CASNeg",
            PulseWidthLow   => tpw_A0_CL5,
            PulseWidthHigh  => tpw_A0_CL5,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CASNeg5,
            Violation       => Pviol_CASNeg5
        );

        -- PulseWidth Check for CASNeg
        VitalPeriodPulseCheck (
            TestSignal      => CASNeg,
            TestSignalName  => "CASNeg",
            PulseWidthLow   => tpw_A0_CL6,
            PulseWidthHigh  => tpw_A0_CL6,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CASNeg6,
            Violation       => Pviol_CASNeg6
        );

        -- PulseWidth Check for WENeg
        VitalPeriodPulseCheck (
            TestSignal      => WENeg,
            TestSignalName  => "WENeg",
            PulseWidthLow   => tpw_A0_CL3,
            PulseWidthHigh  => tpw_A0_CL3,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_WENeg3,
            Violation       => Pviol_WENeg3
        );

        -- PulseWidth Check for WENeg
        VitalPeriodPulseCheck (
            TestSignal      => WENeg,
            TestSignalName  => "WENeg",
            PulseWidthLow   => tpw_A0_CL4,
            PulseWidthHigh  => tpw_A0_CL4,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_WENeg4,
            Violation       => Pviol_WENeg4
        );

        -- PulseWidth Check for WENeg
        VitalPeriodPulseCheck (
            TestSignal      => WENeg,
            TestSignalName  => "WENeg",
            PulseWidthLow   => tpw_A0_CL5,
            PulseWidthHigh  => tpw_A0_CL5,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_WENeg5,
            Violation       => Pviol_WENeg5
        );

        -- PulseWidth Check for WENeg
        VitalPeriodPulseCheck (
            TestSignal      => WENeg,
            TestSignalName  => "WENeg",
            PulseWidthLow   => tpw_A0_CL6,
            PulseWidthHigh  => tpw_A0_CL6,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_WENeg6,
            Violation       => Pviol_WENeg6
        );

        -- PulseWidth Check for DQIn(0)
        VitalPeriodPulseCheck (
            TestSignal      => DQIn(0),
            TestSignalName  => "DQIn(0)",
            PulseWidthLow   => tpw_DQ0_CL3,
            PulseWidthHigh  => tpw_DQ0_CL3,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQ03,
            Violation       => Pviol_DQ03
        );

        -- PulseWidth Check for DQIn(0)
        VitalPeriodPulseCheck (
            TestSignal      => DQIn(0),
            TestSignalName  => "DQIn(0)",
            PulseWidthLow   => tpw_DQ0_CL4,
            PulseWidthHigh  => tpw_DQ0_CL4,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQ04,
            Violation       => Pviol_DQ04
        );

        -- PulseWidth Check for DQIn(0)
        VitalPeriodPulseCheck (
            TestSignal      => DQIn(0),
            TestSignalName  => "DQIn(0)",
            PulseWidthLow   => tpw_DQ0_CL5,
            PulseWidthHigh  => tpw_DQ0_CL5,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQ05,
            Violation       => Pviol_DQ05
        );

        -- PulseWidth Check for DQIn(0)
        VitalPeriodPulseCheck (
            TestSignal      => DQIn(0),
            TestSignalName  => "DQIn(0)",
            PulseWidthLow   => tpw_DQ0_CL6,
            PulseWidthHigh  => tpw_DQ0_CL6,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQ06,
            Violation       => Pviol_DQ06
        );

        -- PulseWidth Check for DM
        VitalPeriodPulseCheck (
            TestSignal      => DM,
            TestSignalName  => "DM",
            PulseWidthLow   => tpw_DQ0_CL3,
            PulseWidthHigh  => tpw_DQ0_CL3,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3 AND EMR(11) = '0',
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DM3,
            Violation       => Pviol_DM3
        );

        -- PulseWidth Check for DM
        VitalPeriodPulseCheck (
            TestSignal      => DM,
            TestSignalName  => "DM",
            PulseWidthLow   => tpw_DQ0_CL4,
            PulseWidthHigh  => tpw_DQ0_CL4,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4 AND EMR(11) = '0',
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DM4,
            Violation       => Pviol_DM4
        );

        -- PulseWidth Check for DM
        VitalPeriodPulseCheck (
            TestSignal      => DM,
            TestSignalName  => "DM",
            PulseWidthLow   => tpw_DQ0_CL5,
            PulseWidthHigh  => tpw_DQ0_CL5,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5 AND EMR(11) = '0',
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DM5,
            Violation       => Pviol_DM5
        );

        -- PulseWidth Check for DM
        VitalPeriodPulseCheck (
            TestSignal      => DM,
            TestSignalName  => "DM",
            PulseWidthLow   => tpw_DQ0_CL6,
            PulseWidthHigh  => tpw_DQ0_CL6,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6 AND EMR(11) = '0',
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DM6,
            Violation       => Pviol_DM6
        );

        -- PulseWidth Check for DQSDiff (normal)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_normCL3_negedge,
            PulseWidthHigh  => tpw_DQS_normCL3_posedge,
            CheckEnabled    => EMR(10) = '0' AND to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS13,
            Violation       => Pviol_DQS13
        );

        -- PulseWidth Check for DQSDiff (normal)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_normCL4_negedge,
            PulseWidthHigh  => tpw_DQS_normCL4_posedge,
            CheckEnabled    => EMR(10) = '0' AND to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS14,
            Violation       => Pviol_DQS14
        );

        -- PulseWidth Check for DQSDiff (normal)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_normCL5_negedge,
            PulseWidthHigh  => tpw_DQS_normCL5_posedge,
            CheckEnabled    => EMR(10) = '0' AND to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS15,
            Violation       => Pviol_DQS15
        );

        -- PulseWidth Check for DQSDiff (normal)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_normCL6_negedge,
            PulseWidthHigh  => tpw_DQS_normCL6_posedge,
            CheckEnabled    => EMR(10) = '0' AND to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS16,
            Violation       => Pviol_DQS16
        );

        -- PulseWidth Check for DQSIn (normal)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_normCL3_negedge,
            PulseWidthHigh  => tpw_DQS_normCL3_posedge,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS113,
            Violation       => Pviol_DQS113
        );

        -- PulseWidth Check for DQSIn (normal)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_normCL4_negedge,
            PulseWidthHigh  => tpw_DQS_normCL4_posedge,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS114,
            Violation       => Pviol_DQS114
        );

        -- PulseWidth Check for DQSIn (normal)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_normCL5_negedge,
            PulseWidthHigh  => tpw_DQS_normCL5_posedge,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS115,
            Violation       => Pviol_DQS115
        );

        -- PulseWidth Check for DQSIn (normal)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_normCL6_negedge,
            PulseWidthHigh  => tpw_DQS_normCL6_posedge,
            CheckEnabled    => to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS116,
            Violation       => Pviol_DQS116
        );

        -- PulseWidth Check for DQSDiff (preamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_preCL3_negedge,
            CheckEnabled    => EMR(10) = '0' AND preamble_check AND
                               to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS23,
            Violation       => Pviol_DQS23
        );

        -- PulseWidth Check for DQSDiff (preamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_preCL4_negedge,
            CheckEnabled    => EMR(10) = '0' AND preamble_check AND
                               to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS24,
            Violation       => Pviol_DQS24
        );

        -- PulseWidth Check for DQSDiff (preamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_preCL5_negedge,
            CheckEnabled    => EMR(10) = '0' AND preamble_check AND
                               to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS25,
            Violation       => Pviol_DQS25
        );

        -- PulseWidth Check for DQSDiff (preamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_preCL6_negedge,
            CheckEnabled    => EMR(10) = '0' AND preamble_check AND
                               to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS26,
            Violation       => Pviol_DQS26
        );

        -- PulseWidth Check for DQSIn (preamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_preCL3_negedge,
            CheckEnabled    => preamble_check AND to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS213,
            Violation       => Pviol_DQS213
        );

        -- PulseWidth Check for DQSIn (preamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_preCL4_negedge,
            CheckEnabled    => preamble_check AND to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS214,
            Violation       => Pviol_DQS214
        );

        -- PulseWidth Check for DQSIn (preamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_preCL5_negedge,
            CheckEnabled    => preamble_check AND to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS215,
            Violation       => Pviol_DQS215
        );

        -- PulseWidth Check for DQSIn (preamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_preCL6_negedge,
            CheckEnabled    => preamble_check AND to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS216,
            Violation       => Pviol_DQS216
        );

        -- PulseWidth Check for DQSDiff (postamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_postCL3_negedge,
            CheckEnabled    => EMR(10) = '0' AND postamble_check AND
                               to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS33,
            Violation       => Pviol_DQS33
        );

        -- PulseWidth Check for DQSDiff (postamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_postCL4_negedge,
            CheckEnabled    => EMR(10) = '0' AND postamble_check AND
                               to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS34,
            Violation       => Pviol_DQS34
        );

        -- PulseWidth Check for DQSDiff (postamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_postCL5_negedge,
            CheckEnabled    => EMR(10) = '0' AND postamble_check AND
                               to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS35,
            Violation       => Pviol_DQS35
        );

        -- PulseWidth Check for DQSDiff (postamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSDiff,
            TestSignalName  => "DQSDiff",
            PulseWidthLow   => tpw_DQS_postCL6_negedge,
            CheckEnabled    => EMR(10) = '0' AND postamble_check AND
                               to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS36,
            Violation       => Pviol_DQS36
        );

        -- PulseWidth Check for DQSIn (postamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_postCL3_negedge,
            CheckEnabled    => postamble_check AND to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS313,
            Violation       => Pviol_DQS313
        );

        -- PulseWidth Check for DQSIn (postamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_postCL4_negedge,
            CheckEnabled    => postamble_check AND to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS314,
            Violation       => Pviol_DQS314
        );

        -- PulseWidth Check for DQSIn (postamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_postCL5_negedge,
            CheckEnabled    => postamble_check AND to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS315,
            Violation       => Pviol_DQS315
        );

        -- PulseWidth Check for DQSIn (postamble)
        VitalPeriodPulseCheck (
            TestSignal      => DQSIn,
            TestSignalName  => "DQSIn",
            PulseWidthLow   => tpw_DQS_postCL6_negedge,
            CheckEnabled    => postamble_check AND to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_DQS316,
            Violation       => Pviol_DQS316
        );

        -- PulseWidth and Period Check for CKDiff
        VitalPeriodPulseCheck (
            TestSignal      => CKDiff,
            TestSignalName  => "CKDiff",
            Period          => tperiod_CK_CL3,
            PulseWidthLow   => tpw_CK_CL3_negedge,
            PulseWidthHigh  => tpw_CK_CL3_posedge,
            CheckEnabled    => CK_stable AND NOT SR_enter_cycle AND
                               NOT Reset_enter_cycle AND
                               to_nat(MR(6 DOWNTO 4)) = 3,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CK3,
            Violation       => Pviol_CK3
        );

        -- PulseWidth and Period Check for CKDiff
        VitalPeriodPulseCheck (
            TestSignal      => CKDiff,
            TestSignalName  => "CKDiff",
            Period          => tperiod_CK_CL4,
            PulseWidthLow   => tpw_CK_CL4_negedge,
            PulseWidthHigh  => tpw_CK_CL4_posedge,
            CheckEnabled    => CK_stable AND NOT SR_enter_cycle AND
                               NOT Reset_enter_cycle AND
                               to_nat(MR(6 DOWNTO 4)) = 4,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CK4,
            Violation       => Pviol_CK4
        );

        -- PulseWidth and Period Check for CKDiff
        VitalPeriodPulseCheck (
            TestSignal      => CKDiff,
            TestSignalName  => "CKDiff",
            Period          => tperiod_CK_CL5,
            PulseWidthLow   => tpw_CK_CL5_negedge,
            PulseWidthHigh  => tpw_CK_CL5_posedge,
            CheckEnabled    => CK_stable AND NOT SR_enter_cycle AND
                               NOT Reset_enter_cycle AND
                               to_nat(MR(6 DOWNTO 4)) = 5,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CK5,
            Violation       => Pviol_CK5
        );

        -- PulseWidth and Period Check for CKDiff
        VitalPeriodPulseCheck (
            TestSignal      => CKDiff,
            TestSignalName  => "CKDiff",
            Period          => tperiod_CK_CL6,
            PulseWidthLow   => tpw_CK_CL6_negedge,
            PulseWidthHigh  => tpw_CK_CL6_posedge,
            CheckEnabled    => CK_stable AND NOT SR_enter_cycle AND
                               NOT Reset_enter_cycle AND
                               to_nat(MR(6 DOWNTO 4)) = 6,
            HeaderMsg       => InstancePath & PartID,
            PeriodData      => PD_CK6,
            Violation       => Pviol_CK6
        );

        Violation := Tviol_DQ0_DQS    OR
                     Tviol_DQ0_DQS1   OR
                     Tviol_DQ1_DQS    OR
                     Tviol_DQ1_DQS1   OR
                     Tviol_DM0_DQS    OR
                     Tviol_DM0_DQS1   OR
                     Tviol_DM1_DQS    OR
                     Tviol_DM1_DQS1   OR
                     Tviol_ODT_CK     OR
                     Tviol_CKE_CK     OR
                     Tviol_CSNeg_CK   OR
                     Tviol_RASNeg_CK  OR
                     Tviol_CASNeg_CK  OR
                     Tviol_WENeg_CK   OR
                     Tviol_BA0_CK     OR
                     Tviol_A0_CK      OR
                     Tviol_DQS_CK3    OR
                     Tviol_DQS_CK4    OR
                     Tviol_DQS_CK5    OR
                     Tviol_DQS_CK6    OR
                     Tviol_DQS1_CK3   OR
                     Tviol_DQS1_CK4   OR
                     Tviol_DQS1_CK5   OR
                     Tviol_DQS1_CK6   OR
                     Pviol_A03        OR
                     Pviol_A04        OR
                     Pviol_A05        OR
                     Pviol_A06        OR
                     Pviol_ODT3       OR
                     Pviol_ODT4       OR
                     Pviol_ODT5       OR
                     Pviol_ODT6       OR
                     Pviol_CSNeg3     OR
                     Pviol_CSNeg4     OR
                     Pviol_CSNeg5     OR
                     Pviol_CSNeg6     OR
                     Pviol_RASNeg3    OR
                     Pviol_RASNeg4    OR
                     Pviol_RASNeg5    OR
                     Pviol_RASNeg6    OR
                     Pviol_CASNeg3    OR
                     Pviol_CASNeg4    OR
                     Pviol_CASNeg5    OR
                     Pviol_CASNeg6    OR
                     Pviol_WENeg3     OR
                     Pviol_WENeg4     OR
                     Pviol_WENeg5     OR
                     Pviol_WENeg6     OR
                     Pviol_DQ03       OR
                     Pviol_DQ04       OR
                     Pviol_DQ05       OR
                     Pviol_DQ06       OR
                     Pviol_DM3        OR
                     Pviol_DM4        OR
                     Pviol_DM5        OR
                     Pviol_DM6        OR
                     Pviol_DQS13      OR
                     Pviol_DQS14      OR
                     Pviol_DQS15      OR
                     Pviol_DQS16      OR
                     Pviol_DQS113     OR
                     Pviol_DQS114     OR
                     Pviol_DQS115     OR
                     Pviol_DQS116     OR
                     Pviol_DQS23      OR
                     Pviol_DQS24      OR
                     Pviol_DQS25      OR
                     Pviol_DQS26      OR
                     Pviol_DQS213     OR
                     Pviol_DQS214     OR
                     Pviol_DQS215     OR
                     Pviol_DQS216     OR
                     Pviol_DQS33      OR
                     Pviol_DQS34      OR
                     Pviol_DQS35      OR
                     Pviol_DQS36      OR
                     Pviol_DQS313     OR
                     Pviol_DQS314     OR
                     Pviol_DQS315     OR
                     Pviol_DQS316     OR
                     Pviol_CK3        OR
                     Pviol_CK4        OR
                     Pviol_CK5        OR
                     Pviol_CK6;

        Viol <= Violation;

        ASSERT Violation = '0'
            REPORT InstancePath & partID & ": simulation may be" &
                    " inaccurate due to timing violations"
            SEVERITY warning;
    END IF;

    END PROCESS VITALBehaviour;

    Skew_checkers: PROCESS(CKDiff, DQSDiff, DQSIn)

        VARIABLE CKDiff_rise  : time := 0 ns;
        VARIABLE DQSDiff_rise : time := 0 ns;
        VARIABLE DQSIn_rise   : time := 0 ns;
        VARIABLE skew_value   : time := 0 ns;
        VARIABLE CK_DQS_time  : time := 0 ns;

    BEGIN

        IF skew_check THEN
            IF to_nat(MR(6 DOWNTO 4)) = 3 THEN
                skew_value := tskew_CK_DQS_CL3_posedge_posedge;
            ELSIF to_nat(MR(6 DOWNTO 4)) = 4 THEN
                skew_value := tskew_CK_DQS_CL4_posedge_posedge;
            ELSIF to_nat(MR(6 DOWNTO 4)) = 5 THEN
                skew_value := tskew_CK_DQS_CL5_posedge_posedge;
            ELSE
                skew_value := tskew_CK_DQS_CL6_posedge_posedge;
            END IF;
            IF rising_edge(CKDiff) THEN
                CKDiff_rise := NOW;
            END IF;
            IF rising_edge(DQSDiff) THEN
                DQSDiff_rise := NOW;
            END IF;
            IF rising_edge(DQSIn) THEN
                DQSIn_rise := NOW;
            END IF;
            IF EMR(10) = '0' THEN
                CK_DQS_time := CKDiff_rise - DQSDiff_rise;
            ELSE
                CK_DQS_time := CKDiff_rise - DQSIn_rise;
            END IF;
            IF (CK_DQS_time > skew_value AND
            CK_DQS_time < (CK_period - skew_value)) THEN
                ASSERT FALSE
                    REPORT "Skew violation, simulation may be inaccurate"
                    SEVERITY warning;
            END IF;
        END IF;

    END PROCESS Skew_checkers;

    DiffRecCK: PROCESS(CK, CKNeg)

        VARIABLE CKDiff_zd             : std_ulogic;
        VARIABLE PrevData              : std_logic_vector(0 TO 1);
        VARIABLE CK_GlitchData         : VitalGlitchDataType;

    BEGIN

        VitalStateTable (
            StateTable      => Diff_rec_tab,
            DataIn          => (CK, CKNeg),
            Result          => CKDiff_zd,
            PreviousDataIn  => PrevData
        );

        ------------------------------------------------------------------------
        -- (Dummy) Path Delay Section
        ------------------------------------------------------------------------
        VitalPathDelay (
            OutSignal       => CKDiff,
            OutSignalName   => "CKDiff",
            OutTemp         => CKDiff_zd,
            GlitchData      => CK_GlitchData,
            Paths           => (
                0 => (InputChangeTime   => CK'LAST_EVENT,
                      PathDelay         => VitalZeroDelay,
                      PathCondition     => FALSE))
        );

    END PROCESS DiffRecCK;

    DiffRecDQS: PROCESS(DQSIn, DQSNegIn)

        VARIABLE DQSDiff_zd            : std_ulogic;
        VARIABLE PrevData              : std_logic_vector(0 TO 1);
        VARIABLE DQS_GlitchData        : VitalGlitchDataType;

    BEGIN

        VitalStateTable (
            StateTable      => Diff_rec_tab,
            DataIn          => (DQSIn, DQSNegIn),
            Result          => DQSDiff_zd,
            PreviousDataIn  => PrevData
        );

        ------------------------------------------------------------------------
        -- (Dummy) Path Delay Section
        ------------------------------------------------------------------------
        VitalPathDelay (
            OutSignal       => DQSDiff,
            OutSignalName   => "DQSDiff",
            OutTemp         => DQSDiff_zd,
            GlitchData      => DQS_GlitchData,
            Paths           => (
                0 => (InputChangeTime   => DQSIn'LAST_EVENT,
                      PathDelay         => VitalZeroDelay,
                      PathCondition     => FALSE))
        );

    END PROCESS DiffRecDQS;

    Functionality: PROCESS(CKDiff, CKE, tRFCMIN_out, tRFCMAX_out, ODT,
                           tXSNR_out, SimulationEnd, SelfRefresh, SR_exit)

        VARIABLE TimModTemp : string(1 TO 20) := (OTHERS => 'X');--extended TM

        --latencies of scheduled read and write operations
        TYPE Lat_type IS ARRAY (0 TO 10) OF natural RANGE 0 TO 7;
        TYPE Lat_bank_type IS ARRAY (0 TO BankNum) OF Lat_type;
        VARIABLE AL : Lat_bank_type;
        VARIABLE CL : Lat_bank_type;

        VARIABLE prechall_viol : boolean;--command other than NOP or DES issued
                                         --tRPA after precharge all

        VARIABLE idle : boolean;--all banks idle state

        TYPE row_type IS ARRAY (0 TO BankNum) OF integer RANGE 0 TO RowNum;
        VARIABLE active_row : row_type;--activated rows

        --starting columns of scheduled read or write operations
        TYPE col_type IS ARRAY (0 TO 10) OF natural RANGE 0 TO ColNum;
        TYPE col_bank_type IS ARRAY (0 TO BankNum) OF col_type;
        VARIABLE start_column : col_bank_type;

        --needed when multiple reads or writes scheduled in same bank
        VARIABLE free_slot : natural RANGE 0 TO 10;

        --all scheduled writes within all banks
        VARIABLE write_sch : write_sch_bank_type :=
                                                  (OTHERS => (OTHERS => FALSE));
        --elapsed aditive latencies of scheduled reads
        VARIABLE AL_elapsed : write_sch_bank_type :=
                                                  (OTHERS => (OTHERS => FALSE));

        TYPE last_write_type IS ARRAY (0 TO BankNum) OF boolean;
        --needed for verification of durations measured since end of write burst
        VARIABLE last_write : last_write_type := (OTHERS => FALSE);
        --programmed write latency elapsed since end of write burst
        VARIABLE WR_elapsed : last_write_type := (OTHERS => TRUE);
        --2 cycles elapsed since end of write burst
        VARIABLE WTR_elapsed : last_write_type := (OTHERS => TRUE);
        --AL + BL/2 elapsed since read command
        VARIABLE RTP_elapsed : last_write_type := (OTHERS => TRUE);

        TYPE precharge_cnt_type IS ARRAY (0 TO BankNum) OF natural;
        --cycles elapsed since read or write command before precharge command
        VARIABLE precharge_cnt : precharge_cnt_type;
        --cycles elapsed since write command before end of write burst
        VARIABLE wr_rd_cnt : precharge_cnt_type;
        --cycles elapsed since read command before bank returns to active state
        VARIABLE rd_act_cnt : precharge_cnt_type;
        --cycles elapsed since read command before write command
        VARIABLE rd_wr_cnt : natural;
        --BL/2 + 2 cycles elapsed since read command
        VARIABLE RTW_elapsed : boolean := TRUE;
        --cycles elapsed since write command before another write command
        VARIABLE wr_wr_cnt : natural;
        --cycles elapsed since read command before another read command
        VARIABLE rd_rd_cnt : natural;

        VARIABLE read_permit : boolean;--read command accepted
        VARIABLE write_permit : boolean;--write command accepted

        TYPE Command_type IS (LM, REF, DES, NOP, PRE, ACT, WR, RD, ILL);
        VARIABLE Command : Command_type;

        --states during initialization
        TYPE State_type IS (illegal, init0, init1, init2, init3, init4, init5,
                            init6, init7, init8, init9, init10, init11, init12);
        VARIABLE Current_state : State_type := init0;
        VARIABLE Next_state : State_type := init0;

        VARIABLE defined_logic_levels : boolean := TRUE;
        VARIABLE CK_cnt : natural;--between commands during initialization

        VARIABLE power_down_cond : boolean;--pd can be entered
        VARIABLE active_pd_cond : boolean;--active pd can be entered
        VARIABLE PD_exit_cnt : natural := 1;--cycles since CKE went high
        VARIABLE PD_read_delay : boolean := FALSE;--tXSRD elapsed
        VARIABLE PD_read_del_cnt : natural := 1;--cycles of tXSRD
        VARIABLE ODT_off : boolean;--ODT turned off when precharge pd entered
        VARIABLE freq_change : boolean := FALSE;--frequency has changed during
                                                --precharge pd
        VARIABLE freq_ch_cnt : natural;--cycles before frequency can change
        VARIABLE DLL_reset_needed : boolean := FALSE;--DLL must be reset prior
                                                     --to read command

        --needed for CKE pulse width check
        VARIABLE CKEcnt : natural RANGE 0 TO 3 := 3;
        VARIABLE CKErise : boolean := FALSE;
        VARIABLE CKEfall : boolean := TRUE;

        FUNCTION find_free(sch : write_sch_type)
        RETURN natural IS
            VARIABLE Temp : natural;
        BEGIN
            Temp := 0;
            WHILE sch(Temp) LOOP
                Temp := Temp + 1;
            END LOOP;
            RETURN Temp;
        END find_free;

        PROCEDURE CheckRead IS
            VARIABLE WTR_viol : boolean;
            VARIABLE rd_rd_viol : boolean;
            VARIABLE rd_interr_viol : boolean;
            VARIABLE rd_DLL_viol : boolean;
            VARIABLE rd_PD_viol : boolean;
            VARIABLE rd_lock_viol : boolean;
        BEGIN
            read_permit := TRUE;
            WTR_viol := FALSE;
            rd_rd_viol := FALSE;
            rd_interr_viol := FALSE;
            rd_DLL_viol := FALSE;
            rd_PD_viol := FALSE;
            rd_lock_viol := FALSE;
            FOR J IN 0 TO BankNum LOOP
                IF NOT WTR_elapsed(J) OR tWTR_out(J) = '0' THEN
                    WTR_viol := TRUE;
                    read_permit := FALSE;
                END IF;
            END LOOP;
            IF rd_rd_cnt = 1 THEN
                rd_rd_viol := TRUE;
                read_permit := FALSE;
            END IF;
            IF rd_rd_cnt = 3 AND to_nat(MR(2 DOWNTO 0)) = 3 THEN
                rd_interr_viol := TRUE;
                read_permit := FALSE;
            END IF;
            IF NOT DLL_delay_elapsed THEN
                rd_DLL_viol := TRUE;
                read_permit := FALSE;
            END IF;
            IF PD_read_delay THEN
                rd_PD_viol := TRUE;
                read_permit := FALSE;
            END IF;
            IF DLL_reset_needed THEN
                rd_lock_viol := TRUE;
                read_permit := FALSE;
            END IF;
            ASSERT NOT WTR_viol
                REPORT "tWTR has not elapsed since the end of last write burst"
                SEVERITY warning;
            ASSERT NOT rd_rd_viol
                REPORT "2 cycles must elapse between consecutive READ commands"
                SEVERITY warning;
            ASSERT NOT rd_interr_viol
                REPORT "Interrupting READ command must be issued exactly 2 " &
                       "cycles after previous READ command"
                SEVERITY warning;
            ASSERT NOT rd_DLL_viol
                REPORT "200 cycles must elapse between DLL reset and READ " &
                       "command"
                SEVERITY warning;
            ASSERT NOT rd_PD_viol
                REPORT "tXARDS has not elapsed since slow-exit power-down exit"
                SEVERITY warning;
            ASSERT NOT rd_lock_viol
                REPORT "DLL must be reset prior to read command"
                SEVERITY warning;
        END CheckRead;

        PROCEDURE CheckWrite IS
            VARIABLE RTW_viol : boolean;
            VARIABLE wr_wr_viol : boolean;
            VARIABLE wr_interr_viol : boolean;
        BEGIN
            write_permit := TRUE;
            RTW_viol := FALSE;
            wr_wr_viol := FALSE;
            wr_interr_viol := FALSE;
            IF NOT RTW_elapsed THEN
                RTW_viol := TRUE;
                write_permit := FALSE;
            END IF;
            IF wr_wr_cnt = 1 THEN
                wr_wr_viol := TRUE;
                write_permit := FALSE;
            END IF;
            IF wr_wr_cnt = 3 AND to_nat(MR(2 DOWNTO 0)) = 3 THEN
                wr_interr_viol := TRUE;
                write_permit := FALSE;
            END IF;
            ASSERT NOT RTW_viol
                REPORT "BL/2 + 2 cycles must elapse " &
                       "between READ and WRITE commands"
                SEVERITY warning;
            ASSERT NOT wr_wr_viol
                REPORT "2 cycles must elapse between " &
                       "consecutive WRITE commands"
                SEVERITY warning;
            ASSERT NOT wr_interr_viol
                REPORT "Interrupting WRITE command must " &
                       "be issued exactly 2 cycles after " &
                       " previous WRITE command"
                SEVERITY warning;
        END CheckWrite;

    BEGIN

        IF rising_edge(CKDiff) THEN

            IF CK_rise /= 0 ns THEN
                CK_stable <= TRUE;
                IF CK_stable THEN
                    IF NOW - CK_rise /= CK_period THEN
                        IF Pre_PD AND ODT_off AND freq_ch_cnt = 0 THEN
                            freq_change := TRUE;
                        ELSIF CKE = '1' THEN
                            ASSERT SR_enter_cycle OR Reset_enter_cycle
                                REPORT "Input clock frequency is not stable"
                                SEVERITY warning;
                        END IF;
                    END IF;
                    SimulationEnd <= FALSE AFTER 1 ns, TRUE AFTER 2*CK_period;
                    ASSERT CK_period <= tdevice_tCKAVGMAX OR
                    SR_enter_cycle OR Reset_enter_cycle
                        REPORT "Input clock period exceeds tCKAVG(max)"
                        SEVERITY warning;
                END IF;
            END IF;
            CK_period := NOW - CK_rise;
            CK_rise := NOW;

            defined_logic_levels := TRUE;
            IF (CKE /= '0' AND CKE /= '1') OR (RASNeg /= '0' AND RASNeg /= '1')
            OR (CASNeg /= '0' AND CASNeg /= '1') OR
            (WENeg /= '0' AND WENeg /= '1') THEN
                defined_logic_levels := FALSE;
            END IF;

            FOR I IN 0 TO 2 LOOP
                IF BAIn(I) /= '0' AND BAIn(I) /= '1' THEN
                    defined_logic_levels := FALSE;
                END IF;
            END LOOP;

            FOR I IN 0 TO 13 LOOP
                IF AIn(I) /= '0' AND AIn(I) /= '1' THEN
                    defined_logic_levels := FALSE;
                END IF;
            END LOOP;

            Command := ILL;
            IF defined_logic_levels THEN
                IF CSNeg = '0' AND RASNeg = '0' AND CASNeg = '0' AND WENeg = '0'
                AND BAIn(2) = '0' THEN
                    Command := LM;
                ELSIF CSNeg = '0' AND RASNeg = '0' AND CASNeg = '0' AND
                WENeg = '1' THEN
                    Command := REF;
                ELSIF CSNeg = '1' THEN
                    Command := DES;
                ELSIF CSNeg = '0' AND RASNeg = '1' AND CASNeg = '1' AND
                WENeg = '1' THEN
                    Command := NOP;
                ELSIF CSNeg = '0' AND RASNeg = '0' AND CASNeg = '1' AND
                WENeg = '0' THEN
                    Command := PRE;
                ELSIF CSNeg = '0' AND RASNeg = '0' AND CASNeg = '1' AND
                WENeg = '1' THEN
                    Command := ACT;
                ELSIF CSNeg = '0' AND RASNeg = '1' AND CASNeg = '0' AND
                WENeg = '0' THEN
                    Command := WR;
                ELSIF CSNeg = '0' AND RASNeg = '1' AND CASNeg = '0' AND
                WENeg = '1' THEN
                    Command := RD;
                END IF;
            END IF;

            CASE Current_state IS
                WHEN init0 =>
                    IF CKE = '1' THEN
                        IF PoweredUp AND (Command = NOP OR Command = DES) THEN
                            Next_state := init1;
                            In_d <= TRUE;
                            ASSERT ((CK_period >= tperiod_CK_CL3 AND
                            to_nat(MR(6 DOWNTO 4)) = 3) OR
                            (CK_period >= tperiod_CK_CL4 AND
                            to_nat(MR(6 DOWNTO 4)) = 4) OR
                            (CK_period >= tperiod_CK_CL5 AND
                            to_nat(MR(6 DOWNTO 4)) = 5) OR
                            (CK_period >= tperiod_CK_CL6 AND
                            to_nat(MR(6 DOWNTO 4)) = 6) OR
                            to_nat(MR(6 DOWNTO 4)) <= 2 OR
                            to_nat(MR(6 DOWNTO 4)) = 7) AND
                            CK_period <= tdevice_tCKAVGMAX
                                REPORT "Clock must be stable before CKE is " &
                                       "raised high"
                                SEVERITY warning;
                        ELSE
                            ASSERT FALSE
                                REPORT "Invalid start of initialization"
                                SEVERITY warning;
                            Next_state := illegal;
                        END IF;
                    END IF;
                WHEN init1 =>
                    IF Init_delay AND Command = PRE AND AIn(10) = '1' THEN
                        Next_state := init2;
                        CK_cnt := 0;
                        In_d <= FALSE;
                        tRP_in(0) <= '0', '1' AFTER 1 ns;
                    END IF;
                WHEN init2 =>
                    IF tRP_out(0) = '1' THEN
                        IF CK_cnt < 1 THEN
                            CK_cnt := CK_cnt + 1;
                        ELSE
                            IF Command = LM AND to_nat(BAIn) = 2 THEN
                                Next_state := init3;
                                CK_cnt := 0;
                                EMR2 := AIn(12 DOWNTO 0);
                                ASSERT to_nat(EMR2) = 0
                                    REPORT "Invalid value programmed to " &
                                           "extended mode register 2"
                                    SEVERITY warning;
                            END IF;
                        END IF;
                    END IF;
                WHEN init3 =>
                    IF CK_cnt < 1 THEN
                        CK_cnt := CK_cnt + 1;
                    ELSE
                        IF Command = LM AND to_nat(BAIn) = 3 THEN
                            Next_state := init4;
                            CK_cnt := 0;
                            EMR3 := AIn(12 DOWNTO 0);
                            ASSERT to_nat(EMR3) = 0
                                REPORT "Invalid value programmed to " &
                                       "extended mode register 3"
                                SEVERITY warning;
                        END IF;
                    END IF;
                WHEN init4 =>
                    IF CK_cnt < 1 THEN
                        CK_cnt := CK_cnt + 1;
                    ELSE
                        IF Command = LM AND to_nat(BAIn) = 1 AND
                        AIn(0) = '0' THEN
                            Next_state := init5;
                            CK_cnt := 0;
                        END IF;
                    END IF;
                WHEN init5 =>
                    IF CK_cnt < 1 THEN
                        CK_cnt := CK_cnt + 1;
                    ELSE
                        IF Command = LM AND to_nat(BAIn) = 0 AND
                        AIn(8) = '1' THEN
                            Next_state := init6;
                            CK_cnt := 0;
                            DLL_delay <= '1', '0' AFTER 1 ns;
                        END IF;
                    END IF;
                WHEN init6 =>
                    IF CK_cnt < 1 THEN
                        CK_cnt := CK_cnt + 1;
                    ELSIF Command = PRE AND AIn(10) = '1' THEN
                        Next_state := init7;
                        CK_cnt := 0;
                        tRP_in(0) <= '0', '1' AFTER 1 ns;
                    END IF;
                WHEN init7 =>
                    IF tRP_out(0) = '1' THEN
                        IF CK_cnt < 1 THEN
                            CK_cnt := CK_cnt + 1;
                        ELSIF Command = REF THEN
                            Next_state := init8;
                            tRFCMIN_in <= '0', '1' AFTER 1 ns;
                            tRFCMAX_in <= '0', '1' AFTER 1 ns;
                        END IF;
                    END IF;
                WHEN init8 =>
                    IF tRFCMIN_out = '1' AND Command = REF THEN
                        Next_state := init9;
                        tRFCMIN_in <= '0', '1' AFTER 1 ns;
                        tRFCMAX_in <= '0', '1' AFTER 1 ns;
                    END IF;
                WHEN init9 =>
                    IF tRFCMIN_out = '1' AND Command = LM AND to_nat(BAIn) = 0
                    AND AIn(8) = '0' THEN
                        Next_state := init10;
                        CK_cnt := 0;
                        MR := AIn(12 DOWNTO 0);
                        ASSERT (to_nat(MR(11 DOWNTO 9)) /= 0 AND
                        to_nat(MR(11 DOWNTO 9)) <= 5) AND
                        (to_nat(MR(6 DOWNTO 4)) >= 3 AND
                        to_nat(MR(6 DOWNTO 4)) /= 7) AND
                        (to_nat(MR(2 DOWNTO 0)) = 2 OR
                        to_nat(MR(2 DOWNTO 0)) = 3)
                            REPORT "Invalid value programmed to " &
                                   "mode register"
                            SEVERITY warning;
                        ASSERT MR(7) = '0'
                            REPORT "Mode should be set to normal, " &
                                   "not test"
                            SEVERITY warning;
                        TimModTemp(1 TO TimingModel'LENGTH) := TimingModel;
                        IF ((TimModTemp(14) = '5' OR
                        TimModTemp(14 TO 15) = "37") AND
                        (to_nat(MR(6 DOWNTO 4)) = 5 OR
                        to_nat(MR(6 DOWNTO 4)) = 6)) OR
                        (TimModTemp(14) = '3' AND TimModTemp(15) /= '7'
                        AND TimModTemp(15) /= 'E' AND
                        to_nat(MR(6 DOWNTO 4)) = 6) OR
                        ((TimModTemp(14 TO 15) = "3E" OR
                        TimModTemp(14 TO 16) = "25E") AND
                        (to_nat(MR(6 DOWNTO 4)) = 3 OR
                        to_nat(MR(6 DOWNTO 4)) = 6)) OR
                        (TimModTemp(14 TO 15) = "25" AND
                        TimModTemp(16) /= 'E' AND
                        (to_nat(MR(6 DOWNTO 4)) = 3 OR
                        to_nat(MR(6 DOWNTO 4)) = 4)) OR
                        (TimModTemp(1) = 'H' AND
                        to_nat(MR(6 DOWNTO 4)) = 6) THEN
                            ASSERT FALSE
                                REPORT "Programmed CL value is not " &
                                       "supported in this speed grade"
                                SEVERITY warning;
                        END IF;
                    END IF;
                WHEN init10 =>
                    IF CK_cnt < 1 THEN
                        CK_cnt := CK_cnt + 1;
                    ELSE
                        IF Command = LM AND to_nat(BAIn) = 1 AND
                        to_nat(AIn(9 DOWNTO 7)) = 7 THEN
                            Next_state := init11;
                            CK_cnt := 0;
                        END IF;
                    END IF;
                WHEN init11 =>
                    IF CK_cnt < 1 THEN
                        CK_cnt := CK_cnt + 1;
                    ELSE
                        IF Command = LM AND to_nat(BAIn) = 1 AND
                        to_nat(AIn(9 DOWNTO 7)) = 0 THEN
                            Next_state := init12;
                            CK_cnt := 0;
                            EMR := AIn(12 DOWNTO 0);
                            ASSERT to_nat(EMR(5 DOWNTO 3)) <= 4
                                REPORT "Invalid AL value programmed"
                                SEVERITY warning;
                            ASSERT EMR(0) = '0'
                                REPORT "DLL must be enabled for normal " &
                                       "operation"
                                SEVERITY warning;
                        END IF;
                    END IF;
                WHEN init12 =>
                    Initialized <= TRUE;
                WHEN illegal =>
            END CASE;

            Current_state := Next_state;

            IF Initialized THEN
                idle := TRUE;
                FOR I IN 0 TO BankNum LOOP
                    IF Curr_bank_state(I) /= precharged THEN
                        idle := FALSE;
                    END IF;
                END LOOP;

                IF CKE = '1' AND NOT (SelfRefresh OR Pre_PD OR Act_PD OR
                Reset) THEN

                IF Command = LM THEN
                    IF idle THEN
                        FOR I IN 0 TO BankNum LOOP
                            Next_bank_state(I) := MRsetting;
                        END LOOP;
                        IF to_nat(BAIn) = 0 THEN
                            MR := AIn(12 DOWNTO 0);
                            IF MR(8) = '1' THEN
                                DLL_delay <= '1', '0' AFTER 1 ns;
                                ODT_off := FALSE;
                                freq_change := FALSE;
                                DLL_reset_needed := FALSE;
                            END IF;
                            ASSERT (to_nat(MR(11 DOWNTO 9)) /= 0 AND
                            to_nat(MR(11 DOWNTO 9)) <= 5) AND
                            (to_nat(MR(6 DOWNTO 4)) >= 3 AND
                            to_nat(MR(6 DOWNTO 4)) /= 7) AND
                            (to_nat(MR(2 DOWNTO 0)) = 2 OR
                            to_nat(MR(2 DOWNTO 0)) = 3)
                                REPORT "Invalid value programmed to " &
                                       "mode register"
                                SEVERITY warning;
                            ASSERT MR(7) = '0'
                                REPORT "Mode should be set to normal, " &
                                       "not test"
                                SEVERITY warning;
                            TimModTemp(1 TO TimingModel'LENGTH) := TimingModel;
                            IF ((TimModTemp(14) = '5' OR
                            TimModTemp(14 TO 15) = "37") AND
                            (to_nat(MR(6 DOWNTO 4)) = 5 OR
                            to_nat(MR(6 DOWNTO 4)) = 6)) OR
                            (TimModTemp(14) = '3' AND TimModTemp(15) /= '7'
                            AND TimModTemp(15) /= 'E' AND
                            to_nat(MR(6 DOWNTO 4)) = 6) OR
                            ((TimModTemp(14 TO 15) = "3E" OR
                            TimModTemp(14 TO 16) = "25E") AND
                            (to_nat(MR(6 DOWNTO 4)) = 3 OR
                            to_nat(MR(6 DOWNTO 4)) = 6)) OR
                            (TimModTemp(14 TO 15) = "25" AND
                            TimModTemp(16) /= 'E' AND
                            (to_nat(MR(6 DOWNTO 4)) = 3 OR
                            to_nat(MR(6 DOWNTO 4)) = 4)) OR
                            (TimModTemp(1) = 'H' AND
                            to_nat(MR(6 DOWNTO 4)) = 6) THEN
                                ASSERT FALSE
                                    REPORT "Programmed CL value is not " &
                                           "supported in this speed grade"
                                    SEVERITY warning;
                            END IF;
                        ELSIF to_nat(BAIn) = 1 THEN
                            EMR := AIn(12 DOWNTO 0);
                            ASSERT to_nat(EMR(5 DOWNTO 3)) <= 4 AND
                            (to_nat(EMR(9 DOWNTO 7)) = 0 OR
                            to_nat(EMR(9 DOWNTO 7)) = 7)
                                REPORT "Invalid value programmed to " &
                                       "extended mode register"
                                SEVERITY warning;
                            ASSERT EMR(0) = '0'
                                REPORT "DLL must be enabled for normal " &
                                       "operation"
                                SEVERITY warning;
                        ELSIF to_nat(BAIn) = 2 THEN
                            EMR2 := AIn(12 DOWNTO 0);
                            ASSERT to_nat(EMR2) = 0
                                REPORT "Invalid value programmed to " &
                                       "extended mode register 2"
                                SEVERITY warning;
                        ELSE
                            EMR3 := AIn(12 DOWNTO 0);
                            ASSERT to_nat(EMR3) = 0
                                REPORT "Invalid value programmed to " &
                                       "extended mode register 3"
                                SEVERITY warning;
                        END IF;
                    ELSE
                        ASSERT FALSE
                            REPORT "The LM command can only be " &
                                   "issued when all banks are idle"
                            SEVERITY warning;
                    END IF;
                END IF;

                ASSERT Curr_bank_state(0) /= MRsetting OR Command = NOP OR
                Command = DES
                    REPORT "Only NOP or DESELECT commands are valid during " &
                           "tMRD after LM command"
                    SEVERITY warning;

                IF Command = REF THEN
                    IF idle THEN
                        FOR I IN 0 TO BankNum LOOP
                            Next_bank_state(I) := refreshing;
                        END LOOP;
                        tRFCMIN_in <= '0', '1' AFTER 1 ns;
                        tRFCMAX_in <= '0', '1' AFTER 1 ns;
                    ELSE
                        ASSERT FALSE
                            REPORT "The REFRESH command can only be " &
                                   "issued when all banks are idle"
                            SEVERITY warning;
                    END IF;
                END IF;

                ASSERT Curr_bank_state(0) /= refreshing OR Command = NOP OR
                Command = DES
                    REPORT "Only NOP or DESELECT commands are valid during " &
                           "tRFC(min) after REFRESH command"
                    SEVERITY warning;

                prechall_viol := FALSE;
                FOR I IN 0 TO BankNum LOOP
                    IF Curr_bank_state(I) = prechall AND Command /= NOP AND
                    Command /= DES THEN
                        prechall_viol := TRUE;
                    END IF;
                END LOOP;
                ASSERT NOT prechall_viol
                    REPORT "Only NOP or DESELECT commands are valid during " &
                           "tRPA after PRECHARGE ALL command"
                    SEVERITY warning;

                ASSERT Command /= PRE OR AIn(10) /= '1' OR
                tRASMIN_out = "11111111"
                    REPORT "tRAS(min) has not elapsed since activation of the" &
                           " last activated bank"
                    SEVERITY warning;

                FOR I IN 0 TO BankNum LOOP
                    CASE Curr_bank_state(I) IS
                        WHEN precharged =>
                            IF Command = ACT AND to_nat(BAIn) = I THEN
                                IF NOT active_forbid THEN
                                    IF tRRD_out = '1' THEN
                                        IF tRC_out(I) = '1' THEN
                                            Next_bank_state(I) := activating;
                                            active_row(I) := to_nat(AIn);
                                            tRCD_in(I) <= '0', '1' AFTER 1 ns;
                                            tRASMIN_in(I) <= '0',
                                                                 '1' AFTER 1 ns;
                                            tRASMAX_in(I) <= '1';
                                            tRRD_in <= '0', '1' AFTER 1 ns;
                                            tRC_in(I) <= '0', '1' AFTER 1 ns;
                                        ELSE
                                            ASSERT FALSE
                                                REPORT "tRC has not elapsed " &
                                                       "since activation of " &
                                                       "the bank"
                                                SEVERITY warning;
                                        END IF;
                                    ELSE
                                        ASSERT FALSE
                                            REPORT "tRRD has not elapsed " &
                                                   "since activation of the " &
                                                   "last activated bank"
                                            SEVERITY warning;
                                    END IF;
                                ELSE
                                    ASSERT FALSE
                                        REPORT "More than 4 ACTIVE commands " &
                                               "issued during tFAW"
                                        SEVERITY warning;
                                END IF;
                            END IF;
                        WHEN MRsetting =>
                            Next_bank_state(I) := precharged;
                        WHEN precharging =>
                            ASSERT Command = NOP OR Command = DES OR
                            to_nat(BAIn) /= I
                                REPORT "During tRP after PRECHARGE command " &
                                       "only valid commands to same bank are " &
                                       "NOP and DESELECT"
                                SEVERITY warning;
                        WHEN prechall =>
                            IF tRP_out(I) = '1' THEN
                                Next_bank_state(I) := precharged;
                            END IF;
                        WHEN active =>
                            IF Command = PRE AND AIn(10) = '0' AND
                            to_nat(BAIn) = I THEN
                                IF tRASMIN_out(I) = '1' THEN
                                    Next_bank_state(I) := precharging;
                                    tRASMAX_in(I) <= '0';
                                    tRP_in(I) <= '0', '1' AFTER 1 ns;
                                ELSE
                                    ASSERT FALSE
                                        REPORT "tRAS(min) has not elapsed " &
                                               "since activation of the bank"
                                        SEVERITY warning;
                                END IF;
                            ELSIF Command = PRE AND AIn(10) = '1' THEN
                                IF tRASMIN_out = "11111111" THEN
                                    Next_bank_state(I) := prechall;
                                    tRASMAX_in <= (OTHERS => '0');
                                    tRP_in(I) <= '0', '1' AFTER 1 ns;
                                END IF;
                            ELSIF Command = WR AND to_nat(BAIn) = I THEN
                                CheckWrite;
                                IF write_permit THEN
                                    wr_wr_cnt := 0;
                                    start_column(I)(0):=to_nat(AIn(9 DOWNTO 0));
                                    AL(I)(0) := to_nat(EMR(5 DOWNTO 3));
                                    CL(I)(0) := to_nat(MR(6 DOWNTO 4));
                                    write_sch(I)(0) := TRUE;
                                    WR_elapsed(I) := FALSE;
                                    tWR_in(I) <= '0';
                                    WTR_elapsed(I) := FALSE;
                                    tWTR_in(I) <= '0';
                                    precharge_cnt(I) := 0;
                                    wr_rd_cnt(I) := 0;
                                    IF AIn(10) = '0' THEN
                                        Next_bank_state(I) := writting;
                                    ELSE
                                        Next_bank_state(I) := writtingAP;
                                    END IF;
                                END IF;
                            ELSIF Command = RD AND to_nat(BAIn) = I THEN
                                CheckRead;
                                IF read_permit THEN
                                    start_column(I)(0) :=
                                                        to_nat(AIn(9 DOWNTO 0));
                                    AL(I)(0) := to_nat(EMR(5 DOWNTO 3));
                                    CL(I)(0) := to_nat(MR(6 DOWNTO 4));
                                    read_sch(I)(0) := TRUE;
                                    AL_elapsed(I)(0) := FALSE;
                                    RTP_elapsed(I) := FALSE;
                                    tRTP_in(I) <= '0';
                                    RTW_elapsed := FALSE;
                                    rd_wr_cnt := 0;
                                    precharge_cnt(I) := 0;
                                    rd_act_cnt(I) := 0;
                                    IF rd_rd_cnt >=
                                    to_nat(MR(2 DOWNTO 0))*2 - 1 THEN
                                        preamble(I)(0) := TRUE;
                                    ELSE
                                        preamble(I)(0) := FALSE;
                                    END IF;
                                    rd_rd_cnt := 0;
                                    IF EMR(5 DOWNTO 3) = "000" AND
                                    MR(2 DOWNTO 0) = "010" THEN
                                        tRTP_in(I) <= '0', '1' AFTER 1 ns;
                                    END IF;
                                    IF AIn(10) = '0' THEN
                                        Next_bank_state(I) := reading;
                                    ELSE
                                        Next_bank_state(I) := readingAP;
                                    END IF;
                                END IF;
                            END IF;
                            ASSERT Command /= ACT OR to_nat(BAIn) /= I
                                REPORT "Previous active row in same bank has " &
                                       "not been closed (precharged)"
                                SEVERITY warning;
                        WHEN activating =>
                            IF to_nat(BAIn) = I THEN
                                IF Command = WR THEN
                                    IF to_nat(EMR(5 DOWNTO 3))*CK_period <
                                    tdevice_tRCD THEN
                                        ASSERT FALSE
                                            REPORT "Greater AL value should " &
                                                   "be programmed"
                                            SEVERITY warning;
                                    ELSE
                                        CheckWrite;
                                        IF write_permit THEN
                                            wr_wr_cnt := 0;
                                            start_column(I)(0) :=
                                                        to_nat(AIn(9 DOWNTO 0));
                                            AL(I)(0) := to_nat(EMR(5 DOWNTO 3));
                                            CL(I)(0) := to_nat(MR(6 DOWNTO 4));
                                            write_sch(I)(0) := TRUE;
                                            WR_elapsed(I) := FALSE;
                                            tWR_in(I) <= '0';
                                            WTR_elapsed(I) := FALSE;
                                            tWTR_in(I) <= '0';
                                            precharge_cnt(I) := 0;
                                            wr_rd_cnt(I) := 0;
                                            IF AIn(10) = '0' THEN
                                                Next_bank_state(I) := writting;
                                            ELSE
                                                Next_bank_state(I):= writtingAP;
                                            END IF;
                                        END IF;
                                    END IF;
                                ELSIF Command = RD THEN
                                    IF to_nat(EMR(5 DOWNTO 3))*CK_period <
                                    tdevice_tRCD THEN
                                        ASSERT FALSE
                                            REPORT "Greater AL value should " &
                                                   "be programmed"
                                            SEVERITY warning;
                                    ELSE
                                        CheckRead;
                                        IF read_permit THEN
                                            start_column(I)(0) :=
                                                        to_nat(AIn(9 DOWNTO 0));
                                            AL(I)(0) := to_nat(EMR(5 DOWNTO 3));
                                            CL(I)(0) := to_nat(MR(6 DOWNTO 4));
                                            read_sch(I)(0) := TRUE;
                                            AL_elapsed(I)(0) := FALSE;
                                            RTP_elapsed(I) := FALSE;
                                            tRTP_in(I) <= '0';
                                            RTW_elapsed := FALSE;
                                            rd_wr_cnt := 0;
                                            precharge_cnt(I) := 0;
                                            rd_act_cnt(I) := 0;
                                            IF rd_rd_cnt >=
                                            to_nat(MR(2 DOWNTO 0))*2 - 1 THEN
                                                preamble(I)(0) := TRUE;
                                            ELSE
                                                preamble(I)(0) := FALSE;
                                            END IF;
                                            rd_rd_cnt := 0;
                                            IF AIn(10) = '0' THEN
                                                Next_bank_state(I) := reading;
                                            ELSE
                                                Next_bank_state(I) := readingAP;
                                            END IF;
                                        END IF;
                                    END IF;
                                ELSE
                                    ASSERT Command = NOP OR Command = DES
                                        REPORT "Illegal command to same bank " &
                                               "during tRCD after activation"
                                        SEVERITY warning;
                                END IF;
                            END IF;
                        WHEN writting =>
                            IF MR(2 DOWNTO 0) = "010" THEN
                                burst_len := 4;
                            ELSE
                                burst_len := 8;
                            END IF;
                            IF last_write(I) THEN
                                precharge_cnt(I) := precharge_cnt(I) + 1;
                                wr_rd_cnt(I) := wr_rd_cnt(I) + 1;
                                IF precharge_cnt(I) = burst_len/2 + 1 THEN
                                    tWR_in(I) <= '0', '1' AFTER 1 ns;
                                ELSIF precharge_cnt(I) = burst_len/2 +
                                to_nat(MR(11 DOWNTO 9)) + 2 THEN
                                    WR_elapsed(I) := TRUE;
                                END IF;
                                IF wr_rd_cnt(I) = burst_len/2 + 1 THEN
                                    tWTR_in(I) <= '0', '1' AFTER 1 ns;
                                END IF;
                            END IF;
                            FOR J IN 0 TO 10 LOOP
                                IF write_sch(I)(J) THEN
                                    IF AL(I)(J) > 0 THEN
                                        AL(I)(J) := AL(I)(J) - 1;
                                    ELSIF CL(I)(J) > 3 THEN
                                        CL(I)(J) := CL(I)(J) - 1;
                                    ELSE
                                        current_bank := I;
                                        current_row := active_row(I);
                                        current_column := start_column(I)(J);
                                        In_data <= '0',
                                            '1' AFTER 3*CK_period/4 - 0.5 ns;
                                        write_sch(I)(J) := FALSE;
                                        last_write(I) := TRUE;
                                        precharge_cnt(I) := 0;
                                        wr_rd_cnt(I) := 0;
                                        WR_elapsed(I) := FALSE;
                                        WTR_elapsed(I) := FALSE;
                                    END IF;
                                END IF;
                            END LOOP;
                            IF Command = WR AND to_nat(BAIn) = I THEN
                                CheckWrite;
                                IF write_permit THEN
                                    wr_wr_cnt := 0;
                                    last_write(I) := FALSE;
                                    precharge_cnt(I) := 0;
                                    wr_rd_cnt(I) := 0;
                                    WR_elapsed(I) := FALSE;
                                    WTR_elapsed(I) := FALSE;
                                    free_slot := find_free(write_sch(I));
                                    start_column(I)(free_slot) :=
                                                        to_nat(AIn(9 DOWNTO 0));
                                    AL(I)(free_slot) := to_nat(EMR(5 DOWNTO 3));
                                    CL(I)(free_slot) := to_nat(MR(6 DOWNTO 4));
                                    write_sch(I)(free_slot) := TRUE;
                                    WR_elapsed(I) := FALSE;
                                    tWR_in(I) <= '0';
                                    WTR_elapsed(I) := FALSE;
                                    tWTR_in(I) <= '0';
                                    IF AIn(10) = '0' THEN
                                        Next_bank_state(I) := writting;
                                    ELSE
                                        Next_bank_state(I) := writtingAP;
                                    END IF;
                                END IF;
                            ELSIF Command = RD AND to_nat(BAIn) = I THEN
                                CheckRead;
                                IF read_permit THEN
                                    start_column(I)(0) :=
                                                        to_nat(AIn(9 DOWNTO 0));
                                    AL(I)(0) := to_nat(EMR(5 DOWNTO 3));
                                    CL(I)(0) := to_nat(MR(6 DOWNTO 4));
                                    read_sch(I)(0) := TRUE;
                                    AL_elapsed(I)(0) := FALSE;
                                    RTP_elapsed(I) := FALSE;
                                    tRTP_in(I) <= '0';
                                    RTW_elapsed := FALSE;
                                    rd_wr_cnt := 0;
                                    precharge_cnt(I) := 0;
                                    rd_act_cnt(I) := 0;
                                    preamble(I)(0) := TRUE;
                                    rd_rd_cnt := 0;
                                    IF EMR(5 DOWNTO 3) = "000" AND
                                    MR(2 DOWNTO 0) = "010" THEN
                                        tRTP_in(I) <= '0', '1' AFTER 1 ns;
                                    END IF;
                                    IF AIn(10) = '0' THEN
                                        Next_bank_state(I) := reading;
                                    ELSE
                                        Next_bank_state(I) := readingAP;
                                    END IF;
                                END IF;
                            ELSIF WR_elapsed(I) THEN
                                IF tWR_out(I) = '1' THEN
                                    IF Command = PRE AND AIn(10) = '0' AND
                                    to_nat(BAIn) = I THEN
                                        IF tRASMIN_out(I) = '1' THEN
                                            Next_bank_state(I) := precharging;
                                            tRASMAX_in(I) <= '0';
                                            tRP_in(I) <= '0', '1' AFTER 1 ns;
                                        ELSE
                                            ASSERT FALSE
                                                REPORT "tRAS(min) has not " &
                                                       "elapsed since " &
                                                       "activation of the bank"
                                                SEVERITY warning;
                                        END IF;
                                    ELSIF Command = PRE AND AIn(10) = '1' THEN
                                        IF tRASMIN_out = "11111111" THEN
                                            Next_bank_state(I) := prechall;
                                            tRASMAX_in <= (OTHERS => '0');
                                            tRP_in(I) <= '0', '1' AFTER 1 ns;
                                        END IF;
                                    ELSE
                                        Next_bank_state(I) := active;
                                    END IF;
                                ELSE
                                    ASSERT FALSE
                                        REPORT "Greater WR value should " &
                                               "be programmed"
                                        SEVERITY warning;
                                END IF;
                            END IF;
                            IF wr_rd_cnt(I) = burst_len/2 + 2 THEN
                                WTR_elapsed(I) := TRUE;
                            END IF;
                        WHEN writtingAP =>
                            IF MR(2 DOWNTO 0) = "010" THEN
                                burst_len := 4;
                            ELSE
                                burst_len := 8;
                            END IF;
                            IF last_write(I) THEN
                                wr_rd_cnt(I) := wr_rd_cnt(I) + 1;
                                precharge_cnt(I) := precharge_cnt(I) + 1;
                                IF precharge_cnt(I) = burst_len/2 + 1 THEN
                                    tWR_in(I) <= '0', '1' AFTER 1 ns;
                                ELSIF precharge_cnt(I) = burst_len/2 +
                                to_nat(MR(11 DOWNTO 9)) + 2 THEN
                                    WR_elapsed(I) := TRUE;
                                END IF;
                                IF wr_rd_cnt(I) = burst_len/2 + 1 THEN
                                    tWTR_in(I) <= '0', '1' AFTER 1 ns;
                                ELSIF wr_rd_cnt(I) = burst_len/2 + 3 THEN
                                    WTR_elapsed(I) := TRUE;
                                END IF;
                            END IF;
                            FOR J IN 0 TO 10 LOOP
                                IF write_sch(I)(J) THEN
                                    IF AL(I)(J) > 0 THEN
                                        AL(I)(J) := AL(I)(J) - 1;
                                    ELSIF CL(I)(J) > 3 THEN
                                        CL(I)(J) := CL(I)(J) - 1;
                                    ELSE
                                        current_bank := I;
                                        current_row := active_row(I);
                                        current_column := start_column(I)(J);
                                        In_data <= '0',
                                            '1' AFTER 3*CK_period/4 - 0.5 ns;
                                        write_sch(I)(J) := FALSE;
                                        last_write(I) := TRUE;
                                        precharge_cnt(I) := 0;
                                        WR_elapsed(I) := FALSE;
                                    END IF;
                                END IF;
                            END LOOP;
                            IF WR_elapsed(I) THEN
                                IF tWR_out(I) = '1' THEN
                                    Next_bank_state(I) := precharging;
                                    tRASMAX_in(I) <= '0';
                                    tRP_in(I) <= '0', '1' AFTER 1 ns;
                                ELSE
                                    ASSERT FALSE
                                        REPORT "Greater WR value should " &
                                               "be programmed"
                                    SEVERITY warning;
                                END IF;
                            END IF;
                        WHEN reading =>
                            precharge_cnt(I) := precharge_cnt(I) + 1;
                            rd_act_cnt(I) := rd_act_cnt(I) + 1;
                            IF MR(2 DOWNTO 0) = "010" THEN
                                burst_len := 4;
                            ELSE
                                burst_len := 8;
                            END IF;
                            IF precharge_cnt(I) = to_nat(EMR(5 DOWNTO 3)) +
                            burst_len/2 - 2 THEN
                                tRTP_in(I) <= '0', '1' AFTER 1 ns;
                            ELSIF precharge_cnt(I) = to_nat(EMR(5 DOWNTO 3)) +
                            burst_len/2 THEN
                                RTP_elapsed(I) := TRUE;
                            END IF;
                            FOR J IN 0 TO 10 LOOP
                                IF read_sch(I)(J) AND NOT AL_elapsed(I)(J) THEN
                                    IF AL(I)(J) > 0 THEN
                                        AL(I)(J) := AL(I)(J) - 1;
                                    ELSE
                                        current_bank := I;
                                        current_row := active_row(I);
                                        current_column := start_column(I)(J);
                                        read_delay := CL(I)(J);
                                        IF read_delay = 3 THEN
                                            IF preamble(I)(J) THEN
                                                preamble_gen <= '0',
                                                 '1' AFTER 3*CK_period/4 - 1 ns,
                                                        'Z' AFTER 3*CK_period/4;
                                            END IF;
                                        END IF;
                                        wait_read(I)(J) <= '0', '1' AFTER 1 ns;
                                        AL_elapsed(I)(J) := TRUE;
                                    END IF;
                                END IF;
                            END LOOP;
                            IF Command = RD AND to_nat(BAIn) = I THEN
                                CheckRead;
                                IF read_permit THEN
                                    precharge_cnt(I) := 0;
                                    rd_wr_cnt := 0;
                                    rd_act_cnt(I) := 0;
                                    RTP_elapsed(I) := FALSE;
                                    RTW_elapsed := FALSE;
                                    free_slot := find_free(read_sch(I));
                                    start_column(I)(free_slot) :=
                                                        to_nat(AIn(9 DOWNTO 0));
                                    AL(I)(free_slot) := to_nat(EMR(5 DOWNTO 3));
                                    CL(I)(free_slot) := to_nat(MR(6 DOWNTO 4));
                                    read_sch(I)(free_slot) := TRUE;
                                    AL_elapsed(I)(free_slot) := FALSE;
                                    tRTP_in(I) <= '0';
                                    RTW_elapsed := FALSE;
                                    IF rd_rd_cnt >=
                                    to_nat(MR(2 DOWNTO 0))*2 - 1 THEN
                                        preamble(I)(free_slot) := TRUE;
                                    ELSE
                                        preamble(I)(free_slot) := FALSE;
                                    END IF;
                                    rd_rd_cnt := 0;
                                    IF EMR(5 DOWNTO 3) = "000" AND
                                    MR(2 DOWNTO 0) = "010" THEN
                                        tRTP_in(I) <= '0', '1' AFTER 1 ns;
                                    END IF;
                                    IF AIn(10) = '0' THEN
                                        Next_bank_state(I) := reading;
                                    ELSE
                                        Next_bank_state(I) := readingAP;
                                    END IF;
                                END IF;
                            ELSIF Command = WR AND to_nat(BAIn) = I THEN
                                CheckWrite;
                                IF write_permit THEN
                                    wr_wr_cnt := 0;
                                    start_column(I)(0) :=
                                                        to_nat(AIn(9 DOWNTO 0));
                                    AL(I)(0) := to_nat(EMR(5 DOWNTO 3));
                                    CL(I)(0) := to_nat(MR(6 DOWNTO 4));
                                    write_sch(I)(0) := TRUE;
                                    WR_elapsed(I) := FALSE;
                                    tWR_in(I) <= '0';
                                    WTR_elapsed(I) := FALSE;
                                    tWTR_in(I) <= '0';
                                    precharge_cnt(I) := 0;
                                    wr_rd_cnt(I) := 0;
                                    IF AIn(10) = '0' THEN
                                        Next_bank_state(I) := writting;
                                    ELSE
                                        Next_bank_state(I) := writtingAP;
                                    END IF;
                                END IF;
                            ELSIF RTP_elapsed(I) AND tRTP_out(I) = '1' AND
                            Command = PRE AND (to_nat(BAIn) = I OR
                            AIn(10) = '1') THEN
                                IF AIn(10) = '0' AND to_nat(BAIn) = I THEN
                                    IF tRASMIN_out(I) = '1' THEN
                                        Next_bank_state(I) := precharging;
                                        tRASMAX_in(I) <= '0';
                                        tRP_in(I) <= '0', '1' AFTER 1 ns;
                                    ELSE
                                        ASSERT FALSE
                                            REPORT "tRAS(min) has not " &
                                                   "elapsed since " &
                                                   "activation of the bank"
                                            SEVERITY warning;
                                    END IF;
                                ELSE
                                    IF tRASMIN_out = "11111111" THEN
                                        Next_bank_state(I) := prechall;
                                        tRASMAX_in <= (OTHERS => '0');
                                        tRP_in(I) <= '0', '1' AFTER 1 ns;
                                    END IF;
                                END IF;
                            ELSIF rd_act_cnt(I) = to_nat(EMR(5 DOWNTO 3)) +
                            to_nat(MR(6 DOWNTO 4)) + 2*to_nat(MR(2 DOWNTO 0))
                            - 2 THEN
                                Next_bank_state(I) := active;
                            END IF;
                        WHEN readingAP =>
                            precharge_cnt(I) := precharge_cnt(I) + 1;
                            IF MR(2 DOWNTO 0) = "010" THEN
                                burst_len := 4;
                            ELSE
                                burst_len := 8;
                            END IF;
                            IF precharge_cnt(I) = to_nat(EMR(5 DOWNTO 3)) +
                            burst_len/2 - 2 THEN
                                tRTP_in(I) <= '0', '1' AFTER 1 ns;
                            ELSIF precharge_cnt(I) = to_nat(EMR(5 DOWNTO 3)) +
                            burst_len/2 THEN
                                RTP_elapsed(I) := TRUE;
                            END IF;
                            FOR J IN 0 TO 10 LOOP
                                IF read_sch(I)(J) AND NOT AL_elapsed(I)(J) THEN
                                    IF AL(I)(J) > 0 THEN
                                        AL(I)(J) := AL(I)(J) - 1;
                                    ELSE
                                        current_bank := I;
                                        current_row := active_row(I);
                                        current_column := start_column(I)(J);
                                        read_delay := CL(I)(J);
                                        IF read_delay = 3 THEN
                                            IF preamble(I)(J) THEN
                                                preamble_gen <= '0',
                                                 '1' AFTER 3*CK_period/4 - 1 ns,
                                                        'Z' AFTER 3*CK_period/4;
                                            END IF;
                                        END IF;
                                        wait_read(I)(J) <= '0', '1' AFTER 1 ns;
                                        AL_elapsed(I)(J) := TRUE;
                                    END IF;
                                END IF;
                            END LOOP;
                            IF RTP_elapsed(I) AND tRTP_out(I) = '1' THEN
                                Next_bank_state(I) := precharging;
                                tRASMAX_in(I) <= '0';
                                tRP_in(I) <= '0', '1' AFTER 1 ns;
                            END IF;
                        WHEN OTHERS =>
                    END CASE;
                    Curr_bank_state(I) := Next_bank_state(I);
                END LOOP;
                IF rd_rd_cnt < 5 THEN
                    rd_rd_cnt := rd_rd_cnt + 1;
                END IF;
                IF wr_wr_cnt < 4 THEN
                    wr_wr_cnt := wr_wr_cnt + 1;
                END IF;
                IF rd_wr_cnt = burst_len/2 + 1 THEN
                    RTW_elapsed := TRUE;
                END IF;
                IF rd_wr_cnt < 6 THEN
                    rd_wr_cnt := rd_wr_cnt + 1;
                END IF;

                END IF;

                IF CKE = '0' AND NOT CKEfall THEN
                    CKEfall := TRUE;
                    CKErise := FALSE;
                    ASSERT CKEcnt = 3
                        REPORT "CKE has not been high for tCKE(min)"
                        SEVERITY warning;
                    CKEcnt := 0;
                END IF;

                IF CKE = '1' AND NOT CKErise THEN
                    CKErise := TRUE;
                    CKEfall := FALSE;
                    ASSERT CKEcnt = 3
                        REPORT "CKE has not been low for tCKE(min)"
                        SEVERITY warning;
                    CKEcnt := 0;
                END IF;

                IF CKEcnt < 3 THEN
                    CKEcnt := CKEcnt + 1;
                END IF;

                IF CKE = '0' AND idle AND Command = REF AND NOT SelfRefresh AND
                (ODT = '0' OR (EMR(6) = '0' AND EMR(2) = '0')) AND
                NOT Act_PD AND NOT Pre_PD AND NOT Reset THEN
                    SR_cond := TRUE;
                    SelfRefresh <= TRUE;
                    SR_exit <= FALSE;
                END IF;

                IF SelfRefresh AND NOT SR_exit AND NOT SR_enter_cycle AND
                CKE = '0' THEN
                    SR_enter_cycle := TRUE;
                END IF;

                IF CKE = '1' AND SelfRefresh AND NOT SR_exit THEN
                    SR_exit <= TRUE;
                    tXSNR_in <= '0', '1' AFTER 1 ns;
                    DLL_delay <= '1', '0' AFTER 1 ns;
                END IF;

                ASSERT Command = NOP OR Command = DES OR NOT SelfRefresh OR
                NOT SR_exit
                    REPORT "Only NOP and DESELECT commands are valid tXSNR " &
                           "after self refresh exit"
                    SEVERITY warning;

                IF CKE = '0' AND (Command = NOP OR Command = DES) AND
                NOT Act_PD AND NOT Pre_PD AND NOT SelfRefresh AND NOT Reset THEN
                    power_down_cond := TRUE;
                    active_pd_cond := FALSE;
                    FOR I IN 0 TO BankNum LOOP
                        IF Curr_bank_state(I) = MRsetting OR
                        Curr_bank_state(I) = reading OR
                        Curr_bank_state(I) = readingAP OR
                        (Curr_bank_state(I) = writting AND
                        NOT (WTR_elapsed(I) AND tWTR_out(I) = '1')) OR
                        Curr_bank_state(I) = writtingAP OR
                        ReadStart OR Read_Start THEN
                            power_down_cond := FALSE;
                        ELSIF Curr_bank_state(I) = activating OR
                        Curr_bank_state(I) = active OR
                        (Curr_bank_state(I) = writting AND
                        WTR_elapsed(I) AND tWTR_out(I) = '1') THEN
                            active_pd_cond := TRUE;
                        END IF;
                    END LOOP;
                    IF power_down_cond THEN
                        IF NOT DLL_delay_elapsed THEN
                            DLL_reset_needed := TRUE;
                        END IF;
                        IF active_pd_cond THEN
                            Act_PD <= TRUE;
                            FOR I IN 0 TO BankNum LOOP
                                IF Curr_bank_state(I) = activating OR
                                Curr_bank_state(I) = writting OR
                                Curr_bank_state(I) = active THEN
                                    Curr_bank_state(I) := active;
                                ELSE
                                    Curr_bank_state(I) := precharged;
                                END IF;
                            END LOOP;
                        ELSE
                            Pre_PD <= TRUE;
                            IF ODT = '0' OR (EMR(6) = '0' AND EMR(2) = '0') THEN
                                ODT_off := TRUE;
                            END IF;
                            freq_ch_cnt := 2;
                            Curr_bank_state := (OTHERS => precharged);
                        END IF;
                    END IF;
                END IF;

                IF freq_ch_cnt > 0 THEN
                    freq_ch_cnt := freq_ch_cnt - 1;
                END IF;

                IF CKE = '1' AND Pre_PD THEN
                    IF PD_exit_cnt = 0 THEN
                        power_down_cond := FALSE;
                        PD_exit_cnt := 1;
                        Pre_PD <= FALSE;
                    ELSE
                        PD_exit_cnt := 0;
                        IF freq_change THEN
                            DLL_reset_needed := TRUE;
                        END IF;
                    END IF;
                END IF;

                IF CKE = '1' AND Act_PD THEN
                    IF PD_exit_cnt = 0 THEN
                        PD_exit_cnt := 1;
                        Act_PD <= FALSE;
                    ELSE
                        PD_exit_cnt := 0;
                        IF NOT PD_read_delay AND MR(12) = '1' THEN
                            PD_read_delay := TRUE;
                            PD_read_del_cnt := 6 - to_nat(EMR(5 DOWNTO 3)) +
                            bool_to_nat(TimModTemp(14) = '3' AND
                            TimModTemp(15) /= '7') +
                            2*bool_to_nat(TimModTemp(14 TO 15) = "25");
                        END IF;
                    END IF;
                END IF;

                IF PD_read_del_cnt > 1 AND PD_read_delay THEN
                    PD_read_del_cnt := PD_read_del_cnt - 1;
                ELSE
                    PD_read_delay := FALSE;
                END IF;

                IF CKE = '0' AND NOT SR_cond AND NOT power_down_cond AND
                NOT Act_PD AND NOT Pre_PD AND NOT SelfRefresh AND NOT Reset THEN
                    Reset <= TRUE;
                    Mem := (OTHERS => (OTHERS => -2));
                    tRFCMAX_in <= '0';
                END IF;

                IF Reset AND NOT Reset_enter_cycle AND CKE = '0' THEN
                    Reset_enter_cycle := TRUE;
                END IF;

            END IF;

        END IF;

        IF falling_edge(CKE) AND NOT Initialized THEN
            ASSERT FALSE
                REPORT "CKE must be driven high during initialization"
                SEVERITY warning;
            Current_state := illegal;
            Next_state := illegal;
        END IF;

        IF rising_edge(tRFCMIN_out) THEN
            FOR I IN 0 TO BankNum LOOP
                IF Curr_bank_state(I) = refreshing THEN
                    Curr_bank_state(I) := precharged;
                    Next_bank_state(I) := precharged;
                END IF;
            END LOOP;
        END IF;

        IF tRFCMAX_out'EVENT AND tRFCMAX_out = '1' THEN
            ASSERT FALSE
                REPORT "tRFC(max) has elapsed since last REFRESH command"
                SEVERITY warning;
        END IF;

        IF rising_edge(ODT) THEN
            ASSERT NOT SelfRefresh OR NOT SR_exit OR
            (EMR(6) = '0' AND EMR(2) = '0')
                REPORT "After exiting self refresh, ODT must remain turned " &
                       "off until tXSNR is satisfied"
                SEVERITY warning;
        END IF;

        IF rising_edge(ODT) AND NOT (EMR(6) = '0' AND EMR(2) = '0') AND
        ODT_off THEN
            ODT_off := FALSE;
        END IF;

        IF rising_edge(tXSNR_out) AND SelfRefresh AND SR_exit THEN
            SR_cond := FALSE;
            SelfRefresh <= FALSE;
            SR_exit <= FALSE;
        END IF;

        IF rising_edge(CKE) AND SelfRefresh AND NOT SR_exit THEN
            SR_enter_cycle := FALSE;
            ASSERT ((CK_period >= tperiod_CK_CL3 AND to_nat(MR(6 DOWNTO 4)) = 3)
            OR (CK_period >= tperiod_CK_CL4 AND to_nat(MR(6 DOWNTO 4)) = 4) OR
            (CK_period >= tperiod_CK_CL5 AND to_nat(MR(6 DOWNTO 4)) = 5) OR
            (CK_period >= tperiod_CK_CL6 AND to_nat(MR(6 DOWNTO 4)) = 6) OR
            to_nat(MR(6 DOWNTO 4)) <= 2 OR to_nat(MR(6 DOWNTO 4)) = 7) AND
            CK_period <= tdevice_tCKAVGMAX
                REPORT "Clock must be stable and meeting tCK specifications " &
                       "at least 1 x tCK prior to exiting self refresh mode"
                SEVERITY warning;
        END IF;

        IF falling_edge(CKE) THEN
            ASSERT NOT SelfRefresh OR NOT SR_exit
                REPORT "CKE must stay high until tXSNR is met"
                SEVERITY warning;
        END IF;

        IF (SelfRefresh'EVENT AND SelfRefresh) OR (SimulationEnd'EVENT AND
        SimulationEnd AND NOT SR_enter_cycle AND NOT Reset_enter_cycle) THEN
            tRFCMAX_in <= '0';
        END IF;

        IF SR_exit'EVENT AND SR_exit THEN
            tRFCMAX_in <= '0', '1' AFTER 1 ns;
        END IF;

        IF rising_edge(CKE) AND Reset THEN
            Reset <= FALSE;
            Reset_enter_cycle := FALSE;
            Initialized <= FALSE;
            Current_state := init0;
            Curr_bank_state := (OTHERS => precharged);
        END IF;

    END PROCESS Functionality;

    TRCDOUT: FOR I IN 0 TO BankNum GENERATE
        PROCESS(tRCD_out(I))
        BEGIN
            IF rising_edge(tRCD_out(I)) AND Curr_bank_state(I) = activating THEN
                Curr_bank_state(I) := active;
                Next_bank_state(I) := active;
            END IF;
        END PROCESS;
    END GENERATE TRCDOUT;

    TRPOUT: FOR I IN 0 TO BankNum GENERATE
        PROCESS(tRP_out(I))
        BEGIN
            IF rising_edge(tRP_out(I)) AND Curr_bank_state(I) = precharging THEN
                Curr_bank_state(I) := precharged;
                Next_bank_state(I) := precharged;
            END IF;
        END PROCESS;
    END GENERATE TRPOUT;

    TRASMAXOUT: FOR I IN 0 TO BankNum GENERATE
        PROCESS(tRASMAX_out(I))
        BEGIN
            ASSERT tRASMAX_out(I) = '0'
                REPORT "tRAS(max) has elapsed since activation of bank, and " &
                       "PRECHARGE command still hasn't been issued"
                SEVERITY warning;
        END PROCESS;
    END GENERATE TRASMAXOUT;

    Refresh_period: PROCESS(Initialized, Ref_per_expired, tRFCMAX_in,
                            SelfRefresh, SR_exit, SimulationEnd, Reset)
        VARIABLE Ref_cnt : natural;
    BEGIN
        IF rising_edge(tRFCMAX_in) AND Ref_cnt < RowNum + 1 THEN
            Ref_cnt := Ref_cnt + 1;
        END IF;
        IF rising_edge(Ref_per_expired) THEN
            ASSERT Ref_cnt = RowNum + 1
                REPORT "Not all rows were refreshed during refresh period"
                SEVERITY warning;
        END IF;
        IF (Initialized'EVENT AND Initialized) OR
        rising_edge(Ref_per_expired) OR (SR_exit'EVENT AND SR_exit) THEN
            Ref_per_start <= '0', '1' AFTER 1 ns;
            Ref_cnt := 0;
        END IF;
        IF (SelfRefresh'EVENT AND SelfRefresh) OR (SimulationEnd'EVENT AND
        SimulationEnd AND NOT SR_enter_cycle AND NOT Reset_enter_cycle) OR
        (Reset'EVENT AND Reset) THEN
            Ref_per_start <= '0';
        END IF;
    END PROCESS Refresh_period;

    PROCESS(Ref_per_start)
        VARIABLE industrial : natural RANGE 0 TO 1;
        VARIABLE len : natural;

    BEGIN
        IF rising_edge(Ref_per_start) THEN
            len := TimingModel'LENGTH;
            industrial := bool_to_nat(TimingModel(len-1 TO len) = "IT");
            Ref_per_expired <= '1' AFTER tdevice_REFPer/(industrial+1) - 1 ns;
        ELSIF falling_edge(Ref_per_start) THEN
            Ref_per_expired <= '0' AFTER 1 ns;
        END IF;
    END PROCESS;

    Indata: PROCESS(DQSDiff, DQSIn, In_data)

        VARIABLE In_col : natural RANGE 0 TO ColNum;
        VARIABLE Start_bank : natural RANGE 0 TO BankNum;
        VARIABLE Start_row  : natural RANGE 0 TO RowNum;
        VARIABLE Start_col  : natural RANGE 0 TO ColNum;
        VARIABLE burst_cnt  : natural := 8;
        VARIABLE burst_seq  : sequence;

        PROCEDURE Write_Mem IS
            VARIABLE addr_temp : natural;
        BEGIN
            addr_temp := Start_row*(ColNum+1) + In_col;
            IF DM = '0' THEN
                Mem(Start_bank)(addr_temp) := -1;
                IF Viol = '0' THEN
                    Mem(Start_bank)(addr_temp) := to_nat(DQIn);
                END IF;
            END IF;
        END Write_Mem;

    BEGIN
        IF rising_edge(In_data) THEN
            preamble_check <= TRUE, FALSE AFTER CK_period/2 + 1 ns;
            skew_check <= TRUE;
            Start_bank := current_bank;
            Start_row := current_row;
            Start_col := current_column;
            In_col := Start_col;
            burst_cnt := 0;
            IF MR(3) = '0' THEN
                burst_seq := seq(In_col MOD 8);
            ELSE
                burst_seq := inl(In_col MOD 8);
            END IF;
        END IF;
        IF ((rising_edge(DQSDiff) AND EMR(10) = '0') OR
        (rising_edge(DQSIn) AND EMR(10) = '1')) AND
        burst_cnt = 0 THEN
            burst_cnt := 1;
            Write_Mem;
        ELSIF ((DQSDiff'EVENT AND EMR(10) = '0') OR
        (DQSIn'EVENT AND EMR(10) = '1')) AND
        burst_cnt > 0 AND burst_cnt < burst_len THEN
            In_col := Start_col + burst_seq(burst_cnt);
            IF burst_cnt = burst_len - 1 THEN
                postamble_check <= TRUE, FALSE AFTER CK_period;
                skew_check <= FALSE;
                burst_cnt := 8;
            ELSE
                burst_cnt := burst_cnt + 1;
            END IF;
            Write_Mem;
        END IF;
    END PROCESS Indata;

    WaitRead: FOR I IN 0 TO BankNum GENERATE
        Inner: FOR J IN 0 TO 10 GENERATE
            PROCESS (CKDiff, wait_read(I)(J))

                VARIABLE delay : natural RANGE 0 TO 7;
                VARIABLE temp_bank : natural;
                VARIABLE temp_row : natural;
                VARIABLE temp_column : natural;

            BEGIN
                IF rising_edge(wait_read(I)(J)) THEN
                    Read_Start := TRUE;
                    delay := read_delay;
                    temp_bank := current_bank;
                    temp_row := current_row;
                    temp_column := current_column;
                END IF;
                IF rising_edge(CKDiff) THEN
                    IF delay > 4 THEN
                        delay := delay - 1;
                    ELSIF delay = 4 THEN
                        delay := delay - 1;
                        IF preamble(I)(J) THEN
                            preamble_gen <= '0', '1' AFTER 3*CK_period/4 - 1 ns,
                                                        'Z' AFTER 3*CK_period/4;
                        END IF;
                    ELSIF delay = 3 THEN
                        delay := delay - 1;
                        read_bank := temp_bank;
                        read_row := temp_row;
                        read_column := temp_column;
                        Out_data <= '0', '1' AFTER 3*CK_period/4 - 1 ns,
                                                        'Z' AFTER 3*CK_period/4;
                        read_sch(I)(J) := FALSE;
                    END IF;
                END IF;
            END PROCESS;
        END GENERATE Inner;
    END GENERATE WaitRead;

    Outdata: PROCESS(CKInt, preamble_gen, Out_data)

        VARIABLE preamble_done : boolean;
        VARIABLE preamble_allow : boolean;
        VARIABLE In_col : natural RANGE 0 TO ColNum;
        VARIABLE Start_bank : natural RANGE 0 TO BankNum;
        VARIABLE Start_row : natural RANGE 0 TO RowNum;
        VARIABLE Start_col : natural RANGE 0 TO ColNum;
        VARIABLE burst_cnt : natural := 9;
        VARIABLE burst_seq : sequence;
        VARIABLE out_buffer : std_logic_vector(7 DOWNTO 0);

        PROCEDURE Read_Mem IS
            VARIABLE addr_temp : natural;
            VARIABLE data_temp : integer;
        BEGIN
            addr_temp := Start_row*(ColNum+1) + In_col;
            out_buffer := (OTHERS => 'X');
            data_temp := Mem(Start_bank)(addr_temp);
            IF data_temp = -2 THEN
                out_buffer(7 DOWNTO 0) := (OTHERS => 'U');
            ELSIF data_temp /= -1 THEN
                out_buffer(7 DOWNTO 0) := to_slv(data_temp, 8);
            END IF;
        END Read_Mem;

    BEGIN
        IF rising_edge(CKInt) THEN
            preamble_allow := FALSE;
        END IF;
        IF rising_edge(preamble_gen) THEN
            preamble_done := FALSE;
        END IF;
        IF rising_edge(CKInt) AND NOT preamble_done THEN
            preamble_allow := TRUE;
            preamble_done := TRUE;
            IF EMR(12) = '0' THEN
                DQSOut_zd  <= NOT CKInt;
                IF EMR(10) = '0' THEN
                    DQSNegOut_zd <= CKInt;
                END IF;
            END IF;
        END IF;
        IF rising_edge(Out_data) THEN
            Start_bank := read_bank;
            Start_row := read_row;
            Start_col := read_column;
            burst_cnt := 0;
            In_col := Start_col;
            IF MR(3) = '0' THEN
                burst_seq := seq(In_col MOD 8);
            ELSE
                burst_seq := inl(In_col MOD 8);
            END IF;
        END IF;
        IF rising_edge(CKInt) AND burst_cnt = 0 THEN
            burst_cnt := 1;
            Read_Mem;
            IF EMR(12) = '0' THEN
                DQSOut_zd <= CKInt;
                IF EMR(10) = '0' THEN
                    DQSNegOut_zd <= NOT CKInt;
                END IF;
                DQOut_zd <= out_buffer;
            END IF;
        ELSIF CKInt'EVENT AND burst_cnt > 0 AND burst_cnt < burst_len THEN
            ReadStart <= TRUE;
            In_col := Start_col + burst_seq(burst_cnt);
            burst_cnt := burst_cnt + 1;
            Read_Mem;
            IF EMR(12) = '0' THEN
                DQSOut_zd <= CKInt;
                IF EMR(10) = '0' THEN
                    DQSNegOut_zd <= NOT CKInt;
                END IF;
                DQOut_zd <= out_buffer;
            END IF;
        ELSIF CKInt'EVENT AND burst_cnt = burst_len AND NOT preamble_allow THEN
            burst_cnt := 9;
            DQSOut_zd <= 'Z';
            DQSNegOut_zd <= 'Z';
            DQOut_zd <= (OTHERS => 'Z');
            ReadStart <= FALSE AFTER CK_period/4 + 1 ns;
            Read_Start := FALSE;
        END IF;
    END PROCESS Outdata;

    active_number: PROCESS(tRRD_in, tFAW_out)

        TYPE act_num_type IS ARRAY (0 TO 3) OF natural RANGE 0 TO 3;
        VARIABLE act_num : act_num_type := (OTHERS => 0);
        VARIABLE next_slot : boolean := FALSE;

    BEGIN
        IF rising_edge(tRRD_in) THEN
            FOR I IN 0 TO 3 LOOP
                IF act_num(I) = 0 THEN
                    IF I = 0 THEN
                        act_num(0) := 1;
                        tFAW_in(0) <= '0', '1' AFTER 1 ns;
                    ELSE
                        next_slot := TRUE;
                        FOR J IN 0 TO I-1 LOOP
                            IF act_num(J) = 0 THEN
                                next_slot := FALSE;
                            END IF;
                        END LOOP;
                        IF next_slot THEN
                            act_num(I) := 1;
                            tFAW_in(I) <= '0', '1' AFTER 1 ns;
                        END IF;
                    END IF;
                ELSE
                    IF act_num(I) = 3 THEN
                        active_forbid := TRUE;
                    ELSE
                        act_num(I) := act_num(I) + 1;
                    END IF;
                END IF;
            END LOOP;
        END IF;
        IF rising_edge(tFAW_out(0)) THEN
            act_num(0) := 0;
            active_forbid := FALSE;
        END IF;
        IF rising_edge(tFAW_out(1)) THEN
            act_num(1) := 0;
            active_forbid := FALSE;
        END IF;
        IF rising_edge(tFAW_out(2)) THEN
            act_num(2) := 0;
            active_forbid := FALSE;
        END IF;
        IF rising_edge(tFAW_out(3)) THEN
            act_num(3) := 0;
            active_forbid := FALSE;
        END IF;
    END PROCESS active_number;

    ----------------------------------------------------------------------------
    -- Path Delay Section
    ----------------------------------------------------------------------------

    DQOut_PathDelay_Gen: FOR I IN DQOut_zd'RANGE GENERATE
        PROCESS(DQOut_zd(I))
            VARIABLE DQ0_GlitchData     : VitalGlitchDataType;
        BEGIN
            VitalPathDelay01Z(
                OutSignal     => DQOut(I),
                OutSignalName => "DQOut",
                OutTemp       => DQOut_zd(I),
                GlitchData    => DQ0_GlitchData,
                Paths         => (
                0 => (InputChangeTime => CKInt'LAST_EVENT,
                      PathDelay       => tpd_CK_DQ0,
                      PathCondition   => TRUE)
                    )
                );
        END PROCESS;
    END GENERATE DQOut_PathDelay_Gen;

    PROCESS(DQSOut_zd)
        VARIABLE DQSOut_GlitchData       : VitalGlitchDataType;
        VARIABLE RDQSOut_GlitchData      : VitalGlitchDataType;
    BEGIN
        VitalPathDelay01Z(
            OutSignal     => DQSOut,
            OutSignalName => "DQSOut",
            OutTemp       => DQSOut_zd,
            GlitchData    => DQSOut_GlitchData,
            Paths         => (
            0 => (InputChangeTime   => CKInt'LAST_EVENT,
                  PathDelay         => tpd_CK_DQS,
                  PathCondition     => TRUE)
            )
        );
        VitalPathDelay01Z(
            OutSignal     => RDQSOut,
            OutSignalName => "RDQSOut",
            OutTemp       => DQSOut_zd,
            GlitchData    => RDQSOut_GlitchData,
            Paths         => (
            0 => (InputChangeTime   => CKInt'LAST_EVENT,
                  PathDelay         => tpd_CK_DQS,
                  PathCondition     => EMR(11) = '1')
            )
        );
    END PROCESS;

    PROCESS(DQSNegOut_zd)
        VARIABLE DQSNegOut_GlitchData       : VitalGlitchDataType;
        VARIABLE RDQSNegOut_GlitchData      : VitalGlitchDataType;
    BEGIN
        VitalPathDelay01Z(
            OutSignal     => DQSNegOut,
            OutSignalName => "DQSNegOut",
            OutTemp       => DQSNegOut_zd,
            GlitchData    => DQSNegOut_GlitchData,
            Paths         => (
            0 => (InputChangeTime   => CKInt'LAST_EVENT,
                  PathDelay         => tpd_CK_DQS,
                  PathCondition     => TRUE)
            )
        );
        VitalPathDelay01Z(
            OutSignal     => RDQSNegOut,
            OutSignalName => "RDQSNegOut",
            OutTemp       => DQSNegOut_zd,
            GlitchData    => RDQSNegOut_GlitchData,
            Paths         => (
            0 => (InputChangeTime   => CKInt'LAST_EVENT,
                  PathDelay         => tpd_CK_DQS,
                  PathCondition     => EMR(11) = '1')
            )
        );
    END PROCESS;

    deflt: PROCESS--default
        -- Text file input variables
        FILE mem_file : text IS mem_file_name;

        VARIABLE ind  : natural := 0;
        VARIABLE buf  : line;

    BEGIN
        -- Preload Control
        ------------------------------------------------------------------------
        -- File Read Section
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        ----- mt47h128m8 memory preload file format ----------------------------
        ------------------------------------------------------------------------
        --   /        - comment
        --   @aaaaaaa - <aaaaaaa> stands for address within memory,
        --              24 LSBits determine address within bank,
        --              other bits determine bank address,
        --              bytes within bank are written row by row
        --   dd       - <dd> is byte to be written at address aaaaaaa++
        --              (aaaaaaa is incremented at every load),
        --   only first 1-8 columns are loaded. NO empty lines !!!!!!!!!!!!!!!!
        ------------------------------------------------------------------------
        IF UserPreload AND (mem_file_name /= "none" ) THEN
            ind := 0;
            Mem := (OTHERS => (OTHERS => -2));
            WHILE (NOT ENDFILE (mem_file)) LOOP
                READLINE (mem_file, buf);
                IF buf(1) = '/' THEN
                    NEXT;
                ELSIF buf(1) = '@' THEN
                    ind := h(buf(2 TO 8)); --address
                ELSE
                    IF ind < (BankNum+1)*(MemSize+1) THEN
                        Mem(ind/(MemSize+1))(ind MOD (MemSize+1))
                                                              := h(buf(1 TO 2));
                        ind := ind + 1;
                    ELSE
                        REPORT "Memory address out of range"
                        SEVERITY warning;
                    END IF;
                END IF;
            END LOOP;
        END IF;

        WAIT;

    END PROCESS;

    END BLOCK behavior;
END vhdl_behavioral;
