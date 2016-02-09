-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : xd_s2m_adapter.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2013-10-25
-- Platform   :
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- (c) Copyright 2012 Xilinx, Inc. All rights reserved.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-05  1.0      rmg/jn	Created
-- 2013-10-25  2.0      pvk     Added support for UltraScale primitives. 
-------------------------------------------------------------------------------
-- ****************************************************************************
--
-- (c) Copyright 2013 Xilinx, Inc. All rights reserved.
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;
use axis_accelerator_adapter_v2_1_6.xd_s2m_converter;
use axis_accelerator_adapter_v2_1_6.xd_s2m_memory_dc;
use axis_accelerator_adapter_v2_1_6.srl_fifo_32_wt;



entity xd_s2m_adapter is
  generic (
    -- System generics:
    C_FAMILY               : string := "virtex7";
    C_MTBF_STAGES          : integer;
    C_BRAM_TYPE            : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    C_S_AXIS_TDATA_WIDTH   : integer;
    C_S_AXIS_TUSER_WIDTH   : integer;
    C_S_AXIS_TID_WIDTH     : integer;
    C_S_AXIS_TDEST_WIDTH   : integer;
    C_AP_ARG_DATA_WIDTH    : integer;
    C_AP_ARG_ADDR_WIDTH    : integer;
    C_MULTIBUFFER_DEPTH    : integer;
    C_AP_ARG_WIDTH         : integer;
    C_AP_ARG_N_DIM         : integer;
    C_AP_ARG_DIM_1         : integer;
    C_AP_ARG_DIM_2         : integer;
    C_AP_ARG_FORMAT_TYPE   : integer;
    C_AP_ARG_FORMAT_FACTOR : integer;
    C_AP_ARG_FORMAT_DIM    : integer;
    C_EXTRA_SYNCS          : integer);
  port (
    -- Input streams
    S_AXIS_ACLK       : in  std_logic;
    S_AXIS_ARESETN    : in  std_logic;
    S_AXIS_TVALID     : in  std_logic;
    S_AXIS_TREADY     : out std_logic;
    S_AXIS_TDATA      : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    S_AXIS_TSTRB      : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0);
    S_AXIS_TKEEP      : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0);
    S_AXIS_TLAST      : in  std_logic;
    S_AXIS_TID        : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    S_AXIS_TDEST      : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    S_AXIS_TUSER      : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);
    dbg_stream_nwords : out std_logic_vector(15 downto 0);
    dbg_buffer_nwords : out std_logic_vector(15 downto 0);
    dbg_ap_start      : in  std_logic;
    ap_clk            : in  std_logic;
    ap_rst_sync       : in  std_logic;
    ap_rst            : in  std_logic;
    ap_arg_addr       : in  std_logic_vector(C_AP_ARG_ADDR_WIDTH-1 downto 0);
    ap_arg_ce         : in  std_logic;
    ap_arg_we         : in  std_logic;
    ap_arg_din        : in  std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    ap_arg_dout       : out std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    mb_arg_rdy        : out std_logic;
    mb_arg_done       : in  std_logic;
    status_empty      : out std_logic;
    status_full       : out std_logic;
    status_used       : out std_logic_vector(3 downto 0));  -- Number of used buffers
end entity;

architecture rtl of xd_s2m_adapter is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  signal axi_rst : std_logic;
  signal axi_rst1 : std_logic;
  signal axi_rst2 : std_logic;

  function calc_axi_addr_width return integer is
    variable addr_width : integer := 0;
  begin
    if (C_S_AXIS_TDATA_WIDTH > C_AP_ARG_DATA_WIDTH) then
      addr_width := C_AP_ARG_ADDR_WIDTH-log2(C_S_AXIS_TDATA_WIDTH/C_AP_ARG_DATA_WIDTH);
    else
      addr_width := C_AP_ARG_ADDR_WIDTH+log2(C_AP_ARG_DATA_WIDTH/C_S_AXIS_TDATA_WIDTH);
    end if;
    return addr_width;
  end function calc_axi_addr_width;

  constant AXI_DATA_WIDTH : integer := C_S_AXIS_TDATA_WIDTH;
  constant AXI_ADDR_WIDTH : integer := calc_axi_addr_width;

  signal ap_rst_vec         : std_logic_vector(0 downto 0);
--  signal ap_rst_sync        : std_logic;
--  signal ap_rst_sync1        : std_logic;
  signal axisn_rst            : std_logic;
  signal conv_addr          : std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
  signal conv_ce            : std_logic;
  signal conv_we            : std_logic;
  signal conv_last          : std_logic;
  signal conv_rdy           : std_logic;
  signal conv_data          : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  -- Control for number of words receided in the stream
  signal last_conv_addr_vld : std_logic;
  signal stream_nwords      : unsigned(AXI_ADDR_WIDTH downto 0);
  signal stream_nwords_vld  : std_logic;
  signal buffer_nwords      : std_logic_vector(AXI_ADDR_WIDTH downto 0);
  signal buffer_nwords_vld  : std_logic;
  signal buffer_nwords_rdy  : std_logic;

    ATTRIBUTE async_reg           : STRING;
  ATTRIBUTE async_reg OF axi_rst  : SIGNAL IS "true";
  ATTRIBUTE async_reg OF axi_rst1  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF ap_rst_sync1  : SIGNAL IS "true";
--  ATTRIBUTE async_reg OF ap_rst_sync  : SIGNAL IS "true";


begin


  -- undriven ports 
  dbg_stream_nwords <= (others => '0');
  dbg_buffer_nwords <= (others => '0');
  
  -- core reset generation


