# This script segment is generated automatically by AutoPilot

# clear list
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_begin
    cg_default_interface_gen_bundle_begin
    AESL_LIB_XILADAPTER::native_axis_begin
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 0 \
    name dest \
    type other \
    dir O \
    reset_level 1 \
    sync_rst true \
    corename dc_dest \
    op interface \
    ports { m_axi_dest_AWVALID { O 1 bit } m_axi_dest_AWREADY { I 1 bit } m_axi_dest_AWADDR { O 32 vector } m_axi_dest_AWID { O 1 vector } m_axi_dest_AWLEN { O 32 vector } m_axi_dest_AWSIZE { O 3 vector } m_axi_dest_AWBURST { O 2 vector } m_axi_dest_AWLOCK { O 2 vector } m_axi_dest_AWCACHE { O 4 vector } m_axi_dest_AWPROT { O 3 vector } m_axi_dest_AWQOS { O 4 vector } m_axi_dest_AWREGION { O 4 vector } m_axi_dest_AWUSER { O 1 vector } m_axi_dest_WVALID { O 1 bit } m_axi_dest_WREADY { I 1 bit } m_axi_dest_WDATA { O 32 vector } m_axi_dest_WSTRB { O 4 vector } m_axi_dest_WLAST { O 1 bit } m_axi_dest_WID { O 1 vector } m_axi_dest_WUSER { O 1 vector } m_axi_dest_ARVALID { O 1 bit } m_axi_dest_ARREADY { I 1 bit } m_axi_dest_ARADDR { O 32 vector } m_axi_dest_ARID { O 1 vector } m_axi_dest_ARLEN { O 32 vector } m_axi_dest_ARSIZE { O 3 vector } m_axi_dest_ARBURST { O 2 vector } m_axi_dest_ARLOCK { O 2 vector } m_axi_dest_ARCACHE { O 4 vector } m_axi_dest_ARPROT { O 3 vector } m_axi_dest_ARQOS { O 4 vector } m_axi_dest_ARREGION { O 4 vector } m_axi_dest_ARUSER { O 1 vector } m_axi_dest_RVALID { I 1 bit } m_axi_dest_RREADY { O 1 bit } m_axi_dest_RDATA { I 32 vector } m_axi_dest_RLAST { I 1 bit } m_axi_dest_RID { I 1 vector } m_axi_dest_RUSER { I 1 vector } m_axi_dest_RRESP { I 2 vector } m_axi_dest_BVALID { I 1 bit } m_axi_dest_BREADY { O 1 bit } m_axi_dest_BRESP { I 2 vector } m_axi_dest_BID { I 1 vector } m_axi_dest_BUSER { I 1 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 1 \
    name data1 \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_data1 \
    op interface \
    ports { data1 { I 30 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 2 \
    name tmp \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_tmp \
    op interface \
    ports { tmp { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id 3 \
    name src \
    type other \
    dir I \
    reset_level 1 \
    sync_rst true \
    corename dc_src \
    op interface \
    ports { src { I 32 vector } } \
} "
}

# Direct connection:
if {${::AESL::PGuard_autoexp_gen}} {
eval "cg_default_interface_gen_dc { \
    id -1 \
    name ap_ctrl \
    type ap_ctrl \
    reset_level 1 \
    sync_rst true \
    corename ap_ctrl \
    op interface \
    ports { ap_start { I 1 bit } ap_ready { O 1 bit } ap_done { O 1 bit } ap_idle { O 1 bit } } \
} "
}


# Adapter definition:
set PortName ap_clk
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_clock] == "cg_default_interface_gen_clock"} {
eval "cg_default_interface_gen_clock { \
    id -2 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_clk \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-113\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}


# Adapter definition:
set PortName ap_rst
set DataWd 1 
if {${::AESL::PGuard_autoexp_gen}} {
if {[info proc cg_default_interface_gen_reset] == "cg_default_interface_gen_reset"} {
eval "cg_default_interface_gen_reset { \
    id -3 \
    name ${PortName} \
    reset_level 1 \
    sync_rst true \
    corename apif_ap_rst \
    data_wd ${DataWd} \
    op interface \
}"
} else {
puts "@W \[IMPL-114\] Cannot find bus interface model in the library. Ignored generation of bus interface for '${PortName}'"
}
}



# merge
if {${::AESL::PGuard_autoexp_gen}} {
    cg_default_interface_gen_dc_end
    cg_default_interface_gen_bundle_end
    AESL_LIB_XILADAPTER::native_axis_end
}


