-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : xd_output_scalars_module.vhd
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
use axis_accelerator_adapter_v2_1_6.xd_output_scalars_fifo;

entity xd_output_scalars_module is
  generic (
    -- System generics:
    C_FAMILY               : string  := "virtex6";  -- Xilinx FPGA family
    C_MTBF_STAGES          : integer;
    C_PRMRY_IS_ACLK_ASYNC  : integer;
    C_MAX_N_OSCALARS       : integer;
    C_MAX_SCALAR_DWIDTH    : integer;
    C_N_OUTPUT_SCALARS     : integer;
    C_N_INOUT_SCALARS      : integer;
    C_OUTPUT_SCALAR_DWIDTH : std_logic_vector;
    C_AP_OSCALAR_DIN_WIDTH : integer;
    C_NONE                 : integer := 2);
  port (
    --- AP output arguments
    ap_clk               : in  std_logic;
    ap_rst               : in  std_logic;
    ap_rst_s_axi_aclk    : in  std_logic;
    ap_oscalar_vld       : in  std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    ap_oscalar_rdy       : out std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    ap_oscalar_din       : in  std_logic_vector(C_AP_OSCALAR_DIN_WIDTH-1 downto 0);
    clk                  : in  std_logic;
    rst                  : in  std_logic;
    oscalar_rst          : in  std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    oscalar_data         : out std_logic_vector(C_MAX_N_OSCALARS*C_MAX_SCALAR_DWIDTH-1 downto 0);
    oscalar_re           : in  std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    status_oscalar_empty : out std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    status_oscalar_full  : out std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
    status_oscalar_used  : out std_logic_vector(C_MAX_N_OSCALARS*4-1 downto 0));
end entity;

architecture rtl of xd_output_scalars_module is

  attribute DowngradeIPIdentifiedWarnings: string;
  attribute DowngradeIPIdentifiedWarnings of rtl : architecture is "yes";
  signal status_oscalar_full_i : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  signal status_oscalar_full_i1 : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  signal ap_oscalar_rdy_i : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);
  signal ap_oscalar_rdy_i1 : std_logic_vector(C_MAX_N_OSCALARS-1 downto 0);

