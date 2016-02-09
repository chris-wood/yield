-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : xd_input_scalars_fifo.vhd
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

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;

library fifo_generator_v13_0_1;
use fifo_generator_v13_0_1.all;


entity xd_input_scalars_fifo is
  generic (
    C_FAMILY : string  := "virtex6";
    C_MTBF_STAGES : integer  := 4;
    WIDTH    : integer := 16);
  port (
    din      : in  std_logic_vector(WIDTH-1 downto 0);
    din_vld  : in  std_logic;
    din_rdy  : out std_logic;
    wr_used  : out std_logic_vector(3 downto 0);
    wr_empty : out std_logic;
    wr_full  : out std_logic;
    wr_clk   : in  std_logic;
    dout     : out std_logic_vector(WIDTH-1 downto 0);
    dout_vld : out std_logic;
    dout_rdy : in  std_logic;
    rd_clk   : in  std_logic;
    rst      : in  std_logic);
end xd_input_scalars_fifo;

architecture rtl of xd_input_scalars_fifo is


  constant DEPTH      : integer := 16;
  constant FIFO_DEPTH : integer := calc_fifo_depth(DEPTH)+ 1;
  constant ADDR_BITS  : integer := log2(FIFO_DEPTH);

  signal rst_vec : std_logic_vector(0 downto 0);
  signal wr_rst_vec : std_logic_vector(0 downto 0);
  signal rd_rst_vec : std_logic_vector(0 downto 0);
  signal wr_rst : std_logic;
  signal rd_rst : std_logic;
  signal rd_addr : unsigned(ADDR_BITS-1 downto 0);
  signal wr_addr : unsigned(ADDR_BITS-1 downto 0);

  -- Next signals are gray values:
  signal wr_gray       : std_logic_vector(ADDR_BITS-1 downto 0);
  signal next_wr_gray  : std_logic_vector(ADDR_BITS-1 downto 0);
  signal wr_gray_ahead : std_logic_vector(ADDR_BITS-1 downto 0);

  signal rd_gray      : std_logic_vector(ADDR_BITS-1 downto 0);
  signal next_rd_gray : std_logic_vector(ADDR_BITS-1 downto 0);
  signal prev_rd_gray : std_logic_vector(ADDR_BITS-1 downto 0);

  signal fifo_we : std_logic;
  signal fifo_re : std_logic;

  signal din_rdy_i  : std_logic;
  signal empty_i    : std_logic;
  signal rd_en      : std_logic;
  signal dout_vld_i : std_logic;
  signal empty : std_logic;
  signal rd_en_dly : std_logic;
  signal wr_en_dly : std_logic;
  signal din_dly : std_logic_vector(WIDTH-1 downto 0);
  signal full : std_logic;
  signal rstn : std_logic;

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

  type   mem_type is array (2**ADDR_BITS-1 downto 0) of std_logic_vector (WIDTH-1 downto 0);
  signal mem : mem_type;

  attribute ram_style        : string;
  attribute ram_style of mem : signal is "distributed";

  signal mem_dout : std_logic_vector(WIDTH-1 downto 0);

  -- Read gray counter synchronized with write clock.
  signal reg_rd_gray : std_logic_vector(ADDR_BITS-1 downto 0);

  signal rd_gray_sync : std_logic_vector(ADDR_BITS-1 downto 0);
  signal rd_bin       : unsigned(ADDR_BITS-1 downto 0);
  signal wr_bin       : unsigned(ADDR_BITS-1 downto 0);
  signal ptr_dist     : unsigned(ADDR_BITS-1 downto 0);
  signal wr_used_i     : std_logic_vector(ADDR_BITS-1 downto 0);

  signal wr_empty_i : std_logic;
  constant C_EXTRA_SYNCS      : integer := 5;

begin

EXISTING : if (C_EXTRA_SYNCS = 0) generate

