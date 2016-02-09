-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : xd_sync_module.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2013-01-22
-- Platform   :
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- (c) Copyright 2012 Xilinx, Inc. All rights reserved.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-05  1.0      rmg/jn  Created
-- 2013-07-12  2.0      pankajk Added new ports iscalar_rqt_enable & 
--                              iscalar_rqt_enable to qualify with 
--                              iscalar_start & oscalar_start
-------------------------------------------------------------------------------
-- ****************************************************************************
--
-- (c) Copyright 2010, 2011 Xilinx, Inc. All rights reserved.
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
-- ****************************************************************************
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;
use axis_accelerator_adapter_v2_1_6.async_fifo_dist_wt;
use axis_accelerator_adapter_v2_1_6.sync_ap_status;
use axis_accelerator_adapter_v2_1_6.cdc_sync;


entity xd_sync_module is
  generic (
    -- System generics:
    C_FAMILY              : string;  -- Xilinx FPGA family
    C_MAX_N_IARGS         : integer;
    C_MAX_N_OARGS         : integer;
    C_N_INPUT_ARGS        : integer;
    C_N_OUTPUT_ARGS       : integer;
    C_PRMRY_IS_ACLK_ASYNC : integer;
    C_MTBF_STAGES         : integer;
    C_MAX_N_ISCALARS      : integer;
    C_N_INPUT_SCALARS     : integer;
    C_MAX_N_OSCALARS      : integer;
    C_N_INOUT_SCALARS     : integer;
    C_MAX_N_IOSCALARS     : integer;
    C_N_OUTPUT_SCALARS    : integer;
    C_NONE                : integer := 2);
  port (
    -- SLAVE AXI LITE:
    S_AXI_ACLK          : in  std_logic;
    S_AXI_ARESETN       : in  std_logic;
    -- Host command input port
    host_cmd_data       : in  std_logic_vector(31 downto 0);
    host_cmd_we         : in  std_logic;
    host_cmd_rdy        : out std_logic;
    host_complete_re    : in  std_logic;
    host_cmd_error      : out std_logic;
    ---
    iarg_rqt_enable     : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    oarg_rqt_enable     : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ---
    status_ap_start     : out std_logic;
    status_ap_done      : out std_logic;
    status_ap_idle      : out std_logic;
    status_ap_ready     : out std_logic;
    status_ap_start_clr : in  std_logic;
    status_ap_done_clr  : in  std_logic;
    status_ap_idle_clr  : in  std_logic;
    status_ap_ready_clr : in  std_logic;
    ---
    status_iarg_rqt     : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    status_iarg_ack     : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    status_oarg_rqt     : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    status_oarg_ack     : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ---
    ap_clk              : in  std_logic;
    soft_rst            : in  std_logic;
    ap_rst              : in  std_logic;
    
    --- Control and status signals for multibuffers
    mb_iarg_rdy         : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    mb_iarg_done        : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    mb_oarg_rdy         : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    mb_oarg_done        : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    -- AP control handshaking
    ap_start            : out std_logic;
    ap_ready            : in  std_logic;
    ap_done             : in  std_logic;
    ap_continue         : out std_logic;
    ap_idle             : in  std_logic;
    ap_start_one_shot   : out std_logic;
    ---
    iscalar_rqt_enable  : in std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    oscalar_rqt_enable  : in std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);

    ---
    ap_iscalar_rdy      : in  std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    ap_iscalar_done     : out std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    ---
    ap_oscalar_vld      : out std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    ap_oscalar_rdy      : in  std_logic_vector(C_MAX_N_OSCALARS-1 downto 0));
end entity;

