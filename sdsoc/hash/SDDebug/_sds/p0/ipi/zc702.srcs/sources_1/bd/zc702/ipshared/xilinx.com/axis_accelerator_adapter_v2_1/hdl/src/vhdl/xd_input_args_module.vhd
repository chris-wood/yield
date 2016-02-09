-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : xd_input_args_module.vhd
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
-- 2012-09-05  1.0      rmg/jn  Created
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
use axis_accelerator_adapter_v2_1_6.xd_s2m_adapter;
use axis_accelerator_adapter_v2_1_6.xd_iarg_s2s_adapter;



entity xd_input_args_module is
  generic (
    -- System generics:
    C_FAMILY                : string;  -- Xilinx FPGA family
    C_BRAM_TYPE             : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    C_MAX_ARG_DWIDTH        : integer;
    C_MAX_ARG_AWIDTH        : integer;
    C_MAX_ARG_N_DIM         : integer;
    C_MAX_MB_DEPTH          : integer;
    C_MAX_N_IARGS           : integer;
    C_N_INPUT_ARGS          : integer;
    C_S_AXIS_TDATA_WIDTH    : integer;
    C_S_AXIS_TUSER_WIDTH    : integer;
    C_S_AXIS_TID_WIDTH      : integer;
    C_S_AXIS_TDEST_WIDTH    : integer;
    C_AP_IARG_TYPE          : std_logic_vector;
    C_AP_IARG_DWIDTH        : std_logic_vector;
    C_AP_IARG_MB_DEPTH      : std_logic_vector;
    C_AP_IARG_WIDTH         : std_logic_vector;
    C_AP_IARG_N_DIM         : std_logic_vector;
    C_AP_IARG_DIM_1         : std_logic_vector;
    C_AP_IARG_DIM_2         : std_logic_vector;
    C_AP_IARG_FORMAT_TYPE   : std_logic_vector;
    C_AP_IARG_FORMAT_FACTOR : std_logic_vector;
    C_AP_IARG_FORMAT_DIM    : std_logic_vector;
    C_MTBF_STAGES           : integer;
    C_EXTRA_SYNCS           : integer;
    C_NONE                  : integer := 2);
  port (
    --- Slave AXI streams (input arguments)
    S_AXIS_ACLK          : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_ARESETN       : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_TVALID        : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_TREADY        : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_TDATA         : in  std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TDATA_WIDTH-1 downto 0);
    S_AXIS_TSTRB         : in  std_logic_vector(C_MAX_N_IARGS*(C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
    S_AXIS_TKEEP         : in  std_logic_vector(C_MAX_N_IARGS*(C_S_AXIS_TDATA_WIDTH/8)-1 downto 0);
    S_AXIS_TLAST         : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    S_AXIS_TID           : in  std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TID_WIDTH-1 downto 0);
    S_AXIS_TDEST         : in  std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TDEST_WIDTH-1 downto 0);
    S_AXIS_TUSER         : in  std_logic_vector(C_MAX_N_IARGS*C_S_AXIS_TUSER_WIDTH-1 downto 0);
    dbg_stream_nwords    : out std_logic_vector(C_MAX_N_IARGS*16-1 downto 0);
    dbg_buffer_nwords    : out std_logic_vector(C_MAX_N_IARGS*16-1 downto 0);
    dbg_ap_start         : in  std_logic;
    --- AP input arguments
    ap_clk               : in  std_logic;
    ap_rst_saclk               : in  std_logic;
    ap_rst               : in  std_logic;
    ap_iarg_rst          : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    ap_iarg_addr         : in  std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_AWIDTH-1 downto 0);
    ap_iarg_ce           : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    ap_iarg_we           : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    ap_iarg_din          : in  std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_iarg_dout         : out std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    mb_iarg_rdy          : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    mb_iarg_done         : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    status_iarg_empty    : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    status_iarg_full     : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    status_iarg_used     : out std_logic_vector(C_MAX_N_IARGS*4-1 downto 0);
    status_iarg_n_words  : out std_logic_vector(C_MAX_N_IARGS*(C_MAX_ARG_AWIDTH+1)-1 downto 0);
    ap_fifo_iarg_dout    : out std_logic_vector(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_fifo_iarg_read    : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    ap_fifo_iarg_empty_n : out std_logic_vector(C_MAX_N_IARGS-1 downto 0));
end entity;

