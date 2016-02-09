// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2015.4
// Copyright (C) 2015 Xilinx Inc. All rights reserved.
// 
// ===========================================================

#ifndef _get_HH_
#define _get_HH_

#include "systemc.h"
#include "AESL_pkg.h"

#include "get_gmem_m_axi.h"

namespace ap_rtl {

template<unsigned int C_M_AXI_GMEM_ADDR_WIDTH = 32,
         unsigned int C_M_AXI_GMEM_ID_WIDTH = 1,
         unsigned int C_M_AXI_GMEM_AWUSER_WIDTH = 1,
         unsigned int C_M_AXI_GMEM_DATA_WIDTH = 32,
         unsigned int C_M_AXI_GMEM_WUSER_WIDTH = 1,
         unsigned int C_M_AXI_GMEM_ARUSER_WIDTH = 1,
         unsigned int C_M_AXI_GMEM_RUSER_WIDTH = 1,
         unsigned int C_M_AXI_GMEM_BUSER_WIDTH = 1>
struct get : public sc_module {
    // Port declarations 56
    sc_in_clk ap_clk;
    sc_in< sc_logic > ap_rst_n;
    sc_in< sc_logic > ap_start;
    sc_out< sc_logic > ap_done;
    sc_out< sc_logic > ap_idle;
    sc_out< sc_logic > ap_ready;
    sc_out< sc_logic > m_axi_gmem_AWVALID;
    sc_in< sc_logic > m_axi_gmem_AWREADY;
    sc_out< sc_uint<C_M_AXI_GMEM_ADDR_WIDTH> > m_axi_gmem_AWADDR;
    sc_out< sc_uint<C_M_AXI_GMEM_ID_WIDTH> > m_axi_gmem_AWID;
    sc_out< sc_lv<8> > m_axi_gmem_AWLEN;
    sc_out< sc_lv<3> > m_axi_gmem_AWSIZE;
    sc_out< sc_lv<2> > m_axi_gmem_AWBURST;
    sc_out< sc_lv<2> > m_axi_gmem_AWLOCK;
    sc_out< sc_lv<4> > m_axi_gmem_AWCACHE;
    sc_out< sc_lv<3> > m_axi_gmem_AWPROT;
    sc_out< sc_lv<4> > m_axi_gmem_AWQOS;
    sc_out< sc_lv<4> > m_axi_gmem_AWREGION;
    sc_out< sc_uint<C_M_AXI_GMEM_AWUSER_WIDTH> > m_axi_gmem_AWUSER;
    sc_out< sc_logic > m_axi_gmem_WVALID;
    sc_in< sc_logic > m_axi_gmem_WREADY;
    sc_out< sc_uint<C_M_AXI_GMEM_DATA_WIDTH> > m_axi_gmem_WDATA;
    sc_out< sc_uint<C_M_AXI_GMEM_DATA_WIDTH/8> > m_axi_gmem_WSTRB;
    sc_out< sc_logic > m_axi_gmem_WLAST;
    sc_out< sc_uint<C_M_AXI_GMEM_ID_WIDTH> > m_axi_gmem_WID;
    sc_out< sc_uint<C_M_AXI_GMEM_WUSER_WIDTH> > m_axi_gmem_WUSER;
    sc_out< sc_logic > m_axi_gmem_ARVALID;
    sc_in< sc_logic > m_axi_gmem_ARREADY;
    sc_out< sc_uint<C_M_AXI_GMEM_ADDR_WIDTH> > m_axi_gmem_ARADDR;
    sc_out< sc_uint<C_M_AXI_GMEM_ID_WIDTH> > m_axi_gmem_ARID;
    sc_out< sc_lv<8> > m_axi_gmem_ARLEN;
    sc_out< sc_lv<3> > m_axi_gmem_ARSIZE;
    sc_out< sc_lv<2> > m_axi_gmem_ARBURST;
    sc_out< sc_lv<2> > m_axi_gmem_ARLOCK;
    sc_out< sc_lv<4> > m_axi_gmem_ARCACHE;
    sc_out< sc_lv<3> > m_axi_gmem_ARPROT;
    sc_out< sc_lv<4> > m_axi_gmem_ARQOS;
    sc_out< sc_lv<4> > m_axi_gmem_ARREGION;
    sc_out< sc_uint<C_M_AXI_GMEM_ARUSER_WIDTH> > m_axi_gmem_ARUSER;
    sc_in< sc_logic > m_axi_gmem_RVALID;
    sc_out< sc_logic > m_axi_gmem_RREADY;
    sc_in< sc_uint<C_M_AXI_GMEM_DATA_WIDTH> > m_axi_gmem_RDATA;
    sc_in< sc_logic > m_axi_gmem_RLAST;
    sc_in< sc_uint<C_M_AXI_GMEM_ID_WIDTH> > m_axi_gmem_RID;
    sc_in< sc_uint<C_M_AXI_GMEM_RUSER_WIDTH> > m_axi_gmem_RUSER;
    sc_in< sc_lv<2> > m_axi_gmem_RRESP;
    sc_in< sc_logic > m_axi_gmem_BVALID;
    sc_out< sc_logic > m_axi_gmem_BREADY;
    sc_in< sc_lv<2> > m_axi_gmem_BRESP;
    sc_in< sc_uint<C_M_AXI_GMEM_ID_WIDTH> > m_axi_gmem_BID;
    sc_in< sc_uint<C_M_AXI_GMEM_BUSER_WIDTH> > m_axi_gmem_BUSER;
    sc_in< sc_lv<32> > data;
    sc_in< sc_lv<32> > key;
    sc_out< sc_lv<32> > val_r;
    sc_out< sc_logic > val_r_ap_vld;
    sc_out< sc_lv<32> > ap_return;


