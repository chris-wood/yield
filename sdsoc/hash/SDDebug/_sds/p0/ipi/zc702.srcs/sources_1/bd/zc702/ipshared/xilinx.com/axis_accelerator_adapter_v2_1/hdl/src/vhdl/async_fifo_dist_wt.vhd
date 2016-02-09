-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : async_fifo_dist_wt.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2013-01-22
-- Platform   :
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- (c) Copyright 2012 Xilinx, Inc. All rights reserved.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-05  1.0      rmg/jn  Created
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

entity async_fifo_dist_wt is
  generic (
    C_FAMILY : string  := "virtex6";    -- Xilinx FPGA family
    DEPTH    : integer := 31;
    WIDTH    : integer := 16);
  port (
    din      : in  std_logic_vector(WIDTH-1 downto 0);
    din_vld  : in  std_logic;
    din_rdy  : out std_logic;
    wr_clk   : in  std_logic;
    wr_rst   : in  std_logic;
    dout     : out std_logic_vector(WIDTH-1 downto 0);
    dout_vld : out std_logic;
    dout_rdy : in  std_logic;
    rd_clk   : in  std_logic;
    rd_rst   : in  std_logic);
end async_fifo_dist_wt;

architecture rtl of async_fifo_dist_wt is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";


  constant FIFO_DEPTH : integer := calc_fifo_depth(DEPTH);
  constant ADDR_BITS  : integer := log2(FIFO_DEPTH);

  signal rd_addr : unsigned(ADDR_BITS-1 downto 0);
  signal wr_addr : unsigned(ADDR_BITS-1 downto 0);

  -- Following signals have gray values
  signal wr_cnt      : std_logic_vector(ADDR_BITS-1 downto 0);
  signal next_wr_cnt : std_logic_vector(ADDR_BITS-1 downto 0);
  signal rd_cnt      : std_logic_vector(ADDR_BITS-1 downto 0);
  signal next_rd_cnt : std_logic_vector(ADDR_BITS-1 downto 0);
  signal prev_rd_cnt : std_logic_vector(ADDR_BITS-1 downto 0);
  signal fifo_we     : std_logic;
  signal fifo_re     : std_logic;
  signal din_rdy_i   : std_logic;
  signal empty_i     : std_logic;
  signal rd_en       : std_logic;
  signal dout_vld_i  : std_logic;

  type   mem_type is array (2**ADDR_BITS-1 downto 0) of std_logic_vector (WIDTH-1 downto 0);
  signal mem                 : mem_type;
  attribute ram_style        : string;
  attribute ram_style of mem : signal is "distributed";

  signal mem_dout : std_logic_vector(WIDTH-1 downto 0);

begin

  ---------------------------------------------------------
  fifo_we <= din_vld and din_rdy_i;

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      wr_addr <= (others => '0');
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_addr <= wr_addr + 1;
      end if;
    end if;
  end process;


  fifo_re <= rd_en and not(empty_i);

  process(rd_clk, rd_rst)
  begin
    if(rd_rst = '1') then
      rd_addr <= (others => '0');
    elsif(rd_clk'event and rd_clk = '1') then
      if(fifo_re = '1') then
        rd_addr <= rd_addr + 1;
      end if;
    end if;
  end process;

  ---------------------------------------------------------
  -- From all gray signals, only next_rd_cnt and next_wr_cnt are counters. all
  -- the rest are registers. It's simpler to use a binary counter and then use
  -- a table to transfor to gray. Given that the address counter is initialized
  -- to zero, signal next_XX_cnt will load code gray(0) after first increment.
  -- Hence, it should be initialized to gray(N-1). that is, the initial values
  -- will be:
  --  * next_XX_cnt = gray(N-1)
  --  * XX_cnt = gray(N-2)
  --  * prev_XX_cnt = gray(N-3)

  process(rd_clk, rd_rst)
  begin
    if(rd_rst = '1') then
      next_rd_cnt <= bin2gray(2**ADDR_BITS-1, ADDR_BITS);
      rd_cnt      <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
      prev_rd_cnt <= bin2gray(2**ADDR_BITS-3, ADDR_BITS);
    elsif(rd_clk'event and rd_clk = '1') then
      if(fifo_re = '1') then
        prev_rd_cnt <= rd_cnt;
        rd_cnt      <= next_rd_cnt;
        next_rd_cnt <= bin2gray(std_logic_vector(rd_addr));
      end if;
    end if;
  end process;

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      next_wr_cnt <= bin2gray(2**ADDR_BITS-1, ADDR_BITS);
      wr_cnt      <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_cnt      <= next_wr_cnt;
        next_wr_cnt <= bin2gray(std_logic_vector(wr_addr));
      end if;
    end if;
  end process;

  -----------------------------------------------------------------
  -- Flag FULL:
  -- 1.- move to full condition (not din_rdy) when there is an efective
  -- write next_wr_cnt = prev_rd_cnt
  -- 2.- stay in full condition (not din_rdy) while this condition is true:
  -- next_wr_cnt = rd_cnt

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      din_rdy_i <= '0';
    elsif(wr_clk'event and wr_clk = '1') then
      if((not(din_rdy_i) or fifo_we) = '1') then
        if(din_rdy_i = '1') then
          if (next_wr_cnt = prev_rd_cnt) then
            din_rdy_i <= '0';
          else
            din_rdy_i <= '1';
          end if;
        else
          if (wr_cnt = prev_rd_cnt) then
            din_rdy_i <= '0';
          else
            din_rdy_i <= '1';
          end if;
        end if;
      end if;
    end if;
  end process;

  din_rdy <= din_rdy_i;

  -- Flag EMPTY:
  -- 1.- move to empty condition when there is read (next_rd_cnt = wr_cnt)
  -- 2.- stay in empty condition while the two pointers are the same (wr_cnt = rd_cnt)

  process(rd_clk, rd_rst)
  begin
    if(rd_rst = '1') then
      empty_i <= '1';
    elsif(rd_clk'event and rd_clk = '1') then
      if((empty_i or fifo_re) = '1') then
        if(empty_i = '0') then
          if(next_rd_cnt = wr_cnt) then
            empty_i <= '1';
          else
            empty_i <= '0';
          end if;
        else
          if(rd_cnt = wr_cnt) then
            empty_i <= '1';
          else
            empty_i <= '0';
          end if;
        end if;
      end if;
    end if;
  end process;

  rd_en <= not(dout_vld_i) or (dout_vld_i and dout_rdy);
  process(rd_clk, rd_rst)
  begin
    if(rd_rst = '1') then
      dout_vld_i <= '0';
    elsif(rd_clk'event and rd_clk = '1') then
      if(rd_en = '1') then
        dout_vld_i <= not(empty_i);
      end if;
    end if;
  end process;

  dout_vld <= dout_vld_i;


  -----------------------------------------------------------------------
  -- memory modeling (XST to infer)

  process(wr_clk)
  begin
    if(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        mem(to_integer(wr_addr)) <= din;
      end if;
    end if;
  end process;

  mem_dout <= mem(to_integer(rd_addr));

  process(rd_clk, rd_rst)
  begin
    if(rd_rst = '1') then
      dout <= (others => '0');
    elsif(rd_clk'event and rd_clk = '1') then
      if(fifo_re = '1') then
        dout <= mem_dout;
      end if;
    end if;
  end process;

end rtl;


