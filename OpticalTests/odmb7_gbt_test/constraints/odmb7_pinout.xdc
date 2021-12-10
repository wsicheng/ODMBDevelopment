# ODMB7 UltraScale FPGA Pinout XDC file
# ----------------------------------------------------------------------------------------------------------------------
# Location constraints for differential reference clock buffers
# Outline/section title:
# - Clock pins
# - Selector/monitor pins unclassified yet
# - VME pins
# - DCFEB JTAG/control pins
# - LVMB control/monitor pins
# - Optical TX/RX pins
# - Optical control pins
# - SYSMON pins
# - LED pins
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# Clock pins
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN AK17  IOSTANDARD LVDS } [get_ports CMS_CLK_FPGA_P]
set_property -dict { PACKAGE_PIN AK16  IOSTANDARD LVDS } [get_ports CMS_CLK_FPGA_N]

set_property -dict { PACKAGE_PIN AK22  IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports GP_CLK_6_P]
set_property -dict { PACKAGE_PIN AK23  IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports GP_CLK_6_N]
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports GP_CLK_7_P]
set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports GP_CLK_7_N]

set_property -dict { PACKAGE_PIN K20   IOSTANDARD LVCMOS18 } [get_ports EMCCLK]
set_property -dict { PACKAGE_PIN AJ16  IOSTANDARD LVCMOS18 } [get_ports LF_CLK]

set_property -dict { PACKAGE_PIN AF6  } [get_ports REF_CLK_1_P]
set_property -dict { PACKAGE_PIN AF5  } [get_ports REF_CLK_1_N]
set_property -dict { PACKAGE_PIN P6   } [get_ports REF_CLK_2_P]
set_property -dict { PACKAGE_PIN P5   } [get_ports REF_CLK_2_N]
set_property -dict { PACKAGE_PIN V6   } [get_ports REF_CLK_3_P]
set_property -dict { PACKAGE_PIN V5   } [get_ports REF_CLK_3_N]
set_property -dict { PACKAGE_PIN AB6  } [get_ports REF_CLK_4_P]
set_property -dict { PACKAGE_PIN AB5  } [get_ports REF_CLK_4_N]
set_property -dict { PACKAGE_PIN M6   } [get_ports REF_CLK_5_P]
set_property -dict { PACKAGE_PIN M5   } [get_ports REF_CLK_5_N]
set_property -dict { PACKAGE_PIN T6   } [get_ports CLK_125_REF_P]
set_property -dict { PACKAGE_PIN T5   } [get_ports CLK_125_REF_N]

# ----------------------------------------------------------------------------------------------------------------------
# Selector/monitor pins unclassified yet
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN U21   IOSTANDARD LVCMOS18 } [get_ports KUS_DL_SEL]
set_property -dict { PACKAGE_PIN T23   IOSTANDARD LVCMOS18 } [get_ports FPGA_SEL]
set_property -dict { PACKAGE_PIN W29   IOSTANDARD LVCMOS18 } [get_ports RST_CLKS_B]
set_property -dict { PACKAGE_PIN AN14  IOSTANDARD LVCMOS18 } [get_ports CCB_HARDRST_B]
set_property -dict { PACKAGE_PIN AP14  IOSTANDARD LVCMOS18 } [get_ports CCB_SOFT_RST]
set_property -dict { PACKAGE_PIN L9    IOSTANDARD LVCMOS18 } [get_ports ODMB_DONE]


# ----------------------------------------------------------------------------------------------------------------------
# VME pins
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN V31   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[0]]
set_property -dict { PACKAGE_PIN W31   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[1]]
set_property -dict { PACKAGE_PIN V32   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[2]]
set_property -dict { PACKAGE_PIN U34   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[3]]
set_property -dict { PACKAGE_PIN V34   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[4]]
set_property -dict { PACKAGE_PIN Y31   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[5]]
set_property -dict { PACKAGE_PIN Y32   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[6]]
set_property -dict { PACKAGE_PIN V33   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[7]]
set_property -dict { PACKAGE_PIN W34   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[8]]
set_property -dict { PACKAGE_PIN W30   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[9]]
set_property -dict { PACKAGE_PIN Y30   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[10]]
set_property -dict { PACKAGE_PIN W33   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[11]]
set_property -dict { PACKAGE_PIN Y33   IOSTANDARD LVCMOS18 } [get_ports VME_DATA[12]]
set_property -dict { PACKAGE_PIN AC33  IOSTANDARD LVCMOS18 } [get_ports VME_DATA[13]]
set_property -dict { PACKAGE_PIN AD33  IOSTANDARD LVCMOS18 } [get_ports VME_DATA[14]]
set_property -dict { PACKAGE_PIN AA34  IOSTANDARD LVCMOS18 } [get_ports VME_DATA[15]]

