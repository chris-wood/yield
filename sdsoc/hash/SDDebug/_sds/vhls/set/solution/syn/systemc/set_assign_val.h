// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2015.4
// Copyright (C) 2015 Xilinx Inc. All rights reserved.
// 
// ===========================================================

#ifndef _set_assign_val_HH_
#define _set_assign_val_HH_

#include "systemc.h"
#include "AESL_pkg.h"


namespace ap_rtl {

struct set_assign_val : public sc_module {
    // Port declarations 54
    sc_in_clk ap_clk;
    sc_in< sc_logic > ap_rst;
    sc_in< sc_logic > ap_start;
    sc_out< sc_logic > ap_done;
    sc_out< sc_logic > ap_idle;
    sc_out< sc_logic > ap_ready;
    sc_out< sc_logic > m_axi_dest_AWVALID;
    sc_in< sc_logic > m_axi_dest_AWREADY;
    sc_out< sc_lv<32> > m_axi_dest_AWADDR;
    sc_out< sc_lv<1> > m_axi_dest_AWID;
    sc_out< sc_lv<32> > m_axi_dest_AWLEN;
    sc_out< sc_lv<3> > m_axi_dest_AWSIZE;
    sc_out< sc_lv<2> > m_axi_dest_AWBURST;
    sc_out< sc_lv<2> > m_axi_dest_AWLOCK;
    sc_out< sc_lv<4> > m_axi_dest_AWCACHE;
    sc_out< sc_lv<3> > m_axi_dest_AWPROT;
    sc_out< sc_lv<4> > m_axi_dest_AWQOS;
    sc_out< sc_lv<4> > m_axi_dest_AWREGION;
    sc_out< sc_lv<1> > m_axi_dest_AWUSER;
    sc_out< sc_logic > m_axi_dest_WVALID;
    sc_in< sc_logic > m_axi_dest_WREADY;
    sc_out< sc_lv<32> > m_axi_dest_WDATA;
    sc_out< sc_lv<4> > m_axi_dest_WSTRB;
    sc_out< sc_logic > m_axi_dest_WLAST;
    sc_out< sc_lv<1> > m_axi_dest_WID;
    sc_out< sc_lv<1> > m_axi_dest_WUSER;
    sc_out< sc_logic > m_axi_dest_ARVALID;
    sc_in< sc_logic > m_axi_dest_ARREADY;
    sc_out< sc_lv<32> > m_axi_dest_ARADDR;
    sc_out< sc_lv<1> > m_axi_dest_ARID;
    sc_out< sc_lv<32> > m_axi_dest_ARLEN;
    sc_out< sc_lv<3> > m_axi_dest_ARSIZE;
    sc_out< sc_lv<2> > m_axi_dest_ARBURST;
    sc_out< sc_lv<2> > m_axi_dest_ARLOCK;
    sc_out< sc_lv<4> > m_axi_dest_ARCACHE;
    sc_out< sc_lv<3> > m_axi_dest_ARPROT;
    sc_out< sc_lv<4> > m_axi_dest_ARQOS;
    sc_out< sc_lv<4> > m_axi_dest_ARREGION;
    sc_out< sc_lv<1> > m_axi_dest_ARUSER;
    sc_in< sc_logic > m_axi_dest_RVALID;
    sc_out< sc_logic > m_axi_dest_RREADY;
    sc_in< sc_lv<32> > m_axi_dest_RDATA;
    sc_in< sc_logic > m_axi_dest_RLAST;
    sc_in< sc_lv<1> > m_axi_dest_RID;
    sc_in< sc_lv<1> > m_axi_dest_RUSER;
    sc_in< sc_lv<2> > m_axi_dest_RRESP;
    sc_in< sc_logic > m_axi_dest_BVALID;
    sc_out< sc_logic > m_axi_dest_BREADY;
    sc_in< sc_lv<2> > m_axi_dest_BRESP;
    sc_in< sc_lv<1> > m_axi_dest_BID;
    sc_in< sc_lv<1> > m_axi_dest_BUSER;
    sc_in< sc_lv<30> > data1;
    sc_in< sc_lv<32> > tmp;
    sc_in< sc_lv<32> > src;


    // Module declarations
    set_assign_val(sc_module_name name);
    SC_HAS_PROCESS(set_assign_val);

    ~set_assign_val();

    sc_trace_file* mVcdFile;

