-------------------------------------------------------------------------------
-- Title      : Accelerator Adapter
-- Project    :
-------------------------------------------------------------------------------
-- File       : xd_adapter_pkg.vhd
-- Author     : rmg/jn
-- Company    : Xilinx, Inc.
-- Created    : 2012-09-05
-- Last update: 2012-11-05
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
USE IEEE.std_logic_misc.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


package xd_adapter_pkg is
  type int_vector is array (natural range <>) of integer;

  CONSTANT TFF : time := 100 ps;
  constant SW_LENGTH_WIDTH : integer := 16;

  constant AP_ARG_MEM_MAP_TYPE : integer := 0;
  constant AP_ARG_STREAM_TYPE  : integer := 1;

  constant FORMAT_TYPE_NONE               : integer := 0;
  constant FORMAT_TYPE_RESHAPE_BLOCK      : integer := 1;
  constant FORMAT_TYPE_RESHAPE_CYCLIC     : integer := 2;
  constant FORMAT_TYPE_RESHAPE_COMPLETE   : integer := 3;
  constant FORMAT_TYPE_PARTITION_BLOCK    : integer := 4;
  constant FORMAT_TYPE_PARTITION_CYCLIC   : integer := 5;
  constant FORMAT_TYPE_PARTITION_COMPLETE : integer := 6;

  function and_reduce(A : std_logic_vector) return std_logic;
  function or_reduce(A  : std_logic_vector) return std_logic;

  function log2(x         : natural) return integer;
  function max(A          : integer; B : integer) return integer;
  function min_size(A     : integer; B : integer) return integer;
  function div_round_up(t : integer; Tclk : integer) return integer;

  function int2lv (A     : integer; width : integer          := 32) return std_logic_vector;
  function lv2int(A      : std_logic_vector) return integer;
  function int2l (A      : integer) return std_logic;
  function ext_lv (value : std_logic_vector; width : natural := 32) return std_logic_vector;

  function get_int_element(A : std_logic_vector; index : natural) return integer;
  function get_int_vector(A  : std_logic_vector; x : natural; y : natural) return int_vector;

  -- These next two functions are used to calculate the LSB and MSB for
  -- "compacted" buses, e.g., output scalar data bus
  function get_compact_LSB(A : std_logic_vector; index : natural) return integer;
  function get_compact_MSB(A : std_logic_vector; index : natural) return integer;
  function get_compact_LSB_IO(A : std_logic_vector; index : natural) return integer;
  function get_compact_MSB_IO(A : std_logic_vector; index : natural) return integer;

  function calc_fifo_depth(x : integer) return integer;

  function bin2gray(bin      : std_logic_vector) return std_logic_vector;
  function bin2gray(bin      : integer; N : natural) return std_logic_vector;
  function gray2bin(gray     : std_logic_vector) return std_logic_vector;
  function gray_inc(gray     : std_logic_vector; k : integer := 1) return std_logic_vector;
  function calc_gray_width(N : integer) return integer;

     FUNCTION bin2gray_fifo (
      indata : std_logic_vector; 
      length : integer)
    RETURN std_logic_vector;
  
    FUNCTION gray2bin_fifo (
      indata : std_logic_vector; 
      length : integer)
    RETURN std_logic_vector;

        FUNCTION if_then_else (
      condition : integer; 
      true_case : integer; 
      false_case : integer)
    RETURN integer;

    
    FUNCTION if_then_else (
      condition : boolean; 
      true_case : integer; 
      false_case : integer)
    RETURN integer;




end xd_adapter_pkg;