set_property -dict { PACKAGE_PIN AK30  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[1]]
set_property -dict { PACKAGE_PIN AL30  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[2]]
set_property -dict { PACKAGE_PIN AM30  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[3]]
set_property -dict { PACKAGE_PIN AM31  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[4]]
set_property -dict { PACKAGE_PIN AL29  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[5]]
set_property -dict { PACKAGE_PIN AM29  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[6]]
set_property -dict { PACKAGE_PIN AN29  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[7]]
set_property -dict { PACKAGE_PIN AP30  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[8]]
set_property -dict { PACKAGE_PIN AN27  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[9]]
set_property -dict { PACKAGE_PIN AN28  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[10]]
set_property -dict { PACKAGE_PIN AP28  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[11]]
set_property -dict { PACKAGE_PIN AP29  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[12]]
set_property -dict { PACKAGE_PIN AN26  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[13]]
set_property -dict { PACKAGE_PIN AP26  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[14]]
set_property -dict { PACKAGE_PIN AJ28  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[15]]
set_property -dict { PACKAGE_PIN AK28  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[16]]
set_property -dict { PACKAGE_PIN AH27  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[17]]
set_property -dict { PACKAGE_PIN AH28  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[18]]
set_property -dict { PACKAGE_PIN AL27  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[19]]
set_property -dict { PACKAGE_PIN AL28  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[20]]
set_property -dict { PACKAGE_PIN AK26  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[21]]
set_property -dict { PACKAGE_PIN AK27  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[22]]
set_property -dict { PACKAGE_PIN AM26  IOSTANDARD LVCMOS18 } [get_ports VME_ADDR[23]]

set_property -dict { PACKAGE_PIN AL33  IOSTANDARD LVCMOS18 } [get_ports VME_AM[0]]
set_property -dict { PACKAGE_PIN AH34  IOSTANDARD LVCMOS18 } [get_ports VME_AM[1]]
set_property -dict { PACKAGE_PIN AJ34  IOSTANDARD LVCMOS18 } [get_ports VME_AM[2]]
set_property -dict { PACKAGE_PIN AH31  IOSTANDARD LVCMOS18 } [get_ports VME_AM[3]]
set_property -dict { PACKAGE_PIN AH32  IOSTANDARD LVCMOS18 } [get_ports VME_AM[4]]
set_property -dict { PACKAGE_PIN AH33  IOSTANDARD LVCMOS18 } [get_ports VME_AM[5]]

set_property -dict { PACKAGE_PIN AB34  IOSTANDARD LVCMOS18 } [get_ports VME_GAP_B]
set_property -dict { PACKAGE_PIN AB30  IOSTANDARD LVCMOS18 } [get_ports VME_GA_B[0]]
set_property -dict { PACKAGE_PIN AD34  IOSTANDARD LVCMOS18 } [get_ports VME_GA_B[1]]
set_property -dict { PACKAGE_PIN AC34  IOSTANDARD LVCMOS18 } [get_ports VME_GA_B[2]]
set_property -dict { PACKAGE_PIN AB29  IOSTANDARD LVCMOS18 } [get_ports VME_GA_B[3]]
set_property -dict { PACKAGE_PIN AA29  IOSTANDARD LVCMOS18 } [get_ports VME_GA_B[4]]

