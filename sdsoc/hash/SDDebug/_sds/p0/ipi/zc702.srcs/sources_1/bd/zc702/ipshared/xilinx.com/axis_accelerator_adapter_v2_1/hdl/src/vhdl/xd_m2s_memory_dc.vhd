-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : xd_m2s_memory_dc.vhd
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
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;
use axis_accelerator_adapter_v2_1_6.arg_mem_bank;
use axis_accelerator_adapter_v2_1_6.oarg_columnized_mem_bank;
use axis_accelerator_adapter_v2_1_6.srl_fifo_32_wt;


entity xd_m2s_memory_dc is
  generic (
    -- System generics:
    C_FAMILY               : string ;      -- Xilinx FPGA family
    C_MTBF_STAGES          : integer;
    C_BRAM_TYPE            : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    SIZE_WIDTH             : integer;
    CONV_DATA_WIDTH        : integer;
    CONV_ADDR_WIDTH        : integer;
    C_AP_ARG_DATA_WIDTH    : integer;
    C_AP_ARG_ADDR_WIDTH    : integer;
    C_MULTIBUFFER_DEPTH    : integer;
    C_AP_ARG_WIDTH         : integer;
    C_AP_ARG_N_DIM         : integer;
    C_AP_ARG_DIMS          : int_vector;
    C_AP_ARG_DIM_1         : integer;
    C_AP_ARG_DIM_2         : integer;
    C_AP_ARG_FORMAT_TYPE   : integer;
    C_AP_ARG_FORMAT_FACTOR : integer;
    C_AP_ARG_FORMAT_DIM    : integer;
    C_NONE                 : integer := 2);
  port (
    clk           : in  std_logic;
    rst           : in  std_logic;
    conv_addr     : in  std_logic_vector(CONV_ADDR_WIDTH-1 downto 0);
    conv_ce       : in  std_logic;
    conv_we       : in  std_logic;
    conv_last     : in  std_logic;
    conv_rdy      : out std_logic;
    conv_data     : out std_logic_vector(CONV_DATA_WIDTH-1 downto 0);
    conv_size     : out std_logic_vector(SIZE_WIDTH-1 downto 0);
    sw_length     : in  std_logic_vector(31 downto 0);
    sw_length_we  : in  std_logic;
    use_sw_length : in  std_logic;
    ap_clk        : in  std_logic;
    ap_rst        : in  std_logic;
    ap_arg_addr   : in  std_logic_vector(C_AP_ARG_ADDR_WIDTH-1 downto 0);
    ap_arg_ce     : in  std_logic;
    ap_arg_we     : in  std_logic;
    ap_arg_din    : in  std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    ap_arg_dout   : out std_logic_vector(C_AP_ARG_DATA_WIDTH-1 downto 0);
    ap_arg_rqt    : out std_logic;
    ap_arg_ack    : in  std_logic;
    -- Status info
    ap_arg_empty  : out std_logic;
    ap_arg_full   : out std_logic;
    ap_arg_used   : out std_logic_vector(3 downto 0));  -- Number of used buffers
end entity;

