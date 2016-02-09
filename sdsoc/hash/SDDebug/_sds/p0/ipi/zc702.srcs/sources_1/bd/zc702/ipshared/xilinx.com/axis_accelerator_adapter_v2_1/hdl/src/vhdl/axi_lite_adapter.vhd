-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : axi_lite_adapter.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2012-12-03
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
-- 2013-08-05  2.0      pvk     updated
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
use axis_accelerator_adapter_v2_1_6.cdc_sync;

entity axi_lite_adapter is
  generic (
    -- System generics:
    C_FAMILY              : string                        := "virtex7";  -- Xilinx FPGA family
    -- AXI generics: 
    C_S_AXI_ADDR_WIDTH    : integer                       := 13;
    C_S_AXI_DATA_WIDTH    : integer range 32 to 128       := 32;
    C_MAX_N_IARGS         : integer;
    C_MAX_N_OARGS         : integer;
    C_MAX_MB_DEPTH        : integer;
    C_N_INPUT_ARGS        : integer;
    C_N_OUTPUT_ARGS       : integer;
    C_PRMRY_IS_ACLK_ASYNC : integer;
    C_MTBF_STAGES         : integer;
    C_MAX_ARG_AWIDTH      : integer;
    C_MAX_N_ISCALARS      : integer;
    C_N_INOUT_SCALARS     : integer;
    C_MAX_N_IOSCALARS     : integer;
    C_N_INPUT_SCALARS     : integer;
    C_MAX_N_OSCALARS      : integer;
    C_N_OUTPUT_SCALARS    : integer;
    C_MAX_SCALAR_DWIDTH   : integer;
    C_M_AXIS_TDEST_WIDTH  : integer);
  port (
    -- AXI LITE interface signals:
    S_AXI_ACLK             : in  std_logic;  --  AXI Clock
    S_AXI_ARESETN          : in  std_logic;  --  AXI Reset, active low
    S_AXI_AWADDR           : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);  --  AXI Write address
    S_AXI_AWVALID          : in  std_logic;  --  Write address valid
    S_AXI_AWREADY          : out std_logic;  --  Write address ready
    S_AXI_WDATA            : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --  Write data
    S_AXI_WSTRB            : in  std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);  --  Write strobes
    S_AXI_WVALID           : in  std_logic;  --  Write valid
    S_AXI_WREADY           : out std_logic;  --  Write ready
    S_AXI_BRESP            : out std_logic_vector(1 downto 0);  --  Write response
    S_AXI_BVALID           : out std_logic;  --  Write response valid
    S_AXI_BREADY           : in  std_logic;  --  Response ready
    S_AXI_ARADDR           : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);  --  Read address
    S_AXI_ARVALID          : in  std_logic;  --  Read address valid
    S_AXI_ARREADY          : out std_logic;  --  Read address ready
    S_AXI_RDATA            : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);  --  Read data
    S_AXI_RRESP            : out std_logic_vector(1 downto 0);  --  Read response
    S_AXI_RVALID           : out std_logic;  --  Read valid
    S_AXI_RREADY           : in  std_logic;  --  Read ready
    --- App. ports
    ap_rst                 : out std_logic;  --  Read valid
    -- Command input port:
    host_cmd_data          : out std_logic_vector(31 downto 0);
    host_cmd_we            : out std_logic;
    host_cmd_rdy           : in  std_logic;
    host_complete_re       : out std_logic;
    host_cmd_error         : in  std_logic;
    -- AP core status signals:
    status_ap_start        : in  std_logic;
    status_ap_done         : in  std_logic;
    status_ap_idle         : in  std_logic;
    status_ap_ready        : in  std_logic;
    status_ap_start_clr    : out std_logic;
    status_ap_done_clr     : out std_logic;
    status_ap_idle_clr     : out std_logic;
    status_ap_ready_clr    : out std_logic;
    -- Input arguments management:
    host_iarg_rst          : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    iarg_rqt_enable        : out std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    status_iarg_empty      : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    status_iarg_full       : in  std_logic_vector(C_MAX_N_IARGS-1 downto 0);
    status_iarg_used       : in  std_logic_vector(C_MAX_N_IARGS*4-1 downto 0);
    status_iarg_n_words    : in  std_logic_vector(C_MAX_N_IARGS*(C_MAX_ARG_AWIDTH+1)-1 downto 0);
    -- Output arguments management:
    host_oarg_rst          : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    oarg_rqt_enable        : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    oarg_sw_length         : out std_logic_vector(31 downto 0);
    oarg_sw_length_m2s     : out std_logic_vector(31 downto 0);
    oarg_sw_length_we      : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    oarg_use_sw_length     : out std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    host_oarg_tdest        : out std_logic_vector(C_MAX_N_OARGS*C_M_AXIS_TDEST_WIDTH-1 downto 0);
    status_oarg_empty      : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    status_oarg_full       : in  std_logic_vector(C_MAX_N_OARGS-1 downto 0);
    status_oarg_used       : in  std_logic_vector(C_MAX_N_OARGS*4-1 downto 0);
    -- Input scalar management:
    host_iscalar_rst       : out std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
    host_iscalar_dout      : out std_logic_vector(31 downto 0);
    host_iscalar_we        : out std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
    host_iscalar_rdy       : in  std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
    status_iscalar_empty   : in  std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
    status_iscalar_full    : in  std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
    status_iscalar_used    : in  std_logic_vector((C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS)*4-1 downto 0);
    -- Output scalar management:                  
    host_oscalar_rst       : out std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
    host_oscalar_din       : in  std_logic_vector((C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS)*C_MAX_SCALAR_DWIDTH-1 downto 0);
    host_oscalar_re        : out std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
    host_oscalar_rdy       : in  std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
    status_oscalar_empty   : in  std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
    status_oscalar_full    : in  std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
    status_oscalar_used    : in  std_logic_vector((C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS)*4-1 downto 0);
    dbg_iarg_stream_nwords : in  std_logic_vector(C_MAX_N_IARGS*16-1 downto 0);
    dbg_iarg_buffer_nwords : in  std_logic_vector(C_MAX_N_IARGS*16-1 downto 0);
    dbg_oarg_stream_nwords : in  std_logic_vector(C_MAX_N_OARGS*16-1 downto 0);
    dbg_oarg_buffer_nwords : in  std_logic_vector(C_MAX_N_OARGS*16-1 downto 0);
    iscalar_rqt_enable     : out std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
    oscalar_rqt_enable     : out std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
    ---
    interrupt              : out std_logic);

  attribute SIGIS                  : string;
  attribute SIGIS of S_AXI_ACLK    : signal is "CLK";
  attribute SIGIS of S_AXI_ARESETN : signal is "RST";


end entity;

