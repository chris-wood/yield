-- (c) Copyright 1995-2016 Xilinx, Inc. All rights reserved.
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
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:axis_accelerator_adapter:2.1
-- IP Revision: 6

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY axis_accelerator_adapter_v2_1_6;
USE axis_accelerator_adapter_v2_1_6.axis_accelerator_adapter;

ENTITY zc702_get_0_if_0 IS
  PORT (
    s_axi_aclk : IN STD_LOGIC;
    s_axi_aresetn : IN STD_LOGIC;
    s_axi_awaddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    s_axi_awvalid : IN STD_LOGIC;
    s_axi_awready : OUT STD_LOGIC;
    s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    s_axi_wvalid : IN STD_LOGIC;
    s_axi_wready : OUT STD_LOGIC;
    s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_bvalid : OUT STD_LOGIC;
    s_axi_bready : IN STD_LOGIC;
    s_axi_araddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
    s_axi_arvalid : IN STD_LOGIC;
    s_axi_arready : OUT STD_LOGIC;
    s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    s_axi_rvalid : OUT STD_LOGIC;
    s_axi_rready : IN STD_LOGIC;
    aclk : IN STD_LOGIC;
    aresetn : OUT STD_LOGIC;
    ap_start : OUT STD_LOGIC;
    ap_ready : IN STD_LOGIC;
    ap_done : IN STD_LOGIC;
    ap_continue : OUT STD_LOGIC;
    ap_idle : IN STD_LOGIC;
    ap_iscalar_0_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    ap_iscalar_1_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    ap_oscalar_0_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ap_oscalar_1_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    ap_oscalar_1_vld : IN STD_LOGIC;
    interrupt : OUT STD_LOGIC
  );
END zc702_get_0_if_0;

