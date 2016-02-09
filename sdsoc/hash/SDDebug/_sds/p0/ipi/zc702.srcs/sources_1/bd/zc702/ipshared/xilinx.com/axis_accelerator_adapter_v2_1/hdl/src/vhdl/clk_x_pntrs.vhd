-------------------------------------------------------------------------------
-- $Id: clk_x_pntrs.vhd,v 1.1 2011/06/02 09:43:59 robertb Exp $ 
-- Title      : Clock Crossing Logic 
-- Project    : FIFO Generator
-------------------------------------------------------------------------------
-- (c) Copyright 2006 - 2009 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- File       : clk_x_pntrs.vhd
-- Author     : Xilinx
-------------------------------------------------------------------------------
--
-- Description: This module is used only for Asynchronous FIFOs to pass the 
--              read pointer from RD_CLK domain to WR_CLK domain and the
--              write pointer from WR_CLK domain to RD_CLK domain. 
--              In the process of passing the pointers from one clock domain to 
--              another, registers might fall into meta-stable state. In order 
--              to avoid this undesired situation, two-register-stage 
--              synchronization logic is implemented after data is passed into 
--              the different clock domain.
--
--              I. Functionality:
--              
--              1. Input binary write pointer is converted into gray code. 
--              
--              2. The gray encoded write pointer is registered in the WR_CLK 
--                 domain. The content of these flops are guaranteed to contain
--                 either the current value or the next value in the sequence,
--                 since only one bit can change at a time. Therefore, using 
--                 gray code guarantees valid pointer values across clock 
--                 domains. For implementing these gray counters, it is more 
--                 efficient to implement a binary counter and then XOR the 
--                 outputs to create a gray code output than to build a gray 
--                 counter directly.
--
--              3. It is then registered twice in the RD_CLK domain. As the 
--                 Gray-encoded counter values are passed across cross domains
--                 from the WR_CLK domain to the RD_CLK domain, or vice-versa, 
--                 it is possible that the counter value may be in a state of 
--                 transition at the time that the flops latch in their data. 
--                 Since the counter value is gray-coded, only one bit will be 
--                 transitioning at any given time, and therefore it is expected 
---                that only one flop is likely to be metastable. Under these 
--                 circumstances, it is acceptable for the metastable flop to 
--                 latch in either the old or the new value.
--
--              4. In the RD_CLK domain, it is converted back to binary and 
--                 registered.
--
--              5. Steps 1-4 are repeated for the read pointer (passed from
--                 RD_CLK domain to WR_CLK domain)
--
--
--              II. Module I/O
--              Inputs: WR_CLK, RD_CLK, WR_RST, RD_RST, 
--                      RD_PNTR (C_RD_PNTR_WIDTH-1:0), 
--                      WR_PNTR (C_WR_PNTR_WIDTH-1:0)
--
--              Outputs: RD_PNTR_WR (C_RD_PNTR_WIDTH-1:0), 
--                       WR_PNTR_RW (C_WR_PNTR_WIDTH-1:0) 
--
-------------------------------------------------------------------------------
------------------------------------------------------------------------------- 

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;

ENTITY clk_x_pntrs IS
  GENERIC (
    ---------------------------------------------------------------------------
    -- Generic Declarations (alphabetical)
    ---------------------------------------------------------------------------
    C_HAS_RST            : integer := 0;
    C_RD_PNTR_WIDTH      : integer := 4;
    C_WR_PNTR_WIDTH      : integer := 4;
    C_MSGON_VAL          : integer := 1;
    C_SYNCHRONIZER_STAGE : integer := 2
    );
  
  PORT(
    ---------------------------------------------------------------------------
    -- Input and Output Declarations
    ---------------------------------------------------------------------------

    -- Inputs
    WR_CLK       : IN  std_logic := '0';
    RD_CLK       : IN  std_logic := '0';

    WR_RST       : IN  std_logic := '0';
    RD_RST       : IN  std_logic := '0';

    WR_PNTR      : IN  std_logic_vector (C_WR_PNTR_WIDTH-1 DOWNTO 0) 
                       := (OTHERS => '0');
    RD_PNTR      : IN  std_logic_vector (C_RD_PNTR_WIDTH-1 DOWNTO 0) 
                       := (OTHERS => '0');

    -- Outputs
    WR_PNTR_RD   : OUT std_logic_vector (C_WR_PNTR_WIDTH-1 DOWNTO 0)
                       := (OTHERS => '0');
    RD_PNTR_WR   : OUT std_logic_vector (C_RD_PNTR_WIDTH-1 DOWNTO 0)
                       := (OTHERS => '0')   
  );

