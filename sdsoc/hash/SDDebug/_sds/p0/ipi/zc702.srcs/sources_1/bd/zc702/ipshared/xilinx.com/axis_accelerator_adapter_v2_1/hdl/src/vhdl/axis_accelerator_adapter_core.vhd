-------------------------------------------------------------------------------
-- axis_accelerator_adapter_core.vhd - Entity and architecture
-------------------------------------------------------------------------------
--
-- *******************************************************************
-- ** (c) Copyright [2010] - [2013] Xilinx, Inc. All rights reserved.*
-- **                                                                *
-- ** This file contains confidential and proprietary information    *
-- ** of Xilinx, Inc. and is protected under U.S. and                *
-- ** international copyright and other intellectual property        *
-- ** laws.                                                          *
-- **                                                                *
-- ** DISCLAIMER                                                     *
-- ** This disclaimer is not a license and does not grant any        *
-- ** rights to the materials distributed herewith. Except as        *
-- ** otherwise provided in a valid license issued to you by         *
-- ** Xilinx, and to the maximum extent permitted by applicable      *
-- ** law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND        *
-- ** WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES    *
-- ** AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING      *
-- ** BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-         *
-- ** INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and       *
-- ** (2) Xilinx shall not be liable (whether in contract or tort,   *
-- ** including negligence, or under any other theory of             *
-- ** liability) for any loss or damage of any kind or nature        *
-- ** related to, arising under or in connection with these          *
-- ** materials, including for any direct, or any indirect,          *
-- ** special, incidental, or consequential loss or damage           *
-- ** (including loss of data, profits, goodwill, or any type of     *
-- ** loss or damage suffered as a result of any action brought      *
-- ** by a third party) even if such damage or loss was              *
-- ** reasonably foreseeable or Xilinx had been advised of the       *
-- ** possibility of the same.                                       *
-- **                                                                *
-- ** CRITICAL APPLICATIONS                                          *
-- ** Xilinx products are not designed or intended to be fail-       *
-- ** safe, or for use in any application requiring fail-safe        *
-- ** performance, such as life-support or safety devices or         *
-- ** systems, Class III medical devices, nuclear facilities,        *
-- ** applications related to the deployment of airbags, or any      *
-- ** other applications that could lead to death, personal          *
-- ** injury, or severe property or environmental damage             *
-- ** (individually and collectively, "Critical                      *
-- ** Applications"). Customer assumes the sole risk and             *
-- ** liability of any use of Xilinx products in Critical            *
-- ** Applications, subject only to applicable laws and              *
-- ** regulations governing limitations on product liability.        *
-- **                                                                *
-- ** THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS       *
-- ** PART OF THIS FILE AT ALL TIMES.                                *
-- *******************************************************************
--
-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : axis_accelerator_adapter_core.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2013-10-25
-- Platform   :
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Structure:
--
--              axis_accelerator_adapter.vhd
--              xd_adapter_pkg.vhd
--              axis_accelerator_adapter_core.vhd
--                   |-- axi_lite_adapter
--                   |-- cdc_sync.vhd
--                   |-- xd_input_args_module.vhd
--                     |-- xd_s2m_adapter.vhd
--                        |-- xd_s2m_converter.vhd
--                        |-- xd_s2m_memory_dc.vhd
--                     |-- xd_iarg_s2s_adapter.vhd
--                        |-- s2s_async_fifo_wt.vhd
--                   |-- xd_output_args_module.vhd
--                     |-- cdc_sync.vhd
--                     |-- xd_m2s_adapter.vhd
--                        |-- xd_m2s_converter.vhd
--                        |-- xd_m2s_memory_dc.vhd
--                           |-- arg_mem_bank.vhd
--                              |-- asymmetric_dp_bank_v6.vhd
--                              |-- symmetric_dp_bank_v6.vhd
--                              |-- dp_bank_sdp_v6.vhd
--                           |-- oarg_columnized_mem_bank.vhd
--                           |-- srl_fifo_32_wt.vhd
--                     |-- xd_oarg_s2s_adapter.vhd
--                        |-- s2s_async_fifo_wt.vhd
--                   |-- xd_sync_module.vhd
--                       |-- cdc_sync.vhd
--                       |-- sync_ap_status.vhd
--                       |-- async_fifo_dist_wt.vhd
--                   |-- xd_input_scalars_module.vhd
--                       |-- xd_input_scalars_fifo.vhd
--                   |-- xd_output_scalars_module.vhd
--                       |-- xd_output_scalars_fifo.vhd
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-05  1.0      rmg/jn  Created
-- 2013-07-19  2.0      pvk     New ports added for scalar valid and ack
-- 2013-10-25  2.0      pvk     Added support for UltraScale primitives. 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;
use axis_accelerator_adapter_v2_1_6.axi_lite_adapter;
use axis_accelerator_adapter_v2_1_6.xd_input_args_module;
use axis_accelerator_adapter_v2_1_6.xd_output_args_module;
use axis_accelerator_adapter_v2_1_6.xd_sync_module;
use axis_accelerator_adapter_v2_1_6.cdc_sync;
use axis_accelerator_adapter_v2_1_6.xd_input_scalars_module;
use axis_accelerator_adapter_v2_1_6.xd_output_scalars_module;


entity axis_accelerator_adapter_core is
  generic (
    -- System generics:
    C_FAMILY                : string                    := "virtex7";  -- Xilinx FPGA family
    C_BRAM_TYPE             : string                    := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2

    ---
    C_S_AXI_ADDR_WIDTH      : integer                   := 13;
    C_S_AXI_DATA_WIDTH      : integer range 32 to 32    := 32;
    C_PRMRY_IS_ACLK_ASYNC   : integer := 0;
    C_MTBF_STAGES           : integer := 2;
    ---
    C_AP_ADAPTER_ID         : integer range 0 to 15;
    C_MAX_SCALAR_DWIDTH     : integer;
    C_MAX_ARG_DWIDTH        : integer;
    C_MAX_ARG_AWIDTH        : integer;
    C_MAX_ARG_N_DIM         : integer;
    C_MAX_MB_DEPTH          : integer;
    C_MAX_N_IARGS           : integer;
    C_MAX_N_OARGS           : integer;
    C_MAX_N_ISCALARS        : integer;
    C_MAX_N_OSCALARS        : integer;
    C_MAX_N_IOSCALARS       : integer;
    ---
    C_N_INPUT_ARGS          : integer;
    C_N_OUTPUT_ARGS         : integer;
    ---
    C_S_AXIS_TDATA_WIDTH    : integer;
    C_S_AXIS_TUSER_WIDTH    : integer;
    C_S_AXIS_TID_WIDTH      : integer;
    C_S_AXIS_TDEST_WIDTH    : integer;
    ---
    C_AP_IARG_TYPE          : std_logic_vector;
    C_AP_IARG_DWIDTH        : std_logic_vector;
    C_AP_IARG_MB_DEPTH      : std_logic_vector;
    C_AP_IARG_WIDTH         : std_logic_vector;
    C_AP_IARG_N_DIM         : std_logic_vector;
    C_AP_IARG_DIM_1         : std_logic_vector;
    C_AP_IARG_DIM_2         : std_logic_vector;
    C_AP_IARG_FORMAT_TYPE   : std_logic_vector;
    C_AP_IARG_FORMAT_FACTOR : std_logic_vector;
    C_AP_IARG_FORMAT_DIM    : std_logic_vector;
    ---
    C_M_AXIS_TDATA_WIDTH    : integer;
    C_M_AXIS_TUSER_WIDTH    : integer;
    C_M_AXIS_TID_WIDTH      : integer;
    C_M_AXIS_TDEST_WIDTH    : integer;
    ---
    C_AP_OARG_TYPE          : std_logic_vector;
    C_AP_OARG_DWIDTH        : std_logic_vector;
    C_AP_OARG_MB_DEPTH      : std_logic_vector;
    C_AP_OARG_WIDTH         : std_logic_vector;
    C_AP_OARG_N_DIM         : std_logic_vector;
    C_AP_OARG_DIM           : std_logic_vector;
    C_AP_OARG_DIM_1         : std_logic_vector;
    C_AP_OARG_DIM_2         : std_logic_vector;
    C_AP_OARG_FORMAT_TYPE   : std_logic_vector;
    C_AP_OARG_FORMAT_FACTOR : std_logic_vector;
    C_AP_OARG_FORMAT_DIM    : std_logic_vector;
    ---
    C_N_INOUT_SCALARS       : integer;
    C_N_INPUT_SCALARS       : integer;
    C_INPUT_SCALAR_MODE     : std_logic_vector(63 downto 0);
    C_OUTPUT_SCALAR_MODE    : std_logic_vector(63 downto 0);
    C_INPUT_SCALAR_DWIDTH   : std_logic_vector;
    C_AP_ISCALAR_DOUT_WIDTH : integer;
    C_N_OUTPUT_SCALARS      : integer;
    C_OUTPUT_SCALAR_DWIDTH  : std_logic_vector;
    C_AP_OSCALAR_DIN_WIDTH  : integer;
    C_AP_ISCALAR_IO_DOUT_WIDTH : integer;
    C_AP_OSCALAR_IO_DIN_WIDTH : integer;
    ---
    C_EXTRA_SYNCS           : integer := 1;
    C_NONE                  : integer := 2);
  port (
    -- SLAVE AXI LITE:
    S_AXI_ACLK           : in  std_logic;
    S_AXI_ARESETN        : in  std_logic;
    S_AXI_AWADDR         : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID        : in  std_logic;
    S_AXI_AWREADY        : out std_logic;
    S_AXI_WDATA          : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB          : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    S_AXI_WVALID         : in  std_logic;
    S_AXI_WREADY         : out std_logic;
    S_AXI_BRESP          : out std_logic_vector(1 downto 0);
    S_AXI_BVALID         : out std_logic;
    S_AXI_BREADY         : in  std_logic;
    S_AXI_ARADDR         : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID        : in  std_logic;
    S_AXI_ARREADY        : out std_logic;
    S_AXI_RDATA          : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP          : out std_logic_vector(1 downto 0);
    S_AXI_RVALID         : out std_logic;
    S_AXI_RREADY         : in  std_logic;
    --- Slave AXI streams (input arguments)
    S_AXIS_ACLK          : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_ARESETN       : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_TVALID        : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_TREADY        : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_TDATA         : in  std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TDATA_WIDTH-1 downto 0);
    S_AXIS_TSTRB         : in  std_logic_vector(C_MAX_N_IARGS*(C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
    S_AXIS_TKEEP         : in  std_logic_vector(C_MAX_N_IARGS*(C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
    S_AXIS_TLAST         : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_TID           : in  std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TID_WIDTH-1 downto 0);
    S_AXIS_TDEST         : in  std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TDEST_WIDTH-1 downto 0);
    S_AXIS_TUSER         : in  std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TUSER_WIDTH-1 downto 0);
    --- AP input arguments, memory map interface
    ap_iarg_addr         : in  std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_AWIDTH-1 downto 0);
    ap_iarg_ce           : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    ap_iarg_we           : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    ap_iarg_din          : in  std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_iarg_dout         : out std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    --- AP input arguments, fifo interface
    ap_fifo_iarg_dout    : out std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_fifo_iarg_read    : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    ap_fifo_iarg_empty_n : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    --- Master AXI streams (output arguments)
    M_AXIS_ACLK          : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_ARESETN       : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_TVALID        : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_TREADY        : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_TDATA         : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDATA_WIDTH-1 downto 0);
    M_AXIS_TSTRB         : out std_logic_vector(C_MAX_N_OARGS*(C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
    M_AXIS_TKEEP         : out std_logic_vector(C_MAX_N_OARGS*(C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
    M_AXIS_TLAST         : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_TID           : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TID_WIDTH-1 downto 0);
    M_AXIS_TDEST         : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDEST_WIDTH-1 downto 0);
    M_AXIS_TUSER         : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TUSER_WIDTH-1 downto 0);
    --- AP output arguments, memory map interface
    ap_oarg_addr         : in  std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_AWIDTH-1 downto 0);
    ap_oarg_ce           : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_oarg_we           : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_oarg_din          : in  std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_oarg_dout         : out std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    --- AP output arguments, fifo interface
    ap_fifo_oarg_din     : in  std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_fifo_oarg_write   : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_fifo_oarg_full_n  : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    -- AP system signals
    ap_clk               : in  std_logic;
    ap_rst               : out std_logic;
    -- AP control handshaking
    ap_start             : out std_logic;
    ap_ready             : in  std_logic;
    ap_done              : in  std_logic;
    ap_continue          : out std_logic;
    ap_idle              : in  std_logic;
    -- AP scalar interface
    ap_iscalar_dout      : out std_logic_vector(511 downto 0);
    ap_oscalar_din       : in  std_logic_vector(511 downto 0);
    ap_oscalar_vld       : in  std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    ap_oscalar_ack       : out std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    ap_iscalar_vld       : out std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    ap_iscalar_ack       : in  std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    interrupt            : out std_logic);