ARCHITECTURE zc702_get_0_if_0_arch OF zc702_get_0_if_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : string;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF zc702_get_0_if_0_arch: ARCHITECTURE IS "yes";

  COMPONENT axis_accelerator_adapter IS
    GENERIC (
      C_FAMILY : STRING;
      C_S_AXI_ADDR_WIDTH : INTEGER;
      C_S_AXI_DATA_WIDTH : INTEGER;
      C_AP_ADAPTER_ID : INTEGER;
      C_N_INPUT_ARGS : INTEGER;
      C_N_OUTPUT_ARGS : INTEGER;
      C_S_AXIS_TDATA_WIDTH : INTEGER;
      C_S_AXIS_TUSER_WIDTH : INTEGER;
      C_S_AXIS_TID_WIDTH : INTEGER;
      C_S_AXIS_TDEST_WIDTH : INTEGER;
      C_AP_IARG_TYPE : STD_LOGIC_VECTOR;
      C_AP_IARG_MB_DEPTH : STD_LOGIC_VECTOR;
      C_AP_IARG_WIDTH : STD_LOGIC_VECTOR;
      C_AP_IARG_N_DIM : STD_LOGIC_VECTOR;
      C_AP_IARG_DIM_1 : STD_LOGIC_VECTOR;
      C_AP_IARG_DIM_2 : STD_LOGIC_VECTOR;
      C_AP_IARG_FORMAT_TYPE : STD_LOGIC_VECTOR;
      C_AP_IARG_FORMAT_FACTOR : STD_LOGIC_VECTOR;
      C_AP_IARG_FORMAT_DIM : STD_LOGIC_VECTOR;
      C_AP_IARG_0_DWIDTH : INTEGER;
      C_AP_IARG_1_DWIDTH : INTEGER;
      C_AP_IARG_2_DWIDTH : INTEGER;
      C_AP_IARG_3_DWIDTH : INTEGER;
      C_AP_IARG_4_DWIDTH : INTEGER;
      C_AP_IARG_5_DWIDTH : INTEGER;
      C_AP_IARG_6_DWIDTH : INTEGER;
      C_AP_IARG_7_DWIDTH : INTEGER;
      C_M_AXIS_TDATA_WIDTH : INTEGER;
      C_M_AXIS_TUSER_WIDTH : INTEGER;
      C_M_AXIS_TID_WIDTH : INTEGER;
      C_M_AXIS_TDEST_WIDTH : INTEGER;
      C_AP_OARG_TYPE : STD_LOGIC_VECTOR;
      C_AP_OARG_MB_DEPTH : STD_LOGIC_VECTOR;
      C_AP_OARG_WIDTH : STD_LOGIC_VECTOR;
      C_AP_OARG_N_DIM : STD_LOGIC_VECTOR;
      C_AP_OARG_DIM : STD_LOGIC_VECTOR;
      C_AP_OARG_DIM_1 : STD_LOGIC_VECTOR;
      C_AP_OARG_DIM_2 : STD_LOGIC_VECTOR;
      C_AP_OARG_FORMAT_TYPE : STD_LOGIC_VECTOR;
      C_AP_OARG_FORMAT_FACTOR : STD_LOGIC_VECTOR;
      C_AP_OARG_FORMAT_DIM : STD_LOGIC_VECTOR;
      C_AP_OARG_0_DWIDTH : INTEGER;
      C_AP_OARG_1_DWIDTH : INTEGER;
      C_AP_OARG_2_DWIDTH : INTEGER;
      C_AP_OARG_3_DWIDTH : INTEGER;
      C_AP_OARG_4_DWIDTH : INTEGER;
      C_AP_OARG_5_DWIDTH : INTEGER;
      C_AP_OARG_6_DWIDTH : INTEGER;
      C_AP_OARG_7_DWIDTH : INTEGER;
      C_N_INOUT_SCALARS : INTEGER;
      C_N_INPUT_SCALARS : INTEGER;
      C_INPUT_SCALAR_DWIDTH : STD_LOGIC_VECTOR;
      C_INPUT_SCALAR_MODE : STD_LOGIC_VECTOR;
      C_OUTPUT_SCALAR_MODE : STD_LOGIC_VECTOR;
      C_AP_ISCALAR_DOUT_WIDTH : INTEGER;
      C_AP_ISCALAR_IO_DOUT_WIDTH : INTEGER;
      C_INPUT_SCALAR_0_WIDTH : INTEGER;
      C_INPUT_SCALAR_1_WIDTH : INTEGER;
      C_INPUT_SCALAR_2_WIDTH : INTEGER;
      C_INPUT_SCALAR_3_WIDTH : INTEGER;
      C_INPUT_SCALAR_4_WIDTH : INTEGER;
      C_INPUT_SCALAR_5_WIDTH : INTEGER;
      C_INPUT_SCALAR_6_WIDTH : INTEGER;
      C_INPUT_SCALAR_7_WIDTH : INTEGER;
      C_INPUT_SCALAR_8_WIDTH : INTEGER;
      C_INPUT_SCALAR_9_WIDTH : INTEGER;
      C_INPUT_SCALAR_10_WIDTH : INTEGER;
      C_INPUT_SCALAR_11_WIDTH : INTEGER;
      C_INPUT_SCALAR_12_WIDTH : INTEGER;
      C_INPUT_SCALAR_13_WIDTH : INTEGER;
      C_INPUT_SCALAR_14_WIDTH : INTEGER;
      C_INPUT_SCALAR_15_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_0_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_1_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_2_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_3_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_4_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_5_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_6_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_7_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_8_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_9_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_10_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_11_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_12_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_13_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_14_WIDTH : INTEGER;
      C_OUTPUT_SCALAR_15_WIDTH : INTEGER;
      C_N_OUTPUT_SCALARS : INTEGER;
      C_OUTPUT_SCALAR_DWIDTH : STD_LOGIC_VECTOR;
      C_AP_OSCALAR_DIN_WIDTH : INTEGER;
      C_AP_OSCALAR_IO_DIN_WIDTH : INTEGER;
      C_ENABLE_STREAM_CLK : INTEGER;
      C_PRMRY_IS_ACLK_ASYNC : INTEGER;
      C_S_AXIS_HAS_TSTRB : INTEGER;
      C_S_AXIS_HAS_TKEEP : INTEGER;
      C_NONE : INTEGER
    );
    PORT (
      s_axi_aclk : IN STD_LOGIC;
      s_axi_aresetn : IN STD_LOGIC;
      s_axi_awaddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
      s_axi_awvalid : IN STD_LOGIC;
      s_axi_awready : OUT STD_LOGIC;
      s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axi_wvalid : IN STD_LOGIC;
      s_axi_wready : OUT STD_LOGIC;
      s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_bvalid : OUT STD_LOGIC;
      s_axi_bready : IN STD_LOGIC;
      s_axi_araddr : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
      s_axi_arvalid : IN STD_LOGIC;
      s_axi_arready : OUT STD_LOGIC;
      s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      s_axi_rvalid : OUT STD_LOGIC;
      s_axi_rready : IN STD_LOGIC;
      s_axis_aclk : IN STD_LOGIC;
      s_axis_aresetn : IN STD_LOGIC;
      s_axis_0_aclk : IN STD_LOGIC;
      s_axis_0_aresetn : IN STD_LOGIC;
      s_axis_0_tvalid : IN STD_LOGIC;
      s_axis_0_tready : OUT STD_LOGIC;
      s_axis_0_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_0_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_0_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_0_tlast : IN STD_LOGIC;
      s_axis_0_tid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_0_tdest : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_0_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_1_aclk : IN STD_LOGIC;
      s_axis_1_aresetn : IN STD_LOGIC;
      s_axis_1_tvalid : IN STD_LOGIC;
      s_axis_1_tready : OUT STD_LOGIC;
      s_axis_1_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_1_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_1_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_1_tlast : IN STD_LOGIC;
      s_axis_1_tid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_1_tdest : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_1_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_2_aclk : IN STD_LOGIC;
      s_axis_2_aresetn : IN STD_LOGIC;
      s_axis_2_tvalid : IN STD_LOGIC;
      s_axis_2_tready : OUT STD_LOGIC;
      s_axis_2_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_2_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_2_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_2_tlast : IN STD_LOGIC;
      s_axis_2_tid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_2_tdest : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_2_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_3_aclk : IN STD_LOGIC;
      s_axis_3_aresetn : IN STD_LOGIC;
      s_axis_3_tvalid : IN STD_LOGIC;
      s_axis_3_tready : OUT STD_LOGIC;
      s_axis_3_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_3_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_3_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_3_tlast : IN STD_LOGIC;
      s_axis_3_tid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_3_tdest : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_3_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_4_aclk : IN STD_LOGIC;
      s_axis_4_aresetn : IN STD_LOGIC;
      s_axis_4_tvalid : IN STD_LOGIC;
      s_axis_4_tready : OUT STD_LOGIC;
      s_axis_4_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_4_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_4_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_4_tlast : IN STD_LOGIC;
      s_axis_4_tid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_4_tdest : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_4_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_5_aclk : IN STD_LOGIC;
      s_axis_5_aresetn : IN STD_LOGIC;
      s_axis_5_tvalid : IN STD_LOGIC;
      s_axis_5_tready : OUT STD_LOGIC;
      s_axis_5_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_5_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_5_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_5_tlast : IN STD_LOGIC;
      s_axis_5_tid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_5_tdest : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_5_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_6_aclk : IN STD_LOGIC;
      s_axis_6_aresetn : IN STD_LOGIC;
      s_axis_6_tvalid : IN STD_LOGIC;
      s_axis_6_tready : OUT STD_LOGIC;
      s_axis_6_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_6_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_6_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_6_tlast : IN STD_LOGIC;
      s_axis_6_tid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_6_tdest : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_6_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_7_aclk : IN STD_LOGIC;
      s_axis_7_aresetn : IN STD_LOGIC;
      s_axis_7_tvalid : IN STD_LOGIC;
      s_axis_7_tready : OUT STD_LOGIC;
      s_axis_7_tdata : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      s_axis_7_tstrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_7_tkeep : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      s_axis_7_tlast : IN STD_LOGIC;
      s_axis_7_tid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_7_tdest : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      s_axis_7_tuser : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      ap_iarg_0_clk : IN STD_LOGIC;
      ap_iarg_0_rst : IN STD_LOGIC;
      ap_iarg_0_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_0_ce : IN STD_LOGIC;
      ap_iarg_0_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_iarg_0_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_0_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_1_clk : IN STD_LOGIC;
      ap_iarg_1_rst : IN STD_LOGIC;
      ap_iarg_1_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_1_ce : IN STD_LOGIC;
      ap_iarg_1_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_iarg_1_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_1_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_2_clk : IN STD_LOGIC;
      ap_iarg_2_rst : IN STD_LOGIC;
      ap_iarg_2_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_2_ce : IN STD_LOGIC;
      ap_iarg_2_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_iarg_2_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_2_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_3_clk : IN STD_LOGIC;
      ap_iarg_3_rst : IN STD_LOGIC;
      ap_iarg_3_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_3_ce : IN STD_LOGIC;
      ap_iarg_3_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_iarg_3_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_3_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_4_clk : IN STD_LOGIC;
      ap_iarg_4_rst : IN STD_LOGIC;
      ap_iarg_4_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_4_ce : IN STD_LOGIC;
      ap_iarg_4_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_iarg_4_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_4_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_5_clk : IN STD_LOGIC;
      ap_iarg_5_rst : IN STD_LOGIC;
      ap_iarg_5_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_5_ce : IN STD_LOGIC;
      ap_iarg_5_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_iarg_5_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_5_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_6_clk : IN STD_LOGIC;
      ap_iarg_6_rst : IN STD_LOGIC;
      ap_iarg_6_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_6_ce : IN STD_LOGIC;
      ap_iarg_6_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_iarg_6_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_6_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_7_clk : IN STD_LOGIC;
      ap_iarg_7_rst : IN STD_LOGIC;
      ap_iarg_7_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_7_ce : IN STD_LOGIC;
      ap_iarg_7_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_iarg_7_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iarg_7_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_0_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_0_read : IN STD_LOGIC;
      ap_fifo_iarg_0_empty_n : OUT STD_LOGIC;
      ap_fifo_iarg_1_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_1_read : IN STD_LOGIC;
      ap_fifo_iarg_1_empty_n : OUT STD_LOGIC;
      ap_fifo_iarg_2_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_2_read : IN STD_LOGIC;
      ap_fifo_iarg_2_empty_n : OUT STD_LOGIC;
      ap_fifo_iarg_3_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_3_read : IN STD_LOGIC;
      ap_fifo_iarg_3_empty_n : OUT STD_LOGIC;
      ap_fifo_iarg_4_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_4_read : IN STD_LOGIC;
      ap_fifo_iarg_4_empty_n : OUT STD_LOGIC;
      ap_fifo_iarg_5_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_5_read : IN STD_LOGIC;
      ap_fifo_iarg_5_empty_n : OUT STD_LOGIC;
      ap_fifo_iarg_6_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_6_read : IN STD_LOGIC;
      ap_fifo_iarg_6_empty_n : OUT STD_LOGIC;
      ap_fifo_iarg_7_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_iarg_7_read : IN STD_LOGIC;
      ap_fifo_iarg_7_empty_n : OUT STD_LOGIC;
      m_axis_aclk : IN STD_LOGIC;
      m_axis_aresetn : IN STD_LOGIC;
      m_axis_0_aclk : IN STD_LOGIC;
      m_axis_0_aresetn : IN STD_LOGIC;
      m_axis_0_tvalid : OUT STD_LOGIC;
      m_axis_0_tready : IN STD_LOGIC;
      m_axis_0_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_0_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_0_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_0_tlast : OUT STD_LOGIC;
      m_axis_0_tid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_0_tdest : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_0_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_1_aclk : IN STD_LOGIC;
      m_axis_1_aresetn : IN STD_LOGIC;
      m_axis_1_tvalid : OUT STD_LOGIC;
      m_axis_1_tready : IN STD_LOGIC;
      m_axis_1_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_1_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_1_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_1_tlast : OUT STD_LOGIC;
      m_axis_1_tid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_1_tdest : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_1_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_2_aclk : IN STD_LOGIC;
      m_axis_2_aresetn : IN STD_LOGIC;
      m_axis_2_tvalid : OUT STD_LOGIC;
      m_axis_2_tready : IN STD_LOGIC;
      m_axis_2_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_2_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_2_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_2_tlast : OUT STD_LOGIC;
      m_axis_2_tid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_2_tdest : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_2_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_3_aclk : IN STD_LOGIC;
      m_axis_3_aresetn : IN STD_LOGIC;
      m_axis_3_tvalid : OUT STD_LOGIC;
      m_axis_3_tready : IN STD_LOGIC;
      m_axis_3_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_3_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_3_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_3_tlast : OUT STD_LOGIC;
      m_axis_3_tid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_3_tdest : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_3_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_4_aclk : IN STD_LOGIC;
      m_axis_4_aresetn : IN STD_LOGIC;
      m_axis_4_tvalid : OUT STD_LOGIC;
      m_axis_4_tready : IN STD_LOGIC;
      m_axis_4_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_4_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_4_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_4_tlast : OUT STD_LOGIC;
      m_axis_4_tid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_4_tdest : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_4_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_5_aclk : IN STD_LOGIC;
      m_axis_5_aresetn : IN STD_LOGIC;
      m_axis_5_tvalid : OUT STD_LOGIC;
      m_axis_5_tready : IN STD_LOGIC;
      m_axis_5_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_5_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_5_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_5_tlast : OUT STD_LOGIC;
      m_axis_5_tid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_5_tdest : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_5_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_6_aclk : IN STD_LOGIC;
      m_axis_6_aresetn : IN STD_LOGIC;
      m_axis_6_tvalid : OUT STD_LOGIC;
      m_axis_6_tready : IN STD_LOGIC;
      m_axis_6_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_6_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_6_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_6_tlast : OUT STD_LOGIC;
      m_axis_6_tid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_6_tdest : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_6_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_7_aclk : IN STD_LOGIC;
      m_axis_7_aresetn : IN STD_LOGIC;
      m_axis_7_tvalid : OUT STD_LOGIC;
      m_axis_7_tready : IN STD_LOGIC;
      m_axis_7_tdata : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      m_axis_7_tstrb : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_7_tkeep : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      m_axis_7_tlast : OUT STD_LOGIC;
      m_axis_7_tid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_7_tdest : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      m_axis_7_tuser : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      ap_oarg_0_clk : IN STD_LOGIC;
      ap_oarg_0_rst : IN STD_LOGIC;
      ap_oarg_0_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_0_ce : IN STD_LOGIC;
      ap_oarg_0_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_oarg_0_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_0_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_1_clk : IN STD_LOGIC;
      ap_oarg_1_rst : IN STD_LOGIC;
      ap_oarg_1_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_1_ce : IN STD_LOGIC;
      ap_oarg_1_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_oarg_1_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_1_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_2_clk : IN STD_LOGIC;
      ap_oarg_2_rst : IN STD_LOGIC;
      ap_oarg_2_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_2_ce : IN STD_LOGIC;
      ap_oarg_2_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_oarg_2_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_2_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_3_clk : IN STD_LOGIC;
      ap_oarg_3_rst : IN STD_LOGIC;
      ap_oarg_3_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_3_ce : IN STD_LOGIC;
      ap_oarg_3_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_oarg_3_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_3_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_4_clk : IN STD_LOGIC;
      ap_oarg_4_rst : IN STD_LOGIC;
      ap_oarg_4_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_4_ce : IN STD_LOGIC;
      ap_oarg_4_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_oarg_4_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_4_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_5_clk : IN STD_LOGIC;
      ap_oarg_5_rst : IN STD_LOGIC;
      ap_oarg_5_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_5_ce : IN STD_LOGIC;
      ap_oarg_5_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_oarg_5_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_5_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_6_clk : IN STD_LOGIC;
      ap_oarg_6_rst : IN STD_LOGIC;
      ap_oarg_6_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_6_ce : IN STD_LOGIC;
      ap_oarg_6_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_oarg_6_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_6_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_7_clk : IN STD_LOGIC;
      ap_oarg_7_rst : IN STD_LOGIC;
      ap_oarg_7_addr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_7_ce : IN STD_LOGIC;
      ap_oarg_7_we : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      ap_oarg_7_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oarg_7_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_0_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_0_write : IN STD_LOGIC;
      ap_fifo_oarg_0_full_n : OUT STD_LOGIC;
      ap_fifo_oarg_1_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_1_write : IN STD_LOGIC;
      ap_fifo_oarg_1_full_n : OUT STD_LOGIC;
      ap_fifo_oarg_2_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_2_write : IN STD_LOGIC;
      ap_fifo_oarg_2_full_n : OUT STD_LOGIC;
      ap_fifo_oarg_3_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_3_write : IN STD_LOGIC;
      ap_fifo_oarg_3_full_n : OUT STD_LOGIC;
      ap_fifo_oarg_4_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_4_write : IN STD_LOGIC;
      ap_fifo_oarg_4_full_n : OUT STD_LOGIC;
      ap_fifo_oarg_5_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_5_write : IN STD_LOGIC;
      ap_fifo_oarg_5_full_n : OUT STD_LOGIC;
      ap_fifo_oarg_6_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_6_write : IN STD_LOGIC;
      ap_fifo_oarg_6_full_n : OUT STD_LOGIC;
      ap_fifo_oarg_7_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_fifo_oarg_7_write : IN STD_LOGIC;
      ap_fifo_oarg_7_full_n : OUT STD_LOGIC;
      aclk : IN STD_LOGIC;
      aresetn : OUT STD_LOGIC;
      ap_start : OUT STD_LOGIC;
      ap_ready : IN STD_LOGIC;
      ap_done : IN STD_LOGIC;
      ap_continue : OUT STD_LOGIC;
      ap_idle : IN STD_LOGIC;
      ap_iscalar_0_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_1_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_2_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_3_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_4_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_5_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_6_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_7_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_8_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_9_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_10_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_11_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_12_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_13_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_14_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_iscalar_15_dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_0_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_1_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_2_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_3_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_4_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_5_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_6_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_7_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_8_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_9_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_10_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_11_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_12_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_13_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_14_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_15_din : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      ap_oscalar_0_vld : IN STD_LOGIC;
      ap_oscalar_1_vld : IN STD_LOGIC;
      ap_oscalar_2_vld : IN STD_LOGIC;
      ap_oscalar_3_vld : IN STD_LOGIC;
      ap_oscalar_4_vld : IN STD_LOGIC;
      ap_oscalar_5_vld : IN STD_LOGIC;
      ap_oscalar_6_vld : IN STD_LOGIC;
      ap_oscalar_7_vld : IN STD_LOGIC;
      ap_oscalar_8_vld : IN STD_LOGIC;
      ap_oscalar_9_vld : IN STD_LOGIC;
      ap_oscalar_10_vld : IN STD_LOGIC;
      ap_oscalar_11_vld : IN STD_LOGIC;
      ap_oscalar_12_vld : IN STD_LOGIC;
      ap_oscalar_13_vld : IN STD_LOGIC;
      ap_oscalar_14_vld : IN STD_LOGIC;
      ap_oscalar_15_vld : IN STD_LOGIC;
      ap_oscalar_0_ack : OUT STD_LOGIC;
      ap_oscalar_1_ack : OUT STD_LOGIC;
      ap_oscalar_2_ack : OUT STD_LOGIC;
      ap_oscalar_3_ack : OUT STD_LOGIC;
      ap_oscalar_4_ack : OUT STD_LOGIC;
      ap_oscalar_5_ack : OUT STD_LOGIC;
      ap_oscalar_6_ack : OUT STD_LOGIC;
      ap_oscalar_7_ack : OUT STD_LOGIC;
      ap_oscalar_8_ack : OUT STD_LOGIC;
      ap_oscalar_9_ack : OUT STD_LOGIC;
      ap_oscalar_10_ack : OUT STD_LOGIC;
      ap_oscalar_11_ack : OUT STD_LOGIC;
      ap_oscalar_12_ack : OUT STD_LOGIC;
      ap_oscalar_13_ack : OUT STD_LOGIC;
      ap_oscalar_14_ack : OUT STD_LOGIC;
      ap_oscalar_15_ack : OUT STD_LOGIC;
      ap_iscalar_0_ack : IN STD_LOGIC;
      ap_iscalar_1_ack : IN STD_LOGIC;
      ap_iscalar_2_ack : IN STD_LOGIC;
      ap_iscalar_3_ack : IN STD_LOGIC;
      ap_iscalar_4_ack : IN STD_LOGIC;
      ap_iscalar_5_ack : IN STD_LOGIC;
      ap_iscalar_6_ack : IN STD_LOGIC;
      ap_iscalar_7_ack : IN STD_LOGIC;
      ap_iscalar_8_ack : IN STD_LOGIC;
      ap_iscalar_9_ack : IN STD_LOGIC;
      ap_iscalar_10_ack : IN STD_LOGIC;
      ap_iscalar_11_ack : IN STD_LOGIC;
      ap_iscalar_12_ack : IN STD_LOGIC;
      ap_iscalar_13_ack : IN STD_LOGIC;
      ap_iscalar_14_ack : IN STD_LOGIC;
      ap_iscalar_15_ack : IN STD_LOGIC;
      ap_iscalar_0_vld : OUT STD_LOGIC;
      ap_iscalar_1_vld : OUT STD_LOGIC;
      ap_iscalar_2_vld : OUT STD_LOGIC;
      ap_iscalar_3_vld : OUT STD_LOGIC;
      ap_iscalar_4_vld : OUT STD_LOGIC;
      ap_iscalar_5_vld : OUT STD_LOGIC;
      ap_iscalar_6_vld : OUT STD_LOGIC;
      ap_iscalar_7_vld : OUT STD_LOGIC;
      ap_iscalar_8_vld : OUT STD_LOGIC;
      ap_iscalar_9_vld : OUT STD_LOGIC;
      ap_iscalar_10_vld : OUT STD_LOGIC;
      ap_iscalar_11_vld : OUT STD_LOGIC;
      ap_iscalar_12_vld : OUT STD_LOGIC;
      ap_iscalar_13_vld : OUT STD_LOGIC;
      ap_iscalar_14_vld : OUT STD_LOGIC;
      ap_iscalar_15_vld : OUT STD_LOGIC;
      interrupt : OUT STD_LOGIC
    );
  END COMPONENT axis_accelerator_adapter;
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 s_axi_aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 s_axi_aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF s_axi_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 S_AXI RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 aclk CLK";
  ATTRIBUTE X_INTERFACE_INFO OF aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 aresetn RST";
  ATTRIBUTE X_INTERFACE_INFO OF ap_start: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 AP_CTRL start";
  ATTRIBUTE X_INTERFACE_INFO OF ap_ready: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 AP_CTRL ready";
  ATTRIBUTE X_INTERFACE_INFO OF ap_done: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 AP_CTRL done";
  ATTRIBUTE X_INTERFACE_INFO OF ap_continue: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 AP_CTRL continue";
  ATTRIBUTE X_INTERFACE_INFO OF ap_idle: SIGNAL IS "xilinx.com:interface:acc_handshake:1.0 AP_CTRL idle";
  ATTRIBUTE X_INTERFACE_INFO OF interrupt: SIGNAL IS "xilinx.com:signal:interrupt:1.0 interrupt INTERRUPT";
