##################################################################################
# Script to automize the checks on the optical links with IBERT for ODMB7
##################################################################################

# ----------------------------------------------------------------------------------
# Constants
# ----------------------------------------------------------------------------------
set DEVICE_NAME {xcku040_0}
set PRBS_PATTERN {PRBS 31-bit}

# ----------------------------------------------------------------------------------
# Optional parameters
# ----------------------------------------------------------------------------------
# set programfpga [lindex $argv 0]
# set bitfilename [lindex $argv 1]
# set tag [lindex $argv 3]
set programfpga 0
set bitfilename {}
set disable_spy_tx 0
set tag "test2"

# # Connect to the Digilent Cable on localhost:3121
# open_hw_manager
# connect_hw_server -url localhost:3121 -allow_non_jtag
# current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210308AB0E6E]
# set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Digilent/210308AB0E6E]
# open_hw_target
# current_hw_device [get_hw_devices xcku040_0]
# refresh_hw_device [lindex [get_hw_devices xcku040_0] 0]

# Load frimeware
if {$programfpga == 1} {
    set_property PROGRAM.FILE $bitfilename.bit [get_hw_devices $DEVICE_NAME]
    set_property PROBES.FILE $bitfilename.ltx [get_hw_devices $DEVICE_NAME]
    set_property FULL_PROBES.FILE $bitfilename.ltx [get_hw_devices $DEVICE_NAME]
    program_hw_devices [lindex [get_hw_devices] 0]
    refresh_hw_device [lindex [get_hw_devices] 0]
}

if ($disable_spy_tx) {
    set_property PORT.TXPD 3 [get_hw_sio_gts localhost:.../Quad_226/MGT_X0Y11]
    commit_hw_sio [get_hw_sio_gts localhost:.../Quad_226/MGT_X0Y121]

    startgroup
    set_property OUTPUT_VALUE 0 [get_hw_probes DAQ_SPY_SEL -of_objects [get_hw_vios -of_objects [get_hw_devices $DEVICE_NAME] -filter {CELL_NAME=~"vio_i"}]]
    commit_hw_vio [get_hw_probes {DAQ_SPY_SEL} -of_objects [get_hw_vios -of_objects [get_hw_devices $DEVICE_NAME] -filter {CELL_NAME=~"vio_i"}]]
    endgroup
} else {
    startgroup
    set_property OUTPUT_VALUE 1 [get_hw_probes DAQ_SPY_SEL -of_objects [get_hw_vios -of_objects [get_hw_devices $DEVICE_NAME] -filter {CELL_NAME=~"vio_i"}]]
    commit_hw_vio [get_hw_probes {DAQ_SPY_SEL} -of_objects [get_hw_vios -of_objects [get_hw_devices $DEVICE_NAME] -filter {CELL_NAME=~"vio_i"}]]
    endgroup
}

# ----------------------------------------------------------------------------------
# Helper function definitions
# ----------------------------------------------------------------------------------

proc parse_report {objname propertyname index} {
    # =================================================================
    # Format of the return info consist as follows, this function returns only the value
    # ----------------------------------------------------------------
    # Property              Type    Read-only  Value
    # RX_BER                string  true       1.2844469155632799e-13
    # RX_RECEIVED_BIT_COUNT string  true       113905209031560
    # RX_PATTERN            enum    false      PRBS 7-bit
    # =================================================================

    set fullrep [split [report_property $objname $propertyname -return_string] "\n"]
    set valline [lindex $fullrep 1]
    set result [lindex [regexp -all -inline {\S+} $valline] $index]

    return $result 
}

proc reset_links_all {links} {
    # Reset error count
    set_property LOGIC.MGT_ERRCNT_RESET_CTRL 1 [get_hw_sio_links $links]
    commit_hw_sio [get_hw_sio_links $links]
    set_property LOGIC.MGT_ERRCNT_RESET_CTRL 0 [get_hw_sio_links $links]
    commit_hw_sio [get_hw_sio_links $links]

    # Inject 1 error
    set_property LOGIC.ERR_INJECT_CTRL 1 [get_hw_sio_links $links]
    commit_hw_sio [get_hw_sio_links $links]
    set_property LOGIC.ERR_INJECT_CTRL 0 [get_hw_sio_links $links]
    commit_hw_sio [get_hw_sio_links $links]

    refresh_hw_sio $links
    puts "Finishing resetting link: $ilink of $nlinks"
}

proc write_to_file {fname outstr} {
    # get current time with microseconds precision:
    set val [clock microseconds]
    # extract time with seconds precision:
    set seconds_precision [expr { $val / 1000000 }]
    set currenttime [format "%s" [clock format $seconds_precision -format "%Y-%m-%d %H:%M:%S"]]
    
    # write to file
    set outfile [open $fname a+]
    puts $outfile "$currenttime $outstr" 
    close $outfile
}

