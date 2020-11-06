
# Connect to the Digilent Cable on localhost:3121
# open_hw_manager
# connect_hw_server -url localhost:3121 -allow_non_jtag
# current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210308AB0E6E]
# set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Digilent/210308AB0E6E]
# open_hw_target

# current_hw_device [get_hw_devices xcku040_0]
# refresh_hw_device [lindex [get_hw_devices xcku040_0] 0]

set programfpga [lindex $argv 0]
set bitfilename [lindex $argv 2]
# set nlinks [lindex $argv 1]
set tag [lindex $argv 3]

# if {$programfpga == 1} {
#  set_property PROGRAM.FILE $bitfilename.bit [get_hw_devices xcku040_0]
#  set_property PROBES.FILE $bitfilename.ltx [get_hw_devices xcku040_0]
#  set_property FULL_PROBES.FILE $bitfilename.ltx [get_hw_devices xcku040_0]
#  program_hw_devices [lindex [get_hw_devices] 0]
#  refresh_hw_device [lindex [get_hw_devices] 0]
# }


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

proc init_links_all {links} {
    set nlinks [llength $links]

    for {set ilink 0} {$ilink < $nlinks} {incr ilink} {
        set link [lindex $links $ilink]
        puts $link

        # Reset error count
        set_property LOGIC.MGT_ERRCNT_RESET_CTRL 1 [get_hw_sio_links $link]
        commit_hw_sio [get_hw_sio_links $link]
        set_property LOGIC.MGT_ERRCNT_RESET_CTRL 0 [get_hw_sio_links $link]
        commit_hw_sio [get_hw_sio_links $link]

        # Inject 1 error
        set_property LOGIC.ERR_INJECT_CTRL 1 [get_hw_sio_links $link]
        commit_hw_sio [get_hw_sio_links $link]
        set_property LOGIC.ERR_INJECT_CTRL 0 [get_hw_sio_links $link]
        commit_hw_sio [get_hw_sio_links $link]

        puts "Finishing resetting link: $ilink of $nlinks"
    }

    refresh_hw_sio $links
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
        # lappend scans [create_hw_sio_scan [lindex $links_txs $i]]
        set iscan [create_hw_sio_scan -description "Scan $i" 2d_full_eye [lindex [get_hw_sio_links [lindex $links $i]] 0 ]]
        set_property DWELL_BER 1e-8 [get_hw_sio_scans $iscan]
        run_hw_sio_scan [get_hw_sio_scans $iscan]
        sleep 15; # wait for 15 seconds
        
        set status [parse_report [get_hw_sio_scans $iscan] "STATUS" 3]
        while {[expr {$status ne "Done"}]} { sleep 5; }; # sleep 5 more seconds if not finished
        set open_area [parse_report [get_hw_sio_scans $iscan] "OPEN_AREA" 3]
        set open_prct [parse_report [get_hw_sio_scans $iscan] "OPEN_PERCENTAGE" 3]
        set vert_prct [parse_report [get_hw_sio_scans $iscan] "VERTICAL_PERCENTAGE" 3]
        set hori_prct [parse_report [get_hw_sio_scans $iscan] "HORIZONTAL_PERCENTAGE" 3]
        set outstr [format "link_%s: open area: %s, open precent: %s, horizon precent: %s%%, vertical percent: %s%%" $i $open_area $open_prct $vert_prct $hori_prct]

        puts "Found for scan $i of $nlinks:  $outstr"

        write_to_file $fname $outstr
    }
}

proc sleepm {N} { after [expr {int($N * 60000)}]; }; # sleep N minutes

# ====================================================
# Now start, with firmware loaded already
# ----------------------------------------------------

# Delete all the existing links, if any
remove_hw_sio_link [get_hw_sio_links]

# Set Up Link
set all_txs [get_hw_sio_txs]
set all_rxs [get_hw_sio_rxs]

set nrxs [llength $all_rxs]
set links [list]

for {set i 0} {$i < $nrxs} {incr i} {
    lappend links [create_hw_sio_link [lindex $all_txs $i] [lindex $all_rxs $i]]
}

set nlinks [llength $links]
puts "Established $nlinks links"

# First do an init
init_links_all $links

run_eyescans_all $links "test1"

# Do init again to prepare for BER values
init_links_all $links

# Loop over to record error after some sleep time
for {set i 0} {$i < 10} {incr i} {
    # sleep [expr {int($i * $i)}];    # sleep for i^2 seconds
    sleepm $i;    # sleep for i minutes
    record_BER_all $links "test1"
    puts "Finish the $i-th recording"
}


# close_hw_manager
