# ODMB7 UltraScale FPGA Pinout XDC file
# ----------------------------------------------------------------------------------------------------------------------

# Location constraints for differential reference clock buffers
# Note: the IP core-level XDC constrains the transceiver channel data pin locations
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# Clock pins
# ----------------------------------------------------------------------------------------------------------------------

set_property package_pin    AK17         [get_ports CMS_CLK_FPGA_P]
set_property package_pin    AK16         [get_ports CMS_CLK_FPGA_N]
set_property IOSTANDARD     DIFF_SSTL12  [get_ports CMS_CLK_FPGA_P]
set_property IOSTANDARD     DIFF_SSTL12  [get_ports CMS_CLK_FPGA_N]
set_property ODT            RTT_48       [get_ports CMS_CLK_FPGA_P]
set_property ODT            RTT_48       [get_ports CMS_CLK_FPGA_N]

# set_property package_pin AK22 [get_ports GP_CLK_6_P]
# set_property package_pin AK23 [get_ports GP_CLK_6_N]
# set_property IOSTANDARD LVDS  [get_ports GP_CLK_6_P]
# set_property IOSTANDARD LVDS  [get_ports GP_CLK_6_N]

# set_property package_pin E18  [get_ports GP_CLK_7_P]
# set_property package_pin E17  [get_ports GP_CLK_7_N]
# set_property IOSTANDARD LVDS  [get_ports GP_CLK_7_P]
# set_property IOSTANDARD LVDS  [get_ports GP_CLK_7_N]

# MGTREFCLK0_225: PCIE_CLK_QO_P/N
set_property package_pin    AB6     [get_ports REF_CLK_1_P]
set_property package_pin    AB5     [get_ports REF_CLK_1_N]
# MGTREFCLK0_226: SMA_MGT_REFCLK_C_P/N
set_property package_pin    V6      [get_ports REF_CLK_4_P]
set_property package_pin    V5      [get_ports REF_CLK_4_N]
# MGTREFCLK1_226: FMC_LPC_GBTCLK0_M2C_C_P/N
# set_property package_pin    T6      [get_ports ???]
# set_property package_pin    T5      [get_ports ???]
# MGTREFCLK0_227: MGT_SI570_CLOCK_C_P/N
set_property package_pin    P6      [get_ports REF_CLK_3_P]
set_property package_pin    P5      [get_ports REF_CLK_3_N]
# MGTREFCLK1_227: SI5328_OUT_C_P/N
set_property package_pin    M6      [get_ports CLK_125_REF_P]
set_property package_pin    M5      [get_ports CLK_125_REF_N]
# MGTREFCLK0_228: FMC_HPC_GBTCLK0_M2C_C_P/N
set_property package_pin    K6      [get_ports REF_CLK_2_P]
set_property package_pin    K5      [get_ports REF_CLK_2_N]
# MGTREFCLK1_228: FMC_HPC_GBTCLK1_M2C_C_P/N
set_property package_pin    H6      [get_ports REF_CLK_5_P]
set_property package_pin    H5      [get_ports REF_CLK_5_N]

# Selector pin for SI570 CLOCK, pretended by DAQ/SPY sel
set_property PACKAGE_PIN   F12      [get_ports DAQ_SPY_SEL]
set_property IOSTANDARD    LVCMOS18 [get_ports DAQ_SPY_SEL]

# ----------------------------------------------------------------------------------------------------------------------
# Optical TX/RX pins
# ----------------------------------------------------------------------------------------------------------------------

set_property package_pin AH2 [get_ports  DAQ_RX_P[0]]
set_property package_pin AH1 [get_ports  DAQ_RX_N[0]]
set_property package_pin AF2 [get_ports  DAQ_RX_P[1]]
set_property package_pin AF1 [get_ports  DAQ_RX_N[1]]
set_property package_pin AD2 [get_ports  DAQ_RX_P[2]]
set_property package_pin AD1 [get_ports  DAQ_RX_N[2]]
set_property package_pin AB2 [get_ports  DAQ_RX_P[3]]
set_property package_pin AB1 [get_ports  DAQ_RX_N[3]]
set_property package_pin Y2  [get_ports  DAQ_RX_P[4]]
set_property package_pin Y1  [get_ports  DAQ_RX_N[4]]
set_property package_pin V2  [get_ports  DAQ_RX_P[5]]
set_property package_pin V1  [get_ports  DAQ_RX_N[5]]
set_property package_pin T2  [get_ports  DAQ_RX_P[6]]
set_property package_pin T1  [get_ports  DAQ_RX_N[6]]
set_property package_pin P2  [get_ports  DAQ_RX_P[7]]
set_property package_pin P1  [get_ports  DAQ_RX_N[7]]
set_property package_pin M2  [get_ports  DAQ_RX_P[8]]
set_property package_pin M1  [get_ports  DAQ_RX_N[8]]
set_property package_pin K2  [get_ports  DAQ_RX_P[9]]
set_property package_pin K1  [get_ports  DAQ_RX_N[9]]
set_property package_pin H2  [get_ports  DAQ_RX_P[10]]
set_property package_pin H1  [get_ports  DAQ_RX_N[10]]
set_property package_pin F2  [get_ports  DAQ_SPY_RX_P]
set_property package_pin F1  [get_ports  DAQ_SPY_RX_N]
set_property package_pin E4  [get_ports  BCK_PRS_P]
set_property package_pin E3  [get_ports  BCK_PRS_N]
set_property package_pin D2  [get_ports  B04_RX_P[2]]
set_property package_pin D1  [get_ports  B04_RX_N[2]]
set_property package_pin B2  [get_ports  B04_RX_P[3]]
set_property package_pin B1  [get_ports  B04_RX_N[3]]
set_property package_pin A4  [get_ports  B04_RX_P[4]]
set_property package_pin A3  [get_ports  B04_RX_N[4]]