begin

  OUTPUT_SCALARS_GEN : for i in 0 to C_MAX_N_OSCALARS-1 generate
  begin

    ACTIVE_GEN : if (i < C_N_OUTPUT_SCALARS) generate
      constant OSCALAR_DWIDTH : integer := get_int_element(C_OUTPUT_SCALAR_DWIDTH, i);
      constant OSCALAR_LSB    : integer := get_compact_LSB(C_OUTPUT_SCALAR_DWIDTH, i);
      constant OSCALAR_MSB    : integer := get_compact_MSB(C_OUTPUT_SCALAR_DWIDTH, i);

      signal dout_i   : std_logic_vector(OSCALAR_DWIDTH-1 downto 0);
      signal fifo_rst_reg : std_logic;

    begin

  --    fifo_rst <= ap_rst_s_axi_aclk or oscalar_rst(i);
  process(clk, ap_rst_s_axi_aclk)
  begin
    if(ap_rst_s_axi_aclk = '1') then
      fifo_rst_reg <= '1';
    elsif(clk'event and clk = '1') then
      fifo_rst_reg <= oscalar_rst(i);
    end if;
  end process;

      -- We might need to generate one hot for ap_oscalar_vld if there is no full handshake for output scalar vld
      -- accelerator might hold valid high for more than one clock
      -- TBD
      
      -- oscalar_re signals are generated at the begining of the data phase;
      -- not required a write-through fifo.
      FIFO_I : entity axis_accelerator_adapter_v2_1_6.xd_output_scalars_fifo
        generic map (
          C_FAMILY => C_FAMILY,
          C_MTBF_STAGES => C_MTBF_STAGES,
          WIDTH    => OSCALAR_DWIDTH)
        port map (
          din      => ap_oscalar_din(OSCALAR_MSB downto OSCALAR_LSB),
          din_vld  => ap_oscalar_vld(i),
          din_rdy  => ap_oscalar_rdy_i(i),
          wr_clk   => ap_clk,
          dout     => dout_i,
          dout_vld => open,
          dout_rdy => oscalar_re(i),
          rd_used  => status_oscalar_used(4*(i+1)-1 downto 4*i),
          rd_empty => status_oscalar_empty(i),
          rd_full  => status_oscalar_full_i(i),
          rd_clk   => clk,
          rst      => fifo_rst_reg);

      process(dout_i)
      begin
        oscalar_data((i+1)*C_MAX_SCALAR_DWIDTH-1 downto i*C_MAX_SCALAR_DWIDTH)            <= (others => '0');
        oscalar_data(i*C_MAX_SCALAR_DWIDTH+OSCALAR_DWIDTH-1 downto i*C_MAX_SCALAR_DWIDTH) <= dout_i;
      end process;


        EN_SYNC_GEN_OSCALAR : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
   begin
   

    XD_OSCALAR_FULL_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_OSCALARS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => status_oscalar_full_i(i),
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => status_oscalar_full(i),
        scndry_vect_out            => open
        );

	
    XD_OSCALAR_RDY_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_OSCALARS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => ap_oscalar_rdy_i(i),
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => ap_oscalar_rdy(i),
        scndry_vect_out            => open
        );

	


   end generate EN_SYNC_GEN_OSCALAR;

       NO_SYNC_GEN_OSCALAR : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
   begin

      status_oscalar_full(i)                     <= status_oscalar_full_i(i);
      ap_oscalar_rdy(i)                     <= ap_oscalar_rdy_i(i);

   end generate NO_SYNC_GEN_OSCALAR;


    end generate ACTIVE_GEN;

    INACTIVE_GEN : if (i > C_N_OUTPUT_SCALARS-1 and i < 8) generate
    begin
      oscalar_data((i+1)*C_MAX_SCALAR_DWIDTH-1 downto i*C_MAX_SCALAR_DWIDTH) <= (others => '0');

      -- A non used scalar is always ready:
      ap_oscalar_rdy(i) <= '1';

      status_oscalar_empty(i)                   <= '0';
      status_oscalar_full(i)                    <= '0';
      status_oscalar_used(4*(i+1)-1 downto 4*i) <= (others => '0');
    end generate INACTIVE_GEN;