    sc_signal< sc_lv<8> > ap_CS_fsm;
    sc_signal< sc_logic > ap_sig_cseq_ST_st1_fsm_0;
    sc_signal< bool > ap_sig_bdd_26;
    sc_signal< sc_lv<32> > dest_addr_reg_86;
    sc_signal< sc_lv<64> > sum_cast_fu_76_p1;
    sc_signal< sc_logic > ap_reg_ioackin_m_axi_dest_AWREADY;
    sc_signal< sc_logic > ap_sig_ioackin_m_axi_dest_AWREADY;
    sc_signal< sc_logic > ap_sig_cseq_ST_st2_fsm_1;
    sc_signal< bool > ap_sig_bdd_103;
    sc_signal< sc_logic > ap_reg_ioackin_m_axi_dest_WREADY;
    sc_signal< sc_logic > ap_sig_ioackin_m_axi_dest_WREADY;
    sc_signal< sc_logic > ap_sig_cseq_ST_st3_fsm_2;
    sc_signal< bool > ap_sig_bdd_120;
    sc_signal< sc_logic > ap_sig_cseq_ST_st8_fsm_7;
    sc_signal< bool > ap_sig_bdd_136;
    sc_signal< sc_lv<33> > tmp_cast_cast_fu_62_p1;
    sc_signal< sc_lv<33> > sext_cast_fu_66_p1;
    sc_signal< sc_lv<33> > sum_fu_70_p2;
    sc_signal< sc_lv<8> > ap_NS_fsm;
    static const sc_logic ap_const_logic_1;
    static const sc_logic ap_const_logic_0;
    static const sc_lv<8> ap_ST_st1_fsm_0;
    static const sc_lv<8> ap_ST_st2_fsm_1;
    static const sc_lv<8> ap_ST_st3_fsm_2;
    static const sc_lv<8> ap_ST_st4_fsm_3;
    static const sc_lv<8> ap_ST_st5_fsm_4;
    static const sc_lv<8> ap_ST_st6_fsm_5;
    static const sc_lv<8> ap_ST_st7_fsm_6;
    static const sc_lv<8> ap_ST_st8_fsm_7;
    static const sc_lv<32> ap_const_lv32_0;
    static const sc_lv<1> ap_const_lv1_1;
    static const sc_lv<1> ap_const_lv1_0;
    static const sc_lv<3> ap_const_lv3_0;
    static const sc_lv<2> ap_const_lv2_0;
    static const sc_lv<4> ap_const_lv4_0;
    static const sc_lv<32> ap_const_lv32_1;
    static const sc_lv<32> ap_const_lv32_2;
    static const sc_lv<4> ap_const_lv4_F;
    static const sc_lv<32> ap_const_lv32_7;
    // Thread declarations
    void thread_ap_clk_no_reset_();
    void thread_ap_done();
    void thread_ap_idle();
    void thread_ap_ready();
    void thread_ap_sig_bdd_103();
    void thread_ap_sig_bdd_120();
    void thread_ap_sig_bdd_136();
    void thread_ap_sig_bdd_26();
    void thread_ap_sig_cseq_ST_st1_fsm_0();
    void thread_ap_sig_cseq_ST_st2_fsm_1();
    void thread_ap_sig_cseq_ST_st3_fsm_2();
    void thread_ap_sig_cseq_ST_st8_fsm_7();
    void thread_ap_sig_ioackin_m_axi_dest_AWREADY();
    void thread_ap_sig_ioackin_m_axi_dest_WREADY();
    void thread_m_axi_dest_ARADDR();
    void thread_m_axi_dest_ARBURST();
    void thread_m_axi_dest_ARCACHE();
    void thread_m_axi_dest_ARID();
    void thread_m_axi_dest_ARLEN();
    void thread_m_axi_dest_ARLOCK();
    void thread_m_axi_dest_ARPROT();
    void thread_m_axi_dest_ARQOS();
    void thread_m_axi_dest_ARREGION();
    void thread_m_axi_dest_ARSIZE();
    void thread_m_axi_dest_ARUSER();
    void thread_m_axi_dest_ARVALID();
    void thread_m_axi_dest_AWADDR();
    void thread_m_axi_dest_AWBURST();
    void thread_m_axi_dest_AWCACHE();
    void thread_m_axi_dest_AWID();
    void thread_m_axi_dest_AWLEN();
    void thread_m_axi_dest_AWLOCK();
    void thread_m_axi_dest_AWPROT();
    void thread_m_axi_dest_AWQOS();
    void thread_m_axi_dest_AWREGION();
    void thread_m_axi_dest_AWSIZE();
    void thread_m_axi_dest_AWUSER();
    void thread_m_axi_dest_AWVALID();
    void thread_m_axi_dest_BREADY();
    void thread_m_axi_dest_RREADY();
    void thread_m_axi_dest_WDATA();
    void thread_m_axi_dest_WID();
    void thread_m_axi_dest_WLAST();
    void thread_m_axi_dest_WSTRB();
    void thread_m_axi_dest_WUSER();
    void thread_m_axi_dest_WVALID();
    void thread_sext_cast_fu_66_p1();
    void thread_sum_cast_fu_76_p1();
    void thread_sum_fu_70_p2();
    void thread_tmp_cast_cast_fu_62_p1();
    void thread_ap_NS_fsm();
};

}

using namespace ap_rtl;

#endif