architecture rtl of axi_lite_adapter is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";

  constant DATA_WIDTH      : integer                      := 32;
  constant STRB_WIDTH      : integer                      := (C_S_AXI_DATA_WIDTH/8);
  constant AXI_RESP_OKAY   : std_logic_vector(1 downto 0) := "00";
  constant AXI_RESP_EXOKAY : std_logic_vector(1 downto 0) := "01";
  constant AXI_RESP_SLVERR : std_logic_vector(1 downto 0) := "10";
  constant AXI_RESP_DECERR : std_logic_vector(1 downto 0) := "11";


  function ext_32 (
    value : std_logic_vector;
    width : natural := 32) 
    return std_logic_vector is
    constant N   : integer := value'length;
    variable ret : std_logic_vector(width-1 downto 0);
  begin
    ret               := (others => '0');
    ret(N-1 downto 0) := value;
    return ret;
  end function ext_32;

  function sext_32 (
    value : std_logic_vector;
    width : natural := 32) 
    return std_logic_vector is
    constant N   : integer := value'length;
    alias val_dn : std_logic_vector (N-1 downto 0) is value;
    variable ret : std_logic_vector(width-1 downto 0);
  begin
    ret(N-1 downto 0) := val_dn;
    if(N < 32) then
      ret(31 downto N) := (others => val_dn(N-1));
    end if;
    return ret;
  end function sext_32;

  signal axi_rst   : std_logic;
  signal ap_rst_fb   : std_logic;
  signal axi_rst1   : std_logic;
  signal ap_rst_i   : std_logic;
  signal axi_addr  : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);  --  AXI Write address
  signal wr_data_i : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

  --------------------------------------------------
  -- We use banks of 16 registers (32 bits, 4 bytes):
  constant BANK_ADDR_WIDTH : integer := 4;  -- Up to 16 banks can be used.
  constant BANK_ADDR_LSB   : integer := log2(16*4);
  constant BANK_ADDR_MSB   : integer := BANK_ADDR_LSB+BANK_ADDR_WIDTH-1;

  constant GP_REGS_BANK_ADDR        : integer := 0;
  constant GP_REGS_BANK1_ADDR       : integer := 1;
  constant ISCALAR_BANK_ADDR        : integer := 2;
  constant OSCALAR_BANK_ADDR        : integer := 3;
  constant IARG_STATUS_BANK_ADDR    : integer := 4;
  constant OARG_STATUS_BANK_ADDR    : integer := 5;
  constant ISCALAR_STATUS_BANK_ADDR : integer := 6;
  constant OSCALAR_STATUS_BANK_ADDR : integer := 7;
  constant OARG_LENGTH_BANK_ADDR    : integer := 8;
  constant OARG_TDEST_BANK_ADDR     : integer := 9;

  constant CTRL_REG_INDEX               : integer := 0;
  constant STATUS_REG_INDEX             : integer := 1;
  constant IARG_RST_REG_INDEX           : integer := 2;
  constant OARG_RST_REG_INDEX           : integer := 3;
  constant IARG_RQT_ENABLE_REG_INDEX    : integer := 4;
  constant OARG_RQT_ENABLE_REG_INDEX    : integer := 5;
  constant COMMAND_REG_INDEX            : integer := 10;
  constant COMPLETE_REG_INDEX           : integer := 11;
  constant INT_ENABLE_REG_INDEX         : integer := 12;
  constant INT_FLAG_REG_INDEX           : integer := 13;
  constant OARG_LENGTH_MODE_REG_INDEX   : integer := 15;
  constant ISCALAR_RST_REG_INDEX        : integer := 16;
  constant OSCALAR_RST_REG_INDEX        : integer := 17;
  constant ISCALAR_RQT_ENABLE_REG_INDEX : integer := 18;
  constant OSCALAR_RQT_ENABLE_REG_INDEX : integer := 19;

  constant BANK1_INDEX : integer := 16;

  signal gp_bank             : std_logic;  -- bank 0
  signal gp_bank1            : std_logic;  -- bank 1
  signal iscalar_bank        : std_logic;  -- bank 2
  signal oscalar_bank        : std_logic;  -- bank 3
  signal iarg_status_bank    : std_logic;  -- bank 4
  signal oarg_status_bank    : std_logic;  -- bank 5
  signal iscalar_status_bank : std_logic;  -- bank 6
  signal oscalar_status_bank : std_logic;  -- bank 7
  signal oarg_length_bank    : std_logic;  -- bank 8
  signal oarg_tdest_bank     : std_logic;  -- bank 9

  signal mux_gp_regs         : std_logic_vector(31 downto 0);
  signal mux_oscalar_data    : std_logic_vector(31 downto 0);
  signal mux_iarg_status     : std_logic_vector(31 downto 0);
  signal mux_oarg_status     : std_logic_vector(31 downto 0);
  signal mux_iscalar_status  : std_logic_vector(31 downto 0);
  signal mux_oscalar_status  : std_logic_vector(31 downto 0);
  signal mux_oarg_tdest_regs : std_logic_vector(31 downto 0);

  signal rd_bank_addr : std_logic_vector(BANK_ADDR_WIDTH-1 downto 0);

  constant REGS_ADDR_WIDTH : integer := 4;  -- Inner address width.
  constant N_REGS          : integer := 2**REGS_ADDR_WIDTH;
  signal   reg_sel         : std_logic_vector(N_REGS-1 downto 0);
  signal   rd_reg_addr     : std_logic_vector(REGS_ADDR_WIDTH-1 downto 0);

  signal ctrl_reg            : std_logic_vector(31 downto 0);
  signal status_reg          : std_logic_vector(31 downto 0);
  signal ap_iarg_rst_reg     : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal ap_oarg_rst_reg     : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  signal iarg_rqt_enable_reg : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal oarg_rqt_enable_reg : std_logic_vector(C_MAX_N_OARGS-1 downto 0);

  signal oarg_length_mode_reg : std_logic_vector(C_MAX_N_OARGS-1 downto 0);

  signal reg_sel1 : std_logic_vector(N_REGS-1 downto 0);

  signal iscalar_rst_reg        : std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
  signal oscalar_rst_reg        : std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);
  signal iscalar_rqt_enable_reg : std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto 0);
  signal oscalar_rqt_enable_reg : std_logic_vector(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto 0);

  ------------------------------------------------
  type state_type is (
    -- pragma translate_off
    stop,
    -- pragma translate_on
    idle,
    read_regs,
    write_regs,
    send_resp);

  signal state : state_type;

  signal wr_addr_rdy : std_logic;
  signal rd_addr_rdy : std_logic;

  signal wr_resp_vld : std_logic;
  signal wr_data_rdy : std_logic;

  signal rd_data_vld : std_logic;
  signal rd_data_ce  : std_logic;
  signal rd_data     : std_logic_vector(31 downto 0);

  signal gp_reg_start : std_logic;
  signal rd_start     : std_logic;
  signal wr_start     : std_logic;
  signal access_start : std_logic;

  signal gp_reg_start1 : std_logic;

  --------------------------------------------------------------------

  -- pragma translate_off
  signal mem_rd : std_logic;
  signal mem_wr : std_logic;
  -- pragma translate_on

  signal scalar_reg_start : std_logic;
  signal glb_int_en       : std_logic;

  ---------------------
  -- INTERRUPT REGs: --
  ---------------------
  constant N_INTS         : integer := 8;
  signal   int_enable_reg : std_logic_vector(N_INTS-1 downto 0);
  signal   int_flag_reg   : std_logic_vector(N_INTS-1 downto 0);
  signal   int_rqt        : std_logic_vector(N_INTS-1 downto 0);
  
  ---------------------
  -- Syncrhpnoaer signals
  ---------------------
  signal status_iarg_empty_sync   : std_logic_vector(C_MAX_N_IARGS-1 downto 0);
  signal oarg_sw_length_we_event  : std_logic;
  signal oarg_sw_length_we_i      : std_logic_vector(C_MAX_N_OARGS-1 downto 0);
  
  
  signal host_ioscalar_re_i : std_logic_vector(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS);
  signal host_oscalar_re_i : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  
      ATTRIBUTE async_reg           : STRING;
        ATTRIBUTE async_reg OF axi_rst1    : SIGNAL IS "true"; 
      ATTRIBUTE async_reg OF axi_rst    : SIGNAL IS "true"; 

