-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : xd_output_args_module.vhd
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
use axis_accelerator_adapter_v2_1_6.xd_m2s_adapter;
use axis_accelerator_adapter_v2_1_6.xd_oarg_s2s_adapter;
use axis_accelerator_adapter_v2_1_6.cdc_sync;


entity xd_output_args_module is
  generic (
    -- System generics:
    C_FAMILY                : string ;  -- Xilinx FPGA family
    C_BRAM_TYPE             : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    C_MAX_ARG_DWIDTH        : integer;
    C_MAX_ARG_AWIDTH        : integer;
    C_MAX_ARG_N_DIM         : integer;
    C_MAX_MB_DEPTH          : integer;
    C_MAX_N_OARGS           : integer;
    C_PRMRY_IS_ACLK_ASYNC   : integer;
    C_MTBF_STAGES           : integer;
    C_N_OUTPUT_ARGS         : integer;
    C_M_AXIS_TDATA_WIDTH    : integer;
    C_M_AXIS_TUSER_WIDTH    : integer;
    C_M_AXIS_TID_WIDTH      : integer;
    C_M_AXIS_TDEST_WIDTH    : integer;
    C_AP_OARG_TYPE          : std_logic_vector;
    C_AP_OARG_DWIDTH        : std_logic_vector;  -- Interface width 
    C_AP_OARG_MB_DEPTH      : std_logic_vector;
    C_AP_OARG_WIDTH         : std_logic_vector;  -- Native width of data
    C_AP_OARG_N_DIM         : std_logic_vector;
    C_AP_OARG_DIM           : std_logic_vector;
    C_AP_OARG_DIM_1         : std_logic_vector;
    C_AP_OARG_DIM_2         : std_logic_vector;
    C_AP_OARG_FORMAT_TYPE   : std_logic_vector;
    C_AP_OARG_FORMAT_FACTOR : std_logic_vector;
    C_AP_OARG_FORMAT_DIM    : std_logic_vector;
    C_NONE                  : integer := 2);
  port (
    --- Slave AXI streams (output arguments)
    M_AXIS_ACLK         : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_ARESETN      : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_TVALID       : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_TREADY       : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_TDATA        : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDATA_WIDTH-1 downto 0);
    M_AXIS_TSTRB        : out std_logic_vector(C_MAX_N_OARGS*(C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
    M_AXIS_TKEEP        : out std_logic_vector(C_MAX_N_OARGS*(C_M_AXIS_TDATA_WIDTH/8)-1 downto 0);
    M_AXIS_TLAST        : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    M_AXIS_TID          : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TID_WIDTH-1 downto 0);
    M_AXIS_TDEST        : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDEST_WIDTH-1 downto 0);
    M_AXIS_TUSER        : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TUSER_WIDTH-1 downto 0);
    ---
    oarg_sw_length      : in  std_logic_vector(31 downto 0);
    oarg_sw_length_m2s  : in  std_logic_vector(31 downto 0);
    oarg_sw_length_we   : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    oarg_use_sw_length  : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    host_oarg_tdest     : in  std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDEST_WIDTH-1 downto 0);
    ---
    dbg_stream_nwords   : out std_logic_vector(C_MAX_N_OARGS*16-1 downto 0);
    dbg_buffer_nwords   : out std_logic_vector(C_MAX_N_OARGS*16-1 downto 0);
    dbg_ap_done         : in  std_logic;
    --- AP output arguments
    ap_clk              : in  std_logic;
    ap_rst_maclk        : in  std_logic;
    ap_rst              : in  std_logic;
    ap_oarg_rst         : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_oarg_addr        : in  std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_AWIDTH-1 downto 0);
    ap_oarg_ce          : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_oarg_we          : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_oarg_din         : in  std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_oarg_dout        : out std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_oarg_rdy         : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_oarg_done        : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    status_oarg_empty   : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    status_oarg_full    : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    status_oarg_used    : out std_logic_vector(C_MAX_N_OARGS*4-1 downto 0);
    ap_fifo_oarg_din    : in  std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_DWIDTH-1 downto 0);
    ap_fifo_oarg_write  : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_fifo_oarg_full_n : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    ap_start            : in  std_logic;
    ap_done             : in  std_logic);
end entity;