END clk_x_pntrs;

-------------------------------------------------------------------------------
-- Port Definitions:
-------------------------------------------------------------------------------
-- WR_PNTR_RD  : Write Pointer synchronized to RD_CLK
-- RD_PNTR_WR  : Read Pointer synchronized to WR_CLK
-------------------------------------------------------------------------------

ARCHITECTURE xilinx OF clk_x_pntrs IS

  ATTRIBUTE DowngradeIPIdentifiedWarnings: STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF xilinx : ARCHITECTURE IS "yes";

  -----------------------------------------------------------------------------
  -- Internal Constants
  -----------------------------------------------------------------------------
  CONSTANT zeros_wr : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) 
                      := (OTHERS => '0');
  CONSTANT zeros_rd : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) 
                      := (OTHERS => '0');
  --CONSTANT MSGONATTR : string := int_2_strbool(C_MSGON_VAL);

  -----------------------------------------------------------------------------
  -- Internal Signals
  -----------------------------------------------------------------------------
  -- The following 6 signals are initialized to 0. Because they are gray coded 
  -- signals, the initial value "0" is actually the gray code for binary "0".
  -- If they have to be initialized to a non-zero value, make sure to use the 
  -- bin2gray function.
  SIGNAL wr_pntr_gc : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
  SIGNAL rd_pntr_gc : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd; 

--  SIGNAL wr_pntr_gc_asreg    : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
--  SIGNAL rd_pntr_gc_asreg    : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;

  SIGNAL wr_pntr_gc_asreg_last : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
  SIGNAL rd_pntr_gc_asreg_last : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;

  SIGNAL wr_pntr_bin : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr; 
  SIGNAL rd_pntr_bin : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;
  
  -- Defined to connect data output of one FIFO to data input of another 
  TYPE wr_sync_array IS ARRAY (0 TO C_SYNCHRONIZER_STAGE) OF std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0);
  TYPE rd_sync_array IS ARRAY (0 TO C_SYNCHRONIZER_STAGE) OF std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0);
  SIGNAL wr_q : wr_sync_array := (OTHERS => (OTHERS => '0'));
  SIGNAL rd_q : rd_sync_array := (OTHERS => (OTHERS => '0'));

  -----------------------------------------------------------------------------
  -- ATTRIBUTE Declarations
  -----------------------------------------------------------------------------
  -- Prevent x-propagation on clock-domain crossing register
--  ATTRIBUTE async_reg                      : STRING;
--  ATTRIBUTE async_reg OF wr_pntr_gc_asreg  : SIGNAL IS "true"; 
--  ATTRIBUTE async_reg OF rd_pntr_gc_asreg  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF wr_q  : SIGNAL IS "true"; 
--  ATTRIBUTE async_reg OF rd_q  : SIGNAL IS "true";
--
--  ATTRIBUTE msgon                        : STRING;
--  ATTRIBUTE msgon OF wr_pntr_gc_asreg    : SIGNAL IS MSGONATTR;
--  ATTRIBUTE msgon OF rd_pntr_gc_asreg    : SIGNAL IS MSGONATTR;    
--  ATTRIBUTE msgon OF wr_q    : SIGNAL IS MSGONATTR;
--  ATTRIBUTE msgon OF rd_q    : SIGNAL IS MSGONATTR;    
  -----------------------------------------------------------------------------

BEGIN --xilinx

