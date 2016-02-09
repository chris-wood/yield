-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : xd_s2m_converter.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2012-11-04
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
-- 2013-08-01  2.0	pvk     Removed conv_bank port.Not being used.
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

entity xd_s2m_converter is
  generic (
    -- System generics:
    C_FAMILY       : string;            -- Xilinx FPGA family
    AXI_DATA_WIDTH : integer;
    AXI_ADDR_WIDTH : integer;
    C_EXTRA_SYNCS  : integer);
  port (
    axi_clk   : in  std_logic;
    axi_rst   : in  std_logic;
    axis_vld  : in  std_logic;
    axis_rdy  : out std_logic;
    axis_last : in  std_logic;
    axis_keep : in  std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
    axis_data : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    --conv_bank : out std_logic_vector(5 downto 0);
    conv_addr : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    conv_ce   : out std_logic;
    conv_we   : out std_logic;
    conv_last : out std_logic;
    conv_rdy  : in  std_logic;
    conv_data : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0));
end entity;

architecture rtl of xd_s2m_converter is
  signal axis_rdy_i : std_logic;
  signal addr_cnt   : unsigned(AXI_ADDR_WIDTH-1 downto 0);

begin

  axis_rdy <= axis_rdy_i;

  process(axi_clk)
  begin
    if(axi_clk'event and axi_clk = '1') then
      if(axi_rst = '1' or (axis_vld and axis_rdy_i and axis_last) = '1') then
        addr_cnt <= (others => '0');
      elsif((axis_vld and axis_rdy_i) = '1') then
        addr_cnt <= addr_cnt + 1;
      end if;
    end if;
  end process;

  -- Used a simple approach; would be good to elaborate more in the long term.
  conv_we    <= or_reduce(axis_keep);
  conv_ce    <= axis_vld;
  conv_data  <= axis_data;
  conv_last  <= axis_last;
  axis_rdy_i <= conv_rdy;
  conv_addr  <= std_logic_vector(addr_cnt);

end rtl;