architecture rtl of xd_output_args_module is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  constant C_M_AXIS_TSTRB_WIDTH : integer := C_M_AXIS_TDATA_WIDTH/8;
  constant C_M_AXIS_TKEEP_WIDTH : integer := C_M_AXIS_TDATA_WIDTH/8;

  alias C_AP_OARG_DIM_dw : std_logic_vector(C_MAX_N_OARGS*C_MAX_ARG_N_DIM*32-1 downto 0) is C_AP_OARG_DIM;


  -- Syncrhonizer Signals
  signal oarg_use_sw_length_sync  : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal oarg_sw_length_we_sync   : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal m_aresetn : std_logic;
  signal m_aclk    : std_logic;

  signal axis_rst    : std_logic;
  signal axis_rst1    : std_logic;
  signal oarg_sw_length_sync_s2s      : std_logic_vector(31 downto 0);
  signal oarg_sw_length_sync_m2s      : std_logic_vector(31 downto 0);
  signal ap_rst_sync1_maclk   : std_logic;
  signal ap_rst_sync_maclk  : std_logic;
  ATTRIBUTE async_reg           : STRING;
  ATTRIBUTE async_reg OF ap_rst_sync_maclk  : SIGNAL IS "true";
  ATTRIBUTE async_reg OF ap_rst_sync1_maclk  : SIGNAL IS "true";
  

begin

  -- undriven ports 
  dbg_stream_nwords <= (others => '0');
  dbg_buffer_nwords <= (others => '0');
  
  
  m_aresetn <=  M_AXIS_ARESETN(0);
  m_aclk    <=  M_AXIS_ACLK(0);

   ------------------------------------
   --- aclk to m_axis_aclk Synchronizer
   ------------------------------------
--   EN_LITE_TO_STRM_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
--   begin
   
      PROCESS (m_aclk, m_aresetn)
      BEGIN
       -- Register Stage #1 
        IF (m_aresetn = '0') THEN
          axis_rst1 <= '1';
          axis_rst <= '1';
        ELSIF (m_aclk'event and m_aclk = '1') THEN
          axis_rst1 <= '0';
          axis_rst <= axis_rst1;
        END IF;
        END PROCESS;


--     prd1: PROCESS (m_aclk)
--      BEGIN
--       -- Register Stage #1 
--        IF (m_aclk'event and m_aclk = '1') THEN
--          ap_rst_sync1_maclk <= ap_rst;
--          ap_rst_sync_maclk <= ap_rst_sync1_maclk;
--        END IF;
--        END PROCESS prd1;


       SW_LENGTH_SYNC_M2S : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0',
        prmry_in                   => '0',
        prmry_vect_in              => oarg_sw_length_m2s,

        scndry_aclk                => m_aclk,
        scndry_resetn              => axis_rst,
        scndry_out                 => open,
        scndry_vect_out            => oarg_sw_length_sync_m2s
        );
       SW_LENGTH_SYNC_S2S : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_VECTOR_WIDTH             => 32,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0',
        prmry_in                   => '0',
        prmry_vect_in              => oarg_sw_length,

        scndry_aclk                => m_aclk,
        scndry_resetn              => axis_rst,
        scndry_out                 => open,
        scndry_vect_out            => oarg_sw_length_sync_s2s
        );

    XD_SW_LENGTH_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_VECTOR_WIDTH             => C_MAX_N_OARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0',
        prmry_in                   => '0',
        prmry_vect_in              => oarg_use_sw_length,

        scndry_aclk                => m_aclk,
        scndry_resetn              => m_aresetn,
        scndry_out                 => open,
        scndry_vect_out            => oarg_use_sw_length_sync
        );

    XD_SW_LENGTH_WE_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_VECTOR_WIDTH             => C_MAX_N_OARGS,
        C_MTBF_STAGES              => C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0',
        prmry_in                   => '0',
        prmry_vect_in              => oarg_sw_length_we,

        scndry_aclk                => m_aclk,
        scndry_resetn              => m_aresetn,
        scndry_out                 => open,
        scndry_vect_out            => oarg_sw_length_we_sync
        );
    
--   end generate EN_LITE_TO_STRM_SYNC_GEN;

   ------------------------------------
   --- Clocks are synchronous
   ------------------------------------