end entity;

architecture rtl of axis_accelerator_adapter_core is


  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";


  signal s_aclk        : std_logic;
  signal m_aclk        : std_logic;
  signal S_AXI_ARESET        : std_logic;
  signal axi_ap_rst          : std_logic;
  signal ap_rst_i            : std_logic;
  signal ap_rst_s_axi_aclk        : std_logic;
  signal ap_rst_saclk        : std_logic;
  signal ap_rst_maclk        : std_logic;
  signal ap_rst_i_n            : std_logic;
  signal ap_start_i          : std_logic;
  signal ap_start_one_shot   : std_logic;
  --- COMMAND INPUT PORT:
  signal host_cmd_data       : std_logic_vector(31 downto 0);
  signal host_cmd_we         : std_logic;
  signal host_cmd_rdy        : std_logic;
  signal host_complete_re    : std_logic;
  signal host_cmd_error      : std_logic;
  --- AP CORE STATUS MANAGEMENT:
  signal status_ap_start     : std_logic;
  signal status_ap_done      : std_logic;
  signal status_ap_idle      : std_logic;
  signal status_ap_ready     : std_logic;
  signal status_ap_start_clr : std_logic;
  signal status_ap_done_clr  : std_logic;
  signal status_ap_idle_clr  : std_logic;
  signal status_ap_ready_clr : std_logic;
  -- INPUT ARGUMENTS MANAGEMENT:
  signal host_iarg_rst       : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal iarg_rqt_enable     : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal iarg_rqt_enable_i     : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal status_iarg_empty   : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal status_iarg_empty_i   : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal status_iarg_empty_int   : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal status_iarg_full    : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal status_iarg_full_i    : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal status_iarg_full_int    : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal status_iarg_used    : std_logic_vector(C_MAX_N_IARGS*4-1 downto 0);
  signal status_iarg_used_i    : std_logic_vector(C_MAX_N_IARGS*4-1 downto 0);
  signal status_iarg_n_words : std_logic_vector(C_MAX_N_IARGS*(C_MAX_ARG_AWIDTH+1)-1 downto 0);
  -- TODO:
  signal status_iarg_rqt     : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal status_iarg_ack     : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  -- Input args, multibuffer management:
  signal mb_iarg_rdy         : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal mb_iarg_rdy_i         : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal mb_iarg_done        : std_logic_vector(C_MAX_N_IARGS-1 downto 0);

  -- OUTPUT ARGUMENTS MANAGEMENT:
  signal host_oarg_rst      : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal oarg_rqt_enable    : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal oarg_rqt_enable_i    : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal oarg_sw_length     : std_logic_vector(31 downto 0);
  signal oarg_sw_length_m2s : std_logic_vector(31 downto 0);
  signal oarg_sw_length_we  : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal oarg_use_sw_length : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal host_oarg_tdest    : std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDEST_WIDTH-1 downto 0);

  signal status_oarg_empty : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal status_oarg_empty_i : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal status_oarg_empty_int : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal status_oarg_full  : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal status_oarg_full_i  : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal status_oarg_full_int  : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal status_oarg_used  : std_logic_vector(C_MAX_N_OARGS*4-1 downto 0);
  signal status_oarg_used_i  : std_logic_vector(C_MAX_N_OARGS*4-1 downto 0);
  -- TODO:
  signal status_oarg_rqt   : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal status_oarg_ack   : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  -- Output args, multibuffer management:
  signal mb_oarg_rdy       : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal mb_oarg_rdy_i       : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal mb_oarg_done      : std_logic_vector(C_MAX_N_OARGS-1 downto 0);

  -- Debugging signals:
  signal dbg_iarg_stream_nwords : std_logic_vector(C_MAX_N_IARGS*16-1 downto 0);
  signal dbg_iarg_buffer_nwords : std_logic_vector(C_MAX_N_IARGS*16-1 downto 0);
  signal dbg_ap_start           : std_logic;
  signal dbg_oarg_stream_nwords : std_logic_vector(C_MAX_N_OARGS*16-1 downto 0);
  signal dbg_oarg_buffer_nwords : std_logic_vector(C_MAX_N_OARGS*16-1 downto 0);
  signal dbg_ap_done            : std_logic;

  -----------------------
  -- INPUT SCALARS MANAGEMENT:
  signal host_iscalar_rst     : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal host_iscalar_dout    : std_logic_vector(31 downto 0);
  signal host_iscalar_we      : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal host_iscalar_rdy     : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal status_iscalar_empty : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal status_iscalar_full  : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal status_iscalar_used  : std_logic_vector((C_MAX_N_ISCALARS)*4-1 downto 0);
  ---
  signal ap_iscalar_rdy       : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal ap_iscalar_done      : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  -- TODO:
  signal iscalar_rqt_enable   : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);

  -- OUTPUT SCALARS MANAGEMENT:
  signal host_oscalar_rst     : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
