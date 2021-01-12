# file: ibert_ultrascale_gth_0.xdc

#################################
# Clocks
#################################

# # Input clock -- constraint by clock wizard
# create_clock -name D_CLK -period 3.333 [get_ports CMS_CLK_FPGA_P]
# set_input_jitter [get_clocks -of_objects [get_ports CMS_CLK_FPGA_P]] 0.033
# set_clock_groups -group [get_clocks D_CLK -include_generated_clocks] -asynchronous

set_property C_CLK_INPUT_FREQ_HZ 80000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER true [get_debug_cores dbg_hub]

# Refclk constraints
create_clock -name gth_refclk0_225 -period 6.4  [get_ports REF_CLK_1_P]
create_clock -name gth_refclk0_227 -period 6.4  [get_ports REF_CLK_3_P]
create_clock -name gth_refclk0_228 -period 6.4  [get_ports REF_CLK_2_P]
create_clock -name gth_refclk1_227 -period 8    [get_ports CLK_125_REF_P]
set_clock_groups -group [get_clocks gth_refclk0_227 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gth_refclk0_228 -include_generated_clocks] -asynchronous
set_clock_groups -group [get_clocks gth_refclk1_227 -include_generated_clocks] -asynchronous
