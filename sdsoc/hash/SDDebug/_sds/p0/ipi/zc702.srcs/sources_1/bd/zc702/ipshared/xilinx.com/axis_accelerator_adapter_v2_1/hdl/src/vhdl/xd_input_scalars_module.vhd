-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : xd_input_scalars_module.vhd
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
use axis_accelerator_adapter_v2_1_6.xd_input_scalars_fifo;




entity xd_input_scalars_module is
  generic (
    -- System generics:
    C_FAMILY                : string  := "virtex6";  -- Xilinx FPGA family
    C_MTBF_STAGES           : integer;
    C_PRMRY_IS_ACLK_ASYNC   : integer;
    C_MAX_N_ISCALARS        : integer;
    C_N_INPUT_SCALARS       : integer;
    C_N_INOUT_SCALARS       : integer;
    C_INPUT_SCALAR_DWIDTH   : std_logic_vector;
    C_AP_ISCALAR_DOUT_WIDTH : integer;
    C_NONE                  : integer := 2);
  port (
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    iscalar_rst          : in  std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    iscalar_din          : in  std_logic_vector(31 downto 0);
    iscalar_we           : in  std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    status_iscalar_empty : out std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    status_iscalar_full  : out std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    status_iscalar_used  : out std_logic_vector(C_MAX_N_ISCALARS*4-1 downto 0);
    --- AP input scalars
    ap_clk               : in  std_logic;
    ap_rst               : in  std_logic;
    ap_rst_s_axi_aclk    : in  std_logic;
    ap_iscalar_rdy       : out std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    ap_iscalar_done      : in  std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
    ap_iscalar_dout      : out std_logic_vector(C_AP_ISCALAR_DOUT_WIDTH-1 downto 0));
end entity;

architecture rtl of xd_input_scalars_module is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";
  signal status_iscalar_used_i : std_logic_vector(C_MAX_N_ISCALARS*4-1 downto 0);
  signal status_iscalar_empty_i : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);
  signal ap_iscalar_rdy_i : std_logic_vector(C_MAX_N_ISCALARS-1 downto 0);

begin

  INPUT_SCALARS_GEN : for i in 0 to C_MAX_N_ISCALARS-1 generate
  begin
    
    ACTIVE_GEN : if (i < C_N_INPUT_SCALARS) generate
      constant ISCALAR_DWIDTH : integer := get_int_element(C_INPUT_SCALAR_DWIDTH, i);
      constant ISCALAR_LSB    : integer := get_compact_LSB(C_INPUT_SCALAR_DWIDTH, i);
      constant ISCALAR_MSB    : integer := get_compact_MSB(C_INPUT_SCALAR_DWIDTH, i);

      signal dout_i   : std_logic_vector(ISCALAR_DWIDTH-1 downto 0);
      signal empty    : std_logic;
      signal fifo_rst_reg : std_logic;
    begin

    --  fifo_rst <= ap_rst_s_axi_aclk or iscalar_rst(i);
  process(clk, ap_rst_s_axi_aclk)
  begin
    if(ap_rst_s_axi_aclk = '1') then
      fifo_rst_reg <= '1';
    elsif(clk'event and clk = '1') then
      fifo_rst_reg <= iscalar_rst(i);
    end if;
  end process;


      -- Input scalars must show a behaviour equal to the input arguments in 
      -- the sense that written data by the processor must be inmediatelly 
      -- available for the accelerator. So a write-through FIFO is used.

      FIFO_I : entity axis_accelerator_adapter_v2_1_6.xd_input_scalars_fifo
        generic map (
          C_FAMILY => C_FAMILY,
          C_MTBF_STAGES   => C_MTBF_STAGES, 
          WIDTH    => ISCALAR_DWIDTH)
        port map (
          din      => iscalar_din(ISCALAR_DWIDTH-1 downto 0),
          din_vld  => iscalar_we(i),
          din_rdy  => open,
          wr_used  => status_iscalar_used_i(4*(i+1)-1 downto 4*i),
          wr_empty => status_iscalar_empty_i(i),
          wr_full  => status_iscalar_full(i),
          wr_clk   => clk,
          dout     => dout_i,
          dout_vld => ap_iscalar_rdy_i(i),
          dout_rdy => ap_iscalar_done(i),
          rd_clk   => ap_clk,
          rst      => fifo_rst_reg);

      ap_iscalar_dout(ISCALAR_MSB downto ISCALAR_LSB) <= dout_i;
   EN_SYNC_GEN_ISCALAR : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
   begin
   

    XD_ISCALAR_STATUS_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => 4,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => '0',
        prmry_vect_in              => status_iscalar_used_i(4*(i+1)-1 downto 4*i),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => open,
        scndry_vect_out            => status_iscalar_used(4*(i+1)-1 downto 4*i)
        );

    XD_ISCALAR_EMPTY_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_ISCALARS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => status_iscalar_empty_i(i),
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => status_iscalar_empty(i),
        scndry_vect_out            => open
        );

    XD_ISCALAR_RDY_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_ISCALARS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => ap_iscalar_rdy_i(i),
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => ap_iscalar_rdy(i),
        scndry_vect_out            => open
        );

	


   end generate EN_SYNC_GEN_ISCALAR;

       NO_SYNC_GEN_ISCALAR : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
   begin

      status_iscalar_empty(i)                     <= status_iscalar_empty_i(i);
      ap_iscalar_rdy(i)                     <= ap_iscalar_rdy_i(i);
      status_iscalar_used(4*(i+1)-1 downto 4*i)  <= status_iscalar_used_i(4*(i+1)-1 downto 4*i);

   end generate NO_SYNC_GEN_ISCALAR;


    end generate ACTIVE_GEN;

    INACTIVE_GEN : if (i > C_N_INPUT_SCALARS-1 and i < 8) generate
      constant ISCALAR_DWIDTH : integer := get_int_element(C_INPUT_SCALAR_DWIDTH, i);
      constant ISCALAR_LSB    : integer := get_compact_LSB(C_INPUT_SCALAR_DWIDTH, i);
      constant ISCALAR_MSB    : integer := get_compact_MSB(C_INPUT_SCALAR_DWIDTH, i);

    begin
      --ap_iscalar_dout(ISCALAR_MSB downto ISCALAR_LSB) <= (others => '0');
      status_iscalar_empty(i)                   <= '0';
      status_iscalar_full(i)                    <= '0';
      status_iscalar_used(4*(i+1)-1 downto 4*i) <= (others => '0');

      -- A non used input scalar is always ready:
      ap_iscalar_rdy(i) <= '1';
    end generate INACTIVE_GEN;