proc record_BER_all {links tag} {
    set nlinks [llength $links]
    refresh_hw_sio $links

    for {set ilink 0} {$ilink < $nlinks} {incr ilink} {

        set link [lindex $links $ilink]
        # record bit error rate, number of bits received, prbs pattern
        set RX_BER [parse_report [get_hw_sio_links $link] "RX_BER" 3]
        set RX_bits [parse_report [get_hw_sio_links $link] "RX_RECEIVED_BIT_COUNT" 3]
        set err_count [parse_report [get_hw_sio_links $link] "LOGIC.ERRBIT_COUNT" 3]
        set RX_pattern [parse_report [get_hw_sio_links $link] "RX_PATTERN" 4]

        set outstr "$RX_BER $RX_bits $err_count $RX_pattern"
        puts "Found for link $ilink of $nlinks:  $outstr"
        
        set fname [format "reports/report_%s_link%s.out" $tag $ilink]
        write_to_file $fname $outstr
    }
}

proc sleep  {N} { after [expr {int($N * 1000)}]; }

proc run_eyescans_all {links tag} {
    # =================================================================
    # line | Full report of parse_report sio_scan
    # ----------------------------------------------------------------
    # 0    | Property                          Type    Read-only  Value
    # 1    | CLASS                             string  true       hw_sio_scan
    # 2    | DATA_READY                        bool    true       1
    # 7    | DWELL_BER                         enum    false      1e-8
    # 10   | HORIZONTAL_OPENING                string  true       49
    # 11   | HORIZONTAL_PERCENTAGE             string  true       77.78
    # 17   | OPEN_AREA                         string  true       8192
    # 18   | OPEN_PERCENTAGE                   string  true       45
    # 19   | PROGRESS                          string  true       100%
    # 23   | STATUS                            string  true       Done
    # 24   | SWEEP                             string  true       
    # 26   | VERTICAL_OPENING                  string  true       201
    # 27   | VERTICAL_PERCENTAGE               string  true       83.87
    # ----------------------------------------------------------------

    # Make a clean first if any scans left
    remove_hw_sio_scan [get_hw_sio_scans]

    set nlinks [llength $links]
    set fname [format "reports/report_%s_scans.out" $tag]

    for {set i 0} {$i < $nlinks} {incr i} {
        # Check the link is up first
        set link_status [parse_report [lindex [get_hw_sio_links [lindex $links $i]] 0 ] "STATUS" 3]
        if {[expr {$link_status eq "NO"}]} {
            puts "Skiping link $i as there's no link."
            continue;
        }
        # Create the Scan, set the DWELL
        set iscan [create_hw_sio_scan -description "Scan $i" 2d_full_eye [lindex [get_hw_sio_links [lindex $links $i]] 0 ]]
        set_property DWELL_BER 1e-8 [get_hw_sio_scans $iscan]
        run_hw_sio_scan [get_hw_sio_scans $iscan]

        # Wait at least for 15 seconds for it to run, check status to see if more time needed
        sleep 15;
        set status [parse_report [get_hw_sio_scans $iscan] "STATUS" 3]
        while {[expr {$status ne "Done"}]} {
            sleep 5;
            set status [parse_report [get_hw_sio_scans $iscan] "STATUS" 3]
        };

        # Create report
        set open_area [parse_report [get_hw_sio_scans $iscan] "OPEN_AREA" 3]
        set open_prct [parse_report [get_hw_sio_scans $iscan] "OPEN_PERCENTAGE" 3]
        set vert_prct [parse_report [get_hw_sio_scans $iscan] "VERTICAL_PERCENTAGE" 3]
        set hori_prct [parse_report [get_hw_sio_scans $iscan] "HORIZONTAL_PERCENTAGE" 3]
        set outstr [format "link_%s: open area: %s, open precent: %s, horizon precent: %s%%, vertical percent: %s%%" $i $open_area $open_prct $vert_prct $hori_prct]

        puts "Scan of link $i of $nlinks:  $outstr"

        write_to_file $fname $outstr
    }
}

proc sleepm {N} { after [expr {int($N * 60000)}]; }; # sleep N minutes

# ----------------------------------------------------------------------------------
# Test start, with firmware loaded already
# ----------------------------------------------------------------------------------

# Delete all the existing links, if any
remove_hw_sio_link [get_hw_sio_links]

# Set Up Link
set all_txs [get_hw_sio_txs]
set all_rxs [get_hw_sio_rxs]

set nrxs [llength $all_rxs]
set links [list]

for {set i 0} {$i < $nrxs} {incr i} {
    set link [create_hw_sio_link [lindex $all_txs $i] [lindex $all_rxs $i]]
    set link_status [parse_report [lindex [get_hw_sio_links $link] 0 ] "STATUS" 3]
    if {[expr {$link_status ne "NO"}]} {
        lappend links [lindex [get_hw_sio_links $link] 0 ]
    } else {
        puts "Skiping link $i as there's no link."
    }
}

set nlinks [llength $links]
puts "Established $nlinks links"

# Set the PRBS pattern to $PRBS_PATTERN defined at the top (default 31-bit)
set_property RX_PATTERN $PRBS_PATTERN [get_hw_sio_links $links]
set_property TX_PATTERN $PRBS_PATTERN [get_hw_sio_links $links]
commit_hw_sio [get_hw_sio_links $links]

# First do an init
reset_links_all $links

run_eyescans_all $links $tag

# Do init again to prepare for BER values
reset_links_all $links

# Loop over to record error after some sleep time
for {set i 0} {$i < 10} {incr i} {
    # sleep [expr {int($i * $i)}];    # sleep for i^2 seconds
    sleepm $i;    # sleep for i minutes
    record_BER_all $links $tag
    puts "Finish the $i-th recording"
}


# close_hw_manager