set_property -dict { PACKAGE_PIN AJ31  IOSTANDARD LVCMOS18 } [get_ports VME_AS_B]
set_property -dict { PACKAGE_PIN AJ30  IOSTANDARD LVCMOS18 } [get_ports VME_DS_B[0]]
set_property -dict { PACKAGE_PIN AJ33  IOSTANDARD LVCMOS18 } [get_ports VME_DS_B[1]]
set_property -dict { PACKAGE_PIN AC31  IOSTANDARD LVCMOS18 } [get_ports VME_SYSRST_B]
set_property -dict { PACKAGE_PIN AC32  IOSTANDARD LVCMOS18 } [get_ports VME_SYSFAIL_B]
set_property -dict { PACKAGE_PIN AE32  IOSTANDARD LVCMOS18 } [get_ports VME_CLK_B]
set_property -dict { PACKAGE_PIN AB32  IOSTANDARD LVCMOS18 } [get_ports VME_BERR_B]
set_property -dict { PACKAGE_PIN AB31  IOSTANDARD LVCMOS18 } [get_ports VME_IACK_B]
set_property -dict { PACKAGE_PIN AA32  IOSTANDARD LVCMOS18 } [get_ports VME_LWORD_B]
set_property -dict { PACKAGE_PIN AA33  IOSTANDARD LVCMOS18 } [get_ports VME_WRITE_B]
set_property -dict { PACKAGE_PIN AN23  IOSTANDARD LVCMOS18 } [get_ports KUS_VME_OE_B]
set_property -dict { PACKAGE_PIN AP23  IOSTANDARD LVCMOS18 } [get_ports KUS_VME_DIR]
set_property -dict { PACKAGE_PIN AM25  IOSTANDARD LVCMOS18 } [get_ports VME_DTACK_KUS_B]

# ----------------------------------------------------------------------------------------------------------------------
# DCFEB JTAG / HD50 pins
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN F15   IOSTANDARD LVDS } [get_ports DCFEB_TCK_P[1]]
set_property -dict { PACKAGE_PIN F14   IOSTANDARD LVDS } [get_ports DCFEB_TCK_N[1]]
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVDS } [get_ports DCFEB_TCK_P[2]]
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVDS } [get_ports DCFEB_TCK_N[2]]
set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVDS } [get_ports DCFEB_TCK_P[3]]
set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVDS } [get_ports DCFEB_TCK_N[3]]
set_property -dict { PACKAGE_PIN E15   IOSTANDARD LVDS } [get_ports DCFEB_TCK_P[4]]
set_property -dict { PACKAGE_PIN D15   IOSTANDARD LVDS } [get_ports DCFEB_TCK_N[4]]
set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVDS } [get_ports DCFEB_TCK_P[5]]
set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVDS } [get_ports DCFEB_TCK_N[5]]
set_property -dict { PACKAGE_PIN C18   IOSTANDARD LVDS } [get_ports DCFEB_TCK_P[6]]
set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVDS } [get_ports DCFEB_TCK_N[6]]
set_property -dict { PACKAGE_PIN C19   IOSTANDARD LVDS } [get_ports DCFEB_TCK_P[7]]
set_property -dict { PACKAGE_PIN B19   IOSTANDARD LVDS } [get_ports DCFEB_TCK_N[7]]
set_property -dict { PACKAGE_PIN A19   IOSTANDARD LVDS } [get_ports DCFEB_TMS_P]
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVDS } [get_ports DCFEB_TMS_N]
set_property -dict { PACKAGE_PIN B14   IOSTANDARD LVDS } [get_ports DCFEB_TDI_P]
set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVDS } [get_ports DCFEB_TDI_N]

set_property -dict { PACKAGE_PIN F23   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_P[1]]
set_property -dict { PACKAGE_PIN F24   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_N[1]]
set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_P[2]]
set_property -dict { PACKAGE_PIN D21   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_N[2]]
set_property -dict { PACKAGE_PIN G20   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_P[3]]
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_N[3]]
set_property -dict { PACKAGE_PIN G24   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_P[4]]
set_property -dict { PACKAGE_PIN F25   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_N[4]]
set_property -dict { PACKAGE_PIN G22   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_P[5]]
set_property -dict { PACKAGE_PIN F22   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_N[5]]
set_property -dict { PACKAGE_PIN E20   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_P[6]]
set_property -dict { PACKAGE_PIN E21   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_N[6]]
set_property -dict { PACKAGE_PIN J19   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_P[7]]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVDS  DIFF_TERM_ADV TERM_100 } [get_ports DCFEB_TDO_N[7]]

