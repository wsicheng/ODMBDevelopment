
--------------------------------------------------------------------------------
--
-- FIFO Generator Core - core top file for implementation
--
--------------------------------------------------------------------------------
--
-- (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
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
--------------------------------------------------------------------------------
--
-- Filename: datafifo_dcfeb_top.vhd
--
-- Description:
--   This is the FIFO core wrapper with BUFG instances for clock connections.
--
--------------------------------------------------------------------------------
-- Library Declarations
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


--------------------------------------------------------------------------------
-- Entity Declaration
--------------------------------------------------------------------------------
entity datafifo_dcfeb_top is
   PORT (
           wr_clk                    : IN  std_logic := '0';
     	   rd_clk                    : IN  std_logic := '0';
           srst                      : IN  std_logic := '0';
           prog_full                 : OUT std_logic := '0';
           wr_rst_busy               : OUT std_logic := '0';
           rd_rst_busy               : OUT std_logic := '0';
           wr_en 		     : IN  std_logic := '0';
           rd_en                     : IN  std_logic := '0';
           din                       : IN  std_logic_vector(18-1 DOWNTO 0) := (OTHERS => '0');
           dout                      : OUT std_logic_vector(18-1 DOWNTO 0) := (OTHERS => '0');
           full                      : OUT std_logic := '0';
           empty                     : OUT std_logic := '1');

end datafifo_dcfeb_top;



architecture xilinx of datafifo_dcfeb_top is

  signal wr_clk_i : std_logic := '0';
  signal rd_clk_i : std_logic := '0';



  component datafifo_dcfeb is
   PORT (
           wr_clk                    : IN  std_logic := '0';
     	   rd_clk                    : IN  std_logic := '0';
           srst                      : IN  std_logic := '0';
           prog_full                 : OUT std_logic := '0';
           wr_rst_busy               : OUT  std_logic := '0';
           rd_rst_busy               : OUT  std_logic := '0';
           wr_en                     : IN  std_logic := '0';
           rd_en                     : IN  std_logic := '0';
           din                       : IN  std_logic_vector(18-1 DOWNTO 0) := (OTHERS => '0');
           dout                      : OUT std_logic_vector(18-1 DOWNTO 0) := (OTHERS => '0');
           full                      : OUT std_logic := '0';
           empty                     : OUT std_logic := '1');

  end component;


begin

      wr_clk_i <= WR_CLK;
      rd_clk_i <= RD_CLK;


  top_inst : datafifo_dcfeb 
    PORT MAP (
           wr_clk                    => wr_clk_i,
           rd_clk                    => rd_clk_i,
           srst                      => srst,
           prog_full                 => prog_full,
           wr_rst_busy               => wr_rst_busy,
           rd_rst_busy               => rd_rst_busy,
           wr_en 		     => wr_en,
           rd_en                     => rd_en,
           din                       => din,
           dout                      => dout,
           full                      => full,
           empty                     => empty);

end xilinx;