--  signal host_oscalar_din     : std_logic_vector((C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS)*C_MAX_SCALAR_DWIDTH-1 downto 0);
  signal host_oscalar_din     : std_logic_vector(C_MAX_N_OSCALARS*C_MAX_SCALAR_DWIDTH-1 downto 0);
  signal host_oscalar_re      : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  signal host_oscalar_rdy     : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  signal status_oscalar_empty : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  signal status_oscalar_full  : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  signal status_oscalar_used  : std_logic_vector((C_MAX_N_OSCALARS)*4-1 downto 0);
  ---
  signal ap_oscalar_vld_sync  : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0); -- Generated with ap_done
  signal ap_iscalar_done_sync : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal ap_oscalar_vld_i     : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0); 
  
  signal ap_oscalar_rdy       : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  -- TODO:
  signal oscalar_rqt_enable   : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);

begin

  -- Reset for AXI clk domain
  S_AXI_ARESET <= not(S_AXI_ARESETN);
  s_aclk <= S_AXIS_ACLK(0);
  m_aclk <= M_AXIS_ACLK(0);
  -- Reset for Accelerator clock domain (assign to output port)
  -- Changed to active low reset for accelerator
  ap_rst       <= not(ap_rst_i);
  ap_rst_i_n       <= not(ap_rst_i);

  -----------------------------------------------------------------------------------------
  -- AXI_LITE_IF_I : AXI4-Lite register interface module
  -----------------------------------------------------------------------------------------
  AXI_LITE_IF_I : entity axis_accelerator_adapter_v2_1_6.axi_lite_adapter
    generic map (
      C_FAMILY              => C_FAMILY,
      C_S_AXI_ADDR_WIDTH    => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_DATA_WIDTH    => C_S_AXI_DATA_WIDTH,
      C_MAX_N_IARGS         => C_MAX_N_IARGS,
      C_MAX_N_OARGS         => C_MAX_N_OARGS,
      C_PRMRY_IS_ACLK_ASYNC => C_PRMRY_IS_ACLK_ASYNC,
      C_MTBF_STAGES         => C_MTBF_STAGES,

      C_MAX_MB_DEPTH        => C_MAX_MB_DEPTH,
      C_N_INPUT_ARGS        => C_N_INPUT_ARGS,
      C_N_OUTPUT_ARGS       => C_N_OUTPUT_ARGS,
      C_MAX_ARG_AWIDTH      => C_MAX_ARG_AWIDTH,
      ---  
      C_MAX_N_ISCALARS      => C_MAX_N_ISCALARS-C_MAX_N_IOSCALARS,
      C_N_INPUT_SCALARS     => C_N_INPUT_SCALARS,
      C_MAX_N_OSCALARS      => C_MAX_N_OSCALARS-C_MAX_N_IOSCALARS,
      C_N_INOUT_SCALARS     => C_N_INOUT_SCALARS,
      C_MAX_N_IOSCALARS     => C_MAX_N_IOSCALARS,
      C_N_OUTPUT_SCALARS    => C_N_OUTPUT_SCALARS,
      C_MAX_SCALAR_DWIDTH   => C_MAX_SCALAR_DWIDTH,
      C_M_AXIS_TDEST_WIDTH  => C_M_AXIS_TDEST_WIDTH)
    port map (
      S_AXI_ACLK             => S_AXI_ACLK,
      S_AXI_ARESETN          => S_AXI_ARESETN,
      S_AXI_AWADDR           => S_AXI_AWADDR,
      S_AXI_AWVALID          => S_AXI_AWVALID,
      S_AXI_AWREADY          => S_AXI_AWREADY,
      S_AXI_WDATA            => S_AXI_WDATA,
      S_AXI_WSTRB            => S_AXI_WSTRB,
      S_AXI_WVALID           => S_AXI_WVALID,
      S_AXI_WREADY           => S_AXI_WREADY,
      S_AXI_BRESP            => S_AXI_BRESP,
      S_AXI_BVALID           => S_AXI_BVALID,
      S_AXI_BREADY           => S_AXI_BREADY,
      S_AXI_ARADDR           => S_AXI_ARADDR,
      S_AXI_ARVALID          => S_AXI_ARVALID,
      S_AXI_ARREADY          => S_AXI_ARREADY,
      S_AXI_RDATA            => S_AXI_RDATA,
      S_AXI_RRESP            => S_AXI_RRESP,
      S_AXI_RVALID           => S_AXI_RVALID,
      S_AXI_RREADY           => S_AXI_RREADY,
      --- App. ports
      ap_rst                 => axi_ap_rst,
      --- Command input port:
      host_cmd_data          => host_cmd_data,
      host_cmd_we            => host_cmd_we,
      host_cmd_rdy           => host_cmd_rdy,
      host_complete_re       => host_complete_re,
      host_cmd_error         => host_cmd_error,
      --- AP core status signals:
      status_ap_start        => status_ap_start,
      status_ap_done         => status_ap_done,
      status_ap_idle         => status_ap_idle,
      status_ap_ready        => status_ap_ready,
      status_ap_start_clr    => status_ap_start_clr,
      status_ap_done_clr     => status_ap_done_clr,
      status_ap_idle_clr     => status_ap_idle_clr,
      status_ap_ready_clr    => status_ap_ready_clr,
      -- Input arguments management:
      host_iarg_rst          => host_iarg_rst,
      iarg_rqt_enable        => iarg_rqt_enable_i,
      status_iarg_empty      => status_iarg_empty,
      status_iarg_full       => status_iarg_full,
      status_iarg_used       => status_iarg_used,
      status_iarg_n_words    => status_iarg_n_words,
      -- Output arguments management:
      host_oarg_rst          => host_oarg_rst,
      oarg_rqt_enable        => oarg_rqt_enable_i,
      oarg_sw_length         => oarg_sw_length,
      oarg_sw_length_m2s     => oarg_sw_length_m2s,
      oarg_sw_length_we      => oarg_sw_length_we,
      oarg_use_sw_length     => oarg_use_sw_length,
      host_oarg_tdest        => host_oarg_tdest,
      status_oarg_empty      => status_oarg_empty,
      status_oarg_full       => status_oarg_full,
      status_oarg_used       => status_oarg_used,
      --- Input scalars management:
      host_iscalar_rst       => host_iscalar_rst,
      host_iscalar_dout      => host_iscalar_dout,
      host_iscalar_we        => host_iscalar_we,
      host_iscalar_rdy       => host_iscalar_rdy,
      status_iscalar_empty   => status_iscalar_empty,
      status_iscalar_full    => status_iscalar_full,
      status_iscalar_used    => status_iscalar_used,
      -- Output scalars management:
      host_oscalar_rst       => host_oscalar_rst,
      host_oscalar_din       => host_oscalar_din,
      host_oscalar_re        => host_oscalar_re,
      host_oscalar_rdy       => host_oscalar_rdy,
      status_oscalar_empty   => status_oscalar_empty,
      status_oscalar_full    => status_oscalar_full,
      status_oscalar_used    => status_oscalar_used,
      ---
      dbg_iarg_stream_nwords => dbg_iarg_stream_nwords,
      dbg_iarg_buffer_nwords => dbg_iarg_buffer_nwords,
      dbg_oarg_stream_nwords => dbg_oarg_stream_nwords,
      dbg_oarg_buffer_nwords => dbg_oarg_buffer_nwords,
      ---
      iscalar_rqt_enable     => iscalar_rqt_enable,
      oscalar_rqt_enable     => oscalar_rqt_enable,
      ---
      interrupt              => interrupt);

     
  -----------------------------------------------------------------------------------------
  -- XD_RESET_SYNC : Reset Synchronizer
  -----------------------------------------------------------------------------------------
    XD_RESET_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 0,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => S_AXI_ACLK,
        prmry_resetn               => '0',
        prmry_in                   => axi_ap_rst,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => ap_clk,
        scndry_resetn              => '0',
        scndry_out                 => ap_rst_i,
        scndry_vect_out            => open
        );

      XD_RESET_SYNC_s_axi_aclk : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 0,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => S_AXI_ACLK,
        prmry_resetn               => '0',
        prmry_in                   => axi_ap_rst,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => '0',
        scndry_out                 => ap_rst_s_axi_aclk,
        scndry_vect_out            => open
        );


      XD_RESET_SYNC_saclk : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 0,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => S_AXI_ACLK,
        prmry_resetn               => '0',
        prmry_in                   => axi_ap_rst,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => s_aclk,
        scndry_resetn              => '0',
        scndry_out                 => ap_rst_saclk,
        scndry_vect_out            => open
        );

      XD_RESET_SYNC_maclk : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 0,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => S_AXI_ACLK,
        prmry_resetn               => '0',
        prmry_in                   => axi_ap_rst,
        prmry_vect_in              => (others => '0'),

        scndry_aclk                => m_aclk,
        scndry_resetn              => '0',
        scndry_out                 => ap_rst_maclk,
        scndry_vect_out            => open
        );




  -----------------------------------------------------------------------------------------
  -- XD_INPUT_ARGS_I : Input argument generation module
  -----------------------------------------------------------------------------------------
  XD_INPUT_ARGS_I : entity axis_accelerator_adapter_v2_1_6.xd_input_args_module
    generic map (
      -- System generics:
      C_FAMILY                => C_FAMILY,
      C_BRAM_TYPE             => C_BRAM_TYPE,
      C_MAX_ARG_DWIDTH        => C_MAX_ARG_DWIDTH,
      C_MAX_ARG_AWIDTH        => C_MAX_ARG_AWIDTH,
      C_MAX_ARG_N_DIM         => C_MAX_ARG_N_DIM,
      C_MAX_MB_DEPTH          => C_MAX_MB_DEPTH,
      C_MAX_N_IARGS           => C_MAX_N_IARGS,
      C_N_INPUT_ARGS          => C_N_INPUT_ARGS,
      ---
      C_S_AXIS_TDATA_WIDTH    => C_S_AXIS_TDATA_WIDTH,
      C_S_AXIS_TUSER_WIDTH    => C_S_AXIS_TUSER_WIDTH,
      C_S_AXIS_TID_WIDTH      => C_S_AXIS_TID_WIDTH,
      C_S_AXIS_TDEST_WIDTH    => C_S_AXIS_TDEST_WIDTH,
      ---
      C_AP_IARG_TYPE          => C_AP_IARG_TYPE,
      C_AP_IARG_DWIDTH        => C_AP_IARG_DWIDTH,
      C_AP_IARG_MB_DEPTH      => C_AP_IARG_MB_DEPTH,
      C_AP_IARG_WIDTH         => C_AP_IARG_WIDTH,
      C_AP_IARG_N_DIM         => C_AP_IARG_N_DIM,
      C_AP_IARG_DIM_1         => C_AP_IARG_DIM_1,
      C_AP_IARG_DIM_2         => C_AP_IARG_DIM_2,
      C_AP_IARG_FORMAT_TYPE   => C_AP_IARG_FORMAT_TYPE,
      C_AP_IARG_FORMAT_FACTOR => C_AP_IARG_FORMAT_FACTOR,
      C_AP_IARG_FORMAT_DIM    => C_AP_IARG_FORMAT_DIM,
      C_MTBF_STAGES           => C_MTBF_STAGES,
      C_EXTRA_SYNCS           => C_EXTRA_SYNCS)
    port map (
      --- Slave AXI streams (input arguments)
      S_AXIS_ACLK          => S_AXIS_ACLK,
      S_AXIS_ARESETN       => S_AXIS_ARESETN,
      S_AXIS_TVALID        => S_AXIS_TVALID,
      S_AXIS_TREADY        => S_AXIS_TREADY,
      S_AXIS_TDATA         => S_AXIS_TDATA,
      S_AXIS_TSTRB         => S_AXIS_TSTRB,
      S_AXIS_TKEEP         => S_AXIS_TKEEP,
      S_AXIS_TLAST         => S_AXIS_TLAST,
      S_AXIS_TID           => S_AXIS_TID,
      S_AXIS_TDEST         => S_AXIS_TDEST,
      S_AXIS_TUSER         => S_AXIS_TUSER,
      dbg_stream_nwords    => dbg_iarg_stream_nwords,
      dbg_buffer_nwords    => dbg_iarg_buffer_nwords,
      dbg_ap_start         => dbg_ap_start,
      --- AP input arguments
      ap_clk               => ap_clk,
      ap_rst               => ap_rst_i,
      ap_rst_saclk         => ap_rst_saclk,
      ap_iarg_rst          => host_iarg_rst,
      ap_iarg_addr         => ap_iarg_addr,
      ap_iarg_ce           => ap_iarg_ce,
      ap_iarg_we           => ap_iarg_we,
      ap_iarg_din          => ap_iarg_din,
      ap_iarg_dout         => ap_iarg_dout,
      mb_iarg_rdy          => mb_iarg_rdy_i,
      mb_iarg_done         => mb_iarg_done,
      status_iarg_empty    => status_iarg_empty_i,
      status_iarg_full     => status_iarg_full_i,
      status_iarg_used     => status_iarg_used_i,
      status_iarg_n_words  => status_iarg_n_words,
      ---
      ap_fifo_iarg_dout    => ap_fifo_iarg_dout,
      ap_fifo_iarg_read    => ap_fifo_iarg_read,
      ap_fifo_iarg_empty_n => ap_fifo_iarg_empty_n);

 


  -----------------------------------------------------------------------------------------
  -- XD_OUTPUT_ARGS_I : Output argument generation module
  -----------------------------------------------------------------------------------------
  XD_OUTPUT_ARGS_I : entity axis_accelerator_adapter_v2_1_6.xd_output_args_module
    generic map (
      -- System generics:
      C_FAMILY                => C_FAMILY,
      C_BRAM_TYPE             => C_BRAM_TYPE,
      C_MAX_ARG_DWIDTH        => C_MAX_ARG_DWIDTH,
      C_MAX_ARG_AWIDTH        => C_MAX_ARG_AWIDTH,
      C_MAX_ARG_N_DIM         => C_MAX_ARG_N_DIM,
      C_MAX_MB_DEPTH          => C_MAX_MB_DEPTH,
      C_MAX_N_OARGS           => C_MAX_N_OARGS,
      C_N_OUTPUT_ARGS         => C_N_OUTPUT_ARGS,
      C_PRMRY_IS_ACLK_ASYNC   => C_PRMRY_IS_ACLK_ASYNC,
      C_MTBF_STAGES           => C_MTBF_STAGES,
      ---
      C_M_AXIS_TDATA_WIDTH    => C_M_AXIS_TDATA_WIDTH,
      C_M_AXIS_TUSER_WIDTH    => C_M_AXIS_TUSER_WIDTH,
      C_M_AXIS_TID_WIDTH      => C_M_AXIS_TID_WIDTH,
      C_M_AXIS_TDEST_WIDTH    => C_M_AXIS_TDEST_WIDTH,
      ---
      C_AP_OARG_TYPE          => C_AP_OARG_TYPE,
      C_AP_OARG_DWIDTH        => C_AP_OARG_DWIDTH,
      C_AP_OARG_MB_DEPTH      => C_AP_OARG_MB_DEPTH,
      ---
      C_AP_OARG_WIDTH         => C_AP_OARG_WIDTH,
      C_AP_OARG_N_DIM         => C_AP_OARG_N_DIM,
      C_AP_OARG_DIM           => C_AP_OARG_DIM,
      C_AP_OARG_DIM_1         => C_AP_OARG_DIM_1,
      C_AP_OARG_DIM_2         => C_AP_OARG_DIM_2,
      C_AP_OARG_FORMAT_TYPE   => C_AP_OARG_FORMAT_TYPE,
      C_AP_OARG_FORMAT_FACTOR => C_AP_OARG_FORMAT_FACTOR,
      C_AP_OARG_FORMAT_DIM    => C_AP_OARG_FORMAT_DIM)
    port map (
      --- Master AXI streams (output arguments)
      M_AXIS_ACLK         => M_AXIS_ACLK,
      M_AXIS_ARESETN      => M_AXIS_ARESETN,
      M_AXIS_TVALID       => M_AXIS_TVALID,
      M_AXIS_TREADY       => M_AXIS_TREADY,
      M_AXIS_TDATA        => M_AXIS_TDATA,
      M_AXIS_TSTRB        => M_AXIS_TSTRB,
      M_AXIS_TKEEP        => M_AXIS_TKEEP,
      M_AXIS_TLAST        => M_AXIS_TLAST,
      M_AXIS_TID          => M_AXIS_TID,
      M_AXIS_TDEST        => M_AXIS_TDEST,
      M_AXIS_TUSER        => M_AXIS_TUSER,
      ---
      oarg_sw_length      => oarg_sw_length,
      oarg_sw_length_m2s     => oarg_sw_length_m2s,
      oarg_sw_length_we   => oarg_sw_length_we,
      oarg_use_sw_length  => oarg_use_sw_length,
      host_oarg_tdest     => host_oarg_tdest,
      ---
      dbg_stream_nwords   => dbg_oarg_stream_nwords,
      dbg_buffer_nwords   => dbg_oarg_buffer_nwords,
      dbg_ap_done         => dbg_ap_done,
      --- AP output arguments
      ap_clk              => ap_clk,
      ap_rst              => ap_rst_i,
      ap_rst_maclk        => ap_rst_maclk,
      ap_oarg_rst         => host_oarg_rst,
      ap_oarg_addr        => ap_oarg_addr,
      ap_oarg_ce          => ap_oarg_ce,
      ap_oarg_we          => ap_oarg_we,
      ap_oarg_din         => ap_oarg_din,
      ap_oarg_dout        => ap_oarg_dout,
      ap_oarg_rdy         => mb_oarg_rdy_i,
      ap_oarg_done        => mb_oarg_done,
      status_oarg_empty   => status_oarg_empty_i,
      status_oarg_full    => status_oarg_full_i,
      status_oarg_used    => status_oarg_used_i,
      ---
      ap_fifo_oarg_din    => ap_fifo_oarg_din,
      ap_fifo_oarg_write  => ap_fifo_oarg_write,
      ap_fifo_oarg_full_n => ap_fifo_oarg_full_n,
      ap_start            => ap_start_one_shot,
      ap_done             => ap_done);


   EN_APCLK_LITE_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
   begin


      AP_OARGFULL_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_OARGS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => M_AXIS_ACLK(0),
        prmry_resetn               => M_AXIS_ARESETN(0),
	prmry_in                   => '0',
        prmry_vect_in              => status_oarg_full_i,

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => open,
        scndry_vect_out            => status_oarg_full_int
        );

        AP_OARGEMPTY_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_OARGS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => M_AXIS_ACLK(0),
        prmry_resetn               => M_AXIS_ARESETN(0),
	prmry_in                   => '0',
        prmry_vect_in              => status_oarg_empty_i,

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => open,
        scndry_vect_out            => status_oarg_empty_int
        );
