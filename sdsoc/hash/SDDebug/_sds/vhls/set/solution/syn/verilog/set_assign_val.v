// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2015.4
// Copyright (C) 2015 Xilinx Inc. All rights reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module set_assign_val (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        m_axi_dest_AWVALID,
        m_axi_dest_AWREADY,
        m_axi_dest_AWADDR,
        m_axi_dest_AWID,
        m_axi_dest_AWLEN,
        m_axi_dest_AWSIZE,
        m_axi_dest_AWBURST,
        m_axi_dest_AWLOCK,
        m_axi_dest_AWCACHE,
        m_axi_dest_AWPROT,
        m_axi_dest_AWQOS,
        m_axi_dest_AWREGION,
        m_axi_dest_AWUSER,
        m_axi_dest_WVALID,
        m_axi_dest_WREADY,
        m_axi_dest_WDATA,
        m_axi_dest_WSTRB,
        m_axi_dest_WLAST,
        m_axi_dest_WID,
        m_axi_dest_WUSER,
        m_axi_dest_ARVALID,
        m_axi_dest_ARREADY,
        m_axi_dest_ARADDR,
        m_axi_dest_ARID,
        m_axi_dest_ARLEN,
        m_axi_dest_ARSIZE,
        m_axi_dest_ARBURST,
        m_axi_dest_ARLOCK,
        m_axi_dest_ARCACHE,
        m_axi_dest_ARPROT,
        m_axi_dest_ARQOS,
        m_axi_dest_ARREGION,
        m_axi_dest_ARUSER,
        m_axi_dest_RVALID,
        m_axi_dest_RREADY,
        m_axi_dest_RDATA,
        m_axi_dest_RLAST,
        m_axi_dest_RID,
        m_axi_dest_RUSER,
        m_axi_dest_RRESP,
        m_axi_dest_BVALID,
        m_axi_dest_BREADY,
        m_axi_dest_BRESP,
        m_axi_dest_BID,
        m_axi_dest_BUSER,
        data1,
        tmp,
        src
);

parameter    ap_const_logic_1 = 1'b1;
parameter    ap_const_logic_0 = 1'b0;
parameter    ap_ST_st1_fsm_0 = 8'b1;
parameter    ap_ST_st2_fsm_1 = 8'b10;
parameter    ap_ST_st3_fsm_2 = 8'b100;
parameter    ap_ST_st4_fsm_3 = 8'b1000;
parameter    ap_ST_st5_fsm_4 = 8'b10000;
parameter    ap_ST_st6_fsm_5 = 8'b100000;
parameter    ap_ST_st7_fsm_6 = 8'b1000000;
parameter    ap_ST_st8_fsm_7 = 8'b10000000;
parameter    ap_const_lv32_0 = 32'b00000000000000000000000000000000;
parameter    ap_const_lv1_1 = 1'b1;
parameter    ap_const_lv1_0 = 1'b0;
parameter    ap_const_lv3_0 = 3'b000;
parameter    ap_const_lv2_0 = 2'b00;
parameter    ap_const_lv4_0 = 4'b0000;
parameter    ap_const_lv32_1 = 32'b1;
parameter    ap_const_lv32_2 = 32'b10;
parameter    ap_const_lv4_F = 4'b1111;
parameter    ap_const_lv32_7 = 32'b111;
parameter    ap_true = 1'b1;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output   m_axi_dest_AWVALID;
input   m_axi_dest_AWREADY;
output  [31:0] m_axi_dest_AWADDR;
output  [0:0] m_axi_dest_AWID;
output  [31:0] m_axi_dest_AWLEN;
output  [2:0] m_axi_dest_AWSIZE;
output  [1:0] m_axi_dest_AWBURST;
output  [1:0] m_axi_dest_AWLOCK;
output  [3:0] m_axi_dest_AWCACHE;
output  [2:0] m_axi_dest_AWPROT;
output  [3:0] m_axi_dest_AWQOS;
output  [3:0] m_axi_dest_AWREGION;
output  [0:0] m_axi_dest_AWUSER;
output   m_axi_dest_WVALID;
input   m_axi_dest_WREADY;
output  [31:0] m_axi_dest_WDATA;
output  [3:0] m_axi_dest_WSTRB;
output   m_axi_dest_WLAST;
output  [0:0] m_axi_dest_WID;
output  [0:0] m_axi_dest_WUSER;
output   m_axi_dest_ARVALID;
input   m_axi_dest_ARREADY;
output  [31:0] m_axi_dest_ARADDR;
output  [0:0] m_axi_dest_ARID;
output  [31:0] m_axi_dest_ARLEN;
output  [2:0] m_axi_dest_ARSIZE;
output  [1:0] m_axi_dest_ARBURST;
output  [1:0] m_axi_dest_ARLOCK;
output  [3:0] m_axi_dest_ARCACHE;
output  [2:0] m_axi_dest_ARPROT;
output  [3:0] m_axi_dest_ARQOS;
output  [3:0] m_axi_dest_ARREGION;
output  [0:0] m_axi_dest_ARUSER;
input   m_axi_dest_RVALID;
output   m_axi_dest_RREADY;
input  [31:0] m_axi_dest_RDATA;
input   m_axi_dest_RLAST;
input  [0:0] m_axi_dest_RID;
input  [0:0] m_axi_dest_RUSER;
input  [1:0] m_axi_dest_RRESP;
input   m_axi_dest_BVALID;
output   m_axi_dest_BREADY;
input  [1:0] m_axi_dest_BRESP;
input  [0:0] m_axi_dest_BID;
input  [0:0] m_axi_dest_BUSER;
input  [29:0] data1;
input  [31:0] tmp;
input  [31:0] src;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg m_axi_dest_AWVALID;
reg m_axi_dest_WVALID;
reg m_axi_dest_BREADY;
(* fsm_encoding = "none" *) reg   [7:0] ap_CS_fsm = 8'b1;
reg    ap_sig_cseq_ST_st1_fsm_0;
reg    ap_sig_bdd_26;
reg   [31:0] dest_addr_reg_86;
wire   [63:0] sum_cast_fu_76_p1;
reg    ap_reg_ioackin_m_axi_dest_AWREADY = 1'b0;
reg    ap_sig_ioackin_m_axi_dest_AWREADY;
reg    ap_sig_cseq_ST_st2_fsm_1;
reg    ap_sig_bdd_103;
reg    ap_reg_ioackin_m_axi_dest_WREADY = 1'b0;
reg    ap_sig_ioackin_m_axi_dest_WREADY;
reg    ap_sig_cseq_ST_st3_fsm_2;
reg    ap_sig_bdd_120;
reg    ap_sig_cseq_ST_st8_fsm_7;
reg    ap_sig_bdd_136;
wire   [32:0] tmp_cast_cast_fu_62_p1;
wire   [32:0] sext_cast_fu_66_p1;
wire   [32:0] sum_fu_70_p2;
reg   [7:0] ap_NS_fsm;




