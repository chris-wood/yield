open_project set
set_top set
add_files C:/Users/sskalick/Xilinx/hash/hash/src/main.cpp -cflags "-IC:/Users/sskalick/Xilinx/hash/hash/src -Wall -O0 -g -fmessage-length=0 -MMD -MP -D __SDSCC__ -I C:/Xilinx/SDSoC/2015.4/arm-xilinx-eabi/include -IC:/Users/sskalick/Xilinx/hash/hash/src -D __SDSVHLS__ -I C:/Users/sskalick/Xilinx/hash/hash/SDDebug -w"
open_solution "solution" -reset
set_part { xc7z020clg484-1 }
# synthesis directives
create_clock -period 8.5
config_rtl -reset_level low
source C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/vhls/set.tcl
# end synthesis directives
csynth_design
export_design -acc