architecture rtl of xd_input_args_module is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  constant C_S_AXIS_TSTRB_WIDTH : integer := C_S_AXIS_TDATA_WIDTH/8;
  constant C_S_AXIS_TKEEP_WIDTH : integer := C_S_AXIS_TDATA_WIDTH/8;
  signal s_aclk    : std_logic;
  signal ap_rst_sync1_saclk   : std_logic;
  signal ap_rst_sync_saclk  : std_logic;
  ATTRIBUTE async_reg           : STRING;
  ATTRIBUTE async_reg OF ap_rst_sync_saclk  : SIGNAL IS "true";
  ATTRIBUTE async_reg OF ap_rst_sync1_saclk  : SIGNAL IS "true";

begin


  s_aclk    <=  S_AXIS_ACLK(0);
  -- Unused signal
  status_iarg_n_words <= (others => '0');


--      prd1: PROCESS (s_aclk)
--      BEGIN
--       -- Register Stage #1 
--        IF (s_aclk'event and s_aclk = '1') THEN
--          ap_rst_sync1_saclk <= ap_rst;
--          ap_rst_sync_saclk <= ap_rst_sync1_saclk;
--        END IF;
--        END PROCESS prd1;



  IARGS_GEN : if (C_N_INPUT_ARGS > 0) generate
  begin

    INPUT_ARGS_GEN : for i in 0 to C_N_INPUT_ARGS-1 generate

      constant IARG_TYPE          : integer := get_int_element(C_AP_IARG_TYPE, i);
      constant IARG_DWIDTH        : integer := get_int_element(C_AP_IARG_DWIDTH, i);
      constant IARG_MB_DEPTH      : integer := get_int_element(C_AP_IARG_MB_DEPTH, i);
      constant IARG_WIDTH         : integer := get_int_element(C_AP_IARG_WIDTH, i);
      constant IARG_N_DIM         : integer := get_int_element(C_AP_IARG_N_DIM, i);
      constant IARG_DIM_1         : integer := get_int_element(C_AP_IARG_DIM_1, i);
      constant IARG_DIM_2         : integer := get_int_element(C_AP_IARG_DIM_2, i);
      constant IARG_FORMAT_TYPE   : integer := get_int_element(C_AP_IARG_FORMAT_TYPE, i);
      constant IARG_FORMAT_FACTOR : integer := get_int_element(C_AP_IARG_FORMAT_FACTOR, i);
      constant IARG_FORMAT_DIM    : integer := get_int_element(C_AP_IARG_FORMAT_DIM, i);

      function calc_arg_addr_width return integer is
        variable addr_width : integer := 10;
        variable N_elements : integer;
      begin
        if (IARG_TYPE = AP_ARG_MEM_MAP_TYPE) then  -- Memory map interface
          if (IARG_N_DIM = 1) then
            N_elements := IARG_DIM_1;

            addr_width := log2(N_elements);
          elsif (IARG_N_DIM = 2) then
            if (IARG_FORMAT_TYPE = FORMAT_TYPE_RESHAPE_BLOCK) then
              N_elements := (IARG_DIM_1*IARG_DIM_2)/IARG_FORMAT_FACTOR;
            else
              N_elements := (IARG_DIM_1*IARG_DIM_2);
            end if;
            addr_width := log2(N_elements);
          end if;
        elsif (IARG_TYPE = AP_ARG_STREAM_TYPE) then  -- FIFO interface
          N_elements := IARG_DIM_1;
          addr_width := log2(N_elements);
        end if;

        return addr_width;
      end function calc_arg_addr_width;

      constant IARG_AWIDTH : integer := calc_arg_addr_width;

    begin

      -- BRAM Interface towards accelerator
      S2M_GEN : if (IARG_TYPE = AP_ARG_MEM_MAP_TYPE) generate
      begin

        IARG_AP_S2M_I : entity axis_accelerator_adapter_v2_1_6.xd_s2m_adapter
          generic map (
            C_FAMILY               => C_FAMILY,
            C_MTBF_STAGES          => C_MTBF_STAGES, 
            C_BRAM_TYPE            => C_BRAM_TYPE,
            C_S_AXIS_TDATA_WIDTH   => C_S_AXIS_TDATA_WIDTH,
            C_S_AXIS_TUSER_WIDTH   => C_S_AXIS_TUSER_WIDTH,
            C_S_AXIS_TID_WIDTH     => C_S_AXIS_TID_WIDTH,
            C_S_AXIS_TDEST_WIDTH   => C_S_AXIS_TDEST_WIDTH,
            C_AP_ARG_DATA_WIDTH    => IARG_DWIDTH,
            C_AP_ARG_ADDR_WIDTH    => IARG_AWIDTH,
            C_MULTIBUFFER_DEPTH    => IARG_MB_DEPTH,
            C_AP_ARG_WIDTH         => IARG_WIDTH,
            C_AP_ARG_N_DIM         => IARG_N_DIM,
            C_AP_ARG_DIM_1         => IARG_DIM_1,
            C_AP_ARG_DIM_2         => IARG_DIM_2,
            C_AP_ARG_FORMAT_TYPE   => IARG_FORMAT_TYPE,
            C_AP_ARG_FORMAT_FACTOR => IARG_FORMAT_FACTOR,
            C_AP_ARG_FORMAT_DIM    => IARG_FORMAT_DIM,
            C_EXTRA_SYNCS          => C_EXTRA_SYNCS)
          port map (
            S_AXIS_ACLK       => S_AXIS_ACLK(i),
            S_AXIS_ARESETN    => S_AXIS_ARESETN(i),
            S_AXIS_TVALID     => S_AXIS_TVALID(i),
            S_AXIS_TREADY     => S_AXIS_TREADY(i),
            S_AXIS_TDATA      => S_AXIS_TDATA(C_S_AXIS_TDATA_WIDTH*(i+1)-1 downto C_S_AXIS_TDATA_WIDTH*i),
            S_AXIS_TSTRB      => S_AXIS_TSTRB(C_S_AXIS_TSTRB_WIDTH*(i+1)-1 downto C_S_AXIS_TSTRB_WIDTH*i),
            S_AXIS_TKEEP      => S_AXIS_TKEEP(C_S_AXIS_TKEEP_WIDTH*(i+1)-1 downto C_S_AXIS_TKEEP_WIDTH*i),
            S_AXIS_TLAST      => S_AXIS_TLAST(i),
            S_AXIS_TID        => S_AXIS_TID(C_S_AXIS_TID_WIDTH*(i+1)-1 downto C_S_AXIS_TID_WIDTH*i),
            S_AXIS_TDEST      => S_AXIS_TDEST(C_S_AXIS_TDEST_WIDTH*(i+1)-1 downto C_S_AXIS_TDEST_WIDTH*i),
            S_AXIS_TUSER      => S_AXIS_TUSER(C_S_AXIS_TUSER_WIDTH*(i+1)-1 downto C_S_AXIS_TUSER_WIDTH*i),
            dbg_stream_nwords => dbg_stream_nwords(16*(i+1)-1 downto 16*i),
            dbg_buffer_nwords => dbg_buffer_nwords(16*(i+1)-1 downto 16*i),
            dbg_ap_start      => dbg_ap_start,
            ap_clk            => ap_clk,
            ap_rst_sync       => ap_rst_saclk,
            ap_rst            => ap_rst,
            ap_arg_addr       => ap_iarg_addr(IARG_AWIDTH-1+C_MAX_ARG_AWIDTH*i downto C_MAX_ARG_AWIDTH*i),
            ap_arg_ce         => ap_iarg_ce(i),
            ap_arg_we         => ap_iarg_we(i),
            ap_arg_din        => ap_iarg_din(IARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i),
            ap_arg_dout       => ap_iarg_dout(IARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i),
            mb_arg_rdy        => mb_iarg_rdy(i),
            mb_arg_done       => mb_iarg_done(i),
            -- Status info
            status_empty      => status_iarg_empty(i),
            status_full       => status_iarg_full(i),
            status_used       => status_iarg_used(4*(i+1)-1 downto 4*i));

          
       
          -- Unused signals
          ap_fifo_iarg_dout(IARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i)    <= (others => '0');
          
          ap_fifo_iarg_empty_n(i) <= '0';
          

      end generate S2M_GEN;
      
      
      -- FIFO Interface towards accelerator
      S2S_GEN : if (IARG_TYPE = AP_ARG_STREAM_TYPE) generate
      begin
        IARG_AP_S2S_I : entity axis_accelerator_adapter_v2_1_6.xd_iarg_s2s_adapter
          generic map (
            C_FAMILY             => C_FAMILY,
            C_MTBF_STAGES        => C_MTBF_STAGES, 
            C_S_AXIS_TDATA_WIDTH => C_S_AXIS_TDATA_WIDTH,
            C_S_AXIS_TUSER_WIDTH => C_S_AXIS_TUSER_WIDTH,
            C_S_AXIS_TID_WIDTH   => C_S_AXIS_TID_WIDTH,
            C_S_AXIS_TDEST_WIDTH => C_S_AXIS_TDEST_WIDTH,
            C_AP_ARG_DATA_WIDTH  => IARG_DWIDTH,
            C_AP_ARG_ADDR_WIDTH  => IARG_AWIDTH,
            C_MULTIBUFFER_DEPTH  => IARG_MB_DEPTH)
          port map (
            S_AXIS_ACLK     => S_AXIS_ACLK(i),
            S_AXIS_ARESETN  => S_AXIS_ARESETN(i),
            S_AXIS_TVALID   => S_AXIS_TVALID(i),
            S_AXIS_TREADY   => S_AXIS_TREADY(i),
            S_AXIS_TDATA    => S_AXIS_TDATA(C_S_AXIS_TDATA_WIDTH*(i+1)-1 downto C_S_AXIS_TDATA_WIDTH*i),
            S_AXIS_TSTRB    => S_AXIS_TSTRB(C_S_AXIS_TSTRB_WIDTH*(i+1)-1 downto C_S_AXIS_TSTRB_WIDTH*i),
            S_AXIS_TKEEP    => S_AXIS_TKEEP(C_S_AXIS_TKEEP_WIDTH*(i+1)-1 downto C_S_AXIS_TKEEP_WIDTH*i),
            S_AXIS_TLAST    => S_AXIS_TLAST(i),
            S_AXIS_TID      => S_AXIS_TID(C_S_AXIS_TID_WIDTH*(i+1)-1 downto C_S_AXIS_TID_WIDTH*i),
            S_AXIS_TDEST    => S_AXIS_TDEST(C_S_AXIS_TDEST_WIDTH*(i+1)-1 downto C_S_AXIS_TDEST_WIDTH*i),
            S_AXIS_TUSER    => S_AXIS_TUSER(C_S_AXIS_TUSER_WIDTH*(i+1)-1 downto C_S_AXIS_TUSER_WIDTH*i),
            ap_clk          => ap_clk,
            ap_rst          => ap_rst,
            ap_iarg_dout    => ap_fifo_iarg_dout(IARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i),
            ap_iarg_re      => ap_fifo_iarg_read(i),
            ap_iarg_empty_n => ap_fifo_iarg_empty_n(i),
            mb_arg_rdy      => mb_iarg_rdy(i),
            mb_arg_done     => mb_iarg_done(i));
            
          -- Unused signals
          status_iarg_empty(i)   <= '1';
          status_iarg_full(i)    <= '0';
          status_iarg_used(4*(i+1)-1 downto 4*i) <=(others => '0');
          ap_iarg_dout(IARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i) <= (others => '0');
          dbg_stream_nwords(16*(i+1)-1 downto 16*i) <= (others => '0');
          dbg_buffer_nwords(16*(i+1)-1 downto 16*i) <= (others => '0');
   
      end generate S2S_GEN;
      
      
      ap_iarg_dout(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto IARG_DWIDTH+C_MAX_ARG_DWIDTH*i)<= (others => '0');
      ap_fifo_iarg_dout(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto IARG_DWIDTH+C_MAX_ARG_DWIDTH*i)<= (others => '0');
      

    end generate INPUT_ARGS_GEN;




    IARGS_DEFAULT_GEN : if (C_N_INPUT_ARGS < C_MAX_N_IARGS) generate

    constant IARG_DWIDTH        : integer := get_int_element(C_AP_IARG_DWIDTH, C_N_INPUT_ARGS-1);

    begin


        INPUT_ARGS_HIGHER_GEN : for i in C_N_INPUT_ARGS to C_MAX_N_IARGS-1 generate
        constant IARG_DWIDTH        : integer := get_int_element(C_AP_IARG_DWIDTH, C_N_INPUT_ARGS-1);
        begin    
            S_AXIS_TREADY(i) <= '0';
	  mb_iarg_rdy(i)     <= '0';
	  ap_fifo_iarg_empty_n(i) <= '0';
          status_iarg_empty(i)   <= '0';
          status_iarg_full(i)    <= '0';
          status_iarg_used(4*(i+1)-1 downto 4*i) <=(others => '0');
          dbg_stream_nwords(16*(i+1)-1 downto 16*i) <= (others => '0');
          dbg_buffer_nwords(16*(i+1)-1 downto 16*i) <= (others => '0');
          ap_fifo_iarg_dout(IARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i)    <= (others => '0');
          ap_iarg_dout(IARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i) <= (others => '0');

	ap_iarg_dout(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto IARG_DWIDTH+C_MAX_ARG_DWIDTH*i)<= (others => '0');
	ap_fifo_iarg_dout(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto IARG_DWIDTH+C_MAX_ARG_DWIDTH*i)<= (others => '0');
	
        end generate INPUT_ARGS_HIGHER_GEN;


        --ap_iarg_dout(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto C_MAX_ARG_DWIDTH*C_N_INPUT_ARGS) <= (others=>'0');
        
    end generate IARGS_DEFAULT_GEN;
    
    
  end generate IARGS_GEN;




end rtl;