set_property -dict { PACKAGE_PIN G19   IOSTANDARD LVCMOS18 } [get_ports DCFEB_DONE[1]]
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS18 } [get_ports DCFEB_DONE[2]]
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS18 } [get_ports DCFEB_DONE[3]]
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS18 } [get_ports DCFEB_DONE[4]]
set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS18 } [get_ports DCFEB_DONE[5]]
set_property -dict { PACKAGE_PIN F17   IOSTANDARD LVCMOS18 } [get_ports DCFEB_DONE[6]]
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS18 } [get_ports DCFEB_DONE[7]]

# DCFEB test pins
set_property -dict { PACKAGE_PIN D8    IOSTANDARD LVDS }     [get_ports RESYNC_P]
set_property -dict { PACKAGE_PIN C8    IOSTANDARD LVDS }     [get_ports RESYNC_N]
set_property -dict { PACKAGE_PIN B15   IOSTANDARD LVDS }     [get_ports BC0_P]
set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVDS }     [get_ports BC0_N]
set_property -dict { PACKAGE_PIN E10   IOSTANDARD LVDS }     [get_ports INJPLS_P]
set_property -dict { PACKAGE_PIN D10   IOSTANDARD LVDS }     [get_ports INJPLS_N]
set_property -dict { PACKAGE_PIN B10   IOSTANDARD LVDS }     [get_ports EXTPLS_P]
set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVDS }     [get_ports EXTPLS_N]
set_property -dict { PACKAGE_PIN C16   IOSTANDARD LVCMOS18 } [get_ports PPIB_OUT_EN_B]

# L1A pins
set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVDS }     [get_ports L1A_P]
set_property -dict { PACKAGE_PIN A9    IOSTANDARD LVDS }     [get_ports L1A_N]
set_property -dict { PACKAGE_PIN L8    IOSTANDARD LVDS }     [get_ports L1A_MATCH_P[1]]
set_property -dict { PACKAGE_PIN K8    IOSTANDARD LVDS }     [get_ports L1A_MATCH_N[1]]
set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVDS }     [get_ports L1A_MATCH_P[2]]
set_property -dict { PACKAGE_PIN C13   IOSTANDARD LVDS }     [get_ports L1A_MATCH_N[2]]
set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVDS }     [get_ports L1A_MATCH_P[3]]
set_property -dict { PACKAGE_PIN A12   IOSTANDARD LVDS }     [get_ports L1A_MATCH_N[3]]
set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVDS }     [get_ports L1A_MATCH_P[4]]
set_property -dict { PACKAGE_PIN E13   IOSTANDARD LVDS }     [get_ports L1A_MATCH_N[4]]
set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVDS }     [get_ports L1A_MATCH_P[5]]
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVDS }     [get_ports L1A_MATCH_N[5]]
set_property -dict { PACKAGE_PIN C12   IOSTANDARD LVDS }     [get_ports L1A_MATCH_P[6]]
set_property -dict { PACKAGE_PIN B12   IOSTANDARD LVDS }     [get_ports L1A_MATCH_N[6]]
set_property -dict { PACKAGE_PIN E11   IOSTANDARD LVDS }     [get_ports L1A_MATCH_P[7]]
set_property -dict { PACKAGE_PIN D11   IOSTANDARD LVDS }     [get_ports L1A_MATCH_N[7]]

# ----------------------------------------------------------------------------------------------------------------------
# LVMB control/monitor pins
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN B24   IOSTANDARD LVCMOS18 } [get_ports LVMB_PON[0]]
set_property -dict { PACKAGE_PIN A24   IOSTANDARD LVCMOS18 } [get_ports LVMB_PON[1]]
set_property -dict { PACKAGE_PIN C26   IOSTANDARD LVCMOS18 } [get_ports LVMB_PON[2]]
set_property -dict { PACKAGE_PIN B26   IOSTANDARD LVCMOS18 } [get_ports LVMB_PON[3]]
set_property -dict { PACKAGE_PIN B25   IOSTANDARD LVCMOS18 } [get_ports LVMB_PON[4]]
set_property -dict { PACKAGE_PIN A25   IOSTANDARD LVCMOS18 } [get_ports LVMB_PON[5]]
set_property -dict { PACKAGE_PIN A27   IOSTANDARD LVCMOS18 } [get_ports LVMB_PON[6]]
set_property -dict { PACKAGE_PIN A28   IOSTANDARD LVCMOS18 } [get_ports LVMB_PON[7]]

