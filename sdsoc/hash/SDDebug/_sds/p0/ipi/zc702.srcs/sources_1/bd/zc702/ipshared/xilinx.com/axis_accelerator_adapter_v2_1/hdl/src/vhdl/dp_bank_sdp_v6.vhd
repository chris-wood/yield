-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dp_bank_sdp_v6.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2012-11-04
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- (c) Copyright 2013 Xilinx, Inc. All rights reserved.
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2012-09-05  1.0      rmg/jn  Created
-- 2013-08-25  2.0      pvk     Updated BRAM data input pin correctly when standard SDP mode is used. 
--                              Lower bits mapped to DIBDI in standard SDP. In Extra wide SDP 
--                              configuration, higher 32 bit mapped to DIBDI.
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

entity dp_bank_sdp_v6 is
  generic (
    C_FAMILY    : string;
    C_BRAM_TYPE : string := "7_SERIES";  -- 7_SERIES = RAMB36E1. ULTRASCALE = RAMB36E2
    C_SDP_WIDE  : integer;  
    C_RD_AWIDTH : integer;
    C_RD_DWIDTH : integer;
    C_WR_AWIDTH : integer;
    C_WR_DWIDTH : integer);
  port (
    rst     : in  std_logic;
    wr_clk  : in  std_logic;
    wr_en   : in  std_logic;
    wr_addr : in  std_logic_vector(C_WR_AWIDTH-1 downto 0);
    din     : in  std_logic_vector(C_WR_DWIDTH-1 downto 0);
    rd_clk  : in  std_logic;
    rd_en   : in  std_logic;
    rd_addr : in  std_logic_vector(C_RD_AWIDTH-1 downto 0);
    dout    : out std_logic_vector(C_RD_DWIDTH-1 downto 0));
end dp_bank_sdp_v6;

architecture rtl of dp_bank_sdp_v6 is

  signal bram_din     : std_logic_vector(63 downto 0);
  signal bram_dout    : std_logic_vector(63 downto 0);
  signal bram_wr_addr : std_logic_vector(15 downto 0);
  signal bram_rd_addr : std_logic_vector(15 downto 0);
  signal bram_we      : std_logic_vector(7 downto 0);

  constant USE_RAMB36E1 : boolean  := ((C_WR_DWIDTH = 64 and C_RD_DWIDTH <= 64) or
                                      (C_RD_DWIDTH = 64 and C_WR_DWIDTH <= 64));

  constant USE_RAMB18E1 : boolean  := ((C_WR_DWIDTH = 32 and C_RD_DWIDTH <= 32) or
                                      (C_RD_DWIDTH = 32 and C_WR_DWIDTH <= 32));

