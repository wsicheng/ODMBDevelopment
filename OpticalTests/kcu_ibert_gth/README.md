# IBERT firmwares for KCU105
IBERT test in VHDL for KCU105, with different configurations using some shared code.

## Projects

### project_[N]quads
Project with all N quads configured to use the reference clock connect to that quad.
- Top file: `source/kcu_ibert_4quads.vhd`
- DAQ_SPY_SEL controlled by vio, but should always be 0
- SYSMON for MGT V/I monitoring

## Generator script
- `scripts/project_generator.tcl`: used to generate projects for different configs with setup on top

## To re-make the testbench project, run the below commands. The testbench is targeted for the KCU105 board.
~~~~bash
cd scripts # this step is needed
emacs -nw project_generator.tcl # edit the configure variables at the top
vivado -nojournal -nolog -mode batch -source project_generator.tcl
~~~~
