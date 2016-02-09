-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : s2s_async_fifo_wt.vhd
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

library fifo_generator_v13_0_1;
use fifo_generator_v13_0_1.all;



entity s2s_async_fifo_wt is
  generic (
    C_FAMILY : string  := "virtex6";
    C_MTBF_STAGES    : integer := 31;
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
end s2s_async_fifo_wt;

architecture rtl of s2s_async_fifo_wt is

  constant FIFO_DEPTH : integer := calc_fifo_depth(DEPTH)+1;
  constant ADDR_BITS  : integer := log2(FIFO_DEPTH);

  signal rd_addr : unsigned(ADDR_BITS-1 downto 0);
  signal wr_addr : unsigned(ADDR_BITS-1 downto 0);

  -- Following signals have gray values
  signal wr_cnt      : std_logic_vector(ADDR_BITS-1 downto 0);
  signal wr_cnt_wr      : std_logic_vector(ADDR_BITS-1 downto 0);
  signal wr_cnt_rd   : std_logic_vector(ADDR_BITS-1 downto 0);
  signal next_wr_cnt : std_logic_vector(ADDR_BITS-1 downto 0);
  signal next_wr_cnt_wr : std_logic_vector(ADDR_BITS-1 downto 0);
  signal dummy_next_wr_cnt : std_logic_vector(ADDR_BITS-1 downto 0);
  signal rd_cnt      : std_logic_vector(ADDR_BITS-1 downto 0);
  signal rd_cnt_rd      : std_logic_vector(ADDR_BITS-1 downto 0);
  signal next_rd_cnt : std_logic_vector(ADDR_BITS-1 downto 0);
  signal next_rd_cnt_rd : std_logic_vector(ADDR_BITS-1 downto 0);
  signal dummy_next_rd_cnt : std_logic_vector(ADDR_BITS-1 downto 0);
  signal prev_rd_cnt : std_logic_vector(ADDR_BITS-1 downto 0);
  signal prev_rd_cnt_wr : std_logic_vector(ADDR_BITS-1 downto 0);
  signal fifo_we     : std_logic;
  signal fifo_re     : std_logic;
  signal din_rdy_i   : std_logic;
  signal empty_i     : std_logic;
  signal rd_en       : std_logic;
  signal dout_vld_i  : std_logic;
  signal full  : std_logic;
  signal empty  : std_logic;
  
  signal almost_full :std_logic;    
  signal wr_ack :std_logic;    
  signal overflow :std_logic;    
  signal almost_empty :std_logic;    
  signal valid :std_logic;    
  signal underflow :std_logic;    
  signal data_count :std_logic_vector(ADDR_BITS-1 downto 0);    
  signal rd_data_count :std_logic_vector(ADDR_BITS-1 downto 0);    
  signal wr_data_count :std_logic_vector(ADDR_BITS-1 downto 0);    
  signal prog_full :std_logic;    
  signal prog_empty :std_logic;    
  signal sbiterr :std_logic;    
  signal dbiterr :std_logic;    
  signal wr_rst_busy :std_logic;    
  signal rd_rst_busy :std_logic;    
  signal m_axi_awid :std_logic_vector(0 downto 0);    
  signal m_axi_awaddr :std_logic_vector(31 downto 0);    
  signal m_axi_awlen :std_logic_vector(7 downto 0);    
  signal m_axi_awsize :std_logic_vector(2 downto 0);    
  signal m_axi_awburst :std_logic_vector(1 downto 0);    
  signal m_axi_awlock :std_logic_vector(0 downto 0);    
  signal m_axi_awcache :std_logic_vector(3 downto 0);    
  signal m_axi_awprot :std_logic_vector(2 downto 0);    
  signal m_axi_awqos :std_logic_vector(3 downto 0);    
  signal m_axi_awregion :std_logic_vector(3 downto 0);    
  signal m_axi_awuser :std_logic_vector(0 downto 0);    
  signal m_axi_awvalid :std_logic;
  signal m_axi_wid :std_logic_vector(0 downto 0);    
  signal m_axi_wdata :std_logic_vector(63 downto 0);    
  signal m_axi_wstrb :std_logic_vector(7 downto 0);    
  signal m_axi_wlast :std_logic;
  signal m_axi_wuser :std_logic_vector(0 downto 0);    
  signal m_axi_wvalid :std_logic;
  signal m_axi_bready :std_logic;
  signal s_axi_awready :std_logic;
  signal s_axi_wready :std_logic;
  signal s_axi_bid :std_logic_vector(0 downto 0);    
  signal s_axi_bresp :std_logic_vector(1 downto 0);    
  signal s_axi_buser :std_logic_vector(0 downto 0);    
  signal m_axi_arid :std_logic_vector(0 downto 0);    
  signal m_axi_araddr :std_logic_vector(31 downto 0);    
  signal m_axi_arlen :std_logic_vector(7 downto 0);    
  signal m_axi_arsize :std_logic_vector(2 downto 0);    
  signal m_axi_arburst :std_logic_vector(1 downto 0);    
  signal m_axi_arlock :std_logic_vector(0 downto 0);    
  signal m_axi_arcache :std_logic_vector(3 downto 0);    
  signal m_axi_arprot :std_logic_vector(2 downto 0);    
  signal m_axi_arqos :std_logic_vector(3 downto 0);    
  signal m_axi_arregion :std_logic_vector(3 downto 0);    
  signal m_axi_aruser :std_logic_vector(0 downto 0);    
  signal m_axi_arvalid :std_logic;
  signal m_axi_rready :std_logic;
  signal s_axi_arready :std_logic;
  signal s_axi_rid :std_logic_vector(0 downto 0);    
  signal s_axi_rdata :std_logic_vector(63 downto 0);    
  signal s_axi_rresp :std_logic_vector(1 downto 0);    
  signal s_axi_rlast :std_logic;
  signal s_axi_ruser :std_logic_vector(0 downto 0);    
  signal m_axis_tvalid :std_logic;
  signal m_axis_tdata :std_logic_vector(7 downto 0);    
  signal m_axis_tstrb :std_logic_vector(0 downto 0);    
  signal m_axis_tlast :std_logic;
  signal m_axis_tkeep :std_logic_vector(0 downto 0);    
  signal m_axis_tid :std_logic_vector(0 downto 0);    
  signal m_axis_tdest :std_logic_vector(0 downto 0);    
  signal m_axis_tuser :std_logic_vector(3 downto 0);    
  signal s_axis_tready :std_logic;
  signal axi_aw_data_count :std_logic_vector(4 downto 0);    
  signal axi_aw_wr_data_count :std_logic_vector(4 downto 0);    
  signal axi_aw_rd_data_count :std_logic_vector(4 downto 0);    
  signal axi_aw_sbiterr :std_logic;    
  signal axi_aw_dbiterr :std_logic;    
  signal axi_aw_overflow :std_logic;    
  signal axi_aw_underflow :std_logic;    
  signal axi_aw_prog_full :std_logic;    
  signal axi_aw_prog_empty :std_logic;    
  signal axi_w_data_count :std_logic_vector(10 downto 0);    
  signal axi_w_wr_data_count :std_logic_vector(10 downto 0);    
  signal axi_w_rd_data_count :std_logic_vector(10 downto 0);    
  signal axi_w_sbiterr :std_logic;    
  signal axi_w_dbiterr :std_logic;    
  signal axi_w_overflow :std_logic;    
  signal axi_w_underflow :std_logic;    
  signal axi_w_prog_full :std_logic;    
  signal axi_w_prog_empty :std_logic;    
  signal axi_b_data_count :std_logic_vector(4 downto 0);    
  signal axi_b_wr_data_count :std_logic_vector(4 downto 0);    
  signal axi_b_rd_data_count :std_logic_vector(4 downto 0);    
  signal axi_b_sbiterr :std_logic;    
  signal axi_b_dbiterr :std_logic;    
  signal axi_b_overflow :std_logic;    
  signal axi_b_underflow :std_logic;    
  signal axi_b_prog_full :std_logic;    
  signal axi_b_prog_empty :std_logic;    
  signal axi_ar_data_count :std_logic_vector(4 downto 0);    
  signal axi_ar_wr_data_count :std_logic_vector(4 downto 0);    
  signal axi_ar_rd_data_count :std_logic_vector(4 downto 0);    
  signal axi_ar_sbiterr :std_logic;    
  signal axi_ar_dbiterr :std_logic;    
  signal axi_ar_overflow :std_logic;    
  signal axi_ar_underflow :std_logic;    
  signal axi_ar_prog_full :std_logic;    
  signal axi_ar_prog_empty :std_logic;    
  signal axi_r_data_count :std_logic_vector(10 downto 0);    
  signal axi_r_wr_data_count :std_logic_vector(10 downto 0);    
  signal axi_r_rd_data_count :std_logic_vector(10 downto 0);    
  signal axi_r_sbiterr :std_logic;    
  signal axi_r_dbiterr :std_logic;    
  signal axi_r_overflow :std_logic;    
  signal axi_r_underflow :std_logic;    
  signal axi_r_prog_full :std_logic;    
  signal axi_r_prog_empty :std_logic;    
  signal axis_data_count :std_logic_vector(10 downto 0);    
  signal axis_wr_data_count :std_logic_vector(10 downto 0);    
  signal axis_rd_data_count :std_logic_vector(10 downto 0);    
  signal axis_sbiterr :std_logic;    
  signal axis_dbiterr :std_logic;    
  signal axis_overflow :std_logic;    
  signal axis_underflow :std_logic;    
  signal axis_prog_full :std_logic;    
  signal axis_prog_empty :std_logic;    



  function calc_ram_style(is_unidir : natural) return boolean is
    variable bram_style : boolean := false;
  begin
    return bram_style;
  end function calc_ram_style;

  constant USE_BRAM : boolean := (ADDR_BITS > 5);

  -- pragma translate_off
  signal dbg_ADDR_BITS : integer := ADDR_BITS;
  -- pragma translate_on
  constant C_EXTRA_SYNCS      : integer := 1;

begin

EXISTING : if (C_EXTRA_SYNCS = 0) generate
 begin  

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

-- process(rd_clk, rd_rst)
--  begin
--    if(rd_rst = '1') then
--      wr_cnt_rd   <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
--      dummy_next_wr_cnt<= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
--    elsif(rd_clk'event and rd_clk = '1') then
--      --if(fifo_we = '1') then
--        dummy_next_wr_cnt <= bin2gray(std_logic_vector(wr_addr));
--        wr_cnt_rd      <= dummy_next_wr_cnt;
--      --end if;
--    end if;
--  end process;

        --dummy_next_rd_cnt <= bin2gray(std_logic_vector(rd_addr));

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

--  process(wr_clk, wr_rst)
--  begin
--    if(wr_rst = '1') then
--      prev_rd_cnt_wr   <= bin2gray(2**ADDR_BITS-3, ADDR_BITS);
--      dummy_next_rd_cnt<= bin2gray(2**ADDR_BITS-3, ADDR_BITS);
--    elsif(rd_clk'event and rd_clk = '1') then
--      --if(fifo_re = '1') then
--        dummy_next_rd_cnt <= bin2gray(std_logic_vector(rd_addr ));
--        prev_rd_cnt_wr      <= dummy_next_rd_cnt;
--      --end if;
--    end if;
--  end process;

        --dummy_next_wr_cnt <= bin2gray(std_logic_vector(wr_addr));

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

  DIST_MEM_GEN : if not(USE_BRAM) generate
    type   mem_type is array (2**ADDR_BITS-1 downto 0) of std_logic_vector (WIDTH-1 downto 0);
    signal mem                 : mem_type;
    attribute ram_style        : string;
    attribute ram_style of mem : signal is "distributed";

    signal mem_dout : std_logic_vector(WIDTH-1 downto 0);

  begin

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

  end generate DIST_MEM_GEN;

  BRAM_MEM_GEN : if (USE_BRAM) generate
    type   mem_type is array (2**ADDR_BITS-1 downto 0) of std_logic_vector (WIDTH-1 downto 0);
    signal mem                 : mem_type;
    attribute ram_style        : string;
    attribute ram_style of mem : signal is "block";
  begin

    process(wr_clk)
    begin
      if(wr_clk'event and wr_clk = '1') then
        if(fifo_we = '1') then
          mem(to_integer(wr_addr)) <= din;
        end if;
      end if;
    end process;

    process(rd_clk, rd_rst)
    begin
      if(rd_rst = '1') then
        dout <= (others => '0');
      elsif(rd_clk'event and rd_clk = '1') then
        if(fifo_re = '1') then
          dout <= mem(to_integer(rd_addr));
        end if;
      end if;
    end process;

  end generate BRAM_MEM_GEN;
end generate EXISTING;

  NEW_INTRO : if (C_EXTRA_SYNCS = 1) generate
 begin  

       din_rdy  <= not(full);
    dout_vld <= not(empty);


  DIST_MEM_GEN : if not(USE_BRAM) generate
  begin
   FIF_DMG_INST : entity fifo_generator_v13_0_1.fifo_generator_v13_0_1
    GENERIC MAP (
      C_COMMON_CLOCK => 0,
      C_COUNT_TYPE => 0,
      C_DATA_COUNT_WIDTH => ADDR_BITS,
      C_DEFAULT_VALUE => "BlankString",
      C_DIN_WIDTH => WIDTH,
      C_DOUT_RST_VAL => "0",
      C_DOUT_WIDTH => WIDTH,
      C_ENABLE_RLOCS => 0,
      C_FAMILY => C_FAMILY,
      C_FULL_FLAGS_RST_VAL => 0,
      C_HAS_ALMOST_EMPTY => 0,
      C_HAS_ALMOST_FULL => 0,
      C_HAS_BACKUP => 0,
      C_HAS_DATA_COUNT => 0,
      C_HAS_INT_CLK => 0,
      C_HAS_MEMINIT_FILE => 0,
      C_HAS_OVERFLOW => 0,
      C_HAS_RD_DATA_COUNT => 0,
      C_HAS_RD_RST => 0,
      C_HAS_RST => 1,
      C_HAS_SRST => 0,
      C_HAS_UNDERFLOW => 0,
      C_HAS_VALID => 0,
      C_HAS_WR_ACK => 0,
      C_HAS_WR_DATA_COUNT => 0,
      C_HAS_WR_RST => 0,
      C_IMPLEMENTATION_TYPE => 2,
      C_INIT_WR_PNTR_VAL => 0,
      C_MEMORY_TYPE => 2,
      C_MIF_FILE_NAME => "BlankString",
      C_OPTIMIZATION_MODE => 0,
      C_OVERFLOW_LOW => 0,
      C_PRELOAD_LATENCY => 0,
      C_PRELOAD_REGS => 1,
      C_PRIM_FIFO_TYPE => "512x36",
      C_PROG_EMPTY_THRESH_ASSERT_VAL => 2,
      C_PROG_EMPTY_THRESH_NEGATE_VAL => 3,
      C_PROG_EMPTY_TYPE => 0,
      C_PROG_FULL_THRESH_ASSERT_VAL => 29,
      C_PROG_FULL_THRESH_NEGATE_VAL => 28,
      C_PROG_FULL_TYPE => 0,
      C_RD_DATA_COUNT_WIDTH => ADDR_BITS,
      C_RD_DEPTH => FIFO_DEPTH,
      C_RD_FREQ => 1,
      C_RD_PNTR_WIDTH => ADDR_BITS,
      C_UNDERFLOW_LOW => 0,
      C_USE_DOUT_RST => 1,
      C_USE_ECC => 0,
      C_USE_EMBEDDED_REG => 0,
      C_USE_PIPELINE_REG => 0,
      C_POWER_SAVING_MODE => 0,
      C_USE_FIFO16_FLAGS => 0,
      C_USE_FWFT_DATA_COUNT => 0,
      C_VALID_LOW => 0,
      C_WR_ACK_LOW => 0,
      C_WR_DATA_COUNT_WIDTH => ADDR_BITS,
      C_WR_DEPTH => FIFO_DEPTH,
      C_WR_FREQ => 1,
      C_WR_PNTR_WIDTH => ADDR_BITS,
      C_WR_RESPONSE_LATENCY => 1,
      C_MSGON_VAL => 1,
      C_ENABLE_RST_SYNC => 0,
      C_ERROR_INJECTION_TYPE => 0,
      C_SYNCHRONIZER_STAGE => C_MTBF_STAGES,
      C_INTERFACE_TYPE => 0,
      C_AXI_TYPE => 1,
      C_HAS_AXI_WR_CHANNEL => 1,
      C_HAS_AXI_RD_CHANNEL => 1,
      C_HAS_SLAVE_CE => 0,
      C_HAS_MASTER_CE => 0,
      C_ADD_NGC_CONSTRAINT => 0,
      C_USE_COMMON_OVERFLOW => 0,
      C_USE_COMMON_UNDERFLOW => 0,
      C_USE_DEFAULT_SETTINGS => 0,
      C_AXI_ID_WIDTH => 1,
      C_AXI_ADDR_WIDTH => 32,
      C_AXI_DATA_WIDTH => 64,
      C_AXI_LEN_WIDTH => 8,
      C_AXI_LOCK_WIDTH => 1,
      C_HAS_AXI_ID => 0,
      C_HAS_AXI_AWUSER => 0,
      C_HAS_AXI_WUSER => 0,
      C_HAS_AXI_BUSER => 0,
      C_HAS_AXI_ARUSER => 0,
      C_HAS_AXI_RUSER => 0,
      C_AXI_ARUSER_WIDTH => 1,
      C_AXI_AWUSER_WIDTH => 1,
      C_AXI_WUSER_WIDTH => 1,
      C_AXI_BUSER_WIDTH => 1,
      C_AXI_RUSER_WIDTH => 1,
      C_HAS_AXIS_TDATA => 1,
      C_HAS_AXIS_TID => 0,
      C_HAS_AXIS_TDEST => 0,
      C_HAS_AXIS_TUSER => 1,
      C_HAS_AXIS_TREADY => 1,
      C_HAS_AXIS_TLAST => 0,
      C_HAS_AXIS_TSTRB => 0,
      C_HAS_AXIS_TKEEP => 0,
      C_AXIS_TDATA_WIDTH => 8,
      C_AXIS_TID_WIDTH => 1,
      C_AXIS_TDEST_WIDTH => 1,
      C_AXIS_TUSER_WIDTH => 4,
      C_AXIS_TSTRB_WIDTH => 1,
      C_AXIS_TKEEP_WIDTH => 1,
      C_WACH_TYPE => 0,
      C_WDCH_TYPE => 0,
      C_WRCH_TYPE => 0,
      C_RACH_TYPE => 0,
      C_RDCH_TYPE => 0,
      C_AXIS_TYPE => 0,
      C_IMPLEMENTATION_TYPE_WACH => 1,
      C_IMPLEMENTATION_TYPE_WDCH => 1,
      C_IMPLEMENTATION_TYPE_WRCH => 1,
      C_IMPLEMENTATION_TYPE_RACH => 1,
      C_IMPLEMENTATION_TYPE_RDCH => 1,
      C_IMPLEMENTATION_TYPE_AXIS => 1,
      C_APPLICATION_TYPE_WACH => 0,
      C_APPLICATION_TYPE_WDCH => 0,
      C_APPLICATION_TYPE_WRCH => 0,
      C_APPLICATION_TYPE_RACH => 0,
      C_APPLICATION_TYPE_RDCH => 0,
      C_APPLICATION_TYPE_AXIS => 0,
      C_PRIM_FIFO_TYPE_WACH => "512x36",
      C_PRIM_FIFO_TYPE_WDCH => "1kx36",
      C_PRIM_FIFO_TYPE_WRCH => "512x36",
      C_PRIM_FIFO_TYPE_RACH => "512x36",
      C_PRIM_FIFO_TYPE_RDCH => "1kx36",
      C_PRIM_FIFO_TYPE_AXIS => "1kx18",
      C_USE_ECC_WACH => 0,
      C_USE_ECC_WDCH => 0,
      C_USE_ECC_WRCH => 0,
      C_USE_ECC_RACH => 0,
      C_USE_ECC_RDCH => 0,
      C_USE_ECC_AXIS => 0,
      C_ERROR_INJECTION_TYPE_WACH => 0,
      C_ERROR_INJECTION_TYPE_WDCH => 0,
      C_ERROR_INJECTION_TYPE_WRCH => 0,
      C_ERROR_INJECTION_TYPE_RACH => 0,
      C_ERROR_INJECTION_TYPE_RDCH => 0,
      C_ERROR_INJECTION_TYPE_AXIS => 0,
      C_DIN_WIDTH_WACH => 32,
      C_DIN_WIDTH_WDCH => 64,
      C_DIN_WIDTH_WRCH => 2,
      C_DIN_WIDTH_RACH => 32,
      C_DIN_WIDTH_RDCH => 64,
      C_DIN_WIDTH_AXIS => 1,
      C_WR_DEPTH_WACH => 16,
      C_WR_DEPTH_WDCH => 1024,
      C_WR_DEPTH_WRCH => 16,
      C_WR_DEPTH_RACH => 16,
      C_WR_DEPTH_RDCH => 1024,
      C_WR_DEPTH_AXIS => 1024,
      C_WR_PNTR_WIDTH_WACH => 4,
      C_WR_PNTR_WIDTH_WDCH => 10,
      C_WR_PNTR_WIDTH_WRCH => 4,
      C_WR_PNTR_WIDTH_RACH => 4,
      C_WR_PNTR_WIDTH_RDCH => 10,
      C_WR_PNTR_WIDTH_AXIS => 10,
      C_HAS_DATA_COUNTS_WACH => 0,
      C_HAS_DATA_COUNTS_WDCH => 0,
      C_HAS_DATA_COUNTS_WRCH => 0,
      C_HAS_DATA_COUNTS_RACH => 0,
      C_HAS_DATA_COUNTS_RDCH => 0,
      C_HAS_DATA_COUNTS_AXIS => 0,
      C_HAS_PROG_FLAGS_WACH => 0,
      C_HAS_PROG_FLAGS_WDCH => 0,
      C_HAS_PROG_FLAGS_WRCH => 0,
      C_HAS_PROG_FLAGS_RACH => 0,
      C_HAS_PROG_FLAGS_RDCH => 0,
      C_HAS_PROG_FLAGS_AXIS => 0,
      C_PROG_FULL_TYPE_WACH => 0,
      C_PROG_FULL_TYPE_WDCH => 0,
      C_PROG_FULL_TYPE_WRCH => 0,
      C_PROG_FULL_TYPE_RACH => 0,
      C_PROG_FULL_TYPE_RDCH => 0,
      C_PROG_FULL_TYPE_AXIS => 0,
      C_PROG_FULL_THRESH_ASSERT_VAL_WACH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_WDCH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_WRCH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_RACH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_RDCH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_AXIS => 1023,
      C_PROG_EMPTY_TYPE_WACH => 0,
      C_PROG_EMPTY_TYPE_WDCH => 0,
      C_PROG_EMPTY_TYPE_WRCH => 0,
      C_PROG_EMPTY_TYPE_RACH => 0,
      C_PROG_EMPTY_TYPE_RDCH => 0,
      C_PROG_EMPTY_TYPE_AXIS => 0,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS => 1022,
      C_REG_SLICE_MODE_WACH => 0,
      C_REG_SLICE_MODE_WDCH => 0,
      C_REG_SLICE_MODE_WRCH => 0,
      C_REG_SLICE_MODE_RACH => 0,
      C_REG_SLICE_MODE_RDCH => 0,
      C_REG_SLICE_MODE_AXIS => 0
    )
    PORT MAP (
      backup                              => '0',
      backup_marker                       => '0',
      clk                                 => '0',
      rst                                 => '0',
      srst                                => '0',
      wr_clk                              => wr_clk,
      wr_rst                              => wr_rst,
      rd_clk                              => rd_clk,
      rd_rst                              => rd_rst,
      din                                 => din,
      wr_en                               => din_vld,
      rd_en                               => dout_rdy,
      prog_empty_thresh                   => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_empty_thresh_assert            => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_empty_thresh_negate            => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_full_thresh                    => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_full_thresh_assert             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_full_thresh_negate             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      int_clk                             => '0',
      injectdbiterr                       => '0',
      injectsbiterr                       => '0',
      sleep                               => '0',
      dout                                => dout,
      full                                => full,
      almost_full                         => almost_full,
      wr_ack                              => wr_ack,
      overflow                            => overflow,
      empty                               => empty,
      almost_empty                        => almost_empty,
      valid                               => valid,
      underflow                           => underflow,
      data_count                          => data_count,
      rd_data_count                       => rd_data_count,
      wr_data_count                       => wr_data_count,
      prog_full                           => prog_full,
      prog_empty                          => prog_empty,
      sbiterr                             => sbiterr,
      dbiterr                             => dbiterr,
      wr_rst_busy                         => wr_rst_busy,
      rd_rst_busy                         => rd_rst_busy,

      m_aclk                              => '0',
      s_aclk                              => '0',
      s_aresetn                           => '0',
      m_aclk_en                           => '0',
      s_aclk_en                           => '0',
      m_axi_awid                          => m_axi_awid,
      m_axi_awaddr                        => m_axi_awaddr,
      m_axi_awlen                         => m_axi_awlen,
      m_axi_awsize                        => m_axi_awsize,
      m_axi_awburst                       => m_axi_awburst,
      m_axi_awlock                        => m_axi_awlock,
      m_axi_awcache                       => m_axi_awcache,
      m_axi_awprot                        => m_axi_awprot,
      m_axi_awqos                         => m_axi_awqos,
      m_axi_awregion                      => m_axi_awregion,
      m_axi_awuser                        => m_axi_awuser,
      m_axi_awvalid                       => m_axi_awvalid,
      m_axi_awready                       => '0',
      m_axi_wid                           => m_axi_wid,
      m_axi_wdata                         => m_axi_wdata,
      m_axi_wstrb                         => m_axi_wstrb,
      m_axi_wlast                         => m_axi_wlast,
      m_axi_wuser                         => m_axi_wuser,
      m_axi_wvalid                        => m_axi_wvalid,
      m_axi_wready                        => '0',
      m_axi_bid                           => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_bresp                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      m_axi_buser                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_bvalid                        => '0',
      m_axi_bready                        => m_axi_bready,
      s_axi_awid                          => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_awaddr                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      s_axi_awlen                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axi_awsize                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      s_axi_awburst                       => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      s_axi_awlock                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_awcache                       => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_awprot                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      s_axi_awqos                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_awregion                      => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_awuser                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_awvalid                       => '0',
      s_axi_awready                       => s_axi_awready,
      s_axi_wid                           => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_wdata                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axi_wstrb                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axi_wlast                         => '0',
      s_axi_wuser                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_wvalid                        => '0',
      s_axi_wready                        => s_axi_wready,
        
      s_axi_bid                           => s_axi_bid,
      s_axi_bresp                         => s_axi_bresp,
      s_axi_buser                         => s_axi_buser,
      s_axi_bready                        => '0',
      m_axi_arid                          => m_axi_arid,
      m_axi_araddr                        => m_axi_araddr,
      m_axi_arlen                         => m_axi_arlen,
      m_axi_arsize                        => m_axi_arsize,
      m_axi_arburst                       => m_axi_arburst,
      m_axi_arlock                        => m_axi_arlock,
      m_axi_arcache                       => m_axi_arcache,
      m_axi_arprot                        => m_axi_arprot,
      m_axi_arqos                         => m_axi_arqos,
      m_axi_arregion                      => m_axi_arregion,
      m_axi_aruser                        => m_axi_aruser,
      m_axi_arvalid                       => m_axi_arvalid,
      m_axi_arready                       => '0',
        
      m_axi_rid                           => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_rdata                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      m_axi_rresp                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      m_axi_rlast                         => '0',
      m_axi_ruser                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_rvalid                        => '0',
      m_axi_rready                        => m_axi_rready,

      s_axi_arid                          => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_araddr                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      s_axi_arlen                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axi_arsize                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      s_axi_arburst                       => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      s_axi_arlock                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_arcache                       => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_arprot                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      s_axi_arqos                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_arregion                      => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_aruser                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_arvalid                       => '0',
      s_axi_arready                       => s_axi_arready,
      s_axi_rid                           => s_axi_rid,
      s_axi_rdata                         => s_axi_rdata,
      s_axi_rresp                         => s_axi_rresp,
      s_axi_rlast                         => s_axi_rlast,
      s_axi_ruser                         => s_axi_ruser,
      s_axi_rready                        => '0',
      m_axis_tvalid                       => m_axis_tvalid,
      m_axis_tready                       => '0',
      m_axis_tdata                        => m_axis_tdata ,
      m_axis_tstrb                        => m_axis_tstrb ,
      m_axis_tkeep                        => m_axis_tkeep ,
      m_axis_tlast                        => m_axis_tlast ,
      m_axis_tid                          => m_axis_tid   ,
      m_axis_tdest                        => m_axis_tdest ,
      m_axis_tuser                        => m_axis_tuser ,
      s_axis_tvalid                       => '0',
      s_axis_tready                       => s_axis_tready,
      s_axis_tdata                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_tstrb                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_tkeep                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_tlast                        => '0',
      s_axis_tid                          => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_tdest                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_tuser                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_aw_injectsbiterr                => '0',
      axi_aw_injectdbiterr                => '0',
      axi_aw_prog_full_thresh             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_aw_prog_empty_thresh            => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_aw_data_count                   => axi_aw_data_count,
      axi_aw_wr_data_count                => axi_aw_wr_data_count,
      axi_aw_rd_data_count                => axi_aw_rd_data_count,
      axi_aw_sbiterr                      => axi_aw_sbiterr,
      axi_aw_dbiterr                      => axi_aw_dbiterr,
      axi_aw_overflow                     => axi_aw_overflow,
      axi_aw_underflow                    => axi_aw_underflow,
      axi_aw_prog_full                    => axi_aw_prog_full,
      axi_aw_prog_empty                   => axi_aw_prog_empty,
      axi_w_injectsbiterr                 => '0',
      axi_w_injectdbiterr                 => '0',
      axi_w_prog_full_thresh              => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axi_w_prog_empty_thresh             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axi_w_data_count                    => axi_w_data_count,
      axi_w_wr_data_count                 => axi_w_wr_data_count,
      axi_w_rd_data_count                 => axi_w_rd_data_count,
      axi_w_sbiterr                       => axi_w_sbiterr,
      axi_w_dbiterr                       => axi_w_dbiterr,
      axi_w_overflow                      => axi_w_overflow,
      axi_w_underflow                     => axi_w_underflow,
      axi_w_prog_full                     => axi_w_prog_full,
      axi_w_prog_empty                    => axi_w_prog_empty,

      axi_b_injectsbiterr                 => '0',
      axi_b_injectdbiterr                 => '0',
      axi_b_prog_full_thresh              => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_b_prog_empty_thresh             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_b_data_count                    => axi_b_data_count,
      axi_b_wr_data_count                 => axi_b_wr_data_count,
      axi_b_rd_data_count                 => axi_b_rd_data_count,
      axi_b_sbiterr                       => axi_b_sbiterr,
      axi_b_dbiterr                       => axi_b_dbiterr,
      axi_b_overflow                      => axi_b_overflow,
      axi_b_underflow                     => axi_b_underflow,
      axi_b_prog_full                     => axi_b_prog_full,
      axi_b_prog_empty                    => axi_b_prog_empty,
      axi_ar_injectsbiterr                => '0',
      axi_ar_injectdbiterr                => '0',
      axi_ar_prog_full_thresh             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_ar_prog_empty_thresh            => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_ar_data_count                    => axi_ar_data_count,
      axi_ar_wr_data_count                 => axi_ar_wr_data_count,
      axi_ar_rd_data_count                 => axi_ar_rd_data_count,
      axi_ar_sbiterr                       => axi_ar_sbiterr,
      axi_ar_dbiterr                       => axi_ar_dbiterr,
      axi_ar_overflow                      => axi_ar_overflow,
      axi_ar_underflow                     => axi_ar_underflow,
      axi_ar_prog_full                     => axi_ar_prog_full,
      axi_ar_prog_empty                    => axi_ar_prog_empty,
      axi_r_injectsbiterr                  => '0',
      axi_r_injectdbiterr                  => '0',
      axi_r_prog_full_thresh               => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axi_r_prog_empty_thresh              => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axi_r_data_count                     => axi_r_data_count,
      axi_r_wr_data_count                  => axi_r_wr_data_count,
      axi_r_rd_data_count                  => axi_r_rd_data_count,
      axi_r_sbiterr                        => axi_r_sbiterr,
      axi_r_dbiterr                        => axi_r_dbiterr,
      axi_r_overflow                       => axi_r_overflow,
      axi_r_underflow                      => axi_r_underflow,
      axi_r_prog_full                      => axi_r_prog_full,
      axi_r_prog_empty                     => axi_r_prog_empty,
      axis_injectsbiterr                   => '0',
      axis_injectdbiterr                   => '0',
      axis_prog_full_thresh                => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axis_prog_empty_thresh               => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axis_data_count                      => axis_data_count,
      axis_wr_data_count                   => axis_wr_data_count,
      axis_rd_data_count                   => axis_rd_data_count,
      axis_sbiterr                         => axis_sbiterr,
      axis_dbiterr                         => axis_dbiterr,
      axis_overflow                        => axis_overflow,
      axis_underflow                       => axis_underflow,
      axis_prog_full                       => axis_prog_full,
      axis_prog_empty                      => axis_prog_empty
    );

  end generate DIST_MEM_GEN;

  BRAM_MEM_GEN : if (USE_BRAM) generate
  begin
   FIF_BMG_INST : entity fifo_generator_v13_0_1.fifo_generator_v13_0_1
    GENERIC MAP (
      C_COMMON_CLOCK => 0,
      C_COUNT_TYPE => 0,
      C_DATA_COUNT_WIDTH => ADDR_BITS,
      C_DEFAULT_VALUE => "BlankString",
      C_DIN_WIDTH => WIDTH,
      C_DOUT_RST_VAL => "0",
      C_DOUT_WIDTH => WIDTH,
      C_ENABLE_RLOCS => 0,
      C_FAMILY => C_FAMILY,
      C_FULL_FLAGS_RST_VAL => 0,
      C_HAS_ALMOST_EMPTY => 0,
      C_HAS_ALMOST_FULL => 0,
      C_HAS_BACKUP => 0,
      C_HAS_DATA_COUNT => 0,
      C_HAS_INT_CLK => 0,
      C_HAS_MEMINIT_FILE => 0,
      C_HAS_OVERFLOW => 0,
      C_HAS_RD_DATA_COUNT => 0,
      C_HAS_RD_RST => 0,
      C_HAS_RST => 1,
      C_HAS_SRST => 0,
      C_HAS_UNDERFLOW => 0,
      C_HAS_VALID => 0,
      C_HAS_WR_ACK => 0,
      C_HAS_WR_DATA_COUNT => 0,
      C_HAS_WR_RST => 0,
      C_IMPLEMENTATION_TYPE => 2,
      C_INIT_WR_PNTR_VAL => 0,
      C_MEMORY_TYPE => 1,
      C_MIF_FILE_NAME => "BlankString",
      C_OPTIMIZATION_MODE => 0,
      C_OVERFLOW_LOW => 0,
      C_PRELOAD_LATENCY => 0,
      C_PRELOAD_REGS => 1,
      C_PRIM_FIFO_TYPE => "512x36",
      C_PROG_EMPTY_THRESH_ASSERT_VAL => 2,
      C_PROG_EMPTY_THRESH_NEGATE_VAL => 3,
      C_PROG_EMPTY_TYPE => 0,
      C_PROG_FULL_THRESH_ASSERT_VAL => 29,
      C_PROG_FULL_THRESH_NEGATE_VAL => 28,
      C_PROG_FULL_TYPE => 0,
      C_RD_DATA_COUNT_WIDTH => ADDR_BITS,
      C_RD_DEPTH => FIFO_DEPTH,
      C_RD_FREQ => 1,
      C_RD_PNTR_WIDTH => ADDR_BITS,
      C_UNDERFLOW_LOW => 0,
      C_USE_DOUT_RST => 1,
      C_USE_ECC => 0,
      C_USE_EMBEDDED_REG => 0,
      C_USE_PIPELINE_REG => 0,
      C_POWER_SAVING_MODE => 0,
      C_USE_FIFO16_FLAGS => 0,
      C_USE_FWFT_DATA_COUNT => 0,
      C_VALID_LOW => 0,
      C_WR_ACK_LOW => 0,
      C_WR_DATA_COUNT_WIDTH => ADDR_BITS,
      C_WR_DEPTH => FIFO_DEPTH,
      C_WR_FREQ => 1,
      C_WR_PNTR_WIDTH => ADDR_BITS,
      C_WR_RESPONSE_LATENCY => 1,
      C_MSGON_VAL => 1,
      C_ENABLE_RST_SYNC => 0,
      C_ERROR_INJECTION_TYPE => 0,
      C_SYNCHRONIZER_STAGE => C_MTBF_STAGES,
      C_INTERFACE_TYPE => 0,
      C_AXI_TYPE => 1,
      C_HAS_AXI_WR_CHANNEL => 1,
      C_HAS_AXI_RD_CHANNEL => 1,
      C_HAS_SLAVE_CE => 0,
      C_HAS_MASTER_CE => 0,
      C_ADD_NGC_CONSTRAINT => 0,
      C_USE_COMMON_OVERFLOW => 0,
      C_USE_COMMON_UNDERFLOW => 0,
      C_USE_DEFAULT_SETTINGS => 0,
      C_AXI_ID_WIDTH => 1,
      C_AXI_ADDR_WIDTH => 32,
      C_AXI_DATA_WIDTH => 64,
      C_AXI_LEN_WIDTH => 8,
      C_AXI_LOCK_WIDTH => 1,
      C_HAS_AXI_ID => 0,
      C_HAS_AXI_AWUSER => 0,
      C_HAS_AXI_WUSER => 0,
      C_HAS_AXI_BUSER => 0,
      C_HAS_AXI_ARUSER => 0,
      C_HAS_AXI_RUSER => 0,
      C_AXI_ARUSER_WIDTH => 1,
      C_AXI_AWUSER_WIDTH => 1,
      C_AXI_WUSER_WIDTH => 1,
      C_AXI_BUSER_WIDTH => 1,
      C_AXI_RUSER_WIDTH => 1,
      C_HAS_AXIS_TDATA => 1,
      C_HAS_AXIS_TID => 0,
      C_HAS_AXIS_TDEST => 0,
      C_HAS_AXIS_TUSER => 1,
      C_HAS_AXIS_TREADY => 1,
      C_HAS_AXIS_TLAST => 0,
      C_HAS_AXIS_TSTRB => 0,
      C_HAS_AXIS_TKEEP => 0,
      C_AXIS_TDATA_WIDTH => 8,
      C_AXIS_TID_WIDTH => 1,
      C_AXIS_TDEST_WIDTH => 1,
      C_AXIS_TUSER_WIDTH => 4,
      C_AXIS_TSTRB_WIDTH => 1,
      C_AXIS_TKEEP_WIDTH => 1,
      C_WACH_TYPE => 0,
      C_WDCH_TYPE => 0,
      C_WRCH_TYPE => 0,
      C_RACH_TYPE => 0,
      C_RDCH_TYPE => 0,
      C_AXIS_TYPE => 0,
      C_IMPLEMENTATION_TYPE_WACH => 1,
      C_IMPLEMENTATION_TYPE_WDCH => 1,
      C_IMPLEMENTATION_TYPE_WRCH => 1,
      C_IMPLEMENTATION_TYPE_RACH => 1,
      C_IMPLEMENTATION_TYPE_RDCH => 1,
      C_IMPLEMENTATION_TYPE_AXIS => 1,
      C_APPLICATION_TYPE_WACH => 0,
      C_APPLICATION_TYPE_WDCH => 0,
      C_APPLICATION_TYPE_WRCH => 0,
      C_APPLICATION_TYPE_RACH => 0,
      C_APPLICATION_TYPE_RDCH => 0,
      C_APPLICATION_TYPE_AXIS => 0,
      C_PRIM_FIFO_TYPE_WACH => "512x36",
      C_PRIM_FIFO_TYPE_WDCH => "1kx36",
      C_PRIM_FIFO_TYPE_WRCH => "512x36",
      C_PRIM_FIFO_TYPE_RACH => "512x36",
      C_PRIM_FIFO_TYPE_RDCH => "1kx36",
      C_PRIM_FIFO_TYPE_AXIS => "1kx18",
      C_USE_ECC_WACH => 0,
      C_USE_ECC_WDCH => 0,
      C_USE_ECC_WRCH => 0,
      C_USE_ECC_RACH => 0,
      C_USE_ECC_RDCH => 0,
      C_USE_ECC_AXIS => 0,
      C_ERROR_INJECTION_TYPE_WACH => 0,
      C_ERROR_INJECTION_TYPE_WDCH => 0,
      C_ERROR_INJECTION_TYPE_WRCH => 0,
      C_ERROR_INJECTION_TYPE_RACH => 0,
      C_ERROR_INJECTION_TYPE_RDCH => 0,
      C_ERROR_INJECTION_TYPE_AXIS => 0,
      C_DIN_WIDTH_WACH => 32,
      C_DIN_WIDTH_WDCH => 64,
      C_DIN_WIDTH_WRCH => 2,
      C_DIN_WIDTH_RACH => 32,
      C_DIN_WIDTH_RDCH => 64,
      C_DIN_WIDTH_AXIS => 1,
      C_WR_DEPTH_WACH => 16,
      C_WR_DEPTH_WDCH => 1024,
      C_WR_DEPTH_WRCH => 16,
      C_WR_DEPTH_RACH => 16,
      C_WR_DEPTH_RDCH => 1024,
      C_WR_DEPTH_AXIS => 1024,
      C_WR_PNTR_WIDTH_WACH => 4,
      C_WR_PNTR_WIDTH_WDCH => 10,
      C_WR_PNTR_WIDTH_WRCH => 4,
      C_WR_PNTR_WIDTH_RACH => 4,
      C_WR_PNTR_WIDTH_RDCH => 10,
      C_WR_PNTR_WIDTH_AXIS => 10,
      C_HAS_DATA_COUNTS_WACH => 0,
      C_HAS_DATA_COUNTS_WDCH => 0,
      C_HAS_DATA_COUNTS_WRCH => 0,
      C_HAS_DATA_COUNTS_RACH => 0,
      C_HAS_DATA_COUNTS_RDCH => 0,
      C_HAS_DATA_COUNTS_AXIS => 0,
      C_HAS_PROG_FLAGS_WACH => 0,
      C_HAS_PROG_FLAGS_WDCH => 0,
      C_HAS_PROG_FLAGS_WRCH => 0,
      C_HAS_PROG_FLAGS_RACH => 0,
      C_HAS_PROG_FLAGS_RDCH => 0,
      C_HAS_PROG_FLAGS_AXIS => 0,
      C_PROG_FULL_TYPE_WACH => 0,
      C_PROG_FULL_TYPE_WDCH => 0,
      C_PROG_FULL_TYPE_WRCH => 0,
      C_PROG_FULL_TYPE_RACH => 0,
      C_PROG_FULL_TYPE_RDCH => 0,
      C_PROG_FULL_TYPE_AXIS => 0,
      C_PROG_FULL_THRESH_ASSERT_VAL_WACH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_WDCH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_WRCH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_RACH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_RDCH => 1023,
      C_PROG_FULL_THRESH_ASSERT_VAL_AXIS => 1023,
      C_PROG_EMPTY_TYPE_WACH => 0,
      C_PROG_EMPTY_TYPE_WDCH => 0,
      C_PROG_EMPTY_TYPE_WRCH => 0,
      C_PROG_EMPTY_TYPE_RACH => 0,
      C_PROG_EMPTY_TYPE_RDCH => 0,
      C_PROG_EMPTY_TYPE_AXIS => 0,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH => 1022,
      C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS => 1022,
      C_REG_SLICE_MODE_WACH => 0,
      C_REG_SLICE_MODE_WDCH => 0,
      C_REG_SLICE_MODE_WRCH => 0,
      C_REG_SLICE_MODE_RACH => 0,
      C_REG_SLICE_MODE_RDCH => 0,
      C_REG_SLICE_MODE_AXIS => 0
    )
    PORT MAP (
      backup                              => '0',
      backup_marker                       => '0',
      clk                                 => '0',
      rst                                 => '0',
      srst                                => '0',
      wr_clk                              => wr_clk,
      wr_rst                              => wr_rst,
      rd_clk                              => rd_clk,
      rd_rst                              => rd_rst,
      din                                 => din,
      wr_en                               => din_vld,
      rd_en                               => dout_rdy,
      prog_empty_thresh                   => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_empty_thresh_assert            => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_empty_thresh_negate            => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_full_thresh                    => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_full_thresh_assert             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      prog_full_thresh_negate             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
      int_clk                             => '0',
      injectdbiterr                       => '0',
      injectsbiterr                       => '0',
      sleep                               => '0',
      dout                                => dout,
      full                                => full,
      almost_full                         => almost_full,
      wr_ack                              => wr_ack,
      overflow                            => overflow,
      empty                               => empty,
      almost_empty                        => almost_empty,
      valid                               => valid,
      underflow                           => underflow,
      data_count                          => data_count,
      rd_data_count                       => rd_data_count,
      wr_data_count                       => wr_data_count,
      prog_full                           => prog_full,
      prog_empty                          => prog_empty,
      sbiterr                             => sbiterr,
      dbiterr                             => dbiterr,
      wr_rst_busy                         => wr_rst_busy,
      rd_rst_busy                         => rd_rst_busy,

      m_aclk                              => '0',
      s_aclk                              => '0',
      s_aresetn                           => '0',
      m_aclk_en                           => '0',
      s_aclk_en                           => '0',
      m_axi_awid                          => m_axi_awid,
      m_axi_awaddr                        => m_axi_awaddr,
      m_axi_awlen                         => m_axi_awlen,
      m_axi_awsize                        => m_axi_awsize,
      m_axi_awburst                       => m_axi_awburst,
      m_axi_awlock                        => m_axi_awlock,
      m_axi_awcache                       => m_axi_awcache,
      m_axi_awprot                        => m_axi_awprot,
      m_axi_awqos                         => m_axi_awqos,
      m_axi_awregion                      => m_axi_awregion,
      m_axi_awuser                        => m_axi_awuser,
      m_axi_awvalid                       => m_axi_awvalid,
      m_axi_awready                       => '0',
      m_axi_wid                           => m_axi_wid,
      m_axi_wdata                         => m_axi_wdata,
      m_axi_wstrb                         => m_axi_wstrb,
      m_axi_wlast                         => m_axi_wlast,
      m_axi_wuser                         => m_axi_wuser,
      m_axi_wvalid                        => m_axi_wvalid,
      m_axi_wready                        => '0',
      m_axi_bid                           => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_bresp                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      m_axi_buser                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_bvalid                        => '0',
      m_axi_bready                        => m_axi_bready,
      s_axi_awid                          => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_awaddr                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      s_axi_awlen                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axi_awsize                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      s_axi_awburst                       => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      s_axi_awlock                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_awcache                       => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_awprot                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      s_axi_awqos                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_awregion                      => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_awuser                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_awvalid                       => '0',
      s_axi_awready                       => s_axi_awready,
      s_axi_wid                           => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_wdata                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      s_axi_wstrb                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axi_wlast                         => '0',
      s_axi_wuser                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_wvalid                        => '0',
      s_axi_wready                        => s_axi_wready,
        
      s_axi_bid                           => s_axi_bid,
      s_axi_bresp                         => s_axi_bresp,
      s_axi_buser                         => s_axi_buser,
      s_axi_bready                        => '0',
      m_axi_arid                          => m_axi_arid,
      m_axi_araddr                        => m_axi_araddr,
      m_axi_arlen                         => m_axi_arlen,
      m_axi_arsize                        => m_axi_arsize,
      m_axi_arburst                       => m_axi_arburst,
      m_axi_arlock                        => m_axi_arlock,
      m_axi_arcache                       => m_axi_arcache,
      m_axi_arprot                        => m_axi_arprot,
      m_axi_arqos                         => m_axi_arqos,
      m_axi_arregion                      => m_axi_arregion,
      m_axi_aruser                        => m_axi_aruser,
      m_axi_arvalid                       => m_axi_arvalid,
      m_axi_arready                       => '0',
        
      m_axi_rid                           => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_rdata                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
      m_axi_rresp                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      m_axi_rlast                         => '0',
      m_axi_ruser                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      m_axi_rvalid                        => '0',
      m_axi_rready                        => m_axi_rready,

      s_axi_arid                          => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_araddr                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      s_axi_arlen                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axi_arsize                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      s_axi_arburst                       => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
      s_axi_arlock                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_arcache                       => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_arprot                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
      s_axi_arqos                         => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_arregion                      => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      s_axi_aruser                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axi_arvalid                       => '0',
      s_axi_arready                       => s_axi_arready,
      s_axi_rid                           => s_axi_rid,
      s_axi_rdata                         => s_axi_rdata,
      s_axi_rresp                         => s_axi_rresp,
      s_axi_rlast                         => s_axi_rlast,
      s_axi_ruser                         => s_axi_ruser,
      s_axi_rready                        => '0',
      m_axis_tvalid                       => m_axis_tvalid,
      m_axis_tready                       => '0',
      m_axis_tdata                        => m_axis_tdata ,
      m_axis_tstrb                        => m_axis_tstrb ,
      m_axis_tkeep                        => m_axis_tkeep ,
      m_axis_tlast                        => m_axis_tlast ,
      m_axis_tid                          => m_axis_tid   ,
      m_axis_tdest                        => m_axis_tdest ,
      m_axis_tuser                        => m_axis_tuser ,
      s_axis_tvalid                       => '0',
      s_axis_tready                       => s_axis_tready,
      s_axis_tdata                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
      s_axis_tstrb                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_tkeep                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_tlast                        => '0',
      s_axis_tid                          => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_tdest                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
      s_axis_tuser                        => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_aw_injectsbiterr                => '0',
      axi_aw_injectdbiterr                => '0',
      axi_aw_prog_full_thresh             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_aw_prog_empty_thresh            => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_aw_data_count                   => axi_aw_data_count,
      axi_aw_wr_data_count                => axi_aw_wr_data_count,
      axi_aw_rd_data_count                => axi_aw_rd_data_count,
      axi_aw_sbiterr                      => axi_aw_sbiterr,
      axi_aw_dbiterr                      => axi_aw_dbiterr,
      axi_aw_overflow                     => axi_aw_overflow,
      axi_aw_underflow                    => axi_aw_underflow,
      axi_aw_prog_full                    => axi_aw_prog_full,
      axi_aw_prog_empty                   => axi_aw_prog_empty,
      axi_w_injectsbiterr                 => '0',
      axi_w_injectdbiterr                 => '0',
      axi_w_prog_full_thresh              => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axi_w_prog_empty_thresh             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axi_w_data_count                    => axi_w_data_count,
      axi_w_wr_data_count                 => axi_w_wr_data_count,
      axi_w_rd_data_count                 => axi_w_rd_data_count,
      axi_w_sbiterr                       => axi_w_sbiterr,
      axi_w_dbiterr                       => axi_w_dbiterr,
      axi_w_overflow                      => axi_w_overflow,
      axi_w_underflow                     => axi_w_underflow,
      axi_w_prog_full                     => axi_w_prog_full,
      axi_w_prog_empty                    => axi_w_prog_empty,

      axi_b_injectsbiterr                 => '0',
      axi_b_injectdbiterr                 => '0',
      axi_b_prog_full_thresh              => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_b_prog_empty_thresh             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_b_data_count                    => axi_b_data_count,
      axi_b_wr_data_count                 => axi_b_wr_data_count,
      axi_b_rd_data_count                 => axi_b_rd_data_count,
      axi_b_sbiterr                       => axi_b_sbiterr,
      axi_b_dbiterr                       => axi_b_dbiterr,
      axi_b_overflow                      => axi_b_overflow,
      axi_b_underflow                     => axi_b_underflow,
      axi_b_prog_full                     => axi_b_prog_full,
      axi_b_prog_empty                    => axi_b_prog_empty,
      axi_ar_injectsbiterr                => '0',
      axi_ar_injectdbiterr                => '0',
      axi_ar_prog_full_thresh             => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_ar_prog_empty_thresh            => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
      axi_ar_data_count                    => axi_ar_data_count,
      axi_ar_wr_data_count                 => axi_ar_wr_data_count,
      axi_ar_rd_data_count                 => axi_ar_rd_data_count,
      axi_ar_sbiterr                       => axi_ar_sbiterr,
      axi_ar_dbiterr                       => axi_ar_dbiterr,
      axi_ar_overflow                      => axi_ar_overflow,
      axi_ar_underflow                     => axi_ar_underflow,
      axi_ar_prog_full                     => axi_ar_prog_full,
      axi_ar_prog_empty                    => axi_ar_prog_empty,
      axi_r_injectsbiterr                  => '0',
      axi_r_injectdbiterr                  => '0',
      axi_r_prog_full_thresh               => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axi_r_prog_empty_thresh              => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axi_r_data_count                     => axi_r_data_count,
      axi_r_wr_data_count                  => axi_r_wr_data_count,
      axi_r_rd_data_count                  => axi_r_rd_data_count,
      axi_r_sbiterr                        => axi_r_sbiterr,
      axi_r_dbiterr                        => axi_r_dbiterr,
      axi_r_overflow                       => axi_r_overflow,
      axi_r_underflow                      => axi_r_underflow,
      axi_r_prog_full                      => axi_r_prog_full,
      axi_r_prog_empty                     => axi_r_prog_empty,
      axis_injectsbiterr                   => '0',
      axis_injectdbiterr                   => '0',
      axis_prog_full_thresh                => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axis_prog_empty_thresh               => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
      axis_data_count                      => axis_data_count,
      axis_wr_data_count                   => axis_wr_data_count,
      axis_rd_data_count                   => axis_rd_data_count,
      axis_sbiterr                         => axis_sbiterr,
      axis_dbiterr                         => axis_dbiterr,
      axis_overflow                        => axis_overflow,
      axis_underflow                       => axis_underflow,
      axis_prog_full                       => axis_prog_full,
      axis_prog_empty                      => axis_prog_empty
    );

  end generate BRAM_MEM_GEN;



  

end generate NEW_INTRO;


end rtl;
