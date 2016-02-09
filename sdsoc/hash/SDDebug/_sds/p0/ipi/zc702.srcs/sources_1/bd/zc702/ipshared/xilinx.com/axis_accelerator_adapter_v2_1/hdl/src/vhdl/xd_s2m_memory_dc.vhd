-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : xd_s2m_memory_dc.vhd
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

-- Design note: Normally, a gray counter is implemented using a binary counter
-- and transfor the output to gray. However, in this design, the number of bit
-- for the gray counters is 4 worst case (C_MULTIBUFFER_DEPTH = 8). In this
-- situation we can use a look-up based approach (LUT4 for each bit). For a
-- gray counter of N bits, gray_inc function should infer a table of 2**N elements.
  
library ieee;
use ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;
use axis_accelerator_adapter_v2_1_6.arg_mem_bank;
use axis_accelerator_adapter_v2_1_6.iarg_columnized_mem_bank;




entity xd_s2m_memory_dc is
  generic (
    -- System generics:
    C_FAMILY               : string;     -- Xilinx FPGA family
    C_MTBF_STAGES          : integer;
    C_BRAM_TYPE            : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    CONV_DATA_WIDTH        : integer;
    CONV_ADDR_WIDTH        : integer;
    C_AP_ARG_WIDTH         : integer;
    C_AP_ARG_N_DIM         : integer;
    C_AP_ARG_DIM_1         : integer;
    C_AP_ARG_DIM_2         : integer;
    C_AP_ARG_FORMAT_TYPE   : integer;
    C_AP_ARG_FORMAT_FACTOR : integer;
    C_AP_ARG_FORMAT_DIM    : integer;
    C_AP_ARG_DATA_WIDTH    : integer;
    C_AP_ARG_ADDR_WIDTH    : integer;
    C_MULTIBUFFER_DEPTH    : integer;
    C_NONE                 : integer := 2;
    C_EXTRA_SYNCS          : integer := 1);
  port (
    clk          : in  std_logic;
    rst          : in  std_logic;
    conv_addr    : in  std_logic_vector(CONV_ADDR_WIDTH-1 downto 0);
    conv_ce      : in  std_logic;
    conv_we      : in  std_logic;
    conv_last    : in  std_logic;
    conv_rdy     : out std_logic;
    conv_data    : in  std_logic_vector(CONV_DATA_WIDTH-1 downto 0);
    ap_clk       : in  std_logic;
    ap_rst       : in  std_logic;
    ap_arg_addr  : in  std_logic_vector(C_AP_ARG_ADDR_WIDTH-1 downto 0);
    ap_arg_ce    : in  std_logic;
    ap_arg_we    : in  std_logic;
    ap_arg_din   : in  std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    ap_arg_dout  : out std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    mb_arg_rdy   : out std_logic;
    mb_arg_done  : in  std_logic;
    status_empty : out std_logic := '0';
    status_full  : out std_logic := '1';
    status_used  : out std_logic_vector(3 downto 0));  -- Number of used buffers
end entity;