always @ (posedge ap_clk) begin : ap_ret_ap_CS_fsm
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_st1_fsm_0;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin : ap_ret_ap_reg_ioackin_m_axi_dest_AWREADY
    if (ap_rst == 1'b1) begin
        ap_reg_ioackin_m_axi_dest_AWREADY <= ap_const_logic_0;
    end else begin
        if ((ap_const_logic_1 == ap_sig_cseq_ST_st2_fsm_1)) begin
            if (~(ap_const_logic_0 == ap_sig_ioackin_m_axi_dest_AWREADY)) begin
                ap_reg_ioackin_m_axi_dest_AWREADY <= ap_const_logic_0;
            end else if ((ap_const_logic_1 == m_axi_dest_AWREADY)) begin
                ap_reg_ioackin_m_axi_dest_AWREADY <= ap_const_logic_1;
            end
        end
    end
end

always @ (posedge ap_clk) begin : ap_ret_ap_reg_ioackin_m_axi_dest_WREADY
    if (ap_rst == 1'b1) begin
        ap_reg_ioackin_m_axi_dest_WREADY <= ap_const_logic_0;
    end else begin
        if ((ap_const_logic_1 == ap_sig_cseq_ST_st3_fsm_2)) begin
            if (~(ap_const_logic_0 == ap_sig_ioackin_m_axi_dest_WREADY)) begin
                ap_reg_ioackin_m_axi_dest_WREADY <= ap_const_logic_0;
            end else if ((ap_const_logic_1 == m_axi_dest_WREADY)) begin
                ap_reg_ioackin_m_axi_dest_WREADY <= ap_const_logic_1;
            end
        end
    end
end

always @ (posedge ap_clk) begin
    if (((ap_const_logic_1 == ap_sig_cseq_ST_st1_fsm_0) & ~(ap_start == ap_const_logic_0))) begin
        dest_addr_reg_86 <= sum_cast_fu_76_p1;
    end
end

always @ (ap_start or ap_sig_cseq_ST_st1_fsm_0 or m_axi_dest_BVALID or ap_sig_cseq_ST_st8_fsm_7) begin
    if (((~(ap_const_logic_1 == ap_start) & (ap_const_logic_1 == ap_sig_cseq_ST_st1_fsm_0)) | ((ap_const_logic_1 == ap_sig_cseq_ST_st8_fsm_7) & ~(m_axi_dest_BVALID == ap_const_logic_0)))) begin
        ap_done = ap_const_logic_1;
    end else begin
        ap_done = ap_const_logic_0;
    end
end

always @ (ap_start or ap_sig_cseq_ST_st1_fsm_0) begin
    if ((~(ap_const_logic_1 == ap_start) & (ap_const_logic_1 == ap_sig_cseq_ST_st1_fsm_0))) begin
        ap_idle = ap_const_logic_1;
    end else begin
        ap_idle = ap_const_logic_0;
    end
end

always @ (m_axi_dest_BVALID or ap_sig_cseq_ST_st8_fsm_7) begin
    if (((ap_const_logic_1 == ap_sig_cseq_ST_st8_fsm_7) & ~(m_axi_dest_BVALID == ap_const_logic_0))) begin
        ap_ready = ap_const_logic_1;
    end else begin
        ap_ready = ap_const_logic_0;
    end
end

always @ (ap_sig_bdd_26) begin
    if (ap_sig_bdd_26) begin
        ap_sig_cseq_ST_st1_fsm_0 = ap_const_logic_1;
    end else begin
        ap_sig_cseq_ST_st1_fsm_0 = ap_const_logic_0;
    end
end

always @ (ap_sig_bdd_103) begin
    if (ap_sig_bdd_103) begin
        ap_sig_cseq_ST_st2_fsm_1 = ap_const_logic_1;
    end else begin
        ap_sig_cseq_ST_st2_fsm_1 = ap_const_logic_0;
    end
end

always @ (ap_sig_bdd_120) begin
    if (ap_sig_bdd_120) begin
        ap_sig_cseq_ST_st3_fsm_2 = ap_const_logic_1;
    end else begin
        ap_sig_cseq_ST_st3_fsm_2 = ap_const_logic_0;
    end
end

always @ (ap_sig_bdd_136) begin
    if (ap_sig_bdd_136) begin
        ap_sig_cseq_ST_st8_fsm_7 = ap_const_logic_1;
    end else begin
        ap_sig_cseq_ST_st8_fsm_7 = ap_const_logic_0;
    end
end

always @ (m_axi_dest_AWREADY or ap_reg_ioackin_m_axi_dest_AWREADY) begin
    if ((ap_const_logic_0 == ap_reg_ioackin_m_axi_dest_AWREADY)) begin
        ap_sig_ioackin_m_axi_dest_AWREADY = m_axi_dest_AWREADY;
    end else begin
        ap_sig_ioackin_m_axi_dest_AWREADY = ap_const_logic_1;
    end
end

always @ (m_axi_dest_WREADY or ap_reg_ioackin_m_axi_dest_WREADY) begin
    if ((ap_const_logic_0 == ap_reg_ioackin_m_axi_dest_WREADY)) begin
        ap_sig_ioackin_m_axi_dest_WREADY = m_axi_dest_WREADY;
    end else begin
        ap_sig_ioackin_m_axi_dest_WREADY = ap_const_logic_1;
    end
end

always @ (ap_reg_ioackin_m_axi_dest_AWREADY or ap_sig_cseq_ST_st2_fsm_1) begin
    if (((ap_const_logic_1 == ap_sig_cseq_ST_st2_fsm_1) & (ap_const_logic_0 == ap_reg_ioackin_m_axi_dest_AWREADY))) begin
        m_axi_dest_AWVALID = ap_const_logic_1;
    end else begin
        m_axi_dest_AWVALID = ap_const_logic_0;
    end
end

always @ (m_axi_dest_BVALID or ap_sig_cseq_ST_st8_fsm_7) begin
    if (((ap_const_logic_1 == ap_sig_cseq_ST_st8_fsm_7) & ~(m_axi_dest_BVALID == ap_const_logic_0))) begin
        m_axi_dest_BREADY = ap_const_logic_1;
    end else begin
        m_axi_dest_BREADY = ap_const_logic_0;
    end
end

always @ (ap_reg_ioackin_m_axi_dest_WREADY or ap_sig_cseq_ST_st3_fsm_2) begin
    if (((ap_const_logic_1 == ap_sig_cseq_ST_st3_fsm_2) & (ap_const_logic_0 == ap_reg_ioackin_m_axi_dest_WREADY))) begin
        m_axi_dest_WVALID = ap_const_logic_1;
    end else begin
        m_axi_dest_WVALID = ap_const_logic_0;
    end
end
always @ (ap_start or ap_CS_fsm or m_axi_dest_BVALID or ap_sig_ioackin_m_axi_dest_AWREADY or ap_sig_ioackin_m_axi_dest_WREADY) begin
    case (ap_CS_fsm)
        ap_ST_st1_fsm_0 : 
        begin
            if (~(ap_start == ap_const_logic_0)) begin
                ap_NS_fsm = ap_ST_st2_fsm_1;
            end else begin
                ap_NS_fsm = ap_ST_st1_fsm_0;
            end
        end
        ap_ST_st2_fsm_1 : 
        begin
            if (~(ap_const_logic_0 == ap_sig_ioackin_m_axi_dest_AWREADY)) begin
                ap_NS_fsm = ap_ST_st3_fsm_2;
            end else begin
                ap_NS_fsm = ap_ST_st2_fsm_1;
            end
        end
        ap_ST_st3_fsm_2 : 
        begin
            if (~(ap_const_logic_0 == ap_sig_ioackin_m_axi_dest_WREADY)) begin
                ap_NS_fsm = ap_ST_st4_fsm_3;
            end else begin
                ap_NS_fsm = ap_ST_st3_fsm_2;
            end
        end
        ap_ST_st4_fsm_3 : 
        begin
            ap_NS_fsm = ap_ST_st5_fsm_4;
        end
        ap_ST_st5_fsm_4 : 
        begin
            ap_NS_fsm = ap_ST_st6_fsm_5;
        end
        ap_ST_st6_fsm_5 : 
        begin
            ap_NS_fsm = ap_ST_st7_fsm_6;
        end
        ap_ST_st7_fsm_6 : 
        begin
            ap_NS_fsm = ap_ST_st8_fsm_7;
        end
        ap_ST_st8_fsm_7 : 
        begin
            if (~(m_axi_dest_BVALID == ap_const_logic_0)) begin
                ap_NS_fsm = ap_ST_st1_fsm_0;
            end else begin
                ap_NS_fsm = ap_ST_st8_fsm_7;
            end
        end
        default : 
        begin
            ap_NS_fsm = 'bx;
        end
    endcase
end



always @ (ap_CS_fsm) begin
    ap_sig_bdd_103 = (ap_const_lv1_1 == ap_CS_fsm[ap_const_lv32_1]);
end


always @ (ap_CS_fsm) begin
    ap_sig_bdd_120 = (ap_const_lv1_1 == ap_CS_fsm[ap_const_lv32_2]);
end


always @ (ap_CS_fsm) begin
    ap_sig_bdd_136 = (ap_const_lv1_1 == ap_CS_fsm[ap_const_lv32_7]);
end


always @ (ap_CS_fsm) begin
    ap_sig_bdd_26 = (ap_CS_fsm[ap_const_lv32_0] == ap_const_lv1_1);
end

assign m_axi_dest_ARADDR = ap_const_lv32_0;

assign m_axi_dest_ARBURST = ap_const_lv2_0;

assign m_axi_dest_ARCACHE = ap_const_lv4_0;

assign m_axi_dest_ARID = ap_const_lv1_0;

assign m_axi_dest_ARLEN = ap_const_lv32_0;

assign m_axi_dest_ARLOCK = ap_const_lv2_0;

assign m_axi_dest_ARPROT = ap_const_lv3_0;

assign m_axi_dest_ARQOS = ap_const_lv4_0;

assign m_axi_dest_ARREGION = ap_const_lv4_0;

assign m_axi_dest_ARSIZE = ap_const_lv3_0;

assign m_axi_dest_ARUSER = ap_const_lv1_0;

assign m_axi_dest_ARVALID = ap_const_logic_0;

assign m_axi_dest_AWADDR = dest_addr_reg_86;

assign m_axi_dest_AWBURST = ap_const_lv2_0;

assign m_axi_dest_AWCACHE = ap_const_lv4_0;

assign m_axi_dest_AWID = ap_const_lv1_0;

assign m_axi_dest_AWLEN = ap_const_lv32_1;

assign m_axi_dest_AWLOCK = ap_const_lv2_0;

assign m_axi_dest_AWPROT = ap_const_lv3_0;

assign m_axi_dest_AWQOS = ap_const_lv4_0;

assign m_axi_dest_AWREGION = ap_const_lv4_0;

assign m_axi_dest_AWSIZE = ap_const_lv3_0;

assign m_axi_dest_AWUSER = ap_const_lv1_0;

assign m_axi_dest_RREADY = ap_const_logic_0;

assign m_axi_dest_WDATA = src;

assign m_axi_dest_WID = ap_const_lv1_0;

assign m_axi_dest_WLAST = ap_const_logic_0;

assign m_axi_dest_WSTRB = ap_const_lv4_F;

assign m_axi_dest_WUSER = ap_const_lv1_0;

assign sext_cast_fu_66_p1 = data1;

assign sum_cast_fu_76_p1 = sum_fu_70_p2;

assign sum_fu_70_p2 = (tmp_cast_cast_fu_62_p1 + sext_cast_fu_66_p1);

assign tmp_cast_cast_fu_62_p1 = tmp;


endmodule //set_assign_val
