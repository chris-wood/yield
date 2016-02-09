hsi::open_hw_design C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/p0/ipi/zc702.sdk/zc702.hdf
set hw_design [hsi::current_hw_design]
hsi::generate_bsp -dir C:/Users/sskalick/Xilinx/hash/hash/SDDebug/_sds/swstubs/standalone_bsp/scratch -hw ${hw_design} -os standalone -proc ps7_cortexa9_0
quit