architecture rtl of xd_s2m_memory_dc is

  ------------------------------------
  function calc_use_columnized_bank return boolean is
    variable ret : boolean := false;
  begin
    if (C_AP_ARG_N_DIM = 2) then
      if(C_AP_ARG_FORMAT_TYPE = FORMAT_TYPE_RESHAPE_BLOCK) then
        if(C_AP_ARG_FORMAT_DIM = 1 and C_AP_ARG_FORMAT_FACTOR > 1) then
          ret := true;
        end if;
      end if;
    end if;
    return ret;
  end function calc_use_columnized_bank;


  constant PTR_WIDTH           : integer := if_then_else((C_MULTIBUFFER_DEPTH = 1),1,log2(C_MULTIBUFFER_DEPTH));
  constant GRAY_WIDTH          : integer := calc_gray_width(C_MULTIBUFFER_DEPTH);
  constant INIT_RD_GRAY        : integer := 0;
  constant INIT_WR_GRAY        : integer := INIT_RD_GRAY;
  constant INIT_WR_GRAY_AHEAD  : integer := INIT_RD_GRAY-C_MULTIBUFFER_DEPTH+1;
  constant USE_COLUMNIZED_BANK : boolean := calc_use_columnized_bank;

  signal empty_n        : std_logic;
  signal ap_rstn        : std_logic;
  signal rstn        : std_logic;
  signal mb_arg_rdy_i        : std_logic;
  signal full_n         : std_logic;
  -- pragma translate_off
  signal empty          : std_logic;
  signal full           : std_logic;
  -- pragma translate_on
  signal status_empty_i : std_logic;
  -- Multibuffer push/pop
  signal mb_push        : std_logic;
  signal m_axis_tlast        : std_logic;
  signal m_axis_tvalid        : std_logic;
  signal mb_pop         : std_logic;
  signal mb_push_ok     : std_logic;
  signal mb_pop_ok      : std_logic;
  -- Selection for read buffer
  signal rd_ptr         : unsigned(PTR_WIDTH-1 downto 0);
  signal rd_pntr         : std_logic_vector(PTR_WIDTH-1 downto 0);
  signal rd_pntr_wr      : std_logic_vector(PTR_WIDTH-1 downto 0);
  signal axis_rd_data_count         : std_logic_vector(PTR_WIDTH downto 0);
  signal rd_ptr_dec     : std_logic_vector(C_MULTIBUFFER_DEPTH-1 downto 0);
  signal rd_gray        : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal rd_gray_wr     : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal next_rd_gray   : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal next_rd_gray_wr: std_logic_vector(GRAY_WIDTH-1 downto 0);
  -- Gray read counter synchronized with read clk
  signal rd_gray_sync   : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal rd_bin         : unsigned(GRAY_WIDTH-1 downto 0);
  signal rd_bins         : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal wr_bin         : unsigned(GRAY_WIDTH-1 downto 0);
  signal wr_bins         : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal ptr_dist       : unsigned(GRAY_WIDTH-1 downto 0);
  signal pntr_dist       : std_logic_vector(PTR_WIDTH-1 downto 0);
  -- Selection for write buffer
  signal wr_ptr         : unsigned(PTR_WIDTH-1 downto 0);
  signal wr_pntr         : std_logic_vector(PTR_WIDTH-1 downto 0);
  signal wr_pntr_rd         : std_logic_vector(PTR_WIDTH-1 downto 0);
  signal axis_wr_data_count         : std_logic_vector(PTR_WIDTH downto 0);
  signal wr_ptr_dec     : std_logic_vector(C_MULTIBUFFER_DEPTH-1 downto 0);
  signal wr_gray        : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal wr_gray_rd        : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal wr_gray_ahead  : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal wr_gray_ahead_rd  : std_logic_vector(GRAY_WIDTH-1 downto 0);

begin


EXISTING : if (C_EXTRA_SYNCS = 0) generate