begin

  fifo_we <= din_vld and din_rdy_i;

  process(wr_clk, rst)
  begin
    if(rst = '1') then
      wr_addr <= (others => '0');
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_addr <= wr_addr + 1;
      end if;
    end if;
  end process;

  fifo_re <= rd_en and not(empty_i);

  process(rd_clk, rst)
  begin
    if(rst = '1') then
      rd_addr <= (others => '0');
    elsif(rd_clk'event and rd_clk = '1') then
      if(fifo_re = '1') then
        rd_addr <= rd_addr + 1;
      end if;
    end if;
  end process;

  ---------------------------------------------------------

  process(rd_clk, rst)
  begin
    if(rst = '1') then
      next_rd_gray <= bin2gray(2**ADDR_BITS-1, ADDR_BITS);
      rd_gray      <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
      prev_rd_gray <= bin2gray(2**ADDR_BITS-3, ADDR_BITS);
    elsif(rd_clk'event and rd_clk = '1') then
      if(fifo_re = '1') then
        prev_rd_gray <= rd_gray;
        rd_gray      <= next_rd_gray;
        next_rd_gray <= bin2gray(std_logic_vector(rd_addr));
      end if;
    end if;
  end process;

  process(wr_clk, rst)
  begin
    if(rst = '1') then
      next_wr_gray <= bin2gray(2**ADDR_BITS-1, ADDR_BITS);
      wr_gray      <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_gray      <= next_wr_gray;
        next_wr_gray <= bin2gray(std_logic_vector(wr_addr));
      end if;
    end if;
  end process;

  process(wr_clk, rst)
  begin
    if(rst = '1') then
      wr_gray_ahead <= bin2gray(2**ADDR_BITS-0, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_gray_ahead <= gray_inc(wr_gray_ahead);
      end if;
    end if;
  end process;

  -----------------------------------------------------------------

  process(wr_clk, rst)
  begin
    if(rst = '1') then
      din_rdy_i <= '0';
    elsif(wr_clk'event and wr_clk = '1') then
      if(din_rdy_i = '1') then
        if (wr_gray_ahead = prev_rd_gray) then
          din_rdy_i <= not(fifo_we);
        else
          din_rdy_i <= '1';
        end if;
      else
        if (wr_gray_ahead = rd_gray) then
          din_rdy_i <= '0';
        else
          din_rdy_i <= '1';
        end if;
      end if;
    end if;
  end process;

  din_rdy <= din_rdy_i;

  process(rd_clk, rst)
  begin
    if(rst = '1') then
      empty_i <= '1';
    elsif(rd_clk'event and rd_clk = '1') then
      if(empty_i = '0') then
        if(next_rd_gray = wr_gray) then
          empty_i <= fifo_re;
        else
          empty_i <= '0';
        end if;
      else
        if(rd_gray = wr_gray) then
          empty_i <= '1';
        else
          empty_i <= '0';
        end if;
      end if;
    end if;
  end process;

  rd_en <= not(dout_vld_i) or (dout_vld_i and dout_rdy);
  process(rd_clk, rst)
  begin
    if(rst = '1') then
      dout_vld_i <= '0';
    elsif(rd_clk'event and rd_clk = '1') then
      if(rd_en = '1') then
        dout_vld_i <= not(empty_i);
      end if;
    end if;
  end process;

  dout_vld <= dout_vld_i;

  -----------------------------------------------------------------------
  -- Memory bank modeling. Tool to infer the memory.

  process(wr_clk)
  begin
    if(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        mem(to_integer(wr_addr)) <= din;
      end if;
    end if;
  end process;

  mem_dout <= mem(to_integer(rd_addr));

  process(rd_clk, rst)
  begin
    if(rst = '1') then
      dout <= (others => '0');
    elsif(rd_clk'event and rd_clk = '1') then
      if(fifo_re = '1') then
        dout <= mem_dout;
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------

  process(rd_clk, rst)
  begin
    if(rst = '1') then
      reg_rd_gray <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
    elsif(rd_clk'event and rd_clk = '1') then
      if(rd_en = '1') then
        reg_rd_gray <= rd_gray;
      end if;
    end if;
  end process;

  process(wr_clk, rst)
  begin
    if(rst = '1') then
      rd_gray_sync <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      rd_gray_sync <= reg_rd_gray;
    end if;
  end process;

  rd_bin <= unsigned(gray2bin(rd_gray_sync));

  process(wr_clk, rst)
  begin
    if(rst = '1') then
      wr_bin <= to_unsigned(2**ADDR_BITS-2, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      if (fifo_we = '1') then
        wr_bin <= wr_bin + 1;
      end if;
    end if;
  end process;

  process(wr_clk, rst)
  begin
    if(rst = '1') then
      ptr_dist <= (others => '0');
    elsif(wr_clk'event and wr_clk = '1') then
      if (fifo_we = '1') then
        ptr_dist <= ptr_dist + 1;
      else
        ptr_dist <= wr_bin - rd_bin;
      end if;
    end if;
  end process;

  wr_used <= std_logic_vector(ptr_dist);
  wr_full <= not(din_rdy_i);

  process(wr_clk, rst)
  begin
    if(rst = '1') then
      wr_empty_i <= '1';
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_empty_i <= '0';
      else
        if(rd_gray_sync = wr_gray) then
          wr_empty_i <= '1';
        else
          wr_empty_i <= '0';
        end if;
      end if;
    end if;
  end process;

  wr_empty <= wr_empty_i;

end generate EXISTING;


NEW_INTRO : if (C_EXTRA_SYNCS = 2) generate
 begin  

   rst_vec(0) <= rst;
   wr_rst <= wr_rst_vec(0);
   rd_rst <= rd_rst_vec(0);

    wr_rst_sync: ENTITY axis_accelerator_adapter_v2_1_6.synchronizer_ff
    GENERIC MAP (
     C_HAS_RST => 0,
     C_WIDTH   => 1
     )
    PORT MAP ( 
     RST       => open,
     CLK       => wr_clk,   
     D         => rst_vec,
     Q         => wr_rst_vec
     );    

    rd_rst_sync: ENTITY axis_accelerator_adapter_v2_1_6.synchronizer_ff
    GENERIC MAP (
     C_HAS_RST => 0,
     C_WIDTH   => 1
     )
    PORT MAP ( 
     RST       => open,
     CLK       => rd_clk,   
     D         => rst_vec,
     Q         => rd_rst_vec
     );    


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

  process(rd_clk, rd_rst)
  begin
    if(rd_rst = '1') then
      next_rd_gray <= bin2gray(2**ADDR_BITS-1, ADDR_BITS);
      rd_gray      <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
      prev_rd_gray <= bin2gray(2**ADDR_BITS-3, ADDR_BITS);
    elsif(rd_clk'event and rd_clk = '1') then
      if(fifo_re = '1') then
        prev_rd_gray <= rd_gray;
        rd_gray      <= next_rd_gray;
        next_rd_gray <= bin2gray(std_logic_vector(rd_addr));
      end if;
    end if;
  end process;

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      next_wr_gray <= bin2gray(2**ADDR_BITS-1, ADDR_BITS);
      wr_gray      <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_gray      <= next_wr_gray;
        next_wr_gray <= bin2gray(std_logic_vector(wr_addr));
      end if;
    end if;
  end process;

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      wr_gray_ahead <= bin2gray(2**ADDR_BITS-0, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_gray_ahead <= gray_inc(wr_gray_ahead);
      end if;
    end if;
  end process;

  -----------------------------------------------------------------

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      din_rdy_i <= '0';
    elsif(wr_clk'event and wr_clk = '1') then
      if(din_rdy_i = '1') then
        if (wr_gray_ahead = prev_rd_gray) then
          din_rdy_i <= not(fifo_we);
        else
          din_rdy_i <= '1';
        end if;
      else
        if (wr_gray_ahead = rd_gray) then
          din_rdy_i <= '0';
        else
          din_rdy_i <= '1';
        end if;
      end if;
    end if;
  end process;

  din_rdy <= din_rdy_i;

  process(rd_clk, rd_rst)
  begin
    if(rd_rst = '1') then
      empty_i <= '1';
    elsif(rd_clk'event and rd_clk = '1') then
      if(empty_i = '0') then
        if(next_rd_gray = wr_gray) then
          empty_i <= fifo_re;
        else
          empty_i <= '0';
        end if;
      else
        if(rd_gray = wr_gray) then
          empty_i <= '1';
        else
          empty_i <= '0';
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
  -- Memory bank modeling. Tool to infer the memory.

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

  -----------------------------------------------------------------------

  process(rd_clk, rd_rst)
  begin
    if(rd_rst = '1') then
      reg_rd_gray <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
    elsif(rd_clk'event and rd_clk = '1') then
      if(rd_en = '1') then
        reg_rd_gray <= rd_gray;
      end if;
    end if;
  end process;

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      rd_gray_sync <= bin2gray(2**ADDR_BITS-2, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      rd_gray_sync <= reg_rd_gray;
    end if;
  end process;

  rd_bin <= unsigned(gray2bin(rd_gray_sync));

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      wr_bin <= to_unsigned(2**ADDR_BITS-2, ADDR_BITS);
    elsif(wr_clk'event and wr_clk = '1') then
      if (fifo_we = '1') then
        wr_bin <= wr_bin + 1;
      end if;
    end if;
  end process;

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      ptr_dist <= (others => '0');
    elsif(wr_clk'event and wr_clk = '1') then
      if (fifo_we = '1') then
        ptr_dist <= ptr_dist + 1;
      else
        ptr_dist <= wr_bin - rd_bin;
      end if;
    end if;
  end process;

  wr_used <= std_logic_vector(ptr_dist(3 downto 0));
  wr_full <= not(din_rdy_i);

  process(wr_clk, wr_rst)
  begin
    if(wr_rst = '1') then
      wr_empty_i <= '1';
    elsif(wr_clk'event and wr_clk = '1') then
      if(fifo_we = '1') then
        wr_empty_i <= '0';
      else
        if(rd_gray_sync = wr_gray) then
          wr_empty_i <= '1';
        else
          wr_empty_i <= '0';
        end if;
      end if;
    end if;
  end process;


  wr_empty <= wr_empty_i;


end generate NEW_INTRO;




NEW_INTRO3 : if (C_EXTRA_SYNCS = 5) generate
 begin  

    rstn  <= not(rst);
    din_rdy  <= not(full);
    din_rdy_i  <= not(full);
    wr_full  <= (full);
    wr_empty  <= (empty);
    dout_vld <= not(empty);
    wr_en_dly <= din_vld ;--AFTER 100ps;
    rd_en_dly <= dout_rdy ;--AFTER 100ps;
    din_dly <= din ;--AFTER 100ps;
    wr_used <= wr_used_i(3 downto 0);



  FIF_DMG_INST : entity fifo_generator_v13_0_1.fifo_generator_v13_0_1
    GENERIC MAP (
      C_COMMON_CLOCK => 0,
      C_COUNT_TYPE => 0,
      C_DATA_COUNT_WIDTH => 4,
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
      C_HAS_WR_DATA_COUNT => 1,
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
      C_USE_FWFT_DATA_COUNT => 1,
      C_VALID_LOW => 0,
      C_WR_ACK_LOW => 0,
      C_WR_DATA_COUNT_WIDTH => ADDR_BITS,
      C_WR_DEPTH => FIFO_DEPTH,
      C_WR_FREQ => 1,
      C_WR_PNTR_WIDTH => ADDR_BITS,
      C_WR_RESPONSE_LATENCY => 1,
      C_MSGON_VAL => 1,
      C_ENABLE_RST_SYNC => 1,
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
      C_HAS_DATA_COUNTS_AXIS => 3,
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
      rst                                 => rst,
      srst                                => '0',
      wr_clk                              => wr_clk,
      wr_rst                              => '0',
      rd_clk                              => rd_clk,
      rd_rst                              => '0',
      din                                 => din_dly,
      wr_en                               => wr_en_dly,
      rd_en                               => rd_en_dly,
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
      wr_data_count                       => wr_used_i,
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

--     COMP_FIFO : entity fifo_generator_v12_0_5.fifo_generator_v12_0_5
-- generic map (
--      C_COMMON_CLOCK => 0,
--      C_COUNT_TYPE => 0,
--      C_DATA_COUNT_WIDTH => 10,
--      C_DEFAULT_VALUE => "BlankString",
--      C_DIN_WIDTH => 18,
--      C_DOUT_RST_VAL => "0",
--      C_DOUT_WIDTH => 18,
--      C_ENABLE_RLOCS => 0,
--      C_FAMILY => C_FAMILY,
--      C_FULL_FLAGS_RST_VAL => 1,
--      C_HAS_ALMOST_EMPTY => 0,
--      C_HAS_ALMOST_FULL => 0,
--      C_HAS_BACKUP => 0,
--      C_HAS_DATA_COUNT => 0,
--      C_HAS_INT_CLK => 0,
--      C_HAS_MEMINIT_FILE => 0,
--      C_HAS_OVERFLOW => 0,
--      C_HAS_RD_DATA_COUNT => 0,
--      C_HAS_RD_RST => 0,
--      C_HAS_RST => 1,
--      C_HAS_SRST => 0,
--      C_HAS_UNDERFLOW => 0,
--      C_HAS_VALID => 0,
--      C_HAS_WR_ACK => 0,
--      C_HAS_WR_DATA_COUNT => 0,
--      C_HAS_WR_RST => 0,
--      C_IMPLEMENTATION_TYPE => 0,
--      C_INIT_WR_PNTR_VAL => 0,
--      C_MEMORY_TYPE => 1,
--      C_MIF_FILE_NAME => "BlankString",
--      C_OPTIMIZATION_MODE => 0,
--      C_OVERFLOW_LOW => 0,
--      C_PRELOAD_LATENCY => 1,
--      C_PRELOAD_REGS => 0,
--      C_PRIM_FIFO_TYPE => "4kx4",
--      C_PROG_EMPTY_THRESH_ASSERT_VAL => 2,
--      C_PROG_EMPTY_THRESH_NEGATE_VAL => 3,
--      C_PROG_EMPTY_TYPE => 0,
--      C_PROG_FULL_THRESH_ASSERT_VAL => 1022,
--      C_PROG_FULL_THRESH_NEGATE_VAL => 1021,
--      C_PROG_FULL_TYPE => 0,
--      C_RD_DATA_COUNT_WIDTH => 10,
--      C_RD_DEPTH => 16,
--      C_RD_FREQ => 1,
--      C_RD_PNTR_WIDTH => ADDR_BITS,
--      C_UNDERFLOW_LOW => 0,
--      C_USE_DOUT_RST => 1,
--      C_USE_ECC => 0,
--      C_USE_EMBEDDED_REG => 0,
--      C_USE_PIPELINE_REG => 0,
--      C_POWER_SAVING_MODE => 0,
--      C_USE_FIFO16_FLAGS => 0,
--      C_USE_FWFT_DATA_COUNT => 0,
--      C_VALID_LOW => 0,
--      C_WR_ACK_LOW => 0,
--      C_WR_DATA_COUNT_WIDTH => 10,
--      C_WR_DEPTH => 16,
--      C_WR_FREQ => 1,
--      C_WR_PNTR_WIDTH => ADDR_BITS,
--      C_WR_RESPONSE_LATENCY => 1,
--      C_MSGON_VAL => 1,
--      C_ENABLE_RST_SYNC => 1,
--      C_ERROR_INJECTION_TYPE => 0,
--      C_SYNCHRONIZER_STAGE => 2,
--      C_INTERFACE_TYPE => 1,
--      C_AXI_TYPE => 1,
--      C_HAS_AXI_WR_CHANNEL => 1,
--      C_HAS_AXI_RD_CHANNEL => 1,
--      C_HAS_SLAVE_CE => 0,
--      C_HAS_MASTER_CE => 0,
--      C_ADD_NGC_CONSTRAINT => 0,
--      C_USE_COMMON_OVERFLOW => 0,
--      C_USE_COMMON_UNDERFLOW => 0,
--      C_USE_DEFAULT_SETTINGS => 0,
--      C_AXI_ID_WIDTH => 1,
--      C_AXI_ADDR_WIDTH => 32,
--      C_AXI_DATA_WIDTH => 64,
--      C_AXI_LEN_WIDTH => 8,
--      C_AXI_LOCK_WIDTH => 1,
--      C_HAS_AXI_ID => 0,
--      C_HAS_AXI_AWUSER => 0,
--      C_HAS_AXI_WUSER => 0,
--      C_HAS_AXI_BUSER => 0,
--      C_HAS_AXI_ARUSER => 0,
--      C_HAS_AXI_RUSER => 0,
--      C_AXI_ARUSER_WIDTH => 1,
--      C_AXI_AWUSER_WIDTH => 1,
--      C_AXI_WUSER_WIDTH => 1,
--      C_AXI_BUSER_WIDTH => 1,
--      C_AXI_RUSER_WIDTH => 1,
--      C_HAS_AXIS_TDATA => 0,
--      C_HAS_AXIS_TID => 0,
--      C_HAS_AXIS_TDEST => 0,
--      C_HAS_AXIS_TUSER => 0,
--      C_HAS_AXIS_TREADY => 1,
--      C_HAS_AXIS_TLAST => 1,
--      C_HAS_AXIS_TSTRB => 0,
--      C_HAS_AXIS_TKEEP => 0,
--      C_AXIS_TDATA_WIDTH => 1,
--      C_AXIS_TID_WIDTH => 1,
--      C_AXIS_TDEST_WIDTH => 1,
--      C_AXIS_TUSER_WIDTH => 1,
--      C_AXIS_TSTRB_WIDTH => 1,
--      C_AXIS_TKEEP_WIDTH => 1,
--      C_WACH_TYPE => 0,
--      C_WDCH_TYPE => 0,
--      C_WRCH_TYPE => 0,
--      C_RACH_TYPE => 0,
--      C_RDCH_TYPE => 0,
--      C_AXIS_TYPE => 0,
--      C_IMPLEMENTATION_TYPE_WACH => 12,
--      C_IMPLEMENTATION_TYPE_WDCH => 11,
--      C_IMPLEMENTATION_TYPE_WRCH => 12,
--      C_IMPLEMENTATION_TYPE_RACH => 12,
--      C_IMPLEMENTATION_TYPE_RDCH => 11,
--      C_IMPLEMENTATION_TYPE_AXIS => 11,
--      C_APPLICATION_TYPE_WACH => 0,
--      C_APPLICATION_TYPE_WDCH => 0,
--      C_APPLICATION_TYPE_WRCH => 0,
--      C_APPLICATION_TYPE_RACH => 0,
--      C_APPLICATION_TYPE_RDCH => 0,
--      C_APPLICATION_TYPE_AXIS => 1,
--      C_PRIM_FIFO_TYPE_WACH => "512x36",
--      C_PRIM_FIFO_TYPE_WDCH => "1kx36",
--      C_PRIM_FIFO_TYPE_WRCH => "512x36",
--      C_PRIM_FIFO_TYPE_RACH => "512x36",
--      C_PRIM_FIFO_TYPE_RDCH => "1kx36",
--      C_PRIM_FIFO_TYPE_AXIS => "512x36",
--      C_USE_ECC_WACH => 0,
--      C_USE_ECC_WDCH => 0,
--      C_USE_ECC_WRCH => 0,
--      C_USE_ECC_RACH => 0,
--      C_USE_ECC_RDCH => 0,
--      C_USE_ECC_AXIS => 0,
--      C_ERROR_INJECTION_TYPE_WACH => 0,
--      C_ERROR_INJECTION_TYPE_WDCH => 0,
--      C_ERROR_INJECTION_TYPE_WRCH => 0,
--      C_ERROR_INJECTION_TYPE_RACH => 0,
--      C_ERROR_INJECTION_TYPE_RDCH => 0,
--      C_ERROR_INJECTION_TYPE_AXIS => 0,
--      C_DIN_WIDTH_WACH => 32,
--      C_DIN_WIDTH_WDCH => 64,
--      C_DIN_WIDTH_WRCH => 2,
--      C_DIN_WIDTH_RACH => 32,
--      C_DIN_WIDTH_RDCH => 64,
--      C_DIN_WIDTH_AXIS => 1,
--      C_WR_DEPTH_WACH => 16,
--      C_WR_DEPTH_WDCH => 1024,
--      C_WR_DEPTH_WRCH => 16,
--      C_WR_DEPTH_RACH => 16,
--      C_WR_DEPTH_RDCH => 1024,
--      C_WR_DEPTH_AXIS => 16,
--      C_WR_PNTR_WIDTH_WACH => ADDR_BITS,
--      C_WR_PNTR_WIDTH_WDCH => 10,
--      C_WR_PNTR_WIDTH_WRCH => ADDR_BITS,
--      C_WR_PNTR_WIDTH_RACH => ADDR_BITS,
--      C_WR_PNTR_WIDTH_RDCH => 10,
--      C_WR_PNTR_WIDTH_AXIS => ADDR_BITS,
--      C_HAS_DATA_COUNTS_WACH => 0,
--      C_HAS_DATA_COUNTS_WDCH => 0,
--      C_HAS_DATA_COUNTS_WRCH => 0,
--      C_HAS_DATA_COUNTS_RACH => 0,
--      C_HAS_DATA_COUNTS_RDCH => 0,
--      C_HAS_DATA_COUNTS_AXIS => 3,
--      C_HAS_PROG_FLAGS_WACH => 0,
--      C_HAS_PROG_FLAGS_WDCH => 0,
--      C_HAS_PROG_FLAGS_WRCH => 0,
--      C_HAS_PROG_FLAGS_RACH => 0,
--      C_HAS_PROG_FLAGS_RDCH => 0,
--      C_HAS_PROG_FLAGS_AXIS => 0,
--      C_PROG_FULL_TYPE_WACH => 0,
--      C_PROG_FULL_TYPE_WDCH => 0,
--      C_PROG_FULL_TYPE_WRCH => 0,
--      C_PROG_FULL_TYPE_RACH => 0,
--      C_PROG_FULL_TYPE_RDCH => 0,
--      C_PROG_FULL_TYPE_AXIS => 0,
--      C_PROG_FULL_THRESH_ASSERT_VAL_WACH => 15,
--      C_PROG_FULL_THRESH_ASSERT_VAL_WDCH => 1023,
--      C_PROG_FULL_THRESH_ASSERT_VAL_WRCH => 15,
--      C_PROG_FULL_THRESH_ASSERT_VAL_RACH => 15,
--      C_PROG_FULL_THRESH_ASSERT_VAL_RDCH => 1023,
--      C_PROG_FULL_THRESH_ASSERT_VAL_AXIS => 15,
--      C_PROG_EMPTY_TYPE_WACH => 0,
--      C_PROG_EMPTY_TYPE_WDCH => 0,
--      C_PROG_EMPTY_TYPE_WRCH => 0,
--      C_PROG_EMPTY_TYPE_RACH => 0,
--      C_PROG_EMPTY_TYPE_RDCH => 0,
--      C_PROG_EMPTY_TYPE_AXIS => 0,
--      C_PROG_EMPTY_THRESH_ASSERT_VAL_WACH => 13,
--      C_PROG_EMPTY_THRESH_ASSERT_VAL_WDCH => 1021,
--      C_PROG_EMPTY_THRESH_ASSERT_VAL_WRCH => 13,
--      C_PROG_EMPTY_THRESH_ASSERT_VAL_RACH => 13,
--      C_PROG_EMPTY_THRESH_ASSERT_VAL_RDCH => 1021,
--      C_PROG_EMPTY_THRESH_ASSERT_VAL_AXIS => 13,
--      C_REG_SLICE_MODE_WACH => 0,
--      C_REG_SLICE_MODE_WDCH => 0,
--      C_REG_SLICE_MODE_WRCH => 0,
--      C_REG_SLICE_MODE_RACH => 0,
--      C_REG_SLICE_MODE_RDCH => 0,
--      C_REG_SLICE_MODE_AXIS => 0
--    )
--    PORT MAP (
--      backup => '0',
--      backup_marker => '0',
--      clk => '0',
--      rst => '0',
--      srst => '0',
--      wr_clk => '0',
--      wr_rst => '0',
--      rd_clk => '0',
--      rd_rst => '0',
--      din => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 18)),
--      wr_en => '0',
--      rd_en => '0',
--      prog_empty_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0,ADDR_BITS)),
--      prog_empty_thresh_assert => STD_LOGIC_VECTOR(TO_UNSIGNED(0,ADDR_BITS)),
--      prog_empty_thresh_negate => STD_LOGIC_VECTOR(TO_UNSIGNED(0,ADDR_BITS)),
--      prog_full_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      prog_full_thresh_assert => STD_LOGIC_VECTOR(TO_UNSIGNED(0,ADDR_BITS)),
--      prog_full_thresh_negate => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      int_clk => '0',
--      injectdbiterr => '0',
--      injectsbiterr => '0',
--      sleep => '0',
--      m_aclk => rd_clk,
--      s_aclk => wr_clk,
--      s_aresetn => rstn,
--      m_aclk_en => '0',
--      s_aclk_en => '0',
--      s_axi_awid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axi_awaddr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
--      s_axi_awlen => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
--      s_axi_awsize => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
--      s_axi_awburst => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
--      s_axi_awlock => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axi_awcache => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
--      s_axi_awprot => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
--      s_axi_awqos => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
--      s_axi_awregion => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
--      s_axi_awuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axi_awvalid => '0',
--      s_axi_wid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axi_wdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
--      s_axi_wstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
--      s_axi_wlast => '0',
--      s_axi_wuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axi_wvalid => '0',
--      s_axi_bready => '0',
--      m_axi_awready => '0',
--      m_axi_wready => '0',
--      m_axi_bid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      m_axi_bresp => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
--      m_axi_buser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      m_axi_bvalid => '0',
--      s_axi_arid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axi_araddr => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
--      s_axi_arlen => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 8)),
--      s_axi_arsize => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
--      s_axi_arburst => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
--      s_axi_arlock => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axi_arcache => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
--      s_axi_arprot => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 3)),
--      s_axi_arqos => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
--      s_axi_arregion => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 4)),
--      s_axi_aruser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axi_arvalid => '0',
--      s_axi_rready => '0',
--      m_axi_arready => '0',
--      m_axi_rid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      m_axi_rdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 64)),
--      m_axi_rresp => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 2)),
--      m_axi_rlast => '0',
--      m_axi_ruser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      m_axi_rvalid => '0',
--      s_axis_tvalid => din_vld,
--      s_axis_tready => open,
--      s_axis_tdata => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axis_tstrb => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axis_tkeep => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axis_tlast => din_rdy_i,
--      s_axis_tid => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axis_tdest => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      s_axis_tuser => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 1)),
--      m_axis_tvalid => dout_vld_i,
--      m_axis_tready => m_axis_tready,
--      m_axis_tlast => m_axis_tlast,
--      axi_aw_injectsbiterr => '0',
--      axi_aw_injectdbiterr => '0',
--      axi_aw_prog_full_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      axi_aw_prog_empty_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      axi_w_injectsbiterr => '0',
--      axi_w_injectdbiterr => '0',
--      axi_w_prog_full_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
--      axi_w_prog_empty_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
--      axi_b_injectsbiterr => '0',
--      axi_b_injectdbiterr => '0',
--      axi_b_prog_full_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      axi_b_prog_empty_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0,ADDR_BITS)),
--      axi_ar_injectsbiterr => '0',
--      axi_ar_injectdbiterr => '0',
--      axi_ar_prog_full_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      axi_ar_prog_empty_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      axi_r_injectsbiterr => '0',
--      axi_r_injectdbiterr => '0',
--      axi_r_prog_full_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
--      axi_r_prog_empty_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 10)),
--      axis_injectsbiterr => '0',
--      axis_injectdbiterr => '0',
--      axis_prog_full_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      axis_prog_empty_thresh => STD_LOGIC_VECTOR(TO_UNSIGNED(0, ADDR_BITS)),
--      axis_wr_data_count => wr_used_i,
--      axis_rd_data_count => open
--    );



end generate NEW_INTRO3;

end rtl;

