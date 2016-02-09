puts "Running ipi tcl"
puts "Running ipi tcl"
open_project C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/p0/ipi/zc702.xpr
set_param cg.skipHiddenCheck true
set_property ip_repo_paths {C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/iprepo/repo C:/Xilinx/SDSoC/2015.4/data/ip/xilinx} [current_fileset]
set_param bd.skipSupportedIPCheck true
update_ip_catalog -rebuild
close_project
open_project C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/p0/ipi/zc702.xpr
set_param bd.get_bd_obj.warning_on_empty_result true
set_param bd.propagate.allow_set_readonly_param true
source top.bd.tcl
regenerate_bd_layout
save_bd_design
report_ip_status
validate_bd_design
generate_target all [get_files *.bd]
# ***************************************************
# Run synthesis and implementation
# ***************************************************
set_property STEPS.OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
set_property STEPS.OPT_DESIGN.ARGS.DIRECTIVE Default [get_runs impl_1]
reset_run synth_1
launch_runs synth_1
wait_on_run synth_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1
# ***************************************************
# Save bitstream for SD card creation
# ***************************************************
set bitstream [get_property top [current_fileset]].bit
set directory [get_property directory [current_run]]
file copy -force [file join $directory $bitstream] [file join $directory bitstream.bit]
open_bd_design [get_files *.bd]
upgrade_ip [get_ips]
open_run impl_1
file mkdir C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/p0/ipi/zc702.sdk
write_hwdef -force -file C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/p0/ipi/zc702.sdk/zc702.hdf
