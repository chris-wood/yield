-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sync_ap_status.vhd
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
-- 2013-08-25  2.0      pvk	Changed reset polarity to active low
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

-- this is a synchronizer module for ap_start and ap_done (between accelerator
-- clock and AXI clock)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;

entity sync_ap_status is
  port (
    rst      : in  std_logic;
    ap_clk   : in  std_logic;
    ap_flag  : in  std_logic;
    axi_clk  : in  std_logic;
    flag     : out std_logic;
    flag_clr : in  std_logic);
end entity;

architecture rtl of sync_ap_status is
  signal wr_cnt  : std_logic;
  signal rd_cnt  : std_logic;
  signal wr_en   : std_logic;
  signal rd_en   : std_logic;
  signal full_n  : std_logic;
  signal empty_n : std_logic;

begin

  wr_en <= ap_flag and full_n;

  process(ap_clk, rst)
  begin
    if(rst = '1') then
      wr_cnt <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      if(wr_en = '1') then
        wr_cnt <= not(wr_cnt);
      end if;
    end if;
  end process;

  rd_en <= flag_clr and empty_n;

  process(axi_clk, rst)
  begin
    if(rst = '1') then
      rd_cnt <= '0';
    elsif(axi_clk'event and axi_clk = '1') then
      if(rd_en = '1') then
        rd_cnt <= not(rd_cnt);
      end if;
    end if;
  end process;

  process(ap_clk, rst)
  begin
    if(rst = '1') then
      full_n <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      if(full_n = '1') then
        full_n <= not(wr_en);
      else
        full_n <= not(wr_cnt xor rd_cnt);
      end if;
    end if;
  end process;

  process(axi_clk, rst)
  begin
    if(rst = '1') then
      empty_n <= '0';
    elsif(axi_clk'event and axi_clk = '1') then
      if(empty_n = '1') then
        empty_n <= not(rd_en);
      else
        empty_n <= (wr_cnt xor rd_cnt);
      end if;
    end if;
  end process;

  flag <= empty_n;

end rtl;