--      prd1: PROCESS (S_AXIS_ACLK, ap_rst)
--      BEGIN
--       -- Register Stage #1 
--        IF (ap_rst = '1') THEN
--          ap_rst_sync1 <= '1';
--          ap_rst_sync <= '1';
--        ELSIF (S_AXIS_ACLK'event and S_AXIS_ACLK = '1') THEN
--          ap_rst_sync1 <= '0';
--          ap_rst_sync <= ap_rst_sync1;
--        END IF;
--        END PROCESS prd1;

	axi_rst2 <= not(S_AXIS_ARESETN) or ap_rst_sync; 

      prd2: PROCESS (S_AXIS_ACLK, axi_rst2)
      BEGIN
       -- Register Stage #1 
        IF (axi_rst2 = '1') THEN
          axi_rst1 <= '1';
          axi_rst <= '1';
        ELSIF (S_AXIS_ACLK'event and S_AXIS_ACLK = '1') THEN
          axi_rst1 <= '0';
          axi_rst <= axi_rst1;
        END IF;
        END PROCESS prd2;


  CONVERTER_I : entity axis_accelerator_adapter_v2_1_6.xd_s2m_converter
    generic map (
      C_FAMILY       => C_FAMILY,
      AXI_DATA_WIDTH => AXI_DATA_WIDTH,
      AXI_ADDR_WIDTH => AXI_ADDR_WIDTH,
      C_EXTRA_SYNCS  => C_EXTRA_SYNCS)
    port map (
      axi_clk   => S_AXIS_ACLK,
      axi_rst   => axi_rst,
      axis_vld  => S_AXIS_TVALID,
      axis_rdy  => S_AXIS_TREADY,
      axis_last => S_AXIS_TLAST,
      axis_keep => S_AXIS_TKEEP,
      axis_data => S_AXIS_TDATA,
      conv_addr => conv_addr,
      conv_ce   => conv_ce,
      conv_we   => conv_we,
      conv_last => conv_last,
      conv_rdy  => conv_rdy,
      conv_data => conv_data);

  MEM_CTRL_I : entity axis_accelerator_adapter_v2_1_6.xd_s2m_memory_dc
    generic map (
      -- System generics:
      C_FAMILY               => C_FAMILY,
      C_MTBF_STAGES          => C_MTBF_STAGES,
      C_BRAM_TYPE            => C_BRAM_TYPE,
      CONV_DATA_WIDTH        => AXI_DATA_WIDTH,
      CONV_ADDR_WIDTH        => AXI_ADDR_WIDTH,
      C_AP_ARG_WIDTH         => C_AP_ARG_WIDTH,
      C_AP_ARG_N_DIM         => C_AP_ARG_N_DIM,
      C_AP_ARG_DIM_1         => C_AP_ARG_DIM_1,
      C_AP_ARG_DIM_2         => C_AP_ARG_DIM_2,
      C_AP_ARG_FORMAT_TYPE   => C_AP_ARG_FORMAT_TYPE,
      C_AP_ARG_FORMAT_FACTOR => C_AP_ARG_FORMAT_FACTOR,
      C_AP_ARG_FORMAT_DIM    => C_AP_ARG_FORMAT_DIM,
      C_AP_ARG_DATA_WIDTH    => C_AP_ARG_DATA_WIDTH,
      C_AP_ARG_ADDR_WIDTH    => C_AP_ARG_ADDR_WIDTH,
      C_MULTIBUFFER_DEPTH    => C_MULTIBUFFER_DEPTH,
      C_EXTRA_SYNCS          => C_EXTRA_SYNCS)
    port map (
      clk          => S_AXIS_ACLK,
      rst          => axi_rst,
      conv_addr    => conv_addr,
      conv_ce      => conv_ce,
      conv_we      => conv_we,
      conv_last    => conv_last,
      conv_rdy     => conv_rdy,
      conv_data    => conv_data,
      ap_clk       => ap_clk,
      ap_rst       => ap_rst,
      ap_arg_addr  => ap_arg_addr,
      ap_arg_ce    => ap_arg_ce,
      ap_arg_we    => ap_arg_we,
      ap_arg_din   => ap_arg_din,
      ap_arg_dout  => ap_arg_dout,
      mb_arg_rdy   => mb_arg_rdy,
      mb_arg_done  => mb_arg_done,
      status_empty => status_empty,
      status_full  => status_full,
      status_used  => status_used);

  ---------------------------
  -- The following logic is used for debugging purposes (provide number of
  -- words received in the axi_stream. TODO: design not finished.

  last_conv_addr_vld <= conv_ce and conv_rdy and conv_last;

  process(S_AXIS_ACLK)
  begin
    if (S_AXIS_ACLK'event and S_AXIS_ACLK = '1') then
      if(last_conv_addr_vld = '1') then
        stream_nwords <= unsigned('0' & conv_addr) + 1;
      end if;
    end if;
  end process;

  process(S_AXIS_ACLK, axi_rst)
  begin
    if (axi_rst = '1') then
      stream_nwords_vld <= '0';
    elsif (S_AXIS_ACLK'event and S_AXIS_ACLK = '1') then
      stream_nwords_vld <= last_conv_addr_vld;
    end if;
  end process;

  NWORDS_FIFO_I : entity axis_accelerator_adapter_v2_1_6.srl_fifo_32_wt
    generic map (
      C_FAMILY => C_FAMILY,
      WIDTH    => AXI_ADDR_WIDTH+1)
    port map (
      rst      => axi_rst,
      clk      => S_AXIS_ACLK,
      din      => std_logic_vector(stream_nwords),
      din_vld  => stream_nwords_vld,
      din_rdy  => open,
      dout     => buffer_nwords,
      dout_vld => buffer_nwords_vld,
      dout_rdy => buffer_nwords_rdy);

  buffer_nwords_rdy <= '0';

end rtl;