-------------------------------------------------------------------------------
-- Asynchronous FIFO
--
-- Pass WR_PNTR from WR_CLK domain to RD_CLK domain
-------------------------------------------------------------------------------
--
--
--            STAGE 1    |       STAGE 2      STAGE 3       STAGE 4
--                       |
--                       | 
--                       |           wr_pntr_gc   wr_pntr_gc 
--                 wr_pntr_gc        _asreg      _asreg_d1     wr_pntr_bin
--            +------+   |     +------+     +------+     +------+
--         --\| bin2 |--------\|      |----\|      |----\|      |----\
--         --/| gray |--------/|      |----/|      |----/|      |----/
--   WR_PNTR  |      |   |     |      |     |      |     |      |  WR_PNTR_RD
--         +--|>  a  |   |   +-|>  a  |   +-|>  a  |   +-|>  a  |  
--         |  +------+   |   | +------+   | +------+   | +------+
--         |      ^      |   |     ^      |     ^      |     ^
--         |      |      |   |     |      |     |      |     |  
--         |      |      |   |     +------|-----+------|-----+------- RD_RST
--       --+      |      |   |            |            |   
--    WR_CLK      |      |   +------------+------------+-------------- RD_CLK
--                |      |         
--      ---------+       |
--   WR_RST              |
--                       |
--                       |
--     WR_CLK domain     |                 RD_CLK domain 
--                       |
--
-- 
-- a = asynchronous reset of the register

  -----------------------------------------------------------------------------
  -- First stage of clock domain crossing 
  -- Clock binary to gray value of the write pointer in WR_CLK domain
  -----------------------------------------------------------------------------
  -- wr_pntr_gc is reset to 0. Because it is a gray coded signal the reset 
  -- value "0" is actually the gray code for binary "0". If it has to be 
  -- initialized to a non-zero value, make sure to use the bin2gray function.

  pwgc : PROCESS (WR_CLK, WR_RST)
  BEGIN
    if (WR_RST='1') then
      wr_pntr_gc <= zeros_wr;
    ELSIF (WR_CLK'event AND WR_CLK='1') THEN
      wr_pntr_gc <= bin2gray(WR_PNTR) AFTER TFF;
    END IF;
  END PROCESS pwgc;

--  -----------------------------------------------------------------------------
--  -- Second and third stages of clock domain crossing
--  -- Clock gray value of the write pointer with RD_CLK
--  -----------------------------------------------------------------------------
--  -- wr_pntr_gc_asreg and wr_pntr_gc_asreg_last are reset to 0. Because they are 
--  -- gray coded signals, the reset value "0" is actually the gray code for 
--  -- binary "0". If they have to be initialized to a non-zero value, make sure
--  -- to use the bin2gray function.
--
--  -- rd_pntr_gc_asreg and rd_pntr_gc_asreg_last are reset to 0. Because they are 
--  -- gray coded signals, the reset value "0" is actually the gray code for 
--  -- binary "0". If they have to be initialized to a non-zero value, make sure
--  -- to use the bin2gray function.
--
--  g2stage_synch: IF (C_SYNCHRONIZER_STAGE = 2) GENERATE
--    SIGNAL wr_pntr_gc_asreg    : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
--    SIGNAL rd_pntr_gc_asreg    : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;
--    ATTRIBUTE async_reg                         : STRING;
--    ATTRIBUTE async_reg OF wr_pntr_gc_asreg     : SIGNAL IS "true"; 
--    ATTRIBUTE async_reg OF rd_pntr_gc_asreg     : SIGNAL IS "true";
--
--    ATTRIBUTE msgon                             : STRING;
--    ATTRIBUTE msgon OF wr_pntr_gc_asreg         : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF rd_pntr_gc_asreg         : SIGNAL IS MSGONATTR;
--  BEGIN
--    pwx: PROCESS (RD_CLK, RD_RST)
--    BEGIN  
--      if (RD_RST='1') then
--        wr_pntr_gc_asreg      <= zeros_wr; 
--        wr_pntr_gc_asreg_last <= zeros_wr; 
--      ELSIF RD_CLK'event AND RD_CLK = '1' THEN 
--        wr_pntr_gc_asreg      <= wr_pntr_gc AFTER TFF;
--        wr_pntr_gc_asreg_last <= wr_pntr_gc_asreg AFTER TFF;
--      END IF;
--    END PROCESS pwx;
--
--    prx: PROCESS (WR_CLK, WR_RST)
--    BEGIN  
--      if (WR_RST='1') then
--        rd_pntr_gc_asreg      <= zeros_rd; 
--        rd_pntr_gc_asreg_last <= zeros_rd; 
--      ELSIF WR_CLK'event AND WR_CLK = '1' THEN 
--        rd_pntr_gc_asreg      <= rd_pntr_gc AFTER TFF;
--        rd_pntr_gc_asreg_last <= rd_pntr_gc_asreg AFTER TFF;
--      END IF;
--    END PROCESS prx;
--  END GENERATE g2stage_synch;
--
--  g3stage_synch: IF (C_SYNCHRONIZER_STAGE = 3) GENERATE
--    SIGNAL wr_pntr_gc_asreg    : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
--    SIGNAL wr_pntr_gc_asreg_d1 : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
--    SIGNAL rd_pntr_gc_asreg    : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;
--    SIGNAL rd_pntr_gc_asreg_d1 : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;
--    ATTRIBUTE async_reg                         : STRING;
--    ATTRIBUTE async_reg OF wr_pntr_gc_asreg     : SIGNAL IS "true"; 
--    ATTRIBUTE async_reg OF wr_pntr_gc_asreg_d1  : SIGNAL IS "true"; 
--    ATTRIBUTE async_reg OF rd_pntr_gc_asreg     : SIGNAL IS "true";
--    ATTRIBUTE async_reg OF rd_pntr_gc_asreg_d1  : SIGNAL IS "true"; 
--
--    ATTRIBUTE msgon                             : STRING;
--    ATTRIBUTE msgon OF wr_pntr_gc_asreg         : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF wr_pntr_gc_asreg_d1      : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF rd_pntr_gc_asreg         : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF rd_pntr_gc_asreg_d1      : SIGNAL IS MSGONATTR;
--  BEGIN
--    pwx: PROCESS (RD_CLK, RD_RST)
--    BEGIN  
--      if (RD_RST='1') then
--        wr_pntr_gc_asreg      <= zeros_wr; 
--        wr_pntr_gc_asreg_d1   <= zeros_wr; 
--        wr_pntr_gc_asreg_last <= zeros_wr; 
--      ELSIF RD_CLK'event AND RD_CLK = '1' THEN 
--        wr_pntr_gc_asreg      <= wr_pntr_gc AFTER TFF;
--        wr_pntr_gc_asreg_d1   <= wr_pntr_gc_asreg AFTER TFF;
--        wr_pntr_gc_asreg_last <= wr_pntr_gc_asreg_d1 AFTER TFF;
--      END IF;
--    END PROCESS pwx;
--
--    prx: PROCESS (WR_CLK, WR_RST)
--    BEGIN  
--      if (WR_RST='1') then
--        rd_pntr_gc_asreg      <= zeros_rd; 
--        rd_pntr_gc_asreg_d1   <= zeros_rd; 
--        rd_pntr_gc_asreg_last <= zeros_rd; 
--      ELSIF WR_CLK'event AND WR_CLK = '1' THEN 
--        rd_pntr_gc_asreg      <= rd_pntr_gc AFTER TFF;
--        rd_pntr_gc_asreg_d1   <= rd_pntr_gc_asreg AFTER TFF;
--        rd_pntr_gc_asreg_last <= rd_pntr_gc_asreg_d1 AFTER TFF;
--      END IF;
--    END PROCESS prx;
--  END GENERATE g3stage_synch;
--
--  g4stage_synch: IF (C_SYNCHRONIZER_STAGE = 4) GENERATE
--    SIGNAL wr_pntr_gc_asreg    : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
--    SIGNAL wr_pntr_gc_asreg_d1 : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
--    SIGNAL wr_pntr_gc_asreg_d2 : std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := zeros_wr;
--    SIGNAL rd_pntr_gc_asreg    : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;
--    SIGNAL rd_pntr_gc_asreg_d1 : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;
--    SIGNAL rd_pntr_gc_asreg_d2 : std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := zeros_rd;
--    ATTRIBUTE async_reg                         : STRING;
--    ATTRIBUTE async_reg OF wr_pntr_gc_asreg     : SIGNAL IS "true"; 
--    ATTRIBUTE async_reg OF wr_pntr_gc_asreg_d1  : SIGNAL IS "true"; 
--    ATTRIBUTE async_reg OF wr_pntr_gc_asreg_d2  : SIGNAL IS "true"; 
--    ATTRIBUTE async_reg OF rd_pntr_gc_asreg     : SIGNAL IS "true";
--    ATTRIBUTE async_reg OF rd_pntr_gc_asreg_d1  : SIGNAL IS "true"; 
--    ATTRIBUTE async_reg OF rd_pntr_gc_asreg_d2  : SIGNAL IS "true"; 
--
--    ATTRIBUTE msgon                             : STRING;
--    ATTRIBUTE msgon OF wr_pntr_gc_asreg         : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF wr_pntr_gc_asreg_d1      : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF wr_pntr_gc_asreg_d2      : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF rd_pntr_gc_asreg         : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF rd_pntr_gc_asreg_d1      : SIGNAL IS MSGONATTR;
--    ATTRIBUTE msgon OF rd_pntr_gc_asreg_d2      : SIGNAL IS MSGONATTR;
--  BEGIN
--    pwx: PROCESS (RD_CLK, RD_RST)
--    BEGIN  
--      if (RD_RST='1') then
--        wr_pntr_gc_asreg      <= zeros_wr; 
--        wr_pntr_gc_asreg_d1   <= zeros_wr; 
--        wr_pntr_gc_asreg_d2   <= zeros_wr; 
--        wr_pntr_gc_asreg_last <= zeros_wr; 
--      ELSIF RD_CLK'event AND RD_CLK = '1' THEN 
--        wr_pntr_gc_asreg      <= wr_pntr_gc AFTER TFF;
--        wr_pntr_gc_asreg_d1   <= wr_pntr_gc_asreg AFTER TFF;
--        wr_pntr_gc_asreg_d2   <= wr_pntr_gc_asreg_d1 AFTER TFF;
--        wr_pntr_gc_asreg_last <= wr_pntr_gc_asreg_d2 AFTER TFF;
--      END IF;
--    END PROCESS pwx;
--
--    prx: PROCESS (WR_CLK, WR_RST)
--    BEGIN  
--      if (WR_RST='1') then
--        rd_pntr_gc_asreg      <= zeros_rd; 
--        rd_pntr_gc_asreg_d1   <= zeros_rd; 
--        rd_pntr_gc_asreg_d2   <= zeros_rd; 
--        rd_pntr_gc_asreg_last <= zeros_rd; 
--      ELSIF WR_CLK'event AND WR_CLK = '1' THEN 
--        rd_pntr_gc_asreg      <= rd_pntr_gc AFTER TFF;
--        rd_pntr_gc_asreg_d1   <= rd_pntr_gc_asreg AFTER TFF;
--        rd_pntr_gc_asreg_d2   <= rd_pntr_gc_asreg_d1 AFTER TFF;
--        rd_pntr_gc_asreg_last <= rd_pntr_gc_asreg_d2 AFTER TFF;
--      END IF;
--    END PROCESS prx;
--  END GENERATE g4stage_synch;

  gsync_stage: FOR I IN 1 TO C_SYNCHRONIZER_STAGE GENERATE
  BEGIN
      rd_stg_inst: ENTITY axis_accelerator_adapter_v2_1_6.synchronizer_ff
          GENERIC MAP (
            C_HAS_RST => C_HAS_RST,
            C_WIDTH   => C_WR_PNTR_WIDTH
            )
          PORT MAP ( 
            RST       => RD_RST,
            CLK       => RD_CLK,   
            D         => wr_q(i-1),
            Q         => wr_q(i)
            );    

      wr_stg_inst: ENTITY axis_accelerator_adapter_v2_1_6.synchronizer_ff
          GENERIC MAP (
            C_HAS_RST => C_HAS_RST,
            C_WIDTH   => C_RD_PNTR_WIDTH
            )
          PORT MAP ( 
            RST       => WR_RST,
            CLK       => WR_CLK,   
            D         => rd_q(i-1),
            Q         => rd_q(i)
            );    
  END GENERATE gsync_stage;

  wr_q(0)                    <= wr_pntr_gc;
  wr_pntr_gc_asreg_last      <= wr_q(C_SYNCHRONIZER_STAGE);
  rd_q(0)                    <= rd_pntr_gc;
  rd_pntr_gc_asreg_last      <= rd_q(C_SYNCHRONIZER_STAGE);

--  pwr_sync : PROCESS (RD_CLK, RD_RST)
--  BEGIN
--    if (RD_RST='1' AND C_HAS_RST = 1) then
--      wr_q <= (OTHERS => (OTHERS => '0')); 
--    ELSIF (RD_CLK'event AND RD_CLK='1') THEN
--      FOR I IN 1 TO C_SYNCHRONIZER_STAGE LOOP
--        wr_q(i) <= wr_q(i-1);
--      END LOOP;
--    END IF;
--  END PROCESS pwr_sync;
--
--  prd_sync : PROCESS (WR_CLK, WR_RST)
--  BEGIN
--    if (WR_RST='1' AND C_HAS_RST = 1) then
--      rd_q <= (OTHERS => (OTHERS => '0')); 
--    ELSIF (WR_CLK'event AND WR_CLK='1') THEN
--      FOR I IN 1 TO C_SYNCHRONIZER_STAGE LOOP
--        rd_q(i) <= rd_q(i-1);
--      END LOOP;
--    END IF;
--  END PROCESS prd_sync;


  -----------------------------------------------------------------------------
  -- Fourth stage of clock domain crossing 
  -- Clock gray to binary value of the write pointer in RD_CLK domain
  -----------------------------------------------------------------------------
  pwbin : PROCESS (RD_CLK, RD_RST)
  BEGIN
    if (RD_RST='1' AND C_HAS_RST = 1) then
      wr_pntr_bin <= zeros_wr; 
    ELSIF (RD_CLK'event AND RD_CLK='1') THEN
      wr_pntr_bin <= gray2bin(wr_pntr_gc_asreg_last) AFTER TFF;
    END IF;
  END PROCESS pwbin;

  -----------------------------------------------------------------------------
  -- Asynchronous FIFO
  --
  -- Pass RD_PNTR from RD_CLK domain to WR_CLK domain
  -----------------------------------------------------------------------------
  -----------------------------------------------------------------------------
  -- First stage of clock domain crossing 
  -- Clock binary to gray value of the read pointer in RD_CLK domain
  -----------------------------------------------------------------------------
  -- rd_pntr_gc is reset to 0. Because it is a gray coded signal the reset 
  -- value "0" is actually the gray code for binary "0". If it has to be 
  -- initialized to a non-zero value, make sure to use the bin2gray function.

  prgc : PROCESS (RD_CLK, RD_RST)
  BEGIN
    if (RD_RST='1' AND C_HAS_RST = 1) then
      rd_pntr_gc <= zeros_rd;
    ELSIF (RD_CLK'event AND RD_CLK='1') THEN
      rd_pntr_gc <= bin2gray(RD_PNTR) AFTER TFF;
    END IF;
  END PROCESS prgc;

  -----------------------------------------------------------------------------
  -- Fourth stage of clock domain crossing 
  -- Clock gray to binary value of the read pointer in WR_CLK domain
  -----------------------------------------------------------------------------
  prbin : PROCESS (WR_CLK, WR_RST)
  BEGIN
    if (WR_RST='1' AND C_HAS_RST = 1) then
      rd_pntr_bin <= zeros_rd; 
    ELSIF (WR_CLK'event AND WR_CLK='1') THEN
      rd_pntr_bin <= gray2bin(rd_pntr_gc_asreg_last ) AFTER TFF;
    END IF;
  END PROCESS prbin;

  -- Connect the output ports
  WR_PNTR_RD <= wr_pntr_bin;
  RD_PNTR_WR <= rd_pntr_bin;

END xilinx;