BEGIN
  U0 : axis_accelerator_adapter
    GENERIC MAP (
      C_FAMILY => "zynq",
      C_S_AXI_ADDR_WIDTH => 13,
      C_S_AXI_DATA_WIDTH => 32,
      C_AP_ADAPTER_ID => 1,
      C_N_INPUT_ARGS => 0,
      C_N_OUTPUT_ARGS => 0,
      C_S_AXIS_TDATA_WIDTH => 64,
      C_S_AXIS_TUSER_WIDTH => 8,
      C_S_AXIS_TID_WIDTH => 4,
      C_S_AXIS_TDEST_WIDTH => 4,
      C_AP_IARG_TYPE => X"0000000000000000000000000000000000000000000000000000000000000000",
      C_AP_IARG_MB_DEPTH => X"0000000400000004000000040000000400000004000000040000000400000004",
      C_AP_IARG_WIDTH => X"0000002000000020000000200000002000000020000000200000002000000020",
      C_AP_IARG_N_DIM => X"0000000100000001000000010000000100000001000000010000000100000001",
      C_AP_IARG_DIM_1 => X"0000040000000400000004000000040000000400000004000000040000000400",
      C_AP_IARG_DIM_2 => X"0000000100000001000000010000000100000001000000010000000100000001",
      C_AP_IARG_FORMAT_TYPE => X"0000000000000000000000000000000000000000000000000000000000000000",
      C_AP_IARG_FORMAT_FACTOR => X"0000000100000001000000010000000100000001000000010000000100000001",
      C_AP_IARG_FORMAT_DIM => X"0000000100000001000000010000000100000001000000010000000100000001",
      C_AP_IARG_0_DWIDTH => 32,
      C_AP_IARG_1_DWIDTH => 32,
      C_AP_IARG_2_DWIDTH => 32,
      C_AP_IARG_3_DWIDTH => 32,
      C_AP_IARG_4_DWIDTH => 32,
      C_AP_IARG_5_DWIDTH => 32,
      C_AP_IARG_6_DWIDTH => 32,
      C_AP_IARG_7_DWIDTH => 32,
      C_M_AXIS_TDATA_WIDTH => 64,
      C_M_AXIS_TUSER_WIDTH => 8,
      C_M_AXIS_TID_WIDTH => 4,
      C_M_AXIS_TDEST_WIDTH => 4,
      C_AP_OARG_TYPE => X"0000000000000000000000000000000000000000000000000000000000000000",
      C_AP_OARG_MB_DEPTH => X"0000000400000004000000040000000400000004000000040000000400000004",
      C_AP_OARG_WIDTH => X"0000002000000020000000200000002000000020000000200000002000000020",
      C_AP_OARG_N_DIM => X"0000000100000001000000010000000100000001000000010000000100000001",
      C_AP_OARG_DIM => X"0000000100000001000000010000040000000001000000010000000100000400000000010000000100000001000004000000000100000001000000010000040000000001000000010000000100000400000000010000000100000001000004000000000100000001000000010000080000000001000000010000000100000008",
      C_AP_OARG_DIM_1 => X"0000040000000400000004000000040000000400000004000000040000000400",
      C_AP_OARG_DIM_2 => X"0000000100000001000000010000000100000001000000010000000100000001",
      C_AP_OARG_FORMAT_TYPE => X"0000000000000000000000000000000000000000000000000000000000000000",
      C_AP_OARG_FORMAT_FACTOR => X"0000000100000001000000010000000100000001000000010000000100000001",
      C_AP_OARG_FORMAT_DIM => X"0000000100000001000000010000000100000001000000010000000100000001",
      C_AP_OARG_0_DWIDTH => 32,
      C_AP_OARG_1_DWIDTH => 32,
      C_AP_OARG_2_DWIDTH => 32,
      C_AP_OARG_3_DWIDTH => 32,
      C_AP_OARG_4_DWIDTH => 32,
      C_AP_OARG_5_DWIDTH => 32,
      C_AP_OARG_6_DWIDTH => 32,
      C_AP_OARG_7_DWIDTH => 32,
      C_N_INOUT_SCALARS => 0,
      C_N_INPUT_SCALARS => 2,
      C_INPUT_SCALAR_DWIDTH => X"00000020000000200000002000000020000000200000002000000020000000200000002000000020000000200000002000000020000000200000002000000020",
      C_INPUT_SCALAR_MODE => X"0000000000000000",
      C_OUTPUT_SCALAR_MODE => X"0000000000000010",
      C_AP_ISCALAR_DOUT_WIDTH => 64,
      C_AP_ISCALAR_IO_DOUT_WIDTH => 32,
      C_INPUT_SCALAR_0_WIDTH => 32,
      C_INPUT_SCALAR_1_WIDTH => 32,
      C_INPUT_SCALAR_2_WIDTH => 32,
      C_INPUT_SCALAR_3_WIDTH => 32,
      C_INPUT_SCALAR_4_WIDTH => 32,
      C_INPUT_SCALAR_5_WIDTH => 32,
      C_INPUT_SCALAR_6_WIDTH => 32,
      C_INPUT_SCALAR_7_WIDTH => 32,
      C_INPUT_SCALAR_8_WIDTH => 32,
      C_INPUT_SCALAR_9_WIDTH => 32,
      C_INPUT_SCALAR_10_WIDTH => 32,
      C_INPUT_SCALAR_11_WIDTH => 32,
      C_INPUT_SCALAR_12_WIDTH => 32,
      C_INPUT_SCALAR_13_WIDTH => 32,
      C_INPUT_SCALAR_14_WIDTH => 32,
      C_INPUT_SCALAR_15_WIDTH => 32,
      C_OUTPUT_SCALAR_0_WIDTH => 32,
      C_OUTPUT_SCALAR_1_WIDTH => 32,
      C_OUTPUT_SCALAR_2_WIDTH => 32,
      C_OUTPUT_SCALAR_3_WIDTH => 32,
      C_OUTPUT_SCALAR_4_WIDTH => 32,
      C_OUTPUT_SCALAR_5_WIDTH => 32,
      C_OUTPUT_SCALAR_6_WIDTH => 32,
      C_OUTPUT_SCALAR_7_WIDTH => 32,
      C_OUTPUT_SCALAR_8_WIDTH => 32,
      C_OUTPUT_SCALAR_9_WIDTH => 32,
      C_OUTPUT_SCALAR_10_WIDTH => 32,
      C_OUTPUT_SCALAR_11_WIDTH => 32,
      C_OUTPUT_SCALAR_12_WIDTH => 32,
      C_OUTPUT_SCALAR_13_WIDTH => 32,
      C_OUTPUT_SCALAR_14_WIDTH => 32,
      C_OUTPUT_SCALAR_15_WIDTH => 32,
      C_N_OUTPUT_SCALARS => 2,
      C_OUTPUT_SCALAR_DWIDTH => X"00000020000000200000002000000020000000200000002000000020000000200000002000000020000000200000002000000020000000200000002000000020",
      C_AP_OSCALAR_DIN_WIDTH => 64,
      C_AP_OSCALAR_IO_DIN_WIDTH => 32,
      C_ENABLE_STREAM_CLK => 0,
      C_PRMRY_IS_ACLK_ASYNC => 0,
      C_S_AXIS_HAS_TSTRB => 0,
      C_S_AXIS_HAS_TKEEP => 0,
      C_NONE => 2
    )
    PORT MAP (
      s_axi_aclk => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_awaddr => s_axi_awaddr,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_awready => s_axi_awready,
      s_axi_wdata => s_axi_wdata,
      s_axi_wstrb => s_axi_wstrb,
      s_axi_wvalid => s_axi_wvalid,
      s_axi_wready => s_axi_wready,
      s_axi_bresp => s_axi_bresp,
      s_axi_bvalid => s_axi_bvalid,
      s_axi_bready => s_axi_bready,
      s_axi_araddr => s_axi_araddr,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_arready => s_axi_arready,
      s_axi_rdata => s_axi_rdata,
      s_axi_rresp => s_axi_rresp,
      s_axi_rvalid => s_axi_rvalid,
      s_axi_rready => s_axi_rready,
      s_axis_aclk => '0',
      s_axis_aresetn => '0',
      s_axis_0_aclk => '0',
      s_axis_0_aresetn => '0',
      s_axis_0_tvalid => '0',
      s_axis_0_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axis_0_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_0_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_0_tlast => '0',
      s_axis_0_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_0_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_0_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_1_aclk => '0',
      s_axis_1_aresetn => '0',
      s_axis_1_tvalid => '0',
      s_axis_1_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axis_1_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_1_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_1_tlast => '0',
      s_axis_1_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_1_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_1_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_2_aclk => '0',
      s_axis_2_aresetn => '0',
      s_axis_2_tvalid => '0',
      s_axis_2_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axis_2_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_2_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_2_tlast => '0',
      s_axis_2_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_2_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_2_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_3_aclk => '0',
      s_axis_3_aresetn => '0',
      s_axis_3_tvalid => '0',
      s_axis_3_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axis_3_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_3_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_3_tlast => '0',
      s_axis_3_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_3_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_3_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_4_aclk => '0',
      s_axis_4_aresetn => '0',
      s_axis_4_tvalid => '0',
      s_axis_4_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axis_4_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_4_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_4_tlast => '0',
      s_axis_4_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_4_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_4_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_5_aclk => '0',
      s_axis_5_aresetn => '0',
      s_axis_5_tvalid => '0',
      s_axis_5_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axis_5_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_5_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_5_tlast => '0',
      s_axis_5_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_5_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_5_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_6_aclk => '0',
      s_axis_6_aresetn => '0',
      s_axis_6_tvalid => '0',
      s_axis_6_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axis_6_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_6_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_6_tlast => '0',
      s_axis_6_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_6_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_6_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_7_aclk => '0',
      s_axis_7_aresetn => '0',
      s_axis_7_tvalid => '0',
      s_axis_7_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axis_7_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_7_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_7_tlast => '0',
      s_axis_7_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_7_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axis_7_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      ap_iarg_0_clk => '0',
      ap_iarg_0_rst => '0',
      ap_iarg_0_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_0_ce => '0',
      ap_iarg_0_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_iarg_0_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_1_clk => '0',
      ap_iarg_1_rst => '0',
      ap_iarg_1_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_1_ce => '0',
      ap_iarg_1_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_iarg_1_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_2_clk => '0',
      ap_iarg_2_rst => '0',
      ap_iarg_2_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_2_ce => '0',
      ap_iarg_2_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_iarg_2_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_3_clk => '0',
      ap_iarg_3_rst => '0',
      ap_iarg_3_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_3_ce => '0',
      ap_iarg_3_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_iarg_3_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_4_clk => '0',
      ap_iarg_4_rst => '0',
      ap_iarg_4_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_4_ce => '0',
      ap_iarg_4_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_iarg_4_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_5_clk => '0',
      ap_iarg_5_rst => '0',
      ap_iarg_5_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_5_ce => '0',
      ap_iarg_5_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_iarg_5_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_6_clk => '0',
      ap_iarg_6_rst => '0',
      ap_iarg_6_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_6_ce => '0',
      ap_iarg_6_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_iarg_6_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_7_clk => '0',
      ap_iarg_7_rst => '0',
      ap_iarg_7_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_iarg_7_ce => '0',
      ap_iarg_7_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_iarg_7_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_iarg_0_read => '0',
      ap_fifo_iarg_1_read => '0',
      ap_fifo_iarg_2_read => '0',
      ap_fifo_iarg_3_read => '0',
      ap_fifo_iarg_4_read => '0',
      ap_fifo_iarg_5_read => '0',
      ap_fifo_iarg_6_read => '0',
      ap_fifo_iarg_7_read => '0',
      m_axis_aclk => '0',
      m_axis_aresetn => '0',
      m_axis_0_aclk => '0',
      m_axis_0_aresetn => '0',
      m_axis_0_tready => '0',
      m_axis_1_aclk => '0',
      m_axis_1_aresetn => '0',
      m_axis_1_tready => '0',
      m_axis_2_aclk => '0',
      m_axis_2_aresetn => '0',
      m_axis_2_tready => '0',
      m_axis_3_aclk => '0',
      m_axis_3_aresetn => '0',
      m_axis_3_tready => '0',
      m_axis_4_aclk => '0',
      m_axis_4_aresetn => '0',
      m_axis_4_tready => '0',
      m_axis_5_aclk => '0',
      m_axis_5_aresetn => '0',
      m_axis_5_tready => '0',
      m_axis_6_aclk => '0',
      m_axis_6_aresetn => '0',
      m_axis_6_tready => '0',
      m_axis_7_aclk => '0',
      m_axis_7_aresetn => '0',
      m_axis_7_tready => '0',
      ap_oarg_0_clk => '0',
      ap_oarg_0_rst => '0',
      ap_oarg_0_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_0_ce => '0',
      ap_oarg_0_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_oarg_0_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_1_clk => '0',
      ap_oarg_1_rst => '0',
      ap_oarg_1_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_1_ce => '0',
      ap_oarg_1_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_oarg_1_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_2_clk => '0',
      ap_oarg_2_rst => '0',
      ap_oarg_2_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_2_ce => '0',
      ap_oarg_2_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_oarg_2_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_3_clk => '0',
      ap_oarg_3_rst => '0',
      ap_oarg_3_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_3_ce => '0',
      ap_oarg_3_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_oarg_3_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_4_clk => '0',
      ap_oarg_4_rst => '0',
      ap_oarg_4_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_4_ce => '0',
      ap_oarg_4_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_oarg_4_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_5_clk => '0',
      ap_oarg_5_rst => '0',
      ap_oarg_5_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_5_ce => '0',
      ap_oarg_5_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_oarg_5_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_6_clk => '0',
      ap_oarg_6_rst => '0',
      ap_oarg_6_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_6_ce => '0',
      ap_oarg_6_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_oarg_6_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_7_clk => '0',
      ap_oarg_7_rst => '0',
      ap_oarg_7_addr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oarg_7_ce => '0',
      ap_oarg_7_we => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      ap_oarg_7_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_0_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_0_write => '0',
      ap_fifo_oarg_1_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_1_write => '0',
      ap_fifo_oarg_2_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_2_write => '0',
      ap_fifo_oarg_3_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_3_write => '0',
      ap_fifo_oarg_4_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_4_write => '0',
      ap_fifo_oarg_5_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_5_write => '0',
      ap_fifo_oarg_6_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_6_write => '0',
      ap_fifo_oarg_7_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_fifo_oarg_7_write => '0',
      aclk => aclk,
      aresetn => aresetn,
      ap_start => ap_start,
      ap_ready => ap_ready,
      ap_done => ap_done,
      ap_continue => ap_continue,
      ap_idle => ap_idle,
      ap_iscalar_0_dout => ap_iscalar_0_dout,
      ap_iscalar_1_dout => ap_iscalar_1_dout,
      ap_oscalar_0_din => ap_oscalar_0_din,
      ap_oscalar_1_din => ap_oscalar_1_din,
      ap_oscalar_2_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_3_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_4_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_5_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_6_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_7_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_8_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_9_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_10_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_11_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_12_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_13_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_14_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_15_din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      ap_oscalar_0_vld => '0',
      ap_oscalar_1_vld => ap_oscalar_1_vld,
      ap_oscalar_2_vld => '0',
      ap_oscalar_3_vld => '0',
      ap_oscalar_4_vld => '0',
      ap_oscalar_5_vld => '0',
      ap_oscalar_6_vld => '0',
      ap_oscalar_7_vld => '0',
      ap_oscalar_8_vld => '0',
      ap_oscalar_9_vld => '0',
      ap_oscalar_10_vld => '0',
      ap_oscalar_11_vld => '0',
      ap_oscalar_12_vld => '0',
      ap_oscalar_13_vld => '0',
      ap_oscalar_14_vld => '0',
      ap_oscalar_15_vld => '0',
      ap_iscalar_0_ack => '0',
      ap_iscalar_1_ack => '0',
      ap_iscalar_2_ack => '0',
      ap_iscalar_3_ack => '0',
      ap_iscalar_4_ack => '0',
      ap_iscalar_5_ack => '0',
      ap_iscalar_6_ack => '0',
      ap_iscalar_7_ack => '0',
      ap_iscalar_8_ack => '0',
      ap_iscalar_9_ack => '0',
      ap_iscalar_10_ack => '0',
      ap_iscalar_11_ack => '0',
      ap_iscalar_12_ack => '0',
      ap_iscalar_13_ack => '0',
      ap_iscalar_14_ack => '0',
      ap_iscalar_15_ack => '0',
      interrupt => interrupt
    );
END zc702_get_0_if_0_arch;
