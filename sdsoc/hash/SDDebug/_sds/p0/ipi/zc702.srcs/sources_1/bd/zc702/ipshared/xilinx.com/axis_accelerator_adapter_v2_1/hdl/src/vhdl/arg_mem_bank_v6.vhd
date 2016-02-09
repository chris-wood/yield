-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : arg_mem_bank_v6.vhd
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
use axis_accelerator_adapter_v2_1_6.asymmetric_dp_bank_v6;
use axis_accelerator_adapter_v2_1_6.symmetric_dp_bank_v6;
use axis_accelerator_adapter_v2_1_6.dp_bank_sdp_v6;


entity arg_mem_bank_v6 is
  generic (
    C_FAMILY       : string;
    C_BRAM_TYPE    : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    C_PRINT_INFO   : boolean              := false;
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
end arg_mem_bank_v6;

architecture rtl of arg_mem_bank_v6 is

  function calc_use_sdp(is_unidir : natural) return integer is
    variable use_sdp : integer;
  begin
    if(C_IS_UNIDIR = 0) then
      use_sdp := 0;
    else
      use_sdp                                   := 0;
      if(C_OPORT_DWIDTH = 64 and C_IPORT_DWIDTH <= 64 and C_OPORT_AWIDTH <= 9) then
        -- SDP, WR port 64 bits
        use_sdp := 1;
      elsif(C_IPORT_DWIDTH = 64 and C_OPORT_DWIDTH <= 64 and C_IPORT_AWIDTH <= 9) then
        -- SDP, RD port 64 bits
        use_sdp := 1;
      end if;
    end if;
    return use_sdp;
  end function calc_use_sdp;

  constant USE_SDP : integer := calc_use_sdp(C_IS_UNIDIR);

begin

  WR_PORT_WIDER_GEN : if (C_IPORT_DWIDTH > C_OPORT_DWIDTH) generate
  begin

    USE_SDP_GEN : if (use_sdp /= 0) generate
    begin

      BANK_I : entity axis_accelerator_adapter_v2_1_6.dp_bank_sdp_v6
        generic map (
          C_FAMILY    => C_FAMILY,
          C_BRAM_TYPE => C_BRAM_TYPE,
          C_SDP_WIDE  => 1,
          C_RD_AWIDTH => C_OPORT_AWIDTH,
          C_RD_DWIDTH => C_OPORT_DWIDTH,
          C_WR_AWIDTH => C_IPORT_AWIDTH,
          C_WR_DWIDTH => C_IPORT_DWIDTH)
        port map (
          rst => rst,
          rd_clk  => oport_clk,
          rd_en   => oport_ce,
          rd_addr => oport_addr,
          dout    => oport_dout,
          wr_clk  => iport_clk,
          wr_en   => iport_ce,
          wr_addr => iport_addr,
          din     => iport_din);

      iport_dout <= (others => '0');

    end generate USE_SDP_GEN;

    DONT_USE_SDP_GEN : if (use_sdp = 0) generate
    begin
      -- Port A is always the wider port
      BANK_I : entity axis_accelerator_adapter_v2_1_6.asymmetric_dp_bank_v6
        generic map (
          C_FAMILY        => C_FAMILY,
          C_BRAM_TYPE     => C_BRAM_TYPE,
          C_BANK_AWIDTH_A => C_IPORT_AWIDTH,
          C_BANK_DWIDTH_A => C_IPORT_DWIDTH,
          C_BANK_AWIDTH_B => C_OPORT_AWIDTH,
          C_BANK_DWIDTH_B => C_OPORT_DWIDTH)
        port map (
          rst    => rst,
          clk_a  => iport_clk,
          ce_a   => iport_ce,
          we_a   => iport_we,
          addr_a => iport_addr,
          din_a  => iport_din,
          dout_a => iport_dout,
          clk_b  => oport_clk,
          ce_b   => oport_ce,
          we_b   => oport_we,
          addr_b => oport_addr,
          din_b  => oport_din,
          dout_b => oport_dout);

    end generate DONT_USE_SDP_GEN;

  end generate WR_PORT_WIDER_GEN;


  ---------------------------------------------------------------------------------------
  WR_PORT_NARROWER_GEN : if (C_IPORT_DWIDTH < C_OPORT_DWIDTH) generate
  begin

    USE_SDP_GEN : if (use_sdp /= 0) generate
    begin

      BANK_I : entity axis_accelerator_adapter_v2_1_6.dp_bank_sdp_v6
        generic map (
          C_FAMILY    => C_FAMILY,
          C_BRAM_TYPE => C_BRAM_TYPE,
          C_SDP_WIDE  => 0,
          C_RD_AWIDTH => C_OPORT_AWIDTH,
          C_RD_DWIDTH => C_OPORT_DWIDTH,
          C_WR_AWIDTH => C_IPORT_AWIDTH,
          C_WR_DWIDTH => C_IPORT_DWIDTH)
        port map (
          rst => rst,
          rd_clk  => oport_clk,
          rd_en   => oport_ce,
          rd_addr => oport_addr,
          dout    => oport_dout,
          wr_clk  => iport_clk,
          wr_en   => iport_ce,
          wr_addr => iport_addr,
          din     => iport_din);

      iport_dout <= (others => '0');

    end generate USE_SDP_GEN;

    DONT_USE_SDP_GEN : if (use_sdp = 0) generate
    begin

      -- Port A is always the wider port
      BANK_I : entity axis_accelerator_adapter_v2_1_6.asymmetric_dp_bank_v6
        generic map (
          C_FAMILY        => C_FAMILY,
          C_BRAM_TYPE     => C_BRAM_TYPE,
          C_BANK_AWIDTH_B => C_IPORT_AWIDTH,
          C_BANK_DWIDTH_B => C_IPORT_DWIDTH,
          C_BANK_AWIDTH_A => C_OPORT_AWIDTH,
          C_BANK_DWIDTH_A => C_OPORT_DWIDTH)
        port map (
          rst    => rst,
          clk_b  => iport_clk,
          ce_b   => iport_ce,
          we_b   => iport_we,
          addr_b => iport_addr,
          din_b  => iport_din,
          dout_b => iport_dout,
          clk_a  => oport_clk,
          ce_a   => oport_ce,
          we_a   => oport_we,
          addr_a => oport_addr,
          din_a  => oport_din,
          dout_a => oport_dout);

    end generate DONT_USE_SDP_GEN;

  end generate WR_PORT_NARROWER_GEN;

  SAME_WIDTH_GEN : if (C_OPORT_DWIDTH = C_IPORT_DWIDTH) generate
  begin

    BANK_I : entity axis_accelerator_adapter_v2_1_6.symmetric_dp_bank_v6
      generic map (
        C_FAMILY      => C_FAMILY,
        C_BRAM_TYPE   => C_BRAM_TYPE,
        C_BANK_AWIDTH => C_OPORT_AWIDTH,
        C_BANK_DWIDTH => C_OPORT_DWIDTH)
      port map (
        rst    => rst,
        clk_a  => oport_clk,
        ce_a   => oport_ce,
        we_a   => oport_we,
        addr_a => oport_addr,
        din_a  => oport_din,
        dout_a => oport_dout,
        clk_b  => iport_clk,
        ce_b   => iport_ce,
        we_b   => iport_we,
        addr_b => iport_addr,
        din_b  => iport_din,
        dout_b => iport_dout);

  end generate SAME_WIDTH_GEN;

end rtl;