architecture rtl of xd_sync_module is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";


  type state_type is (
    idle,
    apply_input_mask,
    wait_start,
    wait_done,
    stop);
  signal state : state_type;

  signal ap_start_i : std_logic;

  ---------------------------------------
  constant OPCODE_WIDTH : integer := 4;

  constant ARG_MASK_LSB    : integer                                   := 0;
  constant ARG_MASK_MSB    : integer                                   := 7;
  constant SCALAR_MASK_LSB : integer                                   := 8;
  constant SCALAR_MASK_MSB : integer                                   := 15;
  constant OPCODE_LSB      : integer                                   := 16;
  constant OPCODE_MSB      : integer                                   := OPCODE_LSB+OPCODE_WIDTH-1;
  constant ISCALAR_MASK_LSB: integer                                   := OPCODE_MSB+1;
  constant ISCALAR_MASK_MSB: integer                                   := ISCALAR_MASK_LSB+7;


  -- input commands
  constant UPDATE_INPUT    : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0000";
  constant UPDATE_OUTPUT   : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0001";
  constant EXECUTE_STEP    : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0010";
  constant EXECUTE_RESUME  : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0100";
  constant EXECUTE_STOP    : std_logic_vector(OPCODE_WIDTH-1 downto 0) := "0101";
  --
  constant EXECUTE         : std_logic_vector(1 downto 0)              := "10";
  constant IARG_UM_LSB     : integer                                   := 0;
  constant OARG_UM_LSB     : integer                                   := 8;
  constant ISCALAR_UM_LSB  : integer                                   := 16;
  constant OSCALAR_UM_LSB  : integer                                   := 24;

-- pragma translate_off
  type dbg_opcode_type is (
    op_update_input,
    op_update_output,
    op_exec_step,
    op_exec_resume,
    op_exec_stop,
    op_invalid);

  signal dbg_opcode : dbg_opcode_type;
-- pragma translate_on


  signal command_full     : std_logic;
  signal command          : std_logic_vector(31 downto 0);
  signal command_vld      : std_logic;
  signal command_rdy      : std_logic;
  --
  signal arg_mask         : std_logic_vector(7 downto 0);
  signal scalar_mask      : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal opcode           : std_logic_vector(OPCODE_WIDTH-1 downto 0);
  --
  signal input_mask_we    : std_logic;
  signal input_mask_clr   : std_logic;
  signal output_mask_we   : std_logic;
  signal output_mask_clr  : std_logic;
  --
  signal iarg_mask        : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal oarg_mask        : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal iscalar_mask     : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal oscalar_mask     : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  --
  signal iarg_start       : std_logic;
  signal iarg_start_sync  : std_logic;
  signal oarg_start       : std_logic;
  signal oarg_start_sync  : std_logic;
  signal iscalar_start    : std_logic;
  signal iscalar_start_sync: std_logic;
  signal oscalar_start    : std_logic;
  signal oscalar_start_sync    : std_logic;
  signal global_start     : std_logic;
  --
  signal mb_iarg_done_i   : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal mb_oarg_done_i   : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  --
  -- Core ap_start delayed version.
  signal core_ap_start    : std_logic;
  signal set_ap_start     : std_logic;
  signal set_ap_start_r   : std_logic;
  signal clr_ap_start     : std_logic;
  
  signal run_continous    : std_logic;
  signal ap_cmd_error     : std_logic;
  signal host_cmd_error_i : std_logic;

  signal axi_rst         : std_logic;
  
  --- Syncrhonizer signals
  signal iarg_rqt_enable_sync : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal oarg_rqt_enable_sync : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal ap_start_i_sync      : std_logic;
  signal ap_done_sync         : std_logic;
  signal ap_idle_sync         : std_logic;
  signal ap_ready_sync        : std_logic;
  signal ap_cmd_error_sync    : std_logic;
  signal ap_rstn              : std_logic;
  signal ap_rst_vec         : std_logic_vector(0 downto 0);
  signal ap_rst_axi_sync    : std_logic;
  signal ap_rst_sync        : std_logic_vector(0 downto 0);
  signal axin_rst            : std_logic;

  constant C_EXTRA_SYNCS  : integer            := 1;

      ATTRIBUTE async_reg           : STRING;
  ATTRIBUTE async_reg OF axi_rst  : SIGNAL IS "true";

