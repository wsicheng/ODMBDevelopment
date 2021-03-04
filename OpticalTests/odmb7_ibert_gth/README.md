# IBERT firmwares for ODMB7
IBERT test in VHDL for ODMB7, with different configurations using some shared code.


## Projects

### project
Original project with all 4 quads configured to use the single reference clock from REFCLK_3.
This one is currently not working with reason unknown.
- Top file: `source/odmb7_ucsb_dev.vhd`

### project_4quads_sepclks
Project with all 4 quads configured to use the reference clock connect to that quad.
- Top file: `source/odmb7_ibert_gth.vhd`
- DAQ_SPY_SEL controlled by vio
- LED blinking at frequency the clock / 2^26
  - LED map: 0: cmsclk, 1: sysclk80, 2: gp7, 3: mgtclk0_226, 4: mgtclk0_227, 5: gth_sysclk

### project_2quads_sepclks
Project with only quad_226 and quad_227 configured to use the reference clock REFCLK_3 and REFCLK_2.
- Top file: `source/odmb7_ibert_gth.vhd`
- DAQ_SPY_SEL controlled by vio
- LED blinking at frequency the clock / 2^26

### project_quad227
- Top file: `source/odmb7_ibert_q227.vhd`
Project with only quad_227 configured to use REFCLK_2.
- LED blinking at frequency the clock / 2^26

## Generator script
- `scripts/project_generator.tcl`: used to generate projects for different configs with setup on top
- `scripts/runScans.tcl`: automated script to create links and do eye scans, good for production test
- `scripts/ip_generator.tcl`: not updated, do not use this script

## To re-make the testbench project, run the below commands. The testbench is targeted for the KCU105 board.
~~~~bash
cd scripts # this step is needed
emacs -nw project_generator.tcl # edit the configure variables at the top
vivado -nojournal -nolog -mode batch -source project_generator.tcl
~~~~
