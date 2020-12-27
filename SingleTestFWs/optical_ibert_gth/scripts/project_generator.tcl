# In the source directory run the below command
# vivado -nojournal -nolog -mode batch -source project_generator.tcl

# Environment variables
set BOARD ODMB7
# set BOARD KCU105
# set CONFIG TwoQuads
set CONFIG FourQuads

if {[string equal $BOARD ODMB7]} {
    set FPGA_TYPE xcku035-ffva1156-1-c; # for ODMB7
    set PROJECT_NAME project
} elseif {[string equal $BOARD KCU105]} {
    set FPGA_TYPE xcku040-ffva1156-2-e; # for KCU105
    set PROJECT_NAME kcu_project
}

if {[string equal $CONFIG TwoQuads]} {
    set TOP_MODULE "odmb7_ibert_2quads"
    set IBERT_MODULE "ibert_2quads_sepclks"
    set PROJECT_NAME project_2quads_sepclks
} elseif {[string equal $CONFIG FourQuads]} {
    set TOP_MODULE "odmb7_ibert_4quads"
    set IBERT_MODULE "ibert_4quads_sepclks"
    set PROJECT_NAME project_4quads_sepclks
} else {
    set TOP_MODULE "odmb7_ucsb_dev"
    set IBERT_MODULE "ibert_odmb7_gth"
    set PROJECT_NAME project_4quads_sameclk
}

# Generate ip
set argv $FPGA_TYPE
set argc 1
# create ip project when needed
# source ip_generator.tcl

# Create project
create_project $TOP_MODULE ../$PROJECT_NAME -part $FPGA_TYPE -force

set_property target_language VHDL [current_project]
set_property target_simulator XSim [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Add the top file and supporting sources
add_files -norecurse "../source/${TOP_MODULE}.vhd"
add_files -norecurse "../source/clock_counting.vhd"

# Add common IP core configurations
add_files -norecurse "../ip/$FPGA_TYPE/$IBERT_MODULE/$IBERT_MODULE.xci"
add_files -norecurse "../ip/$FPGA_TYPE/clockManager/clockManager.xci"
add_files -norecurse "../ip/$FPGA_TYPE/vio_ibert/vio_ibert.xci"

# Add common constraint files
add_files -fileset constrs_1 -norecurse "../constraints/odmb7_pinout.xdc"
add_files -fileset constrs_1 -norecurse "../constraints/odmb7_clocks.xdc"
add_files -fileset constrs_1 -norecurse "../constraints/${IBERT_MODULE}_ip.xdc"

# Set compile order for constraint files
set_property USED_IN_SYNTHESIS false [get_files ../constraints/${IBERT_MODULE}_ip.xdc]
set_property PROCESSING_ORDER  LATE  [get_files ../constraints/${IBERT_MODULE}_ip.xdc]

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value $TOP_MODULE -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

# Set ip as global
set_property generate_synth_checkpoint false [get_files  ../ip/$FPGA_TYPE/$IBERT_MODULE/$IBERT_MODULE.xci]
set_property generate_synth_checkpoint false [get_files  ../ip/$FPGA_TYPE/clockManager/clockManager.xci]
set_property generate_synth_checkpoint false [get_files  ../ip/$FPGA_TYPE/vio_ibert/vio_ibert.xci]
# set_property generate_synth_checkpoint false [get_files ../ip/$FPGA_TYPE/ila/ila.xci]

puts "\[Success\] Created project"
close_project