set_property -dict { PACKAGE_PIN C24   IOSTANDARD LVCMOS18 } [get_ports PON_LOAD]
set_property -dict { PACKAGE_PIN A23   IOSTANDARD LVCMOS18 } [get_ports PON_OE_B]

set_property -dict { PACKAGE_PIN C28   IOSTANDARD LVCMOS18 } [get_ports LVMB_CSB[0]]
set_property -dict { PACKAGE_PIN B29   IOSTANDARD LVCMOS18 } [get_ports LVMB_CSB[1]]
set_property -dict { PACKAGE_PIN A29   IOSTANDARD LVCMOS18 } [get_ports LVMB_CSB[2]]
set_property -dict { PACKAGE_PIN D29   IOSTANDARD LVCMOS18 } [get_ports LVMB_CSB[3]]
set_property -dict { PACKAGE_PIN C27   IOSTANDARD LVCMOS18 } [get_ports LVMB_CSB[4]]
set_property -dict { PACKAGE_PIN B27   IOSTANDARD LVCMOS18 } [get_ports LVMB_CSB[5]]
set_property -dict { PACKAGE_PIN C29   IOSTANDARD LVCMOS18 } [get_ports LVMB_CSB[6]]

set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS18 } [get_ports LVMB_SCLK]
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS18 } [get_ports LVMB_SDIN]

set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS18 } [get_ports MON_LVMB_PON[0]]
set_property -dict { PACKAGE_PIN C21   IOSTANDARD LVCMOS18 } [get_ports MON_LVMB_PON[1]]
set_property -dict { PACKAGE_PIN C22   IOSTANDARD LVCMOS18 } [get_ports MON_LVMB_PON[2]]
set_property -dict { PACKAGE_PIN B21   IOSTANDARD LVCMOS18 } [get_ports MON_LVMB_PON[3]]
set_property -dict { PACKAGE_PIN B22   IOSTANDARD LVCMOS18 } [get_ports MON_LVMB_PON[4]]
set_property -dict { PACKAGE_PIN A22   IOSTANDARD LVCMOS18 } [get_ports MON_LVMB_PON[5]]
set_property -dict { PACKAGE_PIN D23   IOSTANDARD LVCMOS18 } [get_ports MON_LVMB_PON[6]]
set_property -dict { PACKAGE_PIN C23   IOSTANDARD LVCMOS18 } [get_ports MON_LVMB_PON[7]]

