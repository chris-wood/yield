-------------------------------------------------------------------------------
-- axis_accelerator_adpater.vhd - Entity and architecture
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
-- Title      : AXI4-Stream Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : axis_accelerator_adapter.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2013-10-25
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: This is the Accelerator Adapter top-level module. It is 
-- implemented as a wrapper that uses buses for all input/output arguments.
-- This top-level module supports up-to eight input/output arguments.
-- Then, it instantiates the "xd_adapter_core", which is a completely
-- parametrizable module.
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
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "aclk","clk_div#", "clk_#x"
--      reset signals:                          "rst", "aresetn","rst_n"
--      generics:                               "C_*"
--      user defined types:                     "*_TYPE"
--      state machine next state:               "*_ns"
--      state machine current state:            "*_cs"
--      combinatorial signals:                  "*_cmb"
--      pipelined or register delay signals:    "*_d#"
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce"
--      internal version of output port         "*_i"
--      device pins:                            "*_pin"
--      ports:                                  - Names begin with Uppercase
--      processes:                              "*_PROCESS"
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------
-- History:
-- ~~~~~~
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-05  1.0      rmg/jn  Created
-- 2013-01-31  1.0      pankajk removed perf mon ports, all ports in lower case
-- 2013-05-10  1.1      pankajk Seperated scalar port and brought those to top 
--                      entity 
-- 2013-07-22  2.0      pankajk New scalar ports (*.vld, *.ack) and parameter 
--                              scalar_mode added to support accelerator IP 
--                              interface ap_none, ap_hs, ap_vld
-- 2013-10-25  2.0      pvk     Added support for UltraScale primitives. 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;
use axis_accelerator_adapter_v2_1_6.axis_accelerator_adapter_core;


