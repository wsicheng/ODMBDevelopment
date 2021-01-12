# In the source directory run the below command
# vivado -nojournal -nolog -mode batch -source project_generator.tcl

# Environment variables
set BOARD KCU105
# set CONFIG OneQuad
# set CONFIG TwoQuads
# set CONFIG ThreeQuads
# set CONFIG FourQuads
set CONFIG FiveQuads
# set CONFIG Quad227

if {[string equal $BOARD ODMB7]} {
    set FPGA_TYPE xcku035-ffva1156-1-c; # for ODMB7
    set IBERT_MODULE "ibert_odmb7_gth"
    set TOP_MODULE "odmb7_ibert_gth"
    set PROJECT_NAME project
} elseif {[string equal $BOARD KCU105]} {
    set FPGA_TYPE xcku040-ffva1156-2-e; # for KCU105
    set TOP_MODULE "kcu_ibert_gth"
    set IBERT_MODULE "ibert_kcu_gth"
    set PROJECT_NAME kcu_project
}

if {[string equal $CONFIG TwoQuads]} {
    set IBERT_CONFIG "ibert_kcu_2quads"
    set PROJECT_NAME project_2quads
    set TOP_GENERIC {NQUAD=2}
} elseif {[string equal $CONFIG FourQuads]} {
    set IBERT_CONFIG "ibert_kcu_4quads"
    set PROJECT_NAME project_4quads
    set TOP_GENERIC {NQUAD=4}
} elseif {[string equal $CONFIG FiveQuads]} {
    set IBERT_CONFIG "ibert_kcu_5quads"
    set PROJECT_NAME project_5quads
    set TOP_GENERIC {NQUAD=5}
} elseif {[string equal $CONFIG ThreeQuads]} {
    set IBERT_CONFIG "ibert_kcu_3quads"
    set PROJECT_NAME project_3quads
    set TOP_GENERIC {NQUAD=3}
} elseif {[string equal $CONFIG OneQuad]} {
    set IBERT_CONFIG "ibert_kcu_1quad"
    set PROJECT_NAME project_1quad
    set TOP_GENERIC {NQUAD=1}
} else {
    set IBERT_CONFIG "ibert_odmb7_gth"
    set PROJECT_NAME project
    set TOP_GENERIC {NQUAD=3}
}

# Generate ip
set argv $FPGA_TYPE
set argc 1
# create ip project when needed
# source source/ip_generator.tcl

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
# add_files -norecurse "../source/clock_counting.vhd"

set_property generic $TOP_GENERIC [current_fileset]

# Add common IP core configurations
add_files -norecurse "../ip/$FPGA_TYPE/$IBERT_CONFIG/$IBERT_MODULE.xci"
add_files -norecurse "../ip/$FPGA_TYPE/clockManager/clockManager.xci"
add_files -norecurse "../ip/$FPGA_TYPE/vio_0/vio_0.xci"

# Add common constraint files
add_files -fileset constrs_1 -norecurse "../constraints/kcu105_pinout.xdc"
add_files -fileset constrs_1 -norecurse "../constraints/kcu105_clocks.xdc"
add_files -fileset constrs_1 -norecurse "../constraints/${IBERT_CONFIG}_ip.xdc"

# Set compile order for constraint files
set_property USED_IN_SYNTHESIS false [get_files ../constraints/${IBERT_CONFIG}_ip.xdc]
set_property PROCESSING_ORDER  LATE  [get_files ../constraints/${IBERT_CONFIG}_ip.xdc]

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value $TOP_MODULE -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj

# Set ip as global
set_property generate_synth_checkpoint false [get_files  ../ip/$FPGA_TYPE/$IBERT_CONFIG/$IBERT_MODULE.xci]
set_property generate_synth_checkpoint false [get_files  ../ip/$FPGA_TYPE/clockManager/clockManager.xci]
set_property generate_synth_checkpoint false [get_files  ../ip/$FPGA_TYPE/vio_0/vio_0.xci]
# set_property generate_synth_checkpoint false [get_files ../ip/$FPGA_TYPE/ila/ila.xci]

puts "\[Success\] Created project"
close_project