begin



   ----------------------
   --- status_iarg_empty Synchronizer
   ----------------------
   EN_STRM_TO_LITE_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
   begin
   

    XD_IARG_RQT_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_VECTOR_WIDTH             => C_MAX_N_IARGS,
        C_MTBF_STAGES              => 2 --C_MTBF_STAGES
        )
        port map (
        prmry_aclk                 => '0',
        prmry_resetn               => '0',
        prmry_in                   => '0',
        prmry_vect_in              => status_iarg_empty,

        scndry_aclk                => S_AXI_ACLK,
        scndry_resetn              => S_AXI_ARESETN,
        scndry_out                 => open,
        scndry_vect_out            => status_iarg_empty_sync
        );

    
   end generate EN_STRM_TO_LITE_SYNC_GEN;

   NO_SYNC_GEN : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
   begin
   
       status_iarg_empty_sync <= status_iarg_empty;
    
   end generate NO_SYNC_GEN;

   ----------------------
   --- status_iarg_empty Synchronizer
   ----------------------



  --axi_rst <= not(S_AXI_ARESETN);

      prd1: PROCESS (S_AXI_ACLK, S_AXI_ARESETN)
      BEGIN
       -- Register Stage #1 
        IF (S_AXI_ARESETN = '0') THEN
          axi_rst1 <= '1';
          axi_rst <= '1';
        ELSIF (S_AXI_ACLK'event and S_AXI_ACLK = '1') THEN
          axi_rst1 <= '0';
          axi_rst <= axi_rst1;
        END IF;
        END PROCESS prd1;


  S_AXI_AWREADY <= wr_addr_rdy;
  S_AXI_ARREADY <= rd_addr_rdy;
  S_AXI_WREADY  <= wr_data_rdy;

  S_AXI_BVALID <= wr_resp_vld;
  S_AXI_BRESP  <= AXI_RESP_OKAY;

  S_AXI_RDATA  <= rd_data;
  S_AXI_RVALID <= rd_data_vld;
  S_AXI_RRESP  <= AXI_RESP_OKAY;

  -------------------------------------------

  axi_addr <= S_AXI_ARADDR when (S_AXI_ARVALID = '1') else S_AXI_AWADDR;

  process(axi_addr)
    variable int_addr : integer range 0 to (2**BANK_ADDR_WIDTH)-1;
  begin
    gp_bank             <= '0';
    gp_bank1            <= '0';
    iscalar_bank        <= '0';
    oscalar_bank        <= '0';
    iarg_status_bank    <= '0';
    oarg_status_bank    <= '0';
    iscalar_status_bank <= '0';
    oscalar_status_bank <= '0';
    oarg_length_bank    <= '0';
    oarg_tdest_bank     <= '0';

    int_addr := to_integer(unsigned(axi_addr(BANK_ADDR_MSB downto BANK_ADDR_LSB)));
    case int_addr is
      when GP_REGS_BANK_ADDR        => gp_bank             <= '1';
      when GP_REGS_BANK1_ADDR       => gp_bank1            <= '1';
      when ISCALAR_BANK_ADDR        => iscalar_bank        <= '1';
      when OSCALAR_BANK_ADDR        => oscalar_bank        <= '1';
      when IARG_STATUS_BANK_ADDR    => iarg_status_bank    <= '1';
      when OARG_STATUS_BANK_ADDR    => oarg_status_bank    <= '1';
      when ISCALAR_STATUS_BANK_ADDR => iscalar_status_bank <= '1';
      when OSCALAR_STATUS_BANK_ADDR => oscalar_status_bank <= '1';
      when OARG_LENGTH_BANK_ADDR    => oarg_length_bank    <= '1';
      when OARG_TDEST_BANK_ADDR     => oarg_tdest_bank     <= '1';
      when others                   =>
    end case;
  end process;

  process(S_AXI_ACLK)
    constant LSB : integer := log2(C_S_AXI_DATA_WIDTH/8);
    constant MSB : integer := LSB+REGS_ADDR_WIDTH-1;
  begin
    if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      if(rd_start = '1') then
        rd_reg_addr <= S_AXI_ARADDR(MSB downto LSB);
      end if;
    end if;
  end process;

  process(S_AXI_ACLK)
  begin
    if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      if(rd_start = '1') then
        rd_bank_addr <= S_AXI_ARADDR(BANK_ADDR_MSB downto BANK_ADDR_LSB);
      end if;
    end if;
  end process;

  process(S_AXI_ACLK, axi_rst)
  begin
    if(axi_rst = '1') then
      state       <= idle;
      wr_resp_vld <= '0';
      rd_data_vld <= '0';
      rd_addr_rdy <= '0';
      wr_addr_rdy <= '0';
      wr_data_rdy <= '0';
      -- pragma translate_off
      mem_rd      <= '0';
      mem_wr      <= '0';
      -- pragma translate_on
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      rd_addr_rdy <= '0';
      wr_addr_rdy <= '0';
      wr_data_rdy <= '0';
      -- pragma translate_off
      mem_rd      <= '0';
      mem_wr      <= '0';
      -- pragma translate_on
      case state is
        when idle =>
          if(S_AXI_ARVALID = '1') then
            state       <= read_regs;
            rd_addr_rdy <= '1';
          elsif(S_AXI_AWVALID = '1' and S_AXI_WVALID = '1') then
            -- During write accesses it's waited until both both address and 
            -- write data are stables.
            state       <= write_regs;
            wr_addr_rdy <= '1';
            wr_data_rdy <= '1';
          end if;
        when read_regs =>
          state       <= send_resp;
          rd_data_vld <= '1';
        when write_regs =>
          state       <= send_resp;
          wr_resp_vld <= '1';

        when send_resp =>
          if ((wr_resp_vld = '1' and S_AXI_BREADY = '1') or
              (rd_data_vld = '1' and S_AXI_RREADY = '1')) then
            wr_resp_vld <= '0';
            rd_data_vld <= '0';
            state       <= idle;
          end if;
        when others =>
      end case;
    end if;
  end process;

  process(state, gp_bank, gp_bank1, S_AXI_ARVALID, S_AXI_AWVALID, S_AXI_WVALID)
  begin
    rd_data_ce       <= '0';
    gp_reg_start     <= '0';
    gp_reg_start1    <= '0';
    scalar_reg_start <= '0';
    rd_start         <= '0';
    wr_start         <= '0';
    access_start     <= '0';

    case state is
      when idle =>
        rd_start      <= S_AXI_ARVALID;
        wr_start      <= S_AXI_AWVALID and S_AXI_WVALID;
        access_start  <= S_AXI_ARVALID or (S_AXI_AWVALID and S_AXI_WVALID);
        gp_reg_start  <= gp_bank and (S_AXI_ARVALID or (S_AXI_AWVALID and S_AXI_WVALID));
        gp_reg_start1 <= gp_bank1 and (S_AXI_ARVALID or (S_AXI_AWVALID and S_AXI_WVALID));

      when read_regs =>
        rd_data_ce <= '1';

      when write_regs =>

      when send_resp =>

      when others =>
    end case;
  end process;

  --------------------
  -- INPUT DATAPATH --
  --------------------

  process(S_AXI_ACLK)
  begin
    if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      wr_data_i <= S_AXI_WDATA;
    end if;
  end process;

  -----------------------------------------
  --- BANK 0: GENERAL PURPOSE REGISTERS ---
  -----------------------------------------

  -- Selection signal generation for inner registers:
  process(S_AXI_ACLK)
    variable offset : unsigned(REGS_ADDR_WIDTH-1 downto 0);
    constant LSB    : integer := log2(C_S_AXI_DATA_WIDTH/8);
    constant MSB    : integer := LSB+REGS_ADDR_WIDTH-1;
  begin
    if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      if(axi_rst = '1' or wr_data_rdy = '1' or rd_data_vld = '1') then
        reg_sel <= (others => '0');
      elsif(gp_reg_start = '1') then
        offset := unsigned(axi_addr(MSB downto LSB));
        for i in reg_sel'range loop
          if(offset = i) then
            reg_sel(i) <= '1';
          else
            reg_sel(i) <= '0';
          end if;
        end loop;
      end if;
    end if;
  end process;

  ---------------------------------
  -- CONTROL REGISTER (INDEX  0) --
  ---------------------------------

  process(S_AXI_ACLK, axi_rst)
  begin
    if(axi_rst = '1') then
      ctrl_reg <= (others => '0');
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      if(reg_sel(CTRL_REG_INDEX) = '1' and wr_data_rdy = '1') then
        for i in 0 to STRB_WIDTH-1 loop
          if(S_AXI_WSTRB(i) = '1') then
            ctrl_reg(8*(i+1)-1 downto 8*i) <= S_AXI_WDATA(8*(i+1)-1 downto 8*i);
          end if;
        end loop;
      end if;
    end if;
  end process;

  ap_rst_i     <= ctrl_reg(0) or axi_rst;
  glb_int_en <= ctrl_reg(1);

 process(S_AXI_ACLK, axi_rst)
  begin
    if(axi_rst = '1') then
      ap_rst <= '1';
      ap_rst_fb <= '1';
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      ap_rst <= ap_rst_i;
      ap_rst_fb <= ap_rst_i;
    end if;
  end process;


  --------------------------------
  -- STATUS REGISTER (INDEX  1) --
  --------------------------------

  status_reg(0)           <= status_ap_start;
  status_reg(1)           <= status_ap_done;
  status_reg(2)           <= status_ap_idle;
  status_reg(3)           <= status_ap_ready;
  status_reg(31 downto 4) <= (others => '0');

  process(S_AXI_ACLK, ap_rst_fb)
  begin
    if(ap_rst_fb = '1') then
      status_ap_start_clr <= '0';
      status_ap_done_clr  <= '0';
      status_ap_idle_clr  <= '0';
      status_ap_ready_clr <= '0';
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      status_ap_start_clr <= reg_sel(STATUS_REG_INDEX) and wr_data_rdy and S_AXI_WSTRB(0) and S_AXI_WDATA(0);
      status_ap_done_clr  <= reg_sel(STATUS_REG_INDEX) and wr_data_rdy and S_AXI_WSTRB(0) and S_AXI_WDATA(1);
      status_ap_idle_clr  <= reg_sel(STATUS_REG_INDEX) and wr_data_rdy and S_AXI_WSTRB(0) and S_AXI_WDATA(2);
      status_ap_ready_clr <= reg_sel(STATUS_REG_INDEX) and wr_data_rdy and S_AXI_WSTRB(0) and S_AXI_WDATA(3);
    end if;
  end process;

  -----------------------------------------------------
  -- INPUT ARG MULTIBUFFER RESET REGISTER (INDEX  2) --
  -----------------------------------------------------

  IARGS_RST_GEN : if (C_N_INPUT_ARGS > 0) generate
    signal reg : std_logic_vector(C_N_INPUT_ARGS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        reg <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel(IARG_RST_REG_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_INPUT_ARGS-1 loop
            reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(reg)
    begin
      host_iarg_rst              <= (others => '0');
      ap_iarg_rst_reg            <= (others => '0');
      host_iarg_rst(reg'range)   <= reg;
      ap_iarg_rst_reg(reg'range) <= reg;
    end process;

  end generate IARGS_RST_GEN;


  NO_IARGS_RST_GEN : if (C_N_INPUT_ARGS = 0) generate
  begin
    host_iarg_rst   <= (others => '0');
    ap_iarg_rst_reg <= (others => '0');
  end generate NO_IARGS_RST_GEN;

  ------------------------------------------------------
  -- OUTPUT ARG MULTIBUFFER RESET REGISTER (INDEX  3) --
  ------------------------------------------------------

  OARGS_RST_GEN : if (C_N_OUTPUT_ARGS > 0) generate
    signal reg : std_logic_vector(C_N_OUTPUT_ARGS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        reg <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel(OARG_RST_REG_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_OUTPUT_ARGS-1 loop
            reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(reg)
    begin
      host_oarg_rst              <= (others => '0');
      ap_oarg_rst_reg            <= (others => '0');
      host_oarg_rst(reg'range)   <= reg;
      ap_oarg_rst_reg(reg'range) <= reg;
    end process;
    
  end generate OARGS_RST_GEN;


  NO_OARGS_RST_GEN : if (C_N_OUTPUT_ARGS = 0) generate
  begin
    host_oarg_rst   <= (others => '0');
    ap_oarg_rst_reg <= (others => '0');
  end generate NO_OARGS_RST_GEN;

  --------------------------------------------------
  -- INPUT ARG REQUEST ENABLE REGISTER (INDEX  4) --
  --------------------------------------------------

  IARG_RQT_ENABLE_GEN : if (C_N_INPUT_ARGS > 0) generate
    signal reg : std_logic_vector(C_N_INPUT_ARGS-1 downto 0);
  begin
    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        -- reg <= (others => '0');
        reg <= (others => '1');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel(IARG_RQT_ENABLE_REG_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_INPUT_ARGS-1 loop
            reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(reg)
    begin
      iarg_rqt_enable                <= (others => '0');
      iarg_rqt_enable_reg            <= (others => '0');
      iarg_rqt_enable(reg'range)     <= reg;
      iarg_rqt_enable_reg(reg'range) <= reg;
    end process;

  end generate IARG_RQT_ENABLE_GEN;

  NO_IARG_RQT_ENABLE_GEN : if (C_N_INPUT_ARGS = 0) generate
  begin
    iarg_rqt_enable     <= (others => '0');
    iarg_rqt_enable_reg <= (others => '0');
  end generate NO_IARG_RQT_ENABLE_GEN;


  ---------------------------------------------------
  -- OUTPUT ARG REQUEST ENABLE REGISTER (INDEX  5) --
  ---------------------------------------------------

  OARG_RQT_ENABLE_GEN : if (C_N_OUTPUT_ARGS > 0) generate
    signal reg : std_logic_vector(C_N_OUTPUT_ARGS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        -- reg <= (others => '0');
        reg <= (others => '1');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel(OARG_RQT_ENABLE_REG_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_OUTPUT_ARGS-1 loop
            reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(reg)
    begin
      oarg_rqt_enable                <= (others => '0');
      oarg_rqt_enable_reg            <= (others => '0');
      oarg_rqt_enable(reg'range)     <= reg;
      oarg_rqt_enable_reg(reg'range) <= reg;
    end process;
    
  end generate OARG_RQT_ENABLE_GEN;

  NO_OARG_RQT_ENABLE_GEN : if (C_N_OUTPUT_ARGS = 0) generate
  begin
    oarg_rqt_enable     <= (others => '0');
    oarg_rqt_enable_reg <= (others => '0');
  end generate NO_OARG_RQT_ENABLE_GEN;

  ---------------------------------
  -- COMMAND REGISTER (INDEX 10) --
  ---------------------------------

  process(S_AXI_ACLK, ap_rst_fb)
  begin
    if(ap_rst_fb = '1') then
      host_cmd_we <= '0';
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      host_cmd_we <= reg_sel(COMMAND_REG_INDEX) and wr_data_rdy;
    end if;
  end process;

  host_cmd_data <= wr_data_i;

  -----------------------------------
  -- COMPLETE REGISTER (INDEX 11) --
  -----------------------------------

  process(S_AXI_ACLK, ap_rst_fb)
  begin
    if(ap_rst_fb = '1') then
      host_complete_re <= '0';
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      host_complete_re <= reg_sel(COMPLETE_REG_INDEX) and rd_data_vld;  -- ????
    end if;
  end process;


  --------------------------
  -- INTERRUPT MANAGEMENT --
  --------------------------

  ------------------------------------------
  -- INTERRUPT ENABLE REGISTER (INDEX 12) --
  ------------------------------------------

  process(S_AXI_ACLK, ap_rst_fb)
  begin
    if(ap_rst_fb = '1') then
      int_enable_reg <= (others => '0');
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      if(reg_sel(INT_ENABLE_REG_INDEX) = '1' and wr_data_rdy = '1') then
        int_enable_reg <= S_AXI_WDATA(N_INTS-1 downto 0);
      end if;
    end if;
  end process;

  -- Individual asigment for each interrupt source:
  int_rqt(0)                 <= host_cmd_error;
  int_rqt(N_INTS-1 downto 1) <= (others => '0');

  ----------------------------------------
  -- INTERRUPT FLAG REGISTER (INDEX 13) --
  ----------------------------------------

  process(S_AXI_ACLK, ap_rst_fb)
  begin
    if(ap_rst_fb = '1') then
      int_flag_reg <= (others => '0');
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      if(reg_sel(INT_FLAG_REG_INDEX) = '1' and wr_data_rdy = '1') then
        int_flag_reg <= int_flag_reg and not(S_AXI_WDATA(N_INTS-1 downto 0));
      else
        int_flag_reg <= int_flag_reg or int_rqt;
      end if;
    end if;
  end process;

  process(S_AXI_ACLK, ap_rst_fb)
  begin
    if(ap_rst_fb = '1') then
      interrupt <= '0';
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      interrupt <= or_reduce(int_flag_reg and int_enable_reg) and glb_int_en;
    end if;
  end process;

  -----------------------------------------
  --- BANK 1: GENERAL PURPOSE REGISTERS ---
  -----------------------------------------

  -- Selection signal generation for inner registers:
  process(S_AXI_ACLK)
    variable offset : unsigned(REGS_ADDR_WIDTH-1 downto 0);
    constant LSB    : integer := log2(C_S_AXI_DATA_WIDTH/8);
    constant MSB    : integer := LSB+REGS_ADDR_WIDTH-1;
  begin
    if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      if(ap_rst_fb = '1' or wr_data_rdy = '1' or rd_data_vld = '1') then
        reg_sel1 <= (others => '0');
      elsif(gp_reg_start1 = '1') then
        offset := unsigned(axi_addr(MSB downto LSB));
        for i in reg_sel1'range loop
          if(offset = i) then
            reg_sel1(i) <= '1';
          else
            reg_sel1(i) <= '0';
          end if;
        end loop;
      end if;
    end if;
  end process;


  -------------------------------------------------
  -- INPUT SCALAR FIFO RESET REGISTER (INDEX 16) --
  -------------------------------------------------

  ISCALAR_RST_GEN : if (C_N_INPUT_SCALARS > 0) generate
    signal rst_reg : std_logic_vector(C_N_INPUT_SCALARS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        rst_reg <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel1(ISCALAR_RST_REG_INDEX-BANK1_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_INPUT_SCALARS-1 loop
            rst_reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(rst_reg)
    begin
      host_iscalar_rst(C_MAX_N_ISCALARS-1 downto 0)            <= (others => '0');
      iscalar_rst_reg(C_MAX_N_ISCALARS-1 downto 0)             <= (others => '0');
      host_iscalar_rst(rst_reg'range) <= rst_reg;
      iscalar_rst_reg(rst_reg'range)  <= rst_reg;
    end process;

  end generate ISCALAR_RST_GEN;

  NO_ISCALAR_RST_GEN : if (C_N_INPUT_SCALARS = 0) generate
  begin
    host_iscalar_rst(C_MAX_N_ISCALARS-1 downto 0) <= (others => '0');
    iscalar_rst_reg(C_MAX_N_ISCALARS-1 downto 0)  <= (others => '0');
  end generate NO_ISCALAR_RST_GEN;

  ISCALAR_IO_RST_GEN : if (C_N_INOUT_SCALARS > 0) generate
    signal rst_reg : std_logic_vector(C_N_INOUT_SCALARS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        rst_reg <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel1(ISCALAR_RST_REG_INDEX-BANK1_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_INOUT_SCALARS-1 loop
            rst_reg(i) <= S_AXI_WDATA(i+C_MAX_N_ISCALARS) and S_AXI_WSTRB((i+C_MAX_N_ISCALARS)/8);
          end loop;
        end if;
      end if;
    end process;

    process(rst_reg)
    begin
      host_iscalar_rst(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS)            <= (others => '0');
      iscalar_rst_reg(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS)             <= (others => '0');
      host_iscalar_rst(C_MAX_N_ISCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_ISCALARS) <= rst_reg;
      iscalar_rst_reg(C_MAX_N_ISCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_ISCALARS)  <= rst_reg;
    end process;

  end generate ISCALAR_IO_RST_GEN;

  NO_ISCALAR_IO_RST_GEN : if (C_N_INOUT_SCALARS = 0) generate
  begin
    host_iscalar_rst(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS) <= (others => '0');
    iscalar_rst_reg(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS)  <= (others => '0');
  end generate NO_ISCALAR_IO_RST_GEN;


  --------------------------------------------------
  -- OUTPUT SCALAR FIFO RESET REGISTER (INDEX 17) --
  --------------------------------------------------

  OSCALAR_RST_GEN : if (C_N_OUTPUT_SCALARS > 0) generate
    signal rst_reg : std_logic_vector(C_N_OUTPUT_SCALARS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        rst_reg <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel1(OSCALAR_RST_REG_INDEX-BANK1_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_OUTPUT_SCALARS-1 loop
            rst_reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(rst_reg)
    begin
      host_oscalar_rst(C_MAX_N_OSCALARS-1 downto 0)            <= (others => '0');
      oscalar_rst_reg(C_MAX_N_OSCALARS-1 downto 0)             <= (others => '0');
      host_oscalar_rst(rst_reg'range) <= rst_reg;
      oscalar_rst_reg(rst_reg'range)  <= rst_reg;
    end process;

  end generate OSCALAR_RST_GEN;

  NO_OSCALAR_RST_GEN : if (C_N_OUTPUT_SCALARS = 0) generate
  begin
    host_oscalar_rst(C_MAX_N_OSCALARS-1 downto 0) <= (others => '0');
    oscalar_rst_reg(C_MAX_N_OSCALARS-1 downto 0)  <= (others => '0');
  end generate NO_OSCALAR_RST_GEN;

  OSCALAR_IO_RST_GEN : if (C_N_INOUT_SCALARS > 0) generate
    signal os_rst_reg : std_logic_vector(C_N_INOUT_SCALARS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        os_rst_reg <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel1(OSCALAR_RST_REG_INDEX-BANK1_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_INOUT_SCALARS-1 loop
            os_rst_reg(i) <= S_AXI_WDATA(i+C_MAX_N_OSCALARS) and S_AXI_WSTRB((i+C_MAX_N_OSCALARS)/8);
          end loop;
        end if;
      end if;
    end process;

    process(os_rst_reg)
    begin
      host_oscalar_rst(C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_OSCALARS)            <= (others => '0');
      oscalar_rst_reg(C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_OSCALARS)             <= (others => '0');
      host_oscalar_rst(C_MAX_N_OSCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_OSCALARS) <= os_rst_reg;
      oscalar_rst_reg(C_MAX_N_OSCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_OSCALARS)  <= os_rst_reg;
    end process;

  end generate OSCALAR_IO_RST_GEN;

  NO_OSCALAR_IO_RST_GEN : if (C_N_INOUT_SCALARS = 0) generate
  begin
    host_oscalar_rst(C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_OSCALARS) <= (others => '0');
    oscalar_rst_reg(C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_OSCALARS)  <= (others => '0');
  end generate NO_OSCALAR_IO_RST_GEN;

  -----------------------------------------------------
  -- INPUT SCALAR REQUEST ENABLE REGISTER (INDEX 18) --
  -----------------------------------------------------

  ISCALAR_RQT_ENABLE_GEN : if (C_N_INPUT_SCALARS > 0) generate
    signal reg : std_logic_vector(C_N_INPUT_SCALARS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        -- reg <= (others => '0');
        reg <= (others => '1');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel1(ISCALAR_RQT_ENABLE_REG_INDEX-BANK1_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_INPUT_SCALARS-1 loop
            reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(reg)
    begin
      iscalar_rqt_enable(C_MAX_N_ISCALARS-1 downto 0)                <= (others => '0');
      iscalar_rqt_enable_reg(C_MAX_N_ISCALARS-1 downto 0)            <= (others => '0');
      iscalar_rqt_enable(reg'range)     <= reg;
      iscalar_rqt_enable_reg(reg'range) <= reg;
    end process;

  end generate ISCALAR_RQT_ENABLE_GEN;


  NO_ISCALAR_RQT_ENABLE_GEN : if (C_N_INPUT_SCALARS = 0) generate
  begin
    iscalar_rqt_enable(C_MAX_N_ISCALARS-1 downto 0)     <= (others => '0');
    iscalar_rqt_enable_reg(C_MAX_N_ISCALARS-1 downto 0) <= (others => '0');
  end generate NO_ISCALAR_RQT_ENABLE_GEN;

  ISCALAR_IO_RQT_ENABLE_GEN : if (C_N_INOUT_SCALARS > 0) generate
    signal rqt_reg : std_logic_vector(C_N_INOUT_SCALARS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        -- reg <= (others => '0');
        rqt_reg <= (others => '1');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel1(ISCALAR_RQT_ENABLE_REG_INDEX-BANK1_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_INOUT_SCALARS-1 loop
            rqt_reg(i) <= S_AXI_WDATA(i+C_MAX_N_ISCALARS) and S_AXI_WSTRB((i+C_MAX_N_ISCALARS)/8);
          end loop;
        end if;
      end if;
    end process;

    process(rqt_reg)
    begin
      iscalar_rqt_enable(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS)                <= (others => '0');
      iscalar_rqt_enable_reg(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS)            <= (others => '0');
      iscalar_rqt_enable(C_MAX_N_ISCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_ISCALARS)     <= rqt_reg;
      iscalar_rqt_enable_reg(C_MAX_N_ISCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_ISCALARS) <= rqt_reg;
    end process;

  end generate ISCALAR_IO_RQT_ENABLE_GEN;


  NO_ISCALAR_IO_RQT_ENABLE_GEN : if (C_N_INOUT_SCALARS = 0) generate
  begin
    iscalar_rqt_enable(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS)     <= (others => '0');
    iscalar_rqt_enable_reg(C_MAX_N_ISCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_ISCALARS) <= (others => '0');
  end generate NO_ISCALAR_IO_RQT_ENABLE_GEN;


  ------------------------------------------------------
  -- OUTPUT SCALAR REQUEST ENABLE REGISTER (INDEX 19) --
  ------------------------------------------------------

  OSCALAR_RQT_ENABLE_GEN : if (C_N_OUTPUT_SCALARS > 0) generate
    signal reg : std_logic_vector(C_N_OUTPUT_SCALARS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        -- reg <= (others => '0');
        reg <= (others => '1');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel1(OSCALAR_RQT_ENABLE_REG_INDEX-BANK1_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_OUTPUT_SCALARS-1 loop
            reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(reg)
    begin
      oscalar_rqt_enable(C_MAX_N_OSCALARS-1 downto 0)                <= (others => '0');
      oscalar_rqt_enable_reg(C_MAX_N_OSCALARS-1 downto 0)            <= (others => '0');
      oscalar_rqt_enable(reg'range)     <= reg;
      oscalar_rqt_enable_reg(reg'range) <= reg;
    end process;
    
  end generate OSCALAR_RQT_ENABLE_GEN;

  NO_OSCALAR_RQT_ENABLE_GEN : if (C_N_OUTPUT_SCALARS = 0) generate
  begin
    oscalar_rqt_enable(C_MAX_N_OSCALARS-1 downto 0)     <= (others => '0');
    oscalar_rqt_enable_reg(C_MAX_N_OSCALARS-1 downto 0) <= (others => '0');
  end generate NO_OSCALAR_RQT_ENABLE_GEN;


  OSCALAR_IO_RQT_ENABLE_GEN : if (C_N_INOUT_SCALARS > 0) generate
    signal os_rqt_reg : std_logic_vector(C_N_INOUT_SCALARS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        -- reg <= (others => '0');
        os_rqt_reg <= (others => '1');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel1(OSCALAR_RQT_ENABLE_REG_INDEX-BANK1_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_INOUT_SCALARS-1 loop
            os_rqt_reg(i) <= S_AXI_WDATA(i+C_MAX_N_OSCALARS) and S_AXI_WSTRB((i+C_MAX_N_OSCALARS)/8);
          end loop;
        end if;
      end if;
    end process;

    process(os_rqt_reg)
    begin
      oscalar_rqt_enable(C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_OSCALARS)                <= (others => '0');
      oscalar_rqt_enable_reg(C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_OSCALARS)            <= (others => '0');
      oscalar_rqt_enable(C_MAX_N_OSCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_OSCALARS)     <= os_rqt_reg;
      oscalar_rqt_enable_reg(C_MAX_N_OSCALARS+C_N_INOUT_SCALARS-1 downto C_MAX_N_OSCALARS) <= os_rqt_reg;
    end process;
    
  end generate OSCALAR_IO_RQT_ENABLE_GEN;

  NO_OSCALAR_IO_RQT_ENABLE_GEN : if (C_N_INOUT_SCALARS = 0) generate
  begin
    oscalar_rqt_enable(C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_OSCALARS)     <= (others => '0');
    oscalar_rqt_enable_reg(C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 downto C_MAX_N_OSCALARS) <= (others => '0');
  end generate NO_OSCALAR_IO_RQT_ENABLE_GEN;



  -------------------------------------------------
  -- OUTPUT ARGS LENGTH MODE REGISTER (INDEX 15) --
  -------------------------------------------------

  OARG_USE_SW_LENGTH_GEN : if (C_N_OUTPUT_ARGS > 0) generate
    signal reg : std_logic_vector(C_N_OUTPUT_ARGS-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        reg <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        if(reg_sel(OARG_LENGTH_MODE_REG_INDEX) = '1' and wr_data_rdy = '1') then
          for i in 0 to C_N_OUTPUT_ARGS-1 loop
            reg(i) <= S_AXI_WDATA(i) and S_AXI_WSTRB(i/8);
          end loop;
        end if;
      end if;
    end process;

    process(reg)
    begin
      oarg_use_sw_length              <= (others => '0');
      oarg_length_mode_reg            <= (others => '0');
      oarg_use_sw_length(reg'range)   <= reg;
      oarg_length_mode_reg(reg'range) <= reg;
    end process;
    
  end generate OARG_USE_SW_LENGTH_GEN;


  NO_OARG_USE_SW_LENGTH_GEN : if (C_N_OUTPUT_ARGS = 0) generate
  begin
    oarg_use_sw_length   <= (others => '0');
    oarg_length_mode_reg <= (others => '0');
  end generate NO_OARG_USE_SW_LENGTH_GEN;


  ----------------------------
  -- BANK 0 OUTPUT DATAPATH --
  ----------------------------

  -- For V6/S6, when the number of channel of the multiplexer is lower than 16 it's more
  -- efficient to use a mux with binary selection input.

  -- Mux for general purpose register read datapath:
  process(rd_reg_addr,
          ctrl_reg, status_reg,
          ap_iarg_rst_reg, ap_oarg_rst_reg,
          iarg_rqt_enable_reg, oarg_rqt_enable_reg,
          oarg_length_mode_reg)
    variable addr : integer range 0 to N_REGS-1;
  begin
    mux_gp_regs <= (others => '0');
    addr        := to_integer(unsigned(rd_reg_addr));
    case addr is
      when CTRL_REG_INDEX             => mux_gp_regs <= ext_32(ctrl_reg);
      when STATUS_REG_INDEX           => mux_gp_regs <= ext_32(status_reg);
      when IARG_RST_REG_INDEX         => mux_gp_regs <= ext_32(ap_iarg_rst_reg);
      when OARG_RST_REG_INDEX         => mux_gp_regs <= ext_32(ap_oarg_rst_reg);
      when IARG_RQT_ENABLE_REG_INDEX  => mux_gp_regs <= ext_32(iarg_rqt_enable_reg);
      when OARG_RQT_ENABLE_REG_INDEX  => mux_gp_regs <= ext_32(oarg_rqt_enable_reg);
      when OARG_LENGTH_MODE_REG_INDEX => mux_gp_regs <= ext_32(oarg_length_mode_reg);
      when others                     =>
    end case;
  end process;

  ----------------------------------
  --- BANK 2: INPUT SCALAR FIFOs ---
  ----------------------------------

  process(S_AXI_ACLK, ap_rst_fb)
    constant N_ELEMENTS      : integer := C_MAX_N_ISCALARS + C_MAX_N_IOSCALARS;
    constant BANK_ADDR_WIDTH : integer := log2(N_ELEMENTS);
    variable offset          : unsigned(BANK_ADDR_WIDTH-1 downto 0);
    constant LSB             : integer := log2(C_S_AXI_DATA_WIDTH/8);
    constant MSB             : integer := LSB+BANK_ADDR_WIDTH-1;
  begin
    if(ap_rst_fb = '1') then
      host_iscalar_we <= (others => '0');
      --host_oscalar_re(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS -1 downto C_MAX_N_OSCALARS) <= (others => '0');
      host_ioscalar_re_i <= (others => '0');
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      host_iscalar_we <= (others => '0');
      --host_oscalar_re(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS -1 downto C_MAX_N_OSCALARS) <= (others => '0');
      host_ioscalar_re_i <= (others => '0');
      if(iscalar_bank = '1' and wr_start = '1') then
        offset := unsigned(axi_addr(MSB downto LSB));
        for i in 0 to N_ELEMENTS-1 loop
          if(offset = i) then
            host_iscalar_we(i) <= '1';
          else
            host_iscalar_we(i) <= '0';
          end if;
        end loop;
      end if;
      if(iscalar_bank = '1' and rd_start = '1') then
        offset := unsigned(axi_addr(MSB downto LSB));
        for i in C_MAX_N_ISCALARS to C_MAX_N_ISCALARS + C_MAX_N_IOSCALARS-1 loop
          if(offset = i) then
            --host_oscalar_re(i) <= '1';
            host_ioscalar_re_i(i) <= '1';
          else
            --host_oscalar_re(i) <= '0';
            host_ioscalar_re_i(i) <= '0';
          end if;
        end loop;
      end if;
    end if;
  end process;

  host_iscalar_dout <= wr_data_i;

  host_oscalar_re <= host_ioscalar_re_i & host_oscalar_re_i;
  -----------------------------------
  --- BANK 3: OUTPUT SCALAR FIFOs ---
  -----------------------------------


  process(S_AXI_ACLK, ap_rst_fb)
    constant N_ELEMENTS : integer := C_MAX_N_OSCALARS;

    constant BANK_ADDR_WIDTH : integer := log2(N_ELEMENTS);
    variable offset          : unsigned(BANK_ADDR_WIDTH-1 downto 0);
    constant LSB             : integer := log2(C_S_AXI_DATA_WIDTH/8);
    constant MSB             : integer := LSB+BANK_ADDR_WIDTH-1;
  begin
    if(ap_rst_fb = '1') then
      --host_oscalar_re(C_MAX_N_OSCALARS-1 downto 0) <= (others => '0');
      host_oscalar_re_i(C_MAX_N_OSCALARS-1 downto 0) <=(others => '0');
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      --host_oscalar_re(C_MAX_N_OSCALARS-1 downto 0) <= (others => '0');
      host_oscalar_re_i(C_MAX_N_OSCALARS-1 downto 0) <=(others => '0');
      if(oscalar_bank = '1' and rd_start = '1') then
        offset := unsigned(axi_addr(MSB downto LSB));
        for i in 0 to N_ELEMENTS-1 loop
          if(offset = i) then
            --host_oscalar_re(i) <= '1';
            host_oscalar_re_i(i) <='1';
          else
           -- host_oscalar_re(i) <= '0';
            host_oscalar_re_i(i) <='0';
          end if;
        end loop;
      end if;
    end if;
  end process;


--  process(S_AXI_ACLK, ap_rst_fb)
--    constant N_ELEMENTS : integer := C_MAX_N_OSCALARS;
--
--    constant BANK_ADDR_WIDTH : integer := log2(N_ELEMENTS);
--    variable offset          : unsigned(BANK_ADDR_WIDTH-1 downto 0);
--    constant LSB             : integer := log2(C_S_AXI_DATA_WIDTH/8);
--    constant MSB             : integer := LSB+BANK_ADDR_WIDTH-1;
--  begin
--    if(ap_rst_fb = '1') then
--      host_oscalar_re(7 downto 0) <= (others => '0');
--    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
--      host_oscalar_re(7 downto 0) <= (others => '0');
--      if(oscalar_bank = '1' and rd_start = '1') then
--        offset := unsigned(axi_addr(MSB downto LSB));
--        for i in 0 to 7 loop
--          if(offset = i) then
--            host_oscalar_re(i) <= '1';
--          else
--            host_oscalar_re(i) <= '0';
--          end if;
--        end loop;
--      end if;
--    end if;
--  end process;

  -- Output scalar data mux:
  process(rd_reg_addr, host_oscalar_din)
  begin
    mux_oscalar_data <= (others => '0');
    for i in 0 to C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 loop
      if(i = unsigned(rd_reg_addr)) then
        mux_oscalar_data <= ext_32(host_oscalar_din(C_MAX_SCALAR_DWIDTH*(i+1)-1 downto C_MAX_SCALAR_DWIDTH*i));
      end if;
    end loop;
  end process;

--  -----------------------------------
--  --- BANK 2: INOUT SCALAR FIFOs ---
--  -----------------------------------
--
--  process(S_AXI_ACLK, ap_rst_fb)
--    constant N_ELEMENTS : integer := C_MAX_N_OSCALARS + C_MAX_N_IOSCALARS;
--
--    constant BANK_ADDR_WIDTH : integer := log2(N_ELEMENTS);
--    variable offset          : unsigned(BANK_ADDR_WIDTH-1 downto 0);
--    constant LSB             : integer := log2(C_S_AXI_DATA_WIDTH/8);
--    constant MSB             : integer := LSB+BANK_ADDR_WIDTH-1;
--  begin
--    if(ap_rst_fb = '1') then
--      host_oscalar_re(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto C_MAX_N_OSCALARS) <= (others => '0');
--      host_iscalar_we(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto C_MAX_N_ISCALARS) <= (others => '0');
--    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
--      host_oscalar_re(C_MAX_N_IOSCALARS+C_MAX_N_OSCALARS-1 downto C_MAX_N_OSCALARS) <= (others => '0');
--      host_iscalar_we(C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 downto C_MAX_N_ISCALARS) <= (others => '0');
--      if(iscalar_bank = '1' and wr_start = '1') then
--        offset := unsigned(axi_addr(MSB downto LSB));
--        for i in 8 to N_ELEMENTS-1 loop
--          if(offset = i) then
--            host_iscalar_we(i) <= '1';
--          else
--            host_iscalar_we(i) <= '0';
--          end if;
--        end loop;
--      end if;
--      if(iscalar_bank = '1' and rd_start = '1') then
--        offset := unsigned(axi_addr(MSB downto LSB));
--        for i in 8 to N_ELEMENTS-1 loop
--          if(offset = i) then
--            host_oscalar_re(i) <= '1';
--          else
--            host_oscalar_re(i) <= '0';
--          end if;
--        end loop;
--      end if;
--    end if;
--  end process;
--

  ------------------------------------------
  --- BANK 4: INPUT ARG STATUS REGISTERS ---
  ------------------------------------------

  -- Status registers for input arguments:
  process(rd_reg_addr, status_iarg_used, status_iarg_empty_sync, status_iarg_full)
  begin
    mux_iarg_status <= (others => '0');
    for i in 0 to C_MAX_N_IARGS-1 loop
      if(i = unsigned(rd_reg_addr)) then
        mux_iarg_status(3 downto 0) <= status_iarg_used(4*(i+1)-1 downto 4*i);
        mux_iarg_status(4)          <= status_iarg_empty_sync(i);
        mux_iarg_status(5)          <= status_iarg_full(i);
      end if;
    end loop;
  end process;


  -------------------------------------------
  --- BANK 5: OUTPUT ARG STATUS REGISTERS ---
  -------------------------------------------

  -- Status registers for output arguments:
  process(rd_reg_addr, status_oarg_used, status_oarg_empty, status_oarg_full)
  begin
    mux_oarg_status <= (others => '0');
    for i in 0 to C_MAX_N_OARGS-1 loop
      if(i = unsigned(rd_reg_addr)) then
        mux_oarg_status(3 downto 0) <= status_oarg_used(4*(i+1)-1 downto 4*i);
        mux_oarg_status(4)          <= status_oarg_empty(i);
        mux_oarg_status(5)          <= status_oarg_full(i);
      end if;
    end loop;
  end process;

  ---------------------------------------------
  --- BANK 6: INPUT SCALAR STATUS REGISTERS ---
  ---------------------------------------------

  -- Status registers for input scalars:
  process(rd_reg_addr, status_iscalar_used, status_iscalar_empty, status_iscalar_full)
  begin
    mux_iscalar_status <= (others => '0');
    for i in 0 to C_MAX_N_IOSCALARS+C_MAX_N_ISCALARS-1 loop
      if(i = unsigned(rd_reg_addr)) then
        mux_iscalar_status(3 downto 0) <= status_iscalar_used(4*(i+1)-1 downto 4*i);
        mux_iscalar_status(4)          <= status_iscalar_empty(i);
        mux_iscalar_status(5)          <= status_iscalar_full(i);
      end if;
    end loop;
  end process;

  ----------------------------------------------
  --- BANK 7: OUTPUT SCALAR STATUS REGISTERS ---
  ----------------------------------------------

  -- Status registers for output scalars:
  process(rd_reg_addr, status_oscalar_used, status_oscalar_empty, status_oscalar_full)
  begin
    mux_oscalar_status <= (others => '0');
    for i in 0 to C_MAX_N_OSCALARS+C_MAX_N_IOSCALARS-1 loop
      if(i = unsigned(rd_reg_addr)) then
        mux_oscalar_status(3 downto 0) <= status_oscalar_used(4*(i+1)-1 downto 4*i);
        mux_oscalar_status(4)          <= status_oscalar_empty(i);
        mux_oscalar_status(5)          <= status_oscalar_full(i);
      end if;
    end loop;
  end process;

  -------------------------------------------
  --- BANK 8: OUTPUT ARGS SW LENGTH FIFOs ---
  --------------------------------------------

  process(S_AXI_ACLK, ap_rst_fb)
    constant N_ELEMENTS      : integer := C_MAX_N_OARGS;
    constant BANK_ADDR_WIDTH : integer := log2(N_ELEMENTS);
    variable offset          : unsigned(BANK_ADDR_WIDTH-1 downto 0);
    constant LSB             : integer := log2(C_S_AXI_DATA_WIDTH/8);
    constant MSB             : integer := LSB+BANK_ADDR_WIDTH-1;
  begin
    if(ap_rst_fb = '1') then
      oarg_sw_length_we_i <= (others => '0');
    elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      oarg_sw_length_we_i <= (others => '0');
      if(oarg_length_bank = '1' and wr_start = '1') then
        offset := unsigned(axi_addr(MSB downto LSB));
        for i in 0 to N_ELEMENTS-1 loop
          if(offset = i) then
            oarg_sw_length_we_i(i) <= '1';
          else
            oarg_sw_length_we_i(i) <= '0';
          end if;
        end loop;
      end if;
    end if;
  end process;

  --oarg_sw_length <= wr_data_i;
    oarg_sw_length_we_event <= or_reduce(oarg_sw_length_we_i);
    oarg_sw_length_we <= oarg_sw_length_we_i;
    
    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        oarg_sw_length <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
          if(oarg_sw_length_we_event = '1') then
            oarg_sw_length <= wr_data_i;
          end if;
      end if;
    end process;
    process(S_AXI_ACLK)
    begin
      if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
          if(oarg_sw_length_we_event = '1') then
            oarg_sw_length_m2s <= wr_data_i;
          end if;
      end if;
    end process;

  -------------------------------------------
  --- BANK 9: OUTPUT ARGS TDEST REGISTERS ---
  -------------------------------------------

  OARG_TDEST_GEN : if (C_N_OUTPUT_ARGS > 0) generate
    signal oarg_tdest_reg_we : std_logic_vector(N_REGS-1 downto 0);
    signal oarg_tdest_reg    : std_logic_vector(C_N_OUTPUT_ARGS*C_M_AXIS_TDEST_WIDTH-1 downto 0);
  begin

    process(S_AXI_ACLK, ap_rst_fb)
      constant N_ELEMENTS      : integer := C_MAX_N_OARGS;
      constant BANK_ADDR_WIDTH : integer := log2(N_ELEMENTS);
      variable offset          : unsigned(BANK_ADDR_WIDTH-1 downto 0);
      constant LSB             : integer := log2(C_S_AXI_DATA_WIDTH/8);
      constant MSB             : integer := LSB+BANK_ADDR_WIDTH-1;
    begin
      if(ap_rst_fb = '1') then
        oarg_tdest_reg_we <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        oarg_tdest_reg_we <= (others => '0');
        if(oarg_tdest_bank = '1' and wr_start = '1') then
          offset := unsigned(axi_addr(MSB downto LSB));
          for i in 0 to N_ELEMENTS-1 loop
            if(offset = i) then
              oarg_tdest_reg_we(i) <= '1';
            else
              oarg_tdest_reg_we(i) <= '0';
            end if;
          end loop;
        end if;
      end if;
    end process;

    process(S_AXI_ACLK, ap_rst_fb)
    begin
      if(ap_rst_fb = '1') then
        oarg_tdest_reg <= (others => '0');
      elsif(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
        for i in 0 to C_N_OUTPUT_ARGS-1 loop
          if(oarg_tdest_reg_we(i) = '1') then
            oarg_tdest_reg(C_M_AXIS_TDEST_WIDTH*(i+1)-1 downto C_M_AXIS_TDEST_WIDTH*i) <=
              S_AXI_WDATA(C_M_AXIS_TDEST_WIDTH-1 downto 0);
          end if;
        end loop;
      end if;
    end process;

    process(rd_reg_addr, oarg_tdest_reg)
      variable addr : integer range 0 to N_REGS-1;
    begin
      mux_oarg_tdest_regs <= (others => '0');
      addr                := to_integer(unsigned(rd_reg_addr));
      for i in 0 to C_N_OUTPUT_ARGS-1 loop
        if(i = addr) then
          mux_oarg_tdest_regs <= ext_32(oarg_tdest_reg(C_M_AXIS_TDEST_WIDTH*(i+1)-1 downto C_M_AXIS_TDEST_WIDTH*i));
        end if;
      end loop;
    end process;

    process(oarg_tdest_reg)
    begin
      host_oarg_tdest                                                  <= (others => '0');
      host_oarg_tdest(C_N_OUTPUT_ARGS*C_M_AXIS_TDEST_WIDTH-1 downto 0) <= oarg_tdest_reg;
    end process;

  end generate OARG_TDEST_GEN;


  NO_OARG_TDEST_GEN : if (C_N_OUTPUT_ARGS = 0) generate
  begin
    mux_oarg_tdest_regs <= (others => '0');
    host_oarg_tdest     <= (others => '0');
  end generate NO_OARG_TDEST_GEN;


  ---------------------
  -- OUTPUT DATAPATH --
  ---------------------

  process(S_AXI_ACLK)
    variable int_addr : integer range 0 to (2**BANK_ADDR_WIDTH)-1;
  begin
    if(S_AXI_ACLK'event and S_AXI_ACLK = '1') then
      if(axi_rst = '1' or (rd_data_vld and S_AXI_RREADY) = '1') then
        rd_data <= (others => '0');
      elsif(rd_data_ce = '1') then
        int_addr := to_integer(unsigned(rd_bank_addr));
        case int_addr is
          when GP_REGS_BANK_ADDR        => rd_data <= mux_gp_regs;
          when OSCALAR_BANK_ADDR        => rd_data <= mux_oscalar_data;
          when ISCALAR_BANK_ADDR        => rd_data <= mux_oscalar_data;
          when IARG_STATUS_BANK_ADDR    => rd_data <= mux_iarg_status;
          when OARG_STATUS_BANK_ADDR    => rd_data <= mux_oarg_status;
          when ISCALAR_STATUS_BANK_ADDR => rd_data <= mux_iscalar_status;
          when OSCALAR_STATUS_BANK_ADDR => rd_data <= mux_oscalar_status;
          when OARG_TDEST_BANK_ADDR     => rd_data <= mux_oarg_tdest_regs;
          when others                   => rd_data <= (others => '0');
        end case;
      end if;
    end if;
  end process;

end rtl;

