# In the source directory run the below command
# vivado -nojournal -nolog -mode batch -source project_generator.tcl

# Environment variables
set FPGA_TYPE xcku035-ffva1156-1-c; # for ODMB7
# set FPGA_TYPE xcku040-ffva1156-2-e; # for KCU105

# Generate ip
set argv $FPGA_TYPE
set argc 1
# create ip project when needed
# source source/ip_generator.tcl

# Create project
create_project ibert_ultrascale_gth project -part xcku035-ffva1156-1-c -force
# create_project ibert_ultrascale_gth kcu_project -part $FPGA_TYPE -force
set_property target_language VHDL [current_project]
set_property target_simulator XSim [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]

# Import local files from the original project
# Add files
# for f in source/*; do echo \"$f\"\\; done
# find ip -type f -name "*.xci"
# "source/ibert_ultrascale_gth.xdc"\
# "source/ibert_ultrascale_gth_ip.xdc"\

set files [list \
"source/odmb7_ucsb_dev.vhd"\
"ip/$FPGA_TYPE/ibert_odmb7_gth/ibert_odmb7_gth.xci"\
"ip/$FPGA_TYPE/clockManager/clockManager.xci"
# "ip/$FPGA_TYPE/ila_0/ila_0.xci"\
# "ip/$FPGA_TYPE/vio_0/vio_0.xci"
]

add_files -norecurse $files
add_files -fileset constrs_1 -norecurse "source/ibert_ultrascale_gth.xdc"
add_files -fileset constrs_1 -norecurse "source/ibert_ultrascale_gth_ip.xdc"
# add_files -fileset constrs_1 -norecurse "source/odmb_pinouts.xdc"

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "odmb7_ucsb_dev" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

# Add tcl for simulation
## not set currently, add when needed
#set_property -name {xsim.simulate.custom_tcl} -value {../../../../source/Firmware_tb.tcl} -objects [get_filesets sim_1]

# Set ip as global
set_property generate_synth_checkpoint false [get_files  ip/$FPGA_TYPE/ibert_odmb7_gth/ibert_odmb7_gth.xci]
set_property generate_synth_checkpoint false [get_files  ip/$FPGA_TYPE/clockManager/clockManager.xci]
# set_property generate_synth_checkpoint false [get_files  ip/$FPGA_TYPE/ila_0/ila_0.xci]
# set_property generate_synth_checkpoint false [get_files  ip/$FPGA_TYPE/vio_0/vio_0.xci]

puts "\[Success\] Created project"
close_project