package body xd_adapter_pkg is

  function and_reduce (A : std_logic_vector) return std_logic is
    variable aux : std_logic := '1';
  begin
    for i in A'range loop
      aux := aux and A(i);
    end loop;
    return aux;
  end function and_reduce;

  function or_reduce (A : std_logic_vector) return std_logic is
    variable aux : std_logic := '0';
  begin
    for i in A'range loop
      aux := aux or A(i);
    end loop;
    return aux;
  end function or_reduce;

  function log2(x : natural) return integer is
    variable i : integer := 0;
  begin
    if (x = 0) then
      return 0;
    else
      while (x > (2**i)) loop
        i := i+1;
      end loop;
      return i;
    end if;
  end function log2;

  function max(A : integer; B : integer) return integer is
  begin
    if(A > B) then
      return A;
    else
      return B;
    end if;
  end function max;

  function min_size(A : integer; B : integer) return integer is
  begin
    if(A < B) then
      return A;
    else
      return B;
    end if;
  end function min_size;

  function div_round_up(t : integer; Tclk : integer) return integer is
  begin
    -- integer division give the integer part of the results (no rounding). To
    -- obtain round up (excess), add to dividend, the divisor minus one.
    return (t + Tclk-1) / Tclk;
  end function div_round_up;

  function int2lv (A : integer; width : integer := 32) return std_logic_vector is
    variable value : std_logic_vector(width-1 downto 0);
  begin
    value := std_logic_vector(to_signed(A, width));
    return value;
  end function int2lv;

  function lv2int(A : std_logic_vector) return integer is
    variable value : integer;
  begin
    value := to_integer(signed(A));
    return value;
  end function lv2int;

  function int2l (A : integer) return std_logic is
    variable value : std_logic;
  begin
    if(A = 0) then
      value := '0';
    else
      value := '1';
    end if;
    return value;
  end function int2l;

     ------------------------------------------------------------------------------
    -- This function is used to implement an IF..THEN when such a statement is not
    --  allowed. 
    ------------------------------------------------------------------------------
    FUNCTION if_then_else (
      condition : boolean; 
      true_case : integer; 
      false_case : integer) 
    RETURN integer IS
      VARIABLE retval : integer := 0;
    BEGIN
      IF NOT condition THEN
        retval:=false_case;
      ELSE
        retval:=true_case;
      END IF;
      RETURN retval;
    END if_then_else;


      FUNCTION if_then_else (
      condition : integer; 
      true_case : integer; 
      false_case : integer) 
    RETURN integer IS
      VARIABLE retval : integer := 0;
    BEGIN
      IF condition=0 THEN
        retval:=false_case;
      ELSE
        retval:=true_case;
      END IF;
      RETURN retval;
    END if_then_else;




  function ext_lv (value : std_logic_vector; width : natural := 32)
    return std_logic_vector is
    constant N   : integer := value'length;
    variable ret : std_logic_vector(width-1 downto 0);
  begin
    ret               := (others => '0');
    ret(N-1 downto 0) := value;
    return ret;
  end function ext_lv;

  function get_int_element(A : std_logic_vector; index : natural)
    return integer is
    constant N       : integer := A'length;
    alias A_dw       : std_logic_vector(N-1 downto 0) is A;
    variable element : std_logic_vector(31 downto 0);
  begin
    element := A_dw(32*(index+1)-1 downto 32*index);
    return to_integer(signed(element));
  end function get_int_element;

  function get_int_vector(A : std_logic_vector; x : natural; y : natural)
    return int_vector is
    constant N       : integer := A'length;
    alias A_dw       : std_logic_vector(N-1 downto 0) is A;
    variable element : std_logic_vector(31 downto 0);

    constant first      : integer                           := min_size(x, y);
    constant last       : integer                           := max(x, y);
    constant N_elements : integer                           := last - first + 1;
    variable ret_value  : int_vector(N_elements-1 downto 0) := (others => 0);
  begin
    for i in first to last loop
      ret_value(i-first) := get_int_element(A_dw, i);
    end loop;
    return ret_value;
  end function get_int_vector;

  function get_compact_LSB_IO(A : std_logic_vector; index : natural)
    return integer is
    constant N       : integer := A'length;
    alias A_dw       : std_logic_vector(N-1 downto 0) is A;
    variable element : std_logic_vector(31 downto 0);
    variable acc_1     : integer := 256;
  begin
    for k in 8 to index-1 loop
      element := A_dw(32*(k+1)-1 downto 32*k);
      acc_1     := acc_1 + to_integer(signed(element));
    end loop;
    return acc_1;
  end function get_compact_LSB_IO;
  function get_compact_LSB(A : std_logic_vector; index : natural)
    return integer is
    constant N       : integer := A'length;
    alias A_dw       : std_logic_vector(N-1 downto 0) is A;
    variable element : std_logic_vector(31 downto 0);
    variable acc     : integer := 0;
  begin
    for k in 0 to index-1 loop
      element := A_dw(32*(k+1)-1 downto 32*k);
      acc     := acc + to_integer(signed(element));
    end loop;
    return acc;
  end function get_compact_LSB;

  function get_compact_MSB_IO(A : std_logic_vector; index : natural)
    return integer is
    constant N       : integer := A'length;
    alias A_dw       : std_logic_vector(N-1 downto 0) is A;
    variable element : std_logic_vector(31 downto 0);
    variable acc_1     : integer := 256;
  begin
    for k in 8 to index loop
      element := A_dw(32*(k+1)-1 downto 32*k);
      acc_1     := acc_1 + to_integer(signed(element));
    end loop;
    return acc_1-1;
  end function get_compact_MSB_IO;

  function get_compact_MSB(A : std_logic_vector; index : natural)
    return integer is
    constant N       : integer := A'length;
    alias A_dw       : std_logic_vector(N-1 downto 0) is A;
    variable element : std_logic_vector(31 downto 0);
    variable acc     : integer := 0;
  begin
    for k in 0 to index loop
      element := A_dw(32*(k+1)-1 downto 32*k);
      acc     := acc + to_integer(signed(element));
    end loop;
    return acc-1;
  end function get_compact_MSB;

  ---------------------------------------------------------------------
  -- calculate the power inmediately above or equal to the provided depth and
  -- substract one
  function calc_fifo_depth(x : integer) return integer is
    variable i : integer := 0;
  begin
    if (x = 0) then
      return 0;
    else
      while (x > (2**i)) loop
        i := i+1;
      end loop;
      return (2**i)-1;
    end if;
  end function calc_fifo_depth;

  -- Functions to convert from gray code to bin codes and viceversa
  function bin2gray(bin : std_logic_vector) return std_logic_vector is
    constant N    : integer := (bin'length);
    alias bin_dw  : std_logic_vector(N-1 downto 0) is bin;
    variable gray : std_logic_vector(N-1 downto 0);
  begin
    gray(N-1) := bin_dw(N-1);
    for i in 0 to N-2 loop
      gray(i) := bin_dw(i) xor bin_dw(i+1);
    end loop;
    return gray;
  end function bin2gray;

  function bin2gray(bin : integer; N : natural) return std_logic_vector is
    variable gray : std_logic_vector(N-1 downto 0);
  begin
    gray := bin2gray(std_logic_vector(to_signed(bin, N)));
    return gray;
  end function bin2gray;

  function gray2bin(gray : std_logic_vector) return std_logic_vector is
    constant N    : integer := gray'length;
    alias gray_dw : std_logic_vector(N-1 downto 0) is gray;
    variable bin  : std_logic_vector(N-1 downto 0);
  begin
    bin(N-1) := gray_dw(N-1);
    for i in N-2 downto 0 loop
      bin(i) := bin(i+1) xor gray(i);
    end loop;
    return bin;
  end function gray2bin;

      -----------------------------------------------------------------------------
    -- FUNCTION : bin2gray
    -----------------------------------------------------------------------------
    -- This function receives a binary value, and returns the associated 
    -- graycoded value. 
  
    FUNCTION bin2gray_fifo (
      indata : std_logic_vector; 
      length : integer)
    RETURN std_logic_vector IS
      VARIABLE tmp_value : std_logic_vector(length-1 DOWNTO 0);
    BEGIN
      tmp_value(length-1) := indata(length-1);
  
      gray_loop : FOR I IN length-2 DOWNTO 0 LOOP
        tmp_value(I) := indata(I) XOR indata(I+1);
      END LOOP;
  
      RETURN tmp_value;
    END bin2gray_fifo;
  
    -----------------------------------------------------------------------------
    -- FUNCTION : gray2bin
    -----------------------------------------------------------------------------
    -- This function receives a gray-coded value, and returns the associated 
    -- binary value.
  
    FUNCTION gray2bin_fifo (
      indata : std_logic_vector; 
      length : integer)
    RETURN std_logic_vector IS
      VARIABLE tmp_value : std_logic_vector(length-1 DOWNTO 0);
    BEGIN
      tmp_value(length-1) := indata(length-1);
  
      gray_loop : FOR I IN length-2 DOWNTO 0 LOOP
        tmp_value(I) := XOR_REDUCE(indata(length-1 DOWNTO I));
      END LOOP;
  
      RETURN tmp_value;
    END gray2bin_fifo;


  function gray_inc(gray : std_logic_vector; k : integer := 1) return std_logic_vector is
    constant N   : integer := gray'length;
    variable bin : unsigned(N-1 downto 0);
  begin
    bin := unsigned(gray2bin(gray));
    bin := bin + k;
    return bin2gray(std_logic_vector(bin));
  end function gray_inc;

  function calc_gray_width(N : integer) return integer is
    variable bin_width : integer;
  begin
    bin_width := log2(N);
    -- If number of elements is a power of 2, we need an additinal bit,
    -- otherwise when full condition is asserted both gray pointer would be
    -- equal. this is the same condition that shows-up for the empty condition.
    if(N = 2**bin_width) then
      bin_width := bin_width + 1;
    end if;
    return bin_width;
  end function calc_gray_width;

end xd_adapter_pkg;