# ----------------------------------------------------------------------------------------------------------------------
# Optical TX/RX pins
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN  AP2  } [get_ports  DAQ_RX_P[0]]
set_property -dict { PACKAGE_PIN  AP1  } [get_ports  DAQ_RX_N[0]]
set_property -dict { PACKAGE_PIN  AM2  } [get_ports  DAQ_RX_P[1]]
set_property -dict { PACKAGE_PIN  AM1  } [get_ports  DAQ_RX_N[1]]
set_property -dict { PACKAGE_PIN  AK2  } [get_ports  DAQ_RX_P[2]]
set_property -dict { PACKAGE_PIN  AK1  } [get_ports  DAQ_RX_N[2]]
set_property -dict { PACKAGE_PIN  AJ4  } [get_ports  DAQ_RX_P[3]]
set_property -dict { PACKAGE_PIN  AJ3  } [get_ports  DAQ_RX_N[3]]
set_property -dict { PACKAGE_PIN  AH2  } [get_ports  DAQ_RX_P[4]]
set_property -dict { PACKAGE_PIN  AH1  } [get_ports  DAQ_RX_N[4]]
set_property -dict { PACKAGE_PIN  AF2  } [get_ports  DAQ_RX_P[5]]
set_property -dict { PACKAGE_PIN  AF1  } [get_ports  DAQ_RX_N[5]]
set_property -dict { PACKAGE_PIN  AD2  } [get_ports  DAQ_RX_P[6]]
set_property -dict { PACKAGE_PIN  AD1  } [get_ports  DAQ_RX_N[6]]
set_property -dict { PACKAGE_PIN  AB2  } [get_ports  DAQ_RX_P[7]]
set_property -dict { PACKAGE_PIN  AB1  } [get_ports  DAQ_RX_N[7]]
set_property -dict { PACKAGE_PIN  Y2   } [get_ports  DAQ_RX_P[8]]
set_property -dict { PACKAGE_PIN  Y1   } [get_ports  DAQ_RX_N[8]]
set_property -dict { PACKAGE_PIN  V2   } [get_ports  DAQ_RX_P[9]]
set_property -dict { PACKAGE_PIN  V1   } [get_ports  DAQ_RX_N[9]]
set_property -dict { PACKAGE_PIN  T2   } [get_ports  DAQ_RX_P[10]]
set_property -dict { PACKAGE_PIN  T1   } [get_ports  DAQ_RX_N[10]]
set_property -dict { PACKAGE_PIN  P2   } [get_ports  DAQ_SPY_RX_P]
set_property -dict { PACKAGE_PIN  P1   } [get_ports  DAQ_SPY_RX_N]
# set_property -dict { PACKAGE_PIN  N4   } [get_ports  DAQ_TX_P[1]]
# set_property -dict { PACKAGE_PIN  N3   } [get_ports  DAQ_TX_N[1]]
# set_property -dict { PACKAGE_PIN  L4   } [get_ports  DAQ_TX_P[2]]
# set_property -dict { PACKAGE_PIN  L3   } [get_ports  DAQ_TX_N[2]]
# set_property -dict { PACKAGE_PIN  J4   } [get_ports  DAQ_TX_P[3]]
# set_property -dict { PACKAGE_PIN  J3   } [get_ports  DAQ_TX_N[3]]
# set_property -dict { PACKAGE_PIN  G4   } [get_ports  DAQ_TX_P[4]]
# set_property -dict { PACKAGE_PIN  G3   } [get_ports  DAQ_TX_N[4]]
set_property -dict { PACKAGE_PIN  M2   } [get_ports  BCK_PRS_P]
set_property -dict { PACKAGE_PIN  M1   } [get_ports  BCK_PRS_N]
set_property -dict { PACKAGE_PIN  K2   } [get_ports  B04_RX_P[2]]
set_property -dict { PACKAGE_PIN  K1   } [get_ports  B04_RX_N[2]]
set_property -dict { PACKAGE_PIN  H2   } [get_ports  B04_RX_P[3]]
set_property -dict { PACKAGE_PIN  H1   } [get_ports  B04_RX_N[3]]
set_property -dict { PACKAGE_PIN  F2   } [get_ports  B04_RX_P[4]]
set_property -dict { PACKAGE_PIN  F1   } [get_ports  B04_RX_N[4]]
set_property -dict { PACKAGE_PIN  R4   } [get_ports  SPY_TX_P]
set_property -dict { PACKAGE_PIN  R3   } [get_ports  SPY_TX_N]

# ----------------------------------------------------------------------------------------------------------------------
# Optical control pins
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN E12   IOSTANDARD LVCMOS18 } [get_ports DAQ_SPY_SEL]

set_property -dict { PACKAGE_PIN K11   IOSTANDARD LVCMOS18 } [get_ports RX12_I2C_ENA]
set_property -dict { PACKAGE_PIN J11   IOSTANDARD LVCMOS18 } [get_ports RX12_SDA]
set_property -dict { PACKAGE_PIN H12   IOSTANDARD LVCMOS18 } [get_ports RX12_SCL]
set_property -dict { PACKAGE_PIN G12   IOSTANDARD LVCMOS18 } [get_ports RX12_CS_B]
set_property -dict { PACKAGE_PIN F12   IOSTANDARD LVCMOS18 } [get_ports RX12_RST_B]
set_property -dict { PACKAGE_PIN G9    IOSTANDARD LVCMOS18 } [get_ports RX12_INT_B]
set_property -dict { PACKAGE_PIN F9    IOSTANDARD LVCMOS18 } [get_ports RX12_PRESENT_B]

