-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : xd_iarg_s2s_adapter.vhd
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
use axis_accelerator_adapter_v2_1_6.s2s_async_fifo_wt;

entity xd_iarg_s2s_adapter is
  generic (
    -- System generics:
    C_FAMILY             : string := "virtex6";  -- Xilinx FPGA family
    C_MTBF_STAGES        : integer;
    C_S_AXIS_TDATA_WIDTH : integer;
    C_S_AXIS_TUSER_WIDTH : integer;
    C_S_AXIS_TID_WIDTH   : integer;
    C_S_AXIS_TDEST_WIDTH : integer;
    C_AP_ARG_DATA_WIDTH  : integer;
    C_AP_ARG_ADDR_WIDTH  : integer;
    C_MULTIBUFFER_DEPTH  : integer);
  port (
    -- Input streams
    S_AXIS_ACLK     : in  std_logic;
    S_AXIS_ARESETN  : in  std_logic;
    S_AXIS_TVALID   : in  std_logic;
    S_AXIS_TREADY   : out std_logic;
    S_AXIS_TDATA    : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    S_AXIS_TSTRB    : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0);
    S_AXIS_TKEEP    : in  std_logic_vector(C_S_AXIS_TDATA_WIDTH/8-1 downto 0);
    S_AXIS_TLAST    : in  std_logic;
    S_AXIS_TID      : in  std_logic_vector(C_S_AXIS_TID_WIDTH-1 downto 0);
    S_AXIS_TDEST    : in  std_logic_vector(C_S_AXIS_TDEST_WIDTH-1 downto 0);
    S_AXIS_TUSER    : in  std_logic_vector(C_S_AXIS_TUSER_WIDTH-1 downto 0);
    ---
    ap_clk          : in  std_logic;
    ap_rst          : in  std_logic;
    ap_iarg_dout    : out std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    ap_iarg_re      : in  std_logic;
    ap_iarg_empty_n : out std_logic;
    mb_arg_rdy      : out std_logic;
    mb_arg_done     : in  std_logic);
end entity;

architecture rtl of xd_iarg_s2s_adapter is

  signal axis_rst : std_logic;
  signal axis_rst1 : std_logic;
      ATTRIBUTE async_reg           : STRING;
        ATTRIBUTE async_reg OF axis_rst1    : SIGNAL IS "true"; 
      ATTRIBUTE async_reg OF axis_rst    : SIGNAL IS "true"; 