--      status_oarg_empty <= status_oarg_empty_i;
	

      AP_OARGUSED_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_OARGS*4,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => M_AXIS_ACLK(0),
        prmry_resetn               => M_AXIS_ARESETN(0),
	prmry_in                   => '0',
        prmry_vect_in              => status_oarg_used_i,

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => open,
        scndry_vect_out            => status_oarg_used
        );


  AP_ORGRDY_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_OARGS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => ap_rst_i_n,
	prmry_in                   => '0',
        prmry_vect_in              => mb_oarg_rdy_i,

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => open,
        scndry_vect_out            => mb_oarg_rdy
        );


      AP_IARGFULL_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => S_AXIS_ACLK(0),
        prmry_resetn               => S_AXIS_ARESETN(0),
	prmry_in                   => '0',
        prmry_vect_in              => status_iarg_full_i,

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => open,
        scndry_vect_out            => status_iarg_full_int
        );

        AP_IARGEMPTY_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => S_AXIS_ACLK(0),
        prmry_resetn               => S_AXIS_ARESETN(0),
	prmry_in                   => '0',
        prmry_vect_in              => status_iarg_empty_i,

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => open,
        scndry_vect_out            => status_iarg_empty_int
        );
	

      AP_IARGUSED_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS*4,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => S_AXIS_ACLK(0),
        prmry_resetn               => S_AXIS_ARESETN(0),
	prmry_in                   => '0',
        prmry_vect_in              => status_iarg_used_i,

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => open,
        scndry_vect_out            => status_iarg_used
        );


    AP_IRGRQT_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => S_AXI_ACLK,
        prmry_resetn               => S_AXI_ARESETN,
	prmry_in                   => '0',
        prmry_vect_in              => iarg_rqt_enable_i,

        scndry_aclk                => ap_clk,
        scndry_resetn              => ap_rst_i_n,
        scndry_out                 => open,
        scndry_vect_out            => iarg_rqt_enable
        );

      mb_iarg_rdy <= mb_iarg_rdy_i;
      oarg_rqt_enable <= oarg_rqt_enable_i;

  OARGS_GEN_INT : if (C_N_OUTPUT_ARGS > 0) generate
  begin

    OUTPUT_ARGS_GEN_INT : for i in 0 to C_N_OUTPUT_ARGS-1 generate

      constant OARG_TYPE          : integer          := get_int_element(C_AP_OARG_TYPE, i);

    begin

     M2S_gen_INT: if (OARG_TYPE = AP_ARG_MEM_MAP_TYPE) generate 
     begin
      status_oarg_full(i) <= status_oarg_full_int(i);
      status_oarg_empty(i) <= status_oarg_empty_int(i);
      end generate M2S_gen_INT;


     S2S_gen_INT: if (OARG_TYPE = AP_ARG_STREAM_TYPE) generate 
     begin
      status_oarg_full(i) <= '0';
      status_oarg_empty(i) <= '0';
      end generate S2S_gen_INT;

    end generate OUTPUT_ARGS_GEN_INT;

   end generate OARGS_GEN_INT;

 IARGS_GEN_INT : if (C_N_INPUT_ARGS > 0) generate
  begin

    INPUT_ARGS_GEN_INT : for i in 0 to C_N_INPUT_ARGS-1 generate

      constant IARG_TYPE          : integer          := get_int_element(C_AP_IARG_TYPE, i);

    begin

     M2S_gen_INT: if (IARG_TYPE = AP_ARG_MEM_MAP_TYPE) generate 
     begin
      status_iarg_full(i) <= status_iarg_full_int(i);
      status_iarg_empty(i) <= status_iarg_empty_int(i);
      end generate M2S_gen_INT;


     S2S_gen_INT: if (IARG_TYPE = AP_ARG_STREAM_TYPE) generate 
     begin
      status_iarg_full(i) <= '0';
      status_iarg_empty(i) <= '0';
      end generate S2S_gen_INT;

    end generate INPUT_ARGS_GEN_INT;

   end generate IARGS_GEN_INT;


 end generate EN_APCLK_LITE_SYNC_GEN;

   NO_APCLK_LITE_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
   begin
      status_oarg_full <= status_oarg_full_i;
      status_oarg_empty <= status_oarg_empty_i;
      status_oarg_used <= status_oarg_used_i;
      status_iarg_full <= status_iarg_full_i;
      status_iarg_empty <= status_iarg_empty_i;
      status_iarg_used <= status_iarg_used_i;
      mb_iarg_rdy <= mb_iarg_rdy_i;
      iarg_rqt_enable <= iarg_rqt_enable_i;
      oarg_rqt_enable <= oarg_rqt_enable_i;
      mb_oarg_rdy <= mb_oarg_rdy_i;

   end generate NO_APCLK_LITE_SYNC_GEN;


 
  -----------------------------------------------------------------------------------------
  -- XD_SYNC_I : Accelerator Synchronizer module
  -----------------------------------------------------------------------------------------
  XD_SYNC_I : entity axis_accelerator_adapter_v2_1_6.xd_sync_module
    generic map (
      C_FAMILY              => C_FAMILY,
      C_MAX_N_IARGS         => C_MAX_N_IARGS,
      C_MAX_N_OARGS         => C_MAX_N_OARGS,
      C_N_INPUT_ARGS        => C_N_INPUT_ARGS,
      C_N_OUTPUT_ARGS       => C_N_OUTPUT_ARGS,
      C_PRMRY_IS_ACLK_ASYNC => C_PRMRY_IS_ACLK_ASYNC,
      C_MTBF_STAGES         => C_MTBF_STAGES, 
      ---
      C_MAX_N_ISCALARS     => C_MAX_N_ISCALARS,
      C_N_INPUT_SCALARS    => C_N_INPUT_SCALARS,
      C_MAX_N_OSCALARS     => C_MAX_N_OSCALARS,
      C_N_INOUT_SCALARS    => C_N_INOUT_SCALARS,
      C_MAX_N_IOSCALARS    => C_MAX_N_IOSCALARS,
      C_N_OUTPUT_SCALARS   => C_N_OUTPUT_SCALARS)
    port map (
      ---
      S_AXI_ACLK          => S_AXI_ACLK,
      S_AXI_ARESETN       => S_AXI_ARESETN,

      host_cmd_data       => host_cmd_data,
      host_cmd_we         => host_cmd_we,
      host_cmd_rdy        => host_cmd_rdy,
      host_complete_re    => host_complete_re,
      host_cmd_error      => host_cmd_error,
      ---
      iarg_rqt_enable     => iarg_rqt_enable,
      oarg_rqt_enable     => oarg_rqt_enable,
      ---
      status_ap_start     => status_ap_start,
      status_ap_done      => status_ap_done,
      status_ap_idle      => status_ap_idle,
      status_ap_ready     => status_ap_ready,
      status_ap_start_clr => status_ap_start_clr,
      status_ap_done_clr  => status_ap_done_clr,
      status_ap_idle_clr  => status_ap_idle_clr,
      status_ap_ready_clr => status_ap_ready_clr,
      ---
      status_iarg_rqt     => status_iarg_rqt,
      status_iarg_ack     => status_iarg_ack,
      status_oarg_rqt     => status_oarg_rqt,
      status_oarg_ack     => status_oarg_ack,
      ---
      ap_clk              => ap_clk,
      soft_rst            => ap_rst_s_axi_aclk,
      ap_rst              => ap_rst_i,
      ---
      mb_iarg_rdy         => mb_iarg_rdy,
      mb_iarg_done        => mb_iarg_done,
      mb_oarg_rdy         => mb_oarg_rdy,
      mb_oarg_done        => mb_oarg_done,
      -- AP control handshaking:
      ap_start            => ap_start,
      ap_ready            => ap_ready,
      ap_done             => ap_done,
      ap_continue         => ap_continue,
      ap_idle             => ap_idle,
      ap_start_one_shot   => ap_start_one_shot,
      ---
      iscalar_rqt_enable     => iscalar_rqt_enable,
      oscalar_rqt_enable     => oscalar_rqt_enable,
      ---
      ap_iscalar_rdy      => ap_iscalar_rdy,
      ap_iscalar_done     => ap_iscalar_done_sync,
      ap_oscalar_vld      => ap_oscalar_vld_sync,
      ap_oscalar_rdy      => ap_oscalar_rdy);

  -----------------------------------------------------------------------------------------
  -- XD_INPUT_SCALARS_I : Input scalar generation module
  -----------------------------------------------------------------------------------------
  IN_ACTIVE_GEN1 : if (C_N_INOUT_SCALARS > 0) generate
  XD_INPUT_SCALARS_I : entity axis_accelerator_adapter_v2_1_6.xd_input_scalars_module
    generic map (
      C_FAMILY                => C_FAMILY,
      C_MTBF_STAGES           => C_MTBF_STAGES, 
      C_PRMRY_IS_ACLK_ASYNC   => C_PRMRY_IS_ACLK_ASYNC,
      C_MAX_N_ISCALARS        => C_MAX_N_ISCALARS,
      C_N_INPUT_SCALARS       => C_N_INPUT_SCALARS,
      C_N_INOUT_SCALARS       => C_N_INOUT_SCALARS+C_MAX_N_ISCALARS-C_MAX_N_IOSCALARS,
      C_INPUT_SCALAR_DWIDTH   => C_INPUT_SCALAR_DWIDTH,
      C_AP_ISCALAR_DOUT_WIDTH => 32*(C_MAX_N_ISCALARS-C_MAX_N_IOSCALARS)+ C_AP_ISCALAR_IO_DOUT_WIDTH)
    port map (
      clk                  => S_AXI_ACLK,
      rst                  => S_AXI_ARESET,
      iscalar_rst          => host_iscalar_rst,
      iscalar_din          => host_iscalar_dout,
      iscalar_we           => host_iscalar_we,
      status_iscalar_empty => status_iscalar_empty,
      status_iscalar_full  => status_iscalar_full,
      status_iscalar_used  => status_iscalar_used,
      --- AP input scalars
      ap_clk               => ap_clk,
      ap_rst               => ap_rst_i,
      ap_rst_s_axi_aclk    => ap_rst_s_axi_aclk,
      ap_iscalar_rdy       => ap_iscalar_rdy,
      ap_iscalar_done      => ap_iscalar_done,
      ap_iscalar_dout      => ap_iscalar_dout(32*(C_MAX_N_ISCALARS-C_MAX_N_IOSCALARS) + C_AP_ISCALAR_IO_DOUT_WIDTH-1 downto 0));
    end generate IN_ACTIVE_GEN1;

  IN_ACTIVE_GEN2 : if (C_N_INOUT_SCALARS = 0) generate
  XD_INPUT_SCALARS_I : entity axis_accelerator_adapter_v2_1_6.xd_input_scalars_module
    generic map (
      C_FAMILY                => C_FAMILY,
      C_MTBF_STAGES           => C_MTBF_STAGES,
      C_PRMRY_IS_ACLK_ASYNC   => C_PRMRY_IS_ACLK_ASYNC,
      C_MAX_N_ISCALARS        => C_MAX_N_ISCALARS,--+C_MAX_N_IOSCALARS,
      --C_N_INPUT_SCALARS       => C_N_INPUT_SCALARS+C_N_INOUT_SCALARS,
      C_N_INPUT_SCALARS       => C_N_INPUT_SCALARS,
      C_N_INOUT_SCALARS       => C_N_INOUT_SCALARS+C_MAX_N_ISCALARS-C_MAX_N_IOSCALARS,
      C_INPUT_SCALAR_DWIDTH   => C_INPUT_SCALAR_DWIDTH,
      C_AP_ISCALAR_DOUT_WIDTH => C_AP_ISCALAR_DOUT_WIDTH)
    port map (
      clk                  => S_AXI_ACLK,
      rst                  => S_AXI_ARESET,
      iscalar_rst          => host_iscalar_rst,
      iscalar_din          => host_iscalar_dout,
      iscalar_we           => host_iscalar_we,
      status_iscalar_empty => status_iscalar_empty,
      status_iscalar_full  => status_iscalar_full,
      status_iscalar_used  => status_iscalar_used,
      --- AP input scalars
      ap_clk               => ap_clk,
      ap_rst_s_axi_aclk    => ap_rst_s_axi_aclk,
      ap_rst               => ap_rst_i,
      ap_iscalar_rdy       => ap_iscalar_rdy,
      ap_iscalar_done      => ap_iscalar_done,
      ap_iscalar_dout      => ap_iscalar_dout(C_AP_ISCALAR_DOUT_WIDTH-1 downto 0));
    end generate IN_ACTIVE_GEN2;

  -----------------------------------------------------------------------------------------
  -- XD_OUTPUT_SCALARS_I : Output scalar generation module
  -----------------------------------------------------------------------------------------
  ACTIVE_GEN1 : if (C_N_INOUT_SCALARS > 0) generate
  XD_OUTPUT_SCALARS_I : entity axis_accelerator_adapter_v2_1_6.xd_output_scalars_module
    generic map (
      C_FAMILY                => C_FAMILY,
      C_MTBF_STAGES           => C_MTBF_STAGES, 
      C_PRMRY_IS_ACLK_ASYNC   => C_PRMRY_IS_ACLK_ASYNC,
      C_MAX_SCALAR_DWIDTH     => C_MAX_SCALAR_DWIDTH,
      C_MAX_N_OSCALARS        => C_MAX_N_OSCALARS,
      C_N_OUTPUT_SCALARS      => C_N_OUTPUT_SCALARS,
      C_N_INOUT_SCALARS       => C_N_INOUT_SCALARS+C_MAX_N_OSCALARS-C_MAX_N_IOSCALARS,
      C_OUTPUT_SCALAR_DWIDTH  => C_OUTPUT_SCALAR_DWIDTH,
      C_AP_OSCALAR_DIN_WIDTH  => 32*(C_MAX_N_OSCALARS-C_MAX_N_IOSCALARS) + C_AP_OSCALAR_IO_DIN_WIDTH)
    port map (
      --- AP output scalars
      ap_clk               => ap_clk,
      ap_rst               => ap_rst_i,
      ap_rst_s_axi_aclk    => ap_rst_s_axi_aclk,
      ap_oscalar_vld       => ap_oscalar_vld_i,
      ap_oscalar_rdy       => ap_oscalar_rdy,
      ap_oscalar_din       => ap_oscalar_din(32*(C_MAX_N_OSCALARS-C_MAX_N_IOSCALARS) + C_AP_OSCALAR_IO_DIN_WIDTH-1 downto 0),
      ---
      clk                  => S_AXI_ACLK,
      rst                  => S_AXI_ARESET,
      oscalar_rst          => host_oscalar_rst,
      oscalar_data         => host_oscalar_din,
      oscalar_re           => host_oscalar_re,
      status_oscalar_empty => status_oscalar_empty,
      status_oscalar_full  => status_oscalar_full,
      status_oscalar_used  => status_oscalar_used);

    end generate ACTIVE_GEN1;

  ACTIVE_GEN2 : if (C_N_INOUT_SCALARS = 0) generate
  XD_OUTPUT_SCALARS_I : entity axis_accelerator_adapter_v2_1_6.xd_output_scalars_module
    generic map (
      C_FAMILY                => C_FAMILY,
      C_MTBF_STAGES           => C_MTBF_STAGES, 
      C_PRMRY_IS_ACLK_ASYNC   => C_PRMRY_IS_ACLK_ASYNC,
      C_MAX_SCALAR_DWIDTH     => C_MAX_SCALAR_DWIDTH,
      C_MAX_N_OSCALARS        => C_MAX_N_OSCALARS,
      C_N_OUTPUT_SCALARS      => C_N_OUTPUT_SCALARS,
      C_N_INOUT_SCALARS       => C_N_INOUT_SCALARS+C_MAX_N_OSCALARS-C_MAX_N_IOSCALARS,
      C_OUTPUT_SCALAR_DWIDTH  => C_OUTPUT_SCALAR_DWIDTH,
      C_AP_OSCALAR_DIN_WIDTH  => C_AP_OSCALAR_DIN_WIDTH)
    port map (
      --- AP output scalars
      ap_clk               => ap_clk,
      ap_rst               => ap_rst_i,
      ap_rst_s_axi_aclk    => ap_rst_s_axi_aclk,
      ap_oscalar_vld       => ap_oscalar_vld_i,
      ap_oscalar_rdy       => ap_oscalar_rdy,
      ap_oscalar_din       => ap_oscalar_din(C_AP_OSCALAR_DIN_WIDTH-1 downto 0),
      ---
      clk                  => S_AXI_ACLK,
      rst                  => S_AXI_ARESET,
      oscalar_rst          => host_oscalar_rst,
      oscalar_data         => host_oscalar_din,
      oscalar_re           => host_oscalar_re,
      status_oscalar_empty => status_oscalar_empty,
      status_oscalar_full  => status_oscalar_full,
      status_oscalar_used  => status_oscalar_used);
    end generate ACTIVE_GEN2;
      
   
   -----------------------------------------------------------------------------------------
   -- OUTPUT_SCALARS_MODE_GEN : Output Scalar IO mode logic
   -----------------------------------------------------------------------------------------
   OUTPUT_SCALARS_MODE_GEN : for i in 0 to C_MAX_N_OSCALARS-1 generate
   
     -- AP_HS mode
     OSCALAR_HS_MODE : if (C_OUTPUT_SCALAR_MODE(4*(i+1)-1 downto 4*i) = "0010") generate 
     
        ap_oscalar_ack(i)   <= ap_oscalar_rdy(i);
        ap_oscalar_vld_i(i) <= ap_oscalar_vld(i);

     
     end generate OSCALAR_HS_MODE;
    
     -- AP_VLD mode
     OSCALAR_VLD_MODE : if (C_OUTPUT_SCALAR_MODE(4*(i+1)-1 downto 4*i) = "0001") generate 
        ap_oscalar_ack(i)   <= '0';
        ap_oscalar_vld_i(i) <= ap_oscalar_vld(i);
     end generate OSCALAR_VLD_MODE;


     -- AP_NONE mode
     OSCALAR_NONE_MODE : if (C_OUTPUT_SCALAR_MODE(4*(i+1)-1 downto 4*i) = "0000") generate 
        ap_oscalar_ack(i)   <= '0';
        ap_oscalar_vld_i(i) <= ap_oscalar_vld_sync(i);
     end generate OSCALAR_NONE_MODE;

      
  end generate OUTPUT_SCALARS_MODE_GEN;
      
      
   -----------------------------------------------------------------------------------------
   -- INPUT_SCALARS_MODE_GEN : Input Scalar IO mode logic
   -----------------------------------------------------------------------------------------
   INPUT_SCALARS_MODE_GEN : for i in 0 to C_MAX_N_ISCALARS-1 generate
   
     -- AP_HS mode
     ISCALAR_HS_MODE : if (C_INPUT_SCALAR_MODE(4*(i+1)-1 downto 4*i) = "0010") generate 
     
        ap_iscalar_vld(i)  <= ap_iscalar_rdy(i);
        ap_iscalar_done(i) <= ap_iscalar_ack(i);
        
     
     end generate ISCALAR_HS_MODE;
    
     -- AP_VLD mode
     ISCALAR_VLD_MODE : if (C_INPUT_SCALAR_MODE(4*(i+1)-1 downto 4*i) = "0001") generate 
        ap_iscalar_vld(i)  <= ap_iscalar_rdy(i);
        ap_iscalar_done(i) <= ap_iscalar_done_sync(i);
     end generate ISCALAR_VLD_MODE;


     -- AP_NONE mode
     ISCALAR_NONE_MODE : if (C_INPUT_SCALAR_MODE(4*(i+1)-1 downto 4*i) = "0000") generate 
        ap_iscalar_vld(i)  <= '0';
        ap_iscalar_done(i) <= ap_iscalar_done_sync(i);
     end generate ISCALAR_NONE_MODE;

      
  end generate INPUT_SCALARS_MODE_GEN;
      
  -- Unused nets 
   host_iscalar_rdy <= (others => '0');
   host_oscalar_rdy <= (others => '0');  
   dbg_ap_start     <= '0';
   dbg_ap_done      <= '0';   
   
end rtl;

