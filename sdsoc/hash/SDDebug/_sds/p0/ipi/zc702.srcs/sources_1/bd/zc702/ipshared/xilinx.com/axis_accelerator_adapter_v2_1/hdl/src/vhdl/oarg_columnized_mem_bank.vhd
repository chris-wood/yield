-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : oarg_columnized_mem_bank.vhd
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
use ieee.numeric_std.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;
use axis_accelerator_adapter_v2_1_6.arg_mem_bank;

entity oarg_columnized_mem_bank is
  generic (
    C_FAMILY       : string;
    C_BRAM_TYPE    : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    C_FACTOR       : integer;
    C_BUFFER_WIDTH : integer;
    C_CONV_AWIDTH  : integer;
    C_CONV_DWIDTH  : integer;
    C_ARG_WIDTH    : integer;
    C_ARG_AWIDTH   : integer);
  port (
    ap_rst        : in  std_logic;
    ap_clk        : in  std_logic;
    ap_arg_ce     : in  std_logic;
    ap_arg_we     : in  std_logic;
    ap_arg_buffer : in  std_logic_vector(C_BUFFER_WIDTH-1 downto 0);
    ap_arg_addr   : in  std_logic_vector(C_ARG_AWIDTH-1 downto 0);
    ap_arg_din    : in  std_logic_vector(C_ARG_WIDTH*C_FACTOR-1 downto 0);
    ap_arg_dout   : out std_logic_vector(C_ARG_WIDTH*C_FACTOR-1 downto 0);
    clk           : in  std_logic;
    conv_ce       : in  std_logic;
    conv_we       : in  std_logic;
    conv_buffer   : in  std_logic_vector(C_BUFFER_WIDTH-1 downto 0);
    conv_addr     : in  std_logic_vector(C_CONV_AWIDTH-1 downto 0);
    conv_data     : out std_logic_vector(C_CONV_DWIDTH-1 downto 0));

end oarg_columnized_mem_bank;

architecture rtl of oarg_columnized_mem_bank is

  constant BANK_AWIDTH  : integer := log2(C_FACTOR);
  constant IPORT_AWIDTH : integer := C_BUFFER_WIDTH+C_ARG_AWIDTH;
  constant OPORT_AWIDTH : integer := C_BUFFER_WIDTH+(C_CONV_AWIDTH-BANK_AWIDTH);

  signal oport_addr : std_logic_vector(OPORT_AWIDTH-1 downto 0);
  signal iport_addr : std_logic_vector(IPORT_AWIDTH-1 downto 0);
  signal oport_ce   : std_logic_vector(C_FACTOR-1 downto 0);
  signal oport_din  : std_logic_vector(C_CONV_DWIDTH*C_FACTOR-1 downto 0);
  signal oport_dout : std_logic_vector(C_CONV_DWIDTH*C_FACTOR-1 downto 0);

begin

  ONLY_ONE_BANK : if (C_FACTOR = 1) generate
  begin
    oport_ce(0) <= conv_ce;
    iport_addr  <= ap_arg_buffer & ap_arg_addr;
    oport_addr  <= conv_buffer & conv_addr;
    conv_data   <= oport_dout;
  end generate ONLY_ONE_BANK;

  SEVERAL_BANKS : if (C_FACTOR > 1) generate

    constant OFFSET_WIDTH : integer := C_CONV_AWIDTH-BANK_AWIDTH;
    constant BANK_MSB     : integer := C_CONV_AWIDTH-1;
    constant BANK_LSB     : integer := BANK_MSB-BANK_AWIDTH+1;
    constant OFFSET_MSB   : integer := BANK_LSB-1;
    constant OFFSET_LSB   : integer := 0;

    signal conv_bank   : std_logic_vector(BANK_AWIDTH-1 downto 0);
    signal conv_offset : std_logic_vector(OFFSET_WIDTH-1 downto 0);
    signal conv_bank_r : std_logic_vector(BANK_AWIDTH-1 downto 0);
    
  begin

    iport_addr <= ap_arg_buffer & ap_arg_addr;

    conv_bank   <= conv_addr(BANK_MSB downto BANK_LSB);
    conv_offset <= conv_addr(OFFSET_MSB downto OFFSET_LSB);

    process(conv_ce, conv_bank)
    begin
      oport_ce <= (others => '0');
      for i in 0 to C_FACTOR-1 loop
        if(unsigned(conv_bank) = i) then
          oport_ce(i) <= conv_ce;
        end if;
      end loop;
    end process;

    oport_addr <= conv_buffer & conv_offset;

    -- Register part of address used to select the bank
    process(clk)
    begin
      if(clk'event and clk = '1') then
        if(conv_ce = '1') then
          conv_bank_r <= conv_bank;
        end if;
      end if;
    end process;

    -- use conv_bank_r to select the mux at the output
    process(conv_bank_r, oport_dout)
    begin
      conv_data <= (others => '0');
      for i in 0 to C_FACTOR-1 loop
        if(unsigned(conv_bank_r) = i) then
          conv_data <= oport_dout(C_CONV_DWIDTH*(i+1)-1 downto C_CONV_DWIDTH*i);
        end if;
      end loop;
    end process;

  end generate SEVERAL_BANKS;

  BANK_GEN : for i in 0 to C_FACTOR-1 generate
  begin

    MEM_I : entity axis_accelerator_adapter_v2_1_6.arg_mem_bank
      generic map (
        C_FAMILY       => C_FAMILY,
        C_BRAM_TYPE    => C_BRAM_TYPE,
        C_IS_UNIDIR    => 0,
        C_IPORT_DWIDTH => C_ARG_WIDTH,
        C_IPORT_AWIDTH => IPORT_AWIDTH,
        C_OPORT_DWIDTH => C_CONV_DWIDTH,
        C_OPORT_AWIDTH => OPORT_AWIDTH)
      port map (
        rst        => ap_rst,
        iport_clk  => ap_clk,
        iport_ce   => ap_arg_ce,
        iport_we   => ap_arg_we,
        iport_addr => iport_addr,
        iport_din  => ap_arg_din(C_ARG_WIDTH*(i+1)-1 downto C_ARG_WIDTH*i),
        iport_dout => ap_arg_dout(C_ARG_WIDTH*(i+1)-1 downto C_ARG_WIDTH*i),
        oport_clk  => clk,
        oport_ce   => oport_ce(i),
        oport_we   => conv_we,
        oport_addr => oport_addr,
        oport_din  => oport_din(C_CONV_DWIDTH*(i+1)-1 downto C_CONV_DWIDTH*i),
        oport_dout => oport_dout(C_CONV_DWIDTH*(i+1)-1 downto C_CONV_DWIDTH*i));

  end generate BANK_GEN;

end rtl;