begin

  PORT_64_GEN : if USE_RAMB36E1 generate
  begin

    process(wr_addr)
      constant ADDR_LSB : integer := log2(C_WR_DWIDTH);
      constant ADDR_MSB : integer := ADDR_LSB+C_WR_AWIDTH-1;
    begin
      bram_wr_addr                           <= (others => '0');
      bram_wr_addr(ADDR_MSB downto ADDR_LSB) <= wr_addr;
    end process;

    process(rd_addr)
      constant ADDR_LSB : integer := log2(C_RD_DWIDTH);
      constant ADDR_MSB : integer := ADDR_LSB+C_RD_AWIDTH-1;
    begin
      bram_rd_addr                           <= (others => '0');
      bram_rd_addr(ADDR_MSB downto ADDR_LSB) <= rd_addr;
    end process;


        SDP_EXTRA_WIDE_GEN : if C_SDP_WIDE = 1 generate
        begin

          bram_din(C_WR_DWIDTH-1 downto 0) <= din;
          bram_din(63 downto C_WR_DWIDTH)  <= (others => '0');
        end generate SDP_EXTRA_WIDE_GEN;


        SDP_STD_GEN : if C_SDP_WIDE = 0 generate
        begin

          bram_din(32+C_WR_DWIDTH-1 downto 32) <= din;
          bram_din(C_WR_DWIDTH-1 downto 0)     <= din;
          bram_din(31 downto C_WR_DWIDTH)      <= (others => '0');
          bram_din(63 downto 32+C_WR_DWIDTH)   <= (others => '0');
          
        end generate SDP_STD_GEN;

 --   process(din)
 --   begin
 --     bram_din                         <= (others => '0');
 --     bram_din(C_WR_DWIDTH-1 downto 0) <= din;
 --   end process;

    dout <= bram_dout(C_RD_DWIDTH-1 downto 0);

    -- Port A: read
    -- Port B: write

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
        RAM_MODE                  => "SDP",  -- "SDP" or "TDP" 
        READ_WIDTH_A              => C_RD_DWIDTH+(C_RD_DWIDTH/8),  -- READ_WIDTH_A:  0, 1, 2, 4, 9, 18, 36, 72
        WRITE_WIDTH_A             => 0,  -- WRITE_WIDTH_A: 0, 1, 2, 4, 9, 18, 36
        READ_WIDTH_B              => 0,  -- READ_WIDTH_B:  0, 1, 2, 4, 9, 18, 36
        WRITE_WIDTH_B             => C_WR_DWIDTH+(C_WR_DWIDTH/8),  -- WRITE_WIDTH_B: 0, 1, 2, 4, 9, 18, 36, 72
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
        RDADDRECC     => open,          -- 9-bit output ECC read address
        SBITERR       => open,  -- 1-bit output Single bit error status output
        CASCADEINA    => '0',           -- 1-bit input A port cascade input
        CASCADEOUTA   => open,          -- 1-bit output A port cascade output
        DIADI         => bram_din(31 downto 0),  -- 32-bit input A port data/LSB data input
        DIPADIP       => x"0",  -- 4-bit input A port parity/LSB parity input
        DOADO         => bram_dout(31 downto 0),  -- 32-bit output A port data/LSB data output
        DOPADOP       => open,  -- 4-bit output A port parity/LSB parity output
        ADDRARDADDR   => bram_rd_addr,  -- 16-bit input A port address/Read address input
        CLKARDCLK     => rd_clk,  -- 1-bit input A port clock/Read clock input
        ENARDEN       => rd_en,  -- 1-bit input A port enable/Read enable input
        REGCEAREGCE   => '1',  -- 1-bit input A port register enable/Register enable input
        RSTRAMARSTRAM => rst,           -- 1-bit input A port set/reset input
        RSTREGARSTREG => '0',  -- 1-bit input A port register set/reset input
        WEA           => x"0",  -- 4-bit input A port write enable input
        CASCADEINB    => '0',           -- 1-bit input B port cascade input
        CASCADEOUTB   => open,          -- 1-bit output B port cascade output
        DIBDI         => bram_din(63 downto 32),  -- 32-bit input B port data/MSB data input
        DIPBDIP       => x"0",  -- 4-bit input B port parity/MSB parity input
        DOBDO         => bram_dout(63 downto 32),  -- 32-bit output B port data/MSB data output
        DOPBDOP       => open,  -- 4-bit output B port parity/MSB parity output
        ADDRBWRADDR   => bram_wr_addr,  -- 16-bit input B port address/Write address input
        CLKBWRCLK     => wr_clk,  -- 1-bit input B port clock/Write clock input
        ENBWREN       => wr_en,  -- 1-bit input B port enable/Write enable input
        REGCEB        => '1',  -- 1-bit input B port register enable input
        RSTRAMB       => rst,  -- Reset del latch de salida de la memoria (1 bit)
        RSTREGB       => '0',  -- Reset del registro opcional de salida (1 bit)
        WEBWE         => x"FF");  -- 8-bit input B port write enable/Write enable input

      end generate BRAM_7_SERIES;


      --------------------------
      -- 8 Series BRAM Primitive
      --------------------------
      BRAM_8_SERIES : if (C_BRAM_TYPE = "ULTRASCALE") generate
      begin

       BRAM_I: RAMB36E2
         GENERIC MAP (
           SIM_COLLISION_CHECK => "ALL",
           CASCADE_ORDER_A     => "NONE",
           CASCADE_ORDER_B     => "NONE",
           CLOCK_DOMAINS       => "INDEPENDENT",
           DOA_REG             => 0, -- DOA_REG, DOB_REG: Optional output register (0 or 1)
           DOB_REG             => 0,
           ENADDRENA           => "FALSE",
           ENADDRENB           => "FALSE",
           EN_ECC_PIPE         => "FALSE",
           EN_ECC_READ         => "FALSE",
           EN_ECC_WRITE        => "FALSE",
           INIT_A              => X"000000000",
           INIT_B              => X"000000000",
           INIT_FILE           => "NONE",   -- RAM initialization file
           RDADDRCHANGEA       => "FALSE",
           RDADDRCHANGEB       => "FALSE",
           READ_WIDTH_A        => C_RD_DWIDTH+(C_RD_DWIDTH/8),  -- READ_WIDTH_A:  0, 1, 2, 4, 9, 18, 36, 72
           WRITE_WIDTH_A       => 0,  -- WRITE_WIDTH_A: 0, 1, 2, 4, 9, 18, 36,
           READ_WIDTH_B        => 0,  -- READ_WIDTH_B:  0, 1, 2, 4, 9, 18, 36,
           WRITE_WIDTH_B       => C_WR_DWIDTH+(C_WR_DWIDTH/8),  -- WRITE_WIDTH_B: 0, 1, 2, 4, 9, 18, 36, 72
           RSTREG_PRIORITY_A   => "REGCE",
           RSTREG_PRIORITY_B   => "REGCE",
           SLEEP_ASYNC         => "FALSE",
           SRVAL_A             => X"000000000",  -- SRVAL_A, SRVAL_B: Set/reset value for output,
           SRVAL_B             => X"000000000",
           WRITE_MODE_A        => "READ_FIRST",  -- WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE"),
           WRITE_MODE_B        => "READ_FIRST"
         )
         PORT MAP (
           INJECTDBITERR    => '0',
           INJECTSBITERR    => '0',
           DBITERR          => open,
           ECCPARITY        => open,
           RDADDRECC        => open,
           SBITERR          => open,
           CASDOUTA         => open,
           CASDOUTB         => open,
           CASDOUTPA        => open,
           CASDOUTPB        => open,
           CASOUTDBITERR    => open, 
           CASOUTSBITERR    => open, 
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
 
           DINADIN          => bram_din(31 downto 0),  -- 32-bit input A port data/LSB data input
           DINPADINP        => x"0",  -- 4-bit input A port parity/LSB parity input,
           DOUTADOUT        => bram_dout(31 downto 0),  -- 32-bit output A port data/LSB data output
           DOUTPADOUTP      => open,
    
           ADDRARDADDR      => bram_rd_addr(14 downto 0), -- 16-bit input A port address/Read address input
           CLKARDCLK        => rd_clk,
           ENARDEN          => rd_en,  -- 1-bit input A port enable/Read enable input
           ADDRENA          => '0',
           REGCEAREGCE      => '1',
           RSTRAMARSTRAM    => rst,
           RSTREGARSTREG    => '0',
           WEA              => x"0",  -- 4-bit input A port write enable input

           DINBDIN          => bram_din(63 downto 32),  -- 32-bit input B port data/MSB data input
           DINPBDINP        => x"0",  -- 4-bit input B port parity/MSB parity input
           DOUTBDOUT        => bram_dout(63 downto 32),  -- 32-bit output B port data/MSB data output
           DOUTPBDOUTP      => open,

           ADDRBWRADDR      => bram_wr_addr(14 downto 0),  -- 16-bit input B port address/Write address input
           CLKBWRCLK        => wr_clk,
           ENBWREN          => wr_en,  -- 1-bit input B port enable/Write enable input
           ADDRENB          => '0',
           ECCPIPECE        => '0',
           REGCEB           => '1',
           RSTRAMB          => rst,
           RSTREGB          => '0',
           SLEEP            => '0', 
           WEBWE            => x"FF"  -- 8-bit input B port write enable/Write enable input
         );

      end generate BRAM_8_SERIES;

  end generate PORT_64_GEN;

end rtl;

