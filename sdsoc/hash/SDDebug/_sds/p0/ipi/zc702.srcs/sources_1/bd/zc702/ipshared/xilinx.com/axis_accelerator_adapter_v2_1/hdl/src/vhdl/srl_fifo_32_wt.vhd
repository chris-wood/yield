-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : srl_fifo_32_wt.vhd
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

library unisim;
use unisim.vcomponents.all;

entity srl_fifo_32_wt is
  generic (
    C_FAMILY : string  := "spartan6";
    WIDTH    : integer := 16);
  port (
    rst      : in  std_logic;
    clk      : in  std_logic;
    din      : in  std_logic_vector(WIDTH-1 downto 0);
    din_vld  : in  std_logic;
    din_rdy  : out std_logic;
    dout     : out std_logic_vector(WIDTH-1 downto 0);
    dout_vld : out std_logic;
    dout_rdy : in  std_logic);
end srl_fifo_32_wt;

architecture rtl of srl_fifo_32_wt is
  constant ADDR_WIDTH     : integer := 5;
  constant CNT_MAX        : integer := 2**ADDR_WIDTH;
  constant FIFO_CNT_WIDTH : integer := ADDR_WIDTH+1;

  signal addr       : unsigned(ADDR_WIDTH-1 downto 0);
  signal fifo_cnt_i : unsigned(FIFO_CNT_WIDTH-1 downto 0);
  signal fifo_re    : std_logic;
  signal fifo_we    : std_logic;
  signal empty_i    : std_logic;
  signal mem_out    : std_logic_vector(WIDTH-1 downto 0);
  signal din_rdy_i  : std_logic;
  signal rd_en      : std_logic;
  signal dout_vld_i : std_logic;

begin

  MEM_GEN : for i in 0 to WIDTH-1 generate
  begin
    SRL_I : SRLC32E
      generic map (
        INIT => x"00000000")
      port map (
        D   => din(i),
        CE  => fifo_we,
        CLK => clk,
        A   => std_logic_vector(addr),
        Q   => mem_out(i),
        Q31 => open);
  end generate;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if(rst = '1') then
        dout <= (others => '0');
      elsif(fifo_re = '1') then
        dout <= mem_out;
      end if;
    end if;
  end process;

  din_rdy <= din_rdy_i;

  fifo_re <= rd_en and not(empty_i);
  fifo_we <= din_vld and din_rdy_i;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if(rst = '1') then
        fifo_cnt_i <= (others => '0');
        addr       <= (others => '1');
      elsif(fifo_we = '1' and fifo_re = '0') then
        fifo_cnt_i <= fifo_cnt_i + 1;
        addr       <= addr + 1;
      elsif(fifo_we = '0' and fifo_re = '1') then
        fifo_cnt_i <= fifo_cnt_i - 1;
        addr       <= addr - 1;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if (clk'event and clk = '1') then
      if(rst = '1') then
        empty_i <= '1';
      else
        if(fifo_cnt_i(FIFO_CNT_WIDTH-1 downto 1) = 0) then  -- cnt = 0 or 1
          empty_i <= not(fifo_we) and (fifo_re or not(fifo_cnt_i(0)));
        else
          empty_i <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
    constant ones : unsigned(addr'range) := (others => '1');
  begin
    if (clk'event and clk = '1') then
      if(rst = '1') then
        din_rdy_i <= '0';
      else
        if(fifo_cnt_i(FIFO_CNT_WIDTH-1) = '1') then  -- cnt = MAX
          din_rdy_i <= (fifo_re);
        elsif(fifo_cnt_i(addr'range) = ones) then    -- cnt = MAX-1
          din_rdy_i <= not(not(fifo_re) and fifo_we);
        else
          din_rdy_i <= '1';
        end if;
      end if;
    end if;
  end process;

  rd_en <= not(dout_vld_i) or (dout_vld_i and dout_rdy);
  process(clk, rst)
  begin
    if(rst = '1') then
      dout_vld_i <= '0';
    elsif(clk'event and clk = '1') then
      if(rd_en = '1') then
        dout_vld_i <= not(empty_i);
      end if;
    end if;
  end process;

  dout_vld <= dout_vld_i;

end rtl;