--Pankaj
    INOUT_ACTIVE_GEN : if (i > 7 and i < C_N_INOUT_SCALARS) generate
      constant ISCALAR_DWIDTH : integer := get_int_element(C_INPUT_SCALAR_DWIDTH, i);
      constant ISCALAR_LSB    : integer := get_compact_LSB_IO(C_INPUT_SCALAR_DWIDTH, i);
      constant ISCALAR_MSB    : integer := get_compact_MSB_IO(C_INPUT_SCALAR_DWIDTH, i);

      signal dout_i   : std_logic_vector(ISCALAR_DWIDTH-1 downto 0);
      signal empty    : std_logic;
      signal fifo_rst_reg : std_logic;
    begin

  --    fifo_rst <= ap_rst_s_axi_aclk or iscalar_rst(i);
  process(clk, ap_rst_s_axi_aclk)
  begin
    if(ap_rst_s_axi_aclk = '1') then
      fifo_rst_reg <= '1';
    elsif(clk'event and clk = '1') then
      fifo_rst_reg <= iscalar_rst(i);
    end if;
  end process;

      -- Input scalars must show a behaviour equal to the input arguments in 
      -- the sense that written data by the processor must be inmediatelly 
      -- available for the accelerator. So a write-through FIFO is used.

      FIFO_I : entity axis_accelerator_adapter_v2_1_6.xd_input_scalars_fifo
        generic map (
          C_FAMILY => C_FAMILY,
          C_MTBF_STAGES   => C_MTBF_STAGES, 
          WIDTH    => ISCALAR_DWIDTH)
        port map (
          din      => iscalar_din(ISCALAR_DWIDTH-1 downto 0),
          din_vld  => iscalar_we(i),
          din_rdy  => open,
          wr_used  => status_iscalar_used_i(4*(i+1)-1 downto 4*i),
          wr_empty => status_iscalar_empty_i(i),
          wr_full  => status_iscalar_full(i),
          wr_clk   => clk,
          dout     => dout_i,
          dout_vld => ap_iscalar_rdy_i(i),
          dout_rdy => ap_iscalar_done(i),
          rd_clk   => ap_clk,
          rst      => fifo_rst_reg);

      ap_iscalar_dout(ISCALAR_MSB downto ISCALAR_LSB) <= dout_i;

         EN_SYNC_GEN_ISCALAR : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
   begin
   

    XD_ISCALAR_STATUS_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 0,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => 4,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => '0',
        prmry_vect_in              => status_iscalar_used_i(4*(i+1)-1 downto 4*i),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => open,
        scndry_vect_out            => status_iscalar_used(4*(i+1)-1 downto 4*i)
        );

    XD_ISCALAR_EMPTY_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_ISCALARS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => status_iscalar_empty_i(i),
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => status_iscalar_empty(i),
        scndry_vect_out            => open
        );

    XD_ISCALAR_RDY_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_ISCALARS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => ap_iscalar_rdy_i(i),
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => ap_iscalar_rdy(i),
        scndry_vect_out            => open
        );

	


   end generate EN_SYNC_GEN_ISCALAR;

       NO_SYNC_GEN_ISCALAR : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
   begin

      status_iscalar_empty(i)                     <= status_iscalar_empty_i(i);
      ap_iscalar_rdy(i)                     <= ap_iscalar_rdy_i(i);
      status_iscalar_used(4*(i+1)-1 downto 4*i)  <= status_iscalar_used_i(4*(i+1)-1 downto 4*i);

   end generate NO_SYNC_GEN_ISCALAR;


    end generate INOUT_ACTIVE_GEN;

    INOUT_INACTIVE_GEN : if (i > C_N_INOUT_SCALARS-1) generate
    begin
      status_iscalar_empty(i)                   <= '0';
      status_iscalar_full(i)                    <= '0';
      status_iscalar_used(4*(i+1)-1 downto 4*i) <= (others => '0');

      -- A non used input scalar is always ready:
      ap_iscalar_rdy(i) <= '1';


    end generate INOUT_INACTIVE_GEN;

 
---

  end generate INPUT_SCALARS_GEN;

  NO_INPUT_SCALAR_GEN : if (C_N_INPUT_SCALARS = 0 and (C_N_INOUT_SCALARS-8) = 0) generate
  begin
    ap_iscalar_dout <= (others => '0');
  end generate NO_INPUT_SCALAR_GEN;

end rtl;