entity axis_accelerator_adapter is
  generic (
    -- System generics:
    C_FAMILY                : string                  := "virtex7";  -- Xilinx FPGA family
    --
    C_S_AXI_ADDR_WIDTH      : integer                 := 13;
    C_S_AXI_DATA_WIDTH      : integer range 32 to 32  := 32;
    --
    C_AP_ADAPTER_ID         : integer range 0 to 15 :=1;
    C_N_INPUT_ARGS          : integer := 2;
    C_N_OUTPUT_ARGS         : integer := 1;
    C_ENABLE_STREAM_CLK     : integer := 0;
    C_PRMRY_IS_ACLK_ASYNC   : integer := 1;
    C_S_AXIS_HAS_TSTRB      : integer := 0;
    C_S_AXIS_HAS_TKEEP      : integer := 0;

    --
    C_S_AXIS_TDATA_WIDTH    : integer := 64;
    C_S_AXIS_TUSER_WIDTH    : integer := 8;
    C_S_AXIS_TID_WIDTH      : integer := 4;
    C_S_AXIS_TDEST_WIDTH    : integer := 8;
    --
    C_AP_IARG_TYPE          : std_logic_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    C_AP_IARG_MB_DEPTH      : std_logic_vector := X"0000000400000004000000040000000400000004000000040000000400000004";
    C_AP_IARG_WIDTH         : std_logic_vector := X"0000002000000020000000200000002000000020000000200000002000000020";
    C_AP_IARG_N_DIM         : std_logic_vector := X"0000000100000001000000010000000100000001000000010000000100000001";
    C_AP_IARG_DIM_1         : std_logic_vector := X"0000040000000400000004000000040000000400000004000000040000000400";
    C_AP_IARG_DIM_2         : std_logic_vector := X"0000000100000001000000010000000100000001000000010000000100000001";
    C_AP_IARG_FORMAT_TYPE   : std_logic_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    C_AP_IARG_FORMAT_FACTOR : std_logic_vector := X"0000000100000001000000010000000100000001000000010000000100000001";
    C_AP_IARG_FORMAT_DIM    : std_logic_vector := X"0000000100000001000000010000000100000001000000010000000100000001";
    --
    C_AP_IARG_0_DWIDTH      : integer := 32;
    C_AP_IARG_1_DWIDTH      : integer := 32;
    C_AP_IARG_2_DWIDTH      : integer := 32;
    C_AP_IARG_3_DWIDTH      : integer := 32;
    C_AP_IARG_4_DWIDTH      : integer := 32;
    C_AP_IARG_5_DWIDTH      : integer := 32;
    C_AP_IARG_6_DWIDTH      : integer := 32;
    C_AP_IARG_7_DWIDTH      : integer := 32;
    --
    C_M_AXIS_TDATA_WIDTH    : integer := 64;
    C_M_AXIS_TUSER_WIDTH    : integer := 8;
    C_M_AXIS_TID_WIDTH      : integer := 4;
    C_M_AXIS_TDEST_WIDTH    : integer := 8;
    --
    C_AP_OARG_TYPE          : std_logic_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    C_AP_OARG_MB_DEPTH      : std_logic_vector := X"0000000400000004000000040000000400000004000000040000000400000004";
    C_AP_OARG_WIDTH         : std_logic_vector := X"0000002000000020000000200000002000000020000000200000002000000020";
    C_AP_OARG_N_DIM         : std_logic_vector := X"0000000100000001000000010000000100000001000000010000000100000001";
    C_AP_OARG_DIM           : std_logic_vector := X"0000000100000001000000010000040000000001000000010000000100000400000000010000000100000001000004000000000100000001000000010000040000000001000000010000000100000400000000010000000100000001000004000000000100000001000000010000080000000001000000010000000100000008";
    C_AP_OARG_DIM_1         : std_logic_vector := X"0000040000000400000004000000040000000400000004000000080000000008";
    C_AP_OARG_DIM_2         : std_logic_vector := X"0000000100000001000000010000000100000001000000010000000100000001";
    C_AP_OARG_FORMAT_TYPE   : std_logic_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    C_AP_OARG_FORMAT_FACTOR : std_logic_vector := X"0000000100000001000000010000000100000001000000010000000100000001";
    C_AP_OARG_FORMAT_DIM    : std_logic_vector := X"0000000100000001000000010000000100000001000000010000000100000001";
    --
    C_AP_OARG_0_DWIDTH      : integer := 32;
    C_AP_OARG_1_DWIDTH      : integer := 32;
    C_AP_OARG_2_DWIDTH      : integer := 32;
    C_AP_OARG_3_DWIDTH      : integer := 32;
    C_AP_OARG_4_DWIDTH      : integer := 32;
    C_AP_OARG_5_DWIDTH      : integer := 32;
    C_AP_OARG_6_DWIDTH      : integer := 32;
    C_AP_OARG_7_DWIDTH      : integer := 32;
    --

    C_INPUT_SCALAR_0_WIDTH  : integer := 0;
    C_INPUT_SCALAR_1_WIDTH  : integer := 0;
    C_INPUT_SCALAR_2_WIDTH  : integer := 0;
    C_INPUT_SCALAR_3_WIDTH  : integer := 0;
    C_INPUT_SCALAR_4_WIDTH  : integer := 0;
    C_INPUT_SCALAR_5_WIDTH  : integer := 0;
    C_INPUT_SCALAR_6_WIDTH  : integer := 0;
    C_INPUT_SCALAR_7_WIDTH  : integer := 0;
    C_INPUT_SCALAR_8_WIDTH  : integer := 0;
    C_INPUT_SCALAR_9_WIDTH  : integer := 0;
    C_INPUT_SCALAR_10_WIDTH : integer := 0;
    C_INPUT_SCALAR_11_WIDTH : integer := 0;
    C_INPUT_SCALAR_12_WIDTH : integer := 0;
    C_INPUT_SCALAR_13_WIDTH : integer := 0;
    C_INPUT_SCALAR_14_WIDTH : integer := 0;
    C_INPUT_SCALAR_15_WIDTH : integer := 0;

    C_OUTPUT_SCALAR_0_WIDTH  : integer := 0;   
    C_OUTPUT_SCALAR_1_WIDTH  : integer := 0;   
    C_OUTPUT_SCALAR_2_WIDTH  : integer := 0;   
    C_OUTPUT_SCALAR_3_WIDTH  : integer := 0;   
    C_OUTPUT_SCALAR_4_WIDTH  : integer := 0;   
    C_OUTPUT_SCALAR_5_WIDTH  : integer := 0;   
    C_OUTPUT_SCALAR_6_WIDTH  : integer := 0;   
    C_OUTPUT_SCALAR_7_WIDTH  : integer := 0;   
    C_OUTPUT_SCALAR_8_WIDTH  : integer := 0;
    C_OUTPUT_SCALAR_9_WIDTH  : integer := 0;
    C_OUTPUT_SCALAR_10_WIDTH : integer := 0;
    C_OUTPUT_SCALAR_11_WIDTH : integer := 0;
    C_OUTPUT_SCALAR_12_WIDTH : integer := 0;
    C_OUTPUT_SCALAR_13_WIDTH : integer := 0;
    C_OUTPUT_SCALAR_14_WIDTH : integer := 0;
    C_OUTPUT_SCALAR_15_WIDTH : integer := 0;
    
    C_N_INOUT_SCALARS       : integer := 0;
    C_N_INPUT_SCALARS       : integer := 0;
    C_INPUT_SCALAR_DWIDTH   : std_logic_vector := X"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020";
    C_AP_ISCALAR_DOUT_WIDTH : integer := 32;
    C_INPUT_SCALAR_MODE     : std_logic_vector(63 downto 0) := X"0000000000000000";
    
    -- 
    C_N_OUTPUT_SCALARS      : integer := 0;
    C_OUTPUT_SCALAR_DWIDTH  : std_logic_vector := X"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020";
    C_AP_OSCALAR_DIN_WIDTH  : integer := 32;
    C_AP_ISCALAR_IO_DOUT_WIDTH : integer := 32;
    C_AP_OSCALAR_IO_DIN_WIDTH : integer := 32;
    C_OUTPUT_SCALAR_MODE    : std_logic_vector(63 downto 0) := X"0000000000000000";

    C_NONE : integer := 2);
  port (
    -------------------------------
    -- AXI4-Lite Slave Interface --
    -------------------------------
    s_axi_aclk       : in  std_logic;
    s_axi_aresetn    : in  std_logic;
    s_axi_awaddr     : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_awvalid    : in  std_logic;
    s_axi_awready    : out std_logic;
    s_axi_wdata      : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    s_axi_wstrb      : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
    s_axi_wvalid     : in  std_logic;
    s_axi_wready     : out std_logic;
    s_axi_bresp      : out std_logic_vector(1 downto 0);
    s_axi_bvalid     : out std_logic;
    s_axi_bready     : in  std_logic;
    s_axi_araddr     : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    s_axi_arvalid    : in  std_logic;
    s_axi_arready    : out std_logic;
    s_axi_rdata      : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    s_axi_rresp      : out std_logic_vector(1 downto 0);
    s_axi_rvalid     : out std_logic;
    s_axi_rready     : in  std_logic;

    ----------------------------------------------
    -- AXI4-Stream slave interface clock reset
    ----------------------------------------------
    s_axis_aclk      : in  std_logic;
    s_axis_aresetn   : in  std_logic;
    
    ----------------------------------------------
    -- AXI4-Stream master interface clock reset
    ----------------------------------------------
    m_axis_aclk      : in  std_logic;
    m_axis_aresetn   : in  std_logic;


    ----------------------------------------------
    -- Accelerator clock --
    ----------------------------------------------
    aclk                  : in  std_logic;

    -------------------------------
    -- AXI4-Stream Slave Interface --
    -------------------------------
    s_axis_0_aclk    : in  std_logic;
    s_axis_0_aresetn : in  std_logic;
    s_axis_0_tvalid  : in  std_logic;
    s_axis_0_tready  : out std_logic;
    s_axis_0_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    s_axis_0_tstrb   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_0_tkeep   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_0_tlast   : in  std_logic;
    s_axis_0_tid     : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    s_axis_0_tdest   : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    s_axis_0_tuser   : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);

    s_axis_1_aclk    : in  std_logic;
    s_axis_1_aresetn : in  std_logic;
    s_axis_1_tvalid  : in  std_logic;
    s_axis_1_tready  : out std_logic;
    s_axis_1_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    s_axis_1_tstrb   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_1_tkeep   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_1_tlast   : in  std_logic;
    s_axis_1_tid     : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    s_axis_1_tdest   : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    s_axis_1_tuser   : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);

    s_axis_2_aclk    : in  std_logic;
    s_axis_2_aresetn : in  std_logic;
    s_axis_2_tvalid  : in  std_logic;
    s_axis_2_tready  : out std_logic;
    s_axis_2_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    s_axis_2_tstrb   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_2_tkeep   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_2_tlast   : in  std_logic;
    s_axis_2_tid     : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    s_axis_2_tdest   : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    s_axis_2_tuser   : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);

    s_axis_3_aclk    : in  std_logic;
    s_axis_3_aresetn : in  std_logic;
    s_axis_3_tvalid  : in  std_logic;
    s_axis_3_tready  : out std_logic;
    s_axis_3_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    s_axis_3_tstrb   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_3_tkeep   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_3_tlast   : in  std_logic;
    s_axis_3_tid     : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    s_axis_3_tdest   : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    s_axis_3_tuser   : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);

    s_axis_4_aclk    : in  std_logic;
    s_axis_4_aresetn : in  std_logic;
    s_axis_4_tvalid  : in  std_logic;
    s_axis_4_tready  : out std_logic;
    s_axis_4_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    s_axis_4_tstrb   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_4_tkeep   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_4_tlast   : in  std_logic;
    s_axis_4_tid     : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    s_axis_4_tdest   : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    s_axis_4_tuser   : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);

    s_axis_5_aclk    : in  std_logic;
    s_axis_5_aresetn : in  std_logic;
    s_axis_5_tvalid  : in  std_logic;
    s_axis_5_tready  : out std_logic;
    s_axis_5_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    s_axis_5_tstrb   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_5_tkeep   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_5_tlast   : in  std_logic;
    s_axis_5_tid     : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    s_axis_5_tdest   : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    s_axis_5_tuser   : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);

    s_axis_6_aclk    : in  std_logic;
    s_axis_6_aresetn : in  std_logic;
    s_axis_6_tvalid  : in  std_logic;
    s_axis_6_tready  : out std_logic;
    s_axis_6_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    s_axis_6_tstrb   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_6_tkeep   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_6_tlast   : in  std_logic;
    s_axis_6_tid     : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    s_axis_6_tdest   : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    s_axis_6_tuser   : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);

    s_axis_7_aclk    : in  std_logic;
    s_axis_7_aresetn : in  std_logic;
    s_axis_7_tvalid  : in  std_logic;
    s_axis_7_tready  : out std_logic;
    s_axis_7_tdata   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    s_axis_7_tstrb   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_7_tkeep   : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0):= (others => '1');
    s_axis_7_tlast   : in  std_logic;
    s_axis_7_tid     : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    s_axis_7_tdest   : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    s_axis_7_tuser   : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);

    ------------------------------------------
    -- Accelerator Port input arguments (BRAM)
    ------------------------------------------
    ap_iarg_0_clk  : in  std_logic;
    ap_iarg_0_rst  : in  std_logic;
    ap_iarg_0_addr : in  std_logic_vector(31 downto 0);
    ap_iarg_0_ce   : in  std_logic;
    ap_iarg_0_we   : in  std_logic_vector(C_AP_IARG_0_DWIDTH/8-1 downto 0);
    ap_iarg_0_din  : in  std_logic_vector(C_AP_IARG_0_DWIDTH-1 downto 0);
    ap_iarg_0_dout : out std_logic_vector(C_AP_IARG_0_DWIDTH-1 downto 0);
    ---
    ap_iarg_1_clk  : in  std_logic;
    ap_iarg_1_rst  : in  std_logic;
    ap_iarg_1_addr : in  std_logic_vector(31 downto 0);
    ap_iarg_1_ce   : in  std_logic;
    ap_iarg_1_we   : in  std_logic_vector(C_AP_IARG_1_DWIDTH/8-1 downto 0);
    ap_iarg_1_din  : in  std_logic_vector(C_AP_IARG_1_DWIDTH-1 downto 0);
    ap_iarg_1_dout : out std_logic_vector(C_AP_IARG_1_DWIDTH-1 downto 0);
    ---
    ap_iarg_2_clk  : in  std_logic;
    ap_iarg_2_rst  : in  std_logic;
    ap_iarg_2_addr : in  std_logic_vector(31 downto 0);
    ap_iarg_2_ce   : in  std_logic;
    ap_iarg_2_we   : in  std_logic_vector(C_AP_IARG_2_DWIDTH/8-1 downto 0);
    ap_iarg_2_din  : in  std_logic_vector(C_AP_IARG_2_DWIDTH-1 downto 0);
    ap_iarg_2_dout : out std_logic_vector(C_AP_IARG_2_DWIDTH-1 downto 0);
    ---
    ap_iarg_3_clk  : in  std_logic;
    ap_iarg_3_rst  : in  std_logic;
    ap_iarg_3_addr : in  std_logic_vector(31 downto 0);
    ap_iarg_3_ce   : in  std_logic;
    ap_iarg_3_we   : in  std_logic_vector(C_AP_IARG_3_DWIDTH/8-1 downto 0);
    ap_iarg_3_din  : in  std_logic_vector(C_AP_IARG_3_DWIDTH-1 downto 0);
    ap_iarg_3_dout : out std_logic_vector(C_AP_IARG_3_DWIDTH-1 downto 0);
    ---
    ap_iarg_4_clk  : in  std_logic;
    ap_iarg_4_rst  : in  std_logic;
    ap_iarg_4_addr : in  std_logic_vector(31 downto 0);
    ap_iarg_4_ce   : in  std_logic;
    ap_iarg_4_we   : in  std_logic_vector(C_AP_IARG_4_DWIDTH/8-1 downto 0);
    ap_iarg_4_din  : in  std_logic_vector(C_AP_IARG_4_DWIDTH-1 downto 0);
    ap_iarg_4_dout : out std_logic_vector(C_AP_IARG_4_DWIDTH-1 downto 0);
    ---
    ap_iarg_5_clk  : in  std_logic;
    ap_iarg_5_rst  : in  std_logic;
    ap_iarg_5_addr : in  std_logic_vector(31 downto 0);
    ap_iarg_5_ce   : in  std_logic;
    ap_iarg_5_we   : in  std_logic_vector(C_AP_IARG_5_DWIDTH/8-1 downto 0);
    ap_iarg_5_din  : in  std_logic_vector(C_AP_IARG_5_DWIDTH-1 downto 0);
    ap_iarg_5_dout : out std_logic_vector(C_AP_IARG_5_DWIDTH-1 downto 0);
    ---
    ap_iarg_6_clk  : in  std_logic;
    ap_iarg_6_rst  : in  std_logic;
    ap_iarg_6_addr : in  std_logic_vector(31 downto 0);
    ap_iarg_6_ce   : in  std_logic;
    ap_iarg_6_we   : in  std_logic_vector(C_AP_IARG_6_DWIDTH/8-1 downto 0);
    ap_iarg_6_din  : in  std_logic_vector(C_AP_IARG_6_DWIDTH-1 downto 0);
    ap_iarg_6_dout : out std_logic_vector(C_AP_IARG_6_DWIDTH-1 downto 0);
    ---
    ap_iarg_7_clk  : in  std_logic;
    ap_iarg_7_rst  : in  std_logic;
    ap_iarg_7_addr : in  std_logic_vector(31 downto 0);
    ap_iarg_7_ce   : in  std_logic;
    ap_iarg_7_we   : in  std_logic_vector(C_AP_IARG_7_DWIDTH/8-1 downto 0);
    ap_iarg_7_din  : in  std_logic_vector(C_AP_IARG_7_DWIDTH-1 downto 0);
    ap_iarg_7_dout : out std_logic_vector(C_AP_IARG_7_DWIDTH-1 downto 0);

    ---------------------------------------------
    -- Accelerator Port input arguments (FIFO) --
    ---------------------------------------------
    ap_fifo_iarg_0_dout    : out std_logic_vector(C_AP_IARG_0_DWIDTH-1 downto 0);
    ap_fifo_iarg_0_read    : in  std_logic;
    ap_fifo_iarg_0_empty_n : out std_logic;

    ap_fifo_iarg_1_dout    : out std_logic_vector(C_AP_IARG_1_DWIDTH-1 downto 0);
    ap_fifo_iarg_1_read    : in  std_logic;
    ap_fifo_iarg_1_empty_n : out std_logic;

    ap_fifo_iarg_2_dout    : out std_logic_vector(C_AP_IARG_2_DWIDTH-1 downto 0);
    ap_fifo_iarg_2_read    : in  std_logic;
    ap_fifo_iarg_2_empty_n : out std_logic;

    ap_fifo_iarg_3_dout    : out std_logic_vector(C_AP_IARG_3_DWIDTH-1 downto 0);
    ap_fifo_iarg_3_read    : in  std_logic;
    ap_fifo_iarg_3_empty_n : out std_logic;

    ap_fifo_iarg_4_dout    : out std_logic_vector(C_AP_IARG_4_DWIDTH-1 downto 0);
    ap_fifo_iarg_4_read    : in  std_logic;
    ap_fifo_iarg_4_empty_n : out std_logic;

    ap_fifo_iarg_5_dout    : out std_logic_vector(C_AP_IARG_5_DWIDTH-1 downto 0);
    ap_fifo_iarg_5_read    : in  std_logic;
    ap_fifo_iarg_5_empty_n : out std_logic;

    ap_fifo_iarg_6_dout    : out std_logic_vector(C_AP_IARG_6_DWIDTH-1 downto 0);
    ap_fifo_iarg_6_read    : in  std_logic;
    ap_fifo_iarg_6_empty_n : out std_logic;

    ap_fifo_iarg_7_dout    : out std_logic_vector(C_AP_IARG_7_DWIDTH-1 downto 0);
    ap_fifo_iarg_7_read    : in  std_logic;
    ap_fifo_iarg_7_empty_n : out std_logic;

    -------------------------------
    --* AXI4-Stream Slave Interface* --
    -- Output Arguments
    -------------------------------
    m_axis_0_aclk    : in  std_logic;
    m_axis_0_aresetn : in  std_logic;
    m_axis_0_tvalid  : out std_logic;
    m_axis_0_tready  : in  std_logic;
    m_axis_0_tdata   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    m_axis_0_tstrb   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_0_tkeep   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_0_tlast   : out std_logic;
    m_axis_0_tid     : out std_logic_vector(C_M_AXIS_TID_WIDTH-1 downto 0);
    m_axis_0_tdest   : out std_logic_vector(C_M_AXIS_TDEST_WIDTH-1 downto 0);
    m_axis_0_tuser   : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);

    m_axis_1_aclk    : in  std_logic;
    m_axis_1_aresetn : in  std_logic;
    m_axis_1_tvalid  : out std_logic;
    m_axis_1_tready  : in  std_logic;
    m_axis_1_tdata   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    m_axis_1_tstrb   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_1_tkeep   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_1_tlast   : out std_logic;
    m_axis_1_tid     : out std_logic_vector(C_M_AXIS_TID_WIDTH-1 downto 0);
    m_axis_1_tdest   : out std_logic_vector(C_M_AXIS_TDEST_WIDTH-1 downto 0);
    m_axis_1_tuser   : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);

    m_axis_2_aclk    : in  std_logic;
    m_axis_2_aresetn : in  std_logic;
    m_axis_2_tvalid  : out std_logic;
    m_axis_2_tready  : in  std_logic;
    m_axis_2_tdata   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    m_axis_2_tstrb   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_2_tkeep   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_2_tlast   : out std_logic;
    m_axis_2_tid     : out std_logic_vector(C_M_AXIS_TID_WIDTH-1 downto 0);
    m_axis_2_tdest   : out std_logic_vector(C_M_AXIS_TDEST_WIDTH-1 downto 0);
    m_axis_2_tuser   : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);

    m_axis_3_aclk    : in  std_logic;
    m_axis_3_aresetn : in  std_logic;
    m_axis_3_tvalid  : out std_logic;
    m_axis_3_tready  : in  std_logic;
    m_axis_3_tdata   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    m_axis_3_tstrb   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_3_tkeep   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_3_tlast   : out std_logic;
    m_axis_3_tid     : out std_logic_vector(C_M_AXIS_TID_WIDTH-1 downto 0);
    m_axis_3_tdest   : out std_logic_vector(C_M_AXIS_TDEST_WIDTH-1 downto 0);
    m_axis_3_tuser   : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);

    m_axis_4_aclk    : in  std_logic;
    m_axis_4_aresetn : in  std_logic;
    m_axis_4_tvalid  : out std_logic;
    m_axis_4_tready  : in  std_logic;
    m_axis_4_tdata   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    m_axis_4_tstrb   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_4_tkeep   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_4_tlast   : out std_logic;
    m_axis_4_tid     : out std_logic_vector(C_M_AXIS_TID_WIDTH-1 downto 0);
    m_axis_4_tdest   : out std_logic_vector(C_M_AXIS_TDEST_WIDTH-1 downto 0);
    m_axis_4_tuser   : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);

    m_axis_5_aclk    : in  std_logic;
    m_axis_5_aresetn : in  std_logic;
    m_axis_5_tvalid  : out std_logic;
    m_axis_5_tready  : in  std_logic;
    m_axis_5_tdata   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    m_axis_5_tstrb   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_5_tkeep   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_5_tlast   : out std_logic;
    m_axis_5_tid     : out std_logic_vector(C_M_AXIS_TID_WIDTH-1 downto 0);
    m_axis_5_tdest   : out std_logic_vector(C_M_AXIS_TDEST_WIDTH-1 downto 0);
    m_axis_5_tuser   : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);

    m_axis_6_aclk    : in  std_logic;
    m_axis_6_aresetn : in  std_logic;
    m_axis_6_tvalid  : out std_logic;
    m_axis_6_tready  : in  std_logic;
    m_axis_6_tdata   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    m_axis_6_tstrb   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_6_tkeep   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_6_tlast   : out std_logic;
    m_axis_6_tid     : out std_logic_vector(C_M_AXIS_TID_WIDTH-1 downto 0);
    m_axis_6_tdest   : out std_logic_vector(C_M_AXIS_TDEST_WIDTH-1 downto 0);
    m_axis_6_tuser   : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);

    m_axis_7_aclk    : in  std_logic;
    m_axis_7_aresetn : in  std_logic;
    m_axis_7_tvalid  : out std_logic;
    m_axis_7_tready  : in  std_logic;
    m_axis_7_tdata   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH-1 downto 0);
    m_axis_7_tstrb   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_7_tkeep   : out std_logic_vector(C_M_AXIS_TDATA_WIDTH/8-1 downto 0);
    m_axis_7_tlast   : out std_logic;
    m_axis_7_tid     : out std_logic_vector(C_M_AXIS_TID_WIDTH-1 downto 0);
    m_axis_7_tdest   : out std_logic_vector(C_M_AXIS_TDEST_WIDTH-1 downto 0);
    m_axis_7_tuser   : out std_logic_vector(C_M_AXIS_TUSER_WIDTH-1 downto 0);

    ----------------------------------------------
    -- Accelerator Port output arguments (BRAM) --
    ----------------------------------------------
    --- AP output arguments
    ap_oarg_0_clk  : in  std_logic;
    ap_oarg_0_rst  : in  std_logic;
    ap_oarg_0_addr : in  std_logic_vector(31 downto 0);
    ap_oarg_0_ce   : in  std_logic;
    ap_oarg_0_we   : in  std_logic_vector(C_AP_OARG_0_DWIDTH/8-1 downto 0);
    ap_oarg_0_din  : in  std_logic_vector(C_AP_OARG_0_DWIDTH-1 downto 0);
    ap_oarg_0_dout : out std_logic_vector(C_AP_OARG_0_DWIDTH-1 downto 0);
    ---
    ap_oarg_1_clk  : in  std_logic;
    ap_oarg_1_rst  : in  std_logic;
    ap_oarg_1_addr : in  std_logic_vector(31 downto 0);
    ap_oarg_1_ce   : in  std_logic;
    ap_oarg_1_we   : in  std_logic_vector(C_AP_OARG_1_DWIDTH/8-1 downto 0);
    ap_oarg_1_din  : in  std_logic_vector(C_AP_OARG_1_DWIDTH-1 downto 0);
    ap_oarg_1_dout : out std_logic_vector(C_AP_OARG_1_DWIDTH-1 downto 0);
    ---
    ap_oarg_2_clk  : in  std_logic;
    ap_oarg_2_rst  : in  std_logic;
    ap_oarg_2_addr : in  std_logic_vector(31 downto 0);
    ap_oarg_2_ce   : in  std_logic;
    ap_oarg_2_we   : in  std_logic_vector(C_AP_OARG_2_DWIDTH/8-1 downto 0);
    ap_oarg_2_din  : in  std_logic_vector(C_AP_OARG_2_DWIDTH-1 downto 0);
    ap_oarg_2_dout : out std_logic_vector(C_AP_OARG_2_DWIDTH-1 downto 0);
    ---
    ap_oarg_3_clk  : in  std_logic;
    ap_oarg_3_rst  : in  std_logic;
    ap_oarg_3_addr : in  std_logic_vector(31 downto 0);
    ap_oarg_3_ce   : in  std_logic;
    ap_oarg_3_we   : in  std_logic_vector(C_AP_OARG_3_DWIDTH/8-1 downto 0);
    ap_oarg_3_din  : in  std_logic_vector(C_AP_OARG_3_DWIDTH-1 downto 0);
    ap_oarg_3_dout : out std_logic_vector(C_AP_OARG_3_DWIDTH-1 downto 0);
    ---
    ap_oarg_4_clk  : in  std_logic;
    ap_oarg_4_rst  : in  std_logic;
    ap_oarg_4_addr : in  std_logic_vector(31 downto 0);
    ap_oarg_4_ce   : in  std_logic;
    ap_oarg_4_we   : in  std_logic_vector(C_AP_OARG_4_DWIDTH/8-1 downto 0);
    ap_oarg_4_din  : in  std_logic_vector(C_AP_OARG_4_DWIDTH-1 downto 0);
    ap_oarg_4_dout : out std_logic_vector(C_AP_OARG_4_DWIDTH-1 downto 0);
    ---
    ap_oarg_5_clk  : in  std_logic;
    ap_oarg_5_rst  : in  std_logic;
    ap_oarg_5_addr : in  std_logic_vector(31 downto 0);
    ap_oarg_5_ce   : in  std_logic;
    ap_oarg_5_we   : in  std_logic_vector(C_AP_OARG_5_DWIDTH/8-1 downto 0);
    ap_oarg_5_din  : in  std_logic_vector(C_AP_OARG_5_DWIDTH-1 downto 0);
    ap_oarg_5_dout : out std_logic_vector(C_AP_OARG_5_DWIDTH-1 downto 0);
    ---
    ap_oarg_6_clk  : in  std_logic;
    ap_oarg_6_rst  : in  std_logic;
    ap_oarg_6_addr : in  std_logic_vector(31 downto 0);
    ap_oarg_6_ce   : in  std_logic;
    ap_oarg_6_we   : in  std_logic_vector(C_AP_OARG_6_DWIDTH/8-1 downto 0);
    ap_oarg_6_din  : in  std_logic_vector(C_AP_OARG_6_DWIDTH-1 downto 0);
    ap_oarg_6_dout : out std_logic_vector(C_AP_OARG_6_DWIDTH-1 downto 0);
    ---
    ap_oarg_7_clk  : in  std_logic;
    ap_oarg_7_rst  : in  std_logic;
    ap_oarg_7_addr : in  std_logic_vector(31 downto 0);
    ap_oarg_7_ce   : in  std_logic;
    ap_oarg_7_we   : in  std_logic_vector(C_AP_OARG_7_DWIDTH/8-1 downto 0);
    ap_oarg_7_din  : in  std_logic_vector(C_AP_OARG_7_DWIDTH-1 downto 0);
    ap_oarg_7_dout : out std_logic_vector(C_AP_OARG_7_DWIDTH-1 downto 0);

    ----------------------------------------------
    -- Accelerator Port output arguments (FIFO) --
    ----------------------------------------------
    ap_fifo_oarg_0_din    : in  std_logic_vector(C_AP_OARG_0_DWIDTH-1 downto 0);
    ap_fifo_oarg_0_write  : in  std_logic;
    ap_fifo_oarg_0_full_n : out std_logic;

    ap_fifo_oarg_1_din    : in  std_logic_vector(C_AP_OARG_1_DWIDTH-1 downto 0);
    ap_fifo_oarg_1_write  : in  std_logic;
    ap_fifo_oarg_1_full_n : out std_logic;

    ap_fifo_oarg_2_din    : in  std_logic_vector(C_AP_OARG_2_DWIDTH-1 downto 0);
    ap_fifo_oarg_2_write  : in  std_logic;
    ap_fifo_oarg_2_full_n : out std_logic;

    ap_fifo_oarg_3_din    : in  std_logic_vector(C_AP_OARG_3_DWIDTH-1 downto 0);
    ap_fifo_oarg_3_write  : in  std_logic;
    ap_fifo_oarg_3_full_n : out std_logic;

    ap_fifo_oarg_4_din    : in  std_logic_vector(C_AP_OARG_4_DWIDTH-1 downto 0);
    ap_fifo_oarg_4_write  : in  std_logic;
    ap_fifo_oarg_4_full_n : out std_logic;

    ap_fifo_oarg_5_din    : in  std_logic_vector(C_AP_OARG_5_DWIDTH-1 downto 0);
    ap_fifo_oarg_5_write  : in  std_logic;
    ap_fifo_oarg_5_full_n : out std_logic;

    ap_fifo_oarg_6_din    : in  std_logic_vector(C_AP_OARG_6_DWIDTH-1 downto 0);
    ap_fifo_oarg_6_write  : in  std_logic;
    ap_fifo_oarg_6_full_n : out std_logic;

    ap_fifo_oarg_7_din    : in  std_logic_vector(C_AP_OARG_7_DWIDTH-1 downto 0);
    ap_fifo_oarg_7_write  : in  std_logic;
    ap_fifo_oarg_7_full_n : out std_logic;


    ----------------------------------------------
    -- Accelerator Control Interface --
    ----------------------------------------------
    ap_start              : out std_logic;
    ap_ready              : in  std_logic;
    ap_done               : in  std_logic;
    ap_continue           : out std_logic;
    ap_idle               : in  std_logic;
    aresetn               : out std_logic;

    ----------------------------------------------
    -- Accelerator Input Scalar Interface --
    ----------------------------------------------
    ap_iscalar_0_dout     : out std_logic_vector(C_INPUT_SCALAR_0_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_1_dout     : out std_logic_vector(C_INPUT_SCALAR_1_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_2_dout     : out std_logic_vector(C_INPUT_SCALAR_2_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_3_dout     : out std_logic_vector(C_INPUT_SCALAR_3_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_4_dout     : out std_logic_vector(C_INPUT_SCALAR_4_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_5_dout     : out std_logic_vector(C_INPUT_SCALAR_5_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_6_dout     : out std_logic_vector(C_INPUT_SCALAR_6_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_7_dout     : out std_logic_vector(C_INPUT_SCALAR_7_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_8_dout     : out std_logic_vector(C_INPUT_SCALAR_8_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_9_dout     : out std_logic_vector(C_INPUT_SCALAR_9_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_10_dout    : out std_logic_vector(C_INPUT_SCALAR_10_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_11_dout    : out std_logic_vector(C_INPUT_SCALAR_11_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_12_dout    : out std_logic_vector(C_INPUT_SCALAR_12_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_13_dout    : out std_logic_vector(C_INPUT_SCALAR_13_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_14_dout    : out std_logic_vector(C_INPUT_SCALAR_14_WIDTH-1 downto 0) := (others=>'0');
    ap_iscalar_15_dout    : out std_logic_vector(C_INPUT_SCALAR_15_WIDTH-1 downto 0) := (others=>'0');
    
    -- Inpput scalar Valid signals (valid for AP_HS & AP_VLD modes)
    ap_iscalar_0_vld      : out  std_logic;
    ap_iscalar_1_vld      : out  std_logic;
    ap_iscalar_2_vld      : out  std_logic;
    ap_iscalar_3_vld      : out  std_logic;
    ap_iscalar_4_vld      : out  std_logic;
    ap_iscalar_5_vld      : out  std_logic;
    ap_iscalar_6_vld      : out  std_logic;
    ap_iscalar_7_vld      : out  std_logic;
    ap_iscalar_8_vld      : out  std_logic;
    ap_iscalar_9_vld      : out  std_logic;
    ap_iscalar_10_vld     : out  std_logic;
    ap_iscalar_11_vld     : out  std_logic;
    ap_iscalar_12_vld     : out  std_logic;
    ap_iscalar_13_vld     : out  std_logic;
    ap_iscalar_14_vld     : out  std_logic;
    ap_iscalar_15_vld     : out  std_logic;
    -- Input Scalar ack - (valid for AP_HS mode)
    ap_iscalar_0_ack      : in  std_logic;
    ap_iscalar_1_ack      : in  std_logic;
    ap_iscalar_2_ack      : in  std_logic;
    ap_iscalar_3_ack      : in  std_logic;
    ap_iscalar_4_ack      : in  std_logic;
    ap_iscalar_5_ack      : in  std_logic;
    ap_iscalar_6_ack      : in  std_logic;
    ap_iscalar_7_ack      : in  std_logic;
    ap_iscalar_8_ack      : in  std_logic;
    ap_iscalar_9_ack      : in  std_logic;
    ap_iscalar_10_ack     : in  std_logic;
    ap_iscalar_11_ack     : in  std_logic;
    ap_iscalar_12_ack     : in  std_logic;
    ap_iscalar_13_ack     : in  std_logic;
    ap_iscalar_14_ack     : in  std_logic;
    ap_iscalar_15_ack     : in  std_logic;

    ----------------------------------------------
    -- Accelerator Output Scalar Interface --
    ----------------------------------------------
    ap_oscalar_0_din      : in  std_logic_vector(C_OUTPUT_SCALAR_0_WIDTH-1 downto 0);
    ap_oscalar_1_din      : in  std_logic_vector(C_OUTPUT_SCALAR_1_WIDTH-1 downto 0);
    ap_oscalar_2_din      : in  std_logic_vector(C_OUTPUT_SCALAR_2_WIDTH-1 downto 0);
    ap_oscalar_3_din      : in  std_logic_vector(C_OUTPUT_SCALAR_3_WIDTH-1 downto 0);
    ap_oscalar_4_din      : in  std_logic_vector(C_OUTPUT_SCALAR_4_WIDTH-1 downto 0);
    ap_oscalar_5_din      : in  std_logic_vector(C_OUTPUT_SCALAR_5_WIDTH-1 downto 0);
    ap_oscalar_6_din      : in  std_logic_vector(C_OUTPUT_SCALAR_6_WIDTH-1 downto 0);
    ap_oscalar_7_din      : in  std_logic_vector(C_OUTPUT_SCALAR_7_WIDTH-1 downto 0);
    ap_oscalar_8_din      : in  std_logic_vector(C_OUTPUT_SCALAR_8_WIDTH-1 downto 0);
    ap_oscalar_9_din      : in  std_logic_vector(C_OUTPUT_SCALAR_9_WIDTH-1 downto 0);
    ap_oscalar_10_din     : in  std_logic_vector(C_OUTPUT_SCALAR_10_WIDTH-1 downto 0);
    ap_oscalar_11_din     : in  std_logic_vector(C_OUTPUT_SCALAR_11_WIDTH-1 downto 0);
    ap_oscalar_12_din     : in  std_logic_vector(C_OUTPUT_SCALAR_12_WIDTH-1 downto 0);
    ap_oscalar_13_din     : in  std_logic_vector(C_OUTPUT_SCALAR_13_WIDTH-1 downto 0);
    ap_oscalar_14_din     : in  std_logic_vector(C_OUTPUT_SCALAR_14_WIDTH-1 downto 0);
    ap_oscalar_15_din     : in  std_logic_vector(C_OUTPUT_SCALAR_15_WIDTH-1 downto 0);

    -- Output scalar Valid signals (valid for AP_HS & AP_VLD modes)
    ap_oscalar_0_vld      : in  std_logic;
    ap_oscalar_1_vld      : in  std_logic;
    ap_oscalar_2_vld      : in  std_logic;
    ap_oscalar_3_vld      : in  std_logic;
    ap_oscalar_4_vld      : in  std_logic;
    ap_oscalar_5_vld      : in  std_logic;
    ap_oscalar_6_vld      : in  std_logic;
    ap_oscalar_7_vld      : in  std_logic;
    ap_oscalar_8_vld      : in  std_logic;
    ap_oscalar_9_vld      : in  std_logic;
    ap_oscalar_10_vld     : in  std_logic;
    ap_oscalar_11_vld     : in  std_logic;
    ap_oscalar_12_vld     : in  std_logic;
    ap_oscalar_13_vld     : in  std_logic;
    ap_oscalar_14_vld     : in  std_logic;
    ap_oscalar_15_vld     : in  std_logic;
    -- Output Scalar ack - (valid for AP_HS mode)
    ap_oscalar_0_ack      : out  std_logic;
    ap_oscalar_1_ack      : out  std_logic;
    ap_oscalar_2_ack      : out  std_logic;
    ap_oscalar_3_ack      : out  std_logic;
    ap_oscalar_4_ack      : out  std_logic;
    ap_oscalar_5_ack      : out  std_logic;
    ap_oscalar_6_ack      : out  std_logic;
    ap_oscalar_7_ack      : out  std_logic;
    ap_oscalar_8_ack      : out  std_logic;
    ap_oscalar_9_ack      : out  std_logic;
    ap_oscalar_10_ack     : out  std_logic;
    ap_oscalar_11_ack     : out  std_logic;
    ap_oscalar_12_ack     : out  std_logic;
    ap_oscalar_13_ack     : out  std_logic;
    ap_oscalar_14_ack     : out  std_logic;
    ap_oscalar_15_ack     : out  std_logic;

    ---
    interrupt             : out std_logic);
end entity;

architecture rtl of axis_accelerator_adapter is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";


  -- Constant declaration
  constant C_S_AXIS_TSTRB_WIDTH : integer := C_S_AXIS_TDATA_WIDTH/8;
  constant C_S_AXIS_TKEEP_WIDTH : integer := C_S_AXIS_TDATA_WIDTH/8;
  constant C_M_AXIS_TSTRB_WIDTH : integer := C_M_AXIS_TDATA_WIDTH/8;
  constant C_M_AXIS_TKEEP_WIDTH : integer := C_M_AXIS_TDATA_WIDTH/8;
  constant C_MAX_SCALAR_DWIDTH  : integer := 32;
  constant C_MAX_ARG_DWIDTH     : integer := 1024;
  constant C_MAX_ARG_SWIDTH     : integer := 16;  -- Strobe width
  constant C_MAX_ARG_AWIDTH     : integer := 16;
  constant C_MAX_ARG_N_DIM      : integer := 4;
  constant C_MAX_MB_DEPTH       : integer := 8;
  constant C_MAX_N_IARGS        : integer := 8;
  constant C_MAX_N_OARGS        : integer := 8;
  constant C_MAX_N_ISCALARS     : integer := 8;
  constant C_MAX_N_OSCALARS     : integer := 8;
  constant C_MAX_N_IOSCALARS    : integer := 8;
  constant C_MTBF_STAGES        : integer := 4;


  -------------------------
  -- Scaler Data Width
  
  -------------------------
  -- GENERIC GROUPING: INPUT ARGUMENTS:
  function calc_iarg_dwidth return std_logic_vector is
    variable value : std_logic_vector(C_MAX_N_IARGS*32-1 downto 0) := (others => '0');
  begin
    value(32*(0+1)-1 downto 32*0) := int2lv(C_AP_IARG_0_DWIDTH);
    value(32*(1+1)-1 downto 32*1) := int2lv(C_AP_IARG_1_DWIDTH);
    value(32*(2+1)-1 downto 32*2) := int2lv(C_AP_IARG_2_DWIDTH);
    value(32*(3+1)-1 downto 32*3) := int2lv(C_AP_IARG_3_DWIDTH);
    value(32*(4+1)-1 downto 32*4) := int2lv(C_AP_IARG_4_DWIDTH);
    value(32*(5+1)-1 downto 32*5) := int2lv(C_AP_IARG_5_DWIDTH);
    value(32*(6+1)-1 downto 32*6) := int2lv(C_AP_IARG_6_DWIDTH);
    value(32*(7+1)-1 downto 32*7) := int2lv(C_AP_IARG_7_DWIDTH);
    return value;
  end function calc_iarg_dwidth;

  ---------------------------------------------------------
  -- GENERIC GROUPING: OUTPUT ARGUMENTS
  function calc_oarg_dwidth return std_logic_vector is
    variable value : std_logic_vector(C_MAX_N_OARGS*32-1 downto 0) := (others => '0');
  begin
    value(32*(0+1)-1 downto 32*0) := int2lv(C_AP_OARG_0_DWIDTH);
    value(32*(1+1)-1 downto 32*1) := int2lv(C_AP_OARG_1_DWIDTH);
    value(32*(2+1)-1 downto 32*2) := int2lv(C_AP_OARG_2_DWIDTH);
    value(32*(3+1)-1 downto 32*3) := int2lv(C_AP_OARG_3_DWIDTH);
    value(32*(4+1)-1 downto 32*4) := int2lv(C_AP_OARG_4_DWIDTH);
    value(32*(5+1)-1 downto 32*5) := int2lv(C_AP_OARG_5_DWIDTH);
    value(32*(6+1)-1 downto 32*6) := int2lv(C_AP_OARG_6_DWIDTH);
    value(32*(7+1)-1 downto 32*7) := int2lv(C_AP_OARG_7_DWIDTH);
    return value;
  end function calc_oarg_dwidth;


  -------------------------
  -- BRAM PRIMITIVE TYPE 
  -- 7_SERIES : RAMB36E1,  ULRASCALE : RAMB36E2
  -------------------------
  function calc_bram_type return string is
  begin
 
    if (C_FAMILY = "virtexu" or C_FAMILY = "kintexu" or C_FAMILY = "artixu" or C_FAMILY = "virtexuplus" or C_FAMILY = "kintexuplus" or C_FAMILY = "zynquplus") then
	return "ULTRASCALE";
    else 
	return "7_SERIES";
    end if ;
   
  end function calc_bram_type;


  constant BRAM_PRIMITIVE_TYPE : string := calc_bram_type;

  constant C_AP_OARG_DWIDTH : std_logic_vector(C_MAX_N_OARGS*32-1 downto 0) := calc_oarg_dwidth;
  constant C_AP_IARG_DWIDTH : std_logic_vector(C_MAX_N_IARGS*32-1 downto 0) := calc_iarg_dwidth;

  -- SUPERBUSSES DECLARATION:
  signal s_axis_aclk_i    : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal s_axis_aresetn_i : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal s_axis_tvalid  : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal s_axis_tready  : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal s_axis_tdata   : std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TDATA_WIDTH-1 downto 0);
  signal s_axis_tstrb   : std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TSTRB_WIDTH-1 downto 0);
  signal s_axis_tkeep   : std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TKEEP_WIDTH-1 downto 0);
  signal s_axis_tlast   : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal s_axis_tid     : std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TID_WIDTH-1 downto 0);
  signal s_axis_tdest   : std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TDEST_WIDTH-1 downto 0);
  signal s_axis_tuser   : std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TUSER_WIDTH-1 downto 0);

  signal m_axis_aclk_i    : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal m_axis_aresetn_i : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal m_axis_tvalid  : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal m_axis_tready  : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal m_axis_tdata   : std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDATA_WIDTH-1 downto 0);
  signal m_axis_tstrb   : std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TSTRB_WIDTH-1 downto 0);
  signal m_axis_tkeep   : std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TKEEP_WIDTH-1 downto 0);
  signal m_axis_tlast   : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal m_axis_tid     : std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TID_WIDTH-1 downto 0);
  signal m_axis_tdest   : std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDEST_WIDTH-1 downto 0);
  signal m_axis_tuser   : std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TUSER_WIDTH-1 downto 0);

  signal ap_iarg_addr : std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_AWIDTH-1 downto 0);
  signal ap_iarg_ce   : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal ap_iarg_we   : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal ap_iarg_din  : std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);
  signal ap_iarg_dout : std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);

  signal ap_oarg_addr : std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_AWIDTH-1 downto 0);
  signal ap_oarg_ce   : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal ap_oarg_we   : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal ap_oarg_din  : std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);
  signal ap_oarg_dout : std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);

  -------------------------------------------------------
  constant AP_IARG_0_OFFSET : integer := log2(C_AP_IARG_0_DWIDTH/8);
  constant AP_IARG_1_OFFSET : integer := log2(C_AP_IARG_1_DWIDTH/8);
  constant AP_IARG_2_OFFSET : integer := log2(C_AP_IARG_2_DWIDTH/8);
  constant AP_IARG_3_OFFSET : integer := log2(C_AP_IARG_3_DWIDTH/8);
  constant AP_IARG_4_OFFSET : integer := log2(C_AP_IARG_4_DWIDTH/8);
  constant AP_IARG_5_OFFSET : integer := log2(C_AP_IARG_5_DWIDTH/8);
  constant AP_IARG_6_OFFSET : integer := log2(C_AP_IARG_6_DWIDTH/8);
  constant AP_IARG_7_OFFSET : integer := log2(C_AP_IARG_7_DWIDTH/8);

  constant AP_OARG_0_OFFSET : integer := log2(C_AP_OARG_0_DWIDTH/8);
  constant AP_OARG_1_OFFSET : integer := log2(C_AP_OARG_1_DWIDTH/8);
  constant AP_OARG_2_OFFSET : integer := log2(C_AP_OARG_2_DWIDTH/8);
  constant AP_OARG_3_OFFSET : integer := log2(C_AP_OARG_3_DWIDTH/8);
  constant AP_OARG_4_OFFSET : integer := log2(C_AP_OARG_4_DWIDTH/8);
  constant AP_OARG_5_OFFSET : integer := log2(C_AP_OARG_5_DWIDTH/8);
  constant AP_OARG_6_OFFSET : integer := log2(C_AP_OARG_6_DWIDTH/8);
  constant AP_OARG_7_OFFSET : integer := log2(C_AP_OARG_7_DWIDTH/8);

  -------------------------------------------------
  signal ap_fifo_iarg_dout    : std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);
  signal ap_fifo_iarg_read    : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal ap_fifo_iarg_empty_n : std_logic_vector(C_MAX_N_IARGS-1 downto 0);

  signal ap_fifo_oarg_din    : std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);
  signal ap_fifo_oarg_write  : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal ap_fifo_oarg_full_n : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  -------------------------------------------------
   
  --  Scaler signals 
  signal ap_iscalar_dout_i     : std_logic_vector(511 downto 0);
  signal ap_oscalar_din_i      : std_logic_vector(511 downto 0);
  signal ap_oscalar_din_int    : std_logic_vector(C_AP_OSCALAR_DIN_WIDTH-1 downto 0);
  signal ap_ioscalar_din_int   : std_logic_vector(C_AP_OSCALAR_IO_DIN_WIDTH-1 downto 0);
  signal ap_oscalar_vld_i      : std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
  signal ap_iscalar_vld_i      : std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
  signal ap_oscalar_ack_i      : std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
  signal ap_iscalar_ack_i      : std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);

  signal zeros1    : std_logic_vector(256-C_AP_OSCALAR_DIN_WIDTH-1 downto 0);
  signal zeros256    : std_logic_vector(255 downto 0);