set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS18 } [get_ports TX12_I2C_ENA]
set_property -dict { PACKAGE_PIN H13   IOSTANDARD LVCMOS18 } [get_ports TX12_SDA]
set_property -dict { PACKAGE_PIN L12   IOSTANDARD LVCMOS18 } [get_ports TX12_SCL]
set_property -dict { PACKAGE_PIN G10   IOSTANDARD LVCMOS18 } [get_ports TX12_CS_B]
set_property -dict { PACKAGE_PIN F10   IOSTANDARD LVCMOS18 } [get_ports TX12_RST_B]
set_property -dict { PACKAGE_PIN J8    IOSTANDARD LVCMOS18 } [get_ports TX12_INT_B]
set_property -dict { PACKAGE_PIN H8    IOSTANDARD LVCMOS18 } [get_ports TX12_PRESENT_B]

set_property -dict { PACKAGE_PIN K12   IOSTANDARD LVCMOS18 } [get_ports B04_I2C_ENA]
set_property -dict { PACKAGE_PIN L13   IOSTANDARD LVCMOS18 } [get_ports B04_SDA]
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS18 } [get_ports B04_SCL]
set_property -dict { PACKAGE_PIN H11   IOSTANDARD LVCMOS18 } [get_ports B04_CS_B]
set_property -dict { PACKAGE_PIN G11   IOSTANDARD LVCMOS18 } [get_ports B04_RST_B]
set_property -dict { PACKAGE_PIN K10   IOSTANDARD LVCMOS18 } [get_ports B04_INT_B]
set_property -dict { PACKAGE_PIN J10   IOSTANDARD LVCMOS18 } [get_ports B04_PRESENT_B]

set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS18 } [get_ports SPY_I2C_ENA]
set_property -dict { PACKAGE_PIN H9    IOSTANDARD LVCMOS18 } [get_ports SPY_SDA]
set_property -dict { PACKAGE_PIN J9    IOSTANDARD LVCMOS18 } [get_ports SPY_SCL]
set_property -dict { PACKAGE_PIN F8    IOSTANDARD LVCMOS18 } [get_ports SPY_SD]
set_property -dict { PACKAGE_PIN E8    IOSTANDARD LVCMOS18 } [get_ports SPY_TDIS]

