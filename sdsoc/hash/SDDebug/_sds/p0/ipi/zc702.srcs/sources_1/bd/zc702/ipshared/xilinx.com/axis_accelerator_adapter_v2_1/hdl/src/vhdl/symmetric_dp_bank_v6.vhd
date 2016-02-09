-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : symmetric_dp_bank_v6.vhd
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

library unisim;
use unisim.vcomponents.all;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;

entity symmetric_dp_bank_v6 is
  generic (
    C_FAMILY      : string;
    C_BRAM_TYPE   : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    C_BANK_AWIDTH : integer;
    C_BANK_DWIDTH : integer);
  port (
    rst    : in  std_logic;
    clk_a  : in  std_logic;
    ce_a   : in  std_logic;
    we_a   : in  std_logic;
    addr_a : in  std_logic_vector(C_BANK_AWIDTH-1 downto 0);
    din_a  : in  std_logic_vector(C_BANK_DWIDTH-1 downto 0);
    dout_a : out std_logic_vector(C_BANK_DWIDTH-1 downto 0);
    clk_b  : in  std_logic;
    ce_b   : in  std_logic;
    we_b   : in  std_logic;
    addr_b : in  std_logic_vector(C_BANK_AWIDTH-1 downto 0);
    din_b  : in  std_logic_vector(C_BANK_DWIDTH-1 downto 0);
    dout_b : out std_logic_vector(C_BANK_DWIDTH-1 downto 0));
end symmetric_dp_bank_v6;

architecture rtl of symmetric_dp_bank_v6 is
  constant MAX_BRAM_AWIDTH : integer := 15;  -- 32Kx1
  constant MIN_BRAM_AWIDTH : integer := 10;  -- 1Kx32
  constant MAX_BRAM_DWIDTH : integer := 32;  -- 1Kx32
  constant MIN_BRAM_DWIDTH : integer := 1;   -- 32Kx1

  function calc_cfg_bram_dwidth(awidth : natural) return integer is
    variable dwidth : integer;
  begin
    if(awidth > MAX_BRAM_AWIDTH) then
      -- If required address bitwidth is bigger than possible bitwidth, then we
      -- have to increase depth. In this case, the BRAMs are configured x1.
      dwidth := 1;
    else
      -- bitwidth for data bus is calculated using the following expression:
      dwidth := 2**(MAX_BRAM_AWIDTH-awidth);
      -- assuming that we do not go above max possible bitwidth:
      if(dwidth > MAX_BRAM_DWIDTH) then
        dwidth := MAX_BRAM_DWIDTH;
      end if;
    end if;
    return dwidth;
  end function calc_cfg_bram_dwidth;

  function calc_cfg_bram_awidth(bank_awidth : natural) return integer is
    variable awidth : integer;
  begin
    if(bank_awidth > MAX_BRAM_AWIDTH) then
      -- If bitwidth of address for bank is bigger than max possible BRAM
      -- configuration, we should increase depth. in this case, we use max
      -- bitwidth for BRAMs
      awidth := MAX_BRAM_AWIDTH;
    else
      -- otherwise, we use same bitwidth as the bank, given that it's not less
      -- than the BRAM bitwidth
      if(bank_awidth < MIN_BRAM_AWIDTH) then
        awidth := MIN_BRAM_AWIDTH;
      else
        awidth := bank_awidth;
      end if;
    end if;
    return awidth;
  end function calc_cfg_bram_awidth;

  function calc_col_size(bank_awidth : natural) return integer is
    variable col_size : integer;
  begin
    if(bank_awidth > MAX_BRAM_AWIDTH) then
      col_size := 2**(bank_awidth-MAX_BRAM_AWIDTH);
    else
      col_size := 1;
    end if;
    return col_size;
  end function calc_col_size;

  constant BRAM_CFG_AWIDTH : integer := calc_cfg_bram_awidth(C_BANK_AWIDTH);
  constant BRAM_AWIDTH     : integer := min_size(BRAM_CFG_AWIDTH, C_BANK_AWIDTH);
  constant COL_SIZE        : integer := calc_col_size(C_BANK_AWIDTH);

  constant BRAM_CFG_DWIDTH : integer := calc_cfg_bram_dwidth(BRAM_CFG_AWIDTH);
  constant BRAM_DWIDTH     : integer := min_size(BRAM_CFG_DWIDTH, C_BANK_DWIDTH);
  constant ROW_SIZE        : integer := div_round_up(C_BANK_DWIDTH, BRAM_CFG_DWIDTH);