begin

 
   -- Active low ap_rst
   ap_rstn <= not ap_rst;
   
   
   ----------------------
   --- Reset Synchronizer
   ----------------------
--   EN_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
--   begin
--   
--
--    XD_IARG_RQT_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
--        generic map (
--        C_CDC_TYPE                 => 1,
--        C_RESET_STATE              => 0,
--        C_SINGLE_BIT               => 0,
--        C_FLOP_INPUT               => 1,
--        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
--        C_MTBF_STAGES              => C_MTBF_STAGES
--        )
--        port map (
--        prmry_aclk                 => S_AXI_ACLK,
--        prmry_resetn               => S_AXI_ARESETN,
--        prmry_in                   => '0',
--        prmry_vect_in              => iarg_rqt_enable,
--
--        scndry_aclk                => ap_clk,
--        scndry_resetn              => ap_rstn,
--        scndry_out                 => open,
--        scndry_vect_out            => iarg_rqt_enable_sync
--        );
--
--
--    XD_OARG_RQT_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
--        generic map (
--        C_CDC_TYPE                 => 1,
--        C_RESET_STATE              => 0,
--        C_SINGLE_BIT               => 0,
--        C_FLOP_INPUT               => 0,
--        C_VECTOR_WIDTH             => C_MAX_N_OARGS,
--        C_MTBF_STAGES              => C_MTBF_STAGES
--        )
--        port map (
--        prmry_aclk                 => S_AXI_ACLK,
--        prmry_resetn               => S_AXI_ARESETN,
--        prmry_in                   => '0',
--        prmry_vect_in              => oarg_rqt_enable,
--
--        scndry_aclk                => ap_clk,
--        scndry_resetn              => ap_rstn,
--        scndry_out                 => open,
--        scndry_vect_out            => oarg_rqt_enable_sync
--        );
--    
--   end generate EN_SYNC_GEN;
--
--   NO_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
--   begin
   
       iarg_rqt_enable_sync <= iarg_rqt_enable;
       oarg_rqt_enable_sync <= oarg_rqt_enable;
    
--   end generate NO_SYNC_GEN;


   ----------------------
   --- Reset Synchronizer
   ----------------------
   EN_APCLK_LITE_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
   begin
   

    AP_START_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 0,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_start_i,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_start_i_sync,
        scndry_vect_out            => open
        );


    AP_DONE_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_done,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_done_sync,
        scndry_vect_out            => open
        );

    AP_IDLE_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_idle,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_idle_sync,
        scndry_vect_out            => open
        );

    AP_READY_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_ready,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_ready_sync,
        scndry_vect_out            => open
        );
    
    AP_CMDERR_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 0,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_cmd_error,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_cmd_error_sync,
        scndry_vect_out            => open
        );

	
   end generate EN_APCLK_LITE_SYNC_GEN;


   NO_APCLK_LITE_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
   begin
--   
--       ap_start_i_sync   <= ap_start_i;
--       ap_done_sync      <= ap_done;
--       ap_idle_sync      <= ap_idle;
--       ap_ready_sync     <= ap_ready;
--       ap_cmd_error_sync <= ap_cmd_error;
--    
     AP_START_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 0,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2--C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_start_i,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_start_i_sync,
        scndry_vect_out            => open
        );


    AP_DONE_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2--C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_done,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_done_sync,
        scndry_vect_out            => open
        );

    AP_IDLE_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2--C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_idle,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_idle_sync,
        scndry_vect_out            => open
        );

    AP_READY_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2--C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_ready,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_ready_sync,
        scndry_vect_out            => open
        );
    
    AP_CMDERR_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 0,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 0,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2--C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rstn,
        prmry_in                   => ap_cmd_error,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => ap_cmd_error_sync,
        scndry_vect_out            => open
        );

   end generate NO_APCLK_LITE_SYNC_GEN;


   ----------------------
   --- Reset Synchronizer
   ----------------------
 
 
  mb_iarg_done <= mb_iarg_done_i;
  mb_oarg_done <= mb_oarg_done_i;

  axin_rst <= not(S_AXI_ARESETN);
 -- axi_rst <= not(S_AXI_ARESETN) or ap_rst;
