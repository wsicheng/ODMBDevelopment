# In the source directory run the below command
# vivado -nojournal -nolog -mode batch -source project_generator.tcl

# Environment variables
# set BOARD ODMB7
set BOARD KCU105

if {[string equal $BOARD ODMB7]} {
    set FPGA_TYPE xcku035-ffva1156-1-c; # for ODMB7
    set PROJECT_NAME project
} elseif {[string equal $BOARD KCU105]} {
    set FPGA_TYPE xcku040-ffva1156-2-e; # for KCU105
    set PROJECT_NAME kcu_project
}

# Generate ip
set argv $FPGA_TYPE
set argc 1
# create ip project when needed
# source ip_generator.tcl

# Create project
create_project kcu_gtwiz_test ../$PROJECT_NAME -part $FPGA_TYPE -force

# set_property target_language VHDL [current_project]
set_property target_language Verilog [current_project]
set_property target_simulator XSim [current_project]

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]

add_files "../source"
move_files -fileset sim_1 [get_files  ../source/gtwiz_kcu_fmc_sgb_example_top_sim.v]

# Add IP core configurations
add_files -norecurse  "../ip/$FPGA_TYPE/gtwiz_kcu_fmc_sgb/gtwiz_kcu_fmc_sgb.xci"
add_files -norecurse  "../ip/$FPGA_TYPE/gtwiz_kcu_fmc_sgb_vio_0/gtwiz_kcu_fmc_sgb_vio_0.xci"
add_files -norecurse  "../ip/$FPGA_TYPE/clk_mgr/clk_mgr.xci"
# add_files -norecurse   "../ip/$FPGA_TYPE/gtwiz_kcu_fmc_sgb_in_system_ibert_0/gtwiz_kcu_fmc_in_system_ibert_0.xci"
# add_files -norecurse  "../ip/$FPGA_TYPE/ila_00/ila_0.xci"

# Add constraint files
add_files -fileset constrs_1 -norecurse "../constraints/gtwiz_kcu_example.xdc"

# # Set 'sources_1' fileset properties
# set obj [get_filesets sources_1]
# set_property -name "top" -value "odmb7_ucsb_dev" -objects $obj
# set_property -name "top_auto_set" -value "0" -objects $obj
set_property file_type {Verilog Header} [get_files  ../source/gtwiz_kcu_fmc_sgb_example_wrapper_functions.v]

# Set ip as global
set_property generate_synth_checkpoint false [get_files  ../ip/$FPGA_TYPE/gtwiz_kcu_fmc_sgb/gtwiz_kcu_fmc_sgb.xci]
set_property generate_synth_checkpoint false [get_files  ../ip/$FPGA_TYPE/clk_mgr/clk_mgr.xci]
# set_property generate_synth_checkpoint false [get_files  ip/$FPGA_TYPE/ila_0/ila_0.xci]
# set_property generate_synth_checkpoint false [get_files  ip/$FPGA_TYPE/vio_0/vio_0.xci]

puts "\[Success\] Created project"
close_project