# ----------------------------------------------------------------------------------------------------------------------
# SYSMON pins
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN AN8   IOSTANDARD ANALOG }   [get_ports SYSMON_P[0]]
set_property -dict { PACKAGE_PIN AP8   IOSTANDARD ANALOG }   [get_ports SYSMON_N[0]]
set_property -dict { PACKAGE_PIN AN9   IOSTANDARD ANALOG }   [get_ports SYSMON_P[1]]
set_property -dict { PACKAGE_PIN AP9   IOSTANDARD ANALOG }   [get_ports SYSMON_N[1]]
set_property -dict { PACKAGE_PIN AH9   IOSTANDARD ANALOG }   [get_ports SYSMON_P[2]]
set_property -dict { PACKAGE_PIN AH8   IOSTANDARD ANALOG }   [get_ports SYSMON_N[2]]
set_property -dict { PACKAGE_PIN AD10  IOSTANDARD ANALOG }   [get_ports SYSMON_P[3]]
set_property -dict { PACKAGE_PIN AE10  IOSTANDARD ANALOG }   [get_ports SYSMON_N[3]]
set_property -dict { PACKAGE_PIN AD11  IOSTANDARD ANALOG }   [get_ports SYSMON_P[4]]
set_property -dict { PACKAGE_PIN AE11  IOSTANDARD ANALOG }   [get_ports SYSMON_N[4]]
set_property -dict { PACKAGE_PIN AH13  IOSTANDARD ANALOG }   [get_ports SYSMON_P[5]]
set_property -dict { PACKAGE_PIN AJ13  IOSTANDARD ANALOG }   [get_ports SYSMON_N[5]]
set_property -dict { PACKAGE_PIN AK13  IOSTANDARD ANALOG }   [get_ports SYSMON_P[6]]
set_property -dict { PACKAGE_PIN AL13  IOSTANDARD ANALOG }   [get_ports SYSMON_N[6]]
set_property -dict { PACKAGE_PIN AM12  IOSTANDARD ANALOG }   [get_ports SYSMON_P[7]]
set_property -dict { PACKAGE_PIN AN12  IOSTANDARD ANALOG }   [get_ports SYSMON_N[7]]
set_property -dict { PACKAGE_PIN AK10  IOSTANDARD ANALOG }   [get_ports SYSMON_P[8]]
set_property -dict { PACKAGE_PIN AL9   IOSTANDARD ANALOG }   [get_ports SYSMON_N[8]]
set_property -dict { PACKAGE_PIN AL10  IOSTANDARD ANALOG }   [get_ports SYSMON_P[9]]
set_property -dict { PACKAGE_PIN AM10  IOSTANDARD ANALOG }   [get_ports SYSMON_N[9]]
set_property -dict { PACKAGE_PIN AD9   IOSTANDARD ANALOG }   [get_ports SYSMON_P[10]]
set_property -dict { PACKAGE_PIN AD8   IOSTANDARD ANALOG }   [get_ports SYSMON_N[10]]
set_property -dict { PACKAGE_PIN AE8   IOSTANDARD ANALOG }   [get_ports SYSMON_P[11]]
set_property -dict { PACKAGE_PIN AF8   IOSTANDARD ANALOG }   [get_ports SYSMON_N[11]]
set_property -dict { PACKAGE_PIN AE12  IOSTANDARD ANALOG }   [get_ports SYSMON_P[12]]
set_property -dict { PACKAGE_PIN AF12  IOSTANDARD ANALOG }   [get_ports SYSMON_N[12]]
set_property -dict { PACKAGE_PIN AE13  IOSTANDARD ANALOG }   [get_ports SYSMON_P[13]]
set_property -dict { PACKAGE_PIN AF13  IOSTANDARD ANALOG }   [get_ports SYSMON_N[13]]
set_property -dict { PACKAGE_PIN AK12  IOSTANDARD ANALOG }   [get_ports SYSMON_P[14]]
set_property -dict { PACKAGE_PIN AL12  IOSTANDARD ANALOG }   [get_ports SYSMON_N[14]]
set_property -dict { PACKAGE_PIN AM11  IOSTANDARD ANALOG }   [get_ports SYSMON_P[15]]
set_property -dict { PACKAGE_PIN AN11  IOSTANDARD ANALOG }   [get_ports SYSMON_N[15]]

set_property -dict { PACKAGE_PIN AN13  IOSTANDARD LVCMOS18 } [get_ports ADC_CS_B[0]]
set_property -dict { PACKAGE_PIN AP13  IOSTANDARD LVCMOS18 } [get_ports ADC_CS_B[1]]
set_property -dict { PACKAGE_PIN AK11  IOSTANDARD LVCMOS18 } [get_ports ADC_CS_B[2]]
set_property -dict { PACKAGE_PIN AP11  IOSTANDARD LVCMOS18 } [get_ports ADC_CS_B[3]]
set_property -dict { PACKAGE_PIN AP10  IOSTANDARD LVCMOS18 } [get_ports ADC_CS_B[4]]
set_property -dict { PACKAGE_PIN AG10  IOSTANDARD LVCMOS18 } [get_ports ADC_SCK]
set_property -dict { PACKAGE_PIN AF10  IOSTANDARD LVCMOS18 } [get_ports ADC_DIN]
set_property -dict { PACKAGE_PIN AG11  IOSTANDARD LVCMOS18 } [get_ports ADC_DOUT]

# ----------------------------------------------------------------------------------------------------------------------
# LED pins
# ----------------------------------------------------------------------------------------------------------------------
set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[0]]
set_property -dict { PACKAGE_PIN T27   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[1]]
set_property -dict { PACKAGE_PIN N22   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[2]]
set_property -dict { PACKAGE_PIN R27   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[3]]
set_property -dict { PACKAGE_PIN T25   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[4]]
set_property -dict { PACKAGE_PIN R26   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[5]]
set_property -dict { PACKAGE_PIN R25   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[6]]
set_property -dict { PACKAGE_PIN T24   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[7]]
set_property -dict { PACKAGE_PIN R23   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[8]]
set_property -dict { PACKAGE_PIN P23   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[9]]
set_property -dict { PACKAGE_PIN P21   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[10]]
set_property -dict { PACKAGE_PIN M22   IOSTANDARD LVCMOS18 } [get_ports LEDS_CFV[11]]