--    ap_rst_vec(0) <=  ap_rst;
--
--    rst_sync: ENTITY axis_accelerator_adapter_v2_1_6.synchronizer_ff
--    GENERIC MAP (
--     C_HAS_RST => 1,
--     C_WIDTH   => 1
--     )
--    PORT MAP ( 
--     RST       => S_AXI_ARESETN,
--     CLK       => S_AXI_ACLK,   
--     D         => ap_rst_vec,
--     Q         => ap_rst_sync
--     );    

--     process(S_AXI_ACLK)
--       begin
--         if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
--             ap_rst_vec(0) <=  ap_rst;
--             ap_rst_sync(0) <= ap_rst_vec(0);
--         end if;
--     end process;

--     process(S_AXI_ACLK, S_AXI_ARESETN)
--       begin
--         if(S_AXI_ARESETN='0') then
--             axi_rst    <= '1';
--         elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
--             axi_rst    <= ap_rst_axi_sync;
--         end if;
--     end process;

      ap_rst_axi_sync1 : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
       generic map (
       C_CDC_TYPE                 => 1,
       C_RESET_STATE              => 1,
       C_SINGLE_BIT               => 1,
       C_FLOP_INPUT               => 0,
       C_VECTOR_WIDTH             => 1,
       C_MTBF_STAGES              => 2
       )
       port map (
       prmry_aclk                 => '0',
       prmry_resetn               => '0',
       prmry_in                   => ap_rst,
       prmry_vect_in              => (others=>'0'),

       scndry_aclk                => S_AXI_ACLK,
       scndry_resetn              => S_AXI_ARESETN,
       scndry_out                 => axi_rst,
       scndry_vect_out            => open
       );




  ---------------------------------------
  COMMAND_FIFO_NEW : entity axis_accelerator_adapter_v2_1_6.async_fifo_dist_inst
    generic map (
      C_FAMILY => C_FAMILY,
      DEPTH    => 32,
      WIDTH    => 32)
    port map (
      din      => host_cmd_data,
      din_vld  => host_cmd_we,
      din_rdy  => host_cmd_rdy,
      wr_clk   => S_AXI_ACLK,
      wr_rst   => axi_rst,
      dout     => command,
      dout_vld => command_vld,
      dout_rdy => command_rdy,
      rd_clk   => ap_clk,
      rd_rst   => ap_rst);

  arg_mask    <= command(ARG_MASK_MSB downto ARG_MASK_LSB);
  scalar_mask <= command(ISCALAR_MASK_MSB downto ISCALAR_MASK_LSB) & command(SCALAR_MASK_MSB downto SCALAR_MASK_LSB);
  --scalar_mask <= command(SCALAR_MASK_MSB downto SCALAR_MASK_LSB);
  opcode      <= command(OPCODE_MSB downto OPCODE_LSB);

  process(ap_clk)
  begin
    if(ap_clk'event and ap_clk = '1') then
      if(ap_rst = '1' or input_mask_clr = '1') then
        iarg_mask    <= (others => '0');
        iscalar_mask <= (others => '0');
      elsif(input_mask_we = '1') then
        iarg_mask    <= iarg_mask or arg_mask;
        iscalar_mask <= iscalar_mask or scalar_mask;
      end if;
    end if;
  end process;

  process(ap_clk)
  begin
    if(ap_clk'event and ap_clk = '1') then
      if(ap_rst = '1' or output_mask_clr = '1') then
        oarg_mask    <= (others => '0');
        oscalar_mask <= (others => '0');
      elsif(output_mask_we = '1') then
        oarg_mask    <= oarg_mask or arg_mask;
        oscalar_mask <= oscalar_mask or scalar_mask(15 downto 0);
      end if;
    end if;
  end process;

  ----------------------------------------

  
  USE_INPUT_ARGS_GEN : if (C_N_INPUT_ARGS > 0) generate
  begin
    iarg_start <= and_reduce(mb_iarg_rdy(C_N_INPUT_ARGS-1 downto 0) or not(iarg_rqt_enable_sync(C_N_INPUT_ARGS-1 downto 0)));
  end generate USE_INPUT_ARGS_GEN;

  NO_INPUT_ARGS_GEN : if (C_N_INPUT_ARGS = 0) generate
  begin
    iarg_start <= '1';
  end generate NO_INPUT_ARGS_GEN;

  USE_OUTPUT_ARGS_GEN : if (C_N_OUTPUT_ARGS > 0) generate
  begin
    oarg_start <= and_reduce(mb_oarg_rdy(C_N_OUTPUT_ARGS-1 downto 0) or not(oarg_rqt_enable_sync(C_N_OUTPUT_ARGS-1 downto 0)));
  end generate USE_OUTPUT_ARGS_GEN;

  NO_OUTPUT_ARGS_GEN : if (C_N_OUTPUT_ARGS = 0) generate
  begin
    oarg_start <= '1';
  end generate NO_OUTPUT_ARGS_GEN;

  USE_INPUT_SCALAR_GEN1 : if (C_N_INPUT_SCALARS+C_N_INOUT_SCALARS > 0 ) generate
  begin
    iscalar_start <= and_reduce((ap_iscalar_rdy(C_MAX_N_ISCALARS-1 downto 0)) or not(iscalar_rqt_enable(C_MAX_N_ISCALARS-1 downto 0)));
    --iscalar_start <= and_reduce(ap_iscalar_rdy(C_N_INPUT_SCALARS-1 downto 0) or not(iscalar_rqt_enable(C_N_INPUT_SCALARS-1 downto 0))) and and_reduce(ap_iscalar_rdy(C_MAX_N_ISCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_ISCALARS) or not(iscalar_rqt_enable(C_MAX_N_ISCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_ISCALARS)));
  end generate USE_INPUT_SCALAR_GEN1;

--  USE_INPUT_SCALAR_GEN2 : if (C_N_INPUT_SCALARS > 0 and C_N_INOUT_SCALARS = 0) generate
--  begin
--    --iscalar_start <= and_reduce(ap_iscalar_rdy(C_N_INPUT_SCALARS-1 downto 0));
--    iscalar_start <= and_reduce(ap_iscalar_rdy(C_N_INPUT_SCALARS-1 downto 0) or not(iscalar_rqt_enable(C_N_INPUT_SCALARS-1 downto 0)));
--  end generate USE_INPUT_SCALAR_GEN2;
--
--  USE_INPUT_SCALAR_GEN3 : if (C_N_INPUT_SCALARS = 0 and C_N_INOUT_SCALARS > 0) generate
--  begin
--    --iscalar_start <= and_reduce(ap_iscalar_rdy(C_N_INPUT_SCALARS-1 downto 0));
--    iscalar_start <= and_reduce(ap_iscalar_rdy(C_N_INOUT_SCALARS+C_MAX_N_ISCALARS-1 downto C_MAX_N_ISCALARS) or not(iscalar_rqt_enable(C_N_INOUT_SCALARS+C_MAX_N_ISCALARS-1 downto C_MAX_N_ISCALARS)));
--  end generate USE_INPUT_SCALAR_GEN3;


  NO_INPUT_SCALAR_GEN : if (C_N_INPUT_SCALARS = 0 and C_N_INOUT_SCALARS = 0) generate
  begin
    iscalar_start <= '1';
  end generate NO_INPUT_SCALAR_GEN;

  USE_OUTPUT_SCALAR_GEN1 : if (C_N_OUTPUT_SCALARS+C_N_INOUT_SCALARS > 0 ) generate
  begin
    oscalar_start <= and_reduce((ap_oscalar_rdy(C_MAX_N_OSCALARS-1 downto 0)) or not(oscalar_rqt_enable(C_MAX_N_OSCALARS-1 downto 0)));
    --oscalar_start <= and_reduce(ap_oscalar_rdy(C_N_OUTPUT_SCALARS-1 downto 0) or not(oscalar_rqt_enable(C_N_OUTPUT_SCALARS-1 downto 0)));
  end generate USE_OUTPUT_SCALAR_GEN1;

--  USE_OUTPUT_SCALAR_GEN2 : if (C_N_OUTPUT_SCALARS > 0 and C_N_INOUT_SCALARS > 0) generate
--  begin
--    --oscalar_start <= and_reduce(ap_oscalar_rdy(C_N_OUTPUT_SCALARS-1 downto 0));
--    oscalar_start <= and_reduce(ap_oscalar_rdy(C_N_INOUT_SCALARS+C_MAX_N_OSCALARS-1 downto C_MAX_N_OSCALARS) or not(oscalar_rqt_enable(C_N_INOUT_SCALARS+C_MAX_N_OSCALARS-1 downto C_MAX_N_OSCALARS))) and and_reduce(ap_oscalar_rdy(C_N_OUTPUT_SCALARS-1 downto 0) or not(oscalar_rqt_enable(C_N_OUTPUT_SCALARS-1 downto 0)));
--  end generate USE_OUTPUT_SCALAR_GEN2;
--
--  USE_OUTPUT_SCALAR_GEN3 : if (C_N_OUTPUT_SCALARS = 0 and C_N_INOUT_SCALARS > 0) generate
--  begin
--    --oscalar_start <= and_reduce(ap_oscalar_rdy(C_N_OUTPUT_SCALARS-1 downto 0));
--    oscalar_start <= and_reduce(ap_oscalar_rdy(C_N_INOUT_SCALARS+C_MAX_N_OSCALARS-1 downto C_MAX_N_OSCALARS) or not(oscalar_rqt_enable(C_N_INOUT_SCALARS+C_MAX_N_OSCALARS-1 downto C_MAX_N_OSCALARS)));
--  end generate USE_OUTPUT_SCALAR_GEN3;

  NO_OUTPUT_SCALAR_GEN : if (C_N_OUTPUT_SCALARS = 0 and C_N_INOUT_SCALARS = 0) generate
  begin
    oscalar_start <= '1';
  end generate NO_OUTPUT_SCALAR_GEN;


-- pragma translate_off
  process(opcode)
  begin
    dbg_opcode <= op_invalid;
    case opcode is
      when UPDATE_INPUT   => dbg_opcode <= op_update_input;
      when UPDATE_OUTPUT  => dbg_opcode <= op_update_output;
      when EXECUTE_STEP   => dbg_opcode <= op_exec_step;
      when EXECUTE_RESUME => dbg_opcode <= op_exec_resume;
      when EXECUTE_STOP   => dbg_opcode <= op_exec_stop;
      when others         => null;
    end case;
  end process;
-- pragma translate_on

EXISTING : if (C_EXTRA_SYNCS = 0) generate
begin

  global_start <= iarg_start and oarg_start and iscalar_start and oscalar_start;
end generate EXISTING;

NEW_INTRO : if (C_EXTRA_SYNCS = 1) generate
begin

         AP_IARGSTART_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rst,
	prmry_in                   => iarg_start,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => ap_clk,
        scndry_resetn              => ap_rst,
        scndry_out                 => iarg_start_sync,
        scndry_vect_out            => open
        );

    AP_OARGSTART_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => S_AXI_ACLK,
        prmry_resetn               => S_AXI_ARESETN,
	prmry_in                   => oarg_start,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => ap_clk,
        scndry_resetn              => ap_rst,
        scndry_out                 => oarg_start_sync,
        scndry_vect_out            => open
        );

   AP_ISCALARSTART_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => S_AXI_ACLK,
        prmry_resetn               => S_AXI_ARESETN,
	prmry_in                   => iscalar_start,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => ap_clk,
        scndry_resetn              => ap_rst,
	scndry_out                 => iscalar_start_sync,
        scndry_vect_out            => open
        );

   AP_OSCALARSTART_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => S_AXI_ACLK,
        prmry_resetn               => S_AXI_ARESETN,
	prmry_in                   => oscalar_start,
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => ap_clk,
        scndry_resetn              => ap_rst,
	scndry_out                 => oscalar_start_sync,
        scndry_vect_out            => open
        );


  global_start <= iarg_start_sync and oarg_start_sync and iscalar_start_sync and oscalar_start_sync;
