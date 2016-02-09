-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : arg_mem_bank.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-04
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
-- 2012-09-04  1.0      rmg/jn	Created
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
use ieee.numeric_std.all;


library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.arg_mem_bank_v6;


entity arg_mem_bank is
  generic (
    C_FAMILY       : string;
    C_BRAM_TYPE    : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    C_IS_UNIDIR    : integer range 0 to 1 := 0;
    C_OPORT_AWIDTH : integer;
    C_OPORT_DWIDTH : integer;
    C_IPORT_AWIDTH : integer;
    C_IPORT_DWIDTH : integer);
  port (
    rst        : in  std_logic;
    oport_clk  : in  std_logic;
    oport_ce   : in  std_logic;
    oport_we   : in  std_logic;
    oport_addr : in  std_logic_vector(C_OPORT_AWIDTH-1 downto 0);
    oport_din  : in  std_logic_vector(C_OPORT_DWIDTH-1 downto 0);
    oport_dout : out std_logic_vector(C_OPORT_DWIDTH-1 downto 0);

    iport_clk  : in  std_logic;
    iport_ce   : in  std_logic;
    iport_we   : in  std_logic;
    iport_addr : in  std_logic_vector(C_IPORT_AWIDTH-1 downto 0);
    iport_din  : in  std_logic_vector(C_IPORT_DWIDTH-1 downto 0);
    iport_dout : out std_logic_vector(C_IPORT_DWIDTH-1 downto 0));
end arg_mem_bank;

architecture rtl of arg_mem_bank is

begin



    ARG_MEM_I : entity axis_accelerator_adapter_v2_1_6.arg_mem_bank_v6
      generic map (
        C_FAMILY       => C_FAMILY,
        C_BRAM_TYPE    => C_BRAM_TYPE,
        C_IS_UNIDIR    => C_IS_UNIDIR,
        C_OPORT_AWIDTH => C_OPORT_AWIDTH,
        C_OPORT_DWIDTH => C_OPORT_DWIDTH,
        C_IPORT_AWIDTH => C_IPORT_AWIDTH,
        C_IPORT_DWIDTH => C_IPORT_DWIDTH)
      port map (
        rst        => rst,
        oport_clk  => oport_clk,
        oport_ce   => oport_ce,
        oport_we   => oport_we,
        oport_addr => oport_addr,
        oport_din  => oport_din,
        oport_dout => oport_dout,

        iport_clk  => iport_clk,
        iport_ce   => iport_ce,
        iport_we   => iport_we,
        iport_addr => iport_addr,
        iport_din  => iport_din,
        iport_dout => iport_dout);


end rtl;
