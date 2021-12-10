# ODMB7 Firmware Configuration XDC file
# ----------------------------------------------------------------------------------------------------------------------

set_property BITSTREAM.CONFIG.USERID 0x0D3B7E57 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK ENABLE [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR NO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]

# UltraScale FPGAs Transceivers Wizard IP constraints
# ----------------------------------------------------------------------------------------------------------------------

# False path userclk
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *gtwiz_userclk_tx_inst/*gtwiz_userclk_tx_active_*_reg}] -quiet
set_false_path -to [get_cells -hierarchical -filter {NAME =~ *gtwiz_userclk_rx_inst/*gtwiz_userclk_rx_active_*_reg}] -quiet

# Constraints related to the GBT protocol
# ----------------------------------------------------------------------------------------------------------------------
set_property RXSLIDE_MODE "PMA" [get_cells -hier -filter {NAME =~ *gbt_inst*GTHE3_CHANNEL_PRIM_INST}]