end generate NEW_INTRO;

  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      state             <= idle;
      ap_start_i        <= '0';
      ap_start_one_shot <= '0';
      run_continous     <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      ap_start_i        <= '0';
      ap_start_one_shot <= '0';
      case state is
        when idle =>
          -- Wait until there is a command available
          if (command_vld = '1') then
            case opcode is
              when EXECUTE_STEP =>
                state <= wait_start;
              when EXECUTE_RESUME =>
                run_continous <= '1';
                state         <= wait_start;
              when others =>
            end case;
          end if;

        when apply_input_mask =>
          -- In this state we apply the command. For input arguments and
          -- scalars we give a "done" of the elements.
          state <= wait_start;

        when wait_start =>
          if (run_continous = '0') then
            -- accelerator start is given when:
            -- 1.- all input arguments have data valid to process.
            -- 2.- all ouput arguments have free memory where to wite the
            -- processed data.
            if (global_start = '1') then
              state             <= wait_done;
              ap_start_i        <= '1';
              ap_start_one_shot <= '1';
            end if;

          else

            if (command_vld = '1') then
              case opcode is
                when EXECUTE_STOP =>
                  run_continous <= '0';
                  state         <= idle;
                when others =>
                  state <= stop;
              end case;
            elsif (global_start = '1') then
              state             <= wait_done;
              ap_start_i        <= '1';
              ap_start_one_shot <= '1';
            end if;

          end if;

        when wait_done =>
          if(ap_done = '1') then
            if (run_continous = '0') then
              state <= idle;
            else
              state <= apply_input_mask;
            end if;
          end if;

        when others =>
      end case;
    end if;
  end process;

  ap_start <= core_ap_start;

  process(state, global_start, run_continous, command_vld, opcode, iarg_mask, iscalar_mask,
          arg_mask, scalar_mask,
          ap_done, oarg_mask, oscalar_mask)
  begin
    command_rdy    <= '0';
    input_mask_we  <= '0';
    output_mask_we <= '0';

    input_mask_clr  <= '0';
    output_mask_clr <= '0';

    mb_iarg_done_i  <= (others => '0');
    ap_iscalar_done <= (others => '0');
    mb_oarg_done_i  <= (others => '0');
    ap_oscalar_vld  <= (others => '0');

    set_ap_start <= '0';
    ap_cmd_error <= '0';

    case state is
      when idle =>
        command_rdy <= command_vld;

        if(command_vld = '1') then
          case opcode is
            when UPDATE_INPUT =>
              input_mask_we   <= '1';
              mb_iarg_done_i  <= arg_mask;
              ap_iscalar_done <= scalar_mask;
            when UPDATE_OUTPUT =>
              output_mask_we <= '1';
            when EXECUTE_STEP   =>
            when EXECUTE_RESUME =>
            when EXECUTE_STOP   =>
            when others         =>
          end case;
        end if;

      when apply_input_mask =>
        mb_iarg_done_i  <= iarg_mask;
        ap_iscalar_done <= iscalar_mask;

      when wait_start =>
        if (run_continous = '0') then
          set_ap_start <= global_start;
        else
          if (command_vld = '1') then
            command_rdy <= '1';
            if (opcode = EXECUTE_STOP) then
              input_mask_clr  <= '1';
              output_mask_clr <= '1';
            else
              ap_cmd_error <= '1';
            end if;
          else
            set_ap_start <= global_start;
          end if;
        end if;

      when wait_done =>
        if(ap_done = '1') then
          -- Toggle the output argument multibuffer (if enabled)
          if (C_N_OUTPUT_ARGS > 0) then
            mb_oarg_done_i(C_N_OUTPUT_ARGS-1 downto 0) <= oarg_mask(C_N_OUTPUT_ARGS-1 downto 0);
          end if;
          -- Write values in output FIFOs (if enabled)
          if (C_N_OUTPUT_SCALARS+C_N_INOUT_SCALARS > 0) then
            ap_oscalar_vld(C_MAX_N_OSCALARS-1 downto 0) <= oscalar_mask(C_MAX_N_OSCALARS-1 downto 0);
          end if;
         -- if (C_N_INOUT_SCALARS > 0) then
         --   ap_oscalar_vld(C_MAX_N_OSCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_OSCALARS) <= oscalar_mask(C_MAX_N_OSCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_OSCALARS);
         -- end if;
          -- clear input/output masks before we start a new iteration
          input_mask_clr  <= not(run_continous);
          output_mask_clr <= not(run_continous);
        end if;

      when others =>
    end case;
  end process;

  clr_ap_start <= ap_ready;

  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      set_ap_start_r <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      set_ap_start_r <= set_ap_start;
    end if;
  end process;

  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      core_ap_start <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      -- Core ap_start delayed version.
      if(core_ap_start = '0') then
        core_ap_start <= set_ap_start_r;
      else
        core_ap_start <= not(clr_ap_start);
      end if;
    end if;
  end process;

  ---------------------------
  SYNC_AP_START_I : entity axis_accelerator_adapter_v2_1_6.sync_ap_status
    port map (
      rst      => soft_rst,
      ap_clk   => S_AXI_ACLK,
      ap_flag  => ap_start_i_sync,
      axi_clk  => S_AXI_ACLK,
      flag     => status_ap_start,
      flag_clr => status_ap_start_clr);

  SYNC_AP_DONE_I : entity axis_accelerator_adapter_v2_1_6.sync_ap_status
    port map (
      rst      => soft_rst,
      ap_clk   => S_AXI_ACLK,
      ap_flag  => ap_done_sync,
      axi_clk  => S_AXI_ACLK,
      flag     => status_ap_done,
      flag_clr => status_ap_done_clr);

  STATUS_AP_IDLE_I : entity axis_accelerator_adapter_v2_1_6.sync_ap_status
    port map (
      rst      => soft_rst,
      ap_clk   => S_AXI_ACLK,
      ap_flag  => ap_idle_sync,
      axi_clk  => S_AXI_ACLK,
      flag     => status_ap_idle,
      flag_clr => status_ap_idle_clr);

  STATUS_AP_READY_I : entity axis_accelerator_adapter_v2_1_6.sync_ap_status
    port map (
      rst      => soft_rst,
      ap_clk   => S_AXI_ACLK,
      ap_flag  => ap_ready_sync,
      axi_clk  => S_AXI_ACLK,
      flag     => status_ap_ready,
      flag_clr => status_ap_ready_clr);

  SYNC_AP_CMD_ERROR_I : entity work.sync_ap_status
    port map (
      rst      => soft_rst,
      ap_clk   => S_AXI_ACLK,
      ap_flag  => ap_cmd_error_sync,
      axi_clk  => S_AXI_ACLK,
      flag     => host_cmd_error_i,
      flag_clr => host_cmd_error_i);

  host_cmd_error <= host_cmd_error_i;

  -- TODO:
  status_iarg_rqt <= (others => '0');
  status_iarg_ack <= (others => '0');
  status_oarg_rqt <= (others => '0');
  status_oarg_ack <= (others => '0');

  ap_continue <= ap_done;
  
  
  

end rtl;
