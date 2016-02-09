-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : xd_m2s_converter.vhd
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
-- 2013-07-31  2.0      pvk	Updated Tvalid generattion logic to remove stream
--                              protocol error where tvalid was deasserting 
--                              tlast
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

entity xd_m2s_converter is
  generic (
    -- System generics:
    C_FAMILY       : string;            -- Xilinx FPGA family
    SIZE_WIDTH     : integer;
    AXI_DATA_WIDTH : integer;
    AXI_ADDR_WIDTH : integer;
    AXI_USER_WIDTH : integer;
    AXI_ID_WIDTH   : integer;
    AXI_DEST_WIDTH : integer);
  port (
    axi_clk         : in  std_logic;
    axi_rst         : in  std_logic;
    axis_vld        : out std_logic;
    axis_rdy        : in  std_logic;
    axis_data       : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    axis_keep       : out std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
    axis_strb       : out std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
    axis_last       : out std_logic;
    axis_id         : out std_logic_vector(AXI_ID_WIDTH-1 downto 0);
    axis_dest       : out std_logic_vector(AXI_DEST_WIDTH-1 downto 0);
    axis_user       : out std_logic_vector(AXI_USER_WIDTH-1 downto 0);
    conv_size       : in  std_logic_vector(SIZE_WIDTH-1 downto 0);
    conv_addr       : out std_logic_vector(AXI_ADDR_WIDTH-1 downto 0);
    conv_ce         : out std_logic;
    conv_we         : out std_logic;
    conv_last       : out std_logic;
    conv_rdy        : in  std_logic;
    conv_data       : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    host_oarg_tdest : in  std_logic_vector(AXI_DEST_WIDTH-1 downto 0));
end entity;

architecture rtl of xd_m2s_converter is
  constant STRB_WIDTH : integer := AXI_DATA_WIDTH/8;
  type state_type is (
    idle,
    running, wait_last);
  signal state : state_type;

  constant SUBWORD_WIDTH  : integer := log2(AXI_DATA_WIDTH/8);
  constant WORD_CNT_WIDTH : integer := SIZE_WIDTH - SUBWORD_WIDTH;
  constant WORD_CNT_LSB   : integer := SUBWORD_WIDTH;
  constant WORD_CNT_MSB   : integer := SIZE_WIDTH-1;

  signal word_cnt       : unsigned(WORD_CNT_WIDTH-1 downto 0);
  signal init_cnt       : std_logic;
  signal word_cnt_0     : std_logic;
  signal word_cnt_1     : std_logic;
  signal full_last_word : std_logic;
  signal last_word      : std_logic;
  signal last_strb      : std_logic_vector(STRB_WIDTH-1 downto 0);
  --
  signal conv_addr_i    : unsigned(AXI_ADDR_WIDTH-1 downto 0);
  signal conv_ce_i      : std_logic;
  signal conv_data_vld  : std_logic;
  signal conv_data_last : std_logic;
  signal conv_data_strb : std_logic_vector(STRB_WIDTH-1 downto 0);
  signal fill_pipe      : std_logic;
  -- 
  signal dout_vld       : std_logic;
  signal dout_last      : std_logic;
  signal dout_rdy       : std_logic;
  signal dout           : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal dout_strb      : std_logic_vector(STRB_WIDTH-1 downto 0);