begin

  ONE_COL_GEN : if (COL_SIZE = 1) generate
    signal   bram_addr_a   : std_logic_vector(15 downto 0);
    signal   bram_addr_b   : std_logic_vector(15 downto 0);
    -- address bus for primitive has a width of MAX_BRAM_AWIDTH+1 bits (15),
    -- but when we use configurations with widths bigger than x1, then LSB's
    -- are not used. In this case, the efective LSB is given by BRAM_CFG_DWIDTH
    -- and efective bitwidth is given by the bank C_BANK_AWIDTH
    constant BRAM_ADDR_LSB : integer := log2(BRAM_CFG_DWIDTH);
    constant BRAM_ADDR_MSB : integer := BRAM_ADDR_LSB+C_BANK_AWIDTH-1;

  begin

    process(addr_a)
    begin
      bram_addr_a                                     <= (others => '0');
      bram_addr_a(BRAM_ADDR_MSB downto BRAM_ADDR_LSB) <= addr_a;
    end process;

    process(addr_b)
    begin
      bram_addr_b                                     <= (others => '0');
      bram_addr_b(BRAM_ADDR_MSB downto BRAM_ADDR_LSB) <= addr_b;
    end process;

    MEM_BANK_GEN : for i in 0 to ROW_SIZE-1 generate
      signal bram_din_a  : std_logic_vector(MAX_BRAM_DWIDTH-1 downto 0);
      signal bram_dout_a : std_logic_vector(MAX_BRAM_DWIDTH-1 downto 0);
      signal bram_we_a   : std_logic_vector(3 downto 0);

      signal bram_din_b  : std_logic_vector(MAX_BRAM_DWIDTH-1 downto 0);
      signal bram_dout_b : std_logic_vector(MAX_BRAM_DWIDTH-1 downto 0);
      signal bram_we_b   : std_logic_vector(7 downto 0);

    begin

      -- In the BRAM input port, only BRAM_DWIDTH LS bits are used
      process(din_a)
      begin
        bram_din_a                         <= (others => '0');
        bram_din_a(BRAM_DWIDTH-1 downto 0) <= din_a(BRAM_DWIDTH*(i+1)-1 downto BRAM_DWIDTH*i);
      end process;

      process(din_b)
      begin
        bram_din_b                         <= (others => '0');
        bram_din_b(BRAM_DWIDTH-1 downto 0) <= din_b(BRAM_DWIDTH*(i+1)-1 downto BRAM_DWIDTH*i);
      end process;

      -- same approach is used on output port
      dout_a(BRAM_DWIDTH*(i+1)-1 downto BRAM_DWIDTH*i) <= bram_dout_a(BRAM_DWIDTH-1 downto 0);
      dout_b(BRAM_DWIDTH*(i+1)-1 downto BRAM_DWIDTH*i) <= bram_dout_b(BRAM_DWIDTH-1 downto 0);

      -- we signals are comon; dont support byte-level we signals
      bram_we_a <= (others => we_a);
      bram_we_b <= (others => we_b);

      --------------------------
      -- 7 Series BRAM Primitive
      --------------------------
      BRAM_7_SERIES : if (C_BRAM_TYPE = "7_SERIES") generate
      begin
      BRAM_I : RAMB36E1
        generic map (
          SIM_COLLISION_CHECK       => "ALL",  -- Colision check: Values ("ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE")
          RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",  -- "PERFORMANCE" or "DELAYED_WRITE"
          DOA_REG                   => 0,  -- DOA_REG, DOB_REG: Optional output register (0 or 1)
          DOB_REG                   => 0,
          EN_ECC_READ               => false,  -- Error Correction Circuitry (ECC): Encoder/decoder enable (TRUE/FALSE)
          EN_ECC_WRITE              => false,
          INIT_A                    => x"000000000",  -- INIT_A, INIT_B: Initial values on output ports
          INIT_B                    => x"000000000",
          INIT_FILE                 => "NONE",  -- RAM initialization file
          RAM_EXTENSION_A           => "NONE",  -- RAM_EXTENSION_A, RAM_EXTENSION_B: Selects cascade mode ("UPPER", "LOWER", or "NONE")
          RAM_EXTENSION_B           => "NONE",
          RAM_MODE                  => "TDP",  -- "SDP" or "TDP"
          READ_WIDTH_A              => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- READ_WIDTH_A:  0, 1, 2, 4, 9, 18, 36, 72
          WRITE_WIDTH_A             => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- WRITE_WIDTH_A: 0, 1, 2, 4, 9, 18, 36
          READ_WIDTH_B              => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- READ_WIDTH_B:  0, 1, 2, 4, 9, 18, 36
          WRITE_WIDTH_B             => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- WRITE_WIDTH_B: 0, 1, 2, 4, 9, 18, 36, 72
          RSTREG_PRIORITY_A         => "REGCE",  -- RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG" or "REGCE")
          RSTREG_PRIORITY_B         => "REGCE",
          SRVAL_A                   => x"000000000",  -- SRVAL_A, SRVAL_B: Set/reset value for output
          SRVAL_B                   => x"000000000",
          WRITE_MODE_A              => "READ_FIRST",  -- WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE")
          WRITE_MODE_B              => "READ_FIRST")
        port map (
          -- ECC Signals: 1-bit (each) output Error Correction Circuitry ports
          INJECTDBITERR => '0',  -- 1-bit input Inject a double bit error
          INJECTSBITERR => '0',  -- 1-bit input Inject a single bit error
          DBITERR       => open,  -- 1-bit output double bit error status output
          ECCPARITY     => open,  -- 8-bit output generated error correction parity
          RDADDRECC     => open,        -- 9-bit output ECC read address
          SBITERR       => open,  -- 1-bit output Single bit error status output
          CASCADEINA    => '0',         -- 1-bit input A port cascade input
          CASCADEOUTA   => open,        -- 1-bit output A port cascade output
          DIADI         => bram_din_a,  -- 32-bit input A port data/LSB data input
          DIPADIP       => x"0",  -- 4-bit input A port parity/LSB parity input
          DOADO         => bram_dout_a,  -- 32-bit output A port data/LSB data output
          DOPADOP       => open,  -- 4-bit output A port parity/LSB parity output
          ADDRARDADDR   => bram_addr_a,  -- 16-bit input A port address/Read address input
          CLKARDCLK     => clk_a,  -- 1-bit input A port clock/Read clock input
          ENARDEN       => ce_a,  -- 1-bit input A port enable/Read enable input
          REGCEAREGCE   => '1',  -- 1-bit input A port register enable/Register enable input
          RSTRAMARSTRAM => rst,         -- 1-bit input A port set/reset input
          RSTREGARSTREG => '0',  -- 1-bit input A port register set/reset input
          WEA           => bram_we_a,  -- 4-bit input A port write enable input
          CASCADEINB    => '0',         -- 1-bit input B port cascade input
          CASCADEOUTB   => open,        -- 1-bit output B port cascade output
          DIBDI         => bram_din_b,  -- 32-bit input B port data/MSB data input
          DIPBDIP       => x"0",  -- 4-bit input B port parity/MSB parity input
          DOBDO         => bram_dout_b,  -- 32-bit output B port data/MSB data output
          DOPBDOP       => open,  -- 4-bit output B port parity/MSB parity output
          ADDRBWRADDR   => bram_addr_b,  -- 16-bit input B port address/Write address input
          CLKBWRCLK     => clk_b,  -- 1-bit input B port clock/Write clock input
          ENBWREN       => ce_b,  -- 1-bit input B port enable/Write enable input
          REGCEB        => '1',  -- 1-bit input B port register enable input
          RSTRAMB       => rst,  -- Reset del latch de salida de la memoria (1 bit)
          RSTREGB       => '0',  -- Reset del registro opcional de salida (1 bit)
          --WEBWE         => x"FF");          -- 8-bit input B port write enable/Write enable input
          WEBWE         => bram_we_b);  -- 8-bit input B port write enable/Write enable input
        end generate BRAM_7_SERIES;

      --------------------------
      -- 8 Series BRAM Primitive
      --------------------------
      BRAM_8_SERIES : if (C_BRAM_TYPE = "ULTRASCALE") generate
      begin
 
       BRAM_I: RAMB36E2
         GENERIC MAP (
           CASCADE_ORDER_A      => "NONE",
           CASCADE_ORDER_B      => "NONE",
           CLOCK_DOMAINS        => "INDEPENDENT",
           DOA_REG              => 0, -- DOA_REG, DOB_REG: Optional output register (0 or 1)
           DOB_REG              => 0,
           ENADDRENA            => "FALSE",
           ENADDRENB            => "FALSE",
           EN_ECC_PIPE          => "FALSE",
           EN_ECC_READ          => "FALSE",
           EN_ECC_WRITE         => "FALSE",
           INIT_A               => X"000000000",
           INIT_B               => X"000000000",
           INIT_FILE            => "NONE",   -- RAM initialization file
           RDADDRCHANGEA        => "FALSE",
           RDADDRCHANGEB        => "FALSE",
           READ_WIDTH_A         => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- READ_WIDTH_A:  0, 1, 2, 4, 9, 18, 36, 72,
           READ_WIDTH_B         => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- READ_WIDTH_B:  0, 1, 2, 4, 9, 18, 36,
           RSTREG_PRIORITY_A    => "REGCE",
           RSTREG_PRIORITY_B    => "REGCE",
           SIM_COLLISION_CHECK  => "ALL",
           SLEEP_ASYNC          => "FALSE",
           SRVAL_A              => X"000000000",  -- SRVAL_A, SRVAL_B: Set/reset value for output,
           SRVAL_B              => X"000000000",
           WRITE_MODE_A         => "READ_FIRST",  -- WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"),
           WRITE_MODE_B         => "READ_FIRST",
           WRITE_WIDTH_A        => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- WRITE_WIDTH_A: 0, 1, 2, 4, 9, 18, 36,
           WRITE_WIDTH_B        => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8)  -- WRITE_WIDTH_B: 0, 1, 2, 4, 9, 18, 36, 72
         )
         PORT MAP (
           CASDOUTA         => open,
           CASDOUTB         => open,
           CASDOUTPA        => open,
           CASDOUTPB        => open,
           CASOUTDBITERR    => open, 
           CASOUTSBITERR    => open, 
           DBITERR          => open,
           DOUTADOUT        => bram_dout_a,  -- 32-bit output A port data/LSB data output
           DOUTBDOUT        => bram_dout_b,  -- 32-bit output B port data/MSB data output
           DOUTPADOUTP      => open,
           DOUTPBDOUTP      => open,
           ECCPARITY        => open,
           RDADDRECC        => open,
           SBITERR          => open,
           ADDRARDADDR      => bram_addr_a(14 downto 0), -- 16-bit input A port address/Read address input
           ADDRBWRADDR      => bram_addr_b(14 downto 0),  -- 16-bit input B port address/Write address input
           ADDRENA          => '0',
           ADDRENB          => '0',
           CASDIMUXA        => '0',
           CASDIMUXB        => '0',
           CASDOMUXEN_A     => '0',
           CASDOMUXEN_B     => '0',
           CASOREGIMUXEN_A  => '0',
           CASOREGIMUXEN_B  => '0',
           CASDINA          => (OTHERS => '0'),
           CASDINB          => (OTHERS => '0'),
           CASDINPA         => (OTHERS => '0'),
           CASDINPB         => (OTHERS => '0'),
           CASDOMUXA        => '0',
           CASDOMUXB        => '0',
           CASINDBITERR     => '0',
           CASINSBITERR     => '0',
           CASOREGIMUXA     => '0',
           CASOREGIMUXB     => '0',
           CLKARDCLK        => clk_a,
           CLKBWRCLK        => clk_b,
           DINADIN          => bram_din_a,  -- 32-bit input A port data/LSB data input
           DINBDIN          => bram_din_b,  -- 32-bit input B port data/MSB data input
           DINPADINP        => x"0",  -- 4-bit input A port parity/LSB parity input,
           DINPBDINP        => x"0",  -- 4-bit input B port parity/MSB parity input
           ECCPIPECE        => '0',
           ENARDEN          => ce_a,  -- 1-bit input A port enable/Read enable input
           ENBWREN          => ce_b,  -- 1-bit input B port enable/Write enable input
           INJECTDBITERR    => '0',
           INJECTSBITERR    => '0',
           REGCEAREGCE      => '1',
           REGCEB           => '1',
           RSTRAMARSTRAM    => rst,
           RSTRAMB          => rst,
           RSTREGARSTREG    => '0',
           RSTREGB          => '0',
           SLEEP            => '0', 
           WEA              => bram_we_a,  -- 4-bit input A port write enable input
           WEBWE            => bram_we_b  -- 8-bit input B port write enable/Write enable input
         );
        end generate BRAM_8_SERIES;

 
 
  end generate MEM_BANK_GEN;

  end generate ONE_COL_GEN;

  DEPTH_EXPANSION_GEN : if (COL_SIZE > 1) generate
    constant BRAM_ADDR_LSB : integer := log2(BRAM_CFG_DWIDTH);
    constant BRAM_ADDR_MSB : integer := BRAM_ADDR_LSB+C_BANK_AWIDTH-1;
    constant WORD_AWIDTH   : integer := log2(COL_SIZE);
    constant ADDR_LSB      : integer := 0;
    constant ADDR_MSB      : integer := MAX_BRAM_AWIDTH-1;
    constant BRAM_SEL_LSB  : integer := ADDR_MSB+1;
    constant BRAM_SEL_MSB  : integer := C_BANK_AWIDTH-1;

    signal bram_addr_a     : std_logic_vector(15 downto 0);
    signal bram_addr_b     : std_logic_vector(15 downto 0);
    signal bram_ce_a       : std_logic_vector(COL_SIZE-1 downto 0);
    signal bram_ce_b       : std_logic_vector(COL_SIZE-1 downto 0);
    signal bram_sel_addr_a : std_logic_vector(WORD_AWIDTH-1 downto 0);
    signal bram_sel_addr_b : std_logic_vector(WORD_AWIDTH-1 downto 0);

  begin

    -- we use WORD_AWIDTH MS bits to select the BRAM inside a column
    process(addr_a, ce_a)
    begin
      bram_ce_a <= (others => '0');
      if (ce_a = '1') then
        for i in 0 to COL_SIZE-1 loop
          if (unsigned(addr_a(BRAM_SEL_MSB downto BRAM_SEL_LSB)) = i) then
            bram_ce_a(i) <= '1';
          end if;
        end loop;
      end if;
    end process;

    process(addr_b, ce_b)
    begin
      bram_ce_b <= (others => '0');
      if (ce_b = '1') then
        for i in 0 to COL_SIZE-1 loop
          if (unsigned(addr_b(BRAM_SEL_MSB downto BRAM_SEL_LSB)) = i) then
            bram_ce_b(i) <= '1';
          end if;
        end loop;
      end if;
    end process;

    -- This set of bits have to be registered to generate the selection signal
    -- on the mux's in the output datapath
    process(clk_a)
    begin
      if (clk_a'event and clk_a = '1') then
        if (ce_a = '1') then
          bram_sel_addr_a <= addr_a(BRAM_SEL_MSB downto BRAM_SEL_LSB);
        end if;
      end if;
    end process;

    process(clk_b)
    begin
      if (clk_b'event and clk_b = '1') then
        if (ce_b = '1') then
          bram_sel_addr_b <= addr_b(BRAM_SEL_MSB downto BRAM_SEL_LSB);
        end if;
      end if;
    end process;

    -- In this case, given that it is a depth increase, we use all width for
    -- address bus on BRAMs

    process(addr_a)
    begin
      bram_addr_a                             <= (others => '0');
      bram_addr_a(MAX_BRAM_AWIDTH-1 downto 0) <= addr_a(MAX_BRAM_AWIDTH-1 downto 0);
    end process;

    process(addr_b)
    begin
      bram_addr_b                             <= (others => '0');
      bram_addr_b(MAX_BRAM_AWIDTH-1 downto 0) <= addr_b(MAX_BRAM_AWIDTH-1 downto 0);
    end process;

    MEM_BANK_GEN : for i in 0 to ROW_SIZE-1 generate
      signal bram_din_a : std_logic_vector(MAX_BRAM_DWIDTH-1 downto 0);
      signal bram_we_a  : std_logic_vector(3 downto 0);
      signal bram_din_b : std_logic_vector(MAX_BRAM_DWIDTH-1 downto 0);
      signal bram_we_b  : std_logic_vector(7 downto 0);
      -- These "superbusses" represent all data busses at the output of all
      -- BRAM's in the same column. In reality, BRAM_DWIDTH is always 1.
      signal col_dout_a : std_logic_vector(COL_SIZE*BRAM_DWIDTH-1 downto 0);
      signal col_dout_b : std_logic_vector(COL_SIZE*BRAM_DWIDTH-1 downto 0);

    begin

      -- In each BRAM column, the input data is applied in parallel to all
      -- BRAMs. we only use BRAM_DWIDTH LS bits:
      process(din_a)
      begin
        bram_din_a                         <= (others => '0');
        bram_din_a(BRAM_DWIDTH-1 downto 0) <= din_a(BRAM_DWIDTH*(i+1)-1 downto BRAM_DWIDTH*i);
      end process;

      process(din_b)
      begin
        bram_din_b                         <= (others => '0');
        bram_din_b(BRAM_DWIDTH-1 downto 0) <= din_b(BRAM_DWIDTH*(i+1)-1 downto BRAM_DWIDTH*i);
      end process;

      -- mux's on output busses on the same column
      process(col_dout_a, bram_sel_addr_a)
        variable mux_dout : std_logic_vector(BRAM_DWIDTH-1 downto 0);
      begin
        mux_dout := (others => '0');
        for k in 0 to COL_SIZE-1 loop
          if (unsigned(bram_sel_addr_a) = k) then
            mux_dout := col_dout_a(BRAM_DWIDTH*(k+1)-1 downto BRAM_DWIDTH*k);
          end if;
        end loop;
        dout_a(BRAM_DWIDTH*(i+1)-1 downto BRAM_DWIDTH*i) <= mux_dout;
      end process;

      process(col_dout_b, bram_sel_addr_b)
        variable mux_dout : std_logic_vector(BRAM_DWIDTH-1 downto 0);
      begin
        mux_dout := (others => '0');
        for k in 0 to COL_SIZE-1 loop
          if (unsigned(bram_sel_addr_b) = k) then
            mux_dout := col_dout_b(BRAM_DWIDTH*(k+1)-1 downto BRAM_DWIDTH*k);
          end if;
        end loop;
        dout_b(BRAM_DWIDTH*(i+1)-1 downto BRAM_DWIDTH*i) <= mux_dout;
      end process;

      -- not supported byte-level we signals. All bystes written at the same time.
      bram_we_a <= (others => we_a);
      bram_we_b <= (others => we_b);

      BRAM_COL_GEN : for k in 0 to COL_SIZE-1 generate
        signal bram_dout_a : std_logic_vector(MAX_BRAM_DWIDTH-1 downto 0);
        signal bram_dout_b : std_logic_vector(MAX_BRAM_DWIDTH-1 downto 0);
      begin

        -- this superbus groups all datapath at memory outputs
        col_dout_a(BRAM_DWIDTH*(k+1)-1 downto BRAM_DWIDTH*k) <= bram_dout_a(BRAM_DWIDTH-1 downto 0);
        col_dout_b(BRAM_DWIDTH*(k+1)-1 downto BRAM_DWIDTH*k) <= bram_dout_b(BRAM_DWIDTH-1 downto 0);

      --------------------------
      -- 7 Series BRAM Primitive
      --------------------------
      BRAM_7_SERIES : if (C_BRAM_TYPE = "7_SERIES") generate
      begin

        BRAM_I : RAMB36E1
          generic map (
            SIM_COLLISION_CHECK       => "ALL",  -- Colision check: Values ("ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE")
            RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",  -- "PERFORMANCE" or "DELAYED_WRITE"
            DOA_REG                   => 0,  -- DOA_REG, DOB_REG: Optional output register (0 or 1)
            DOB_REG                   => 0,
            EN_ECC_READ               => false,  -- Error Correction Circuitry (ECC): Encoder/decoder enable (TRUE/FALSE)
            EN_ECC_WRITE              => false,
            INIT_A                    => x"000000000",  -- INIT_A, INIT_B: Initial values on output ports
            INIT_B                    => x"000000000",
            INIT_FILE                 => "NONE",  -- RAM initialization file
            RAM_EXTENSION_A           => "NONE",  -- RAM_EXTENSION_A, RAM_EXTENSION_B: Selects cascade mode ("UPPER", "LOWER", or "NONE")
            RAM_EXTENSION_B           => "NONE",
            RAM_MODE                  => "TDP",  -- "SDP" or "TDP"
            READ_WIDTH_A              => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- READ_WIDTH_A:  0, 1, 2, 4, 9, 18, 36, 72
            WRITE_WIDTH_A             => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- WRITE_WIDTH_A: 0, 1, 2, 4, 9, 18, 36
            READ_WIDTH_B              => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- READ_WIDTH_B:  0, 1, 2, 4, 9, 18, 36
            WRITE_WIDTH_B             => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- WRITE_WIDTH_B: 0, 1, 2, 4, 9, 18, 36, 72
            RSTREG_PRIORITY_A         => "REGCE",  -- RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG" or "REGCE")
            RSTREG_PRIORITY_B         => "REGCE",
            SRVAL_A                   => x"000000000",  -- SRVAL_A, SRVAL_B: Set/reset value for output
            SRVAL_B                   => x"000000000",
            WRITE_MODE_A              => "READ_FIRST",  -- WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE")
            WRITE_MODE_B              => "READ_FIRST")
          port map (
            -- ECC Signals: 1-bit (each) output Error Correction Circuitry ports
            INJECTDBITERR => '0',  -- 1-bit input Inject a double bit error
            INJECTSBITERR => '0',  -- 1-bit input Inject a single bit error
            DBITERR       => open,  -- 1-bit output double bit error status output
            ECCPARITY     => open,  -- 8-bit output generated error correction parity
            RDADDRECC     => open,      -- 9-bit output ECC read address
            SBITERR       => open,  -- 1-bit output Single bit error status output
            CASCADEINA    => '0',       -- 1-bit input A port cascade input
            CASCADEOUTA   => open,      -- 1-bit output A port cascade output
            DIADI         => bram_din_a,  -- 32-bit input A port data/LSB data input
            DIPADIP       => x"0",  -- 4-bit input A port parity/LSB parity input
            DOADO         => bram_dout_a,  -- 32-bit output A port data/LSB data output
            DOPADOP       => open,  -- 4-bit output A port parity/LSB parity output
            ADDRARDADDR   => bram_addr_a,  -- 16-bit input A port address/Read address input
            CLKARDCLK     => clk_a,  -- 1-bit input A port clock/Read clock input
            ENARDEN       => bram_ce_a(k),  -- 1-bit input A port enable/Read enable input
            REGCEAREGCE   => '1',  -- 1-bit input A port register enable/Register enable input
            RSTRAMARSTRAM => rst,       -- 1-bit input A port set/reset input
            RSTREGARSTREG => '0',  -- 1-bit input A port register set/reset input
            WEA           => bram_we_a,  -- 4-bit input A port write enable input
            CASCADEINB    => '0',       -- 1-bit input B port cascade input
            CASCADEOUTB   => open,      -- 1-bit output B port cascade output
            DIBDI         => bram_din_b,  -- 32-bit input B port data/MSB data input
            DIPBDIP       => x"0",  -- 4-bit input B port parity/MSB parity input
            DOBDO         => bram_dout_b,  -- 32-bit output B port data/MSB data output
            DOPBDOP       => open,  -- 4-bit output B port parity/MSB parity output
            ADDRBWRADDR   => bram_addr_b,  -- 16-bit input B port address/Write address input
            CLKBWRCLK     => clk_b,  -- 1-bit input B port clock/Write clock input
            ENBWREN       => bram_ce_b(k),  -- 1-bit input B port enable/Write enable input
            REGCEB        => '1',  -- 1-bit input B port register enable input
            RSTRAMB       => rst,  -- Reset del latch de salida de la memoria (1 bit)
            RSTREGB       => '0',  -- Reset del registro opcional de salida (1 bit)
            WEBWE         => bram_we_b);  -- 8-bit input B port write enable/Write enable input
        end generate BRAM_7_SERIES;


      --------------------------
      -- 8 Series BRAM Primitive
      --------------------------
      BRAM_8_SERIES : if (C_BRAM_TYPE = "ULTRASCALE") generate
      begin

      BRAM_I: RAMB36E2
        GENERIC MAP (
          CASCADE_ORDER_A => "NONE",
          CASCADE_ORDER_B => "NONE",
          CLOCK_DOMAINS   => "INDEPENDENT",
          DOA_REG      => 0, -- DOA_REG, DOB_REG: Optional output register (0 or 1)
          DOB_REG      => 0,
          ENADDRENA    => "FALSE",
          ENADDRENB    => "FALSE",
          EN_ECC_PIPE  => "FALSE",
          EN_ECC_READ  => "FALSE",
          EN_ECC_WRITE => "FALSE",
          INIT_A       => X"000000000",
          INIT_B       => X"000000000",
          INIT_FILE    => "NONE",   -- RAM initialization file
          RDADDRCHANGEA => "FALSE",
          RDADDRCHANGEB => "FALSE",
          READ_WIDTH_A => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- READ_WIDTH_A:  0, 1, 2, 4, 9, 18, 36, 72,
          READ_WIDTH_B => BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- READ_WIDTH_B:  0, 1, 2, 4, 9, 18, 36,
          RSTREG_PRIORITY_A   => "REGCE",
          RSTREG_PRIORITY_B   => "REGCE",
          SIM_COLLISION_CHECK => "ALL",
          SLEEP_ASYNC => "FALSE",
          SRVAL_A      => X"000000000",  -- SRVAL_A, SRVAL_B: Set/reset value for output,
          SRVAL_B      => X"000000000",
          WRITE_MODE_A => "READ_FIRST",  -- WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"),
          WRITE_MODE_B => "READ_FIRST",
          WRITE_WIDTH_A=> BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8),  -- WRITE_WIDTH_A: 0, 1, 2, 4, 9, 18, 36,
          WRITE_WIDTH_B=> BRAM_CFG_DWIDTH+(BRAM_CFG_DWIDTH/8)  -- WRITE_WIDTH_B: 0, 1, 2, 4, 9, 18, 36, 72
        )
        PORT MAP (
          CASDOUTA  => open,
          CASDOUTB  => open,
          CASDOUTPA  => open,
          CASDOUTPB  => open,
          CASOUTDBITERR  => open, 
          CASOUTSBITERR  => open, 
          DBITERR      => open,
          DOUTADOUT        => bram_dout_a,  -- 32-bit output A port data/LSB data output
          DOUTBDOUT        => bram_dout_b,  -- 32-bit output B port data/MSB data output
          DOUTPADOUTP      => open,
          DOUTPBDOUTP      => open,
          ECCPARITY    => open,
          RDADDRECC    => open,
          SBITERR      => open,
          ADDRARDADDR  => bram_addr_a(14 downto 0), -- 16-bit input A port address/Read address input
          ADDRBWRADDR  => bram_addr_b(14 downto 0),  -- 16-bit input B port address/Write address input
          ADDRENA => '0',
          ADDRENB => '0',
          CASDIMUXA => '0',
          CASDIMUXB => '0',
          CASDOMUXEN_A => '0',
          CASDOMUXEN_B => '0',
          CASOREGIMUXEN_A => '0',
          CASOREGIMUXEN_B => '0',
          CASDINA   => (OTHERS => '0'),
          CASDINB   => (OTHERS => '0'),
          CASDINPA   => (OTHERS => '0'),
          CASDINPB   => (OTHERS => '0'),
          CASDOMUXA   => '0',
          CASDOMUXB   => '0',
          CASINDBITERR => '0',
          CASINSBITERR => '0',
          CASOREGIMUXA => '0',
          CASOREGIMUXB => '0',
          CLKARDCLK    => clk_a,
          CLKBWRCLK    => clk_b,
          DINADIN        => bram_din_a,  -- 32-bit input A port data/LSB data input
          DINBDIN        => bram_din_b,  -- 32-bit input B port data/MSB data input
          DINPADINP      => x"0",  -- 4-bit input A port parity/LSB parity input,
          DINPBDINP      => x"0",  -- 4-bit input B port parity/MSB parity input
          ECCPIPECE    => '0',
          ENARDEN      => bram_ce_a(k),  -- 1-bit input A port enable/Read enable input
          ENBWREN      => bram_ce_b(k),  -- 1-bit input B port enable/Write enable input
          INJECTDBITERR=> '0',
          INJECTSBITERR=> '0',
          REGCEAREGCE  => '1',
          REGCEB       => '1',
          RSTRAMARSTRAM=> rst,
          RSTRAMB      => rst,
          RSTREGARSTREG=> '0',
          RSTREGB      => '0',
          SLEEP        => '0', 
          WEA          => bram_we_a,  -- 4-bit input A port write enable input
          WEBWE        => bram_we_b  -- 8-bit input B port write enable/Write enable input
        );
        end generate BRAM_8_SERIES;


      end generate BRAM_COL_GEN;

    end generate MEM_BANK_GEN;

  end generate DEPTH_EXPANSION_GEN;

end rtl;