begin

  mb_arg_rdy <= '1';

  --axis_rst <= not(S_AXIS_ARESETN);

      prd1: PROCESS (S_AXIS_ACLK, S_AXIS_ARESETN)
      BEGIN
       -- Register Stage #1 
        IF (S_AXIS_ARESETN = '0') THEN
          axis_rst1 <= '1';
          axis_rst <= '1';
        ELSIF (S_AXIS_ACLK'event and S_AXIS_ACLK = '1') THEN
          axis_rst1 <= '0';
          axis_rst <= axis_rst1;
        END IF;
        END PROCESS prd1;


  SAME_WIDTH_GEN : if (C_S_AXIS_TDATA_WIDTH = C_AP_ARG_DATA_WIDTH) generate
    constant FIFO_DATA_LSB : integer := 0;
    constant FIFO_DATA_MSB : integer := C_S_AXIS_TDATA_WIDTH-1;
    constant FIFO_LAST_BIT : integer := FIFO_DATA_MSB+1;
    constant FIFO_WIDTH    : integer := FIFO_LAST_BIT+1;

    signal fifo_din      : std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal fifo_dout     : std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal fifo_dout_vld : std_logic;
    signal fifo_dout_rdy : std_logic;

    -- FIFO depth calculation
    constant FIFO_DEPTH : integer := (2**C_AP_ARG_ADDR_WIDTH)-1;

  begin

    fifo_din(FIFO_DATA_MSB downto FIFO_DATA_LSB) <= S_AXIS_TDATA;
    fifo_din(FIFO_LAST_BIT)                      <= S_AXIS_TLAST;

    FIFO_I : entity axis_accelerator_adapter_v2_1_6.s2s_async_fifo_wt
      generic map (
        C_FAMILY => C_FAMILY,
        C_MTBF_STAGES   => C_MTBF_STAGES, 
        DEPTH    => FIFO_DEPTH,
        WIDTH    => FIFO_WIDTH)
      port map (
        din      => fifo_din,
        din_vld  => S_AXIS_TVALID,
        din_rdy  => S_AXIS_TREADY,
        wr_clk   => S_AXIS_ACLK,
        wr_rst   => axis_rst,
        dout     => fifo_dout,
        dout_vld => fifo_dout_vld,
        dout_rdy => fifo_dout_rdy,
        rd_clk   => ap_clk,
        rd_rst   => ap_rst);

    ap_iarg_dout    <= fifo_dout(FIFO_DATA_MSB downto FIFO_DATA_LSB);
    ap_iarg_empty_n <= fifo_dout_vld;
    fifo_dout_rdy   <= ap_iarg_re;

  end generate SAME_WIDTH_GEN;

  AXI_WIDER_GEN : if (C_S_AXIS_TDATA_WIDTH > C_AP_ARG_DATA_WIDTH) generate
    constant WORDS_PER_BEAT : integer := C_S_AXIS_TDATA_WIDTH/C_AP_ARG_DATA_WIDTH;
    constant WORD_CNT_WIDTH : integer := log2(WORDS_PER_BEAT);
    constant REM_WIDTH      : integer := WORD_CNT_WIDTH;
    constant FIFO_DATA_LSB  : integer := 0;
    constant FIFO_DATA_MSB  : integer := C_S_AXIS_TDATA_WIDTH-1;
    constant FIFO_REM_LSB   : integer := FIFO_DATA_MSB+1;
    constant FIFO_REM_MSB   : integer := FIFO_REM_LSB+REM_WIDTH-1;
    constant FIFO_LAST_BIT  : integer := FIFO_REM_MSB+1;
    constant FIFO_WIDTH     : integer := FIFO_LAST_BIT+1;
    -- Output register is an additional position to the FIFO. Substract one.
    constant DATA_RATIO     : integer := C_S_AXIS_TDATA_WIDTH/C_AP_ARG_DATA_WIDTH;
    constant FIFO_DEPTH     : integer := (2**(C_AP_ARG_ADDR_WIDTH-log2(DATA_RATIO)))-1;

    signal word_cnt : unsigned(WORD_CNT_WIDTH-1 downto 0);
    signal word_inc : std_logic;
    signal axi_rem  : std_logic_vector(REM_WIDTH-1 downto 0);

    signal fifo_din      : std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal fifo_dout     : std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal fifo_dout_vld : std_logic;
    signal fifo_dout_rdy : std_logic;

    -- Ouput for decoupling fifo
    signal ap_data : std_logic_vector(C_S_AXIS_TDATA_WIDTH-1 downto 0);
    signal ap_rem  : std_logic_vector(REM_WIDTH-1 downto 0);
    signal ap_last : std_logic;

    signal dout     : std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    signal dout_ce  : std_logic;
    signal dout_vld : std_logic;
    signal dout_rdy : std_logic;

  begin

    -- This logic should generate a set of LUTs (w.c. 8 inputs, 3 outputs)
    process(S_AXIS_TKEEP)
      constant BYTES_PER_WORD : integer                                     := C_AP_ARG_DATA_WIDTH/8;
      constant ones           : std_logic_vector(BYTES_PER_WORD-1 downto 0) := (others => '1');
      variable aux            : integer range 0 to WORDS_PER_BEAT-1;
    begin
      aux := 0;
      for i in 0 to WORDS_PER_BEAT-1 loop
        if(S_AXIS_TKEEP(BYTES_PER_WORD*(i+1)-1 downto BYTES_PER_WORD*i) = ones) then
          aux := i;
        else
          exit;
        end if;
      end loop;
      axi_rem <= std_logic_vector(to_unsigned(aux, WORD_CNT_WIDTH));
    end process;

    fifo_din(FIFO_DATA_MSB downto FIFO_DATA_LSB) <= S_AXIS_TDATA;
    fifo_din(FIFO_REM_MSB downto FIFO_REM_LSB)   <= axi_rem;
    fifo_din(FIFO_LAST_BIT)                      <= S_AXIS_TLAST;

    FIFO_I : entity axis_accelerator_adapter_v2_1_6.s2s_async_fifo_wt
      generic map (
        C_FAMILY => C_FAMILY,
        C_MTBF_STAGES   => C_MTBF_STAGES, 
        DEPTH    => FIFO_DEPTH,
        WIDTH    => FIFO_WIDTH)
      port map (
        din      => fifo_din,
        din_vld  => S_AXIS_TVALID,
        din_rdy  => S_AXIS_TREADY,
        wr_clk   => S_AXIS_ACLK,
        wr_rst   => axis_rst,
        dout     => fifo_dout,
        dout_vld => fifo_dout_vld,
        dout_rdy => fifo_dout_rdy,
        rd_clk   => ap_clk,
        rd_rst   => ap_rst);

    ap_data <= fifo_dout(FIFO_DATA_MSB downto FIFO_DATA_LSB);
    ap_rem  <= fifo_dout(FIFO_REM_MSB downto FIFO_REM_LSB);
    ap_last <= fifo_dout(FIFO_LAST_BIT);

    -- Set the output register when output is not valid or if it's valid it's
    -- being taken (same cycle)
    dout_ce <= not(dout_vld) or (dout_vld and dout_rdy);

    -- Take output of the fifo when we move to the output the last word of the
    -- beat
    fifo_dout_rdy <= dout_ce when (word_cnt = unsigned(ap_rem)) else '0';

    -- Increment word counter when we transfer one word at the output
    word_inc <= fifo_dout_vld and dout_ce;

    -- Counter of words transferd to output port:
    process(ap_clk, ap_rst)
    begin
      if(ap_rst = '1') then
        word_cnt <= (others => '0');
      elsif(ap_clk'event and ap_clk = '1') then
        if(word_inc = '1') then
          if(word_cnt = unsigned(ap_rem)) then
            word_cnt <= (others => '0');
          else
            word_cnt <= word_cnt + 1;
          end if;
        end if;
      end if;
    end process;

    process(ap_clk, ap_rst)
    begin
      if(ap_rst = '1') then
        dout_vld <= '0';
      elsif(ap_clk'event and ap_clk = '1') then
        if(dout_ce = '1') then
          dout_vld <= fifo_dout_vld;
        end if;
      end if;
    end process;

    -- Register + mux for output port
    process(ap_clk, ap_rst)
    begin
      if(ap_rst = '1') then
        dout <= (others => '0');
      elsif(ap_clk'event and ap_clk = '1') then
        if(dout_ce = '1') then
          for i in 0 to WORDS_PER_BEAT-1 loop
            if(i = word_cnt) then
              dout <= fifo_dout(C_AP_ARG_DATA_WIDTH*(i+1)-1 downto C_AP_ARG_DATA_WIDTH*i);
            end if;
          end loop;
        end if;
      end if;
    end process;

    ap_iarg_dout    <= dout;
    ap_iarg_empty_n <= dout_vld;
    dout_rdy        <= ap_iarg_re;

  end generate AXI_WIDER_GEN;

  AXI_NARROWER_GEN : if (C_S_AXIS_TDATA_WIDTH < C_AP_ARG_DATA_WIDTH) generate
    constant BEATS_PER_WORD : integer := C_AP_ARG_DATA_WIDTH/C_S_AXIS_TDATA_WIDTH;
    constant FIFO_DATA_LSB  : integer := 0;
    constant FIFO_DATA_MSB  : integer := C_AP_ARG_DATA_WIDTH-1;
    constant FIFO_WIDTH     : integer := FIFO_DATA_MSB+1;

    signal beat_sel  : std_logic_vector(BEATS_PER_WORD-1 downto 0);
    signal tap_0     : std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    signal tap_0_we  : std_logic;
    signal tap_0_vld : std_logic;
    signal tap_0_rdy : std_logic;
    signal axis_vld  : std_logic;
    signal axis_rdy  : std_logic;

    signal fifo_din      : std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal fifo_din_vld  : std_logic;
    signal fifo_din_rdy  : std_logic;
    signal fifo_dout     : std_logic_vector(FIFO_WIDTH-1 downto 0);
    signal fifo_dout_vld : std_logic;
    signal fifo_dout_rdy : std_logic;

    -- register tap_0 is an extra position to the fifo. substract 1.
    constant FIFO_DEPTH : integer := (2**C_AP_ARG_ADDR_WIDTH)-1;

  begin

    axis_vld      <= S_AXIS_TVALID;
    S_AXIS_TREADY <= axis_rdy;

    process(S_AXIS_ACLK)
    begin
      if(S_AXIS_ACLK'event and S_AXIS_ACLK = '1') then
        if(axis_rst = '1' or (S_AXIS_TLAST and tap_0_we) = '1') then
          beat_sel    <= (others => '0');
          beat_sel(0) <= '1';
        elsif(tap_0_we = '1') then
          beat_sel <= beat_sel(BEATS_PER_WORD-2 downto 0) & beat_sel(BEATS_PER_WORD-1);
        end if;
      end if;
    end process;

    process(S_AXIS_ACLK)
    begin
      if(S_AXIS_ACLK'event and S_AXIS_ACLK = '1') then
        if(tap_0_we = '1') then
          for i in 0 to BEATS_PER_WORD-1 loop
            if(beat_sel(i) = '1') then
              tap_0(C_S_AXIS_TDATA_WIDTH*(i+1)-1 downto C_S_AXIS_TDATA_WIDTH*i) <= S_AXIS_TDATA;
            end if;
          end loop;
        end if;
      end if;
    end process;

    process(S_AXIS_ACLK, axis_rst)
    begin
      if(axis_rst = '1') then
        tap_0_vld <= '0';
      elsif(S_AXIS_ACLK'event and S_AXIS_ACLK = '1') then
        if(tap_0_vld = '0' or (tap_0_vld and tap_0_rdy) = '1') then
          tap_0_vld <= tap_0_we and (beat_sel(BEATS_PER_WORD-1) or S_AXIS_TLAST);
        end if;
      end if;
    end process;

    -- We accept new input data when:
    --  1. tap_0 is empty
    --  2. tap_0 is full but it's content is being moved to fifo
    axis_rdy <= not(tap_0_vld) or (tap_0_vld and fifo_din_rdy);

    -- under this conditions, a new write will occur on tap_0, if additionally
    -- there is a new data at the input
    tap_0_we <= axis_vld and (not(tap_0_vld) or (tap_0_vld and fifo_din_rdy));

    -- fifo shows a data valid at the input when tap_0 is valid
    fifo_din_vld <= tap_0_vld;

    -- take tap_0 when it's moved the data to the fifo:
    tap_0_rdy <= fifo_din_vld and fifo_din_rdy;


    fifo_din(FIFO_DATA_MSB downto FIFO_DATA_LSB) <= tap_0;

    FIFO_I : entity axis_accelerator_adapter_v2_1_6.s2s_async_fifo_wt
      generic map (
        C_FAMILY => C_FAMILY,
        C_MTBF_STAGES   => C_MTBF_STAGES, 
        DEPTH    => FIFO_DEPTH,
        WIDTH    => FIFO_WIDTH)
      port map (
        din      => fifo_din,
        din_vld  => fifo_din_vld,
        din_rdy  => fifo_din_rdy,
        wr_clk   => S_AXIS_ACLK,
        wr_rst   => axis_rst,
        dout     => fifo_dout,
        dout_vld => fifo_dout_vld,
        dout_rdy => fifo_dout_rdy,
        rd_clk   => ap_clk,
        rd_rst   => ap_rst);

    ap_iarg_dout    <= fifo_dout(FIFO_DATA_MSB downto FIFO_DATA_LSB);
    ap_iarg_empty_n <= fifo_dout_vld;

    fifo_dout_rdy <= ap_iarg_re;

  end generate AXI_NARROWER_GEN;

end rtl;