architecture rtl of xd_m2s_memory_dc is

  function calc_sw_length_fifo_width return integer is
    variable N_elements : integer;
  begin
    if (C_AP_ARG_N_DIM = 2) then
      N_elements := C_AP_ARG_DIM_1*C_AP_ARG_DIM_2;
    else
      N_elements := C_AP_ARG_DIM_1;
    end if;
    return log2(N_elements)+1;
  end function calc_sw_length_fifo_width;

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

  --------------------------------------------------------------------------
  -- C_AP_ARG_DIMS generic is a vector with range between 1 and C_AP_ARG_N_DIM.
  -- It follows VivadoHLS approach (i.e., dimension 1 is the closest to the
  -- varibale declaration). For example, A[2][4][8]:
  --  C_AP_ARG_DIMS[1] = 2
  --  C_AP_ARG_DIMS[2] = 4
  --  C_AP_ARG_DIMS[3] = 8
  -- For the memory bank organization, it's easier to have this sorted
  -- differently, so it reflects the linear organization in which is stored in
  -- memory. That is, the dimension more far away from definition is 0 and
  -- closest is C_AP_ARG_N_DIM-1. For previous example:
  --  ARG_DIMS[2] = 2
  --  ARG_DIMS[1] = 4
  --  ARG_DIMS[0] = 8
  constant ARG_DIMS     : int_vector(0 to C_AP_ARG_N_DIM-1) := C_AP_ARG_DIMS;
  
  function calc_addr_lsb return int_vector is
    variable lsb_vector : int_vector(C_AP_ARG_N_DIM-1 downto 0);
    variable msb_vector : int_vector(C_AP_ARG_N_DIM-1 downto 0);
    variable lsb        : integer := 0;
    variable dim_width  : integer;
  begin
    for i in 0 to C_AP_ARG_N_DIM-1 loop
      dim_width     := log2(ARG_DIMS(i));
      lsb_vector(i) := lsb;
      msb_vector(i) := lsb+dim_width-1;
      lsb           := lsb + dim_width;
    end loop;
    return lsb_vector;
  end function calc_addr_lsb;

  function calc_addr_msb return int_vector is
    variable lsb_vector : int_vector(C_AP_ARG_N_DIM-1 downto 0);
    variable msb_vector : int_vector(C_AP_ARG_N_DIM-1 downto 0);
    variable lsb        : integer := 0;
    variable dim_width  : integer;
  begin
    for i in 0 to C_AP_ARG_N_DIM-1 loop
      dim_width     := log2(ARG_DIMS(i));
      lsb_vector(i) := lsb;
      msb_vector(i) := lsb+dim_width-1;
      lsb           := lsb + dim_width;
    end loop;
    return msb_vector;
  end function calc_addr_msb;
  
  --constant PTR_WIDTH            : integer                                      := log2(C_MULTIBUFFER_DEPTH);
  constant PTR_WIDTH           : integer := if_then_else((C_MULTIBUFFER_DEPTH = 1),1,log2(C_MULTIBUFFER_DEPTH));
  constant GRAY_WIDTH           : integer                                      := calc_gray_width(C_MULTIBUFFER_DEPTH);
  constant INIT_RD_GRAY         : integer                                      := 0;
  constant INIT_WR_GRAY         : integer                                      := INIT_RD_GRAY;
  constant INIT_WR_GRAY_AHEAD   : integer                                      := INIT_RD_GRAY-C_MULTIBUFFER_DEPTH+1;
  constant conv_din_zero        : std_logic_vector(CONV_DATA_WIDTH-1 downto 0) := (others => '0');
  constant SW_LENGTH_FIFO_WIDTH : integer                                      := calc_sw_length_fifo_width;
  constant USE_COLUMNIZED_BANK  : boolean                                      := calc_use_columnized_bank;

  signal empty_n       : std_logic;
  signal full_n        : std_logic;
  -- Multibuffer push/pop
  signal mb_push       : std_logic;
  signal mb_pop        : std_logic;
  signal mb_push_ok    : std_logic;
  signal mb_pop_ok     : std_logic;
  signal mb_pop_ok1     : std_logic;
  signal mb_pop_ok_rd  : std_logic;
  signal mb_pop_ok_vect: std_logic_vector(0 downto 0);
  --
  signal iport_ce      : std_logic;     -- ap_arg_ce validated with full_n 
  signal oport_ce      : std_logic;     -- conv_ce validated with empty_n
  -- Read buffer selection
  signal rd_ptr        : unsigned(PTR_WIDTH-1 downto 0); 
  signal rd_pntr       : std_logic_vector(PTR_WIDTH-1 downto 0); 
  signal rd_pntr_wr    : std_logic_vector(PTR_WIDTH-1 downto 0); 
  signal rd_ptr_dec    : std_logic_vector(C_MULTIBUFFER_DEPTH-1 downto 0); 
  signal rd_gray       : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal rd_gray_wr    : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal next_rd_gray  : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal next_rd_gray_wr: std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal prev_rd_gray  : std_logic_vector(GRAY_WIDTH-1 downto 0);
  -- Gray counter for writes synchronized with read clock
  signal wr_gray_sync  : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal rd_bin        : unsigned(GRAY_WIDTH-1 downto 0);
  signal rd_bins        : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal wr_bin        : unsigned(GRAY_WIDTH-1 downto 0);
  signal wr_bins        : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal ptr_dist      : unsigned(GRAY_WIDTH-1 downto 0);
  signal pntr_dist     : std_logic_vector(PTR_WIDTH-1 downto 0);
  -- Write buffer selection
  signal wr_ptr        : unsigned(PTR_WIDTH-1 downto 0);
  signal wr_pntr       : std_logic_vector(PTR_WIDTH-1 downto 0);
  signal wr_pntr_rd    : std_logic_vector(PTR_WIDTH-1 downto 0);
  signal wr_ptr_dec    : std_logic_vector(C_MULTIBUFFER_DEPTH-1 downto 0);
  signal wr_gray       : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal wr_gray_rd    : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal wr_gray_ahead : std_logic_vector(GRAY_WIDTH-1 downto 0);
  signal wr_gray_ahead_rd : std_logic_vector(GRAY_WIDTH-1 downto 0);
  -- Only required for almost empty:
  signal prev_wr_gray  : std_logic_vector(GRAY_WIDTH-1 downto 0);

  -- pragma translate_off
  signal empty : std_logic;
  signal full  : std_logic;
  -- pragma translate_on

  signal ap_arg_hw_length : unsigned(C_AP_ARG_ADDR_WIDTH downto 0);
  signal ap_arg_length    : std_logic_vector(C_AP_ARG_ADDR_WIDTH downto 0);

  signal sw_length_fifo_dout : std_logic_vector(SW_LENGTH_FIFO_WIDTH-1 downto 0);
  signal sw_length_wr : std_logic_vector(SW_LENGTH_FIFO_WIDTH-1 downto 0);
  signal sw_length_rd : std_logic_vector(SW_LENGTH_FIFO_WIDTH-1 downto 0);
  signal sw_length_we_vector       : std_logic_vector(0 downto 0);
  signal sw_length_we_rd       : std_logic;
  signal sw_length_we_rd_vector       : std_logic_vector(0 downto 0);
  signal ap_arg_full_i       : std_logic;

  type   length_mem_type is array (2**PTR_WIDTH-1 downto 0) of std_logic_vector(C_AP_ARG_ADDR_WIDTH downto 0);
  signal hw_length_mem      : length_mem_type;
  signal hw_length_mem_dout : std_logic_vector(C_AP_ARG_ADDR_WIDTH downto 0);
  signal hw_length_mem_dout_rd : std_logic_vector(C_AP_ARG_ADDR_WIDTH downto 0);

  attribute ram_style                  : string;
  attribute ram_style of hw_length_mem : signal is "distributed";

  constant C_EXTRA_SYNCS  : integer   := 1; 