-- Pankaj
    INOUT_ACTIVE_GEN : if (i > 7 and i < C_N_INOUT_SCALARS) generate
      constant OSCALAR_DWIDTH : integer := get_int_element(C_OUTPUT_SCALAR_DWIDTH, i);
      constant OSCALAR_LSB    : integer := get_compact_LSB_IO(C_OUTPUT_SCALAR_DWIDTH, i);
      constant OSCALAR_MSB    : integer := get_compact_MSB_IO(C_OUTPUT_SCALAR_DWIDTH, i);

      signal dout_i   : std_logic_vector(OSCALAR_DWIDTH-1 downto 0);
      signal fifo_rst_reg : std_logic;

    begin

  --    fifo_rst <= ap_rst_s_axi_aclk or oscalar_rst(i);
  process(clk, ap_rst_s_axi_aclk)
  begin
    if(ap_rst_s_axi_aclk = '1') then
      fifo_rst_reg <= '1';
    elsif(clk'event and clk = '1') then
      fifo_rst_reg <= oscalar_rst(i);
    end if;
  end process;

      -- We might need to generate one hot for ap_oscalar_vld if there is no full handshake for output scalar vld
      -- accelerator might hold valid high for more than one clock
      -- TBD
      
      -- oscalar_re signals are generated at the begining of the data phase;
      -- not required a write-through fifo.
      FIFO_I : entity axis_accelerator_adapter_v2_1_6.xd_output_scalars_fifo
        generic map (
          C_FAMILY => C_FAMILY,
          C_MTBF_STAGES => C_MTBF_STAGES,
          WIDTH    => OSCALAR_DWIDTH)
        port map (
          din      => ap_oscalar_din(OSCALAR_MSB downto OSCALAR_LSB),
          din_vld  => ap_oscalar_vld(i),
          din_rdy  => ap_oscalar_rdy_i(i),
          wr_clk   => ap_clk,
          dout     => dout_i,
          dout_vld => open,
          dout_rdy => oscalar_re(i),
          rd_used  => status_oscalar_used(4*(i+1)-1 downto 4*i),
          rd_empty => status_oscalar_empty(i),
          rd_full  => status_oscalar_full_i(i),
          rd_clk   => clk,
          rst      => fifo_rst_reg);

      process(dout_i)
      begin
        oscalar_data((i+1)*C_MAX_SCALAR_DWIDTH-1 downto i*C_MAX_SCALAR_DWIDTH)            <= (others => '0');
        oscalar_data(i*C_MAX_SCALAR_DWIDTH+OSCALAR_DWIDTH-1 downto i*C_MAX_SCALAR_DWIDTH) <= dout_i;
      end process;

      
        EN_SYNC_GEN_OSCALAR : if (C_PRMRY_IS_ACLK_ASYNC = 1) generate
   begin
   

    XD_OSCALAR_FULL_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_OSCALARS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => status_oscalar_full_i(i),
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => status_oscalar_full(i),
        scndry_vect_out            => open
        );

    XD_OSCALAR_RDY_SYNC : entity  axis_accelerator_adapter_v2_1_6.cdc_sync
        generic map (
        C_CDC_TYPE                 => 1,
        C_RESET_STATE              => 0,
        C_SINGLE_BIT               => 1,
        C_FLOP_INPUT               => 1,
        C_VECTOR_WIDTH             => C_MAX_N_OSCALARS,
        C_MTBF_STAGES              => 2
        )
        port map (
        prmry_aclk                 => ap_clk,
        prmry_resetn               => '1',
        prmry_in                   => ap_oscalar_rdy_i(i),
        prmry_vect_in              => (others=>'0'),

        scndry_aclk                => clk,
        scndry_resetn              => '1',
        scndry_out                 => ap_oscalar_rdy(i),
        scndry_vect_out            => open
        );

--  process(clk, rst)
--  begin
--   if(clk'event and clk = '1') then
--    if(rst = '1') then
--      status_oscalar_full_i1(i) <= '0';
--      status_oscalar_full(i) <= '0';
--    else
--      status_oscalar_full_i1(i) <=status_oscalar_full_i(i) ;
--      status_oscalar_full(i) <= status_oscalar_full_i1(i);
--    end if;
--   end if;
--  end process;
--
--
--  process(clk, rst)
--  begin
--   if(clk'event and clk = '1') then
--    if(rst = '1') then
--      ap_oscalar_rdy_i1(i) <= '1';
--      ap_oscalar_rdy(i) <= '1';
--    else
--      ap_oscalar_rdy_i1(i) <=ap_oscalar_rdy_i(i) ;
--      ap_oscalar_rdy(i) <= ap_oscalar_rdy_i1(i);
--    end if;
--   end if;
--  end process;



	


   end generate EN_SYNC_GEN_OSCALAR;

       NO_SYNC_GEN_OSCALAR : if (C_PRMRY_IS_ACLK_ASYNC = 0) generate
   begin

      status_oscalar_full(i)                     <= status_oscalar_full_i(i);
      ap_oscalar_rdy(i)                     <= ap_oscalar_rdy_i(i);

   end generate NO_SYNC_GEN_OSCALAR;


    end generate INOUT_ACTIVE_GEN;

    INOUT_INACTIVE_GEN : if(i > C_N_INOUT_SCALARS-1) generate
    begin
      oscalar_data((i+1)*C_MAX_SCALAR_DWIDTH-1 downto i*C_MAX_SCALAR_DWIDTH) <= (others => '0');

      -- A non used scalar is always ready:
      ap_oscalar_rdy(i) <= '1';

      status_oscalar_empty(i)                   <= '0';
      status_oscalar_full(i)                    <= '0';
      status_oscalar_used(4*(i+1)-1 downto 4*i) <= (others => '0');
    end generate INOUT_INACTIVE_GEN;

---


  end generate OUTPUT_SCALARS_GEN;

end rtl;