set_property package_pin G4  [get_ports  SPY_TX_P]
set_property package_pin G3  [get_ports  SPY_TX_N]
set_property package_pin F6  [get_ports  DAQ_TX_P[1]]
set_property package_pin F5  [get_ports  DAQ_TX_N[1]]
set_property package_pin D6  [get_ports  DAQ_TX_P[2]]
set_property package_pin D5  [get_ports  DAQ_TX_N[2]]
set_property package_pin C4  [get_ports  DAQ_TX_P[3]]
set_property package_pin C3  [get_ports  DAQ_TX_N[3]]
set_property package_pin B6  [get_ports  DAQ_TX_P[4]]
set_property package_pin B5  [get_ports  DAQ_TX_N[4]]

set_property package_pin W4  [get_ports SFP_TX_P[0]]
set_property package_pin W3  [get_ports SFP_TX_N[0]]
set_property package_pin U4  [get_ports SFP_TX_P[1]]
set_property package_pin U3  [get_ports SFP_TX_N[1]]

set_property package_pin N4  [get_ports FMC_TX_P[0]]
set_property package_pin N3  [get_ports FMC_TX_N[0]]
set_property package_pin L4  [get_ports FMC_TX_P[1]]
set_property package_pin L3  [get_ports FMC_TX_N[1]]
set_property package_pin J4  [get_ports FMC_TX_P[2]]
set_property package_pin J3  [get_ports FMC_TX_N[2]]

# ----------------------------------------------------------------------------------------------------------------------
# SYSMON ports
# ----------------------------------------------------------------------------------------------------------------------
set_property PACKAGE_PIN F13 [get_ports SYSMON_AD0_R_P]
set_property PACKAGE_PIN E13 [get_ports SYSMON_AD0_R_N]
set_property IOSTANDARD ANALOG [get_ports SYSMON_AD0_R_P]
set_property IOSTANDARD ANALOG [get_ports SYSMON_AD0_R_N]

set_property PACKAGE_PIN C11 [get_ports SYSMON_AD8_R_P]
set_property PACKAGE_PIN B11 [get_ports SYSMON_AD8_R_N]
set_property IOSTANDARD ANALOG [get_ports SYSMON_AD8_R_P]
set_property IOSTANDARD ANALOG [get_ports SYSMON_AD8_R_N]

set_property PACKAGE_PIN J13 [get_ports SYSMON_AD2_R_P]
set_property PACKAGE_PIN H13 [get_ports SYSMON_AD2_R_N]
set_property IOSTANDARD ANALOG [get_ports SYSMON_AD2_R_P]
set_property IOSTANDARD ANALOG [get_ports SYSMON_AD2_R_N]

set_property PACKAGE_PIN N27 [get_ports SYSMON_MUX_ADDR_LS[2]]
set_property PACKAGE_PIN R27 [get_ports SYSMON_MUX_ADDR_LS[1]]
set_property PACKAGE_PIN T27 [get_ports SYSMON_MUX_ADDR_LS[0]]
set_property IOSTANDARD LVCMOS18 [get_ports SYSMON_MUX_ADDR_LS[2]]
set_property IOSTANDARD LVCMOS18 [get_ports SYSMON_MUX_ADDR_LS[1]]
set_property IOSTANDARD LVCMOS18 [get_ports SYSMON_MUX_ADDR_LS[0]]


# Empty TX ports

# # 225
# AH6
# AH5
# AG4
# AG3
# AE4
# AE3
# AC4
# AC3

# # 226
# AA4
# AA3
# R4
# R3



