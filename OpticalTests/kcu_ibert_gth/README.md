# Test firmware with IBERT 
This testbench uses the template from the [KintexUltraScale Testbench Template](https://github.com/odmb/odmbDevelopment)
Only the source folder is requried. Other folders can be generated using the generator tcl files.

This testbench is specific to test the reading and writing to the fifo generator, as well as being a learning project.

## File description 
- source/Firmware.vhd: Module
- source/Firmware_pkg.vhd: Pakage file that holds global variables
- source/Firmware_tb.vhd: Testbench for module
- source/Firmware_tb.xdc: Constraint file for testbench
- source/Firmware_tb.tcl: Simulation file
- source/data: COE data files for LUTs

## Generator files
- source/ip_generator.tcl: Tcl file that can generate IPs according to the FPGA
- source/tb_project_generator.tcl: Tcl file that can generate testbench Vivado project

## To re-make the testbench project, run the below commands. The testbench is targeted for the KCU105 board.
~~~~bash
cd source; vivado -nojournal -nolog -mode batch -source tb_project_generator.tcl
~~~~

## To re-make the ip cores, run one of the below command according to the FPGA target
~~~~bash
cd source; vivado -nojournal -nolog -mode batch -source ip_generator.tcl -tclargs xcku040-ffva1156-2-e
~~~~