begin

  
EXISTING : if (C_EXTRA_SYNCS = 0) generate

begin


  -- pragma translate_off
  empty <= not(empty_n);
  full  <= not(full_n);
  -- pragma translate_on

  -- New buffer has been produced when accelerator generates ack and the
  -- multibuffer is not full.
  mb_push <= full_n and ap_arg_ack;
  -- New buffer consumed when the last data is read and the multibuffer is not
  -- empty.
  mb_pop  <= empty_n and conv_ce and conv_last;

  -- Selection pointer to write buffer (push)
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      wr_ptr        <= (others => '0');
      wr_ptr_dec    <= (others => '0');
      wr_ptr_dec(0) <= '1';
    elsif(ap_clk'event and ap_clk = '1') then
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
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      wr_gray_ahead <= bin2gray(INIT_WR_GRAY_AHEAD, GRAY_WIDTH);
      wr_gray       <= bin2gray(INIT_WR_GRAY, GRAY_WIDTH);
      prev_wr_gray  <= bin2gray(INIT_WR_GRAY-1, GRAY_WIDTH);
    elsif(ap_clk'event and ap_clk = '1') then
      if (mb_push_ok = '1') then
        wr_gray_ahead <= gray_inc(wr_gray_ahead);
        wr_gray       <= gray_inc(wr_gray);
        prev_wr_gray  <= wr_gray;
      end if;
    end if;
  end process;

  -- Full status signal generation
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      full_n <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      if(full_n = '0') then
        -- Stay in full if wr_gray_ahead = next_rd_gray
        if(wr_gray_ahead = next_rd_gray) then
          full_n <= '0';
        else
          full_n <= '1';
        end if;
      else
        -- Go to full if writting and wr_gray_ahead = rd_gray
        if(wr_gray_ahead = rd_gray) then
          full_n <= not(mb_push_ok);
        else
          full_n <= '1';
        end if;
      end if;
    end if;
  end process;

  -- Read buffer selection pointer (pop)
  process(clk, rst)
  begin
    if(rst = '1') then
      rd_ptr        <= (others => '0');
      rd_ptr_dec    <= (others => '0');
      rd_ptr_dec(0) <= '1';
    elsif(clk'event and clk = '1') then
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

  -- Gray pointers (read) to manage status of multibuffer
  process(clk, rst)
  begin
    if(rst = '1') then
      next_rd_gray <= bin2gray(INIT_RD_GRAY+1, GRAY_WIDTH);
      rd_gray      <= bin2gray(INIT_RD_GRAY, GRAY_WIDTH);
      prev_rd_gray <= bin2gray(INIT_RD_GRAY-1, GRAY_WIDTH);
    elsif(clk'event and clk = '1') then
      if (mb_pop_ok = '1') then
        next_rd_gray <= gray_inc(next_rd_gray);
        rd_gray      <= next_rd_gray;
        prev_rd_gray <= rd_gray;
      end if;
    end if;
  end process;

  -- Empty status signal generation:
  process(clk, rst)
  begin
    if(rst = '1') then
      empty_n <= '0';
    elsif(clk'event and clk = '1') then
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

  -- Management of pseudo-static buffers
  -- Para los argumentos de salida no hay buffers pseudo-estáticos.
  mb_pop_ok <= mb_pop and empty_n;

  ---------------------------------------------
  conv_rdy   <= empty_n;
  ap_arg_rqt <= full_n;

  iport_ce <= ap_arg_ce and full_n;
  oport_ce <= conv_ce and empty_n;


  -- Number of used buffers it's calculated as the distance between read/write
  -- pointers

  -- synch wr_gray to reduce metastability. Added one cycle clock latency on rd_clk
  process(clk, rst)
  begin
    if(rst = '1') then
      wr_gray_sync <= bin2gray(INIT_WR_GRAY, GRAY_WIDTH);
    elsif(clk'event and clk = '1') then
      wr_gray_sync <= wr_gray;
    end if;
  end process;

  wr_bin <= unsigned(gray2bin(wr_gray_sync));

  process(clk, rst)
  begin
    if(rst = '1') then
      rd_bin <= to_unsigned(INIT_RD_GRAY, GRAY_WIDTH);
    elsif(clk'event and clk = '1') then
      if (mb_pop_ok = '1') then
        rd_bin <= rd_bin + 1;
      end if;
    end if;
  end process;

  -- If we only look at the pointers, there will be one cycle latency to reflect
  -- the status of the fifo. To refresh inmediately during a read, we decrement
  -- the counter
  process(clk, rst)
  begin
    if(rst = '1') then
      ptr_dist <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_pop_ok = '1') then
        ptr_dist <= ptr_dist - 1;
      else
        -- This ia also valid when we arrive at the end of sequence counter wr_bin < rd_bin
        ptr_dist <= wr_bin - rd_bin;
      end if;
    end if;
  end process;

  process(ptr_dist)
  begin
    ap_arg_used                 <= (others => '0');
    ap_arg_used(ptr_dist'range) <= std_logic_vector(ptr_dist);
  end process;

  -- Status signals empty/full should be synchronized with AXI clk
  ap_arg_empty <= not(empty_n);

  process(clk, rst)
  begin
    if(rst = '1') then
      ap_arg_full_i <= '1';
    elsif(clk'event and clk = '1') then
      -- If read, we move out of full state
      if(mb_pop_ok = '1') then
        ap_arg_full_i <= '0';
      else
        -- Stay in full if wr_gray_ahead = next_rd_gray
        if(wr_gray_ahead = next_rd_gray) then
          ap_arg_full_i <= '1';
        else
          ap_arg_full_i <= '0';
        end if;
      end if;
    end if;
  end process;

  ap_arg_full <= ap_arg_full_i;

end generate EXISTING;


NEW_INTRO : if (C_EXTRA_SYNCS = 1) generate
   CONSTANT LOG2DEPTH                       : integer := log2(C_MULTIBUFFER_DEPTH);
     CONSTANT ONE       : std_logic_vector(PTR_WIDTH-1 DOWNTO 0) 
    := int2lv(1, PTR_WIDTH);

 begin  

   
  -- pragma translate_off
  empty <= not(empty_n);
  full  <= not(full_n);
  -- pragma translate_on

  -- New buffer has been produced when accelerator generates ack and the
  -- multibuffer is not full.
  mb_push <= full_n and ap_arg_ack;
  -- New buffer consumed when the last data is read and the multibuffer is not
  -- empty.
  mb_pop  <= empty_n and conv_ce and conv_last;

  -- Selection pointer to write buffer (push)
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      wr_pntr        <= (others => '0');
    elsif(ap_clk'event and ap_clk = '1') then
      if (mb_push_ok = '1') then
        if(wr_pntr = int2lv(C_MULTIBUFFER_DEPTH-1,PTR_WIDTH)) then
          wr_pntr <= (others => '0');
        else
          wr_pntr <= wr_pntr + ONE;
        end if;
      end if;
    end if;
  end process;


  process(clk, rst)
  begin
    if(rst = '1') then
      rd_pntr        <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_pop_ok_rd = '1') then
        if(rd_pntr = int2lv(C_MULTIBUFFER_DEPTH-1,PTR_WIDTH)) then
          rd_pntr <= (others => '0');
        else
          rd_pntr <= rd_pntr + ONE;
        end if;
      end if;
    end if;
  end process;


    -- Gray pointers (write) to manage status of multibuffer
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      wr_gray_ahead <= bin2gray(INIT_WR_GRAY_AHEAD, GRAY_WIDTH);
      wr_gray       <= bin2gray(INIT_WR_GRAY, GRAY_WIDTH);
      prev_wr_gray  <= bin2gray(INIT_WR_GRAY-1, GRAY_WIDTH);
    elsif(ap_clk'event and ap_clk = '1') then
      if (mb_push_ok = '1') then
        wr_gray_ahead <= gray_inc(wr_gray_ahead);
        wr_gray       <= gray_inc(wr_gray);
        prev_wr_gray  <= wr_gray;
      end if;
    end if;
  end process;

    -- Gray pointers (read) to manage status of multibuffer
  process(clk, rst)
  begin
    if(rst = '1') then
      next_rd_gray <= bin2gray(INIT_RD_GRAY+1, GRAY_WIDTH);
      rd_gray      <= bin2gray(INIT_RD_GRAY, GRAY_WIDTH);
      prev_rd_gray <= bin2gray(INIT_RD_GRAY-1, GRAY_WIDTH);
    elsif(clk'event and clk = '1') then
      if (mb_pop_ok_rd = '1') then
        next_rd_gray <= gray_inc(next_rd_gray);
        rd_gray      <= next_rd_gray;
        prev_rd_gray <= rd_gray;
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
          WR_CLK         => ap_clk,   
          RD_CLK         => clk,   
          WR_RST         => ap_rst,   
          RD_RST         => rst,   
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
          WR_CLK         => ap_clk,   
          RD_CLK         => clk,   
          WR_RST         => ap_rst,   
          RD_RST         => rst,   
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
          WR_CLK         => ap_clk,   
          RD_CLK         => clk,   
          WR_RST         => ap_rst,   
          RD_RST         => rst,   
          WR_PNTR        => wr_pntr,   
          RD_PNTR        => rd_pntr,   
          WR_PNTR_RD     => wr_pntr_rd,   
          RD_PNTR_WR     => rd_pntr_wr     
          );




    -- Full status signal generation
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      full_n <= '0';
    elsif(ap_clk'event and ap_clk = '1') then
      if(full_n = '0') then
        -- Stay in full if wr_gray_ahead = next_rd_gray
        if(wr_gray_ahead = next_rd_gray_wr) then
          full_n <= '0';
        else
          full_n <= '1';
        end if;
      else
        -- Go to full if writting and wr_gray_ahead = rd_gray
        if(wr_gray_ahead = rd_gray_wr) then
          full_n <= not(mb_push_ok);
        else
          full_n <= '1';
        end if;
      end if;
    end if;
  end process;





      prd1: PROCESS (clk, rst)
      BEGIN
       -- Register Stage #1 
        IF (rst = '1') THEN
          mb_pop_ok1 <= '0';
          mb_pop_ok_rd <= '0';
        ELSIF (clk'event and clk = '1') THEN
          mb_pop_ok1 <= mb_pop_ok;
          mb_pop_ok_rd <= mb_pop_ok1;
        END IF;
        END PROCESS prd1;



    -- Empty status signal generation:
  process(clk, rst)
  begin
    if(rst = '1') then
      empty_n <= '0';
    elsif(clk'event and clk = '1') then
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
          empty_n <= not(mb_pop_ok_rd);
        else
          empty_n <= '1';
        end if;
      end if;
    end if;
  end process;

  mb_push_ok <= mb_push and full_n;

  -- Management of pseudo-static buffers
  -- Para los argumentos de salida no hay buffers pseudo-estáticos.
  mb_pop_ok <= mb_pop and empty_n;

  ---------------------------------------------
  conv_rdy   <= empty_n;
  ap_arg_rqt <= full_n;

  iport_ce <= ap_arg_ce and full_n;
  oport_ce <= conv_ce and empty_n;

  -- If we only look at the pointers, there will be one cycle latency to reflect
  -- the status of the fifo. To refresh inmediately during a read, we decrement
  -- the counter
MBn : if (C_MULTIBUFFER_DEPTH > 1) generate
begin
  process(clk, rst)
  begin
    if(rst = '1') then
      pntr_dist <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_pop_ok_rd = '1') then
        pntr_dist <= pntr_dist - 1;
      else
        -- This ia also valid when we arrive at the end of sequence counter wr_bin < rd_bin
        --pntr_dist <= ('0' & wr_pntr_rd) - ('0' & rd_pntr);
        pntr_dist <= (wr_pntr_rd) - (rd_pntr);
      end if;
    end if;
  end process;

end generate MBn;


MB1 : if (C_MULTIBUFFER_DEPTH = 1) generate
begin

  process(clk, rst)
  begin
    if(rst = '1') then
      rd_bins <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_pop_ok_rd = '1') then
        rd_bins <= rd_bins + 1;
      end if;
    end if;
  end process;

  wr_bins <= wr_gray_rd;

  process(clk, rst)
  begin
    if(rst = '1') then
      pntr_dist <= (others => '0');
    elsif(clk'event and clk = '1') then
      if (mb_pop_ok_rd = '1') then
        pntr_dist <= pntr_dist - 1;
      else
        -- This ia also valid when we arrive at the end of sequence counter wr_bin < rd_bin
        --pntr_dist <= ('0' & wr_pntr_rd) - ('0' & rd_pntr);
        pntr_dist <= (wr_bins) - (rd_bins);
      end if;
    end if;
  end process;
end generate MB1;

  process(pntr_dist)
  begin
    ap_arg_used                 <= (others => '0');
    ap_arg_used(pntr_dist'range) <= (pntr_dist);
  end process;

  -- Status signals empty/full should be synchronized with AXI clk
  ap_arg_empty <= not(empty_n);

  process(clk, rst)
  begin
    if(rst = '1') then
      ap_arg_full_i <= '1';
    elsif(clk'event and clk = '1') then
      -- If read, we move out of full state
      if(mb_pop_ok_rd = '1') then
        ap_arg_full_i <= '0';
      else
        -- Stay in full if wr_gray_ahead = next_rd_gray
        if(wr_gray_ahead_rd = next_rd_gray) then
          ap_arg_full_i <= '1';
        else
          ap_arg_full_i <= '0';
        end if;
      end if;
    end if;
  end process;

  ap_arg_full <= ap_arg_full_i;

   
end generate NEW_INTRO;



    LINEAR_BANK_GEN : if not(USE_COLUMNIZED_BANK) generate
    -- address width for input port is the addition of required bits for the
    -- argument plus the required bits to select buffer (PTR_WIDTH).
    constant IPORT_ADDR_WIDTH : integer := C_AP_ARG_ADDR_WIDTH+log2(C_MULTIBUFFER_DEPTH);
    constant OPORT_ADDR_WIDTH : integer := CONV_ADDR_WIDTH+log2(C_MULTIBUFFER_DEPTH);

    signal iport_addr : std_logic_vector(IPORT_ADDR_WIDTH-1 downto 0);
    signal oport_addr : std_logic_vector(OPORT_ADDR_WIDTH-1 downto 0);

  begin
    MB1_addr : if (C_MULTIBUFFER_DEPTH = 1) generate
    begin
     iport_addr <= ap_arg_addr;
     oport_addr <= conv_addr;
    end generate MB1_addr;

    MBn_addr : if (C_MULTIBUFFER_DEPTH > 1) generate
    begin
     iport_addr <= std_logic_vector(wr_pntr) & ap_arg_addr;
     oport_addr <= std_logic_vector(rd_pntr) & conv_addr;
    end generate MBn_addr;

    MEM_I : entity axis_accelerator_adapter_v2_1_6.arg_mem_bank
      generic map (
        C_FAMILY       => C_FAMILY,
        C_BRAM_TYPE    => C_BRAM_TYPE,
        C_IS_UNIDIR    => 0,
        C_IPORT_DWIDTH => C_AP_ARG_DATA_WIDTH,
        C_IPORT_AWIDTH => IPORT_ADDR_WIDTH,
        C_OPORT_DWIDTH => CONV_DATA_WIDTH,
        C_OPORT_AWIDTH => OPORT_ADDR_WIDTH)
      port map (
        rst        => ap_rst,
        iport_clk  => ap_clk,
        iport_ce   => iport_ce,
        iport_we   => ap_arg_we,
        iport_addr => iport_addr,
        iport_din  => ap_arg_din,
        iport_dout => ap_arg_dout,
        oport_clk  => clk,
        oport_ce   => oport_ce,
        oport_we   => conv_we,
        oport_addr => oport_addr,
        oport_din  => conv_din_zero,
        oport_dout => conv_data);
  end generate LINEAR_BANK_GEN;

  COLUMNIZED_BANK_GEN : if (USE_COLUMNIZED_BANK) generate
  begin

    MEM_I : entity axis_accelerator_adapter_v2_1_6.oarg_columnized_mem_bank
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
        ap_clk        => ap_clk,
        ap_arg_ce     => ap_arg_ce,
        ap_arg_we     => ap_arg_we,
        ap_arg_buffer => std_logic_vector(wr_ptr),
        ap_arg_addr   => ap_arg_addr,
        ap_arg_din    => ap_arg_din,
        ap_arg_dout   => ap_arg_dout,
        clk           => clk,
        conv_ce       => conv_ce,
        conv_we       => conv_we,
        conv_buffer   => std_logic_vector(rd_ptr),
        conv_addr     => conv_addr,
        conv_data     => conv_data);

  end generate COLUMNIZED_BANK_GEN;

  -- To know how many beats to produce on output stream, we track the highest
  -- address written
  process(ap_clk, ap_rst)
  begin
    if(ap_rst = '1') then
      ap_arg_hw_length <= (others => '0');
    elsif(ap_clk'event and ap_clk = '1') then
      if(ap_arg_ack = '1') then
        ap_arg_hw_length <= (others => '0');
      elsif(iport_ce = '1' and ap_arg_we = '1') then
        if(unsigned(ap_arg_addr) >= ap_arg_hw_length) then
          ap_arg_hw_length <= unsigned('0' & ap_arg_addr) + 1;
        end if;
      end if;
    end if;
  end process;

  -- length memory modeling (XST infer)
  process(ap_clk)
  begin
    if(ap_clk'event and ap_clk = '1') then
      if(ap_arg_ack = '1') then
        hw_length_mem(to_integer(wr_ptr)) <= std_logic_vector(ap_arg_hw_length);
      end if;
    end if;
  end process;

  hw_length_mem_dout <= hw_length_mem(to_integer(rd_ptr));

--        clkx_4: ENTITY axis_accelerator_adapter_v2_1_6.clk_x_pntrs
--        GENERIC MAP(
--          C_HAS_RST              => 1,
--          C_RD_PNTR_WIDTH        => SW_LENGTH_FIFO_WIDTH,     
--          C_WR_PNTR_WIDTH        => SW_LENGTH_FIFO_WIDTH,
--          C_MSGON_VAL            => 1,
--          C_SYNCHRONIZER_STAGE   => 2
--          )
--        PORT MAP(
--          WR_CLK         => ap_clk,   
--          RD_CLK         => clk,   
--          WR_RST         => ap_rst,   
--          RD_RST         => rst,   
--          WR_PNTR        => sw_length_wr,   
--          RD_PNTR        => open,   
--          WR_PNTR_RD     => sw_length_rd,   
--          RD_PNTR_WR     => open     
--          );

--     SW_LENGTH_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
--        generic map (
--        C_CDC_TYPE                 => 1,
--        C_RESET_STATE              => 0,
--        C_SINGLE_BIT               => 0,
--        C_VECTOR_WIDTH             => SW_LENGTH_FIFO_WIDTH,
--        C_MTBF_STAGES              => 2
--        )
--        port map (
--        prmry_aclk                 => '0',
--        prmry_resetn               => '0',
--        prmry_in                   => '0',
--        prmry_vect_in              => sw_length_wr,
--
--        scndry_aclk                => clk,
--        scndry_resetn              => rst,
--        scndry_out                 => open,
--        scndry_vect_out            => sw_length_rd
--        );


       clkx_5: ENTITY axis_accelerator_adapter_v2_1_6.clk_x_pntrs
        GENERIC MAP(
          C_HAS_RST              => 1,
          C_RD_PNTR_WIDTH        => C_AP_ARG_ADDR_WIDTH+1,     
          C_WR_PNTR_WIDTH        => C_AP_ARG_ADDR_WIDTH+1,
          C_MSGON_VAL            => 1,
          C_SYNCHRONIZER_STAGE   => 2
          )
        PORT MAP(
          WR_CLK         => ap_clk,   
          RD_CLK         => clk,   
          WR_RST         => ap_rst,   
          RD_RST         => rst,   
          WR_PNTR        => hw_length_mem_dout,   
          RD_PNTR        => open,   
          WR_PNTR_RD     => hw_length_mem_dout_rd,   
          RD_PNTR_WR     => open     
          );



  sw_length_rd <= sw_length(SW_LENGTH_FIFO_WIDTH-1 downto 0);
  sw_length_we_vector(0) <= sw_length_we;
  sw_length_we_rd        <= sw_length_we_rd_vector(0);

   wr_stg_inst: ENTITY axis_accelerator_adapter_v2_1_6.synchronizer_ff
    GENERIC MAP (
     C_HAS_RST => 1,
     C_WIDTH   => 1
     )
    PORT MAP ( 
     RST       => rst,
     CLK       => clk,   
     D         => sw_length_we_vector,
     Q         => sw_length_we_rd_vector
     );    


  SW_LENGTH_FIFO : entity axis_accelerator_adapter_v2_1_6.srl_fifo_32_wt
    generic map (
      C_FAMILY => C_FAMILY,
      WIDTH    => SW_LENGTH_FIFO_WIDTH)
    port map (
      rst      => rst,
      clk      => clk,
      din      => sw_length_rd,
      din_vld  => sw_length_we_rd,
      din_rdy  => open,
      dout     => sw_length_fifo_dout,
      dout_vld => open,
      dout_rdy => mb_pop_ok_rd
    );

  process(use_sw_length, hw_length_mem_dout_rd, sw_length_fifo_dout)
    constant HW_LSB : integer := log2(C_AP_ARG_DATA_WIDTH/8);
    constant SW_LSB : integer := log2(C_AP_ARG_WIDTH/8);
    constant SW_MSB : integer := SW_LSB+SW_LENGTH_FIFO_WIDTH-1;
  begin
    conv_size <= (others => '0');
    if(use_sw_length = '0') then
      conv_size(SIZE_WIDTH-1 downto HW_LSB) <= hw_length_mem_dout_rd;
    else
      conv_size(SW_MSB downto SW_LSB) <= sw_length_fifo_dout;
    end if;
  end process;


end rtl;