begin

zeros1 <= (others => '0');
zeros256 <= (others => '0');
    ----------------------------------------------
    -- Scalar signals assignments
    ----------------------------------------------
    ap_oscalar_vld_i <= ap_oscalar_15_vld & ap_oscalar_14_vld & ap_oscalar_13_vld &
                        ap_oscalar_12_vld & ap_oscalar_11_vld & ap_oscalar_10_vld & 
                        ap_oscalar_9_vld & ap_oscalar_8_vld & ap_oscalar_7_vld & 
                        ap_oscalar_6_vld & ap_oscalar_5_vld & ap_oscalar_4_vld & 
                        ap_oscalar_3_vld & ap_oscalar_2_vld & ap_oscalar_1_vld & 
                        ap_oscalar_0_vld;
                        
    ap_iscalar_ack_i <= ap_iscalar_15_ack & ap_iscalar_14_ack & ap_iscalar_13_ack &
                        ap_iscalar_12_ack & ap_iscalar_11_ack & ap_iscalar_10_ack & 
                        ap_iscalar_9_ack & ap_iscalar_8_ack & ap_iscalar_7_ack & 
                        ap_iscalar_6_ack & ap_iscalar_5_ack & ap_iscalar_4_ack & 
                        ap_iscalar_3_ack & ap_iscalar_2_ack & ap_iscalar_1_ack & 
                        ap_iscalar_0_ack;
  

    -- Output scalar ack generation
    ap_oscalar_0_ack  <= ap_oscalar_ack_i(0);
    ap_oscalar_1_ack  <= ap_oscalar_ack_i(1);
    ap_oscalar_2_ack  <= ap_oscalar_ack_i(2);
    ap_oscalar_3_ack  <= ap_oscalar_ack_i(3);
    ap_oscalar_4_ack  <= ap_oscalar_ack_i(4);
    ap_oscalar_5_ack  <= ap_oscalar_ack_i(5);
    ap_oscalar_6_ack  <= ap_oscalar_ack_i(6);
    ap_oscalar_7_ack  <= ap_oscalar_ack_i(7);
    ap_oscalar_8_ack  <= ap_oscalar_ack_i(8);
    ap_oscalar_9_ack  <= ap_oscalar_ack_i(9);
    ap_oscalar_10_ack  <= ap_oscalar_ack_i(10);
    ap_oscalar_11_ack  <= ap_oscalar_ack_i(11);
    ap_oscalar_12_ack  <= ap_oscalar_ack_i(12);
    ap_oscalar_13_ack  <= ap_oscalar_ack_i(13);
    ap_oscalar_14_ack  <= ap_oscalar_ack_i(14);
    ap_oscalar_15_ack  <= ap_oscalar_ack_i(15);
    
    -- input scalar valid generation
    ap_iscalar_0_vld  <= ap_iscalar_vld_i(0);
    ap_iscalar_1_vld  <= ap_iscalar_vld_i(1);
    ap_iscalar_2_vld  <= ap_iscalar_vld_i(2);
    ap_iscalar_3_vld  <= ap_iscalar_vld_i(3);
    ap_iscalar_4_vld  <= ap_iscalar_vld_i(4);
    ap_iscalar_5_vld  <= ap_iscalar_vld_i(5);
    ap_iscalar_6_vld  <= ap_iscalar_vld_i(6);
    ap_iscalar_7_vld  <= ap_iscalar_vld_i(7);
    ap_iscalar_8_vld  <= ap_iscalar_vld_i(8);
    ap_iscalar_9_vld  <= ap_iscalar_vld_i(9);
    ap_iscalar_10_vld  <= ap_iscalar_vld_i(10);
    ap_iscalar_11_vld  <= ap_iscalar_vld_i(11);
    ap_iscalar_12_vld  <= ap_iscalar_vld_i(12);
    ap_iscalar_13_vld  <= ap_iscalar_vld_i(13);
    ap_iscalar_14_vld  <= ap_iscalar_vld_i(14);
    ap_iscalar_15_vld  <= ap_iscalar_vld_i(15);



    ----------------------------------------------
    -- Output Scalar signals assignments
    ----------------------------------------------
    OSCALER_0_GEN : if (C_N_OUTPUT_SCALARS = 0) generate
    begin
      ap_oscalar_din_int <= (others=>'0'); 
    end generate OSCALER_0_GEN;    
    
    OSCALER_1_GEN : if (C_N_OUTPUT_SCALARS = 1) generate
    begin
      ap_oscalar_din_int <= ap_oscalar_0_din; 
    end generate OSCALER_1_GEN;    
    
    OSCALER_2_GEN : if (C_N_OUTPUT_SCALARS = 2) generate
    begin
      ap_oscalar_din_int <= ap_oscalar_1_din & ap_oscalar_0_din; 
    end generate OSCALER_2_GEN;    
    
    OSCALER_3_GEN : if (C_N_OUTPUT_SCALARS = 3) generate
    begin
      ap_oscalar_din_int <= ap_oscalar_2_din & ap_oscalar_1_din & ap_oscalar_0_din; 
    end generate OSCALER_3_GEN;    
    
    OSCALER_4_GEN : if (C_N_OUTPUT_SCALARS = 4) generate
    begin
      ap_oscalar_din_int <= ap_oscalar_3_din & ap_oscalar_2_din & ap_oscalar_1_din & ap_oscalar_0_din; 
    end generate OSCALER_4_GEN;    
    
    OSCALER_5_GEN : if (C_N_OUTPUT_SCALARS = 5) generate
    begin
      ap_oscalar_din_int <= ap_oscalar_4_din & ap_oscalar_3_din & ap_oscalar_2_din & ap_oscalar_1_din & ap_oscalar_0_din; 
    end generate OSCALER_5_GEN;    
    
    OSCALER_6_GEN : if (C_N_OUTPUT_SCALARS = 6) generate
    begin
      ap_oscalar_din_int <= ap_oscalar_5_din & ap_oscalar_4_din & ap_oscalar_3_din & ap_oscalar_2_din & ap_oscalar_1_din & ap_oscalar_0_din; 
    end generate OSCALER_6_GEN;    
    
    OSCALER_7_GEN : if (C_N_OUTPUT_SCALARS = 7) generate
    begin
      ap_oscalar_din_int <= ap_oscalar_6_din & ap_oscalar_5_din & ap_oscalar_4_din & ap_oscalar_3_din & ap_oscalar_2_din & ap_oscalar_1_din & ap_oscalar_0_din; 
    end generate OSCALER_7_GEN;    
    
    OSCALER_8_GEN : if (C_N_OUTPUT_SCALARS = 8) generate
    begin
      ap_oscalar_din_int <= ap_oscalar_7_din & ap_oscalar_6_din & ap_oscalar_5_din & ap_oscalar_4_din & ap_oscalar_3_din & ap_oscalar_2_din & ap_oscalar_1_din & ap_oscalar_0_din; 
    end generate OSCALER_8_GEN;    

    IOSCALER_0_GEN : if (C_N_INOUT_SCALARS = 0) generate
    begin
      ap_ioscalar_din_int <= (others=>'0'); 
    end generate IOSCALER_0_GEN;    

    OSCALER_9_GEN : if (C_N_INOUT_SCALARS = 1) generate
    begin
      ap_ioscalar_din_int <= ap_oscalar_8_din; 
    end generate OSCALER_9_GEN;    

    OSCALER_10_GEN : if (C_N_INOUT_SCALARS = 2) generate
    begin
      ap_ioscalar_din_int <= ap_oscalar_9_din & ap_oscalar_8_din; 
    end generate OSCALER_10_GEN;    

    OSCALER_11_GEN : if (C_N_INOUT_SCALARS = 3) generate
    begin
      ap_ioscalar_din_int <= ap_oscalar_10_din & ap_oscalar_9_din & ap_oscalar_8_din; 
    end generate OSCALER_11_GEN;    

    OSCALER_12_GEN : if (C_N_INOUT_SCALARS = 4) generate
    begin
      ap_ioscalar_din_int <= ap_oscalar_11_din & ap_oscalar_10_din & ap_oscalar_9_din & ap_oscalar_8_din; 
    end generate OSCALER_12_GEN;    

    OSCALER_13_GEN : if (C_N_INOUT_SCALARS = 5) generate
    begin
      ap_ioscalar_din_int <= ap_oscalar_12_din & ap_oscalar_11_din & ap_oscalar_10_din & ap_oscalar_9_din & ap_oscalar_8_din; 
    end generate OSCALER_13_GEN;    

    OSCALER_14_GEN : if (C_N_INOUT_SCALARS = 6) generate
    begin
      ap_ioscalar_din_int <= ap_oscalar_13_din & ap_oscalar_12_din & ap_oscalar_11_din & ap_oscalar_10_din & ap_oscalar_9_din & ap_oscalar_8_din; 
    end generate OSCALER_14_GEN;    

    OSCALER_15_GEN : if (C_N_INOUT_SCALARS = 7) generate
    begin
      ap_ioscalar_din_int <= ap_oscalar_14_din & ap_oscalar_13_din & ap_oscalar_12_din & ap_oscalar_11_din & ap_oscalar_10_din & ap_oscalar_9_din & ap_oscalar_8_din; 
    end generate OSCALER_15_GEN;    

    OSCALER_16_GEN : if (C_N_INOUT_SCALARS = 8) generate
    begin
      ap_ioscalar_din_int <= ap_oscalar_15_din & ap_oscalar_14_din & ap_oscalar_13_din & ap_oscalar_12_din & ap_oscalar_11_din & ap_oscalar_10_din & ap_oscalar_9_din & ap_oscalar_8_din; 
    end generate OSCALER_16_GEN;    

    OSCALER_GEN_1 : if (C_N_INOUT_SCALARS > 0 and C_N_OUTPUT_SCALARS > 0) generate
    begin
       ap_oscalar_din_i(256+C_AP_OSCALAR_IO_DIN_WIDTH-1 downto 0) <= ap_ioscalar_din_int & zeros1 & ap_oscalar_din_int;
       OSCALER_ZERO_GEN_1 : if (C_AP_OSCALAR_IO_DIN_WIDTH < 256 ) generate
       ap_oscalar_din_i(511 downto 256+C_AP_OSCALAR_IO_DIN_WIDTH) <= (others =>'0') ;
       end generate OSCALER_ZERO_GEN_1;    
    end generate OSCALER_GEN_1;    

    OSCALER_GEN_2 : if (C_N_INOUT_SCALARS = 0 and C_N_OUTPUT_SCALARS > 0) generate
    begin
       ap_oscalar_din_i(C_AP_OSCALAR_DIN_WIDTH-1 downto 0) <=  ap_oscalar_din_int;
       ap_oscalar_din_i(511 downto C_AP_OSCALAR_DIN_WIDTH) <=  (others => '0');
    end generate OSCALER_GEN_2;    

    OSCALER_GEN_3 : if (C_N_INOUT_SCALARS > 0 and C_N_OUTPUT_SCALARS = 0) generate
    begin
       ap_oscalar_din_i(256+C_AP_OSCALAR_IO_DIN_WIDTH-1 downto 0) <= ap_ioscalar_din_int & zeros256 ;
       OSCALER_ZERO_GEN_3 : if (C_AP_OSCALAR_IO_DIN_WIDTH < 256 ) generate
       ap_oscalar_din_i(511 downto 256+C_AP_OSCALAR_IO_DIN_WIDTH) <= (others =>'0') ;
       end generate OSCALER_ZERO_GEN_3;    
    end generate OSCALER_GEN_3;    

    OSCALER_GEN_4 : if (C_N_INOUT_SCALARS = 0 and C_N_OUTPUT_SCALARS = 0) generate
    begin
       ap_oscalar_din_i <= (others => '0');
    end generate OSCALER_GEN_4;    



    ----------------------------------------------
    -- Input Scalar signals assignments
    ----------------------------------------------
    ISCALER_1_GEN : if (C_N_INPUT_SCALARS > 0) generate
    begin
        ap_iscalar_0_dout <= ap_iscalar_dout_i((get_compact_MSB(C_INPUT_SCALAR_DWIDTH, 0)) downto (get_compact_LSB(C_INPUT_SCALAR_DWIDTH, 0)));
    end generate ISCALER_1_GEN;    
    
    ISCALER_2_GEN : if (C_N_INPUT_SCALARS > 1) generate
    begin
        ap_iscalar_1_dout <= ap_iscalar_dout_i((get_compact_MSB(C_INPUT_SCALAR_DWIDTH, 1)) downto (get_compact_LSB(C_INPUT_SCALAR_DWIDTH, 1)));  
    end generate ISCALER_2_GEN;    
    
    ISCALER_3_GEN : if (C_N_INPUT_SCALARS > 2) generate
    begin
        ap_iscalar_2_dout <= ap_iscalar_dout_i((get_compact_MSB(C_INPUT_SCALAR_DWIDTH, 2)) downto (get_compact_LSB(C_INPUT_SCALAR_DWIDTH, 2)));
    end generate ISCALER_3_GEN;    
    
    ISCALER_4_GEN : if (C_N_INPUT_SCALARS > 3) generate
    begin
        ap_iscalar_3_dout <= ap_iscalar_dout_i((get_compact_MSB(C_INPUT_SCALAR_DWIDTH, 3)) downto (get_compact_LSB(C_INPUT_SCALAR_DWIDTH, 3)));
    end generate ISCALER_4_GEN;    
    
    ISCALER_5_GEN : if (C_N_INPUT_SCALARS > 4) generate
    begin
        ap_iscalar_4_dout <= ap_iscalar_dout_i((get_compact_MSB(C_INPUT_SCALAR_DWIDTH, 4)) downto (get_compact_LSB(C_INPUT_SCALAR_DWIDTH, 4)));
    end generate ISCALER_5_GEN;    
    
    ISCALER_6_GEN : if (C_N_INPUT_SCALARS > 5) generate
    begin
        ap_iscalar_5_dout <= ap_iscalar_dout_i((get_compact_MSB(C_INPUT_SCALAR_DWIDTH, 5)) downto (get_compact_LSB(C_INPUT_SCALAR_DWIDTH, 5)));
    end generate ISCALER_6_GEN;    
    
    ISCALER_7_GEN : if (C_N_INPUT_SCALARS > 6) generate
    begin
        ap_iscalar_6_dout <= ap_iscalar_dout_i((get_compact_MSB(C_INPUT_SCALAR_DWIDTH, 6)) downto (get_compact_LSB(C_INPUT_SCALAR_DWIDTH, 6)));
    end generate ISCALER_7_GEN;    
    
    ISCALER_8_GEN : if (C_N_INPUT_SCALARS > 7) generate
    begin
        ap_iscalar_7_dout <= ap_iscalar_dout_i((get_compact_MSB(C_INPUT_SCALAR_DWIDTH, 7)) downto (get_compact_LSB(C_INPUT_SCALAR_DWIDTH, 7)));
    end generate ISCALER_8_GEN;    
    
    ISCALER_9_GEN : if (C_N_INOUT_SCALARS > 0) generate
    begin
        ap_iscalar_8_dout <= ap_iscalar_dout_i((get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, 8)) downto (get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, 8)));
    end generate ISCALER_9_GEN;    
    
    ISCALER_10_GEN : if (C_N_INOUT_SCALARS > 1) generate
    begin
        ap_iscalar_9_dout <= ap_iscalar_dout_i((get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, 9)) downto (get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, 9)));  
    end generate ISCALER_10_GEN;    
    
    ISCALER_11_GEN : if (C_N_INOUT_SCALARS > 2) generate
    begin
        ap_iscalar_10_dout <= ap_iscalar_dout_i((get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, 10)) downto (get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, 10)));
    end generate ISCALER_11_GEN;    
    
    ISCALER_12_GEN : if (C_N_INOUT_SCALARS > 3) generate
    begin
        ap_iscalar_11_dout <= ap_iscalar_dout_i((get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, 11)) downto (get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, 11)));
    end generate ISCALER_12_GEN;    
    
    ISCALER_13_GEN : if (C_N_INOUT_SCALARS > 4) generate
    begin
        ap_iscalar_12_dout <= ap_iscalar_dout_i((get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, 12)) downto (get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, 12)));
    end generate ISCALER_13_GEN;    
    
    ISCALER_14_GEN : if (C_N_INOUT_SCALARS > 5) generate
    begin
        ap_iscalar_13_dout <= ap_iscalar_dout_i((get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, 13)) downto (get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, 13)));
    end generate ISCALER_14_GEN;    
    
    ISCALER_15_GEN : if (C_N_INOUT_SCALARS > 6) generate
    begin
        ap_iscalar_14_dout <= ap_iscalar_dout_i((get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, 14)) downto (get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, 14)));
    end generate ISCALER_15_GEN;    
    
    ISCALER_16_GEN : if (C_N_INOUT_SCALARS > 7) generate
    begin
        ap_iscalar_15_dout <= ap_iscalar_dout_i((get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, 15)) downto (get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, 15)));
    end generate ISCALER_16_GEN;    
 
 
 
  
                     
    -----------------------------------------------------------------------------------------
    -- AXI4-Stream Slave interface signal Generation
    -- Single stremaing clock and reset port exposed to user. Asynchronous clocks between the 
    -- different streaming channel not supported
    -----------------------------------------------------------------------------------------
    SINGLE_CLK_RST_GEN : if (C_ENABLE_STREAM_CLK = 0) generate

      s_axis_aclk_i(0) <= s_axis_aclk;
      s_axis_aclk_i(1) <= s_axis_aclk;
      s_axis_aclk_i(2) <= s_axis_aclk;
      s_axis_aclk_i(3) <= s_axis_aclk;
      s_axis_aclk_i(4) <= s_axis_aclk;
      s_axis_aclk_i(5) <= s_axis_aclk;
      s_axis_aclk_i(6) <= s_axis_aclk;
      s_axis_aclk_i(7) <= s_axis_aclk;

      s_axis_aresetn_i(0) <= s_axis_aresetn;
      s_axis_aresetn_i(1) <= s_axis_aresetn;
      s_axis_aresetn_i(2) <= s_axis_aresetn;
      s_axis_aresetn_i(3) <= s_axis_aresetn;
      s_axis_aresetn_i(4) <= s_axis_aresetn;
      s_axis_aresetn_i(5) <= s_axis_aresetn;
      s_axis_aresetn_i(6) <= s_axis_aresetn;
      s_axis_aresetn_i(7) <= s_axis_aresetn;

      m_axis_aclk_i(0) <= m_axis_aclk;
      m_axis_aclk_i(1) <= m_axis_aclk;
      m_axis_aclk_i(2) <= m_axis_aclk;
      m_axis_aclk_i(3) <= m_axis_aclk;
      m_axis_aclk_i(4) <= m_axis_aclk;
      m_axis_aclk_i(5) <= m_axis_aclk;
      m_axis_aclk_i(6) <= m_axis_aclk;
      m_axis_aclk_i(7) <= m_axis_aclk;

      m_axis_aresetn_i(0) <= m_axis_aresetn;
      m_axis_aresetn_i(1) <= m_axis_aresetn;
      m_axis_aresetn_i(2) <= m_axis_aresetn;
      m_axis_aresetn_i(3) <= m_axis_aresetn;
      m_axis_aresetn_i(4) <= m_axis_aresetn;
      m_axis_aresetn_i(5) <= m_axis_aresetn;
      m_axis_aresetn_i(6) <= m_axis_aresetn;
      m_axis_aresetn_i(7) <= m_axis_aresetn;
      
    end generate SINGLE_CLK_RST_GEN;    


    -----------------------------------------------------------------------------------------
    -- AXI4-Stream Slave interface signal Generation
    -- Asynchronous clocks between the different streaming channel supported
    -----------------------------------------------------------------------------------------
    ASYNC_CLK_RST_GEN : if (C_ENABLE_STREAM_CLK = 1) generate

      s_axis_aclk_i(0) <= s_axis_0_aclk;
      s_axis_aclk_i(1) <= s_axis_1_aclk;
      s_axis_aclk_i(2) <= s_axis_2_aclk;
      s_axis_aclk_i(3) <= s_axis_3_aclk;
      s_axis_aclk_i(4) <= s_axis_4_aclk;
      s_axis_aclk_i(5) <= s_axis_5_aclk;
      s_axis_aclk_i(6) <= s_axis_6_aclk;
      s_axis_aclk_i(7) <= s_axis_7_aclk;

      s_axis_aresetn_i(0) <= s_axis_0_aresetn;
      s_axis_aresetn_i(1) <= s_axis_1_aresetn;
      s_axis_aresetn_i(2) <= s_axis_2_aresetn;
      s_axis_aresetn_i(3) <= s_axis_3_aresetn;
      s_axis_aresetn_i(4) <= s_axis_4_aresetn;
      s_axis_aresetn_i(5) <= s_axis_5_aresetn;
      s_axis_aresetn_i(6) <= s_axis_6_aresetn;
      s_axis_aresetn_i(7) <= s_axis_7_aresetn;

      m_axis_aclk_i(0) <= m_axis_0_aclk;
      m_axis_aclk_i(1) <= m_axis_1_aclk;
      m_axis_aclk_i(2) <= m_axis_2_aclk;
      m_axis_aclk_i(3) <= m_axis_3_aclk;
      m_axis_aclk_i(4) <= m_axis_4_aclk;
      m_axis_aclk_i(5) <= m_axis_5_aclk;
      m_axis_aclk_i(6) <= m_axis_6_aclk;
      m_axis_aclk_i(7) <= m_axis_7_aclk;

      m_axis_aresetn_i(0) <= m_axis_0_aresetn;
      m_axis_aresetn_i(1) <= m_axis_1_aresetn;
      m_axis_aresetn_i(2) <= m_axis_2_aresetn;
      m_axis_aresetn_i(3) <= m_axis_3_aresetn;
      m_axis_aresetn_i(4) <= m_axis_4_aresetn;
      m_axis_aresetn_i(5) <= m_axis_5_aresetn;
      m_axis_aresetn_i(6) <= m_axis_6_aresetn;
      m_axis_aresetn_i(7) <= m_axis_7_aresetn;

    end generate ASYNC_CLK_RST_GEN;    
    

    -------------------------------------------------------------------------------------------------
    -- Assiging default value '1' when TSTRB and TKEEP signals are not present in the Input stream. 
    -- When Input stream STROBE and KEEP are available, no need to drive default values. 
    -- This is work around to resolve the Vivado wrapper issue which does not drive default input '1' 
    -- properly when signla widht is less than 4 bits.
    -------------------------------------------------------------------------------------------------
    EN_TSTRB_GEN : if (C_S_AXIS_HAS_TSTRB = 1) generate
      s_axis_tstrb(C_S_AXIS_TSTRB_WIDTH*(0+1)-1 downto C_S_AXIS_TSTRB_WIDTH*0) <= s_axis_0_tstrb;
      s_axis_tstrb(C_S_AXIS_TSTRB_WIDTH*(1+1)-1 downto C_S_AXIS_TSTRB_WIDTH*1) <= s_axis_1_tstrb;
      s_axis_tstrb(C_S_AXIS_TSTRB_WIDTH*(2+1)-1 downto C_S_AXIS_TSTRB_WIDTH*2) <= s_axis_2_tstrb;
      s_axis_tstrb(C_S_AXIS_TSTRB_WIDTH*(3+1)-1 downto C_S_AXIS_TSTRB_WIDTH*3) <= s_axis_3_tstrb;
      s_axis_tstrb(C_S_AXIS_TSTRB_WIDTH*(4+1)-1 downto C_S_AXIS_TSTRB_WIDTH*4) <= s_axis_4_tstrb;
      s_axis_tstrb(C_S_AXIS_TSTRB_WIDTH*(5+1)-1 downto C_S_AXIS_TSTRB_WIDTH*5) <= s_axis_5_tstrb;
      s_axis_tstrb(C_S_AXIS_TSTRB_WIDTH*(6+1)-1 downto C_S_AXIS_TSTRB_WIDTH*6) <= s_axis_6_tstrb;
      s_axis_tstrb(C_S_AXIS_TSTRB_WIDTH*(7+1)-1 downto C_S_AXIS_TSTRB_WIDTH*7) <= s_axis_7_tstrb;
    end generate EN_TSTRB_GEN;    
  
    NO_TSTRB_GEN : if (C_S_AXIS_HAS_TSTRB = 0) generate
      s_axis_tstrb <= (others => '1') ;
    end generate NO_TSTRB_GEN;    


    -- TKEEP generation
    EN_TKEEP_GEN : if (C_S_AXIS_HAS_TKEEP = 1) generate
      s_axis_tkeep(C_S_AXIS_TKEEP_WIDTH*(0+1)-1 downto C_S_AXIS_TKEEP_WIDTH*0) <= s_axis_0_tkeep;
      s_axis_tkeep(C_S_AXIS_TKEEP_WIDTH*(1+1)-1 downto C_S_AXIS_TKEEP_WIDTH*1) <= s_axis_1_tkeep;
      s_axis_tkeep(C_S_AXIS_TKEEP_WIDTH*(2+1)-1 downto C_S_AXIS_TKEEP_WIDTH*2) <= s_axis_2_tkeep;
      s_axis_tkeep(C_S_AXIS_TKEEP_WIDTH*(3+1)-1 downto C_S_AXIS_TKEEP_WIDTH*3) <= s_axis_3_tkeep;
      s_axis_tkeep(C_S_AXIS_TKEEP_WIDTH*(4+1)-1 downto C_S_AXIS_TKEEP_WIDTH*4) <= s_axis_4_tkeep;
      s_axis_tkeep(C_S_AXIS_TKEEP_WIDTH*(5+1)-1 downto C_S_AXIS_TKEEP_WIDTH*5) <= s_axis_5_tkeep;
      s_axis_tkeep(C_S_AXIS_TKEEP_WIDTH*(6+1)-1 downto C_S_AXIS_TKEEP_WIDTH*6) <= s_axis_6_tkeep;
      s_axis_tkeep(C_S_AXIS_TKEEP_WIDTH*(7+1)-1 downto C_S_AXIS_TKEEP_WIDTH*7) <= s_axis_7_tkeep;
    end generate EN_TKEEP_GEN;    
  
    NO_TKEEP_GEN : if (C_S_AXIS_HAS_TKEEP = 0) generate
      s_axis_tkeep <= (others => '1') ;
    end generate NO_TKEEP_GEN;    


    -----------------------------------------------------------------------------------------
    -- AXI4-Stream Slave interface signal Generation
    -- SUPERBUSES BUILDING: SLAVE AXI STREAMS (INPUT ARGUMENTS):
    -- NOTE FOR SIMULATION: This concatenation inserts a delta delay for clocks signals. In
    -- the case of input signals causality is preserved becouse another delta delay is
    -- inserted during their concatenation. For input signals, there is no problem
    -----------------------------------------------------------------------------------------
    --AXI4-Stream slave interface TVALID generation
    s_axis_tvalid(0) <= s_axis_0_tvalid;
    s_axis_tvalid(1) <= s_axis_1_tvalid;
    s_axis_tvalid(2) <= s_axis_2_tvalid;
    s_axis_tvalid(3) <= s_axis_3_tvalid;
    s_axis_tvalid(4) <= s_axis_4_tvalid;
    s_axis_tvalid(5) <= s_axis_5_tvalid;
    s_axis_tvalid(6) <= s_axis_6_tvalid;
    s_axis_tvalid(7) <= s_axis_7_tvalid;

    --AXI4-Stream slave interface TREADY generation
    s_axis_0_tready <= s_axis_tready(0);
    s_axis_1_tready <= s_axis_tready(1);
    s_axis_2_tready <= s_axis_tready(2);
    s_axis_3_tready <= s_axis_tready(3);
    s_axis_4_tready <= s_axis_tready(4);
    s_axis_5_tready <= s_axis_tready(5);
    s_axis_6_tready <= s_axis_tready(6);
    s_axis_7_tready <= s_axis_tready(7);

    --AXI4-Stream slave interface TDATA generation
    s_axis_tdata(C_S_AXIS_TDATA_WIDTH*(0+1)-1 downto C_S_AXIS_TDATA_WIDTH*0) <= s_axis_0_tdata;
    s_axis_tdata(C_S_AXIS_TDATA_WIDTH*(1+1)-1 downto C_S_AXIS_TDATA_WIDTH*1) <= s_axis_1_tdata;
    s_axis_tdata(C_S_AXIS_TDATA_WIDTH*(2+1)-1 downto C_S_AXIS_TDATA_WIDTH*2) <= s_axis_2_tdata;
    s_axis_tdata(C_S_AXIS_TDATA_WIDTH*(3+1)-1 downto C_S_AXIS_TDATA_WIDTH*3) <= s_axis_3_tdata;
    s_axis_tdata(C_S_AXIS_TDATA_WIDTH*(4+1)-1 downto C_S_AXIS_TDATA_WIDTH*4) <= s_axis_4_tdata;
    s_axis_tdata(C_S_AXIS_TDATA_WIDTH*(5+1)-1 downto C_S_AXIS_TDATA_WIDTH*5) <= s_axis_5_tdata;
    s_axis_tdata(C_S_AXIS_TDATA_WIDTH*(6+1)-1 downto C_S_AXIS_TDATA_WIDTH*6) <= s_axis_6_tdata;
    s_axis_tdata(C_S_AXIS_TDATA_WIDTH*(7+1)-1 downto C_S_AXIS_TDATA_WIDTH*7) <= s_axis_7_tdata;

    --AXI4-Stream slave interface TLAST generation
    s_axis_tlast(0) <= s_axis_0_tlast;
    s_axis_tlast(1) <= s_axis_1_tlast;
    s_axis_tlast(2) <= s_axis_2_tlast;
    s_axis_tlast(3) <= s_axis_3_tlast;
    s_axis_tlast(4) <= s_axis_4_tlast;
    s_axis_tlast(5) <= s_axis_5_tlast;
    s_axis_tlast(6) <= s_axis_6_tlast;
    s_axis_tlast(7) <= s_axis_7_tlast;

    --AXI4-Stream slave interface TID generation
    s_axis_tid(C_S_AXIS_TID_WIDTH*(0+1)-1 downto C_S_AXIS_TID_WIDTH*0) <= s_axis_0_tid;
    s_axis_tid(C_S_AXIS_TID_WIDTH*(1+1)-1 downto C_S_AXIS_TID_WIDTH*1) <= s_axis_1_tid;
    s_axis_tid(C_S_AXIS_TID_WIDTH*(2+1)-1 downto C_S_AXIS_TID_WIDTH*2) <= s_axis_2_tid;
    s_axis_tid(C_S_AXIS_TID_WIDTH*(3+1)-1 downto C_S_AXIS_TID_WIDTH*3) <= s_axis_3_tid;
    s_axis_tid(C_S_AXIS_TID_WIDTH*(4+1)-1 downto C_S_AXIS_TID_WIDTH*4) <= s_axis_4_tid;
    s_axis_tid(C_S_AXIS_TID_WIDTH*(5+1)-1 downto C_S_AXIS_TID_WIDTH*5) <= s_axis_5_tid;
    s_axis_tid(C_S_AXIS_TID_WIDTH*(6+1)-1 downto C_S_AXIS_TID_WIDTH*6) <= s_axis_6_tid;
    s_axis_tid(C_S_AXIS_TID_WIDTH*(7+1)-1 downto C_S_AXIS_TID_WIDTH*7) <= s_axis_7_tid;

    --AXI4-Stream slave interface TDEST generation
    s_axis_tdest(C_S_AXIS_TDEST_WIDTH*(0+1)-1 downto C_S_AXIS_TDEST_WIDTH*0) <= s_axis_0_tdest;
    s_axis_tdest(C_S_AXIS_TDEST_WIDTH*(1+1)-1 downto C_S_AXIS_TDEST_WIDTH*1) <= s_axis_1_tdest;
    s_axis_tdest(C_S_AXIS_TDEST_WIDTH*(2+1)-1 downto C_S_AXIS_TDEST_WIDTH*2) <= s_axis_2_tdest;
    s_axis_tdest(C_S_AXIS_TDEST_WIDTH*(3+1)-1 downto C_S_AXIS_TDEST_WIDTH*3) <= s_axis_3_tdest;
    s_axis_tdest(C_S_AXIS_TDEST_WIDTH*(4+1)-1 downto C_S_AXIS_TDEST_WIDTH*4) <= s_axis_4_tdest;
    s_axis_tdest(C_S_AXIS_TDEST_WIDTH*(5+1)-1 downto C_S_AXIS_TDEST_WIDTH*5) <= s_axis_5_tdest;
    s_axis_tdest(C_S_AXIS_TDEST_WIDTH*(6+1)-1 downto C_S_AXIS_TDEST_WIDTH*6) <= s_axis_6_tdest;
    s_axis_tdest(C_S_AXIS_TDEST_WIDTH*(7+1)-1 downto C_S_AXIS_TDEST_WIDTH*7) <= s_axis_7_tdest;

    --AXI4-Stream slave interface TUSER generation
    s_axis_tuser(C_S_AXIS_TUSER_WIDTH*(0+1)-1 downto C_S_AXIS_TUSER_WIDTH*0) <= s_axis_0_tuser;
    s_axis_tuser(C_S_AXIS_TUSER_WIDTH*(1+1)-1 downto C_S_AXIS_TUSER_WIDTH*1) <= s_axis_1_tuser;
    s_axis_tuser(C_S_AXIS_TUSER_WIDTH*(2+1)-1 downto C_S_AXIS_TUSER_WIDTH*2) <= s_axis_2_tuser;
    s_axis_tuser(C_S_AXIS_TUSER_WIDTH*(3+1)-1 downto C_S_AXIS_TUSER_WIDTH*3) <= s_axis_3_tuser;
    s_axis_tuser(C_S_AXIS_TUSER_WIDTH*(4+1)-1 downto C_S_AXIS_TUSER_WIDTH*4) <= s_axis_4_tuser;
    s_axis_tuser(C_S_AXIS_TUSER_WIDTH*(5+1)-1 downto C_S_AXIS_TUSER_WIDTH*5) <= s_axis_5_tuser;
    s_axis_tuser(C_S_AXIS_TUSER_WIDTH*(6+1)-1 downto C_S_AXIS_TUSER_WIDTH*6) <= s_axis_6_tuser;
    s_axis_tuser(C_S_AXIS_TUSER_WIDTH*(7+1)-1 downto C_S_AXIS_TUSER_WIDTH*7) <= s_axis_7_tuser;

    -----------------------------------------------------------------------------------------
    -- Accelerator Input Argument interface signal Generation
    -- SUPERBUSES BUILDING: AP INPUT ARGUMENTS:
    -----------------------------------------------------------------------------------------
    -- Input Argument BRAM interface addr generation
    ap_iarg_addr(C_MAX_ARG_AWIDTH*(0+1)-1 downto C_MAX_ARG_AWIDTH*0) <= ap_iarg_0_addr(C_MAX_ARG_AWIDTH+AP_IARG_0_OFFSET-1 downto AP_IARG_0_OFFSET);
    ap_iarg_addr(C_MAX_ARG_AWIDTH*(1+1)-1 downto C_MAX_ARG_AWIDTH*1) <= ap_iarg_1_addr(C_MAX_ARG_AWIDTH+AP_IARG_1_OFFSET-1 downto AP_IARG_1_OFFSET);
    ap_iarg_addr(C_MAX_ARG_AWIDTH*(2+1)-1 downto C_MAX_ARG_AWIDTH*2) <= ap_iarg_2_addr(C_MAX_ARG_AWIDTH+AP_IARG_2_OFFSET-1 downto AP_IARG_2_OFFSET);
    ap_iarg_addr(C_MAX_ARG_AWIDTH*(3+1)-1 downto C_MAX_ARG_AWIDTH*3) <= ap_iarg_3_addr(C_MAX_ARG_AWIDTH+AP_IARG_3_OFFSET-1 downto AP_IARG_3_OFFSET);
    ap_iarg_addr(C_MAX_ARG_AWIDTH*(4+1)-1 downto C_MAX_ARG_AWIDTH*4) <= ap_iarg_4_addr(C_MAX_ARG_AWIDTH+AP_IARG_4_OFFSET-1 downto AP_IARG_4_OFFSET);
    ap_iarg_addr(C_MAX_ARG_AWIDTH*(5+1)-1 downto C_MAX_ARG_AWIDTH*5) <= ap_iarg_5_addr(C_MAX_ARG_AWIDTH+AP_IARG_5_OFFSET-1 downto AP_IARG_5_OFFSET);
    ap_iarg_addr(C_MAX_ARG_AWIDTH*(6+1)-1 downto C_MAX_ARG_AWIDTH*6) <= ap_iarg_6_addr(C_MAX_ARG_AWIDTH+AP_IARG_6_OFFSET-1 downto AP_IARG_6_OFFSET);
    ap_iarg_addr(C_MAX_ARG_AWIDTH*(7+1)-1 downto C_MAX_ARG_AWIDTH*7) <= ap_iarg_7_addr(C_MAX_ARG_AWIDTH+AP_IARG_7_OFFSET-1 downto AP_IARG_7_OFFSET);

    -- Input Argument BRAM interface ce generation
    ap_iarg_ce(0) <= ap_iarg_0_ce;
    ap_iarg_ce(1) <= ap_iarg_1_ce;
    ap_iarg_ce(2) <= ap_iarg_2_ce;
    ap_iarg_ce(3) <= ap_iarg_3_ce;
    ap_iarg_ce(4) <= ap_iarg_4_ce;
    ap_iarg_ce(5) <= ap_iarg_5_ce;
    ap_iarg_ce(6) <= ap_iarg_6_ce;
    ap_iarg_ce(7) <= ap_iarg_7_ce;

    -- Input Argument BRAM interface we generation
    ap_iarg_we(0) <= ap_iarg_0_we(0);
    ap_iarg_we(1) <= ap_iarg_1_we(0);
    ap_iarg_we(2) <= ap_iarg_2_we(0);
    ap_iarg_we(3) <= ap_iarg_3_we(0);
    ap_iarg_we(4) <= ap_iarg_4_we(0);
    ap_iarg_we(5) <= ap_iarg_5_we(0);
    ap_iarg_we(6) <= ap_iarg_6_we(0);
    ap_iarg_we(7) <= ap_iarg_7_we(0);

    -- Input Argument BRAM interface din generation
    ap_iarg_din(C_MAX_ARG_DWIDTH*(0+1)-1 downto C_MAX_ARG_DWIDTH*0) <= ext_lv(ap_iarg_0_din, C_MAX_ARG_DWIDTH);
    ap_iarg_din(C_MAX_ARG_DWIDTH*(1+1)-1 downto C_MAX_ARG_DWIDTH*1) <= ext_lv(ap_iarg_1_din, C_MAX_ARG_DWIDTH);
    ap_iarg_din(C_MAX_ARG_DWIDTH*(2+1)-1 downto C_MAX_ARG_DWIDTH*2) <= ext_lv(ap_iarg_2_din, C_MAX_ARG_DWIDTH);
    ap_iarg_din(C_MAX_ARG_DWIDTH*(3+1)-1 downto C_MAX_ARG_DWIDTH*3) <= ext_lv(ap_iarg_3_din, C_MAX_ARG_DWIDTH);
    ap_iarg_din(C_MAX_ARG_DWIDTH*(4+1)-1 downto C_MAX_ARG_DWIDTH*4) <= ext_lv(ap_iarg_4_din, C_MAX_ARG_DWIDTH);
    ap_iarg_din(C_MAX_ARG_DWIDTH*(5+1)-1 downto C_MAX_ARG_DWIDTH*5) <= ext_lv(ap_iarg_5_din, C_MAX_ARG_DWIDTH);
    ap_iarg_din(C_MAX_ARG_DWIDTH*(6+1)-1 downto C_MAX_ARG_DWIDTH*6) <= ext_lv(ap_iarg_6_din, C_MAX_ARG_DWIDTH);
    ap_iarg_din(C_MAX_ARG_DWIDTH*(7+1)-1 downto C_MAX_ARG_DWIDTH*7) <= ext_lv(ap_iarg_7_din, C_MAX_ARG_DWIDTH);

    -- Input Argument BRAM interface dout generation
    ap_iarg_0_dout <= ap_iarg_dout(C_AP_IARG_0_DWIDTH-1+C_MAX_ARG_DWIDTH*0 downto C_MAX_ARG_DWIDTH*0);
    ap_iarg_1_dout <= ap_iarg_dout(C_AP_IARG_1_DWIDTH-1+C_MAX_ARG_DWIDTH*1 downto C_MAX_ARG_DWIDTH*1);
    ap_iarg_2_dout <= ap_iarg_dout(C_AP_IARG_2_DWIDTH-1+C_MAX_ARG_DWIDTH*2 downto C_MAX_ARG_DWIDTH*2);
    ap_iarg_3_dout <= ap_iarg_dout(C_AP_IARG_3_DWIDTH-1+C_MAX_ARG_DWIDTH*3 downto C_MAX_ARG_DWIDTH*3);
    ap_iarg_4_dout <= ap_iarg_dout(C_AP_IARG_4_DWIDTH-1+C_MAX_ARG_DWIDTH*4 downto C_MAX_ARG_DWIDTH*4);
    ap_iarg_5_dout <= ap_iarg_dout(C_AP_IARG_5_DWIDTH-1+C_MAX_ARG_DWIDTH*5 downto C_MAX_ARG_DWIDTH*5);
    ap_iarg_6_dout <= ap_iarg_dout(C_AP_IARG_6_DWIDTH-1+C_MAX_ARG_DWIDTH*6 downto C_MAX_ARG_DWIDTH*6);
    ap_iarg_7_dout <= ap_iarg_dout(C_AP_IARG_7_DWIDTH-1+C_MAX_ARG_DWIDTH*7 downto C_MAX_ARG_DWIDTH*7);

    
    -- Input Argument FIFO interface dout generation
    ap_fifo_iarg_0_dout <= ap_fifo_iarg_dout(C_AP_IARG_0_DWIDTH-1+C_MAX_ARG_DWIDTH*0 downto C_MAX_ARG_DWIDTH*0);
    ap_fifo_iarg_1_dout <= ap_fifo_iarg_dout(C_AP_IARG_1_DWIDTH-1+C_MAX_ARG_DWIDTH*1 downto C_MAX_ARG_DWIDTH*1);
    ap_fifo_iarg_2_dout <= ap_fifo_iarg_dout(C_AP_IARG_2_DWIDTH-1+C_MAX_ARG_DWIDTH*2 downto C_MAX_ARG_DWIDTH*2);
    ap_fifo_iarg_3_dout <= ap_fifo_iarg_dout(C_AP_IARG_3_DWIDTH-1+C_MAX_ARG_DWIDTH*3 downto C_MAX_ARG_DWIDTH*3);
    ap_fifo_iarg_4_dout <= ap_fifo_iarg_dout(C_AP_IARG_4_DWIDTH-1+C_MAX_ARG_DWIDTH*4 downto C_MAX_ARG_DWIDTH*4);
    ap_fifo_iarg_5_dout <= ap_fifo_iarg_dout(C_AP_IARG_5_DWIDTH-1+C_MAX_ARG_DWIDTH*5 downto C_MAX_ARG_DWIDTH*5);
    ap_fifo_iarg_6_dout <= ap_fifo_iarg_dout(C_AP_IARG_6_DWIDTH-1+C_MAX_ARG_DWIDTH*6 downto C_MAX_ARG_DWIDTH*6);
    ap_fifo_iarg_7_dout <= ap_fifo_iarg_dout(C_AP_IARG_7_DWIDTH-1+C_MAX_ARG_DWIDTH*7 downto C_MAX_ARG_DWIDTH*7);

    -- Input Argument FIFO interface read generation
    ap_fifo_iarg_read(0) <= ap_fifo_iarg_0_read;
    ap_fifo_iarg_read(1) <= ap_fifo_iarg_1_read;
    ap_fifo_iarg_read(2) <= ap_fifo_iarg_2_read;
    ap_fifo_iarg_read(3) <= ap_fifo_iarg_3_read;
    ap_fifo_iarg_read(4) <= ap_fifo_iarg_4_read;
    ap_fifo_iarg_read(5) <= ap_fifo_iarg_5_read;
    ap_fifo_iarg_read(6) <= ap_fifo_iarg_6_read;
    ap_fifo_iarg_read(7) <= ap_fifo_iarg_7_read;

    -- Input Argument FIFO interface empty generation
    ap_fifo_iarg_0_empty_n <= ap_fifo_iarg_empty_n(0);
    ap_fifo_iarg_1_empty_n <= ap_fifo_iarg_empty_n(1);
    ap_fifo_iarg_2_empty_n <= ap_fifo_iarg_empty_n(2);
    ap_fifo_iarg_3_empty_n <= ap_fifo_iarg_empty_n(3);
    ap_fifo_iarg_4_empty_n <= ap_fifo_iarg_empty_n(4);
    ap_fifo_iarg_5_empty_n <= ap_fifo_iarg_empty_n(5);
    ap_fifo_iarg_6_empty_n <= ap_fifo_iarg_empty_n(6);
    ap_fifo_iarg_7_empty_n <= ap_fifo_iarg_empty_n(7);
    
    
    -----------------------------------------------------------------------------------------
    -- AXI4-Stream Slave interface signal Generation
    -- SUPERBUSES BUILDING: MASTER AXI STREAMS (OUTPUT ARGUMENTS):
    -- NOTE FOR SIMULATION: This concatenation inserts a delta delay for clocks signals. In
    -- the case of input signals causality is preserved becouse another delta delay is
    -- inserted during their concatenation. For input signals, there is no problem
    -----------------------------------------------------------------------------------------
    --AXI4-Stream master interface TVALID generation
    m_axis_0_tvalid <= m_axis_tvalid(0);
    m_axis_1_tvalid <= m_axis_tvalid(1);
    m_axis_2_tvalid <= m_axis_tvalid(2);
    m_axis_3_tvalid <= m_axis_tvalid(3);
    m_axis_4_tvalid <= m_axis_tvalid(4);
    m_axis_5_tvalid <= m_axis_tvalid(5);
    m_axis_6_tvalid <= m_axis_tvalid(6);
    m_axis_7_tvalid <= m_axis_tvalid(7);

    --AXI4-Stream master interface TREADY generation
    m_axis_tready(0) <= m_axis_0_tready;
    m_axis_tready(1) <= m_axis_1_tready;
    m_axis_tready(2) <= m_axis_2_tready;
    m_axis_tready(3) <= m_axis_3_tready;
    m_axis_tready(4) <= m_axis_4_tready;
    m_axis_tready(5) <= m_axis_5_tready;
    m_axis_tready(6) <= m_axis_6_tready;
    m_axis_tready(7) <= m_axis_7_tready;

    --AXI4-Stream master interface TDATA generation
    m_axis_0_tdata <= m_axis_tdata(C_M_AXIS_TDATA_WIDTH*(0+1)-1 downto C_M_AXIS_TDATA_WIDTH*0);
    m_axis_1_tdata <= m_axis_tdata(C_M_AXIS_TDATA_WIDTH*(1+1)-1 downto C_M_AXIS_TDATA_WIDTH*1);
    m_axis_2_tdata <= m_axis_tdata(C_M_AXIS_TDATA_WIDTH*(2+1)-1 downto C_M_AXIS_TDATA_WIDTH*2);
    m_axis_3_tdata <= m_axis_tdata(C_M_AXIS_TDATA_WIDTH*(3+1)-1 downto C_M_AXIS_TDATA_WIDTH*3);
    m_axis_4_tdata <= m_axis_tdata(C_M_AXIS_TDATA_WIDTH*(4+1)-1 downto C_M_AXIS_TDATA_WIDTH*4);
    m_axis_5_tdata <= m_axis_tdata(C_M_AXIS_TDATA_WIDTH*(5+1)-1 downto C_M_AXIS_TDATA_WIDTH*5);
    m_axis_6_tdata <= m_axis_tdata(C_M_AXIS_TDATA_WIDTH*(6+1)-1 downto C_M_AXIS_TDATA_WIDTH*6);
    m_axis_7_tdata <= m_axis_tdata(C_M_AXIS_TDATA_WIDTH*(7+1)-1 downto C_M_AXIS_TDATA_WIDTH*7);

    --AXI4-Stream master interface TSTRB generation
    m_axis_0_tstrb <= m_axis_tstrb(C_M_AXIS_TSTRB_WIDTH*(0+1)-1 downto C_M_AXIS_TSTRB_WIDTH*0);
    m_axis_1_tstrb <= m_axis_tstrb(C_M_AXIS_TSTRB_WIDTH*(1+1)-1 downto C_M_AXIS_TSTRB_WIDTH*1);
    m_axis_2_tstrb <= m_axis_tstrb(C_M_AXIS_TSTRB_WIDTH*(2+1)-1 downto C_M_AXIS_TSTRB_WIDTH*2);
    m_axis_3_tstrb <= m_axis_tstrb(C_M_AXIS_TSTRB_WIDTH*(3+1)-1 downto C_M_AXIS_TSTRB_WIDTH*3);
    m_axis_4_tstrb <= m_axis_tstrb(C_M_AXIS_TSTRB_WIDTH*(4+1)-1 downto C_M_AXIS_TSTRB_WIDTH*4);
    m_axis_5_tstrb <= m_axis_tstrb(C_M_AXIS_TSTRB_WIDTH*(5+1)-1 downto C_M_AXIS_TSTRB_WIDTH*5);
    m_axis_6_tstrb <= m_axis_tstrb(C_M_AXIS_TSTRB_WIDTH*(6+1)-1 downto C_M_AXIS_TSTRB_WIDTH*6);
    m_axis_7_tstrb <= m_axis_tstrb(C_M_AXIS_TSTRB_WIDTH*(7+1)-1 downto C_M_AXIS_TSTRB_WIDTH*7);

    --AXI4-Stream master interface TKEEP generation
    m_axis_0_tkeep <= m_axis_tkeep(C_M_AXIS_TKEEP_WIDTH*(0+1)-1 downto C_M_AXIS_TKEEP_WIDTH*0);
    m_axis_1_tkeep <= m_axis_tkeep(C_M_AXIS_TKEEP_WIDTH*(1+1)-1 downto C_M_AXIS_TKEEP_WIDTH*1);
    m_axis_2_tkeep <= m_axis_tkeep(C_M_AXIS_TKEEP_WIDTH*(2+1)-1 downto C_M_AXIS_TKEEP_WIDTH*2);
    m_axis_3_tkeep <= m_axis_tkeep(C_M_AXIS_TKEEP_WIDTH*(3+1)-1 downto C_M_AXIS_TKEEP_WIDTH*3);
    m_axis_4_tkeep <= m_axis_tkeep(C_M_AXIS_TKEEP_WIDTH*(4+1)-1 downto C_M_AXIS_TKEEP_WIDTH*4);
    m_axis_5_tkeep <= m_axis_tkeep(C_M_AXIS_TKEEP_WIDTH*(5+1)-1 downto C_M_AXIS_TKEEP_WIDTH*5);
    m_axis_6_tkeep <= m_axis_tkeep(C_M_AXIS_TKEEP_WIDTH*(6+1)-1 downto C_M_AXIS_TKEEP_WIDTH*6);
    m_axis_7_tkeep <= m_axis_tkeep(C_M_AXIS_TKEEP_WIDTH*(7+1)-1 downto C_M_AXIS_TKEEP_WIDTH*7);

    --AXI4-Stream master interface TLAST generation
    m_axis_0_tlast <= m_axis_tlast(0);
    m_axis_1_tlast <= m_axis_tlast(1);
    m_axis_2_tlast <= m_axis_tlast(2);
    m_axis_3_tlast <= m_axis_tlast(3);
    m_axis_4_tlast <= m_axis_tlast(4);
    m_axis_5_tlast <= m_axis_tlast(5);
    m_axis_6_tlast <= m_axis_tlast(6);
    m_axis_7_tlast <= m_axis_tlast(7);

    --AXI4-Stream master interface TID generation
    m_axis_0_tid <= m_axis_tid(C_M_AXIS_TID_WIDTH*(0+1)-1 downto C_M_AXIS_TID_WIDTH*0);
    m_axis_1_tid <= m_axis_tid(C_M_AXIS_TID_WIDTH*(1+1)-1 downto C_M_AXIS_TID_WIDTH*1);
    m_axis_2_tid <= m_axis_tid(C_M_AXIS_TID_WIDTH*(2+1)-1 downto C_M_AXIS_TID_WIDTH*2);
    m_axis_3_tid <= m_axis_tid(C_M_AXIS_TID_WIDTH*(3+1)-1 downto C_M_AXIS_TID_WIDTH*3);
    m_axis_4_tid <= m_axis_tid(C_M_AXIS_TID_WIDTH*(4+1)-1 downto C_M_AXIS_TID_WIDTH*4);
    m_axis_5_tid <= m_axis_tid(C_M_AXIS_TID_WIDTH*(5+1)-1 downto C_M_AXIS_TID_WIDTH*5);
    m_axis_6_tid <= m_axis_tid(C_M_AXIS_TID_WIDTH*(6+1)-1 downto C_M_AXIS_TID_WIDTH*6);
    m_axis_7_tid <= m_axis_tid(C_M_AXIS_TID_WIDTH*(7+1)-1 downto C_M_AXIS_TID_WIDTH*7);

    --AXI4-Stream master interface TDEST generation
    m_axis_0_tdest <= m_axis_tdest(C_M_AXIS_TDEST_WIDTH*(0+1)-1 downto C_M_AXIS_TDEST_WIDTH*0);
    m_axis_1_tdest <= m_axis_tdest(C_M_AXIS_TDEST_WIDTH*(1+1)-1 downto C_M_AXIS_TDEST_WIDTH*1);
    m_axis_2_tdest <= m_axis_tdest(C_M_AXIS_TDEST_WIDTH*(2+1)-1 downto C_M_AXIS_TDEST_WIDTH*2);
    m_axis_3_tdest <= m_axis_tdest(C_M_AXIS_TDEST_WIDTH*(3+1)-1 downto C_M_AXIS_TDEST_WIDTH*3);
    m_axis_4_tdest <= m_axis_tdest(C_M_AXIS_TDEST_WIDTH*(4+1)-1 downto C_M_AXIS_TDEST_WIDTH*4);
    m_axis_5_tdest <= m_axis_tdest(C_M_AXIS_TDEST_WIDTH*(5+1)-1 downto C_M_AXIS_TDEST_WIDTH*5);
    m_axis_6_tdest <= m_axis_tdest(C_M_AXIS_TDEST_WIDTH*(6+1)-1 downto C_M_AXIS_TDEST_WIDTH*6);
    m_axis_7_tdest <= m_axis_tdest(C_M_AXIS_TDEST_WIDTH*(7+1)-1 downto C_M_AXIS_TDEST_WIDTH*7);

    --AXI4-Stream master interface TKEEP generation
    m_axis_0_tuser <= m_axis_tuser(C_M_AXIS_TUSER_WIDTH*(0+1)-1 downto C_M_AXIS_TUSER_WIDTH*0);
    m_axis_1_tuser <= m_axis_tuser(C_M_AXIS_TUSER_WIDTH*(1+1)-1 downto C_M_AXIS_TUSER_WIDTH*1);
    m_axis_2_tuser <= m_axis_tuser(C_M_AXIS_TUSER_WIDTH*(2+1)-1 downto C_M_AXIS_TUSER_WIDTH*2);
    m_axis_3_tuser <= m_axis_tuser(C_M_AXIS_TUSER_WIDTH*(3+1)-1 downto C_M_AXIS_TUSER_WIDTH*3);
    m_axis_4_tuser <= m_axis_tuser(C_M_AXIS_TUSER_WIDTH*(4+1)-1 downto C_M_AXIS_TUSER_WIDTH*4);
    m_axis_5_tuser <= m_axis_tuser(C_M_AXIS_TUSER_WIDTH*(5+1)-1 downto C_M_AXIS_TUSER_WIDTH*5);
    m_axis_6_tuser <= m_axis_tuser(C_M_AXIS_TUSER_WIDTH*(6+1)-1 downto C_M_AXIS_TUSER_WIDTH*6);
    m_axis_7_tuser <= m_axis_tuser(C_M_AXIS_TUSER_WIDTH*(7+1)-1 downto C_M_AXIS_TUSER_WIDTH*7);

    -----------------------------------------------------------------------------------------
    -- Accelerator Output Argument interface signal Generation
    -- SUPERBUSES BUILDING: AP Output ARGUMENTS:
    -----------------------------------------------------------------------------------------
    -- Output Argument BRAM interface addr generation
    ap_oarg_addr(C_MAX_ARG_AWIDTH*(0+1)-1 downto C_MAX_ARG_AWIDTH*0) <= ap_oarg_0_addr(C_MAX_ARG_AWIDTH+AP_OARG_0_OFFSET-1 downto AP_OARG_0_OFFSET);
    ap_oarg_addr(C_MAX_ARG_AWIDTH*(1+1)-1 downto C_MAX_ARG_AWIDTH*1) <= ap_oarg_1_addr(C_MAX_ARG_AWIDTH+AP_OARG_1_OFFSET-1 downto AP_OARG_1_OFFSET);
    ap_oarg_addr(C_MAX_ARG_AWIDTH*(2+1)-1 downto C_MAX_ARG_AWIDTH*2) <= ap_oarg_2_addr(C_MAX_ARG_AWIDTH+AP_OARG_2_OFFSET-1 downto AP_OARG_2_OFFSET);
    ap_oarg_addr(C_MAX_ARG_AWIDTH*(3+1)-1 downto C_MAX_ARG_AWIDTH*3) <= ap_oarg_3_addr(C_MAX_ARG_AWIDTH+AP_OARG_3_OFFSET-1 downto AP_OARG_3_OFFSET);
    ap_oarg_addr(C_MAX_ARG_AWIDTH*(4+1)-1 downto C_MAX_ARG_AWIDTH*4) <= ap_oarg_4_addr(C_MAX_ARG_AWIDTH+AP_OARG_4_OFFSET-1 downto AP_OARG_4_OFFSET);
    ap_oarg_addr(C_MAX_ARG_AWIDTH*(5+1)-1 downto C_MAX_ARG_AWIDTH*5) <= ap_oarg_5_addr(C_MAX_ARG_AWIDTH+AP_OARG_5_OFFSET-1 downto AP_OARG_5_OFFSET);
    ap_oarg_addr(C_MAX_ARG_AWIDTH*(6+1)-1 downto C_MAX_ARG_AWIDTH*6) <= ap_oarg_6_addr(C_MAX_ARG_AWIDTH+AP_OARG_6_OFFSET-1 downto AP_OARG_6_OFFSET);
    ap_oarg_addr(C_MAX_ARG_AWIDTH*(7+1)-1 downto C_MAX_ARG_AWIDTH*7) <= ap_oarg_7_addr(C_MAX_ARG_AWIDTH+AP_OARG_7_OFFSET-1 downto AP_OARG_7_OFFSET);

    -- Output Argument BRAM interface ce generation
    ap_oarg_ce(0) <= ap_oarg_0_ce;
    ap_oarg_ce(1) <= ap_oarg_1_ce;
    ap_oarg_ce(2) <= ap_oarg_2_ce;
    ap_oarg_ce(3) <= ap_oarg_3_ce;
    ap_oarg_ce(4) <= ap_oarg_4_ce;
    ap_oarg_ce(5) <= ap_oarg_5_ce;
    ap_oarg_ce(6) <= ap_oarg_6_ce;
    ap_oarg_ce(7) <= ap_oarg_7_ce;

    -- Output Argument BRAM interface we generation
    ap_oarg_we(0) <= ap_oarg_0_we(0);
    ap_oarg_we(1) <= ap_oarg_1_we(0);
    ap_oarg_we(2) <= ap_oarg_2_we(0);
    ap_oarg_we(3) <= ap_oarg_3_we(0);
    ap_oarg_we(4) <= ap_oarg_4_we(0);
    ap_oarg_we(5) <= ap_oarg_5_we(0);
    ap_oarg_we(6) <= ap_oarg_6_we(0);
    ap_oarg_we(7) <= ap_oarg_7_we(0);

    -- Output Argument BRAM interface din generation
    ap_oarg_din(C_MAX_ARG_DWIDTH*(0+1)-1 downto C_MAX_ARG_DWIDTH*0) <= ext_lv(ap_oarg_0_din, C_MAX_ARG_DWIDTH);
    ap_oarg_din(C_MAX_ARG_DWIDTH*(1+1)-1 downto C_MAX_ARG_DWIDTH*1) <= ext_lv(ap_oarg_1_din, C_MAX_ARG_DWIDTH);
    ap_oarg_din(C_MAX_ARG_DWIDTH*(2+1)-1 downto C_MAX_ARG_DWIDTH*2) <= ext_lv(ap_oarg_2_din, C_MAX_ARG_DWIDTH);
    ap_oarg_din(C_MAX_ARG_DWIDTH*(3+1)-1 downto C_MAX_ARG_DWIDTH*3) <= ext_lv(ap_oarg_3_din, C_MAX_ARG_DWIDTH);
    ap_oarg_din(C_MAX_ARG_DWIDTH*(4+1)-1 downto C_MAX_ARG_DWIDTH*4) <= ext_lv(ap_oarg_4_din, C_MAX_ARG_DWIDTH);
    ap_oarg_din(C_MAX_ARG_DWIDTH*(5+1)-1 downto C_MAX_ARG_DWIDTH*5) <= ext_lv(ap_oarg_5_din, C_MAX_ARG_DWIDTH);
    ap_oarg_din(C_MAX_ARG_DWIDTH*(6+1)-1 downto C_MAX_ARG_DWIDTH*6) <= ext_lv(ap_oarg_6_din, C_MAX_ARG_DWIDTH);
    ap_oarg_din(C_MAX_ARG_DWIDTH*(7+1)-1 downto C_MAX_ARG_DWIDTH*7) <= ext_lv(ap_oarg_7_din, C_MAX_ARG_DWIDTH);

    -- Output Argument BRAM interface dout generation
    ap_oarg_0_dout <= ap_oarg_dout(C_AP_OARG_0_DWIDTH-1+C_MAX_ARG_DWIDTH*0 downto C_MAX_ARG_DWIDTH*0);
    ap_oarg_1_dout <= ap_oarg_dout(C_AP_OARG_1_DWIDTH-1+C_MAX_ARG_DWIDTH*1 downto C_MAX_ARG_DWIDTH*1);
    ap_oarg_2_dout <= ap_oarg_dout(C_AP_OARG_2_DWIDTH-1+C_MAX_ARG_DWIDTH*2 downto C_MAX_ARG_DWIDTH*2);
    ap_oarg_3_dout <= ap_oarg_dout(C_AP_OARG_3_DWIDTH-1+C_MAX_ARG_DWIDTH*3 downto C_MAX_ARG_DWIDTH*3);
    ap_oarg_4_dout <= ap_oarg_dout(C_AP_OARG_4_DWIDTH-1+C_MAX_ARG_DWIDTH*4 downto C_MAX_ARG_DWIDTH*4);
    ap_oarg_5_dout <= ap_oarg_dout(C_AP_OARG_5_DWIDTH-1+C_MAX_ARG_DWIDTH*5 downto C_MAX_ARG_DWIDTH*5);
    ap_oarg_6_dout <= ap_oarg_dout(C_AP_OARG_6_DWIDTH-1+C_MAX_ARG_DWIDTH*6 downto C_MAX_ARG_DWIDTH*6);
    ap_oarg_7_dout <= ap_oarg_dout(C_AP_OARG_7_DWIDTH-1+C_MAX_ARG_DWIDTH*7 downto C_MAX_ARG_DWIDTH*7);


    -- Output Argument FIFO interface din generation
    ap_fifo_oarg_din(C_AP_OARG_0_DWIDTH-1+C_MAX_ARG_DWIDTH*0 downto C_MAX_ARG_DWIDTH*0) <= ap_fifo_oarg_0_din;
    ap_fifo_oarg_din(C_AP_OARG_1_DWIDTH-1+C_MAX_ARG_DWIDTH*1 downto C_MAX_ARG_DWIDTH*1) <= ap_fifo_oarg_1_din;
    ap_fifo_oarg_din(C_AP_OARG_2_DWIDTH-1+C_MAX_ARG_DWIDTH*2 downto C_MAX_ARG_DWIDTH*2) <= ap_fifo_oarg_2_din;
    ap_fifo_oarg_din(C_AP_OARG_3_DWIDTH-1+C_MAX_ARG_DWIDTH*3 downto C_MAX_ARG_DWIDTH*3) <= ap_fifo_oarg_3_din;
    ap_fifo_oarg_din(C_AP_OARG_4_DWIDTH-1+C_MAX_ARG_DWIDTH*4 downto C_MAX_ARG_DWIDTH*4) <= ap_fifo_oarg_4_din;
    ap_fifo_oarg_din(C_AP_OARG_5_DWIDTH-1+C_MAX_ARG_DWIDTH*5 downto C_MAX_ARG_DWIDTH*5) <= ap_fifo_oarg_5_din;
    ap_fifo_oarg_din(C_AP_OARG_6_DWIDTH-1+C_MAX_ARG_DWIDTH*6 downto C_MAX_ARG_DWIDTH*6) <= ap_fifo_oarg_6_din;
    ap_fifo_oarg_din(C_AP_OARG_7_DWIDTH-1+C_MAX_ARG_DWIDTH*7 downto C_MAX_ARG_DWIDTH*7) <= ap_fifo_oarg_7_din;

    -- Assining unused bits in the vector to default value to reduce synthesis warnings.
    ap_fifo_oarg_din(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*0 downto C_AP_OARG_0_DWIDTH+C_MAX_ARG_DWIDTH*0) <= (others => '0');
    ap_fifo_oarg_din(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*1 downto C_AP_OARG_1_DWIDTH+C_MAX_ARG_DWIDTH*1) <= (others => '0');
    ap_fifo_oarg_din(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*2 downto C_AP_OARG_2_DWIDTH+C_MAX_ARG_DWIDTH*2) <= (others => '0');
    ap_fifo_oarg_din(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*3 downto C_AP_OARG_3_DWIDTH+C_MAX_ARG_DWIDTH*3) <= (others => '0');
    ap_fifo_oarg_din(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*4 downto C_AP_OARG_4_DWIDTH+C_MAX_ARG_DWIDTH*4) <= (others => '0');
    ap_fifo_oarg_din(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*5 downto C_AP_OARG_5_DWIDTH+C_MAX_ARG_DWIDTH*5) <= (others => '0');
    ap_fifo_oarg_din(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*6 downto C_AP_OARG_6_DWIDTH+C_MAX_ARG_DWIDTH*6) <= (others => '0');
    ap_fifo_oarg_din(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*7 downto C_AP_OARG_7_DWIDTH+C_MAX_ARG_DWIDTH*7) <= (others => '0');


    -- Output Argument FIFO interface fifo_write generation
    ap_fifo_oarg_write(0) <= ap_fifo_oarg_0_write;
    ap_fifo_oarg_write(1) <= ap_fifo_oarg_1_write;
    ap_fifo_oarg_write(2) <= ap_fifo_oarg_2_write;
    ap_fifo_oarg_write(3) <= ap_fifo_oarg_3_write;
    ap_fifo_oarg_write(4) <= ap_fifo_oarg_4_write;
    ap_fifo_oarg_write(5) <= ap_fifo_oarg_5_write;
    ap_fifo_oarg_write(6) <= ap_fifo_oarg_6_write;
    ap_fifo_oarg_write(7) <= ap_fifo_oarg_7_write;

    -- Output Argument FIFO interface fifo_full generation
    ap_fifo_oarg_0_full_n <= ap_fifo_oarg_full_n(0);
    ap_fifo_oarg_1_full_n <= ap_fifo_oarg_full_n(1);
    ap_fifo_oarg_2_full_n <= ap_fifo_oarg_full_n(2);
    ap_fifo_oarg_3_full_n <= ap_fifo_oarg_full_n(3);
    ap_fifo_oarg_4_full_n <= ap_fifo_oarg_full_n(4);
    ap_fifo_oarg_5_full_n <= ap_fifo_oarg_full_n(5);
    ap_fifo_oarg_6_full_n <= ap_fifo_oarg_full_n(6);
    ap_fifo_oarg_7_full_n <= ap_fifo_oarg_full_n(7);

  --------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------
    -- XD_ADAPTER_CORE_I : Adapter core logic
    -----------------------------------------------------------------------------------------
    XD_ADAPTER_CORE_I : entity axis_accelerator_adapter_v2_1_6.axis_accelerator_adapter_core
    generic map (
      -- System generics:
      C_FAMILY                => C_FAMILY,
      C_BRAM_TYPE             => BRAM_PRIMITIVE_TYPE,
      C_S_AXI_ADDR_WIDTH      => C_S_AXI_ADDR_WIDTH,
      C_S_AXI_DATA_WIDTH      => C_S_AXI_DATA_WIDTH,
      C_PRMRY_IS_ACLK_ASYNC   => C_PRMRY_IS_ACLK_ASYNC,
      C_MTBF_STAGES           => C_MTBF_STAGES,
      --
      
      C_AP_ADAPTER_ID         => C_AP_ADAPTER_ID,
      C_MAX_SCALAR_DWIDTH     => C_MAX_SCALAR_DWIDTH,
      C_MAX_ARG_DWIDTH        => C_MAX_ARG_DWIDTH,
      C_MAX_ARG_AWIDTH        => C_MAX_ARG_AWIDTH,
      C_MAX_ARG_N_DIM         => C_MAX_ARG_N_DIM,
      C_MAX_MB_DEPTH          => C_MAX_MB_DEPTH,
      C_MAX_N_IARGS           => C_MAX_N_IARGS,
      C_MAX_N_OARGS           => C_MAX_N_OARGS,
      C_MAX_N_ISCALARS        => C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS,
      C_MAX_N_OSCALARS        => C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS,
      C_MAX_N_IOSCALARS       => C_MAX_N_IOSCALARS,
      --
      C_N_INPUT_ARGS          => C_N_INPUT_ARGS,
      C_N_OUTPUT_ARGS         => C_N_OUTPUT_ARGS,
      --
      C_S_AXIS_TDATA_WIDTH    => C_S_AXIS_TDATA_WIDTH,
      C_S_AXIS_TUSER_WIDTH    => C_S_AXIS_TUSER_WIDTH,
      C_S_AXIS_TID_WIDTH      => C_S_AXIS_TID_WIDTH,
      C_S_AXIS_TDEST_WIDTH    => C_S_AXIS_TDEST_WIDTH,
      --
      C_AP_IARG_TYPE          => C_AP_IARG_TYPE,
      C_AP_IARG_DWIDTH        => C_AP_IARG_DWIDTH,
      C_AP_IARG_MB_DEPTH      => C_AP_IARG_MB_DEPTH,
      --
      C_AP_IARG_WIDTH         => C_AP_IARG_WIDTH,
      C_AP_IARG_N_DIM         => C_AP_IARG_N_DIM,
      C_AP_IARG_DIM_1         => C_AP_IARG_DIM_1,
      C_AP_IARG_DIM_2         => C_AP_IARG_DIM_2,
      C_AP_IARG_FORMAT_TYPE   => C_AP_IARG_FORMAT_TYPE,
      C_AP_IARG_FORMAT_FACTOR => C_AP_IARG_FORMAT_FACTOR,
      C_AP_IARG_FORMAT_DIM    => C_AP_IARG_FORMAT_DIM,
      --
      C_M_AXIS_TDATA_WIDTH    => C_M_AXIS_TDATA_WIDTH,
      C_M_AXIS_TUSER_WIDTH    => C_M_AXIS_TUSER_WIDTH,
      C_M_AXIS_TID_WIDTH      => C_M_AXIS_TID_WIDTH,
      C_M_AXIS_TDEST_WIDTH    => C_M_AXIS_TDEST_WIDTH,
      --
      C_AP_OARG_TYPE          => C_AP_OARG_TYPE,
      C_AP_OARG_DWIDTH        => C_AP_OARG_DWIDTH,
      C_AP_OARG_MB_DEPTH      => C_AP_OARG_MB_DEPTH,
      --
      C_AP_OARG_WIDTH         => C_AP_OARG_WIDTH,
      C_AP_OARG_N_DIM         => C_AP_OARG_N_DIM,
      C_AP_OARG_DIM           => C_AP_OARG_DIM,
      C_AP_OARG_DIM_1         => C_AP_OARG_DIM_1,
      C_AP_OARG_DIM_2         => C_AP_OARG_DIM_2,
      C_AP_OARG_FORMAT_TYPE   => C_AP_OARG_FORMAT_TYPE,
      C_AP_OARG_FORMAT_FACTOR => C_AP_OARG_FORMAT_FACTOR,
      C_AP_OARG_FORMAT_DIM    => C_AP_OARG_FORMAT_DIM,
      --
      C_N_INOUT_SCALARS       => C_N_INOUT_SCALARS,
      C_N_INPUT_SCALARS       => C_N_INPUT_SCALARS,
      C_INPUT_SCALAR_DWIDTH   => C_INPUT_SCALAR_DWIDTH,
      C_AP_ISCALAR_DOUT_WIDTH => C_AP_ISCALAR_DOUT_WIDTH,
      C_INPUT_SCALAR_MODE     => C_INPUT_SCALAR_MODE,      
      --
      C_OUTPUT_SCALAR_MODE    => C_OUTPUT_SCALAR_MODE,
      C_N_OUTPUT_SCALARS      => C_N_OUTPUT_SCALARS,
      C_OUTPUT_SCALAR_DWIDTH  => C_OUTPUT_SCALAR_DWIDTH,
      C_AP_OSCALAR_DIN_WIDTH  => C_AP_OSCALAR_DIN_WIDTH,
      C_AP_ISCALAR_IO_DOUT_WIDTH  => C_AP_ISCALAR_IO_DOUT_WIDTH,
      C_AP_OSCALAR_IO_DIN_WIDTH  => C_AP_OSCALAR_IO_DIN_WIDTH)
    port map (
      -- SLAVE AXI LITE:
      s_axi_aclk           => s_axi_aclk,
      s_axi_aresetn        => s_axi_aresetn,
      s_axi_awaddr         => s_axi_awaddr,
      s_axi_awvalid        => s_axi_awvalid,
      s_axi_awready        => s_axi_awready,
      s_axi_wdata          => s_axi_wdata,
      s_axi_wstrb          => s_axi_wstrb,
      s_axi_wvalid         => s_axi_wvalid,
      s_axi_wready         => s_axi_wready,
      s_axi_bresp          => s_axi_bresp,
      s_axi_bvalid         => s_axi_bvalid,
      s_axi_bready         => s_axi_bready,
      s_axi_araddr         => s_axi_araddr,
      s_axi_arvalid        => s_axi_arvalid,
      s_axi_arready        => s_axi_arready,
      s_axi_rdata          => s_axi_rdata,
      s_axi_rresp          => s_axi_rresp,
      s_axi_rvalid         => s_axi_rvalid,
      s_axi_rready         => s_axi_rready,
      --- Slave AXI streams (input arguments)
      s_axis_aclk          => s_axis_aclk_i,
      s_axis_aresetn       => s_axis_aresetn_i,
      s_axis_tvalid        => s_axis_tvalid,
      s_axis_tready        => s_axis_tready,
      s_axis_tdata         => s_axis_tdata,
      s_axis_tstrb         => s_axis_tstrb,
      s_axis_tkeep         => s_axis_tkeep,
      s_axis_tlast         => s_axis_tlast,
      s_axis_tid           => s_axis_tid,
      s_axis_tdest         => s_axis_tdest,
      s_axis_tuser         => s_axis_tuser,
      --- AP input arguments
      ap_iarg_addr         => ap_iarg_addr,
      ap_iarg_ce           => ap_iarg_ce,
      ap_iarg_we           => ap_iarg_we,
      ap_iarg_din          => ap_iarg_din,
      ap_iarg_dout         => ap_iarg_dout,
      ---
      ap_fifo_iarg_dout    => ap_fifo_iarg_dout,
      ap_fifo_iarg_read    => ap_fifo_iarg_read,
      ap_fifo_iarg_empty_n => ap_fifo_iarg_empty_n,
      --- Master AXI streams (output arguments)
      m_axis_aclk          => m_axis_aclk_i,
      m_axis_aresetn       => m_axis_aresetn_i,
      m_axis_tvalid        => m_axis_tvalid,
      m_axis_tready        => m_axis_tready,
      m_axis_tdata         => m_axis_tdata,
      m_axis_tstrb         => m_axis_tstrb,
      m_axis_tkeep         => m_axis_tkeep,
      m_axis_tlast         => m_axis_tlast,
      m_axis_tid           => m_axis_tid,
      m_axis_tdest         => m_axis_tdest,
      m_axis_tuser         => m_axis_tuser,
      --- AP output arguments
      ap_oarg_addr         => ap_oarg_addr,
      ap_oarg_ce           => ap_oarg_ce,
      ap_oarg_we           => ap_oarg_we,
      ap_oarg_din          => ap_oarg_din,
      ap_oarg_dout         => ap_oarg_dout,
      ---
      ap_fifo_oarg_din     => ap_fifo_oarg_din,
      ap_fifo_oarg_write   => ap_fifo_oarg_write,
      ap_fifo_oarg_full_n  => ap_fifo_oarg_full_n,
      ---
      ap_clk               => aclk,
      ap_rst               => aresetn,
      -- AP control handshaking:
      ap_start             => ap_start,
      ap_ready             => ap_ready,
      ap_done              => ap_done,
      ap_continue          => ap_continue,
      ap_idle              => ap_idle,
      ---
      ap_iscalar_dout      => ap_iscalar_dout_i,
      ap_oscalar_din       => ap_oscalar_din_i,
      ap_oscalar_vld       => ap_oscalar_vld_i,
      ap_oscalar_ack       => ap_oscalar_ack_i,
      ap_iscalar_vld       => ap_iscalar_vld_i,
      ap_iscalar_ack       => ap_iscalar_ack_i,
      ---
      interrupt            => interrupt);


end rtl;