--   NO_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
--   begin
--   
--   
--       oarg_use_sw_length_sync <= oarg_use_sw_length;
--      -- oarg_sw_length_we_sync  <= oarg_sw_length_we;
--
--        process(m_aclk)
--        begin
--          if(m_aclk'event and m_aclk = '1') then
--            if(m_aresetn = '0') then
--                oarg_sw_length_we_sync  <= (others=>'0');
--            else
--                oarg_sw_length_we_sync  <= oarg_sw_length_we;
--            end if;
--          end if;
--        end process;
--    
--   end generate NO_SYNC_GEN;



  ------------------------------------
  --- Output Argument generation
  ------------------------------------
  OARGS_GEN : if (C_N_OUTPUT_ARGS > 0) generate
  begin

    OUTPUT_ARGS_GEN : for i in 0 to C_N_OUTPUT_ARGS-1 generate

      constant OARG_TYPE          : integer          := get_int_element(C_AP_OARG_TYPE, i);
      constant OARG_DWIDTH        : integer          := get_int_element(C_AP_OARG_DWIDTH, i);
      constant OARG_MB_DEPTH      : integer          := get_int_element(C_AP_OARG_MB_DEPTH, i);
      constant OARG_WIDTH         : integer          := get_int_element(C_AP_OARG_WIDTH, i);
      constant OARG_N_DIM         : integer          := get_int_element(C_AP_OARG_N_DIM, i);
      constant OARG_DIM_1         : integer          := get_int_element(C_AP_OARG_DIM_1, i);
      constant OARG_DIM_2         : integer          := get_int_element(C_AP_OARG_DIM_2, i);
      constant OARG_FORMAT_TYPE   : integer          := get_int_element(C_AP_OARG_FORMAT_TYPE, i);
      constant OARG_FORMAT_FACTOR : integer          := get_int_element(C_AP_OARG_FORMAT_FACTOR, i);
      constant OARG_FORMAT_DIM    : integer          := get_int_element(C_AP_OARG_FORMAT_DIM, i);
      constant OARG_DIM           : std_logic_vector := C_AP_OARG_DIM_dw(C_MAX_ARG_N_DIM*32*(i+1)-1 downto C_MAX_ARG_N_DIM*32*i);

      constant OARG_DIMS : int_vector(C_MAX_ARG_N_DIM downto 1) := get_int_vector(C_AP_OARG_DIM, C_MAX_ARG_N_DIM*(i+1)-1, C_MAX_ARG_N_DIM*i);

      function calc_arg_addr_width2 return integer is
        variable addr_width : integer := 10;
        variable N_elements : integer := 1;
      begin

        if (OARG_TYPE = AP_ARG_MEM_MAP_TYPE) then  -- Memory map interface
          for i in 1 to OARG_N_DIM loop
            N_elements := N_elements * OARG_DIMS(i);
          end loop;

          case OARG_FORMAT_TYPE is
            when FORMAT_TYPE_NONE               =>
            when FORMAT_TYPE_RESHAPE_BLOCK      => N_elements := N_elements / OARG_FORMAT_FACTOR;
            when FORMAT_TYPE_RESHAPE_CYCLIC     => N_elements := N_elements / OARG_FORMAT_FACTOR;
            when FORMAT_TYPE_RESHAPE_COMPLETE   =>
            when FORMAT_TYPE_PARTITION_BLOCK    => N_elements := N_elements / OARG_FORMAT_FACTOR;
            when FORMAT_TYPE_PARTITION_CYCLIC   => N_elements := N_elements / OARG_FORMAT_FACTOR;
            when FORMAT_TYPE_PARTITION_COMPLETE =>
            when others                         =>
          end case;
          addr_width := log2(N_elements);
        elsif (OARG_TYPE = AP_ARG_STREAM_TYPE) then  -- FIFO interface
          -- FIFO interface is considered a unidimentional array; taking the
          -- number of elements from dimension 1
          N_elements := OARG_DIMS(1);
          addr_width := log2(N_elements);
        end if;
        return addr_width;
      end function calc_arg_addr_width2;

      signal dbg_arg_addr_width : integer := calc_arg_addr_width2;

      function calc_arg_addr_width return integer is
        variable addr_width : integer;
        variable N_elements : integer;
      begin
        if (OARG_TYPE = AP_ARG_MEM_MAP_TYPE) then  -- Memory map interface
          if (OARG_N_DIM = 1) then
            N_elements := OARG_DIM_1;

            addr_width := log2(N_elements);
          elsif (OARG_N_DIM = 2) then
            if (OARG_FORMAT_TYPE = FORMAT_TYPE_RESHAPE_BLOCK) then
              N_elements := (OARG_DIM_1*OARG_DIM_2)/OARG_FORMAT_FACTOR;
            else
              N_elements := (OARG_DIM_1*OARG_DIM_2);
            end if;
            addr_width := log2(N_elements);
          end if;
        elsif (OARG_TYPE = AP_ARG_STREAM_TYPE) then  -- FIFO interface
          N_elements := OARG_DIM_1;
          addr_width := log2(N_elements);
        end if;

        return addr_width;
      end function calc_arg_addr_width;

      constant OARG_AWIDTH : integer := calc_arg_addr_width;

      signal test_dim : int_vector(0 to OARG_N_DIM-1) :=
        get_int_vector(C_AP_OARG_DIM, OARG_N_DIM-1+C_MAX_ARG_N_DIM*i, C_MAX_ARG_N_DIM*i);

    begin

      -- BRAM Interface towards accelerator
      M2S_GEN : if (OARG_TYPE = AP_ARG_MEM_MAP_TYPE) generate
      begin
        OARG_M2S_I : entity axis_accelerator_adapter_v2_1_6.xd_m2s_adapter
          generic map (
            C_FAMILY               => C_FAMILY,
            C_MTBF_STAGES          => C_MTBF_STAGES,
            C_BRAM_TYPE            => C_BRAM_TYPE,
            C_M_AXIS_TDATA_WIDTH   => C_M_AXIS_TDATA_WIDTH,
            C_M_AXIS_TUSER_WIDTH   => C_M_AXIS_TUSER_WIDTH,
            C_M_AXIS_TID_WIDTH     => C_M_AXIS_TID_WIDTH,
            C_M_AXIS_TDEST_WIDTH   => C_M_AXIS_TDEST_WIDTH,
            C_AP_ARG_DATA_WIDTH    => OARG_DWIDTH,
            C_AP_ARG_ADDR_WIDTH    => OARG_AWIDTH,
            C_MULTIBUFFER_DEPTH    => OARG_MB_DEPTH,
            C_AP_ARG_WIDTH         => OARG_WIDTH,
            C_AP_ARG_N_DIM         => OARG_N_DIM,
            C_AP_ARG_DIMS          => OARG_DIMS(OARG_N_DIM downto 1),
            C_AP_ARG_DIM_1         => OARG_DIM_1,
            C_AP_ARG_DIM_2         => OARG_DIM_2,
            C_AP_ARG_FORMAT_TYPE   => OARG_FORMAT_TYPE,
            C_AP_ARG_FORMAT_FACTOR => OARG_FORMAT_FACTOR,
            C_AP_ARG_FORMAT_DIM    => OARG_FORMAT_DIM)
          port map (
            M_AXIS_ACLK     => M_AXIS_ACLK(i),
            M_AXIS_ARESETN  => M_AXIS_ARESETN(i),
            M_AXIS_TVALID   => M_AXIS_TVALID(i),
            M_AXIS_TREADY   => M_AXIS_TREADY(i),
            M_AXIS_TDATA    => M_AXIS_TDATA(C_M_AXIS_TDATA_WIDTH*(i+1)-1 downto C_M_AXIS_TDATA_WIDTH*i),
            M_AXIS_TSTRB    => M_AXIS_TSTRB(C_M_AXIS_TSTRB_WIDTH*(i+1)-1 downto C_M_AXIS_TSTRB_WIDTH*i),
            M_AXIS_TKEEP    => M_AXIS_TKEEP(C_M_AXIS_TKEEP_WIDTH*(i+1)-1 downto C_M_AXIS_TKEEP_WIDTH*i),
            M_AXIS_TLAST    => M_AXIS_TLAST(i),
            M_AXIS_TID      => M_AXIS_TID(C_M_AXIS_TID_WIDTH*(i+1)-1 downto C_M_AXIS_TID_WIDTH*i),
            M_AXIS_TDEST    => M_AXIS_TDEST(C_M_AXIS_TDEST_WIDTH*(i+1)-1 downto C_M_AXIS_TDEST_WIDTH*i),
            M_AXIS_TUSER    => M_AXIS_TUSER(C_M_AXIS_TUSER_WIDTH*(i+1)-1 downto C_M_AXIS_TUSER_WIDTH*i),
            ---
            sw_length       => oarg_sw_length_sync_m2s,
            sw_length_we    => oarg_sw_length_we_sync(i),
            use_sw_length   => oarg_use_sw_length_sync(i),
            host_oarg_tdest => host_oarg_tdest(C_M_AXIS_TDEST_WIDTH*(i+1)-1 downto C_M_AXIS_TDEST_WIDTH*i),
            ---
            ap_clk          => ap_clk,
            ap_rst_sync     => ap_rst_maclk,
            ap_rst          => ap_rst,
            ap_arg_addr     => ap_oarg_addr(OARG_AWIDTH-1+C_MAX_ARG_AWIDTH*i downto C_MAX_ARG_AWIDTH*i),
            ap_arg_ce       => ap_oarg_ce(i),
            ap_arg_we       => ap_oarg_we(i),
            ap_arg_din      => ap_oarg_din(OARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i),
            ap_arg_dout     => ap_oarg_dout(OARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i),
            ap_arg_rqt      => ap_oarg_rdy(i),
            ap_arg_ack      => ap_oarg_done(i),
            -- Status info
            ap_arg_empty    => status_oarg_empty(i),
            ap_arg_full     => status_oarg_full(i),
            ap_arg_used     => status_oarg_used(4*(i+1)-1 downto 4*i));

          -- Unused signals
          ap_fifo_oarg_full_n(i) <= '0';

      end generate M2S_GEN;

      -- FIFO Interface towards accelerator
      S2S_GEN : if (OARG_TYPE = AP_ARG_STREAM_TYPE) generate
      begin

        OARG_S2S_I : entity axis_accelerator_adapter_v2_1_6.xd_oarg_s2s_adapter
          generic map (
            C_FAMILY             => C_FAMILY,
            C_MTBF_STAGES          => C_MTBF_STAGES,
            C_M_AXIS_TDATA_WIDTH => C_M_AXIS_TDATA_WIDTH,
            C_M_AXIS_TUSER_WIDTH => C_M_AXIS_TUSER_WIDTH,
            C_M_AXIS_TID_WIDTH   => C_M_AXIS_TID_WIDTH,
            C_M_AXIS_TDEST_WIDTH => C_M_AXIS_TDEST_WIDTH,
            C_AP_ARG_DATA_WIDTH  => OARG_DWIDTH,
            C_AP_ARG_ADDR_WIDTH  => OARG_AWIDTH,
            C_MULTIBUFFER_DEPTH  => OARG_MB_DEPTH)
          port map (
            M_AXIS_ACLK     => M_AXIS_ACLK(i),
            M_AXIS_ARESETN  => M_AXIS_ARESETN(i),
            M_AXIS_TVALID   => M_AXIS_TVALID(i),
            M_AXIS_TREADY   => M_AXIS_TREADY(i),
            M_AXIS_TDATA    => M_AXIS_TDATA(C_M_AXIS_TDATA_WIDTH*(i+1)-1 downto C_M_AXIS_TDATA_WIDTH*i),
            M_AXIS_TSTRB    => M_AXIS_TSTRB(C_M_AXIS_TSTRB_WIDTH*(i+1)-1 downto C_M_AXIS_TSTRB_WIDTH*i),
            M_AXIS_TKEEP    => M_AXIS_TKEEP(C_M_AXIS_TKEEP_WIDTH*(i+1)-1 downto C_M_AXIS_TKEEP_WIDTH*i),
            M_AXIS_TLAST    => M_AXIS_TLAST(i),
            M_AXIS_TID      => M_AXIS_TID(C_M_AXIS_TID_WIDTH*(i+1)-1 downto C_M_AXIS_TID_WIDTH*i),
            M_AXIS_TDEST    => M_AXIS_TDEST(C_M_AXIS_TDEST_WIDTH*(i+1)-1 downto C_M_AXIS_TDEST_WIDTH*i),
            M_AXIS_TUSER    => M_AXIS_TUSER(C_M_AXIS_TUSER_WIDTH*(i+1)-1 downto C_M_AXIS_TUSER_WIDTH*i),
            ---
            sw_length       => oarg_sw_length_sync_s2s,
            sw_length_we    => oarg_sw_length_we_sync(i),
            use_sw_length   => oarg_use_sw_length_sync(i),
            host_oarg_tdest => host_oarg_tdest(C_M_AXIS_TDEST_WIDTH*(i+1)-1 downto C_M_AXIS_TDEST_WIDTH*i),
            ---
            ap_clk          => ap_clk,
            ap_rst_sync     => ap_rst_maclk,
            ap_rst          => ap_rst,
            ap_oarg_din     => ap_fifo_oarg_din(OARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i),
            ap_oarg_we      => ap_fifo_oarg_write(i),
            ap_oarg_full_n  => ap_fifo_oarg_full_n(i),
            ap_arg_rqt      => ap_oarg_rdy(i),
            ap_arg_ack      => ap_oarg_done(i),
            ap_start        => ap_start,
            ap_done         => ap_done);

          -- Unused signals
          ap_oarg_dout(OARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i) <= (others => '0');
          status_oarg_empty(i) <= '1';
          status_oarg_full(i)  <= '0';
          status_oarg_used(4*(i+1)-1 downto 4*i) <= (others => '0');

      end generate S2S_GEN;

      ap_oarg_dout(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto OARG_DWIDTH+C_MAX_ARG_DWIDTH*i)<= (others => '0');

    end generate OUTPUT_ARGS_GEN;


    OARGS_DEFAULT_GEN : if (C_N_OUTPUT_ARGS < C_MAX_N_OARGS) generate
    begin


        OUTPUT_ARGS_HIGHER_GEN : for i in C_N_OUTPUT_ARGS to C_MAX_N_OARGS-1 generate
        constant OARG_DWIDTH        : integer := get_int_element(C_AP_OARG_DWIDTH, C_N_OUTPUT_ARGS-1);
        begin    
          M_AXIS_TVALID(i) <= '0';
          M_AXIS_TLAST(i)  <= '0';
          ap_oarg_rdy(i)     <= '0';
          ap_fifo_oarg_full_n(i) <= '0';
          status_oarg_empty(i) <= '0';
          status_oarg_full(i)  <= '0';
          status_oarg_used(4*(i+1)-1 downto 4*i) <= (others => '0');
          M_AXIS_TDATA(C_M_AXIS_TDATA_WIDTH*(i+1)-1 downto C_M_AXIS_TDATA_WIDTH*i) <= (others => '0');
          M_AXIS_TSTRB(C_M_AXIS_TSTRB_WIDTH*(i+1)-1 downto C_M_AXIS_TSTRB_WIDTH*i) <= (others => '0');
          M_AXIS_TKEEP(C_M_AXIS_TKEEP_WIDTH*(i+1)-1 downto C_M_AXIS_TKEEP_WIDTH*i) <= (others => '0');
          M_AXIS_TID(C_M_AXIS_TID_WIDTH*(i+1)-1 downto C_M_AXIS_TID_WIDTH*i)       <= (others => '0');
          M_AXIS_TDEST(C_M_AXIS_TDEST_WIDTH*(i+1)-1 downto C_M_AXIS_TDEST_WIDTH*i) <= (others => '0');
          M_AXIS_TUSER(C_M_AXIS_TUSER_WIDTH*(i+1)-1 downto C_M_AXIS_TUSER_WIDTH*i) <= (others => '0');
          ap_oarg_dout(OARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto C_MAX_ARG_DWIDTH*i) <= (others => '0');


          ap_oarg_dout(C_MAX_ARG_DWIDTH-1+C_MAX_ARG_DWIDTH*i downto OARG_DWIDTH+C_MAX_ARG_DWIDTH*i)<= (others => '0');
    
        end generate OUTPUT_ARGS_HIGHER_GEN;


        --ap_iarg_dout(C_MAX_N_IARGS*C_MAX_ARG_DWIDTH-1 downto C_MAX_ARG_DWIDTH*C_N_INPUT_ARGS) <= (others=>'0');
        
    end generate OARGS_DEFAULT_GEN;


  end generate OARGS_GEN;

end rtl;