begin

  -- Each time we send a stream out, we initialize to zero its buffer
  conv_we <= '0';

  -- count the words to read:
  process(axi_clk)
    variable aux : unsigned(WORD_CNT_WIDTH-1 downto 0);
  begin
    if(axi_clk'event and axi_clk = '1') then
      if(init_cnt = '1') then
        aux        := unsigned(conv_size(WORD_CNT_MSB downto WORD_CNT_LSB));
        word_cnt   <= aux;
        word_cnt_0 <= '0';
        word_cnt_1 <= '0';
        if(aux(WORD_CNT_WIDTH-1 downto 1) = 0) then
          word_cnt_1 <= aux(0);
          word_cnt_0 <= not(aux(0));
        end if;
      elsif(conv_ce_i = '1') then
        word_cnt <= word_cnt - 1;
        if(word_cnt = 2) then
          word_cnt_1 <= '1';
        else
          word_cnt_1 <= '0';
        end if;
        word_cnt_0 <= word_cnt_1;
      end if;
    end if;
  end process;

  -- Address to access:
  process(axi_clk)
    variable aux : unsigned(WORD_CNT_WIDTH-1 downto 0);
  begin
    if(axi_clk'event and axi_clk = '1') then
      if(init_cnt = '1') then
        conv_addr_i <= (others => '0');
      elsif(conv_ce_i = '1') then
        conv_addr_i <= conv_addr_i + 1;
      end if;
    end if;
  end process;

  conv_addr <= std_logic_vector(conv_addr_i);

  -- Last read; although last_strb seems complex, each bit generated should be
  -- a simple LUT with 3 inputs (SUBWORD_WIDTH = 3)
  process(axi_clk)
    constant zeros : std_logic_vector(SUBWORD_WIDTH-1 downto 0) := (others => '0');
    variable aux   : integer range 0 to (2**SUBWORD_WIDTH)-1;
  begin
    if(axi_clk'event and axi_clk = '1') then
      if(init_cnt = '1') then
        aux := to_integer(unsigned(conv_size(SUBWORD_WIDTH-1 downto 0)));
        if(aux = 0) then
          full_last_word <= '1';
          last_strb      <= (others => '1');
        else
          full_last_word <= '0';
          last_strb      <= std_logic_vector(to_unsigned(2**aux-1, STRB_WIDTH));
        end if;
      end if;
    end if;
  end process;

  last_word <= word_cnt_1 when (full_last_word = '1') else word_cnt_0;

  -- This module behaves like a two-stage pipeline
  -- first stage is BRAM outputs (from multibuffer)
  -- second stage is te registered output of the module

  -- TAP 1: BRAM output
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk = '1') then
      if (axi_rst = '1') then
        conv_data_vld  <= '0';
        conv_data_last <= '0';
        conv_data_strb <= (others => '0');
      elsif(conv_data_vld = '0' or dout_vld = '0' or (dout_vld and dout_rdy) = '1') then
        -- this tage happens if any of the following conditions:
        -- 1.- stage is empty => refresh continous of the input values to the stage
        -- 2.- next stage is empty => data in this stage move to next stage
        -- 3.- pipeline moves => consumed data in last stage
        conv_data_vld  <= conv_ce_i;
        conv_data_last <= last_word;
        if(last_word = '1') then
          conv_data_strb <= last_strb;
        else
          conv_data_strb <= (others => '1');
        end if;
      end if;
    end if;
  end process;

  -- TAP 2: Output register.
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk = '1') then
      if (axi_rst = '1') then
        dout_vld <= '0';
      elsif(dout_vld = '0' or (dout_vld and dout_rdy) = '1') then
        dout_vld <= conv_data_vld;
      end if;
    end if;
  end process;

  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk = '1') then
      if(dout_vld = '0' or (dout_vld and dout_rdy) = '1') then
        dout      <= conv_data;
        dout_last <= conv_data_last;
        dout_strb <= conv_data_strb;
      end if;
    end if;
  end process;

  -- Control of reads during filling the pipe:
  process(axi_clk)
  begin
    if (axi_clk'event and axi_clk = '1') then
      if (axi_rst = '1') then
        fill_pipe <= '0';
      else
        if(dout_vld = '1') then          -- last stage is busy 
          -- Stop if  first stage is full or about to be filled (new data coming)
          fill_pipe <= not(conv_data_vld or conv_ce_i);
        elsif(conv_data_vld = '1') then  -- second to last stage busy
          -- if new data coming, stop reads
          fill_pipe <= not(conv_ce_i);
        else                             -- pipe is empty 
          fill_pipe <= '1';
        end if;
      end if;
    end if;
  end process;

  -- FSM:
  process(axi_clk, axi_rst)
  begin
    if(axi_rst = '1') then
      state <= idle;
    elsif(axi_clk'event and axi_clk = '1') then
      case state is
        when idle =>
          if(conv_rdy = '1') then
            state <= running;
          end if;
        when running =>
          if(last_word = '1' and conv_ce_i = '1') then
            --state <= idle;
              state <= wait_last;
          end if;
        when wait_last =>
          if(dout_last = '1' and axis_rdy = '1') then
             state <= idle;
          end if;
        when others =>
      end case;
    end if;
  end process;

  process(state, conv_rdy, last_word, dout_vld, dout_rdy, fill_pipe)
  begin
    init_cnt  <= '0';
    conv_last <= '0';
    conv_ce_i <= '0';
    case state is
      when idle =>
        -- init_cnt <= conv_rdy;
        init_cnt <= '1';
      when running =>
        conv_ce_i <= (dout_vld and dout_rdy) or fill_pipe;
        conv_last <= last_word and ((dout_vld and dout_rdy) or fill_pipe);
      when others =>
    end case;
  end process;

  conv_ce <= conv_ce_i;

  axis_vld  <= dout_vld;
  dout_rdy  <= axis_rdy;
  axis_data <= dout;
  axis_keep <= dout_strb;
  axis_strb <= dout_strb;
  axis_last <= dout_last;
  axis_id   <= (others => '0');
  axis_dest <= host_oarg_tdest;
  axis_user <= (others => '0');

end rtl;

