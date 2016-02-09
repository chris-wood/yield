-------------------------------------------------------------------------------
-- $Id: synchronizer_ff.vhd,v 1.1 2011/06/02 09:44:03 robertb Exp $ 
-- Title      : Binary Counter Module for Write Logic
-- Project    : FIFO Generator
-------------------------------------------------------------------------------
-- (c) Copyright 2006 - 2009 Xilinx, Inc. All rights reserved.
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
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- File       : synchronizer_ff.vhd
-- Author     : Xilinx
-------------------------------------------------------------------------------
-- Structure:
--  synchronizer_ff.vhd
--
-------------------------------------------------------------------------------
-- Description:
-- A basic Flip Flop with asynchronous reset
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

library axis_accelerator_adapter_v2_1_6;
use axis_accelerator_adapter_v2_1_6.xd_adapter_pkg.all;

ENTITY synchronizer_ff IS
  GENERIC (
    C_HAS_RST : integer := 0;
    C_WIDTH   : integer := 0
  	);
  PORT ( 
    RST       : IN  std_logic := '0' ;
    CLK       : IN  std_logic := '0' ;
    D         : IN  std_logic_vector(C_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    Q         : OUT std_logic_vector(C_WIDTH-1 DOWNTO 0) := (OTHERS => '0')
    );
END synchronizer_ff;

ARCHITECTURE xilinx OF synchronizer_ff IS

  ATTRIBUTE DowngradeIPIdentifiedWarnings: STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF xilinx : ARCHITECTURE IS "yes";

  signal Q_reg : std_logic_vector(C_WIDTH-1 downto 0) := (OTHERS => '0');
  ATTRIBUTE async_reg           : STRING;
  ATTRIBUTE async_reg OF Q_reg  : SIGNAL IS "true";
  ATTRIBUTE msgon                        : STRING;
  ATTRIBUTE msgon OF Q_reg    : SIGNAL IS "true";
 
--  attribute dont_touch : string;
--  attribute dont_touch of Q_reg  : signal is "true";
--  ATTRIBUTE KEEP_HIERARCHY : STRING;
--  ATTRIBUTE KEEP_HIERARCHY of xilinx : ARCHITECTURE IS "yes";
BEGIN
  PROCESS (CLK, RST)
  BEGIN  
    IF (RST = '1' AND C_HAS_RST = 1) THEN
      Q_reg <= (OTHERS => '0');
--      Q <= (OTHERS => '0');
    ELSIF CLK'EVENT AND CLK = '1' THEN  
      Q_reg <= D AFTER TFF;
--      Q <= D AFTER TFF;
    END IF;
  END PROCESS;
  Q <= Q_reg;
END xilinx;