begin

  -- pragma translate_off
  empty <= not(empty_n);
  full  <= not(full_n);
  -- pragma translate_on

  -- New buffer is filled is last data beat is written and the multibuffer is
  -- not full
  mb_push <= full_n and conv_ce and conv_last;
  -- Active buffer has been consumed when signal "mb_arg_done" is activated and
  -- the multibuffer is not empty.
  mb_pop  <= empty_n and mb_arg_done;

  -- Pointer to write buffer
  process(clk, ap_rst)
  begin
    if(ap_rst = '1') then
      wr_ptr        <= (others => '0');
      wr_ptr_dec    <= (others => '0');
      wr_ptr_dec(0) <= '1';
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        if(wr_ptr = C_MULTIBUFFER_DEPTH-1) then
          wr_ptr <= (others => '0');
        else
          wr_ptr <= wr_ptr + 1;
        end if;
        wr_ptr_dec <= wr_ptr_dec(C_MULTIBUFFER_DEPTH-2 downto 0) & wr_ptr_dec(C_MULTIBUFFER_DEPTH-1);
      end if;
    end if;
  end process;

  -- Gray pointers (write) to manage status of multibuffer
  process(clk, ap_rst)
  begin
    if(ap_rst = '1') then
      wr_gray_ahead <= bin2gray(INIT_WR_GRAY_AHEAD,GRAY_WIDTH);
      wr_gray       <= bin2gray(INIT_WR_GRAY, GRAY_WIDTH);
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        wr_gray_ahead <= gray_inc(wr_gray_ahead);
        wr_gray       <= gray_inc(wr_gray);
      end if;
    end if;
  end process;

  -- Generation of status full signal
  process(clk, ap_rst)
  begin
    if(ap_rst = '1') then
      full_n <= '0';
    elsif(clk'event and clk = '1') then
      if(full_n = '0') then
        -- Stay in full if wr_gray_ahead = next_rd_gray
        if(wr_gray_ahead = next_rd_gray) then
          full_n <= '0';
        else
          full_n <= '1';
        end if;
      else
        -- Move to full if writting and wr_gray_ahead = rd_gray
        if(wr_gray_ahead = rd_gray) then
          full_n <= not(mb_push_ok);
        else
          full_n <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Selection pointer for read buffer (pop)
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      rd_ptr        <= (others => '0');
      rd_ptr_dec    <= (others => '0');
      rd_ptr_dec(0) <= '1';
    elsif(ap_clk'event and ap_clk = '1') then
      if (mb_pop_ok = '1') then
        if(rd_ptr = C_MULTIBUFFER_DEPTH-1) then
          rd_ptr <= (others => '0');
        else
          rd_ptr <= rd_ptr + 1;
        end if;
        rd_ptr_dec <= rd_ptr_dec(C_MULTIBUFFER_DEPTH-2 downto 0) & rd_ptr_dec(C_MULTIBUFFER_DEPTH-1);
      end if;
    end if;
  end process;

  -- Gray pointers (read) to manage the status of multibuffer
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      next_rd_gray <= bin2gray(INIT_RD_GRAY+1, GRAY_WIDTH);
      rd_gray      <= bin2gray(INIT_RD_GRAY, GRAY_WIDTH);
    elsif(ap_clk'event and ap_clk = '1') then
      if (mb_pop_ok = '1') then
        next_rd_gray <= gray_inc(next_rd_gray);
        rd_gray      <= next_rd_gray;
      end if;
    end if;
  end process;

  -- Generation of empty status signal 
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      empty_n <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      if(empty_n = '0') then
        -- Stay in empty if rd_gray = wr_gray
        if(rd_gray = wr_gray) then
          empty_n <= '0';
        else
          empty_n <= '1';
        end if;
      else
        -- Move to empty if reading and next_rd_gray = wr_gray
        if(next_rd_gray = wr_gray) then
          empty_n <= not(mb_pop_ok);
        else
          empty_n <= '1';
        end if;
      end if;
    end if;
  end process;

  mb_push_ok <= mb_push and full_n;
  mb_pop_ok  <= mb_pop and empty_n;

  conv_rdy   <= full_n;
  mb_arg_rdy <= empty_n;


  -----------------
  -- STATUS INFO --
  -----------------

  -- Following logic is used to provide status information to software. Among
  -- others this information includes:
  --  * empty signal
  --  * full signal
  --  * Number of buffers used
  -- All this status information should be provided on the AXI clock domain

  -- NUMBER OF USED BUFFERS:
  -- this value is calculated based on the distance between the read and write
  -- pointers.

  -- Synchronization of rd_gray to reduce metastability issues. This will
  -- introduce a latency of one clock on rd_clk
  process(clk, ap_rst)
  begin
    if(ap_rst = '1') then
      rd_gray_sync <= bin2gray(INIT_RD_GRAY, GRAY_WIDTH);
    elsif(clk'event and clk = '1') then
      rd_gray_sync <= rd_gray;
    end if;
  end process;

  rd_bin <= unsigned(gray2bin(rd_gray_sync));

  process(clk, ap_rst)
  begin
    if(ap_rst = '1') then
      wr_bin <= to_unsigned(INIT_WR_GRAY, GRAY_WIDTH);
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        wr_bin <= wr_bin + 1;
      end if;
    end if;
  end process;

  -- If comparing pointers happens during write, then there will be a one cycle
  -- latency to reflect the status of the fifo. To refresh inmediately, during
  -- a write we increment the counter.
  process(clk, ap_rst)
  begin
    if(ap_rst = '1') then
      ptr_dist <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        ptr_dist <= ptr_dist + 1;
      else
        -- This is also valid when we arrive at the end of counting sequence
        -- for wr_bin < rd_bin
        ptr_dist <= wr_bin - rd_bin;
      end if;
    end if;
  end process;

  process(ptr_dist)
  begin
    status_used                 <= (others => '0');
    status_used(ptr_dist'range) <= std_logic_vector(ptr_dist);
  end process;

  -- STATUS FULL:
  -- this signal is generated in the AXI clock domain; Hence, status_full
  -- is just a simple copy of the internal signal
  status_full <= not(full_n);

  -- STATUS EMPTY:
  -- This signal represents the empty status of the multibiffer from the point
  -- of view of the write port (AXI clock domain)
  process(clk, ap_rst)
  begin
    if(ap_rst = '1') then
      status_empty_i <= '1';
    elsif(clk'event and clk = '1') then
      -- If write, we exit the empty condition inmediately
      if(mb_push_ok = '1') then
        status_empty_i <= '0';
      else
        -- Stay in empty if rd_gray = wr_gray
        if(rd_gray = wr_gray) then
          status_empty_i <= '1';
        else
          status_empty_i <= '0';
        end if;
      end if;
    end if;
  end process;

  status_empty <= status_empty_i;

end generate EXISTING;
------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------
NEW_INTRO : if (C_EXTRA_SYNCS = 1) generate
   CONSTANT LOG2DEPTH                       : integer := log2(C_MULTIBUFFER_DEPTH);
     CONSTANT ONE       : std_logic_vector(PTR_WIDTH-1 DOWNTO 0) 
    := int2lv(1, PTR_WIDTH);

 begin  

   
  -- pragma translate_off
  empty <= not(empty_n);
  full  <= not(full_n);
  ap_rstn  <= not(ap_rst);
  rstn  <= not(rst);
  -- pragma translate_on

  -- New buffer is filled is last data beat is written and the multibuffer is
  -- not full
  mb_push <= full_n and conv_ce and conv_last;
  -- Active buffer has been consumed when signal "mb_arg_done" is activated and
  -- the multibuffer is not empty.
  mb_pop  <= empty_n and mb_arg_done;

  -- Pointer to write buffer
  process(clk, rst)
  begin
    if(rst = '1') then
      wr_pntr        <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        if(wr_pntr = int2lv(C_MULTIBUFFER_DEPTH-1,PTR_WIDTH)) then
          wr_pntr <= (others => '0');
        else
          wr_pntr <= wr_pntr + ONE;
        end if;
      end if;
    end if;
  end process;


 process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      rd_pntr        <= (others => '0');
    elsif(ap_clk'event and ap_clk = '1') then
      if (mb_pop_ok = '1') then
        if(rd_pntr =int2lv(C_MULTIBUFFER_DEPTH-1,PTR_WIDTH)) then
          rd_pntr <= (others => '0');
        else
          rd_pntr <= rd_pntr + ONE;
        end if;
      end if;
    end if;
  end process;




    -- Gray pointers (write) to manage status of multibuffer
  process(clk, rst)
  begin
    if(rst = '1') then
      wr_gray_ahead <= bin2gray(INIT_WR_GRAY_AHEAD,GRAY_WIDTH);
      wr_gray       <= bin2gray(INIT_WR_GRAY, GRAY_WIDTH);
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        wr_gray_ahead <= gray_inc(wr_gray_ahead);
        wr_gray       <= gray_inc(wr_gray);
      end if;
    end if;
  end process;


    -- Gray pointers (read) to manage the status of multibuffer
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      next_rd_gray <= bin2gray(INIT_RD_GRAY+1, GRAY_WIDTH);
      rd_gray      <= bin2gray(INIT_RD_GRAY, GRAY_WIDTH);
    elsif(ap_clk'event and ap_clk = '1') then
      if (mb_pop_ok = '1') then
        next_rd_gray <= gray_inc(next_rd_gray);
        rd_gray      <= next_rd_gray;
      end if;
    end if;
  end process;


  
      clkx_1: ENTITY axis_accelerator_adapter_v2_1_6.clk_x_pntrs
        GENERIC MAP(
          C_HAS_RST              => 1,
          C_RD_PNTR_WIDTH        => GRAY_WIDTH,     
          C_WR_PNTR_WIDTH        => GRAY_WIDTH,
          C_MSGON_VAL            => 1,
          C_SYNCHRONIZER_STAGE   => C_MTBF_STAGES
          )
        PORT MAP(
          WR_CLK         => clk,   
          RD_CLK         => ap_clk,   
          WR_RST         => rst,   
          RD_RST         => ap_rst,   
          WR_PNTR        => wr_gray,   
          RD_PNTR        => rd_gray,   
          WR_PNTR_RD     => wr_gray_rd,   
          RD_PNTR_WR     => rd_gray_wr     
          );

      clkx_2: ENTITY axis_accelerator_adapter_v2_1_6.clk_x_pntrs
        GENERIC MAP(
          C_HAS_RST              => 1,
          C_RD_PNTR_WIDTH        => GRAY_WIDTH,     
          C_WR_PNTR_WIDTH        => GRAY_WIDTH,
          C_MSGON_VAL            => 1,
          C_SYNCHRONIZER_STAGE   => C_MTBF_STAGES
          )
        PORT MAP(
          WR_CLK         => clk,   
          RD_CLK         => ap_clk,   
          WR_RST         => rst,   
          RD_RST         => ap_rst,   
          WR_PNTR        => wr_gray_ahead,   
          RD_PNTR        => next_rd_gray,   
          WR_PNTR_RD     => wr_gray_ahead_rd,   
          RD_PNTR_WR     => next_rd_gray_wr     
          );

       clkx_3: ENTITY axis_accelerator_adapter_v2_1_6.clk_x_pntrs
        GENERIC MAP(
          C_HAS_RST              => 1,
          C_RD_PNTR_WIDTH        => PTR_WIDTH,     
          C_WR_PNTR_WIDTH        => PTR_WIDTH,
          C_MSGON_VAL            => 1,
          C_SYNCHRONIZER_STAGE   => C_MTBF_STAGES
          )
        PORT MAP(
          WR_CLK         => clk,   
          RD_CLK         => ap_clk,   
          WR_RST         => rst,   
          RD_RST         => ap_rst,   
          WR_PNTR        => wr_pntr,   
          RD_PNTR        => rd_pntr,   
          WR_PNTR_RD     => wr_pntr_rd,   
          RD_PNTR_WR     => rd_pntr_wr     
          );





       -- Generation of status full signal
  process(clk, rst)
  begin
    if(rst = '1') then
      full_n <= '0';
    elsif(clk'event and clk = '1') then
      if(full_n = '0') then
        -- Stay in full if wr_gray_ahead = next_rd_gray
        if(wr_gray_ahead = next_rd_gray_wr) then
          full_n <= '0';
        else
          full_n <= '1';
        end if;
      else
        -- Move to full if writting and wr_gray_ahead = rd_gray
        if(wr_gray_ahead = rd_gray_wr) then
          full_n <= not(mb_push_ok);
        else
          full_n <= '1';
        end if;
      end if;
    end if;
  end process;

    -- Generation of empty status signal 
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      empty_n <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      if(empty_n = '0') then
        -- Stay in empty if rd_gray = wr_gray
        if(rd_gray = wr_gray_rd) then
          empty_n <= '0';
        else
          empty_n <= '1';
        end if;
      else
        -- Move to empty if reading and next_rd_gray = wr_gray
        if(next_rd_gray = wr_gray_rd) then
          empty_n <= not(mb_pop_ok);
        else
          empty_n <= '1';
        end if;
      end if;
    end if;
  end process;

  mb_push_ok <= mb_push and full_n;
  mb_pop_ok  <= mb_pop and empty_n;

  conv_rdy   <= full_n;
  mb_arg_rdy <= empty_n;

--          AP_IRGRDY_SYNC_I : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
--        generic map (
--        C_CDC_TYPE                 => 1,
--        C_RESET_STATE              => 0,
--        C_SINGLE_BIT               => 1,
--        C_FLOP_INPUT               => 1,
--        C_VECTOR_WIDTH             => 2,
--        C_MTBF_STAGES              => C_MTBF_STAGES
--        )
--        port map (
--        prmry_aclk                 => ap_clk,
--        prmry_resetn               => ap_rstn,
--	prmry_in                   => mb_arg_rdy_i,
--        prmry_vect_in              => (others=>'0'),
--
--        scndry_aclk                => clk,
--        scndry_resetn              => rstn,
--        scndry_out                 => mb_arg_rdy,
--        scndry_vect_out            => open
--        );


  


MBn : if (C_MULTIBUFFER_DEPTH > 1) generate
begin
 process(clk, rst)
  begin
    if(rst = '1') then
      pntr_dist <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        pntr_dist <= pntr_dist + 1;
     else
      --  pntr_dist <= ('0' & wr_pntr) - ( '0' & rd_pntr_wr);
        pntr_dist <= ( wr_pntr) - ( rd_pntr_wr);
        --pntr_dist <= ( wr_bins) - ( rd_bins);
      end if;
    end if;
  end process;
end generate MBn;

MB1 : if (C_MULTIBUFFER_DEPTH = 1) generate
begin

    rd_bins <= rd_gray_wr;

  process(clk, rst)
  begin
    if(rst = '1') then
      wr_bins <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        wr_bins <= wr_bins + 1;
      end if;
    end if;
  end process;

 process(clk, rst)
  begin
    if(rst = '1') then
      pntr_dist <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_push_ok = '1') then
        pntr_dist <= pntr_dist + 1;
     else
        pntr_dist <= ( wr_bins) - ( rd_bins);
      end if;
    end if;
  end process;
end generate MB1;


  process(pntr_dist)
  begin
    status_used                 <= (others => '0');
    status_used(pntr_dist'range) <= (pntr_dist);
  end process;

    -- STATUS FULL:
  -- this signal is generated in the AXI clock domain; Hence, status_full
  -- is just a simple copy of the internal signal
  status_full <= not(full_n);

  -- STATUS EMPTY:
  -- This signal represents the empty status of the multibiffer from the point
  -- of view of the write port (AXI clock domain)


 process(clk, rst)
  begin
    if(rst = '1') then
      status_empty_i <= '1';
    elsif(clk'event and clk = '1') then
      -- If write, we exit the empty condition inmediately
      if(mb_push_ok = '1') then
        status_empty_i <= '0';
      else
        -- Stay in empty if rd_gray = wr_gray
        if(rd_gray_wr = wr_gray) then
          status_empty_i <= '1';
        else
          status_empty_i <= '0';
        end if;
      end if;
    end if;
  end process;

  status_empty <= status_empty_i;



end generate NEW_INTRO;



    LINEAR_BANK_GEN : if not(USE_COLUMNIZED_BANK) generate
    -- Efective width for input address bus (conv_addr)
    function calc_eff_addr_width return integer is
      variable addr_width : integer;
    begin
      if(CONV_DATA_WIDTH > C_AP_ARG_DATA_WIDTH) then
        addr_width := C_AP_ARG_ADDR_WIDTH-log2(CONV_DATA_WIDTH/C_AP_ARG_DATA_WIDTH);
      else
        addr_width := C_AP_ARG_ADDR_WIDTH+log2(C_AP_ARG_DATA_WIDTH/CONV_DATA_WIDTH);
      end if;
      return addr_width;
    end function calc_eff_addr_width;

    constant EFF_ADDR_WIDTH   : integer := calc_eff_addr_width;
    constant IPORT_ADDR_WIDTH : integer := EFF_ADDR_WIDTH+log2(C_MULTIBUFFER_DEPTH);
    constant OPORT_ADDR_WIDTH : integer := C_AP_ARG_ADDR_WIDTH+log2(C_MULTIBUFFER_DEPTH);

    signal iport_addr : std_logic_vector(IPORT_ADDR_WIDTH-1 downto 0);
    -- Width of address bus of output port is the addition of number of bits
    -- required by input argument plus the required bits to select the
    -- appropiate bank (PTR_WIDTH).
    signal oport_addr : std_logic_vector(OPORT_ADDR_WIDTH-1 downto 0);

  begin
    MB1_addr : if (C_MULTIBUFFER_DEPTH = 1) generate
    begin
    iport_addr <= conv_addr(EFF_ADDR_WIDTH-1 downto 0);
    oport_addr <= ap_arg_addr;
    end generate MB1_addr;

    MBn_addr : if (C_MULTIBUFFER_DEPTH > 1) generate
    begin
     iport_addr <= std_logic_vector(wr_pntr) & conv_addr(EFF_ADDR_WIDTH-1 downto 0);
     oport_addr <= std_logic_vector(rd_pntr) & ap_arg_addr;
    end generate MBn_addr;


    MEM_I : entity axis_accelerator_adapter_v2_1_6.arg_mem_bank
      generic map (
        C_FAMILY       => C_FAMILY,
        C_BRAM_TYPE    => C_BRAM_TYPE,
        C_IS_UNIDIR    => 1,
        C_IPORT_DWIDTH => CONV_DATA_WIDTH,
        C_IPORT_AWIDTH => IPORT_ADDR_WIDTH,
        C_OPORT_DWIDTH => C_AP_ARG_DATA_WIDTH,
        C_OPORT_AWIDTH => OPORT_ADDR_WIDTH)
      port map (
        rst        => ap_rst,
        iport_clk  => clk,
        iport_ce   => conv_ce,
        iport_we   => '1',
        iport_addr => iport_addr,
        iport_din  => conv_data,
        iport_dout => open,
        oport_clk  => ap_clk,
        oport_ce   => ap_arg_ce,
        oport_we   => ap_arg_we,
        oport_addr => oport_addr,
        oport_din  => ap_arg_din,
        oport_dout => ap_arg_dout);
  end generate LINEAR_BANK_GEN;

  COLUMNIZED_BANK_GEN : if (USE_COLUMNIZED_BANK) generate
  begin

    MEM_I : entity axis_accelerator_adapter_v2_1_6.iarg_columnized_mem_bank
      generic map (
        C_FAMILY       => C_FAMILY,
        C_BRAM_TYPE    => C_BRAM_TYPE,
        C_FACTOR       => C_AP_ARG_FORMAT_FACTOR,
        C_BUFFER_WIDTH => PTR_WIDTH,
        C_CONV_AWIDTH  => CONV_ADDR_WIDTH,
        C_CONV_DWIDTH  => CONV_DATA_WIDTH,
        C_ARG_WIDTH    => C_AP_ARG_WIDTH,
        C_ARG_AWIDTH   => C_AP_ARG_ADDR_WIDTH)
      port map (
        ap_rst        => ap_rst,
        clk           => clk,
        conv_ce       => conv_ce,
        conv_we       => conv_we,
        conv_buffer   => std_logic_vector(wr_ptr),
        conv_addr     => conv_addr,
        conv_data     => conv_data,
        ap_clk        => ap_clk,
        ap_arg_ce     => ap_arg_ce,
        ap_arg_we     => ap_arg_we,
        ap_arg_buffer => std_logic_vector(rd_ptr),
        ap_arg_addr   => ap_arg_addr,
        ap_arg_din    => ap_arg_din,
        ap_arg_dout   => ap_arg_dout);

  end generate COLUMNIZED_BANK_GEN;


end rtl;