    // Module declarations
    get(sc_module_name name);
    SC_HAS_PROCESS(get);

    ~get();

    sc_trace_file* mVcdFile;

    ofstream mHdltvinHandle;
    ofstream mHdltvoutHandle;
    get_gmem_m_axi<32,32,5,C_M_AXI_GMEM_ID_WIDTH,C_M_AXI_GMEM_ADDR_WIDTH,C_M_AXI_GMEM_DATA_WIDTH,C_M_AXI_GMEM_AWUSER_WIDTH,C_M_AXI_GMEM_ARUSER_WIDTH,C_M_AXI_GMEM_WUSER_WIDTH,C_M_AXI_GMEM_RUSER_WIDTH,C_M_AXI_GMEM_BUSER_WIDTH,C_M_AXI_GMEM_USER_VALUE,C_M_AXI_GMEM_PROT_VALUE,C_M_AXI_GMEM_CACHE_VALUE>* get_gmem_m_axi_U;
    sc_signal< sc_logic > ap_rst_n_inv;
    sc_signal< sc_lv<9> > ap_CS_fsm;
    sc_signal< sc_logic > ap_sig_cseq_ST_st1_fsm_0;
    sc_signal< bool > ap_sig_bdd_27;
    sc_signal< sc_logic > gmem_AWVALID;
    sc_signal< sc_logic > gmem_AWREADY;
    sc_signal< sc_lv<32> > gmem_AWADDR;
    sc_signal< sc_lv<1> > gmem_AWID;
    sc_signal< sc_lv<32> > gmem_AWLEN;
    sc_signal< sc_lv<3> > gmem_AWSIZE;
    sc_signal< sc_lv<2> > gmem_AWBURST;
    sc_signal< sc_lv<2> > gmem_AWLOCK;
    sc_signal< sc_lv<4> > gmem_AWCACHE;
    sc_signal< sc_lv<3> > gmem_AWPROT;
    sc_signal< sc_lv<4> > gmem_AWQOS;
    sc_signal< sc_lv<4> > gmem_AWREGION;
    sc_signal< sc_lv<1> > gmem_AWUSER;
    sc_signal< sc_logic > gmem_WVALID;
    sc_signal< sc_logic > gmem_WREADY;
    sc_signal< sc_lv<32> > gmem_WDATA;
    sc_signal< sc_lv<4> > gmem_WSTRB;
    sc_signal< sc_logic > gmem_WLAST;
    sc_signal< sc_lv<1> > gmem_WID;
    sc_signal< sc_lv<1> > gmem_WUSER;
    sc_signal< sc_logic > gmem_ARVALID;
    sc_signal< sc_logic > gmem_ARREADY;
    sc_signal< sc_lv<32> > gmem_ARADDR;
    sc_signal< sc_lv<1> > gmem_ARID;
    sc_signal< sc_lv<32> > gmem_ARLEN;
    sc_signal< sc_lv<3> > gmem_ARSIZE;
    sc_signal< sc_lv<2> > gmem_ARBURST;
    sc_signal< sc_lv<2> > gmem_ARLOCK;
    sc_signal< sc_lv<4> > gmem_ARCACHE;
    sc_signal< sc_lv<3> > gmem_ARPROT;
    sc_signal< sc_lv<4> > gmem_ARQOS;
    sc_signal< sc_lv<4> > gmem_ARREGION;
    sc_signal< sc_lv<1> > gmem_ARUSER;
    sc_signal< sc_logic > gmem_RVALID;
    sc_signal< sc_logic > gmem_RREADY;
    sc_signal< sc_lv<32> > gmem_RDATA;
    sc_signal< sc_logic > gmem_RLAST;
    sc_signal< sc_lv<1> > gmem_RID;
    sc_signal< sc_lv<1> > gmem_RUSER;
    sc_signal< sc_lv<2> > gmem_RRESP;
    sc_signal< sc_logic > gmem_BVALID;
    sc_signal< sc_logic > gmem_BREADY;
    sc_signal< sc_lv<2> > gmem_BRESP;
    sc_signal< sc_lv<1> > gmem_BID;
    sc_signal< sc_lv<1> > gmem_BUSER;
    sc_signal< sc_logic > get_gmem_m_axi_U_ap_dummy_ce;
    sc_signal< sc_lv<32> > gmem_addr_reg_110;
    sc_signal< sc_lv<64> > data2_sum_cast_fu_100_p1;
    sc_signal< sc_logic > ap_reg_ioackin_gmem_ARREADY;
    sc_signal< sc_logic > ap_sig_ioackin_gmem_ARREADY;
    sc_signal< sc_logic > ap_sig_cseq_ST_st2_fsm_1;
    sc_signal< bool > ap_sig_bdd_182;
    sc_signal< sc_logic > ap_sig_cseq_ST_st9_fsm_8;
    sc_signal< bool > ap_sig_bdd_201;
    sc_signal< sc_lv<30> > tmp_fu_76_p4;
    sc_signal< sc_lv<33> > tmp_cast_fu_90_p1;
    sc_signal< sc_lv<33> > tmp_1_cast_fu_86_p1;
    sc_signal< sc_lv<33> > data2_sum_fu_94_p2;
    sc_signal< sc_lv<9> > ap_NS_fsm;
    static const sc_logic ap_const_logic_1;
    static const sc_logic ap_const_logic_0;
    static const sc_lv<9> ap_ST_st1_fsm_0;
    static const sc_lv<9> ap_ST_st2_fsm_1;
    static const sc_lv<9> ap_ST_st3_fsm_2;
    static const sc_lv<9> ap_ST_st4_fsm_3;
    static const sc_lv<9> ap_ST_st5_fsm_4;
    static const sc_lv<9> ap_ST_st6_fsm_5;
    static const sc_lv<9> ap_ST_st7_fsm_6;
    static const sc_lv<9> ap_ST_st8_fsm_7;
    static const sc_lv<9> ap_ST_st9_fsm_8;
    static const sc_lv<32> ap_const_lv32_0;
    static const sc_lv<1> ap_const_lv1_1;
    static const int C_M_AXI_DATA_WIDTH;
    static const int C_M_AXI_GMEM_USER_VALUE;
    static const int C_M_AXI_GMEM_PROT_VALUE;
    static const int C_M_AXI_GMEM_CACHE_VALUE;
    static const sc_lv<32> ap_const_lv32_1;
    static const sc_lv<1> ap_const_lv1_0;
    static const sc_lv<3> ap_const_lv3_0;
    static const sc_lv<2> ap_const_lv2_0;
    static const sc_lv<4> ap_const_lv4_0;
    static const sc_lv<32> ap_const_lv32_8;
    static const sc_lv<32> ap_const_lv32_2;
    static const sc_lv<32> ap_const_lv32_1F;
    // Thread declarations
    void thread_ap_clk_no_reset_();
    void thread_ap_done();
    void thread_ap_idle();
    void thread_ap_ready();
    void thread_ap_return();
    void thread_ap_rst_n_inv();
    void thread_ap_sig_bdd_182();
    void thread_ap_sig_bdd_201();
    void thread_ap_sig_bdd_27();
    void thread_ap_sig_cseq_ST_st1_fsm_0();
    void thread_ap_sig_cseq_ST_st2_fsm_1();
    void thread_ap_sig_cseq_ST_st9_fsm_8();
    void thread_ap_sig_ioackin_gmem_ARREADY();
    void thread_data2_sum_cast_fu_100_p1();
    void thread_data2_sum_fu_94_p2();
    void thread_get_gmem_m_axi_U_ap_dummy_ce();
    void thread_gmem_ARADDR();
    void thread_gmem_ARBURST();
    void thread_gmem_ARCACHE();
    void thread_gmem_ARID();
    void thread_gmem_ARLEN();
    void thread_gmem_ARLOCK();
    void thread_gmem_ARPROT();
    void thread_gmem_ARQOS();
    void thread_gmem_ARREGION();
    void thread_gmem_ARSIZE();
    void thread_gmem_ARUSER();
    void thread_gmem_ARVALID();
    void thread_gmem_AWADDR();
    void thread_gmem_AWBURST();
    void thread_gmem_AWCACHE();
    void thread_gmem_AWID();
    void thread_gmem_AWLEN();
    void thread_gmem_AWLOCK();
    void thread_gmem_AWPROT();
    void thread_gmem_AWQOS();
    void thread_gmem_AWREGION();
    void thread_gmem_AWSIZE();
    void thread_gmem_AWUSER();
    void thread_gmem_AWVALID();
    void thread_gmem_BREADY();
    void thread_gmem_RREADY();
    void thread_gmem_WDATA();
    void thread_gmem_WID();
    void thread_gmem_WLAST();
    void thread_gmem_WSTRB();
    void thread_gmem_WUSER();
    void thread_gmem_WVALID();
    void thread_tmp_1_cast_fu_86_p1();
    void thread_tmp_cast_fu_90_p1();
    void thread_tmp_fu_76_p4();
    void thread_val_r();
    void thread_val_r_ap_vld();
    void thread_ap_NS_fsm();
    void thread_hdltv_gen();
};

}

using namespace ap_rtl;

#endif
