//Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
//Date        : Tue Feb 02 21:37:26 2016
//Host        : running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target zc702.bd
//Design      : zc702
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module m00_couplers_imp_1IKQD79
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input [0:0]M_ARESETN;
  output [12:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [12:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input [0:0]S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire [0:0]M_ARESETN_1;
  wire [31:0]m00_couplers_to_m00_regslice_ARADDR;
  wire [2:0]m00_couplers_to_m00_regslice_ARPROT;
  wire m00_couplers_to_m00_regslice_ARREADY;
  wire m00_couplers_to_m00_regslice_ARVALID;
  wire [31:0]m00_couplers_to_m00_regslice_AWADDR;
  wire [2:0]m00_couplers_to_m00_regslice_AWPROT;
  wire m00_couplers_to_m00_regslice_AWREADY;
  wire m00_couplers_to_m00_regslice_AWVALID;
  wire m00_couplers_to_m00_regslice_BREADY;
  wire [1:0]m00_couplers_to_m00_regslice_BRESP;
  wire m00_couplers_to_m00_regslice_BVALID;
  wire [31:0]m00_couplers_to_m00_regslice_RDATA;
  wire m00_couplers_to_m00_regslice_RREADY;
  wire [1:0]m00_couplers_to_m00_regslice_RRESP;
  wire m00_couplers_to_m00_regslice_RVALID;
  wire [31:0]m00_couplers_to_m00_regslice_WDATA;
  wire m00_couplers_to_m00_regslice_WREADY;
  wire [3:0]m00_couplers_to_m00_regslice_WSTRB;
  wire m00_couplers_to_m00_regslice_WVALID;
  wire [12:0]m00_regslice_to_m00_couplers_ARADDR;
  wire m00_regslice_to_m00_couplers_ARREADY;
  wire m00_regslice_to_m00_couplers_ARVALID;
  wire [12:0]m00_regslice_to_m00_couplers_AWADDR;
  wire m00_regslice_to_m00_couplers_AWREADY;
  wire m00_regslice_to_m00_couplers_AWVALID;
  wire m00_regslice_to_m00_couplers_BREADY;
  wire [1:0]m00_regslice_to_m00_couplers_BRESP;
  wire m00_regslice_to_m00_couplers_BVALID;
  wire [31:0]m00_regslice_to_m00_couplers_RDATA;
  wire m00_regslice_to_m00_couplers_RREADY;
  wire [1:0]m00_regslice_to_m00_couplers_RRESP;
  wire m00_regslice_to_m00_couplers_RVALID;
  wire [31:0]m00_regslice_to_m00_couplers_WDATA;
  wire m00_regslice_to_m00_couplers_WREADY;
  wire [3:0]m00_regslice_to_m00_couplers_WSTRB;
  wire m00_regslice_to_m00_couplers_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN[0];
  assign M_AXI_araddr[12:0] = m00_regslice_to_m00_couplers_ARADDR;
  assign M_AXI_arvalid = m00_regslice_to_m00_couplers_ARVALID;
  assign M_AXI_awaddr[12:0] = m00_regslice_to_m00_couplers_AWADDR;
  assign M_AXI_awvalid = m00_regslice_to_m00_couplers_AWVALID;
  assign M_AXI_bready = m00_regslice_to_m00_couplers_BREADY;
  assign M_AXI_rready = m00_regslice_to_m00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m00_regslice_to_m00_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m00_regslice_to_m00_couplers_WSTRB;
  assign M_AXI_wvalid = m00_regslice_to_m00_couplers_WVALID;
  assign S_AXI_arready = m00_couplers_to_m00_regslice_ARREADY;
  assign S_AXI_awready = m00_couplers_to_m00_regslice_AWREADY;
  assign S_AXI_bresp[1:0] = m00_couplers_to_m00_regslice_BRESP;
  assign S_AXI_bvalid = m00_couplers_to_m00_regslice_BVALID;
  assign S_AXI_rdata[31:0] = m00_couplers_to_m00_regslice_RDATA;
  assign S_AXI_rresp[1:0] = m00_couplers_to_m00_regslice_RRESP;
  assign S_AXI_rvalid = m00_couplers_to_m00_regslice_RVALID;
  assign S_AXI_wready = m00_couplers_to_m00_regslice_WREADY;
  assign m00_couplers_to_m00_regslice_ARADDR = S_AXI_araddr[31:0];
  assign m00_couplers_to_m00_regslice_ARPROT = S_AXI_arprot[2:0];
  assign m00_couplers_to_m00_regslice_ARVALID = S_AXI_arvalid;
  assign m00_couplers_to_m00_regslice_AWADDR = S_AXI_awaddr[31:0];
  assign m00_couplers_to_m00_regslice_AWPROT = S_AXI_awprot[2:0];
  assign m00_couplers_to_m00_regslice_AWVALID = S_AXI_awvalid;
  assign m00_couplers_to_m00_regslice_BREADY = S_AXI_bready;
  assign m00_couplers_to_m00_regslice_RREADY = S_AXI_rready;
  assign m00_couplers_to_m00_regslice_WDATA = S_AXI_wdata[31:0];
  assign m00_couplers_to_m00_regslice_WSTRB = S_AXI_wstrb[3:0];
  assign m00_couplers_to_m00_regslice_WVALID = S_AXI_wvalid;
  assign m00_regslice_to_m00_couplers_ARREADY = M_AXI_arready;
  assign m00_regslice_to_m00_couplers_AWREADY = M_AXI_awready;
  assign m00_regslice_to_m00_couplers_BRESP = M_AXI_bresp[1:0];
  assign m00_regslice_to_m00_couplers_BVALID = M_AXI_bvalid;
  assign m00_regslice_to_m00_couplers_RDATA = M_AXI_rdata[31:0];
  assign m00_regslice_to_m00_couplers_RRESP = M_AXI_rresp[1:0];
  assign m00_regslice_to_m00_couplers_RVALID = M_AXI_rvalid;
  assign m00_regslice_to_m00_couplers_WREADY = M_AXI_wready;
  zc702_m00_regslice_0 m00_regslice
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(m00_regslice_to_m00_couplers_ARADDR),
        .m_axi_arready(m00_regslice_to_m00_couplers_ARREADY),
        .m_axi_arvalid(m00_regslice_to_m00_couplers_ARVALID),
        .m_axi_awaddr(m00_regslice_to_m00_couplers_AWADDR),
        .m_axi_awready(m00_regslice_to_m00_couplers_AWREADY),
        .m_axi_awvalid(m00_regslice_to_m00_couplers_AWVALID),
        .m_axi_bready(m00_regslice_to_m00_couplers_BREADY),
        .m_axi_bresp(m00_regslice_to_m00_couplers_BRESP),
        .m_axi_bvalid(m00_regslice_to_m00_couplers_BVALID),
        .m_axi_rdata(m00_regslice_to_m00_couplers_RDATA),
        .m_axi_rready(m00_regslice_to_m00_couplers_RREADY),
        .m_axi_rresp(m00_regslice_to_m00_couplers_RRESP),
        .m_axi_rvalid(m00_regslice_to_m00_couplers_RVALID),
        .m_axi_wdata(m00_regslice_to_m00_couplers_WDATA),
        .m_axi_wready(m00_regslice_to_m00_couplers_WREADY),
        .m_axi_wstrb(m00_regslice_to_m00_couplers_WSTRB),
        .m_axi_wvalid(m00_regslice_to_m00_couplers_WVALID),
        .s_axi_araddr(m00_couplers_to_m00_regslice_ARADDR[12:0]),
        .s_axi_arprot(m00_couplers_to_m00_regslice_ARPROT),
        .s_axi_arready(m00_couplers_to_m00_regslice_ARREADY),
        .s_axi_arvalid(m00_couplers_to_m00_regslice_ARVALID),
        .s_axi_awaddr(m00_couplers_to_m00_regslice_AWADDR[12:0]),
        .s_axi_awprot(m00_couplers_to_m00_regslice_AWPROT),
        .s_axi_awready(m00_couplers_to_m00_regslice_AWREADY),
        .s_axi_awvalid(m00_couplers_to_m00_regslice_AWVALID),
        .s_axi_bready(m00_couplers_to_m00_regslice_BREADY),
        .s_axi_bresp(m00_couplers_to_m00_regslice_BRESP),
        .s_axi_bvalid(m00_couplers_to_m00_regslice_BVALID),
        .s_axi_rdata(m00_couplers_to_m00_regslice_RDATA),
        .s_axi_rready(m00_couplers_to_m00_regslice_RREADY),
        .s_axi_rresp(m00_couplers_to_m00_regslice_RRESP),
        .s_axi_rvalid(m00_couplers_to_m00_regslice_RVALID),
        .s_axi_wdata(m00_couplers_to_m00_regslice_WDATA),
        .s_axi_wready(m00_couplers_to_m00_regslice_WREADY),
        .s_axi_wstrb(m00_couplers_to_m00_regslice_WSTRB),
        .s_axi_wvalid(m00_couplers_to_m00_regslice_WVALID));
endmodule

module m00_couplers_imp_F6WOYG
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arid,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rid,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wid,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arregion,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awregion,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input [0:0]M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [0:0]M_AXI_arid;
  output [3:0]M_AXI_arlen;
  output [1:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [0:0]M_AXI_awid;
  output [3:0]M_AXI_awlen;
  output [1:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output M_AXI_awvalid;
  input [2:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [63:0]M_AXI_rdata;
  input [2:0]M_AXI_rid;
  input M_AXI_rlast;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [63:0]M_AXI_wdata;
  output [0:0]M_AXI_wid;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [7:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input [0:0]S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [0:0]S_AXI_arid;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [3:0]S_AXI_arregion;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [0:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [3:0]S_AXI_awregion;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  output [0:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [63:0]S_AXI_rdata;
  output [0:0]S_AXI_rid;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [63:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [7:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire [0:0]M_ARESETN_1;
  wire S_ACLK_1;
  wire [0:0]S_ARESETN_1;
  wire [31:0]auto_pc_to_m00_regslice_ARADDR;
  wire [1:0]auto_pc_to_m00_regslice_ARBURST;
  wire [3:0]auto_pc_to_m00_regslice_ARCACHE;
  wire [0:0]auto_pc_to_m00_regslice_ARID;
  wire [3:0]auto_pc_to_m00_regslice_ARLEN;
  wire [1:0]auto_pc_to_m00_regslice_ARLOCK;
  wire [2:0]auto_pc_to_m00_regslice_ARPROT;
  wire [3:0]auto_pc_to_m00_regslice_ARQOS;
  wire auto_pc_to_m00_regslice_ARREADY;
  wire [2:0]auto_pc_to_m00_regslice_ARSIZE;
  wire auto_pc_to_m00_regslice_ARVALID;
  wire [31:0]auto_pc_to_m00_regslice_AWADDR;
  wire [1:0]auto_pc_to_m00_regslice_AWBURST;
  wire [3:0]auto_pc_to_m00_regslice_AWCACHE;
  wire [0:0]auto_pc_to_m00_regslice_AWID;
  wire [3:0]auto_pc_to_m00_regslice_AWLEN;
  wire [1:0]auto_pc_to_m00_regslice_AWLOCK;
  wire [2:0]auto_pc_to_m00_regslice_AWPROT;
  wire [3:0]auto_pc_to_m00_regslice_AWQOS;
  wire auto_pc_to_m00_regslice_AWREADY;
  wire [2:0]auto_pc_to_m00_regslice_AWSIZE;
  wire auto_pc_to_m00_regslice_AWVALID;
  wire [0:0]auto_pc_to_m00_regslice_BID;
  wire auto_pc_to_m00_regslice_BREADY;
  wire [1:0]auto_pc_to_m00_regslice_BRESP;
  wire auto_pc_to_m00_regslice_BVALID;
  wire [63:0]auto_pc_to_m00_regslice_RDATA;
  wire [0:0]auto_pc_to_m00_regslice_RID;
  wire auto_pc_to_m00_regslice_RLAST;
  wire auto_pc_to_m00_regslice_RREADY;
  wire [1:0]auto_pc_to_m00_regslice_RRESP;
  wire auto_pc_to_m00_regslice_RVALID;
  wire [63:0]auto_pc_to_m00_regslice_WDATA;
  wire [0:0]auto_pc_to_m00_regslice_WID;
  wire auto_pc_to_m00_regslice_WLAST;
  wire auto_pc_to_m00_regslice_WREADY;
  wire [7:0]auto_pc_to_m00_regslice_WSTRB;
  wire auto_pc_to_m00_regslice_WVALID;
  wire [31:0]m00_couplers_to_m00_data_fifo_ARADDR;
  wire [1:0]m00_couplers_to_m00_data_fifo_ARBURST;
  wire [3:0]m00_couplers_to_m00_data_fifo_ARCACHE;
  wire [0:0]m00_couplers_to_m00_data_fifo_ARID;
  wire [7:0]m00_couplers_to_m00_data_fifo_ARLEN;
  wire [0:0]m00_couplers_to_m00_data_fifo_ARLOCK;
  wire [2:0]m00_couplers_to_m00_data_fifo_ARPROT;
  wire [3:0]m00_couplers_to_m00_data_fifo_ARQOS;
  wire m00_couplers_to_m00_data_fifo_ARREADY;
  wire [3:0]m00_couplers_to_m00_data_fifo_ARREGION;
  wire [2:0]m00_couplers_to_m00_data_fifo_ARSIZE;
  wire m00_couplers_to_m00_data_fifo_ARVALID;
  wire [31:0]m00_couplers_to_m00_data_fifo_AWADDR;
  wire [1:0]m00_couplers_to_m00_data_fifo_AWBURST;
  wire [3:0]m00_couplers_to_m00_data_fifo_AWCACHE;
  wire [0:0]m00_couplers_to_m00_data_fifo_AWID;
  wire [7:0]m00_couplers_to_m00_data_fifo_AWLEN;
  wire [0:0]m00_couplers_to_m00_data_fifo_AWLOCK;
  wire [2:0]m00_couplers_to_m00_data_fifo_AWPROT;
  wire [3:0]m00_couplers_to_m00_data_fifo_AWQOS;
  wire m00_couplers_to_m00_data_fifo_AWREADY;
  wire [3:0]m00_couplers_to_m00_data_fifo_AWREGION;
  wire [2:0]m00_couplers_to_m00_data_fifo_AWSIZE;
  wire m00_couplers_to_m00_data_fifo_AWVALID;
  wire [0:0]m00_couplers_to_m00_data_fifo_BID;
  wire m00_couplers_to_m00_data_fifo_BREADY;
  wire [1:0]m00_couplers_to_m00_data_fifo_BRESP;
  wire m00_couplers_to_m00_data_fifo_BVALID;
  wire [63:0]m00_couplers_to_m00_data_fifo_RDATA;
  wire [0:0]m00_couplers_to_m00_data_fifo_RID;
  wire m00_couplers_to_m00_data_fifo_RLAST;
  wire m00_couplers_to_m00_data_fifo_RREADY;
  wire [1:0]m00_couplers_to_m00_data_fifo_RRESP;
  wire m00_couplers_to_m00_data_fifo_RVALID;
  wire [63:0]m00_couplers_to_m00_data_fifo_WDATA;
  wire m00_couplers_to_m00_data_fifo_WLAST;
  wire m00_couplers_to_m00_data_fifo_WREADY;
  wire [7:0]m00_couplers_to_m00_data_fifo_WSTRB;
  wire m00_couplers_to_m00_data_fifo_WVALID;
  wire [31:0]m00_data_fifo_to_auto_pc_ARADDR;
  wire [1:0]m00_data_fifo_to_auto_pc_ARBURST;
  wire [3:0]m00_data_fifo_to_auto_pc_ARCACHE;
  wire [0:0]m00_data_fifo_to_auto_pc_ARID;
  wire [7:0]m00_data_fifo_to_auto_pc_ARLEN;
  wire [0:0]m00_data_fifo_to_auto_pc_ARLOCK;
  wire [2:0]m00_data_fifo_to_auto_pc_ARPROT;
  wire [3:0]m00_data_fifo_to_auto_pc_ARQOS;
  wire m00_data_fifo_to_auto_pc_ARREADY;
  wire [3:0]m00_data_fifo_to_auto_pc_ARREGION;
  wire [2:0]m00_data_fifo_to_auto_pc_ARSIZE;
  wire m00_data_fifo_to_auto_pc_ARVALID;
  wire [31:0]m00_data_fifo_to_auto_pc_AWADDR;
  wire [1:0]m00_data_fifo_to_auto_pc_AWBURST;
  wire [3:0]m00_data_fifo_to_auto_pc_AWCACHE;
  wire [0:0]m00_data_fifo_to_auto_pc_AWID;
  wire [7:0]m00_data_fifo_to_auto_pc_AWLEN;
  wire [0:0]m00_data_fifo_to_auto_pc_AWLOCK;
  wire [2:0]m00_data_fifo_to_auto_pc_AWPROT;
  wire [3:0]m00_data_fifo_to_auto_pc_AWQOS;
  wire m00_data_fifo_to_auto_pc_AWREADY;
  wire [3:0]m00_data_fifo_to_auto_pc_AWREGION;
  wire [2:0]m00_data_fifo_to_auto_pc_AWSIZE;
  wire m00_data_fifo_to_auto_pc_AWVALID;
  wire [0:0]m00_data_fifo_to_auto_pc_BID;
  wire m00_data_fifo_to_auto_pc_BREADY;
  wire [1:0]m00_data_fifo_to_auto_pc_BRESP;
  wire m00_data_fifo_to_auto_pc_BVALID;
  wire [63:0]m00_data_fifo_to_auto_pc_RDATA;
  wire [0:0]m00_data_fifo_to_auto_pc_RID;
  wire m00_data_fifo_to_auto_pc_RLAST;
  wire m00_data_fifo_to_auto_pc_RREADY;
  wire [1:0]m00_data_fifo_to_auto_pc_RRESP;
  wire m00_data_fifo_to_auto_pc_RVALID;
  wire [63:0]m00_data_fifo_to_auto_pc_WDATA;
  wire m00_data_fifo_to_auto_pc_WLAST;
  wire m00_data_fifo_to_auto_pc_WREADY;
  wire [7:0]m00_data_fifo_to_auto_pc_WSTRB;
  wire m00_data_fifo_to_auto_pc_WVALID;
  wire [31:0]m00_regslice_to_m00_couplers_ARADDR;
  wire [1:0]m00_regslice_to_m00_couplers_ARBURST;
  wire [3:0]m00_regslice_to_m00_couplers_ARCACHE;
  wire [0:0]m00_regslice_to_m00_couplers_ARID;
  wire [3:0]m00_regslice_to_m00_couplers_ARLEN;
  wire [1:0]m00_regslice_to_m00_couplers_ARLOCK;
  wire [2:0]m00_regslice_to_m00_couplers_ARPROT;
  wire [3:0]m00_regslice_to_m00_couplers_ARQOS;
  wire m00_regslice_to_m00_couplers_ARREADY;
  wire [2:0]m00_regslice_to_m00_couplers_ARSIZE;
  wire m00_regslice_to_m00_couplers_ARVALID;
  wire [31:0]m00_regslice_to_m00_couplers_AWADDR;
  wire [1:0]m00_regslice_to_m00_couplers_AWBURST;
  wire [3:0]m00_regslice_to_m00_couplers_AWCACHE;
  wire [0:0]m00_regslice_to_m00_couplers_AWID;
  wire [3:0]m00_regslice_to_m00_couplers_AWLEN;
  wire [1:0]m00_regslice_to_m00_couplers_AWLOCK;
  wire [2:0]m00_regslice_to_m00_couplers_AWPROT;
  wire [3:0]m00_regslice_to_m00_couplers_AWQOS;
  wire m00_regslice_to_m00_couplers_AWREADY;
  wire [2:0]m00_regslice_to_m00_couplers_AWSIZE;
  wire m00_regslice_to_m00_couplers_AWVALID;
  wire [2:0]m00_regslice_to_m00_couplers_BID;
  wire m00_regslice_to_m00_couplers_BREADY;
  wire [1:0]m00_regslice_to_m00_couplers_BRESP;
  wire m00_regslice_to_m00_couplers_BVALID;
  wire [63:0]m00_regslice_to_m00_couplers_RDATA;
  wire [2:0]m00_regslice_to_m00_couplers_RID;
  wire m00_regslice_to_m00_couplers_RLAST;
  wire m00_regslice_to_m00_couplers_RREADY;
  wire [1:0]m00_regslice_to_m00_couplers_RRESP;
  wire m00_regslice_to_m00_couplers_RVALID;
  wire [63:0]m00_regslice_to_m00_couplers_WDATA;
  wire [0:0]m00_regslice_to_m00_couplers_WID;
  wire m00_regslice_to_m00_couplers_WLAST;
  wire m00_regslice_to_m00_couplers_WREADY;
  wire [7:0]m00_regslice_to_m00_couplers_WSTRB;
  wire m00_regslice_to_m00_couplers_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN[0];
  assign M_AXI_araddr[31:0] = m00_regslice_to_m00_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = m00_regslice_to_m00_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = m00_regslice_to_m00_couplers_ARCACHE;
  assign M_AXI_arid[0] = m00_regslice_to_m00_couplers_ARID;
  assign M_AXI_arlen[3:0] = m00_regslice_to_m00_couplers_ARLEN;
  assign M_AXI_arlock[1:0] = m00_regslice_to_m00_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = m00_regslice_to_m00_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = m00_regslice_to_m00_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = m00_regslice_to_m00_couplers_ARSIZE;
  assign M_AXI_arvalid = m00_regslice_to_m00_couplers_ARVALID;
  assign M_AXI_awaddr[31:0] = m00_regslice_to_m00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = m00_regslice_to_m00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = m00_regslice_to_m00_couplers_AWCACHE;
  assign M_AXI_awid[0] = m00_regslice_to_m00_couplers_AWID;
  assign M_AXI_awlen[3:0] = m00_regslice_to_m00_couplers_AWLEN;
  assign M_AXI_awlock[1:0] = m00_regslice_to_m00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = m00_regslice_to_m00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = m00_regslice_to_m00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = m00_regslice_to_m00_couplers_AWSIZE;
  assign M_AXI_awvalid = m00_regslice_to_m00_couplers_AWVALID;
  assign M_AXI_bready = m00_regslice_to_m00_couplers_BREADY;
  assign M_AXI_rready = m00_regslice_to_m00_couplers_RREADY;
  assign M_AXI_wdata[63:0] = m00_regslice_to_m00_couplers_WDATA;
  assign M_AXI_wid[0] = m00_regslice_to_m00_couplers_WID;
  assign M_AXI_wlast = m00_regslice_to_m00_couplers_WLAST;
  assign M_AXI_wstrb[7:0] = m00_regslice_to_m00_couplers_WSTRB;
  assign M_AXI_wvalid = m00_regslice_to_m00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN[0];
  assign S_AXI_arready = m00_couplers_to_m00_data_fifo_ARREADY;
  assign S_AXI_awready = m00_couplers_to_m00_data_fifo_AWREADY;
  assign S_AXI_bid[0] = m00_couplers_to_m00_data_fifo_BID;
  assign S_AXI_bresp[1:0] = m00_couplers_to_m00_data_fifo_BRESP;
  assign S_AXI_bvalid = m00_couplers_to_m00_data_fifo_BVALID;
  assign S_AXI_rdata[63:0] = m00_couplers_to_m00_data_fifo_RDATA;
  assign S_AXI_rid[0] = m00_couplers_to_m00_data_fifo_RID;
  assign S_AXI_rlast = m00_couplers_to_m00_data_fifo_RLAST;
  assign S_AXI_rresp[1:0] = m00_couplers_to_m00_data_fifo_RRESP;
  assign S_AXI_rvalid = m00_couplers_to_m00_data_fifo_RVALID;
  assign S_AXI_wready = m00_couplers_to_m00_data_fifo_WREADY;
  assign m00_couplers_to_m00_data_fifo_ARADDR = S_AXI_araddr[31:0];
  assign m00_couplers_to_m00_data_fifo_ARBURST = S_AXI_arburst[1:0];
  assign m00_couplers_to_m00_data_fifo_ARCACHE = S_AXI_arcache[3:0];
  assign m00_couplers_to_m00_data_fifo_ARID = S_AXI_arid[0];
  assign m00_couplers_to_m00_data_fifo_ARLEN = S_AXI_arlen[7:0];
  assign m00_couplers_to_m00_data_fifo_ARLOCK = S_AXI_arlock[0];
  assign m00_couplers_to_m00_data_fifo_ARPROT = S_AXI_arprot[2:0];
  assign m00_couplers_to_m00_data_fifo_ARQOS = S_AXI_arqos[3:0];
  assign m00_couplers_to_m00_data_fifo_ARREGION = S_AXI_arregion[3:0];
  assign m00_couplers_to_m00_data_fifo_ARSIZE = S_AXI_arsize[2:0];
  assign m00_couplers_to_m00_data_fifo_ARVALID = S_AXI_arvalid;
  assign m00_couplers_to_m00_data_fifo_AWADDR = S_AXI_awaddr[31:0];
  assign m00_couplers_to_m00_data_fifo_AWBURST = S_AXI_awburst[1:0];
  assign m00_couplers_to_m00_data_fifo_AWCACHE = S_AXI_awcache[3:0];
  assign m00_couplers_to_m00_data_fifo_AWID = S_AXI_awid[0];
  assign m00_couplers_to_m00_data_fifo_AWLEN = S_AXI_awlen[7:0];
  assign m00_couplers_to_m00_data_fifo_AWLOCK = S_AXI_awlock[0];
  assign m00_couplers_to_m00_data_fifo_AWPROT = S_AXI_awprot[2:0];
  assign m00_couplers_to_m00_data_fifo_AWQOS = S_AXI_awqos[3:0];
  assign m00_couplers_to_m00_data_fifo_AWREGION = S_AXI_awregion[3:0];
  assign m00_couplers_to_m00_data_fifo_AWSIZE = S_AXI_awsize[2:0];
  assign m00_couplers_to_m00_data_fifo_AWVALID = S_AXI_awvalid;
  assign m00_couplers_to_m00_data_fifo_BREADY = S_AXI_bready;
  assign m00_couplers_to_m00_data_fifo_RREADY = S_AXI_rready;
  assign m00_couplers_to_m00_data_fifo_WDATA = S_AXI_wdata[63:0];
  assign m00_couplers_to_m00_data_fifo_WLAST = S_AXI_wlast;
  assign m00_couplers_to_m00_data_fifo_WSTRB = S_AXI_wstrb[7:0];
  assign m00_couplers_to_m00_data_fifo_WVALID = S_AXI_wvalid;
  assign m00_regslice_to_m00_couplers_ARREADY = M_AXI_arready;
  assign m00_regslice_to_m00_couplers_AWREADY = M_AXI_awready;
  assign m00_regslice_to_m00_couplers_BID = M_AXI_bid[2:0];
  assign m00_regslice_to_m00_couplers_BRESP = M_AXI_bresp[1:0];
  assign m00_regslice_to_m00_couplers_BVALID = M_AXI_bvalid;
  assign m00_regslice_to_m00_couplers_RDATA = M_AXI_rdata[63:0];
  assign m00_regslice_to_m00_couplers_RID = M_AXI_rid[2:0];
  assign m00_regslice_to_m00_couplers_RLAST = M_AXI_rlast;
  assign m00_regslice_to_m00_couplers_RRESP = M_AXI_rresp[1:0];
  assign m00_regslice_to_m00_couplers_RVALID = M_AXI_rvalid;
  assign m00_regslice_to_m00_couplers_WREADY = M_AXI_wready;
  zc702_auto_pc_1 auto_pc
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(auto_pc_to_m00_regslice_ARADDR),
        .m_axi_arburst(auto_pc_to_m00_regslice_ARBURST),
        .m_axi_arcache(auto_pc_to_m00_regslice_ARCACHE),
        .m_axi_arid(auto_pc_to_m00_regslice_ARID),
        .m_axi_arlen(auto_pc_to_m00_regslice_ARLEN),
        .m_axi_arlock(auto_pc_to_m00_regslice_ARLOCK),
        .m_axi_arprot(auto_pc_to_m00_regslice_ARPROT),
        .m_axi_arqos(auto_pc_to_m00_regslice_ARQOS),
        .m_axi_arready(auto_pc_to_m00_regslice_ARREADY),
        .m_axi_arsize(auto_pc_to_m00_regslice_ARSIZE),
        .m_axi_arvalid(auto_pc_to_m00_regslice_ARVALID),
        .m_axi_awaddr(auto_pc_to_m00_regslice_AWADDR),
        .m_axi_awburst(auto_pc_to_m00_regslice_AWBURST),
        .m_axi_awcache(auto_pc_to_m00_regslice_AWCACHE),
        .m_axi_awid(auto_pc_to_m00_regslice_AWID),
        .m_axi_awlen(auto_pc_to_m00_regslice_AWLEN),
        .m_axi_awlock(auto_pc_to_m00_regslice_AWLOCK),
        .m_axi_awprot(auto_pc_to_m00_regslice_AWPROT),
        .m_axi_awqos(auto_pc_to_m00_regslice_AWQOS),
        .m_axi_awready(auto_pc_to_m00_regslice_AWREADY),
        .m_axi_awsize(auto_pc_to_m00_regslice_AWSIZE),
        .m_axi_awvalid(auto_pc_to_m00_regslice_AWVALID),
        .m_axi_bid(auto_pc_to_m00_regslice_BID),
        .m_axi_bready(auto_pc_to_m00_regslice_BREADY),
        .m_axi_bresp(auto_pc_to_m00_regslice_BRESP),
        .m_axi_bvalid(auto_pc_to_m00_regslice_BVALID),
        .m_axi_rdata(auto_pc_to_m00_regslice_RDATA),
        .m_axi_rid(auto_pc_to_m00_regslice_RID),
        .m_axi_rlast(auto_pc_to_m00_regslice_RLAST),
        .m_axi_rready(auto_pc_to_m00_regslice_RREADY),
        .m_axi_rresp(auto_pc_to_m00_regslice_RRESP),
        .m_axi_rvalid(auto_pc_to_m00_regslice_RVALID),
        .m_axi_wdata(auto_pc_to_m00_regslice_WDATA),
        .m_axi_wid(auto_pc_to_m00_regslice_WID),
        .m_axi_wlast(auto_pc_to_m00_regslice_WLAST),
        .m_axi_wready(auto_pc_to_m00_regslice_WREADY),
        .m_axi_wstrb(auto_pc_to_m00_regslice_WSTRB),
        .m_axi_wvalid(auto_pc_to_m00_regslice_WVALID),
        .s_axi_araddr(m00_data_fifo_to_auto_pc_ARADDR),
        .s_axi_arburst(m00_data_fifo_to_auto_pc_ARBURST),
        .s_axi_arcache(m00_data_fifo_to_auto_pc_ARCACHE),
        .s_axi_arid(m00_data_fifo_to_auto_pc_ARID),
        .s_axi_arlen(m00_data_fifo_to_auto_pc_ARLEN),
        .s_axi_arlock(m00_data_fifo_to_auto_pc_ARLOCK),
        .s_axi_arprot(m00_data_fifo_to_auto_pc_ARPROT),
        .s_axi_arqos(m00_data_fifo_to_auto_pc_ARQOS),
        .s_axi_arready(m00_data_fifo_to_auto_pc_ARREADY),
        .s_axi_arregion(m00_data_fifo_to_auto_pc_ARREGION),
        .s_axi_arsize(m00_data_fifo_to_auto_pc_ARSIZE),
        .s_axi_arvalid(m00_data_fifo_to_auto_pc_ARVALID),
        .s_axi_awaddr(m00_data_fifo_to_auto_pc_AWADDR),
        .s_axi_awburst(m00_data_fifo_to_auto_pc_AWBURST),
        .s_axi_awcache(m00_data_fifo_to_auto_pc_AWCACHE),
        .s_axi_awid(m00_data_fifo_to_auto_pc_AWID),
        .s_axi_awlen(m00_data_fifo_to_auto_pc_AWLEN),
        .s_axi_awlock(m00_data_fifo_to_auto_pc_AWLOCK),
        .s_axi_awprot(m00_data_fifo_to_auto_pc_AWPROT),
        .s_axi_awqos(m00_data_fifo_to_auto_pc_AWQOS),
        .s_axi_awready(m00_data_fifo_to_auto_pc_AWREADY),
        .s_axi_awregion(m00_data_fifo_to_auto_pc_AWREGION),
        .s_axi_awsize(m00_data_fifo_to_auto_pc_AWSIZE),
        .s_axi_awvalid(m00_data_fifo_to_auto_pc_AWVALID),
        .s_axi_bid(m00_data_fifo_to_auto_pc_BID),
        .s_axi_bready(m00_data_fifo_to_auto_pc_BREADY),
        .s_axi_bresp(m00_data_fifo_to_auto_pc_BRESP),
        .s_axi_bvalid(m00_data_fifo_to_auto_pc_BVALID),
        .s_axi_rdata(m00_data_fifo_to_auto_pc_RDATA),
        .s_axi_rid(m00_data_fifo_to_auto_pc_RID),
        .s_axi_rlast(m00_data_fifo_to_auto_pc_RLAST),
        .s_axi_rready(m00_data_fifo_to_auto_pc_RREADY),
        .s_axi_rresp(m00_data_fifo_to_auto_pc_RRESP),
        .s_axi_rvalid(m00_data_fifo_to_auto_pc_RVALID),
        .s_axi_wdata(m00_data_fifo_to_auto_pc_WDATA),
        .s_axi_wlast(m00_data_fifo_to_auto_pc_WLAST),
        .s_axi_wready(m00_data_fifo_to_auto_pc_WREADY),
        .s_axi_wstrb(m00_data_fifo_to_auto_pc_WSTRB),
        .s_axi_wvalid(m00_data_fifo_to_auto_pc_WVALID));
  zc702_m00_data_fifo_0 m00_data_fifo
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(m00_data_fifo_to_auto_pc_ARADDR),
        .m_axi_arburst(m00_data_fifo_to_auto_pc_ARBURST),
        .m_axi_arcache(m00_data_fifo_to_auto_pc_ARCACHE),
        .m_axi_arid(m00_data_fifo_to_auto_pc_ARID),
        .m_axi_arlen(m00_data_fifo_to_auto_pc_ARLEN),
        .m_axi_arlock(m00_data_fifo_to_auto_pc_ARLOCK),
        .m_axi_arprot(m00_data_fifo_to_auto_pc_ARPROT),
        .m_axi_arqos(m00_data_fifo_to_auto_pc_ARQOS),
        .m_axi_arready(m00_data_fifo_to_auto_pc_ARREADY),
        .m_axi_arregion(m00_data_fifo_to_auto_pc_ARREGION),
        .m_axi_arsize(m00_data_fifo_to_auto_pc_ARSIZE),
        .m_axi_arvalid(m00_data_fifo_to_auto_pc_ARVALID),
        .m_axi_awaddr(m00_data_fifo_to_auto_pc_AWADDR),
        .m_axi_awburst(m00_data_fifo_to_auto_pc_AWBURST),
        .m_axi_awcache(m00_data_fifo_to_auto_pc_AWCACHE),
        .m_axi_awid(m00_data_fifo_to_auto_pc_AWID),
        .m_axi_awlen(m00_data_fifo_to_auto_pc_AWLEN),
        .m_axi_awlock(m00_data_fifo_to_auto_pc_AWLOCK),
        .m_axi_awprot(m00_data_fifo_to_auto_pc_AWPROT),
        .m_axi_awqos(m00_data_fifo_to_auto_pc_AWQOS),
        .m_axi_awready(m00_data_fifo_to_auto_pc_AWREADY),
        .m_axi_awregion(m00_data_fifo_to_auto_pc_AWREGION),
        .m_axi_awsize(m00_data_fifo_to_auto_pc_AWSIZE),
        .m_axi_awvalid(m00_data_fifo_to_auto_pc_AWVALID),
        .m_axi_bid(m00_data_fifo_to_auto_pc_BID),
        .m_axi_bready(m00_data_fifo_to_auto_pc_BREADY),
        .m_axi_bresp(m00_data_fifo_to_auto_pc_BRESP),
        .m_axi_bvalid(m00_data_fifo_to_auto_pc_BVALID),
        .m_axi_rdata(m00_data_fifo_to_auto_pc_RDATA),
        .m_axi_rid(m00_data_fifo_to_auto_pc_RID),
        .m_axi_rlast(m00_data_fifo_to_auto_pc_RLAST),
        .m_axi_rready(m00_data_fifo_to_auto_pc_RREADY),
        .m_axi_rresp(m00_data_fifo_to_auto_pc_RRESP),
        .m_axi_rvalid(m00_data_fifo_to_auto_pc_RVALID),
        .m_axi_wdata(m00_data_fifo_to_auto_pc_WDATA),
        .m_axi_wlast(m00_data_fifo_to_auto_pc_WLAST),
        .m_axi_wready(m00_data_fifo_to_auto_pc_WREADY),
        .m_axi_wstrb(m00_data_fifo_to_auto_pc_WSTRB),
        .m_axi_wvalid(m00_data_fifo_to_auto_pc_WVALID),
        .s_axi_araddr(m00_couplers_to_m00_data_fifo_ARADDR),
        .s_axi_arburst(m00_couplers_to_m00_data_fifo_ARBURST),
        .s_axi_arcache(m00_couplers_to_m00_data_fifo_ARCACHE),
        .s_axi_arid(m00_couplers_to_m00_data_fifo_ARID),
        .s_axi_arlen(m00_couplers_to_m00_data_fifo_ARLEN),
        .s_axi_arlock(m00_couplers_to_m00_data_fifo_ARLOCK),
        .s_axi_arprot(m00_couplers_to_m00_data_fifo_ARPROT),
        .s_axi_arqos(m00_couplers_to_m00_data_fifo_ARQOS),
        .s_axi_arready(m00_couplers_to_m00_data_fifo_ARREADY),
        .s_axi_arregion(m00_couplers_to_m00_data_fifo_ARREGION),
        .s_axi_arsize(m00_couplers_to_m00_data_fifo_ARSIZE),
        .s_axi_arvalid(m00_couplers_to_m00_data_fifo_ARVALID),
        .s_axi_awaddr(m00_couplers_to_m00_data_fifo_AWADDR),
        .s_axi_awburst(m00_couplers_to_m00_data_fifo_AWBURST),
        .s_axi_awcache(m00_couplers_to_m00_data_fifo_AWCACHE),
        .s_axi_awid(m00_couplers_to_m00_data_fifo_AWID),
        .s_axi_awlen(m00_couplers_to_m00_data_fifo_AWLEN),
        .s_axi_awlock(m00_couplers_to_m00_data_fifo_AWLOCK),
        .s_axi_awprot(m00_couplers_to_m00_data_fifo_AWPROT),
        .s_axi_awqos(m00_couplers_to_m00_data_fifo_AWQOS),
        .s_axi_awready(m00_couplers_to_m00_data_fifo_AWREADY),
        .s_axi_awregion(m00_couplers_to_m00_data_fifo_AWREGION),
        .s_axi_awsize(m00_couplers_to_m00_data_fifo_AWSIZE),
        .s_axi_awvalid(m00_couplers_to_m00_data_fifo_AWVALID),
        .s_axi_bid(m00_couplers_to_m00_data_fifo_BID),
        .s_axi_bready(m00_couplers_to_m00_data_fifo_BREADY),
        .s_axi_bresp(m00_couplers_to_m00_data_fifo_BRESP),
        .s_axi_bvalid(m00_couplers_to_m00_data_fifo_BVALID),
        .s_axi_rdata(m00_couplers_to_m00_data_fifo_RDATA),
        .s_axi_rid(m00_couplers_to_m00_data_fifo_RID),
        .s_axi_rlast(m00_couplers_to_m00_data_fifo_RLAST),
        .s_axi_rready(m00_couplers_to_m00_data_fifo_RREADY),
        .s_axi_rresp(m00_couplers_to_m00_data_fifo_RRESP),
        .s_axi_rvalid(m00_couplers_to_m00_data_fifo_RVALID),
        .s_axi_wdata(m00_couplers_to_m00_data_fifo_WDATA),
        .s_axi_wlast(m00_couplers_to_m00_data_fifo_WLAST),
        .s_axi_wready(m00_couplers_to_m00_data_fifo_WREADY),
        .s_axi_wstrb(m00_couplers_to_m00_data_fifo_WSTRB),
        .s_axi_wvalid(m00_couplers_to_m00_data_fifo_WVALID));
  zc702_m00_regslice_1 m00_regslice
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(m00_regslice_to_m00_couplers_ARADDR),
        .m_axi_arburst(m00_regslice_to_m00_couplers_ARBURST),
        .m_axi_arcache(m00_regslice_to_m00_couplers_ARCACHE),
        .m_axi_arid(m00_regslice_to_m00_couplers_ARID),
        .m_axi_arlen(m00_regslice_to_m00_couplers_ARLEN),
        .m_axi_arlock(m00_regslice_to_m00_couplers_ARLOCK),
        .m_axi_arprot(m00_regslice_to_m00_couplers_ARPROT),
        .m_axi_arqos(m00_regslice_to_m00_couplers_ARQOS),
        .m_axi_arready(m00_regslice_to_m00_couplers_ARREADY),
        .m_axi_arsize(m00_regslice_to_m00_couplers_ARSIZE),
        .m_axi_arvalid(m00_regslice_to_m00_couplers_ARVALID),
        .m_axi_awaddr(m00_regslice_to_m00_couplers_AWADDR),
        .m_axi_awburst(m00_regslice_to_m00_couplers_AWBURST),
        .m_axi_awcache(m00_regslice_to_m00_couplers_AWCACHE),
        .m_axi_awid(m00_regslice_to_m00_couplers_AWID),
        .m_axi_awlen(m00_regslice_to_m00_couplers_AWLEN),
        .m_axi_awlock(m00_regslice_to_m00_couplers_AWLOCK),
        .m_axi_awprot(m00_regslice_to_m00_couplers_AWPROT),
        .m_axi_awqos(m00_regslice_to_m00_couplers_AWQOS),
        .m_axi_awready(m00_regslice_to_m00_couplers_AWREADY),
        .m_axi_awsize(m00_regslice_to_m00_couplers_AWSIZE),
        .m_axi_awvalid(m00_regslice_to_m00_couplers_AWVALID),
        .m_axi_bid(m00_regslice_to_m00_couplers_BID[0]),
        .m_axi_bready(m00_regslice_to_m00_couplers_BREADY),
        .m_axi_bresp(m00_regslice_to_m00_couplers_BRESP),
        .m_axi_bvalid(m00_regslice_to_m00_couplers_BVALID),
        .m_axi_rdata(m00_regslice_to_m00_couplers_RDATA),
        .m_axi_rid(m00_regslice_to_m00_couplers_RID[0]),
        .m_axi_rlast(m00_regslice_to_m00_couplers_RLAST),
        .m_axi_rready(m00_regslice_to_m00_couplers_RREADY),
        .m_axi_rresp(m00_regslice_to_m00_couplers_RRESP),
        .m_axi_rvalid(m00_regslice_to_m00_couplers_RVALID),
        .m_axi_wdata(m00_regslice_to_m00_couplers_WDATA),
        .m_axi_wid(m00_regslice_to_m00_couplers_WID),
        .m_axi_wlast(m00_regslice_to_m00_couplers_WLAST),
        .m_axi_wready(m00_regslice_to_m00_couplers_WREADY),
        .m_axi_wstrb(m00_regslice_to_m00_couplers_WSTRB),
        .m_axi_wvalid(m00_regslice_to_m00_couplers_WVALID),
        .s_axi_araddr(auto_pc_to_m00_regslice_ARADDR),
        .s_axi_arburst(auto_pc_to_m00_regslice_ARBURST),
        .s_axi_arcache(auto_pc_to_m00_regslice_ARCACHE),
        .s_axi_arid(auto_pc_to_m00_regslice_ARID),
        .s_axi_arlen(auto_pc_to_m00_regslice_ARLEN),
        .s_axi_arlock(auto_pc_to_m00_regslice_ARLOCK),
        .s_axi_arprot(auto_pc_to_m00_regslice_ARPROT),
        .s_axi_arqos(auto_pc_to_m00_regslice_ARQOS),
        .s_axi_arready(auto_pc_to_m00_regslice_ARREADY),
        .s_axi_arsize(auto_pc_to_m00_regslice_ARSIZE),
        .s_axi_arvalid(auto_pc_to_m00_regslice_ARVALID),
        .s_axi_awaddr(auto_pc_to_m00_regslice_AWADDR),
        .s_axi_awburst(auto_pc_to_m00_regslice_AWBURST),
        .s_axi_awcache(auto_pc_to_m00_regslice_AWCACHE),
        .s_axi_awid(auto_pc_to_m00_regslice_AWID),
        .s_axi_awlen(auto_pc_to_m00_regslice_AWLEN),
        .s_axi_awlock(auto_pc_to_m00_regslice_AWLOCK),
        .s_axi_awprot(auto_pc_to_m00_regslice_AWPROT),
        .s_axi_awqos(auto_pc_to_m00_regslice_AWQOS),
        .s_axi_awready(auto_pc_to_m00_regslice_AWREADY),
        .s_axi_awsize(auto_pc_to_m00_regslice_AWSIZE),
        .s_axi_awvalid(auto_pc_to_m00_regslice_AWVALID),
        .s_axi_bid(auto_pc_to_m00_regslice_BID),
        .s_axi_bready(auto_pc_to_m00_regslice_BREADY),
        .s_axi_bresp(auto_pc_to_m00_regslice_BRESP),
        .s_axi_bvalid(auto_pc_to_m00_regslice_BVALID),
        .s_axi_rdata(auto_pc_to_m00_regslice_RDATA),
        .s_axi_rid(auto_pc_to_m00_regslice_RID),
        .s_axi_rlast(auto_pc_to_m00_regslice_RLAST),
        .s_axi_rready(auto_pc_to_m00_regslice_RREADY),
        .s_axi_rresp(auto_pc_to_m00_regslice_RRESP),
        .s_axi_rvalid(auto_pc_to_m00_regslice_RVALID),
        .s_axi_wdata(auto_pc_to_m00_regslice_WDATA),
        .s_axi_wid(auto_pc_to_m00_regslice_WID),
        .s_axi_wlast(auto_pc_to_m00_regslice_WLAST),
        .s_axi_wready(auto_pc_to_m00_regslice_WREADY),
        .s_axi_wstrb(auto_pc_to_m00_regslice_WSTRB),
        .s_axi_wvalid(auto_pc_to_m00_regslice_WVALID));
endmodule

module m01_couplers_imp_YRHFB1
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input [0:0]M_ARESETN;
  output [12:0]M_AXI_araddr;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [12:0]M_AXI_awaddr;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input [0:0]S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire [0:0]M_ARESETN_1;
  wire [31:0]m01_couplers_to_m01_regslice_ARADDR;
  wire [2:0]m01_couplers_to_m01_regslice_ARPROT;
  wire m01_couplers_to_m01_regslice_ARREADY;
  wire m01_couplers_to_m01_regslice_ARVALID;
  wire [31:0]m01_couplers_to_m01_regslice_AWADDR;
  wire [2:0]m01_couplers_to_m01_regslice_AWPROT;
  wire m01_couplers_to_m01_regslice_AWREADY;
  wire m01_couplers_to_m01_regslice_AWVALID;
  wire m01_couplers_to_m01_regslice_BREADY;
  wire [1:0]m01_couplers_to_m01_regslice_BRESP;
  wire m01_couplers_to_m01_regslice_BVALID;
  wire [31:0]m01_couplers_to_m01_regslice_RDATA;
  wire m01_couplers_to_m01_regslice_RREADY;
  wire [1:0]m01_couplers_to_m01_regslice_RRESP;
  wire m01_couplers_to_m01_regslice_RVALID;
  wire [31:0]m01_couplers_to_m01_regslice_WDATA;
  wire m01_couplers_to_m01_regslice_WREADY;
  wire [3:0]m01_couplers_to_m01_regslice_WSTRB;
  wire m01_couplers_to_m01_regslice_WVALID;
  wire [12:0]m01_regslice_to_m01_couplers_ARADDR;
  wire m01_regslice_to_m01_couplers_ARREADY;
  wire m01_regslice_to_m01_couplers_ARVALID;
  wire [12:0]m01_regslice_to_m01_couplers_AWADDR;
  wire m01_regslice_to_m01_couplers_AWREADY;
  wire m01_regslice_to_m01_couplers_AWVALID;
  wire m01_regslice_to_m01_couplers_BREADY;
  wire [1:0]m01_regslice_to_m01_couplers_BRESP;
  wire m01_regslice_to_m01_couplers_BVALID;
  wire [31:0]m01_regslice_to_m01_couplers_RDATA;
  wire m01_regslice_to_m01_couplers_RREADY;
  wire [1:0]m01_regslice_to_m01_couplers_RRESP;
  wire m01_regslice_to_m01_couplers_RVALID;
  wire [31:0]m01_regslice_to_m01_couplers_WDATA;
  wire m01_regslice_to_m01_couplers_WREADY;
  wire [3:0]m01_regslice_to_m01_couplers_WSTRB;
  wire m01_regslice_to_m01_couplers_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN[0];
  assign M_AXI_araddr[12:0] = m01_regslice_to_m01_couplers_ARADDR;
  assign M_AXI_arvalid = m01_regslice_to_m01_couplers_ARVALID;
  assign M_AXI_awaddr[12:0] = m01_regslice_to_m01_couplers_AWADDR;
  assign M_AXI_awvalid = m01_regslice_to_m01_couplers_AWVALID;
  assign M_AXI_bready = m01_regslice_to_m01_couplers_BREADY;
  assign M_AXI_rready = m01_regslice_to_m01_couplers_RREADY;
  assign M_AXI_wdata[31:0] = m01_regslice_to_m01_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = m01_regslice_to_m01_couplers_WSTRB;
  assign M_AXI_wvalid = m01_regslice_to_m01_couplers_WVALID;
  assign S_AXI_arready = m01_couplers_to_m01_regslice_ARREADY;
  assign S_AXI_awready = m01_couplers_to_m01_regslice_AWREADY;
  assign S_AXI_bresp[1:0] = m01_couplers_to_m01_regslice_BRESP;
  assign S_AXI_bvalid = m01_couplers_to_m01_regslice_BVALID;
  assign S_AXI_rdata[31:0] = m01_couplers_to_m01_regslice_RDATA;
  assign S_AXI_rresp[1:0] = m01_couplers_to_m01_regslice_RRESP;
  assign S_AXI_rvalid = m01_couplers_to_m01_regslice_RVALID;
  assign S_AXI_wready = m01_couplers_to_m01_regslice_WREADY;
  assign m01_couplers_to_m01_regslice_ARADDR = S_AXI_araddr[31:0];
  assign m01_couplers_to_m01_regslice_ARPROT = S_AXI_arprot[2:0];
  assign m01_couplers_to_m01_regslice_ARVALID = S_AXI_arvalid;
  assign m01_couplers_to_m01_regslice_AWADDR = S_AXI_awaddr[31:0];
  assign m01_couplers_to_m01_regslice_AWPROT = S_AXI_awprot[2:0];
  assign m01_couplers_to_m01_regslice_AWVALID = S_AXI_awvalid;
  assign m01_couplers_to_m01_regslice_BREADY = S_AXI_bready;
  assign m01_couplers_to_m01_regslice_RREADY = S_AXI_rready;
  assign m01_couplers_to_m01_regslice_WDATA = S_AXI_wdata[31:0];
  assign m01_couplers_to_m01_regslice_WSTRB = S_AXI_wstrb[3:0];
  assign m01_couplers_to_m01_regslice_WVALID = S_AXI_wvalid;
  assign m01_regslice_to_m01_couplers_ARREADY = M_AXI_arready;
  assign m01_regslice_to_m01_couplers_AWREADY = M_AXI_awready;
  assign m01_regslice_to_m01_couplers_BRESP = M_AXI_bresp[1:0];
  assign m01_regslice_to_m01_couplers_BVALID = M_AXI_bvalid;
  assign m01_regslice_to_m01_couplers_RDATA = M_AXI_rdata[31:0];
  assign m01_regslice_to_m01_couplers_RRESP = M_AXI_rresp[1:0];
  assign m01_regslice_to_m01_couplers_RVALID = M_AXI_rvalid;
  assign m01_regslice_to_m01_couplers_WREADY = M_AXI_wready;
  zc702_m01_regslice_0 m01_regslice
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(m01_regslice_to_m01_couplers_ARADDR),
        .m_axi_arready(m01_regslice_to_m01_couplers_ARREADY),
        .m_axi_arvalid(m01_regslice_to_m01_couplers_ARVALID),
        .m_axi_awaddr(m01_regslice_to_m01_couplers_AWADDR),
        .m_axi_awready(m01_regslice_to_m01_couplers_AWREADY),
        .m_axi_awvalid(m01_regslice_to_m01_couplers_AWVALID),
        .m_axi_bready(m01_regslice_to_m01_couplers_BREADY),
        .m_axi_bresp(m01_regslice_to_m01_couplers_BRESP),
        .m_axi_bvalid(m01_regslice_to_m01_couplers_BVALID),
        .m_axi_rdata(m01_regslice_to_m01_couplers_RDATA),
        .m_axi_rready(m01_regslice_to_m01_couplers_RREADY),
        .m_axi_rresp(m01_regslice_to_m01_couplers_RRESP),
        .m_axi_rvalid(m01_regslice_to_m01_couplers_RVALID),
        .m_axi_wdata(m01_regslice_to_m01_couplers_WDATA),
        .m_axi_wready(m01_regslice_to_m01_couplers_WREADY),
        .m_axi_wstrb(m01_regslice_to_m01_couplers_WSTRB),
        .m_axi_wvalid(m01_regslice_to_m01_couplers_WVALID),
        .s_axi_araddr(m01_couplers_to_m01_regslice_ARADDR[12:0]),
        .s_axi_arprot(m01_couplers_to_m01_regslice_ARPROT),
        .s_axi_arready(m01_couplers_to_m01_regslice_ARREADY),
        .s_axi_arvalid(m01_couplers_to_m01_regslice_ARVALID),
        .s_axi_awaddr(m01_couplers_to_m01_regslice_AWADDR[12:0]),
        .s_axi_awprot(m01_couplers_to_m01_regslice_AWPROT),
        .s_axi_awready(m01_couplers_to_m01_regslice_AWREADY),
        .s_axi_awvalid(m01_couplers_to_m01_regslice_AWVALID),
        .s_axi_bready(m01_couplers_to_m01_regslice_BREADY),
        .s_axi_bresp(m01_couplers_to_m01_regslice_BRESP),
        .s_axi_bvalid(m01_couplers_to_m01_regslice_BVALID),
        .s_axi_rdata(m01_couplers_to_m01_regslice_RDATA),
        .s_axi_rready(m01_couplers_to_m01_regslice_RREADY),
        .s_axi_rresp(m01_couplers_to_m01_regslice_RRESP),
        .s_axi_rvalid(m01_couplers_to_m01_regslice_RVALID),
        .s_axi_wdata(m01_couplers_to_m01_regslice_WDATA),
        .s_axi_wready(m01_couplers_to_m01_regslice_WREADY),
        .s_axi_wstrb(m01_couplers_to_m01_regslice_WSTRB),
        .s_axi_wvalid(m01_couplers_to_m01_regslice_WVALID));
endmodule

module s00_couplers_imp_14Q0TRY
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wid,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input [0:0]M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input [0:0]S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [11:0]S_AXI_arid;
  input [3:0]S_AXI_arlen;
  input [1:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [11:0]S_AXI_awid;
  input [3:0]S_AXI_awlen;
  input [1:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  output [11:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output [11:0]S_AXI_rid;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input [11:0]S_AXI_wid;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire [0:0]M_ARESETN_1;
  wire S_ACLK_1;
  wire [0:0]S_ARESETN_1;
  wire [31:0]auto_pc_to_s00_data_fifo_ARADDR;
  wire [2:0]auto_pc_to_s00_data_fifo_ARPROT;
  wire auto_pc_to_s00_data_fifo_ARREADY;
  wire auto_pc_to_s00_data_fifo_ARVALID;
  wire [31:0]auto_pc_to_s00_data_fifo_AWADDR;
  wire [2:0]auto_pc_to_s00_data_fifo_AWPROT;
  wire auto_pc_to_s00_data_fifo_AWREADY;
  wire auto_pc_to_s00_data_fifo_AWVALID;
  wire auto_pc_to_s00_data_fifo_BREADY;
  wire [1:0]auto_pc_to_s00_data_fifo_BRESP;
  wire auto_pc_to_s00_data_fifo_BVALID;
  wire [31:0]auto_pc_to_s00_data_fifo_RDATA;
  wire auto_pc_to_s00_data_fifo_RREADY;
  wire [1:0]auto_pc_to_s00_data_fifo_RRESP;
  wire auto_pc_to_s00_data_fifo_RVALID;
  wire [31:0]auto_pc_to_s00_data_fifo_WDATA;
  wire auto_pc_to_s00_data_fifo_WREADY;
  wire [3:0]auto_pc_to_s00_data_fifo_WSTRB;
  wire auto_pc_to_s00_data_fifo_WVALID;
  wire [31:0]s00_couplers_to_s00_regslice_ARADDR;
  wire [1:0]s00_couplers_to_s00_regslice_ARBURST;
  wire [3:0]s00_couplers_to_s00_regslice_ARCACHE;
  wire [11:0]s00_couplers_to_s00_regslice_ARID;
  wire [3:0]s00_couplers_to_s00_regslice_ARLEN;
  wire [1:0]s00_couplers_to_s00_regslice_ARLOCK;
  wire [2:0]s00_couplers_to_s00_regslice_ARPROT;
  wire [3:0]s00_couplers_to_s00_regslice_ARQOS;
  wire s00_couplers_to_s00_regslice_ARREADY;
  wire [2:0]s00_couplers_to_s00_regslice_ARSIZE;
  wire s00_couplers_to_s00_regslice_ARVALID;
  wire [31:0]s00_couplers_to_s00_regslice_AWADDR;
  wire [1:0]s00_couplers_to_s00_regslice_AWBURST;
  wire [3:0]s00_couplers_to_s00_regslice_AWCACHE;
  wire [11:0]s00_couplers_to_s00_regslice_AWID;
  wire [3:0]s00_couplers_to_s00_regslice_AWLEN;
  wire [1:0]s00_couplers_to_s00_regslice_AWLOCK;
  wire [2:0]s00_couplers_to_s00_regslice_AWPROT;
  wire [3:0]s00_couplers_to_s00_regslice_AWQOS;
  wire s00_couplers_to_s00_regslice_AWREADY;
  wire [2:0]s00_couplers_to_s00_regslice_AWSIZE;
  wire s00_couplers_to_s00_regslice_AWVALID;
  wire [11:0]s00_couplers_to_s00_regslice_BID;
  wire s00_couplers_to_s00_regslice_BREADY;
  wire [1:0]s00_couplers_to_s00_regslice_BRESP;
  wire s00_couplers_to_s00_regslice_BVALID;
  wire [31:0]s00_couplers_to_s00_regslice_RDATA;
  wire [11:0]s00_couplers_to_s00_regslice_RID;
  wire s00_couplers_to_s00_regslice_RLAST;
  wire s00_couplers_to_s00_regslice_RREADY;
  wire [1:0]s00_couplers_to_s00_regslice_RRESP;
  wire s00_couplers_to_s00_regslice_RVALID;
  wire [31:0]s00_couplers_to_s00_regslice_WDATA;
  wire [11:0]s00_couplers_to_s00_regslice_WID;
  wire s00_couplers_to_s00_regslice_WLAST;
  wire s00_couplers_to_s00_regslice_WREADY;
  wire [3:0]s00_couplers_to_s00_regslice_WSTRB;
  wire s00_couplers_to_s00_regslice_WVALID;
  wire [31:0]s00_data_fifo_to_s00_couplers_ARADDR;
  wire [2:0]s00_data_fifo_to_s00_couplers_ARPROT;
  wire s00_data_fifo_to_s00_couplers_ARREADY;
  wire s00_data_fifo_to_s00_couplers_ARVALID;
  wire [31:0]s00_data_fifo_to_s00_couplers_AWADDR;
  wire [2:0]s00_data_fifo_to_s00_couplers_AWPROT;
  wire s00_data_fifo_to_s00_couplers_AWREADY;
  wire s00_data_fifo_to_s00_couplers_AWVALID;
  wire s00_data_fifo_to_s00_couplers_BREADY;
  wire [1:0]s00_data_fifo_to_s00_couplers_BRESP;
  wire s00_data_fifo_to_s00_couplers_BVALID;
  wire [31:0]s00_data_fifo_to_s00_couplers_RDATA;
  wire s00_data_fifo_to_s00_couplers_RREADY;
  wire [1:0]s00_data_fifo_to_s00_couplers_RRESP;
  wire s00_data_fifo_to_s00_couplers_RVALID;
  wire [31:0]s00_data_fifo_to_s00_couplers_WDATA;
  wire s00_data_fifo_to_s00_couplers_WREADY;
  wire [3:0]s00_data_fifo_to_s00_couplers_WSTRB;
  wire s00_data_fifo_to_s00_couplers_WVALID;
  wire [31:0]s00_regslice_to_auto_pc_ARADDR;
  wire [1:0]s00_regslice_to_auto_pc_ARBURST;
  wire [3:0]s00_regslice_to_auto_pc_ARCACHE;
  wire [11:0]s00_regslice_to_auto_pc_ARID;
  wire [3:0]s00_regslice_to_auto_pc_ARLEN;
  wire [1:0]s00_regslice_to_auto_pc_ARLOCK;
  wire [2:0]s00_regslice_to_auto_pc_ARPROT;
  wire [3:0]s00_regslice_to_auto_pc_ARQOS;
  wire s00_regslice_to_auto_pc_ARREADY;
  wire [2:0]s00_regslice_to_auto_pc_ARSIZE;
  wire s00_regslice_to_auto_pc_ARVALID;
  wire [31:0]s00_regslice_to_auto_pc_AWADDR;
  wire [1:0]s00_regslice_to_auto_pc_AWBURST;
  wire [3:0]s00_regslice_to_auto_pc_AWCACHE;
  wire [11:0]s00_regslice_to_auto_pc_AWID;
  wire [3:0]s00_regslice_to_auto_pc_AWLEN;
  wire [1:0]s00_regslice_to_auto_pc_AWLOCK;
  wire [2:0]s00_regslice_to_auto_pc_AWPROT;
  wire [3:0]s00_regslice_to_auto_pc_AWQOS;
  wire s00_regslice_to_auto_pc_AWREADY;
  wire [2:0]s00_regslice_to_auto_pc_AWSIZE;
  wire s00_regslice_to_auto_pc_AWVALID;
  wire [11:0]s00_regslice_to_auto_pc_BID;
  wire s00_regslice_to_auto_pc_BREADY;
  wire [1:0]s00_regslice_to_auto_pc_BRESP;
  wire s00_regslice_to_auto_pc_BVALID;
  wire [31:0]s00_regslice_to_auto_pc_RDATA;
  wire [11:0]s00_regslice_to_auto_pc_RID;
  wire s00_regslice_to_auto_pc_RLAST;
  wire s00_regslice_to_auto_pc_RREADY;
  wire [1:0]s00_regslice_to_auto_pc_RRESP;
  wire s00_regslice_to_auto_pc_RVALID;
  wire [31:0]s00_regslice_to_auto_pc_WDATA;
  wire [11:0]s00_regslice_to_auto_pc_WID;
  wire s00_regslice_to_auto_pc_WLAST;
  wire s00_regslice_to_auto_pc_WREADY;
  wire [3:0]s00_regslice_to_auto_pc_WSTRB;
  wire s00_regslice_to_auto_pc_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN[0];
  assign M_AXI_araddr[31:0] = s00_data_fifo_to_s00_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = s00_data_fifo_to_s00_couplers_ARPROT;
  assign M_AXI_arvalid = s00_data_fifo_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[31:0] = s00_data_fifo_to_s00_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = s00_data_fifo_to_s00_couplers_AWPROT;
  assign M_AXI_awvalid = s00_data_fifo_to_s00_couplers_AWVALID;
  assign M_AXI_bready = s00_data_fifo_to_s00_couplers_BREADY;
  assign M_AXI_rready = s00_data_fifo_to_s00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = s00_data_fifo_to_s00_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = s00_data_fifo_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = s00_data_fifo_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN[0];
  assign S_AXI_arready = s00_couplers_to_s00_regslice_ARREADY;
  assign S_AXI_awready = s00_couplers_to_s00_regslice_AWREADY;
  assign S_AXI_bid[11:0] = s00_couplers_to_s00_regslice_BID;
  assign S_AXI_bresp[1:0] = s00_couplers_to_s00_regslice_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_s00_regslice_BVALID;
  assign S_AXI_rdata[31:0] = s00_couplers_to_s00_regslice_RDATA;
  assign S_AXI_rid[11:0] = s00_couplers_to_s00_regslice_RID;
  assign S_AXI_rlast = s00_couplers_to_s00_regslice_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_s00_regslice_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_s00_regslice_RVALID;
  assign S_AXI_wready = s00_couplers_to_s00_regslice_WREADY;
  assign s00_couplers_to_s00_regslice_ARADDR = S_AXI_araddr[31:0];
  assign s00_couplers_to_s00_regslice_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_s00_regslice_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_s00_regslice_ARID = S_AXI_arid[11:0];
  assign s00_couplers_to_s00_regslice_ARLEN = S_AXI_arlen[3:0];
  assign s00_couplers_to_s00_regslice_ARLOCK = S_AXI_arlock[1:0];
  assign s00_couplers_to_s00_regslice_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_s00_regslice_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_s00_regslice_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_s00_regslice_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_s00_regslice_AWADDR = S_AXI_awaddr[31:0];
  assign s00_couplers_to_s00_regslice_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_s00_regslice_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_s00_regslice_AWID = S_AXI_awid[11:0];
  assign s00_couplers_to_s00_regslice_AWLEN = S_AXI_awlen[3:0];
  assign s00_couplers_to_s00_regslice_AWLOCK = S_AXI_awlock[1:0];
  assign s00_couplers_to_s00_regslice_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_s00_regslice_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_s00_regslice_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_s00_regslice_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_s00_regslice_BREADY = S_AXI_bready;
  assign s00_couplers_to_s00_regslice_RREADY = S_AXI_rready;
  assign s00_couplers_to_s00_regslice_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_s00_regslice_WID = S_AXI_wid[11:0];
  assign s00_couplers_to_s00_regslice_WLAST = S_AXI_wlast;
  assign s00_couplers_to_s00_regslice_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_s00_regslice_WVALID = S_AXI_wvalid;
  assign s00_data_fifo_to_s00_couplers_ARREADY = M_AXI_arready;
  assign s00_data_fifo_to_s00_couplers_AWREADY = M_AXI_awready;
  assign s00_data_fifo_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign s00_data_fifo_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign s00_data_fifo_to_s00_couplers_RDATA = M_AXI_rdata[31:0];
  assign s00_data_fifo_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign s00_data_fifo_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign s00_data_fifo_to_s00_couplers_WREADY = M_AXI_wready;
  zc702_auto_pc_0 auto_pc
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(auto_pc_to_s00_data_fifo_ARADDR),
        .m_axi_arprot(auto_pc_to_s00_data_fifo_ARPROT),
        .m_axi_arready(auto_pc_to_s00_data_fifo_ARREADY),
        .m_axi_arvalid(auto_pc_to_s00_data_fifo_ARVALID),
        .m_axi_awaddr(auto_pc_to_s00_data_fifo_AWADDR),
        .m_axi_awprot(auto_pc_to_s00_data_fifo_AWPROT),
        .m_axi_awready(auto_pc_to_s00_data_fifo_AWREADY),
        .m_axi_awvalid(auto_pc_to_s00_data_fifo_AWVALID),
        .m_axi_bready(auto_pc_to_s00_data_fifo_BREADY),
        .m_axi_bresp(auto_pc_to_s00_data_fifo_BRESP),
        .m_axi_bvalid(auto_pc_to_s00_data_fifo_BVALID),
        .m_axi_rdata(auto_pc_to_s00_data_fifo_RDATA),
        .m_axi_rready(auto_pc_to_s00_data_fifo_RREADY),
        .m_axi_rresp(auto_pc_to_s00_data_fifo_RRESP),
        .m_axi_rvalid(auto_pc_to_s00_data_fifo_RVALID),
        .m_axi_wdata(auto_pc_to_s00_data_fifo_WDATA),
        .m_axi_wready(auto_pc_to_s00_data_fifo_WREADY),
        .m_axi_wstrb(auto_pc_to_s00_data_fifo_WSTRB),
        .m_axi_wvalid(auto_pc_to_s00_data_fifo_WVALID),
        .s_axi_araddr(s00_regslice_to_auto_pc_ARADDR),
        .s_axi_arburst(s00_regslice_to_auto_pc_ARBURST),
        .s_axi_arcache(s00_regslice_to_auto_pc_ARCACHE),
        .s_axi_arid(s00_regslice_to_auto_pc_ARID),
        .s_axi_arlen(s00_regslice_to_auto_pc_ARLEN),
        .s_axi_arlock(s00_regslice_to_auto_pc_ARLOCK),
        .s_axi_arprot(s00_regslice_to_auto_pc_ARPROT),
        .s_axi_arqos(s00_regslice_to_auto_pc_ARQOS),
        .s_axi_arready(s00_regslice_to_auto_pc_ARREADY),
        .s_axi_arsize(s00_regslice_to_auto_pc_ARSIZE),
        .s_axi_arvalid(s00_regslice_to_auto_pc_ARVALID),
        .s_axi_awaddr(s00_regslice_to_auto_pc_AWADDR),
        .s_axi_awburst(s00_regslice_to_auto_pc_AWBURST),
        .s_axi_awcache(s00_regslice_to_auto_pc_AWCACHE),
        .s_axi_awid(s00_regslice_to_auto_pc_AWID),
        .s_axi_awlen(s00_regslice_to_auto_pc_AWLEN),
        .s_axi_awlock(s00_regslice_to_auto_pc_AWLOCK),
        .s_axi_awprot(s00_regslice_to_auto_pc_AWPROT),
        .s_axi_awqos(s00_regslice_to_auto_pc_AWQOS),
        .s_axi_awready(s00_regslice_to_auto_pc_AWREADY),
        .s_axi_awsize(s00_regslice_to_auto_pc_AWSIZE),
        .s_axi_awvalid(s00_regslice_to_auto_pc_AWVALID),
        .s_axi_bid(s00_regslice_to_auto_pc_BID),
        .s_axi_bready(s00_regslice_to_auto_pc_BREADY),
        .s_axi_bresp(s00_regslice_to_auto_pc_BRESP),
        .s_axi_bvalid(s00_regslice_to_auto_pc_BVALID),
        .s_axi_rdata(s00_regslice_to_auto_pc_RDATA),
        .s_axi_rid(s00_regslice_to_auto_pc_RID),
        .s_axi_rlast(s00_regslice_to_auto_pc_RLAST),
        .s_axi_rready(s00_regslice_to_auto_pc_RREADY),
        .s_axi_rresp(s00_regslice_to_auto_pc_RRESP),
        .s_axi_rvalid(s00_regslice_to_auto_pc_RVALID),
        .s_axi_wdata(s00_regslice_to_auto_pc_WDATA),
        .s_axi_wid(s00_regslice_to_auto_pc_WID),
        .s_axi_wlast(s00_regslice_to_auto_pc_WLAST),
        .s_axi_wready(s00_regslice_to_auto_pc_WREADY),
        .s_axi_wstrb(s00_regslice_to_auto_pc_WSTRB),
        .s_axi_wvalid(s00_regslice_to_auto_pc_WVALID));
  zc702_s00_data_fifo_0 s00_data_fifo
       (.aclk(M_ACLK_1),
        .aresetn(M_ARESETN_1),
        .m_axi_araddr(s00_data_fifo_to_s00_couplers_ARADDR),
        .m_axi_arprot(s00_data_fifo_to_s00_couplers_ARPROT),
        .m_axi_arready(s00_data_fifo_to_s00_couplers_ARREADY),
        .m_axi_arvalid(s00_data_fifo_to_s00_couplers_ARVALID),
        .m_axi_awaddr(s00_data_fifo_to_s00_couplers_AWADDR),
        .m_axi_awprot(s00_data_fifo_to_s00_couplers_AWPROT),
        .m_axi_awready(s00_data_fifo_to_s00_couplers_AWREADY),
        .m_axi_awvalid(s00_data_fifo_to_s00_couplers_AWVALID),
        .m_axi_bready(s00_data_fifo_to_s00_couplers_BREADY),
        .m_axi_bresp(s00_data_fifo_to_s00_couplers_BRESP),
        .m_axi_bvalid(s00_data_fifo_to_s00_couplers_BVALID),
        .m_axi_rdata(s00_data_fifo_to_s00_couplers_RDATA),
        .m_axi_rready(s00_data_fifo_to_s00_couplers_RREADY),
        .m_axi_rresp(s00_data_fifo_to_s00_couplers_RRESP),
        .m_axi_rvalid(s00_data_fifo_to_s00_couplers_RVALID),
        .m_axi_wdata(s00_data_fifo_to_s00_couplers_WDATA),
        .m_axi_wready(s00_data_fifo_to_s00_couplers_WREADY),
        .m_axi_wstrb(s00_data_fifo_to_s00_couplers_WSTRB),
        .m_axi_wvalid(s00_data_fifo_to_s00_couplers_WVALID),
        .s_axi_araddr(auto_pc_to_s00_data_fifo_ARADDR),
        .s_axi_arprot(auto_pc_to_s00_data_fifo_ARPROT),
        .s_axi_arready(auto_pc_to_s00_data_fifo_ARREADY),
        .s_axi_arvalid(auto_pc_to_s00_data_fifo_ARVALID),
        .s_axi_awaddr(auto_pc_to_s00_data_fifo_AWADDR),
        .s_axi_awprot(auto_pc_to_s00_data_fifo_AWPROT),
        .s_axi_awready(auto_pc_to_s00_data_fifo_AWREADY),
        .s_axi_awvalid(auto_pc_to_s00_data_fifo_AWVALID),
        .s_axi_bready(auto_pc_to_s00_data_fifo_BREADY),
        .s_axi_bresp(auto_pc_to_s00_data_fifo_BRESP),
        .s_axi_bvalid(auto_pc_to_s00_data_fifo_BVALID),
        .s_axi_rdata(auto_pc_to_s00_data_fifo_RDATA),
        .s_axi_rready(auto_pc_to_s00_data_fifo_RREADY),
        .s_axi_rresp(auto_pc_to_s00_data_fifo_RRESP),
        .s_axi_rvalid(auto_pc_to_s00_data_fifo_RVALID),
        .s_axi_wdata(auto_pc_to_s00_data_fifo_WDATA),
        .s_axi_wready(auto_pc_to_s00_data_fifo_WREADY),
        .s_axi_wstrb(auto_pc_to_s00_data_fifo_WSTRB),
        .s_axi_wvalid(auto_pc_to_s00_data_fifo_WVALID));
  zc702_s00_regslice_0 s00_regslice
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(s00_regslice_to_auto_pc_ARADDR),
        .m_axi_arburst(s00_regslice_to_auto_pc_ARBURST),
        .m_axi_arcache(s00_regslice_to_auto_pc_ARCACHE),
        .m_axi_arid(s00_regslice_to_auto_pc_ARID),
        .m_axi_arlen(s00_regslice_to_auto_pc_ARLEN),
        .m_axi_arlock(s00_regslice_to_auto_pc_ARLOCK),
        .m_axi_arprot(s00_regslice_to_auto_pc_ARPROT),
        .m_axi_arqos(s00_regslice_to_auto_pc_ARQOS),
        .m_axi_arready(s00_regslice_to_auto_pc_ARREADY),
        .m_axi_arsize(s00_regslice_to_auto_pc_ARSIZE),
        .m_axi_arvalid(s00_regslice_to_auto_pc_ARVALID),
        .m_axi_awaddr(s00_regslice_to_auto_pc_AWADDR),
        .m_axi_awburst(s00_regslice_to_auto_pc_AWBURST),
        .m_axi_awcache(s00_regslice_to_auto_pc_AWCACHE),
        .m_axi_awid(s00_regslice_to_auto_pc_AWID),
        .m_axi_awlen(s00_regslice_to_auto_pc_AWLEN),
        .m_axi_awlock(s00_regslice_to_auto_pc_AWLOCK),
        .m_axi_awprot(s00_regslice_to_auto_pc_AWPROT),
        .m_axi_awqos(s00_regslice_to_auto_pc_AWQOS),
        .m_axi_awready(s00_regslice_to_auto_pc_AWREADY),
        .m_axi_awsize(s00_regslice_to_auto_pc_AWSIZE),
        .m_axi_awvalid(s00_regslice_to_auto_pc_AWVALID),
        .m_axi_bid(s00_regslice_to_auto_pc_BID),
        .m_axi_bready(s00_regslice_to_auto_pc_BREADY),
        .m_axi_bresp(s00_regslice_to_auto_pc_BRESP),
        .m_axi_bvalid(s00_regslice_to_auto_pc_BVALID),
        .m_axi_rdata(s00_regslice_to_auto_pc_RDATA),
        .m_axi_rid(s00_regslice_to_auto_pc_RID),
        .m_axi_rlast(s00_regslice_to_auto_pc_RLAST),
        .m_axi_rready(s00_regslice_to_auto_pc_RREADY),
        .m_axi_rresp(s00_regslice_to_auto_pc_RRESP),
        .m_axi_rvalid(s00_regslice_to_auto_pc_RVALID),
        .m_axi_wdata(s00_regslice_to_auto_pc_WDATA),
        .m_axi_wid(s00_regslice_to_auto_pc_WID),
        .m_axi_wlast(s00_regslice_to_auto_pc_WLAST),
        .m_axi_wready(s00_regslice_to_auto_pc_WREADY),
        .m_axi_wstrb(s00_regslice_to_auto_pc_WSTRB),
        .m_axi_wvalid(s00_regslice_to_auto_pc_WVALID),
        .s_axi_araddr(s00_couplers_to_s00_regslice_ARADDR),
        .s_axi_arburst(s00_couplers_to_s00_regslice_ARBURST),
        .s_axi_arcache(s00_couplers_to_s00_regslice_ARCACHE),
        .s_axi_arid(s00_couplers_to_s00_regslice_ARID),
        .s_axi_arlen(s00_couplers_to_s00_regslice_ARLEN),
        .s_axi_arlock(s00_couplers_to_s00_regslice_ARLOCK),
        .s_axi_arprot(s00_couplers_to_s00_regslice_ARPROT),
        .s_axi_arqos(s00_couplers_to_s00_regslice_ARQOS),
        .s_axi_arready(s00_couplers_to_s00_regslice_ARREADY),
        .s_axi_arsize(s00_couplers_to_s00_regslice_ARSIZE),
        .s_axi_arvalid(s00_couplers_to_s00_regslice_ARVALID),
        .s_axi_awaddr(s00_couplers_to_s00_regslice_AWADDR),
        .s_axi_awburst(s00_couplers_to_s00_regslice_AWBURST),
        .s_axi_awcache(s00_couplers_to_s00_regslice_AWCACHE),
        .s_axi_awid(s00_couplers_to_s00_regslice_AWID),
        .s_axi_awlen(s00_couplers_to_s00_regslice_AWLEN),
        .s_axi_awlock(s00_couplers_to_s00_regslice_AWLOCK),
        .s_axi_awprot(s00_couplers_to_s00_regslice_AWPROT),
        .s_axi_awqos(s00_couplers_to_s00_regslice_AWQOS),
        .s_axi_awready(s00_couplers_to_s00_regslice_AWREADY),
        .s_axi_awsize(s00_couplers_to_s00_regslice_AWSIZE),
        .s_axi_awvalid(s00_couplers_to_s00_regslice_AWVALID),
        .s_axi_bid(s00_couplers_to_s00_regslice_BID),
        .s_axi_bready(s00_couplers_to_s00_regslice_BREADY),
        .s_axi_bresp(s00_couplers_to_s00_regslice_BRESP),
        .s_axi_bvalid(s00_couplers_to_s00_regslice_BVALID),
        .s_axi_rdata(s00_couplers_to_s00_regslice_RDATA),
        .s_axi_rid(s00_couplers_to_s00_regslice_RID),
        .s_axi_rlast(s00_couplers_to_s00_regslice_RLAST),
        .s_axi_rready(s00_couplers_to_s00_regslice_RREADY),
        .s_axi_rresp(s00_couplers_to_s00_regslice_RRESP),
        .s_axi_rvalid(s00_couplers_to_s00_regslice_RVALID),
        .s_axi_wdata(s00_couplers_to_s00_regslice_WDATA),
        .s_axi_wid(s00_couplers_to_s00_regslice_WID),
        .s_axi_wlast(s00_couplers_to_s00_regslice_WLAST),
        .s_axi_wready(s00_couplers_to_s00_regslice_WREADY),
        .s_axi_wstrb(s00_couplers_to_s00_regslice_WSTRB),
        .s_axi_wvalid(s00_couplers_to_s00_regslice_WVALID));
endmodule

module s00_couplers_imp_QU0DDF
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arregion,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awregion,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input [0:0]M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [7:0]M_AXI_arlen;
  output [0:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [7:0]M_AXI_awlen;
  output [0:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [63:0]M_AXI_rdata;
  input M_AXI_rlast;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [63:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [7:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input [0:0]S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [7:0]S_AXI_arlen;
  input [1:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [3:0]S_AXI_arregion;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [7:0]S_AXI_awlen;
  input [1:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [3:0]S_AXI_awregion;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire [0:0]M_ARESETN_1;
  wire S_ACLK_1;
  wire [0:0]S_ARESETN_1;
  wire [31:0]auto_us_df_to_s00_couplers_ARADDR;
  wire [1:0]auto_us_df_to_s00_couplers_ARBURST;
  wire [3:0]auto_us_df_to_s00_couplers_ARCACHE;
  wire [7:0]auto_us_df_to_s00_couplers_ARLEN;
  wire [0:0]auto_us_df_to_s00_couplers_ARLOCK;
  wire [2:0]auto_us_df_to_s00_couplers_ARPROT;
  wire [3:0]auto_us_df_to_s00_couplers_ARQOS;
  wire auto_us_df_to_s00_couplers_ARREADY;
  wire [2:0]auto_us_df_to_s00_couplers_ARSIZE;
  wire auto_us_df_to_s00_couplers_ARVALID;
  wire [31:0]auto_us_df_to_s00_couplers_AWADDR;
  wire [1:0]auto_us_df_to_s00_couplers_AWBURST;
  wire [3:0]auto_us_df_to_s00_couplers_AWCACHE;
  wire [7:0]auto_us_df_to_s00_couplers_AWLEN;
  wire [0:0]auto_us_df_to_s00_couplers_AWLOCK;
  wire [2:0]auto_us_df_to_s00_couplers_AWPROT;
  wire [3:0]auto_us_df_to_s00_couplers_AWQOS;
  wire auto_us_df_to_s00_couplers_AWREADY;
  wire [2:0]auto_us_df_to_s00_couplers_AWSIZE;
  wire auto_us_df_to_s00_couplers_AWVALID;
  wire auto_us_df_to_s00_couplers_BREADY;
  wire [1:0]auto_us_df_to_s00_couplers_BRESP;
  wire auto_us_df_to_s00_couplers_BVALID;
  wire [63:0]auto_us_df_to_s00_couplers_RDATA;
  wire auto_us_df_to_s00_couplers_RLAST;
  wire auto_us_df_to_s00_couplers_RREADY;
  wire [1:0]auto_us_df_to_s00_couplers_RRESP;
  wire auto_us_df_to_s00_couplers_RVALID;
  wire [63:0]auto_us_df_to_s00_couplers_WDATA;
  wire auto_us_df_to_s00_couplers_WLAST;
  wire auto_us_df_to_s00_couplers_WREADY;
  wire [7:0]auto_us_df_to_s00_couplers_WSTRB;
  wire auto_us_df_to_s00_couplers_WVALID;
  wire [31:0]s00_couplers_to_s00_regslice_ARADDR;
  wire [1:0]s00_couplers_to_s00_regslice_ARBURST;
  wire [3:0]s00_couplers_to_s00_regslice_ARCACHE;
  wire [7:0]s00_couplers_to_s00_regslice_ARLEN;
  wire [1:0]s00_couplers_to_s00_regslice_ARLOCK;
  wire [2:0]s00_couplers_to_s00_regslice_ARPROT;
  wire [3:0]s00_couplers_to_s00_regslice_ARQOS;
  wire s00_couplers_to_s00_regslice_ARREADY;
  wire [3:0]s00_couplers_to_s00_regslice_ARREGION;
  wire [2:0]s00_couplers_to_s00_regslice_ARSIZE;
  wire s00_couplers_to_s00_regslice_ARVALID;
  wire [31:0]s00_couplers_to_s00_regslice_AWADDR;
  wire [1:0]s00_couplers_to_s00_regslice_AWBURST;
  wire [3:0]s00_couplers_to_s00_regslice_AWCACHE;
  wire [7:0]s00_couplers_to_s00_regslice_AWLEN;
  wire [1:0]s00_couplers_to_s00_regslice_AWLOCK;
  wire [2:0]s00_couplers_to_s00_regslice_AWPROT;
  wire [3:0]s00_couplers_to_s00_regslice_AWQOS;
  wire s00_couplers_to_s00_regslice_AWREADY;
  wire [3:0]s00_couplers_to_s00_regslice_AWREGION;
  wire [2:0]s00_couplers_to_s00_regslice_AWSIZE;
  wire s00_couplers_to_s00_regslice_AWVALID;
  wire s00_couplers_to_s00_regslice_BREADY;
  wire [1:0]s00_couplers_to_s00_regslice_BRESP;
  wire s00_couplers_to_s00_regslice_BVALID;
  wire [31:0]s00_couplers_to_s00_regslice_RDATA;
  wire s00_couplers_to_s00_regslice_RLAST;
  wire s00_couplers_to_s00_regslice_RREADY;
  wire [1:0]s00_couplers_to_s00_regslice_RRESP;
  wire s00_couplers_to_s00_regslice_RVALID;
  wire [31:0]s00_couplers_to_s00_regslice_WDATA;
  wire s00_couplers_to_s00_regslice_WLAST;
  wire s00_couplers_to_s00_regslice_WREADY;
  wire [3:0]s00_couplers_to_s00_regslice_WSTRB;
  wire s00_couplers_to_s00_regslice_WVALID;
  wire [31:0]s00_regslice_to_auto_us_df_ARADDR;
  wire [1:0]s00_regslice_to_auto_us_df_ARBURST;
  wire [3:0]s00_regslice_to_auto_us_df_ARCACHE;
  wire [7:0]s00_regslice_to_auto_us_df_ARLEN;
  wire [0:0]s00_regslice_to_auto_us_df_ARLOCK;
  wire [2:0]s00_regslice_to_auto_us_df_ARPROT;
  wire [3:0]s00_regslice_to_auto_us_df_ARQOS;
  wire s00_regslice_to_auto_us_df_ARREADY;
  wire [3:0]s00_regslice_to_auto_us_df_ARREGION;
  wire [2:0]s00_regslice_to_auto_us_df_ARSIZE;
  wire s00_regslice_to_auto_us_df_ARVALID;
  wire [31:0]s00_regslice_to_auto_us_df_AWADDR;
  wire [1:0]s00_regslice_to_auto_us_df_AWBURST;
  wire [3:0]s00_regslice_to_auto_us_df_AWCACHE;
  wire [7:0]s00_regslice_to_auto_us_df_AWLEN;
  wire [0:0]s00_regslice_to_auto_us_df_AWLOCK;
  wire [2:0]s00_regslice_to_auto_us_df_AWPROT;
  wire [3:0]s00_regslice_to_auto_us_df_AWQOS;
  wire s00_regslice_to_auto_us_df_AWREADY;
  wire [3:0]s00_regslice_to_auto_us_df_AWREGION;
  wire [2:0]s00_regslice_to_auto_us_df_AWSIZE;
  wire s00_regslice_to_auto_us_df_AWVALID;
  wire s00_regslice_to_auto_us_df_BREADY;
  wire [1:0]s00_regslice_to_auto_us_df_BRESP;
  wire s00_regslice_to_auto_us_df_BVALID;
  wire [31:0]s00_regslice_to_auto_us_df_RDATA;
  wire s00_regslice_to_auto_us_df_RLAST;
  wire s00_regslice_to_auto_us_df_RREADY;
  wire [1:0]s00_regslice_to_auto_us_df_RRESP;
  wire s00_regslice_to_auto_us_df_RVALID;
  wire [31:0]s00_regslice_to_auto_us_df_WDATA;
  wire s00_regslice_to_auto_us_df_WLAST;
  wire s00_regslice_to_auto_us_df_WREADY;
  wire [3:0]s00_regslice_to_auto_us_df_WSTRB;
  wire s00_regslice_to_auto_us_df_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN[0];
  assign M_AXI_araddr[31:0] = auto_us_df_to_s00_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = auto_us_df_to_s00_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = auto_us_df_to_s00_couplers_ARCACHE;
  assign M_AXI_arlen[7:0] = auto_us_df_to_s00_couplers_ARLEN;
  assign M_AXI_arlock[0] = auto_us_df_to_s00_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = auto_us_df_to_s00_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = auto_us_df_to_s00_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = auto_us_df_to_s00_couplers_ARSIZE;
  assign M_AXI_arvalid = auto_us_df_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[31:0] = auto_us_df_to_s00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = auto_us_df_to_s00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = auto_us_df_to_s00_couplers_AWCACHE;
  assign M_AXI_awlen[7:0] = auto_us_df_to_s00_couplers_AWLEN;
  assign M_AXI_awlock[0] = auto_us_df_to_s00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = auto_us_df_to_s00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = auto_us_df_to_s00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = auto_us_df_to_s00_couplers_AWSIZE;
  assign M_AXI_awvalid = auto_us_df_to_s00_couplers_AWVALID;
  assign M_AXI_bready = auto_us_df_to_s00_couplers_BREADY;
  assign M_AXI_rready = auto_us_df_to_s00_couplers_RREADY;
  assign M_AXI_wdata[63:0] = auto_us_df_to_s00_couplers_WDATA;
  assign M_AXI_wlast = auto_us_df_to_s00_couplers_WLAST;
  assign M_AXI_wstrb[7:0] = auto_us_df_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_us_df_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN[0];
  assign S_AXI_arready = s00_couplers_to_s00_regslice_ARREADY;
  assign S_AXI_awready = s00_couplers_to_s00_regslice_AWREADY;
  assign S_AXI_bresp[1:0] = s00_couplers_to_s00_regslice_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_s00_regslice_BVALID;
  assign S_AXI_rdata[31:0] = s00_couplers_to_s00_regslice_RDATA;
  assign S_AXI_rlast = s00_couplers_to_s00_regslice_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_s00_regslice_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_s00_regslice_RVALID;
  assign S_AXI_wready = s00_couplers_to_s00_regslice_WREADY;
  assign auto_us_df_to_s00_couplers_ARREADY = M_AXI_arready;
  assign auto_us_df_to_s00_couplers_AWREADY = M_AXI_awready;
  assign auto_us_df_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_us_df_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign auto_us_df_to_s00_couplers_RDATA = M_AXI_rdata[63:0];
  assign auto_us_df_to_s00_couplers_RLAST = M_AXI_rlast;
  assign auto_us_df_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_us_df_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign auto_us_df_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_s00_regslice_ARADDR = S_AXI_araddr[31:0];
  assign s00_couplers_to_s00_regslice_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_s00_regslice_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_s00_regslice_ARLEN = S_AXI_arlen[7:0];
  assign s00_couplers_to_s00_regslice_ARLOCK = S_AXI_arlock[1:0];
  assign s00_couplers_to_s00_regslice_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_s00_regslice_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_s00_regslice_ARREGION = S_AXI_arregion[3:0];
  assign s00_couplers_to_s00_regslice_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_s00_regslice_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_s00_regslice_AWADDR = S_AXI_awaddr[31:0];
  assign s00_couplers_to_s00_regslice_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_s00_regslice_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_s00_regslice_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_s00_regslice_AWLOCK = S_AXI_awlock[1:0];
  assign s00_couplers_to_s00_regslice_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_s00_regslice_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_s00_regslice_AWREGION = S_AXI_awregion[3:0];
  assign s00_couplers_to_s00_regslice_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_s00_regslice_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_s00_regslice_BREADY = S_AXI_bready;
  assign s00_couplers_to_s00_regslice_RREADY = S_AXI_rready;
  assign s00_couplers_to_s00_regslice_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_s00_regslice_WLAST = S_AXI_wlast;
  assign s00_couplers_to_s00_regslice_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_s00_regslice_WVALID = S_AXI_wvalid;
  zc702_auto_us_df_0 auto_us_df
       (.m_axi_araddr(auto_us_df_to_s00_couplers_ARADDR),
        .m_axi_arburst(auto_us_df_to_s00_couplers_ARBURST),
        .m_axi_arcache(auto_us_df_to_s00_couplers_ARCACHE),
        .m_axi_arlen(auto_us_df_to_s00_couplers_ARLEN),
        .m_axi_arlock(auto_us_df_to_s00_couplers_ARLOCK),
        .m_axi_arprot(auto_us_df_to_s00_couplers_ARPROT),
        .m_axi_arqos(auto_us_df_to_s00_couplers_ARQOS),
        .m_axi_arready(auto_us_df_to_s00_couplers_ARREADY),
        .m_axi_arsize(auto_us_df_to_s00_couplers_ARSIZE),
        .m_axi_arvalid(auto_us_df_to_s00_couplers_ARVALID),
        .m_axi_awaddr(auto_us_df_to_s00_couplers_AWADDR),
        .m_axi_awburst(auto_us_df_to_s00_couplers_AWBURST),
        .m_axi_awcache(auto_us_df_to_s00_couplers_AWCACHE),
        .m_axi_awlen(auto_us_df_to_s00_couplers_AWLEN),
        .m_axi_awlock(auto_us_df_to_s00_couplers_AWLOCK),
        .m_axi_awprot(auto_us_df_to_s00_couplers_AWPROT),
        .m_axi_awqos(auto_us_df_to_s00_couplers_AWQOS),
        .m_axi_awready(auto_us_df_to_s00_couplers_AWREADY),
        .m_axi_awsize(auto_us_df_to_s00_couplers_AWSIZE),
        .m_axi_awvalid(auto_us_df_to_s00_couplers_AWVALID),
        .m_axi_bready(auto_us_df_to_s00_couplers_BREADY),
        .m_axi_bresp(auto_us_df_to_s00_couplers_BRESP),
        .m_axi_bvalid(auto_us_df_to_s00_couplers_BVALID),
        .m_axi_rdata(auto_us_df_to_s00_couplers_RDATA),
        .m_axi_rlast(auto_us_df_to_s00_couplers_RLAST),
        .m_axi_rready(auto_us_df_to_s00_couplers_RREADY),
        .m_axi_rresp(auto_us_df_to_s00_couplers_RRESP),
        .m_axi_rvalid(auto_us_df_to_s00_couplers_RVALID),
        .m_axi_wdata(auto_us_df_to_s00_couplers_WDATA),
        .m_axi_wlast(auto_us_df_to_s00_couplers_WLAST),
        .m_axi_wready(auto_us_df_to_s00_couplers_WREADY),
        .m_axi_wstrb(auto_us_df_to_s00_couplers_WSTRB),
        .m_axi_wvalid(auto_us_df_to_s00_couplers_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(s00_regslice_to_auto_us_df_ARADDR),
        .s_axi_arburst(s00_regslice_to_auto_us_df_ARBURST),
        .s_axi_arcache(s00_regslice_to_auto_us_df_ARCACHE),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arlen(s00_regslice_to_auto_us_df_ARLEN),
        .s_axi_arlock(s00_regslice_to_auto_us_df_ARLOCK),
        .s_axi_arprot(s00_regslice_to_auto_us_df_ARPROT),
        .s_axi_arqos(s00_regslice_to_auto_us_df_ARQOS),
        .s_axi_arready(s00_regslice_to_auto_us_df_ARREADY),
        .s_axi_arregion(s00_regslice_to_auto_us_df_ARREGION),
        .s_axi_arsize(s00_regslice_to_auto_us_df_ARSIZE),
        .s_axi_arvalid(s00_regslice_to_auto_us_df_ARVALID),
        .s_axi_awaddr(s00_regslice_to_auto_us_df_AWADDR),
        .s_axi_awburst(s00_regslice_to_auto_us_df_AWBURST),
        .s_axi_awcache(s00_regslice_to_auto_us_df_AWCACHE),
        .s_axi_awlen(s00_regslice_to_auto_us_df_AWLEN),
        .s_axi_awlock(s00_regslice_to_auto_us_df_AWLOCK),
        .s_axi_awprot(s00_regslice_to_auto_us_df_AWPROT),
        .s_axi_awqos(s00_regslice_to_auto_us_df_AWQOS),
        .s_axi_awready(s00_regslice_to_auto_us_df_AWREADY),
        .s_axi_awregion(s00_regslice_to_auto_us_df_AWREGION),
        .s_axi_awsize(s00_regslice_to_auto_us_df_AWSIZE),
        .s_axi_awvalid(s00_regslice_to_auto_us_df_AWVALID),
        .s_axi_bready(s00_regslice_to_auto_us_df_BREADY),
        .s_axi_bresp(s00_regslice_to_auto_us_df_BRESP),
        .s_axi_bvalid(s00_regslice_to_auto_us_df_BVALID),
        .s_axi_rdata(s00_regslice_to_auto_us_df_RDATA),
        .s_axi_rlast(s00_regslice_to_auto_us_df_RLAST),
        .s_axi_rready(s00_regslice_to_auto_us_df_RREADY),
        .s_axi_rresp(s00_regslice_to_auto_us_df_RRESP),
        .s_axi_rvalid(s00_regslice_to_auto_us_df_RVALID),
        .s_axi_wdata(s00_regslice_to_auto_us_df_WDATA),
        .s_axi_wlast(s00_regslice_to_auto_us_df_WLAST),
        .s_axi_wready(s00_regslice_to_auto_us_df_WREADY),
        .s_axi_wstrb(s00_regslice_to_auto_us_df_WSTRB),
        .s_axi_wvalid(s00_regslice_to_auto_us_df_WVALID));
  zc702_s00_regslice_1 s00_regslice
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(s00_regslice_to_auto_us_df_ARADDR),
        .m_axi_arburst(s00_regslice_to_auto_us_df_ARBURST),
        .m_axi_arcache(s00_regslice_to_auto_us_df_ARCACHE),
        .m_axi_arlen(s00_regslice_to_auto_us_df_ARLEN),
        .m_axi_arlock(s00_regslice_to_auto_us_df_ARLOCK),
        .m_axi_arprot(s00_regslice_to_auto_us_df_ARPROT),
        .m_axi_arqos(s00_regslice_to_auto_us_df_ARQOS),
        .m_axi_arready(s00_regslice_to_auto_us_df_ARREADY),
        .m_axi_arregion(s00_regslice_to_auto_us_df_ARREGION),
        .m_axi_arsize(s00_regslice_to_auto_us_df_ARSIZE),
        .m_axi_arvalid(s00_regslice_to_auto_us_df_ARVALID),
        .m_axi_awaddr(s00_regslice_to_auto_us_df_AWADDR),
        .m_axi_awburst(s00_regslice_to_auto_us_df_AWBURST),
        .m_axi_awcache(s00_regslice_to_auto_us_df_AWCACHE),
        .m_axi_awlen(s00_regslice_to_auto_us_df_AWLEN),
        .m_axi_awlock(s00_regslice_to_auto_us_df_AWLOCK),
        .m_axi_awprot(s00_regslice_to_auto_us_df_AWPROT),
        .m_axi_awqos(s00_regslice_to_auto_us_df_AWQOS),
        .m_axi_awready(s00_regslice_to_auto_us_df_AWREADY),
        .m_axi_awregion(s00_regslice_to_auto_us_df_AWREGION),
        .m_axi_awsize(s00_regslice_to_auto_us_df_AWSIZE),
        .m_axi_awvalid(s00_regslice_to_auto_us_df_AWVALID),
        .m_axi_bready(s00_regslice_to_auto_us_df_BREADY),
        .m_axi_bresp(s00_regslice_to_auto_us_df_BRESP),
        .m_axi_bvalid(s00_regslice_to_auto_us_df_BVALID),
        .m_axi_rdata(s00_regslice_to_auto_us_df_RDATA),
        .m_axi_rlast(s00_regslice_to_auto_us_df_RLAST),
        .m_axi_rready(s00_regslice_to_auto_us_df_RREADY),
        .m_axi_rresp(s00_regslice_to_auto_us_df_RRESP),
        .m_axi_rvalid(s00_regslice_to_auto_us_df_RVALID),
        .m_axi_wdata(s00_regslice_to_auto_us_df_WDATA),
        .m_axi_wlast(s00_regslice_to_auto_us_df_WLAST),
        .m_axi_wready(s00_regslice_to_auto_us_df_WREADY),
        .m_axi_wstrb(s00_regslice_to_auto_us_df_WSTRB),
        .m_axi_wvalid(s00_regslice_to_auto_us_df_WVALID),
        .s_axi_araddr(s00_couplers_to_s00_regslice_ARADDR),
        .s_axi_arburst(s00_couplers_to_s00_regslice_ARBURST),
        .s_axi_arcache(s00_couplers_to_s00_regslice_ARCACHE),
        .s_axi_arlen(s00_couplers_to_s00_regslice_ARLEN),
        .s_axi_arlock(s00_couplers_to_s00_regslice_ARLOCK[0]),
        .s_axi_arprot(s00_couplers_to_s00_regslice_ARPROT),
        .s_axi_arqos(s00_couplers_to_s00_regslice_ARQOS),
        .s_axi_arready(s00_couplers_to_s00_regslice_ARREADY),
        .s_axi_arregion(s00_couplers_to_s00_regslice_ARREGION),
        .s_axi_arsize(s00_couplers_to_s00_regslice_ARSIZE),
        .s_axi_arvalid(s00_couplers_to_s00_regslice_ARVALID),
        .s_axi_awaddr(s00_couplers_to_s00_regslice_AWADDR),
        .s_axi_awburst(s00_couplers_to_s00_regslice_AWBURST),
        .s_axi_awcache(s00_couplers_to_s00_regslice_AWCACHE),
        .s_axi_awlen(s00_couplers_to_s00_regslice_AWLEN),
        .s_axi_awlock(s00_couplers_to_s00_regslice_AWLOCK[0]),
        .s_axi_awprot(s00_couplers_to_s00_regslice_AWPROT),
        .s_axi_awqos(s00_couplers_to_s00_regslice_AWQOS),
        .s_axi_awready(s00_couplers_to_s00_regslice_AWREADY),
        .s_axi_awregion(s00_couplers_to_s00_regslice_AWREGION),
        .s_axi_awsize(s00_couplers_to_s00_regslice_AWSIZE),
        .s_axi_awvalid(s00_couplers_to_s00_regslice_AWVALID),
        .s_axi_bready(s00_couplers_to_s00_regslice_BREADY),
        .s_axi_bresp(s00_couplers_to_s00_regslice_BRESP),
        .s_axi_bvalid(s00_couplers_to_s00_regslice_BVALID),
        .s_axi_rdata(s00_couplers_to_s00_regslice_RDATA),
        .s_axi_rlast(s00_couplers_to_s00_regslice_RLAST),
        .s_axi_rready(s00_couplers_to_s00_regslice_RREADY),
        .s_axi_rresp(s00_couplers_to_s00_regslice_RRESP),
        .s_axi_rvalid(s00_couplers_to_s00_regslice_RVALID),
        .s_axi_wdata(s00_couplers_to_s00_regslice_WDATA),
        .s_axi_wlast(s00_couplers_to_s00_regslice_WLAST),
        .s_axi_wready(s00_couplers_to_s00_regslice_WREADY),
        .s_axi_wstrb(s00_couplers_to_s00_regslice_WSTRB),
        .s_axi_wvalid(s00_couplers_to_s00_regslice_WVALID));
endmodule

module s01_couplers_imp_1OALJYZ
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arregion,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awregion,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input [0:0]M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [7:0]M_AXI_arlen;
  output [0:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [7:0]M_AXI_awlen;
  output [0:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [63:0]M_AXI_rdata;
  input M_AXI_rlast;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [63:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [7:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input [0:0]S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [7:0]S_AXI_arlen;
  input [1:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [3:0]S_AXI_arregion;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [7:0]S_AXI_awlen;
  input [1:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [3:0]S_AXI_awregion;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire M_ACLK_1;
  wire [0:0]M_ARESETN_1;
  wire S_ACLK_1;
  wire [0:0]S_ARESETN_1;
  wire [31:0]auto_us_df_to_s01_couplers_ARADDR;
  wire [1:0]auto_us_df_to_s01_couplers_ARBURST;
  wire [3:0]auto_us_df_to_s01_couplers_ARCACHE;
  wire [7:0]auto_us_df_to_s01_couplers_ARLEN;
  wire [0:0]auto_us_df_to_s01_couplers_ARLOCK;
  wire [2:0]auto_us_df_to_s01_couplers_ARPROT;
  wire [3:0]auto_us_df_to_s01_couplers_ARQOS;
  wire auto_us_df_to_s01_couplers_ARREADY;
  wire [2:0]auto_us_df_to_s01_couplers_ARSIZE;
  wire auto_us_df_to_s01_couplers_ARVALID;
  wire [31:0]auto_us_df_to_s01_couplers_AWADDR;
  wire [1:0]auto_us_df_to_s01_couplers_AWBURST;
  wire [3:0]auto_us_df_to_s01_couplers_AWCACHE;
  wire [7:0]auto_us_df_to_s01_couplers_AWLEN;
  wire [0:0]auto_us_df_to_s01_couplers_AWLOCK;
  wire [2:0]auto_us_df_to_s01_couplers_AWPROT;
  wire [3:0]auto_us_df_to_s01_couplers_AWQOS;
  wire auto_us_df_to_s01_couplers_AWREADY;
  wire [2:0]auto_us_df_to_s01_couplers_AWSIZE;
  wire auto_us_df_to_s01_couplers_AWVALID;
  wire auto_us_df_to_s01_couplers_BREADY;
  wire [1:0]auto_us_df_to_s01_couplers_BRESP;
  wire auto_us_df_to_s01_couplers_BVALID;
  wire [63:0]auto_us_df_to_s01_couplers_RDATA;
  wire auto_us_df_to_s01_couplers_RLAST;
  wire auto_us_df_to_s01_couplers_RREADY;
  wire [1:0]auto_us_df_to_s01_couplers_RRESP;
  wire auto_us_df_to_s01_couplers_RVALID;
  wire [63:0]auto_us_df_to_s01_couplers_WDATA;
  wire auto_us_df_to_s01_couplers_WLAST;
  wire auto_us_df_to_s01_couplers_WREADY;
  wire [7:0]auto_us_df_to_s01_couplers_WSTRB;
  wire auto_us_df_to_s01_couplers_WVALID;
  wire [31:0]s01_couplers_to_s01_regslice_ARADDR;
  wire [1:0]s01_couplers_to_s01_regslice_ARBURST;
  wire [3:0]s01_couplers_to_s01_regslice_ARCACHE;
  wire [7:0]s01_couplers_to_s01_regslice_ARLEN;
  wire [1:0]s01_couplers_to_s01_regslice_ARLOCK;
  wire [2:0]s01_couplers_to_s01_regslice_ARPROT;
  wire [3:0]s01_couplers_to_s01_regslice_ARQOS;
  wire s01_couplers_to_s01_regslice_ARREADY;
  wire [3:0]s01_couplers_to_s01_regslice_ARREGION;
  wire [2:0]s01_couplers_to_s01_regslice_ARSIZE;
  wire s01_couplers_to_s01_regslice_ARVALID;
  wire [31:0]s01_couplers_to_s01_regslice_AWADDR;
  wire [1:0]s01_couplers_to_s01_regslice_AWBURST;
  wire [3:0]s01_couplers_to_s01_regslice_AWCACHE;
  wire [7:0]s01_couplers_to_s01_regslice_AWLEN;
  wire [1:0]s01_couplers_to_s01_regslice_AWLOCK;
  wire [2:0]s01_couplers_to_s01_regslice_AWPROT;
  wire [3:0]s01_couplers_to_s01_regslice_AWQOS;
  wire s01_couplers_to_s01_regslice_AWREADY;
  wire [3:0]s01_couplers_to_s01_regslice_AWREGION;
  wire [2:0]s01_couplers_to_s01_regslice_AWSIZE;
  wire s01_couplers_to_s01_regslice_AWVALID;
  wire s01_couplers_to_s01_regslice_BREADY;
  wire [1:0]s01_couplers_to_s01_regslice_BRESP;
  wire s01_couplers_to_s01_regslice_BVALID;
  wire [31:0]s01_couplers_to_s01_regslice_RDATA;
  wire s01_couplers_to_s01_regslice_RLAST;
  wire s01_couplers_to_s01_regslice_RREADY;
  wire [1:0]s01_couplers_to_s01_regslice_RRESP;
  wire s01_couplers_to_s01_regslice_RVALID;
  wire [31:0]s01_couplers_to_s01_regslice_WDATA;
  wire s01_couplers_to_s01_regslice_WLAST;
  wire s01_couplers_to_s01_regslice_WREADY;
  wire [3:0]s01_couplers_to_s01_regslice_WSTRB;
  wire s01_couplers_to_s01_regslice_WVALID;
  wire [31:0]s01_regslice_to_auto_us_df_ARADDR;
  wire [1:0]s01_regslice_to_auto_us_df_ARBURST;
  wire [3:0]s01_regslice_to_auto_us_df_ARCACHE;
  wire [7:0]s01_regslice_to_auto_us_df_ARLEN;
  wire [0:0]s01_regslice_to_auto_us_df_ARLOCK;
  wire [2:0]s01_regslice_to_auto_us_df_ARPROT;
  wire [3:0]s01_regslice_to_auto_us_df_ARQOS;
  wire s01_regslice_to_auto_us_df_ARREADY;
  wire [3:0]s01_regslice_to_auto_us_df_ARREGION;
  wire [2:0]s01_regslice_to_auto_us_df_ARSIZE;
  wire s01_regslice_to_auto_us_df_ARVALID;
  wire [31:0]s01_regslice_to_auto_us_df_AWADDR;
  wire [1:0]s01_regslice_to_auto_us_df_AWBURST;
  wire [3:0]s01_regslice_to_auto_us_df_AWCACHE;
  wire [7:0]s01_regslice_to_auto_us_df_AWLEN;
  wire [0:0]s01_regslice_to_auto_us_df_AWLOCK;
  wire [2:0]s01_regslice_to_auto_us_df_AWPROT;
  wire [3:0]s01_regslice_to_auto_us_df_AWQOS;
  wire s01_regslice_to_auto_us_df_AWREADY;
  wire [3:0]s01_regslice_to_auto_us_df_AWREGION;
  wire [2:0]s01_regslice_to_auto_us_df_AWSIZE;
  wire s01_regslice_to_auto_us_df_AWVALID;
  wire s01_regslice_to_auto_us_df_BREADY;
  wire [1:0]s01_regslice_to_auto_us_df_BRESP;
  wire s01_regslice_to_auto_us_df_BVALID;
  wire [31:0]s01_regslice_to_auto_us_df_RDATA;
  wire s01_regslice_to_auto_us_df_RLAST;
  wire s01_regslice_to_auto_us_df_RREADY;
  wire [1:0]s01_regslice_to_auto_us_df_RRESP;
  wire s01_regslice_to_auto_us_df_RVALID;
  wire [31:0]s01_regslice_to_auto_us_df_WDATA;
  wire s01_regslice_to_auto_us_df_WLAST;
  wire s01_regslice_to_auto_us_df_WREADY;
  wire [3:0]s01_regslice_to_auto_us_df_WSTRB;
  wire s01_regslice_to_auto_us_df_WVALID;

  assign M_ACLK_1 = M_ACLK;
  assign M_ARESETN_1 = M_ARESETN[0];
  assign M_AXI_araddr[31:0] = auto_us_df_to_s01_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = auto_us_df_to_s01_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = auto_us_df_to_s01_couplers_ARCACHE;
  assign M_AXI_arlen[7:0] = auto_us_df_to_s01_couplers_ARLEN;
  assign M_AXI_arlock[0] = auto_us_df_to_s01_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = auto_us_df_to_s01_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = auto_us_df_to_s01_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = auto_us_df_to_s01_couplers_ARSIZE;
  assign M_AXI_arvalid = auto_us_df_to_s01_couplers_ARVALID;
  assign M_AXI_awaddr[31:0] = auto_us_df_to_s01_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = auto_us_df_to_s01_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = auto_us_df_to_s01_couplers_AWCACHE;
  assign M_AXI_awlen[7:0] = auto_us_df_to_s01_couplers_AWLEN;
  assign M_AXI_awlock[0] = auto_us_df_to_s01_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = auto_us_df_to_s01_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = auto_us_df_to_s01_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = auto_us_df_to_s01_couplers_AWSIZE;
  assign M_AXI_awvalid = auto_us_df_to_s01_couplers_AWVALID;
  assign M_AXI_bready = auto_us_df_to_s01_couplers_BREADY;
  assign M_AXI_rready = auto_us_df_to_s01_couplers_RREADY;
  assign M_AXI_wdata[63:0] = auto_us_df_to_s01_couplers_WDATA;
  assign M_AXI_wlast = auto_us_df_to_s01_couplers_WLAST;
  assign M_AXI_wstrb[7:0] = auto_us_df_to_s01_couplers_WSTRB;
  assign M_AXI_wvalid = auto_us_df_to_s01_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN[0];
  assign S_AXI_arready = s01_couplers_to_s01_regslice_ARREADY;
  assign S_AXI_awready = s01_couplers_to_s01_regslice_AWREADY;
  assign S_AXI_bresp[1:0] = s01_couplers_to_s01_regslice_BRESP;
  assign S_AXI_bvalid = s01_couplers_to_s01_regslice_BVALID;
  assign S_AXI_rdata[31:0] = s01_couplers_to_s01_regslice_RDATA;
  assign S_AXI_rlast = s01_couplers_to_s01_regslice_RLAST;
  assign S_AXI_rresp[1:0] = s01_couplers_to_s01_regslice_RRESP;
  assign S_AXI_rvalid = s01_couplers_to_s01_regslice_RVALID;
  assign S_AXI_wready = s01_couplers_to_s01_regslice_WREADY;
  assign auto_us_df_to_s01_couplers_ARREADY = M_AXI_arready;
  assign auto_us_df_to_s01_couplers_AWREADY = M_AXI_awready;
  assign auto_us_df_to_s01_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_us_df_to_s01_couplers_BVALID = M_AXI_bvalid;
  assign auto_us_df_to_s01_couplers_RDATA = M_AXI_rdata[63:0];
  assign auto_us_df_to_s01_couplers_RLAST = M_AXI_rlast;
  assign auto_us_df_to_s01_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_us_df_to_s01_couplers_RVALID = M_AXI_rvalid;
  assign auto_us_df_to_s01_couplers_WREADY = M_AXI_wready;
  assign s01_couplers_to_s01_regslice_ARADDR = S_AXI_araddr[31:0];
  assign s01_couplers_to_s01_regslice_ARBURST = S_AXI_arburst[1:0];
  assign s01_couplers_to_s01_regslice_ARCACHE = S_AXI_arcache[3:0];
  assign s01_couplers_to_s01_regslice_ARLEN = S_AXI_arlen[7:0];
  assign s01_couplers_to_s01_regslice_ARLOCK = S_AXI_arlock[1:0];
  assign s01_couplers_to_s01_regslice_ARPROT = S_AXI_arprot[2:0];
  assign s01_couplers_to_s01_regslice_ARQOS = S_AXI_arqos[3:0];
  assign s01_couplers_to_s01_regslice_ARREGION = S_AXI_arregion[3:0];
  assign s01_couplers_to_s01_regslice_ARSIZE = S_AXI_arsize[2:0];
  assign s01_couplers_to_s01_regslice_ARVALID = S_AXI_arvalid;
  assign s01_couplers_to_s01_regslice_AWADDR = S_AXI_awaddr[31:0];
  assign s01_couplers_to_s01_regslice_AWBURST = S_AXI_awburst[1:0];
  assign s01_couplers_to_s01_regslice_AWCACHE = S_AXI_awcache[3:0];
  assign s01_couplers_to_s01_regslice_AWLEN = S_AXI_awlen[7:0];
  assign s01_couplers_to_s01_regslice_AWLOCK = S_AXI_awlock[1:0];
  assign s01_couplers_to_s01_regslice_AWPROT = S_AXI_awprot[2:0];
  assign s01_couplers_to_s01_regslice_AWQOS = S_AXI_awqos[3:0];
  assign s01_couplers_to_s01_regslice_AWREGION = S_AXI_awregion[3:0];
  assign s01_couplers_to_s01_regslice_AWSIZE = S_AXI_awsize[2:0];
  assign s01_couplers_to_s01_regslice_AWVALID = S_AXI_awvalid;
  assign s01_couplers_to_s01_regslice_BREADY = S_AXI_bready;
  assign s01_couplers_to_s01_regslice_RREADY = S_AXI_rready;
  assign s01_couplers_to_s01_regslice_WDATA = S_AXI_wdata[31:0];
  assign s01_couplers_to_s01_regslice_WLAST = S_AXI_wlast;
  assign s01_couplers_to_s01_regslice_WSTRB = S_AXI_wstrb[3:0];
  assign s01_couplers_to_s01_regslice_WVALID = S_AXI_wvalid;
  zc702_auto_us_df_1 auto_us_df
       (.m_axi_araddr(auto_us_df_to_s01_couplers_ARADDR),
        .m_axi_arburst(auto_us_df_to_s01_couplers_ARBURST),
        .m_axi_arcache(auto_us_df_to_s01_couplers_ARCACHE),
        .m_axi_arlen(auto_us_df_to_s01_couplers_ARLEN),
        .m_axi_arlock(auto_us_df_to_s01_couplers_ARLOCK),
        .m_axi_arprot(auto_us_df_to_s01_couplers_ARPROT),
        .m_axi_arqos(auto_us_df_to_s01_couplers_ARQOS),
        .m_axi_arready(auto_us_df_to_s01_couplers_ARREADY),
        .m_axi_arsize(auto_us_df_to_s01_couplers_ARSIZE),
        .m_axi_arvalid(auto_us_df_to_s01_couplers_ARVALID),
        .m_axi_awaddr(auto_us_df_to_s01_couplers_AWADDR),
        .m_axi_awburst(auto_us_df_to_s01_couplers_AWBURST),
        .m_axi_awcache(auto_us_df_to_s01_couplers_AWCACHE),
        .m_axi_awlen(auto_us_df_to_s01_couplers_AWLEN),
        .m_axi_awlock(auto_us_df_to_s01_couplers_AWLOCK),
        .m_axi_awprot(auto_us_df_to_s01_couplers_AWPROT),
        .m_axi_awqos(auto_us_df_to_s01_couplers_AWQOS),
        .m_axi_awready(auto_us_df_to_s01_couplers_AWREADY),
        .m_axi_awsize(auto_us_df_to_s01_couplers_AWSIZE),
        .m_axi_awvalid(auto_us_df_to_s01_couplers_AWVALID),
        .m_axi_bready(auto_us_df_to_s01_couplers_BREADY),
        .m_axi_bresp(auto_us_df_to_s01_couplers_BRESP),
        .m_axi_bvalid(auto_us_df_to_s01_couplers_BVALID),
        .m_axi_rdata(auto_us_df_to_s01_couplers_RDATA),
        .m_axi_rlast(auto_us_df_to_s01_couplers_RLAST),
        .m_axi_rready(auto_us_df_to_s01_couplers_RREADY),
        .m_axi_rresp(auto_us_df_to_s01_couplers_RRESP),
        .m_axi_rvalid(auto_us_df_to_s01_couplers_RVALID),
        .m_axi_wdata(auto_us_df_to_s01_couplers_WDATA),
        .m_axi_wlast(auto_us_df_to_s01_couplers_WLAST),
        .m_axi_wready(auto_us_df_to_s01_couplers_WREADY),
        .m_axi_wstrb(auto_us_df_to_s01_couplers_WSTRB),
        .m_axi_wvalid(auto_us_df_to_s01_couplers_WVALID),
        .s_axi_aclk(S_ACLK_1),
        .s_axi_araddr(s01_regslice_to_auto_us_df_ARADDR),
        .s_axi_arburst(s01_regslice_to_auto_us_df_ARBURST),
        .s_axi_arcache(s01_regslice_to_auto_us_df_ARCACHE),
        .s_axi_aresetn(S_ARESETN_1),
        .s_axi_arlen(s01_regslice_to_auto_us_df_ARLEN),
        .s_axi_arlock(s01_regslice_to_auto_us_df_ARLOCK),
        .s_axi_arprot(s01_regslice_to_auto_us_df_ARPROT),
        .s_axi_arqos(s01_regslice_to_auto_us_df_ARQOS),
        .s_axi_arready(s01_regslice_to_auto_us_df_ARREADY),
        .s_axi_arregion(s01_regslice_to_auto_us_df_ARREGION),
        .s_axi_arsize(s01_regslice_to_auto_us_df_ARSIZE),
        .s_axi_arvalid(s01_regslice_to_auto_us_df_ARVALID),
        .s_axi_awaddr(s01_regslice_to_auto_us_df_AWADDR),
        .s_axi_awburst(s01_regslice_to_auto_us_df_AWBURST),
        .s_axi_awcache(s01_regslice_to_auto_us_df_AWCACHE),
        .s_axi_awlen(s01_regslice_to_auto_us_df_AWLEN),
        .s_axi_awlock(s01_regslice_to_auto_us_df_AWLOCK),
        .s_axi_awprot(s01_regslice_to_auto_us_df_AWPROT),
        .s_axi_awqos(s01_regslice_to_auto_us_df_AWQOS),
        .s_axi_awready(s01_regslice_to_auto_us_df_AWREADY),
        .s_axi_awregion(s01_regslice_to_auto_us_df_AWREGION),
        .s_axi_awsize(s01_regslice_to_auto_us_df_AWSIZE),
        .s_axi_awvalid(s01_regslice_to_auto_us_df_AWVALID),
        .s_axi_bready(s01_regslice_to_auto_us_df_BREADY),
        .s_axi_bresp(s01_regslice_to_auto_us_df_BRESP),
        .s_axi_bvalid(s01_regslice_to_auto_us_df_BVALID),
        .s_axi_rdata(s01_regslice_to_auto_us_df_RDATA),
        .s_axi_rlast(s01_regslice_to_auto_us_df_RLAST),
        .s_axi_rready(s01_regslice_to_auto_us_df_RREADY),
        .s_axi_rresp(s01_regslice_to_auto_us_df_RRESP),
        .s_axi_rvalid(s01_regslice_to_auto_us_df_RVALID),
        .s_axi_wdata(s01_regslice_to_auto_us_df_WDATA),
        .s_axi_wlast(s01_regslice_to_auto_us_df_WLAST),
        .s_axi_wready(s01_regslice_to_auto_us_df_WREADY),
        .s_axi_wstrb(s01_regslice_to_auto_us_df_WSTRB),
        .s_axi_wvalid(s01_regslice_to_auto_us_df_WVALID));
  zc702_s01_regslice_0 s01_regslice
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(s01_regslice_to_auto_us_df_ARADDR),
        .m_axi_arburst(s01_regslice_to_auto_us_df_ARBURST),
        .m_axi_arcache(s01_regslice_to_auto_us_df_ARCACHE),
        .m_axi_arlen(s01_regslice_to_auto_us_df_ARLEN),
        .m_axi_arlock(s01_regslice_to_auto_us_df_ARLOCK),
        .m_axi_arprot(s01_regslice_to_auto_us_df_ARPROT),
        .m_axi_arqos(s01_regslice_to_auto_us_df_ARQOS),
        .m_axi_arready(s01_regslice_to_auto_us_df_ARREADY),
        .m_axi_arregion(s01_regslice_to_auto_us_df_ARREGION),
        .m_axi_arsize(s01_regslice_to_auto_us_df_ARSIZE),
        .m_axi_arvalid(s01_regslice_to_auto_us_df_ARVALID),
        .m_axi_awaddr(s01_regslice_to_auto_us_df_AWADDR),
        .m_axi_awburst(s01_regslice_to_auto_us_df_AWBURST),
        .m_axi_awcache(s01_regslice_to_auto_us_df_AWCACHE),
        .m_axi_awlen(s01_regslice_to_auto_us_df_AWLEN),
        .m_axi_awlock(s01_regslice_to_auto_us_df_AWLOCK),
        .m_axi_awprot(s01_regslice_to_auto_us_df_AWPROT),
        .m_axi_awqos(s01_regslice_to_auto_us_df_AWQOS),
        .m_axi_awready(s01_regslice_to_auto_us_df_AWREADY),
        .m_axi_awregion(s01_regslice_to_auto_us_df_AWREGION),
        .m_axi_awsize(s01_regslice_to_auto_us_df_AWSIZE),
        .m_axi_awvalid(s01_regslice_to_auto_us_df_AWVALID),
        .m_axi_bready(s01_regslice_to_auto_us_df_BREADY),
        .m_axi_bresp(s01_regslice_to_auto_us_df_BRESP),
        .m_axi_bvalid(s01_regslice_to_auto_us_df_BVALID),
        .m_axi_rdata(s01_regslice_to_auto_us_df_RDATA),
        .m_axi_rlast(s01_regslice_to_auto_us_df_RLAST),
        .m_axi_rready(s01_regslice_to_auto_us_df_RREADY),
        .m_axi_rresp(s01_regslice_to_auto_us_df_RRESP),
        .m_axi_rvalid(s01_regslice_to_auto_us_df_RVALID),
        .m_axi_wdata(s01_regslice_to_auto_us_df_WDATA),
        .m_axi_wlast(s01_regslice_to_auto_us_df_WLAST),
        .m_axi_wready(s01_regslice_to_auto_us_df_WREADY),
        .m_axi_wstrb(s01_regslice_to_auto_us_df_WSTRB),
        .m_axi_wvalid(s01_regslice_to_auto_us_df_WVALID),
        .s_axi_araddr(s01_couplers_to_s01_regslice_ARADDR),
        .s_axi_arburst(s01_couplers_to_s01_regslice_ARBURST),
        .s_axi_arcache(s01_couplers_to_s01_regslice_ARCACHE),
        .s_axi_arlen(s01_couplers_to_s01_regslice_ARLEN),
        .s_axi_arlock(s01_couplers_to_s01_regslice_ARLOCK[0]),
        .s_axi_arprot(s01_couplers_to_s01_regslice_ARPROT),
        .s_axi_arqos(s01_couplers_to_s01_regslice_ARQOS),
        .s_axi_arready(s01_couplers_to_s01_regslice_ARREADY),
        .s_axi_arregion(s01_couplers_to_s01_regslice_ARREGION),
        .s_axi_arsize(s01_couplers_to_s01_regslice_ARSIZE),
        .s_axi_arvalid(s01_couplers_to_s01_regslice_ARVALID),
        .s_axi_awaddr(s01_couplers_to_s01_regslice_AWADDR),
        .s_axi_awburst(s01_couplers_to_s01_regslice_AWBURST),
        .s_axi_awcache(s01_couplers_to_s01_regslice_AWCACHE),
        .s_axi_awlen(s01_couplers_to_s01_regslice_AWLEN),
        .s_axi_awlock(s01_couplers_to_s01_regslice_AWLOCK[0]),
        .s_axi_awprot(s01_couplers_to_s01_regslice_AWPROT),
        .s_axi_awqos(s01_couplers_to_s01_regslice_AWQOS),
        .s_axi_awready(s01_couplers_to_s01_regslice_AWREADY),
        .s_axi_awregion(s01_couplers_to_s01_regslice_AWREGION),
        .s_axi_awsize(s01_couplers_to_s01_regslice_AWSIZE),
        .s_axi_awvalid(s01_couplers_to_s01_regslice_AWVALID),
        .s_axi_bready(s01_couplers_to_s01_regslice_BREADY),
        .s_axi_bresp(s01_couplers_to_s01_regslice_BRESP),
        .s_axi_bvalid(s01_couplers_to_s01_regslice_BVALID),
        .s_axi_rdata(s01_couplers_to_s01_regslice_RDATA),
        .s_axi_rlast(s01_couplers_to_s01_regslice_RLAST),
        .s_axi_rready(s01_couplers_to_s01_regslice_RREADY),
        .s_axi_rresp(s01_couplers_to_s01_regslice_RRESP),
        .s_axi_rvalid(s01_couplers_to_s01_regslice_RVALID),
        .s_axi_wdata(s01_couplers_to_s01_regslice_WDATA),
        .s_axi_wlast(s01_couplers_to_s01_regslice_WLAST),
        .s_axi_wready(s01_couplers_to_s01_regslice_WREADY),
        .s_axi_wstrb(s01_couplers_to_s01_regslice_WSTRB),
        .s_axi_wvalid(s01_couplers_to_s01_regslice_WVALID));
endmodule

(* CORE_GENERATION_INFO = "zc702,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=zc702,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=35,numReposBlks=27,numNonXlnxBlks=0,numHierBlks=8,maxHierDepth=0,synth_mode=Global}" *) (* HW_HANDOFF = "zc702.hwdef" *) 
module zc702
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;

  wire [3:0]acp_axcache_0xF_dout;
  wire [12:0]axi_ic_ps7_M_AXI_GP0_M00_AXI_ARADDR;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_ARREADY;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_ARVALID;
  wire [12:0]axi_ic_ps7_M_AXI_GP0_M00_AXI_AWADDR;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_AWREADY;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_AWVALID;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_BREADY;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_M00_AXI_BRESP;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_BVALID;
  wire [31:0]axi_ic_ps7_M_AXI_GP0_M00_AXI_RDATA;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_RREADY;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_M00_AXI_RRESP;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_RVALID;
  wire [31:0]axi_ic_ps7_M_AXI_GP0_M00_AXI_WDATA;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_WREADY;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_M00_AXI_WSTRB;
  wire axi_ic_ps7_M_AXI_GP0_M00_AXI_WVALID;
  wire [12:0]axi_ic_ps7_M_AXI_GP0_M01_AXI_ARADDR;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_ARREADY;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_ARVALID;
  wire [12:0]axi_ic_ps7_M_AXI_GP0_M01_AXI_AWADDR;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_AWREADY;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_AWVALID;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_BREADY;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_M01_AXI_BRESP;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_BVALID;
  wire [31:0]axi_ic_ps7_M_AXI_GP0_M01_AXI_RDATA;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_RREADY;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_M01_AXI_RRESP;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_RVALID;
  wire [31:0]axi_ic_ps7_M_AXI_GP0_M01_AXI_WDATA;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_WREADY;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_M01_AXI_WSTRB;
  wire axi_ic_ps7_M_AXI_GP0_M01_AXI_WVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARADDR;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARBURST;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARCACHE;
  wire [0:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARID;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARLEN;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARLOCK;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARPROT;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARQOS;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_ARREADY;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_ARSIZE;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_ARVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWADDR;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWBURST;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWCACHE;
  wire [0:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWID;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWLEN;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWLOCK;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWPROT;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWQOS;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_AWREADY;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_AWSIZE;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_AWVALID;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_BID;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_BREADY;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_BRESP;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_BVALID;
  wire [63:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_RDATA;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_RID;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_RLAST;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_RREADY;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_RRESP;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_RVALID;
  wire [63:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_WDATA;
  wire [0:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_WID;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_WLAST;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_WREADY;
  wire [7:0]axi_ic_ps7_S_AXI_ACP_M00_AXI_WSTRB;
  wire axi_ic_ps7_S_AXI_ACP_M00_AXI_WVALID;
  wire clkid0;
  wire clkid1;
  wire clkid2;
  wire clkid3;
  wire [31:0]get_0_ap_return;
  wire get_0_if_AP_CTRL_done;
  wire get_0_if_AP_CTRL_idle;
  wire get_0_if_AP_CTRL_ready;
  wire get_0_if_AP_CTRL_start;
  wire [31:0]get_0_if_ap_iscalar_0_dout;
  wire [31:0]get_0_if_ap_iscalar_1_dout;
  wire get_0_if_aresetn;
  wire [31:0]get_0_m_axi_gmem_ARADDR;
  wire [1:0]get_0_m_axi_gmem_ARBURST;
  wire [7:0]get_0_m_axi_gmem_ARLEN;
  wire [1:0]get_0_m_axi_gmem_ARLOCK;
  wire [2:0]get_0_m_axi_gmem_ARPROT;
  wire [3:0]get_0_m_axi_gmem_ARQOS;
  wire get_0_m_axi_gmem_ARREADY;
  wire [3:0]get_0_m_axi_gmem_ARREGION;
  wire [2:0]get_0_m_axi_gmem_ARSIZE;
  wire get_0_m_axi_gmem_ARVALID;
  wire [31:0]get_0_m_axi_gmem_AWADDR;
  wire [1:0]get_0_m_axi_gmem_AWBURST;
  wire [7:0]get_0_m_axi_gmem_AWLEN;
  wire [1:0]get_0_m_axi_gmem_AWLOCK;
  wire [2:0]get_0_m_axi_gmem_AWPROT;
  wire [3:0]get_0_m_axi_gmem_AWQOS;
  wire get_0_m_axi_gmem_AWREADY;
  wire [3:0]get_0_m_axi_gmem_AWREGION;
  wire [2:0]get_0_m_axi_gmem_AWSIZE;
  wire get_0_m_axi_gmem_AWVALID;
  wire get_0_m_axi_gmem_BREADY;
  wire [1:0]get_0_m_axi_gmem_BRESP;
  wire get_0_m_axi_gmem_BVALID;
  wire [31:0]get_0_m_axi_gmem_RDATA;
  wire get_0_m_axi_gmem_RLAST;
  wire get_0_m_axi_gmem_RREADY;
  wire [1:0]get_0_m_axi_gmem_RRESP;
  wire get_0_m_axi_gmem_RVALID;
  wire [31:0]get_0_m_axi_gmem_WDATA;
  wire get_0_m_axi_gmem_WLAST;
  wire get_0_m_axi_gmem_WREADY;
  wire [3:0]get_0_m_axi_gmem_WSTRB;
  wire get_0_m_axi_gmem_WVALID;
  wire [31:0]get_0_val_r1;
  wire get_0_val_r_ap_vld;
  wire [31:0]get_0_val_r_data_out;
  wire get_0_val_r_vld_out;
  wire [0:0]proc_sys_reset_2_interconnect_aresetn;
  wire [0:0]proc_sys_reset_2_peripheral_aresetn;
  wire [31:0]ps7_M_AXI_GP0_ARADDR;
  wire [1:0]ps7_M_AXI_GP0_ARBURST;
  wire [3:0]ps7_M_AXI_GP0_ARCACHE;
  wire [11:0]ps7_M_AXI_GP0_ARID;
  wire [3:0]ps7_M_AXI_GP0_ARLEN;
  wire [1:0]ps7_M_AXI_GP0_ARLOCK;
  wire [2:0]ps7_M_AXI_GP0_ARPROT;
  wire [3:0]ps7_M_AXI_GP0_ARQOS;
  wire ps7_M_AXI_GP0_ARREADY;
  wire [2:0]ps7_M_AXI_GP0_ARSIZE;
  wire ps7_M_AXI_GP0_ARVALID;
  wire [31:0]ps7_M_AXI_GP0_AWADDR;
  wire [1:0]ps7_M_AXI_GP0_AWBURST;
  wire [3:0]ps7_M_AXI_GP0_AWCACHE;
  wire [11:0]ps7_M_AXI_GP0_AWID;
  wire [3:0]ps7_M_AXI_GP0_AWLEN;
  wire [1:0]ps7_M_AXI_GP0_AWLOCK;
  wire [2:0]ps7_M_AXI_GP0_AWPROT;
  wire [3:0]ps7_M_AXI_GP0_AWQOS;
  wire ps7_M_AXI_GP0_AWREADY;
  wire [2:0]ps7_M_AXI_GP0_AWSIZE;
  wire ps7_M_AXI_GP0_AWVALID;
  wire [11:0]ps7_M_AXI_GP0_BID;
  wire ps7_M_AXI_GP0_BREADY;
  wire [1:0]ps7_M_AXI_GP0_BRESP;
  wire ps7_M_AXI_GP0_BVALID;
  wire [31:0]ps7_M_AXI_GP0_RDATA;
  wire [11:0]ps7_M_AXI_GP0_RID;
  wire ps7_M_AXI_GP0_RLAST;
  wire ps7_M_AXI_GP0_RREADY;
  wire [1:0]ps7_M_AXI_GP0_RRESP;
  wire ps7_M_AXI_GP0_RVALID;
  wire [31:0]ps7_M_AXI_GP0_WDATA;
  wire [11:0]ps7_M_AXI_GP0_WID;
  wire ps7_M_AXI_GP0_WLAST;
  wire ps7_M_AXI_GP0_WREADY;
  wire [3:0]ps7_M_AXI_GP0_WSTRB;
  wire ps7_M_AXI_GP0_WVALID;
  wire [14:0]ps7_ddr_ADDR;
  wire [2:0]ps7_ddr_BA;
  wire ps7_ddr_CAS_N;
  wire ps7_ddr_CKE;
  wire ps7_ddr_CK_N;
  wire ps7_ddr_CK_P;
  wire ps7_ddr_CS_N;
  wire [3:0]ps7_ddr_DM;
  wire [31:0]ps7_ddr_DQ;
  wire [3:0]ps7_ddr_DQS_N;
  wire [3:0]ps7_ddr_DQS_P;
  wire ps7_ddr_ODT;
  wire ps7_ddr_RAS_N;
  wire ps7_ddr_RESET_N;
  wire ps7_ddr_WE_N;
  wire ps7_fclk_reset0_n;
  wire ps7_fixed_io_DDR_VRN;
  wire ps7_fixed_io_DDR_VRP;
  wire [53:0]ps7_fixed_io_MIO;
  wire ps7_fixed_io_PS_CLK;
  wire ps7_fixed_io_PS_PORB;
  wire ps7_fixed_io_PS_SRSTB;
  wire [0:0]ps7_irq_const_dout;
  wire [31:0]set_0_ap_return;
  wire set_0_if_AP_CTRL_done;
  wire set_0_if_AP_CTRL_idle;
  wire set_0_if_AP_CTRL_ready;
  wire set_0_if_AP_CTRL_start;
  wire [31:0]set_0_if_ap_iscalar_0_dout;
  wire [31:0]set_0_if_ap_iscalar_1_dout;
  wire [31:0]set_0_if_ap_iscalar_2_dout;
  wire set_0_if_aresetn;
  wire [31:0]set_0_m_axi_gmem_ARADDR;
  wire [1:0]set_0_m_axi_gmem_ARBURST;
  wire [7:0]set_0_m_axi_gmem_ARLEN;
  wire [1:0]set_0_m_axi_gmem_ARLOCK;
  wire [2:0]set_0_m_axi_gmem_ARPROT;
  wire [3:0]set_0_m_axi_gmem_ARQOS;
  wire set_0_m_axi_gmem_ARREADY;
  wire [3:0]set_0_m_axi_gmem_ARREGION;
  wire [2:0]set_0_m_axi_gmem_ARSIZE;
  wire set_0_m_axi_gmem_ARVALID;
  wire [31:0]set_0_m_axi_gmem_AWADDR;
  wire [1:0]set_0_m_axi_gmem_AWBURST;
  wire [7:0]set_0_m_axi_gmem_AWLEN;
  wire [1:0]set_0_m_axi_gmem_AWLOCK;
  wire [2:0]set_0_m_axi_gmem_AWPROT;
  wire [3:0]set_0_m_axi_gmem_AWQOS;
  wire set_0_m_axi_gmem_AWREADY;
  wire [3:0]set_0_m_axi_gmem_AWREGION;
  wire [2:0]set_0_m_axi_gmem_AWSIZE;
  wire set_0_m_axi_gmem_AWVALID;
  wire set_0_m_axi_gmem_BREADY;
  wire [1:0]set_0_m_axi_gmem_BRESP;
  wire set_0_m_axi_gmem_BVALID;
  wire [31:0]set_0_m_axi_gmem_RDATA;
  wire set_0_m_axi_gmem_RLAST;
  wire set_0_m_axi_gmem_RREADY;
  wire [1:0]set_0_m_axi_gmem_RRESP;
  wire set_0_m_axi_gmem_RVALID;
  wire [31:0]set_0_m_axi_gmem_WDATA;
  wire set_0_m_axi_gmem_WLAST;
  wire set_0_m_axi_gmem_WREADY;
  wire [3:0]set_0_m_axi_gmem_WSTRB;
  wire set_0_m_axi_gmem_WVALID;
  wire [0:0]xlconcat_1_dout;

  zc702_acp_axcache_0xF_0 acp_axcache_0xF
       (.dout(acp_axcache_0xF_dout));
  zc702_axi_ic_ps7_M_AXI_GP0_0 axi_ic_ps7_M_AXI_GP0
       (.ACLK(clkid2),
        .ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .M00_ACLK(clkid2),
        .M00_ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .M00_AXI_araddr(axi_ic_ps7_M_AXI_GP0_M00_AXI_ARADDR),
        .M00_AXI_arready(axi_ic_ps7_M_AXI_GP0_M00_AXI_ARREADY),
        .M00_AXI_arvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_ARVALID),
        .M00_AXI_awaddr(axi_ic_ps7_M_AXI_GP0_M00_AXI_AWADDR),
        .M00_AXI_awready(axi_ic_ps7_M_AXI_GP0_M00_AXI_AWREADY),
        .M00_AXI_awvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_AWVALID),
        .M00_AXI_bready(axi_ic_ps7_M_AXI_GP0_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_ic_ps7_M_AXI_GP0_M00_AXI_BRESP),
        .M00_AXI_bvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_BVALID),
        .M00_AXI_rdata(axi_ic_ps7_M_AXI_GP0_M00_AXI_RDATA),
        .M00_AXI_rready(axi_ic_ps7_M_AXI_GP0_M00_AXI_RREADY),
        .M00_AXI_rresp(axi_ic_ps7_M_AXI_GP0_M00_AXI_RRESP),
        .M00_AXI_rvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_RVALID),
        .M00_AXI_wdata(axi_ic_ps7_M_AXI_GP0_M00_AXI_WDATA),
        .M00_AXI_wready(axi_ic_ps7_M_AXI_GP0_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_ic_ps7_M_AXI_GP0_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_WVALID),
        .M01_ACLK(clkid2),
        .M01_ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .M01_AXI_araddr(axi_ic_ps7_M_AXI_GP0_M01_AXI_ARADDR),
        .M01_AXI_arready(axi_ic_ps7_M_AXI_GP0_M01_AXI_ARREADY),
        .M01_AXI_arvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_ARVALID),
        .M01_AXI_awaddr(axi_ic_ps7_M_AXI_GP0_M01_AXI_AWADDR),
        .M01_AXI_awready(axi_ic_ps7_M_AXI_GP0_M01_AXI_AWREADY),
        .M01_AXI_awvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_AWVALID),
        .M01_AXI_bready(axi_ic_ps7_M_AXI_GP0_M01_AXI_BREADY),
        .M01_AXI_bresp(axi_ic_ps7_M_AXI_GP0_M01_AXI_BRESP),
        .M01_AXI_bvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_BVALID),
        .M01_AXI_rdata(axi_ic_ps7_M_AXI_GP0_M01_AXI_RDATA),
        .M01_AXI_rready(axi_ic_ps7_M_AXI_GP0_M01_AXI_RREADY),
        .M01_AXI_rresp(axi_ic_ps7_M_AXI_GP0_M01_AXI_RRESP),
        .M01_AXI_rvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_RVALID),
        .M01_AXI_wdata(axi_ic_ps7_M_AXI_GP0_M01_AXI_WDATA),
        .M01_AXI_wready(axi_ic_ps7_M_AXI_GP0_M01_AXI_WREADY),
        .M01_AXI_wstrb(axi_ic_ps7_M_AXI_GP0_M01_AXI_WSTRB),
        .M01_AXI_wvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_WVALID),
        .S00_ACLK(clkid2),
        .S00_ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .S00_AXI_araddr(ps7_M_AXI_GP0_ARADDR),
        .S00_AXI_arburst(ps7_M_AXI_GP0_ARBURST),
        .S00_AXI_arcache(ps7_M_AXI_GP0_ARCACHE),
        .S00_AXI_arid(ps7_M_AXI_GP0_ARID),
        .S00_AXI_arlen(ps7_M_AXI_GP0_ARLEN),
        .S00_AXI_arlock(ps7_M_AXI_GP0_ARLOCK),
        .S00_AXI_arprot(ps7_M_AXI_GP0_ARPROT),
        .S00_AXI_arqos(ps7_M_AXI_GP0_ARQOS),
        .S00_AXI_arready(ps7_M_AXI_GP0_ARREADY),
        .S00_AXI_arsize(ps7_M_AXI_GP0_ARSIZE),
        .S00_AXI_arvalid(ps7_M_AXI_GP0_ARVALID),
        .S00_AXI_awaddr(ps7_M_AXI_GP0_AWADDR),
        .S00_AXI_awburst(ps7_M_AXI_GP0_AWBURST),
        .S00_AXI_awcache(ps7_M_AXI_GP0_AWCACHE),
        .S00_AXI_awid(ps7_M_AXI_GP0_AWID),
        .S00_AXI_awlen(ps7_M_AXI_GP0_AWLEN),
        .S00_AXI_awlock(ps7_M_AXI_GP0_AWLOCK),
        .S00_AXI_awprot(ps7_M_AXI_GP0_AWPROT),
        .S00_AXI_awqos(ps7_M_AXI_GP0_AWQOS),
        .S00_AXI_awready(ps7_M_AXI_GP0_AWREADY),
        .S00_AXI_awsize(ps7_M_AXI_GP0_AWSIZE),
        .S00_AXI_awvalid(ps7_M_AXI_GP0_AWVALID),
        .S00_AXI_bid(ps7_M_AXI_GP0_BID),
        .S00_AXI_bready(ps7_M_AXI_GP0_BREADY),
        .S00_AXI_bresp(ps7_M_AXI_GP0_BRESP),
        .S00_AXI_bvalid(ps7_M_AXI_GP0_BVALID),
        .S00_AXI_rdata(ps7_M_AXI_GP0_RDATA),
        .S00_AXI_rid(ps7_M_AXI_GP0_RID),
        .S00_AXI_rlast(ps7_M_AXI_GP0_RLAST),
        .S00_AXI_rready(ps7_M_AXI_GP0_RREADY),
        .S00_AXI_rresp(ps7_M_AXI_GP0_RRESP),
        .S00_AXI_rvalid(ps7_M_AXI_GP0_RVALID),
        .S00_AXI_wdata(ps7_M_AXI_GP0_WDATA),
        .S00_AXI_wid(ps7_M_AXI_GP0_WID),
        .S00_AXI_wlast(ps7_M_AXI_GP0_WLAST),
        .S00_AXI_wready(ps7_M_AXI_GP0_WREADY),
        .S00_AXI_wstrb(ps7_M_AXI_GP0_WSTRB),
        .S00_AXI_wvalid(ps7_M_AXI_GP0_WVALID));
  zc702_axi_ic_ps7_S_AXI_ACP_0 axi_ic_ps7_S_AXI_ACP
       (.ACLK(clkid2),
        .ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .M00_ACLK(clkid2),
        .M00_ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .M00_AXI_araddr(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARADDR),
        .M00_AXI_arburst(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARBURST),
        .M00_AXI_arcache(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARCACHE),
        .M00_AXI_arid(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARID),
        .M00_AXI_arlen(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARLEN),
        .M00_AXI_arlock(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARLOCK),
        .M00_AXI_arprot(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARPROT),
        .M00_AXI_arqos(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARQOS),
        .M00_AXI_arready(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARREADY),
        .M00_AXI_arsize(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARVALID),
        .M00_AXI_awaddr(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWADDR),
        .M00_AXI_awburst(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWBURST),
        .M00_AXI_awcache(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWCACHE),
        .M00_AXI_awid(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWID),
        .M00_AXI_awlen(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWLEN),
        .M00_AXI_awlock(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWLOCK),
        .M00_AXI_awprot(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWPROT),
        .M00_AXI_awqos(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWQOS),
        .M00_AXI_awready(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWREADY),
        .M00_AXI_awsize(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWVALID),
        .M00_AXI_bid(axi_ic_ps7_S_AXI_ACP_M00_AXI_BID),
        .M00_AXI_bready(axi_ic_ps7_S_AXI_ACP_M00_AXI_BREADY),
        .M00_AXI_bresp(axi_ic_ps7_S_AXI_ACP_M00_AXI_BRESP),
        .M00_AXI_bvalid(axi_ic_ps7_S_AXI_ACP_M00_AXI_BVALID),
        .M00_AXI_rdata(axi_ic_ps7_S_AXI_ACP_M00_AXI_RDATA),
        .M00_AXI_rid(axi_ic_ps7_S_AXI_ACP_M00_AXI_RID),
        .M00_AXI_rlast(axi_ic_ps7_S_AXI_ACP_M00_AXI_RLAST),
        .M00_AXI_rready(axi_ic_ps7_S_AXI_ACP_M00_AXI_RREADY),
        .M00_AXI_rresp(axi_ic_ps7_S_AXI_ACP_M00_AXI_RRESP),
        .M00_AXI_rvalid(axi_ic_ps7_S_AXI_ACP_M00_AXI_RVALID),
        .M00_AXI_wdata(axi_ic_ps7_S_AXI_ACP_M00_AXI_WDATA),
        .M00_AXI_wid(axi_ic_ps7_S_AXI_ACP_M00_AXI_WID),
        .M00_AXI_wlast(axi_ic_ps7_S_AXI_ACP_M00_AXI_WLAST),
        .M00_AXI_wready(axi_ic_ps7_S_AXI_ACP_M00_AXI_WREADY),
        .M00_AXI_wstrb(axi_ic_ps7_S_AXI_ACP_M00_AXI_WSTRB),
        .M00_AXI_wvalid(axi_ic_ps7_S_AXI_ACP_M00_AXI_WVALID),
        .S00_ACLK(clkid2),
        .S00_ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .S00_AXI_araddr(get_0_m_axi_gmem_ARADDR),
        .S00_AXI_arburst(get_0_m_axi_gmem_ARBURST),
        .S00_AXI_arcache(acp_axcache_0xF_dout),
        .S00_AXI_arlen(get_0_m_axi_gmem_ARLEN),
        .S00_AXI_arlock(get_0_m_axi_gmem_ARLOCK),
        .S00_AXI_arprot(get_0_m_axi_gmem_ARPROT),
        .S00_AXI_arqos(get_0_m_axi_gmem_ARQOS),
        .S00_AXI_arready(get_0_m_axi_gmem_ARREADY),
        .S00_AXI_arregion(get_0_m_axi_gmem_ARREGION),
        .S00_AXI_arsize(get_0_m_axi_gmem_ARSIZE),
        .S00_AXI_arvalid(get_0_m_axi_gmem_ARVALID),
        .S00_AXI_awaddr(get_0_m_axi_gmem_AWADDR),
        .S00_AXI_awburst(get_0_m_axi_gmem_AWBURST),
        .S00_AXI_awcache(acp_axcache_0xF_dout),
        .S00_AXI_awlen(get_0_m_axi_gmem_AWLEN),
        .S00_AXI_awlock(get_0_m_axi_gmem_AWLOCK),
        .S00_AXI_awprot(get_0_m_axi_gmem_AWPROT),
        .S00_AXI_awqos(get_0_m_axi_gmem_AWQOS),
        .S00_AXI_awready(get_0_m_axi_gmem_AWREADY),
        .S00_AXI_awregion(get_0_m_axi_gmem_AWREGION),
        .S00_AXI_awsize(get_0_m_axi_gmem_AWSIZE),
        .S00_AXI_awvalid(get_0_m_axi_gmem_AWVALID),
        .S00_AXI_bready(get_0_m_axi_gmem_BREADY),
        .S00_AXI_bresp(get_0_m_axi_gmem_BRESP),
        .S00_AXI_bvalid(get_0_m_axi_gmem_BVALID),
        .S00_AXI_rdata(get_0_m_axi_gmem_RDATA),
        .S00_AXI_rlast(get_0_m_axi_gmem_RLAST),
        .S00_AXI_rready(get_0_m_axi_gmem_RREADY),
        .S00_AXI_rresp(get_0_m_axi_gmem_RRESP),
        .S00_AXI_rvalid(get_0_m_axi_gmem_RVALID),
        .S00_AXI_wdata(get_0_m_axi_gmem_WDATA),
        .S00_AXI_wlast(get_0_m_axi_gmem_WLAST),
        .S00_AXI_wready(get_0_m_axi_gmem_WREADY),
        .S00_AXI_wstrb(get_0_m_axi_gmem_WSTRB),
        .S00_AXI_wvalid(get_0_m_axi_gmem_WVALID),
        .S01_ACLK(clkid2),
        .S01_ARESETN(proc_sys_reset_2_interconnect_aresetn),
        .S01_AXI_araddr(set_0_m_axi_gmem_ARADDR),
        .S01_AXI_arburst(set_0_m_axi_gmem_ARBURST),
        .S01_AXI_arcache(acp_axcache_0xF_dout),
        .S01_AXI_arlen(set_0_m_axi_gmem_ARLEN),
        .S01_AXI_arlock(set_0_m_axi_gmem_ARLOCK),
        .S01_AXI_arprot(set_0_m_axi_gmem_ARPROT),
        .S01_AXI_arqos(set_0_m_axi_gmem_ARQOS),
        .S01_AXI_arready(set_0_m_axi_gmem_ARREADY),
        .S01_AXI_arregion(set_0_m_axi_gmem_ARREGION),
        .S01_AXI_arsize(set_0_m_axi_gmem_ARSIZE),
        .S01_AXI_arvalid(set_0_m_axi_gmem_ARVALID),
        .S01_AXI_awaddr(set_0_m_axi_gmem_AWADDR),
        .S01_AXI_awburst(set_0_m_axi_gmem_AWBURST),
        .S01_AXI_awcache(acp_axcache_0xF_dout),
        .S01_AXI_awlen(set_0_m_axi_gmem_AWLEN),
        .S01_AXI_awlock(set_0_m_axi_gmem_AWLOCK),
        .S01_AXI_awprot(set_0_m_axi_gmem_AWPROT),
        .S01_AXI_awqos(set_0_m_axi_gmem_AWQOS),
        .S01_AXI_awready(set_0_m_axi_gmem_AWREADY),
        .S01_AXI_awregion(set_0_m_axi_gmem_AWREGION),
        .S01_AXI_awsize(set_0_m_axi_gmem_AWSIZE),
        .S01_AXI_awvalid(set_0_m_axi_gmem_AWVALID),
        .S01_AXI_bready(set_0_m_axi_gmem_BREADY),
        .S01_AXI_bresp(set_0_m_axi_gmem_BRESP),
        .S01_AXI_bvalid(set_0_m_axi_gmem_BVALID),
        .S01_AXI_rdata(set_0_m_axi_gmem_RDATA),
        .S01_AXI_rlast(set_0_m_axi_gmem_RLAST),
        .S01_AXI_rready(set_0_m_axi_gmem_RREADY),
        .S01_AXI_rresp(set_0_m_axi_gmem_RRESP),
        .S01_AXI_rvalid(set_0_m_axi_gmem_RVALID),
        .S01_AXI_wdata(set_0_m_axi_gmem_WDATA),
        .S01_AXI_wlast(set_0_m_axi_gmem_WLAST),
        .S01_AXI_wready(set_0_m_axi_gmem_WREADY),
        .S01_AXI_wstrb(set_0_m_axi_gmem_WSTRB),
        .S01_AXI_wvalid(set_0_m_axi_gmem_WVALID));
  zc702_get_0_0 get_0
       (.ap_clk(clkid2),
        .ap_done(get_0_if_AP_CTRL_done),
        .ap_idle(get_0_if_AP_CTRL_idle),
        .ap_ready(get_0_if_AP_CTRL_ready),
        .ap_return(get_0_ap_return),
        .ap_rst_n(get_0_if_aresetn),
        .ap_start(get_0_if_AP_CTRL_start),
        .data(get_0_if_ap_iscalar_0_dout),
        .key(get_0_if_ap_iscalar_1_dout),
        .m_axi_gmem_ARADDR(get_0_m_axi_gmem_ARADDR),
        .m_axi_gmem_ARBURST(get_0_m_axi_gmem_ARBURST),
        .m_axi_gmem_ARLEN(get_0_m_axi_gmem_ARLEN),
        .m_axi_gmem_ARLOCK(get_0_m_axi_gmem_ARLOCK),
        .m_axi_gmem_ARPROT(get_0_m_axi_gmem_ARPROT),
        .m_axi_gmem_ARQOS(get_0_m_axi_gmem_ARQOS),
        .m_axi_gmem_ARREADY(get_0_m_axi_gmem_ARREADY),
        .m_axi_gmem_ARREGION(get_0_m_axi_gmem_ARREGION),
        .m_axi_gmem_ARSIZE(get_0_m_axi_gmem_ARSIZE),
        .m_axi_gmem_ARVALID(get_0_m_axi_gmem_ARVALID),
        .m_axi_gmem_AWADDR(get_0_m_axi_gmem_AWADDR),
        .m_axi_gmem_AWBURST(get_0_m_axi_gmem_AWBURST),
        .m_axi_gmem_AWLEN(get_0_m_axi_gmem_AWLEN),
        .m_axi_gmem_AWLOCK(get_0_m_axi_gmem_AWLOCK),
        .m_axi_gmem_AWPROT(get_0_m_axi_gmem_AWPROT),
        .m_axi_gmem_AWQOS(get_0_m_axi_gmem_AWQOS),
        .m_axi_gmem_AWREADY(get_0_m_axi_gmem_AWREADY),
        .m_axi_gmem_AWREGION(get_0_m_axi_gmem_AWREGION),
        .m_axi_gmem_AWSIZE(get_0_m_axi_gmem_AWSIZE),
        .m_axi_gmem_AWVALID(get_0_m_axi_gmem_AWVALID),
        .m_axi_gmem_BREADY(get_0_m_axi_gmem_BREADY),
        .m_axi_gmem_BRESP(get_0_m_axi_gmem_BRESP),
        .m_axi_gmem_BVALID(get_0_m_axi_gmem_BVALID),
        .m_axi_gmem_RDATA(get_0_m_axi_gmem_RDATA),
        .m_axi_gmem_RLAST(get_0_m_axi_gmem_RLAST),
        .m_axi_gmem_RREADY(get_0_m_axi_gmem_RREADY),
        .m_axi_gmem_RRESP(get_0_m_axi_gmem_RRESP),
        .m_axi_gmem_RVALID(get_0_m_axi_gmem_RVALID),
        .m_axi_gmem_WDATA(get_0_m_axi_gmem_WDATA),
        .m_axi_gmem_WLAST(get_0_m_axi_gmem_WLAST),
        .m_axi_gmem_WREADY(get_0_m_axi_gmem_WREADY),
        .m_axi_gmem_WSTRB(get_0_m_axi_gmem_WSTRB),
        .m_axi_gmem_WVALID(get_0_m_axi_gmem_WVALID),
        .val_r(get_0_val_r1),
        .val_r_ap_vld(get_0_val_r_ap_vld));
  zc702_get_0_if_0 get_0_if
       (.aclk(clkid2),
        .ap_done(get_0_if_AP_CTRL_done),
        .ap_idle(get_0_if_AP_CTRL_idle),
        .ap_iscalar_0_dout(get_0_if_ap_iscalar_0_dout),
        .ap_iscalar_1_dout(get_0_if_ap_iscalar_1_dout),
        .ap_oscalar_0_din(get_0_ap_return),
        .ap_oscalar_1_din(get_0_val_r_data_out),
        .ap_oscalar_1_vld(get_0_val_r_vld_out),
        .ap_ready(get_0_if_AP_CTRL_ready),
        .ap_start(get_0_if_AP_CTRL_start),
        .aresetn(get_0_if_aresetn),
        .s_axi_aclk(clkid2),
        .s_axi_araddr(axi_ic_ps7_M_AXI_GP0_M00_AXI_ARADDR),
        .s_axi_aresetn(proc_sys_reset_2_peripheral_aresetn),
        .s_axi_arready(axi_ic_ps7_M_AXI_GP0_M00_AXI_ARREADY),
        .s_axi_arvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_ARVALID),
        .s_axi_awaddr(axi_ic_ps7_M_AXI_GP0_M00_AXI_AWADDR),
        .s_axi_awready(axi_ic_ps7_M_AXI_GP0_M00_AXI_AWREADY),
        .s_axi_awvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_AWVALID),
        .s_axi_bready(axi_ic_ps7_M_AXI_GP0_M00_AXI_BREADY),
        .s_axi_bresp(axi_ic_ps7_M_AXI_GP0_M00_AXI_BRESP),
        .s_axi_bvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_BVALID),
        .s_axi_rdata(axi_ic_ps7_M_AXI_GP0_M00_AXI_RDATA),
        .s_axi_rready(axi_ic_ps7_M_AXI_GP0_M00_AXI_RREADY),
        .s_axi_rresp(axi_ic_ps7_M_AXI_GP0_M00_AXI_RRESP),
        .s_axi_rvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_RVALID),
        .s_axi_wdata(axi_ic_ps7_M_AXI_GP0_M00_AXI_WDATA),
        .s_axi_wready(axi_ic_ps7_M_AXI_GP0_M00_AXI_WREADY),
        .s_axi_wstrb(axi_ic_ps7_M_AXI_GP0_M00_AXI_WSTRB),
        .s_axi_wvalid(axi_ic_ps7_M_AXI_GP0_M00_AXI_WVALID));
  zc702_get_0_val_r_0 get_0_val_r
       (.ap_done(get_0_if_AP_CTRL_done),
        .clk(clkid2),
        .data_in(get_0_val_r1),
        .data_out(get_0_val_r_data_out),
        .vld_in(get_0_val_r_ap_vld),
        .vld_out(get_0_val_r_vld_out));
  zc702_proc_sys_reset_4_3 proc_sys_reset_0
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(ps7_fclk_reset0_n),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(clkid0));
  zc702_proc_sys_reset_1_0 proc_sys_reset_1
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(ps7_fclk_reset0_n),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(clkid1));
  zc702_proc_sys_reset_2_1 proc_sys_reset_2
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(ps7_fclk_reset0_n),
        .interconnect_aresetn(proc_sys_reset_2_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(proc_sys_reset_2_peripheral_aresetn),
        .slowest_sync_clk(clkid2));
  zc702_proc_sys_reset_3_2 proc_sys_reset_3
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(ps7_fclk_reset0_n),
        .mb_debug_sys_rst(1'b0),
        .slowest_sync_clk(clkid3));
  zc702_processing_system7_1_0 ps7
       (.DDR_Addr(DDR_addr[14:0]),
        .DDR_BankAddr(DDR_ba[2:0]),
        .DDR_CAS_n(DDR_cas_n),
        .DDR_CKE(DDR_cke),
        .DDR_CS_n(DDR_cs_n),
        .DDR_Clk(DDR_ck_p),
        .DDR_Clk_n(DDR_ck_n),
        .DDR_DM(DDR_dm[3:0]),
        .DDR_DQ(DDR_dq[31:0]),
        .DDR_DQS(DDR_dqs_p[3:0]),
        .DDR_DQS_n(DDR_dqs_n[3:0]),
        .DDR_DRSTB(DDR_reset_n),
        .DDR_ODT(DDR_odt),
        .DDR_RAS_n(DDR_ras_n),
        .DDR_VRN(FIXED_IO_ddr_vrn),
        .DDR_VRP(FIXED_IO_ddr_vrp),
        .DDR_WEB(DDR_we_n),
        .FCLK_CLK0(clkid0),
        .FCLK_CLK1(clkid1),
        .FCLK_CLK2(clkid2),
        .FCLK_CLK3(clkid3),
        .FCLK_RESET0_N(ps7_fclk_reset0_n),
        .IRQ_F2P(xlconcat_1_dout),
        .MIO(FIXED_IO_mio[53:0]),
        .M_AXI_GP0_ACLK(clkid2),
        .M_AXI_GP0_ARADDR(ps7_M_AXI_GP0_ARADDR),
        .M_AXI_GP0_ARBURST(ps7_M_AXI_GP0_ARBURST),
        .M_AXI_GP0_ARCACHE(ps7_M_AXI_GP0_ARCACHE),
        .M_AXI_GP0_ARID(ps7_M_AXI_GP0_ARID),
        .M_AXI_GP0_ARLEN(ps7_M_AXI_GP0_ARLEN),
        .M_AXI_GP0_ARLOCK(ps7_M_AXI_GP0_ARLOCK),
        .M_AXI_GP0_ARPROT(ps7_M_AXI_GP0_ARPROT),
        .M_AXI_GP0_ARQOS(ps7_M_AXI_GP0_ARQOS),
        .M_AXI_GP0_ARREADY(ps7_M_AXI_GP0_ARREADY),
        .M_AXI_GP0_ARSIZE(ps7_M_AXI_GP0_ARSIZE),
        .M_AXI_GP0_ARVALID(ps7_M_AXI_GP0_ARVALID),
        .M_AXI_GP0_AWADDR(ps7_M_AXI_GP0_AWADDR),
        .M_AXI_GP0_AWBURST(ps7_M_AXI_GP0_AWBURST),
        .M_AXI_GP0_AWCACHE(ps7_M_AXI_GP0_AWCACHE),
        .M_AXI_GP0_AWID(ps7_M_AXI_GP0_AWID),
        .M_AXI_GP0_AWLEN(ps7_M_AXI_GP0_AWLEN),
        .M_AXI_GP0_AWLOCK(ps7_M_AXI_GP0_AWLOCK),
        .M_AXI_GP0_AWPROT(ps7_M_AXI_GP0_AWPROT),
        .M_AXI_GP0_AWQOS(ps7_M_AXI_GP0_AWQOS),
        .M_AXI_GP0_AWREADY(ps7_M_AXI_GP0_AWREADY),
        .M_AXI_GP0_AWSIZE(ps7_M_AXI_GP0_AWSIZE),
        .M_AXI_GP0_AWVALID(ps7_M_AXI_GP0_AWVALID),
        .M_AXI_GP0_BID(ps7_M_AXI_GP0_BID),
        .M_AXI_GP0_BREADY(ps7_M_AXI_GP0_BREADY),
        .M_AXI_GP0_BRESP(ps7_M_AXI_GP0_BRESP),
        .M_AXI_GP0_BVALID(ps7_M_AXI_GP0_BVALID),
        .M_AXI_GP0_RDATA(ps7_M_AXI_GP0_RDATA),
        .M_AXI_GP0_RID(ps7_M_AXI_GP0_RID),
        .M_AXI_GP0_RLAST(ps7_M_AXI_GP0_RLAST),
        .M_AXI_GP0_RREADY(ps7_M_AXI_GP0_RREADY),
        .M_AXI_GP0_RRESP(ps7_M_AXI_GP0_RRESP),
        .M_AXI_GP0_RVALID(ps7_M_AXI_GP0_RVALID),
        .M_AXI_GP0_WDATA(ps7_M_AXI_GP0_WDATA),
        .M_AXI_GP0_WID(ps7_M_AXI_GP0_WID),
        .M_AXI_GP0_WLAST(ps7_M_AXI_GP0_WLAST),
        .M_AXI_GP0_WREADY(ps7_M_AXI_GP0_WREADY),
        .M_AXI_GP0_WSTRB(ps7_M_AXI_GP0_WSTRB),
        .M_AXI_GP0_WVALID(ps7_M_AXI_GP0_WVALID),
        .PS_CLK(FIXED_IO_ps_clk),
        .PS_PORB(FIXED_IO_ps_porb),
        .PS_SRSTB(FIXED_IO_ps_srstb),
        .S_AXI_ACP_ACLK(clkid2),
        .S_AXI_ACP_ARADDR(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARADDR),
        .S_AXI_ACP_ARBURST(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARBURST),
        .S_AXI_ACP_ARCACHE(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARCACHE),
        .S_AXI_ACP_ARID({1'b0,1'b0,axi_ic_ps7_S_AXI_ACP_M00_AXI_ARID}),
        .S_AXI_ACP_ARLEN(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARLEN),
        .S_AXI_ACP_ARLOCK(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARLOCK),
        .S_AXI_ACP_ARPROT(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARPROT),
        .S_AXI_ACP_ARQOS(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARQOS),
        .S_AXI_ACP_ARREADY(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARREADY),
        .S_AXI_ACP_ARSIZE(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARSIZE),
        .S_AXI_ACP_ARUSER({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_ACP_ARVALID(axi_ic_ps7_S_AXI_ACP_M00_AXI_ARVALID),
        .S_AXI_ACP_AWADDR(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWADDR),
        .S_AXI_ACP_AWBURST(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWBURST),
        .S_AXI_ACP_AWCACHE(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWCACHE),
        .S_AXI_ACP_AWID({1'b0,1'b0,axi_ic_ps7_S_AXI_ACP_M00_AXI_AWID}),
        .S_AXI_ACP_AWLEN(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWLEN),
        .S_AXI_ACP_AWLOCK(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWLOCK),
        .S_AXI_ACP_AWPROT(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWPROT),
        .S_AXI_ACP_AWQOS(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWQOS),
        .S_AXI_ACP_AWREADY(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWREADY),
        .S_AXI_ACP_AWSIZE(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWSIZE),
        .S_AXI_ACP_AWUSER({1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_ACP_AWVALID(axi_ic_ps7_S_AXI_ACP_M00_AXI_AWVALID),
        .S_AXI_ACP_BID(axi_ic_ps7_S_AXI_ACP_M00_AXI_BID),
        .S_AXI_ACP_BREADY(axi_ic_ps7_S_AXI_ACP_M00_AXI_BREADY),
        .S_AXI_ACP_BRESP(axi_ic_ps7_S_AXI_ACP_M00_AXI_BRESP),
        .S_AXI_ACP_BVALID(axi_ic_ps7_S_AXI_ACP_M00_AXI_BVALID),
        .S_AXI_ACP_RDATA(axi_ic_ps7_S_AXI_ACP_M00_AXI_RDATA),
        .S_AXI_ACP_RID(axi_ic_ps7_S_AXI_ACP_M00_AXI_RID),
        .S_AXI_ACP_RLAST(axi_ic_ps7_S_AXI_ACP_M00_AXI_RLAST),
        .S_AXI_ACP_RREADY(axi_ic_ps7_S_AXI_ACP_M00_AXI_RREADY),
        .S_AXI_ACP_RRESP(axi_ic_ps7_S_AXI_ACP_M00_AXI_RRESP),
        .S_AXI_ACP_RVALID(axi_ic_ps7_S_AXI_ACP_M00_AXI_RVALID),
        .S_AXI_ACP_WDATA(axi_ic_ps7_S_AXI_ACP_M00_AXI_WDATA),
        .S_AXI_ACP_WID({1'b0,1'b0,axi_ic_ps7_S_AXI_ACP_M00_AXI_WID}),
        .S_AXI_ACP_WLAST(axi_ic_ps7_S_AXI_ACP_M00_AXI_WLAST),
        .S_AXI_ACP_WREADY(axi_ic_ps7_S_AXI_ACP_M00_AXI_WREADY),
        .S_AXI_ACP_WSTRB(axi_ic_ps7_S_AXI_ACP_M00_AXI_WSTRB),
        .S_AXI_ACP_WVALID(axi_ic_ps7_S_AXI_ACP_M00_AXI_WVALID),
        .USB0_VBUS_PWRFAULT(1'b0));
  zc702_ps7_irq_const_0 ps7_irq_const
       (.dout(ps7_irq_const_dout));
  zc702_set_0_0 set_0
       (.ap_clk(clkid2),
        .ap_done(set_0_if_AP_CTRL_done),
        .ap_idle(set_0_if_AP_CTRL_idle),
        .ap_ready(set_0_if_AP_CTRL_ready),
        .ap_return(set_0_ap_return),
        .ap_rst_n(set_0_if_aresetn),
        .ap_start(set_0_if_AP_CTRL_start),
        .data(set_0_if_ap_iscalar_0_dout),
        .key(set_0_if_ap_iscalar_1_dout),
        .m_axi_gmem_ARADDR(set_0_m_axi_gmem_ARADDR),
        .m_axi_gmem_ARBURST(set_0_m_axi_gmem_ARBURST),
        .m_axi_gmem_ARLEN(set_0_m_axi_gmem_ARLEN),
        .m_axi_gmem_ARLOCK(set_0_m_axi_gmem_ARLOCK),
        .m_axi_gmem_ARPROT(set_0_m_axi_gmem_ARPROT),
        .m_axi_gmem_ARQOS(set_0_m_axi_gmem_ARQOS),
        .m_axi_gmem_ARREADY(set_0_m_axi_gmem_ARREADY),
        .m_axi_gmem_ARREGION(set_0_m_axi_gmem_ARREGION),
        .m_axi_gmem_ARSIZE(set_0_m_axi_gmem_ARSIZE),
        .m_axi_gmem_ARVALID(set_0_m_axi_gmem_ARVALID),
        .m_axi_gmem_AWADDR(set_0_m_axi_gmem_AWADDR),
        .m_axi_gmem_AWBURST(set_0_m_axi_gmem_AWBURST),
        .m_axi_gmem_AWLEN(set_0_m_axi_gmem_AWLEN),
        .m_axi_gmem_AWLOCK(set_0_m_axi_gmem_AWLOCK),
        .m_axi_gmem_AWPROT(set_0_m_axi_gmem_AWPROT),
        .m_axi_gmem_AWQOS(set_0_m_axi_gmem_AWQOS),
        .m_axi_gmem_AWREADY(set_0_m_axi_gmem_AWREADY),
        .m_axi_gmem_AWREGION(set_0_m_axi_gmem_AWREGION),
        .m_axi_gmem_AWSIZE(set_0_m_axi_gmem_AWSIZE),
        .m_axi_gmem_AWVALID(set_0_m_axi_gmem_AWVALID),
        .m_axi_gmem_BREADY(set_0_m_axi_gmem_BREADY),
        .m_axi_gmem_BRESP(set_0_m_axi_gmem_BRESP),
        .m_axi_gmem_BVALID(set_0_m_axi_gmem_BVALID),
        .m_axi_gmem_RDATA(set_0_m_axi_gmem_RDATA),
        .m_axi_gmem_RLAST(set_0_m_axi_gmem_RLAST),
        .m_axi_gmem_RREADY(set_0_m_axi_gmem_RREADY),
        .m_axi_gmem_RRESP(set_0_m_axi_gmem_RRESP),
        .m_axi_gmem_RVALID(set_0_m_axi_gmem_RVALID),
        .m_axi_gmem_WDATA(set_0_m_axi_gmem_WDATA),
        .m_axi_gmem_WLAST(set_0_m_axi_gmem_WLAST),
        .m_axi_gmem_WREADY(set_0_m_axi_gmem_WREADY),
        .m_axi_gmem_WSTRB(set_0_m_axi_gmem_WSTRB),
        .m_axi_gmem_WVALID(set_0_m_axi_gmem_WVALID),
        .val_r(set_0_if_ap_iscalar_2_dout));
  zc702_set_0_if_0 set_0_if
       (.aclk(clkid2),
        .ap_done(set_0_if_AP_CTRL_done),
        .ap_idle(set_0_if_AP_CTRL_idle),
        .ap_iscalar_0_dout(set_0_if_ap_iscalar_0_dout),
        .ap_iscalar_1_dout(set_0_if_ap_iscalar_1_dout),
        .ap_iscalar_2_dout(set_0_if_ap_iscalar_2_dout),
        .ap_oscalar_0_din(set_0_ap_return),
        .ap_ready(set_0_if_AP_CTRL_ready),
        .ap_start(set_0_if_AP_CTRL_start),
        .aresetn(set_0_if_aresetn),
        .s_axi_aclk(clkid2),
        .s_axi_araddr(axi_ic_ps7_M_AXI_GP0_M01_AXI_ARADDR),
        .s_axi_aresetn(proc_sys_reset_2_peripheral_aresetn),
        .s_axi_arready(axi_ic_ps7_M_AXI_GP0_M01_AXI_ARREADY),
        .s_axi_arvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_ARVALID),
        .s_axi_awaddr(axi_ic_ps7_M_AXI_GP0_M01_AXI_AWADDR),
        .s_axi_awready(axi_ic_ps7_M_AXI_GP0_M01_AXI_AWREADY),
        .s_axi_awvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_AWVALID),
        .s_axi_bready(axi_ic_ps7_M_AXI_GP0_M01_AXI_BREADY),
        .s_axi_bresp(axi_ic_ps7_M_AXI_GP0_M01_AXI_BRESP),
        .s_axi_bvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_BVALID),
        .s_axi_rdata(axi_ic_ps7_M_AXI_GP0_M01_AXI_RDATA),
        .s_axi_rready(axi_ic_ps7_M_AXI_GP0_M01_AXI_RREADY),
        .s_axi_rresp(axi_ic_ps7_M_AXI_GP0_M01_AXI_RRESP),
        .s_axi_rvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_RVALID),
        .s_axi_wdata(axi_ic_ps7_M_AXI_GP0_M01_AXI_WDATA),
        .s_axi_wready(axi_ic_ps7_M_AXI_GP0_M01_AXI_WREADY),
        .s_axi_wstrb(axi_ic_ps7_M_AXI_GP0_M01_AXI_WSTRB),
        .s_axi_wvalid(axi_ic_ps7_M_AXI_GP0_M01_AXI_WVALID));
  zc702_xlconcat_1_0 xlconcat
       (.In0(ps7_irq_const_dout),
        .dout(xlconcat_1_dout));
endmodule

module zc702_axi_ic_ps7_M_AXI_GP0_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arready,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awready,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    M01_ACLK,
    M01_ARESETN,
    M01_AXI_araddr,
    M01_AXI_arready,
    M01_AXI_arvalid,
    M01_AXI_awaddr,
    M01_AXI_awready,
    M01_AXI_awvalid,
    M01_AXI_bready,
    M01_AXI_bresp,
    M01_AXI_bvalid,
    M01_AXI_rdata,
    M01_AXI_rready,
    M01_AXI_rresp,
    M01_AXI_rvalid,
    M01_AXI_wdata,
    M01_AXI_wready,
    M01_AXI_wstrb,
    M01_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arid,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awid,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rid,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wid,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input [0:0]ARESETN;
  input M00_ACLK;
  input [0:0]M00_ARESETN;
  output [12:0]M00_AXI_araddr;
  input M00_AXI_arready;
  output M00_AXI_arvalid;
  output [12:0]M00_AXI_awaddr;
  input M00_AXI_awready;
  output M00_AXI_awvalid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [31:0]M00_AXI_rdata;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [31:0]M00_AXI_wdata;
  input M00_AXI_wready;
  output [3:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input M01_ACLK;
  input [0:0]M01_ARESETN;
  output [12:0]M01_AXI_araddr;
  input M01_AXI_arready;
  output M01_AXI_arvalid;
  output [12:0]M01_AXI_awaddr;
  input M01_AXI_awready;
  output M01_AXI_awvalid;
  output M01_AXI_bready;
  input [1:0]M01_AXI_bresp;
  input M01_AXI_bvalid;
  input [31:0]M01_AXI_rdata;
  output M01_AXI_rready;
  input [1:0]M01_AXI_rresp;
  input M01_AXI_rvalid;
  output [31:0]M01_AXI_wdata;
  input M01_AXI_wready;
  output [3:0]M01_AXI_wstrb;
  output M01_AXI_wvalid;
  input S00_ACLK;
  input [0:0]S00_ARESETN;
  input [31:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [11:0]S00_AXI_arid;
  input [3:0]S00_AXI_arlen;
  input [1:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input S00_AXI_arvalid;
  input [31:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [11:0]S00_AXI_awid;
  input [3:0]S00_AXI_awlen;
  input [1:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  output [11:0]S00_AXI_bid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  output [11:0]S00_AXI_rid;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  input [11:0]S00_AXI_wid;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire axi_ic_ps7_M_AXI_GP0_ACLK_net;
  wire [0:0]axi_ic_ps7_M_AXI_GP0_ARESETN_net;
  wire [31:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARADDR;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARBURST;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARCACHE;
  wire [11:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARID;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARLEN;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARLOCK;
  wire [2:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARPROT;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARQOS;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARREADY;
  wire [2:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARSIZE;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARVALID;
  wire [31:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWADDR;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWBURST;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWCACHE;
  wire [11:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWID;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWLEN;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWLOCK;
  wire [2:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWPROT;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWQOS;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWREADY;
  wire [2:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWSIZE;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWVALID;
  wire [11:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BID;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BREADY;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BRESP;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BVALID;
  wire [31:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RDATA;
  wire [11:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RID;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RLAST;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RREADY;
  wire [1:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RRESP;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RVALID;
  wire [31:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WDATA;
  wire [11:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WID;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WLAST;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WREADY;
  wire [3:0]axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WSTRB;
  wire axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WVALID;
  wire [12:0]m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARADDR;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARREADY;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARVALID;
  wire [12:0]m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWADDR;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWREADY;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWVALID;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BREADY;
  wire [1:0]m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BRESP;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BVALID;
  wire [31:0]m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RDATA;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RREADY;
  wire [1:0]m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RRESP;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RVALID;
  wire [31:0]m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WDATA;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WREADY;
  wire [3:0]m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WSTRB;
  wire m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WVALID;
  wire [12:0]m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARADDR;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARREADY;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARVALID;
  wire [12:0]m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWADDR;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWREADY;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWVALID;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BREADY;
  wire [1:0]m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BRESP;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BVALID;
  wire [31:0]m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RDATA;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RREADY;
  wire [1:0]m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RRESP;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RVALID;
  wire [31:0]m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WDATA;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WREADY;
  wire [3:0]m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WSTRB;
  wire m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WVALID;
  wire [31:0]s00_couplers_to_xbar_ARADDR;
  wire [2:0]s00_couplers_to_xbar_ARPROT;
  wire [0:0]s00_couplers_to_xbar_ARREADY;
  wire s00_couplers_to_xbar_ARVALID;
  wire [31:0]s00_couplers_to_xbar_AWADDR;
  wire [2:0]s00_couplers_to_xbar_AWPROT;
  wire [0:0]s00_couplers_to_xbar_AWREADY;
  wire s00_couplers_to_xbar_AWVALID;
  wire s00_couplers_to_xbar_BREADY;
  wire [1:0]s00_couplers_to_xbar_BRESP;
  wire [0:0]s00_couplers_to_xbar_BVALID;
  wire [31:0]s00_couplers_to_xbar_RDATA;
  wire s00_couplers_to_xbar_RREADY;
  wire [1:0]s00_couplers_to_xbar_RRESP;
  wire [0:0]s00_couplers_to_xbar_RVALID;
  wire [31:0]s00_couplers_to_xbar_WDATA;
  wire [0:0]s00_couplers_to_xbar_WREADY;
  wire [3:0]s00_couplers_to_xbar_WSTRB;
  wire s00_couplers_to_xbar_WVALID;
  wire [31:0]xbar_to_m00_couplers_ARADDR;
  wire [2:0]xbar_to_m00_couplers_ARPROT;
  wire xbar_to_m00_couplers_ARREADY;
  wire [0:0]xbar_to_m00_couplers_ARVALID;
  wire [31:0]xbar_to_m00_couplers_AWADDR;
  wire [2:0]xbar_to_m00_couplers_AWPROT;
  wire xbar_to_m00_couplers_AWREADY;
  wire [0:0]xbar_to_m00_couplers_AWVALID;
  wire [0:0]xbar_to_m00_couplers_BREADY;
  wire [1:0]xbar_to_m00_couplers_BRESP;
  wire xbar_to_m00_couplers_BVALID;
  wire [31:0]xbar_to_m00_couplers_RDATA;
  wire [0:0]xbar_to_m00_couplers_RREADY;
  wire [1:0]xbar_to_m00_couplers_RRESP;
  wire xbar_to_m00_couplers_RVALID;
  wire [31:0]xbar_to_m00_couplers_WDATA;
  wire xbar_to_m00_couplers_WREADY;
  wire [3:0]xbar_to_m00_couplers_WSTRB;
  wire [0:0]xbar_to_m00_couplers_WVALID;
  wire [63:32]xbar_to_m01_couplers_ARADDR;
  wire [5:3]xbar_to_m01_couplers_ARPROT;
  wire xbar_to_m01_couplers_ARREADY;
  wire [1:1]xbar_to_m01_couplers_ARVALID;
  wire [63:32]xbar_to_m01_couplers_AWADDR;
  wire [5:3]xbar_to_m01_couplers_AWPROT;
  wire xbar_to_m01_couplers_AWREADY;
  wire [1:1]xbar_to_m01_couplers_AWVALID;
  wire [1:1]xbar_to_m01_couplers_BREADY;
  wire [1:0]xbar_to_m01_couplers_BRESP;
  wire xbar_to_m01_couplers_BVALID;
  wire [31:0]xbar_to_m01_couplers_RDATA;
  wire [1:1]xbar_to_m01_couplers_RREADY;
  wire [1:0]xbar_to_m01_couplers_RRESP;
  wire xbar_to_m01_couplers_RVALID;
  wire [63:32]xbar_to_m01_couplers_WDATA;
  wire xbar_to_m01_couplers_WREADY;
  wire [7:4]xbar_to_m01_couplers_WSTRB;
  wire [1:1]xbar_to_m01_couplers_WVALID;

  assign M00_AXI_araddr[12:0] = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARADDR;
  assign M00_AXI_arvalid = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARVALID;
  assign M00_AXI_awaddr[12:0] = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWADDR;
  assign M00_AXI_awvalid = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWVALID;
  assign M00_AXI_bready = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BREADY;
  assign M00_AXI_rready = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RREADY;
  assign M00_AXI_wdata[31:0] = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WDATA;
  assign M00_AXI_wstrb[3:0] = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WSTRB;
  assign M00_AXI_wvalid = m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WVALID;
  assign M01_AXI_araddr[12:0] = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARADDR;
  assign M01_AXI_arvalid = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARVALID;
  assign M01_AXI_awaddr[12:0] = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWADDR;
  assign M01_AXI_awvalid = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWVALID;
  assign M01_AXI_bready = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BREADY;
  assign M01_AXI_rready = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RREADY;
  assign M01_AXI_wdata[31:0] = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WDATA;
  assign M01_AXI_wstrb[3:0] = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WSTRB;
  assign M01_AXI_wvalid = m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WVALID;
  assign S00_AXI_arready = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWREADY;
  assign S00_AXI_bid[11:0] = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BID;
  assign S00_AXI_bresp[1:0] = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[31:0] = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RDATA;
  assign S00_AXI_rid[11:0] = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RID;
  assign S00_AXI_rlast = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RVALID;
  assign S00_AXI_wready = axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WREADY;
  assign axi_ic_ps7_M_AXI_GP0_ACLK_net = ACLK;
  assign axi_ic_ps7_M_AXI_GP0_ARESETN_net = ARESETN[0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARADDR = S00_AXI_araddr[31:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARID = S00_AXI_arid[11:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARLEN = S00_AXI_arlen[3:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARLOCK = S00_AXI_arlock[1:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWADDR = S00_AXI_awaddr[31:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWID = S00_AXI_awid[11:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWLEN = S00_AXI_awlen[3:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWLOCK = S00_AXI_awlock[1:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RREADY = S00_AXI_rready;
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WID = S00_AXI_wid[11:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARREADY = M00_AXI_arready;
  assign m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWREADY = M00_AXI_awready;
  assign m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BRESP = M00_AXI_bresp[1:0];
  assign m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BVALID = M00_AXI_bvalid;
  assign m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RDATA = M00_AXI_rdata[31:0];
  assign m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RRESP = M00_AXI_rresp[1:0];
  assign m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RVALID = M00_AXI_rvalid;
  assign m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WREADY = M00_AXI_wready;
  assign m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARREADY = M01_AXI_arready;
  assign m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWREADY = M01_AXI_awready;
  assign m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BRESP = M01_AXI_bresp[1:0];
  assign m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BVALID = M01_AXI_bvalid;
  assign m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RDATA = M01_AXI_rdata[31:0];
  assign m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RRESP = M01_AXI_rresp[1:0];
  assign m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RVALID = M01_AXI_rvalid;
  assign m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WREADY = M01_AXI_wready;
  m00_couplers_imp_1IKQD79 m00_couplers
       (.M_ACLK(axi_ic_ps7_M_AXI_GP0_ACLK_net),
        .M_ARESETN(axi_ic_ps7_M_AXI_GP0_ARESETN_net),
        .M_AXI_araddr(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARADDR),
        .M_AXI_arready(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARREADY),
        .M_AXI_arvalid(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_ARVALID),
        .M_AXI_awaddr(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWADDR),
        .M_AXI_awready(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWREADY),
        .M_AXI_awvalid(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_AWVALID),
        .M_AXI_bready(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BREADY),
        .M_AXI_bresp(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BRESP),
        .M_AXI_bvalid(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_BVALID),
        .M_AXI_rdata(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RDATA),
        .M_AXI_rready(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RREADY),
        .M_AXI_rresp(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RRESP),
        .M_AXI_rvalid(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_RVALID),
        .M_AXI_wdata(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WDATA),
        .M_AXI_wready(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WREADY),
        .M_AXI_wstrb(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WSTRB),
        .M_AXI_wvalid(m00_couplers_to_axi_ic_ps7_M_AXI_GP0_WVALID),
        .S_ACLK(axi_ic_ps7_M_AXI_GP0_ACLK_net),
        .S_ARESETN(axi_ic_ps7_M_AXI_GP0_ARESETN_net),
        .S_AXI_araddr(xbar_to_m00_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m00_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m00_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m00_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m00_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m00_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m00_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m00_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m00_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m00_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m00_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m00_couplers_RDATA),
        .S_AXI_rready(xbar_to_m00_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m00_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m00_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m00_couplers_WDATA),
        .S_AXI_wready(xbar_to_m00_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m00_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m00_couplers_WVALID));
  m01_couplers_imp_YRHFB1 m01_couplers
       (.M_ACLK(axi_ic_ps7_M_AXI_GP0_ACLK_net),
        .M_ARESETN(axi_ic_ps7_M_AXI_GP0_ARESETN_net),
        .M_AXI_araddr(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARADDR),
        .M_AXI_arready(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARREADY),
        .M_AXI_arvalid(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_ARVALID),
        .M_AXI_awaddr(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWADDR),
        .M_AXI_awready(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWREADY),
        .M_AXI_awvalid(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_AWVALID),
        .M_AXI_bready(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BREADY),
        .M_AXI_bresp(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BRESP),
        .M_AXI_bvalid(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_BVALID),
        .M_AXI_rdata(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RDATA),
        .M_AXI_rready(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RREADY),
        .M_AXI_rresp(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RRESP),
        .M_AXI_rvalid(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_RVALID),
        .M_AXI_wdata(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WDATA),
        .M_AXI_wready(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WREADY),
        .M_AXI_wstrb(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WSTRB),
        .M_AXI_wvalid(m01_couplers_to_axi_ic_ps7_M_AXI_GP0_WVALID),
        .S_ACLK(axi_ic_ps7_M_AXI_GP0_ACLK_net),
        .S_ARESETN(axi_ic_ps7_M_AXI_GP0_ARESETN_net),
        .S_AXI_araddr(xbar_to_m01_couplers_ARADDR),
        .S_AXI_arprot(xbar_to_m01_couplers_ARPROT),
        .S_AXI_arready(xbar_to_m01_couplers_ARREADY),
        .S_AXI_arvalid(xbar_to_m01_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m01_couplers_AWADDR),
        .S_AXI_awprot(xbar_to_m01_couplers_AWPROT),
        .S_AXI_awready(xbar_to_m01_couplers_AWREADY),
        .S_AXI_awvalid(xbar_to_m01_couplers_AWVALID),
        .S_AXI_bready(xbar_to_m01_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m01_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m01_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m01_couplers_RDATA),
        .S_AXI_rready(xbar_to_m01_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m01_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m01_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m01_couplers_WDATA),
        .S_AXI_wready(xbar_to_m01_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m01_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m01_couplers_WVALID));
  s00_couplers_imp_14Q0TRY s00_couplers
       (.M_ACLK(axi_ic_ps7_M_AXI_GP0_ACLK_net),
        .M_ARESETN(axi_ic_ps7_M_AXI_GP0_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_xbar_ARADDR),
        .M_AXI_arprot(s00_couplers_to_xbar_ARPROT),
        .M_AXI_arready(s00_couplers_to_xbar_ARREADY),
        .M_AXI_arvalid(s00_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_xbar_AWADDR),
        .M_AXI_awprot(s00_couplers_to_xbar_AWPROT),
        .M_AXI_awready(s00_couplers_to_xbar_AWREADY),
        .M_AXI_awvalid(s00_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s00_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s00_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s00_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s00_couplers_to_xbar_RDATA),
        .M_AXI_rready(s00_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s00_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s00_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s00_couplers_to_xbar_WDATA),
        .M_AXI_wready(s00_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s00_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_xbar_WVALID),
        .S_ACLK(axi_ic_ps7_M_AXI_GP0_ACLK_net),
        .S_ARESETN(axi_ic_ps7_M_AXI_GP0_ARESETN_net),
        .S_AXI_araddr(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARADDR),
        .S_AXI_arburst(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARBURST),
        .S_AXI_arcache(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARCACHE),
        .S_AXI_arid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARID),
        .S_AXI_arlen(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARLEN),
        .S_AXI_arlock(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARPROT),
        .S_AXI_arqos(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARQOS),
        .S_AXI_arready(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARREADY),
        .S_AXI_arsize(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARSIZE),
        .S_AXI_arvalid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWADDR),
        .S_AXI_awburst(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWBURST),
        .S_AXI_awcache(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWCACHE),
        .S_AXI_awid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWID),
        .S_AXI_awlen(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWLEN),
        .S_AXI_awlock(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWPROT),
        .S_AXI_awqos(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWQOS),
        .S_AXI_awready(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWREADY),
        .S_AXI_awsize(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWSIZE),
        .S_AXI_awvalid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_AWVALID),
        .S_AXI_bid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BID),
        .S_AXI_bready(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BRESP),
        .S_AXI_bvalid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_BVALID),
        .S_AXI_rdata(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RDATA),
        .S_AXI_rid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RID),
        .S_AXI_rlast(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RLAST),
        .S_AXI_rready(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RREADY),
        .S_AXI_rresp(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RRESP),
        .S_AXI_rvalid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_RVALID),
        .S_AXI_wdata(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WDATA),
        .S_AXI_wid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WID),
        .S_AXI_wlast(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WLAST),
        .S_AXI_wready(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(axi_ic_ps7_M_AXI_GP0_to_s00_couplers_WVALID));
  zc702_xbar_0 xbar
       (.aclk(axi_ic_ps7_M_AXI_GP0_ACLK_net),
        .aresetn(axi_ic_ps7_M_AXI_GP0_ARESETN_net),
        .m_axi_araddr({xbar_to_m01_couplers_ARADDR,xbar_to_m00_couplers_ARADDR}),
        .m_axi_arprot({xbar_to_m01_couplers_ARPROT,xbar_to_m00_couplers_ARPROT}),
        .m_axi_arready({xbar_to_m01_couplers_ARREADY,xbar_to_m00_couplers_ARREADY}),
        .m_axi_arvalid({xbar_to_m01_couplers_ARVALID,xbar_to_m00_couplers_ARVALID}),
        .m_axi_awaddr({xbar_to_m01_couplers_AWADDR,xbar_to_m00_couplers_AWADDR}),
        .m_axi_awprot({xbar_to_m01_couplers_AWPROT,xbar_to_m00_couplers_AWPROT}),
        .m_axi_awready({xbar_to_m01_couplers_AWREADY,xbar_to_m00_couplers_AWREADY}),
        .m_axi_awvalid({xbar_to_m01_couplers_AWVALID,xbar_to_m00_couplers_AWVALID}),
        .m_axi_bready({xbar_to_m01_couplers_BREADY,xbar_to_m00_couplers_BREADY}),
        .m_axi_bresp({xbar_to_m01_couplers_BRESP,xbar_to_m00_couplers_BRESP}),
        .m_axi_bvalid({xbar_to_m01_couplers_BVALID,xbar_to_m00_couplers_BVALID}),
        .m_axi_rdata({xbar_to_m01_couplers_RDATA,xbar_to_m00_couplers_RDATA}),
        .m_axi_rready({xbar_to_m01_couplers_RREADY,xbar_to_m00_couplers_RREADY}),
        .m_axi_rresp({xbar_to_m01_couplers_RRESP,xbar_to_m00_couplers_RRESP}),
        .m_axi_rvalid({xbar_to_m01_couplers_RVALID,xbar_to_m00_couplers_RVALID}),
        .m_axi_wdata({xbar_to_m01_couplers_WDATA,xbar_to_m00_couplers_WDATA}),
        .m_axi_wready({xbar_to_m01_couplers_WREADY,xbar_to_m00_couplers_WREADY}),
        .m_axi_wstrb({xbar_to_m01_couplers_WSTRB,xbar_to_m00_couplers_WSTRB}),
        .m_axi_wvalid({xbar_to_m01_couplers_WVALID,xbar_to_m00_couplers_WVALID}),
        .s_axi_araddr(s00_couplers_to_xbar_ARADDR),
        .s_axi_arprot(s00_couplers_to_xbar_ARPROT),
        .s_axi_arready(s00_couplers_to_xbar_ARREADY),
        .s_axi_arvalid(s00_couplers_to_xbar_ARVALID),
        .s_axi_awaddr(s00_couplers_to_xbar_AWADDR),
        .s_axi_awprot(s00_couplers_to_xbar_AWPROT),
        .s_axi_awready(s00_couplers_to_xbar_AWREADY),
        .s_axi_awvalid(s00_couplers_to_xbar_AWVALID),
        .s_axi_bready(s00_couplers_to_xbar_BREADY),
        .s_axi_bresp(s00_couplers_to_xbar_BRESP),
        .s_axi_bvalid(s00_couplers_to_xbar_BVALID),
        .s_axi_rdata(s00_couplers_to_xbar_RDATA),
        .s_axi_rready(s00_couplers_to_xbar_RREADY),
        .s_axi_rresp(s00_couplers_to_xbar_RRESP),
        .s_axi_rvalid(s00_couplers_to_xbar_RVALID),
        .s_axi_wdata(s00_couplers_to_xbar_WDATA),
        .s_axi_wready(s00_couplers_to_xbar_WREADY),
        .s_axi_wstrb(s00_couplers_to_xbar_WSTRB),
        .s_axi_wvalid(s00_couplers_to_xbar_WVALID));
endmodule

module zc702_axi_ic_ps7_S_AXI_ACP_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arburst,
    M00_AXI_arcache,
    M00_AXI_arid,
    M00_AXI_arlen,
    M00_AXI_arlock,
    M00_AXI_arprot,
    M00_AXI_arqos,
    M00_AXI_arready,
    M00_AXI_arsize,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awburst,
    M00_AXI_awcache,
    M00_AXI_awid,
    M00_AXI_awlen,
    M00_AXI_awlock,
    M00_AXI_awprot,
    M00_AXI_awqos,
    M00_AXI_awready,
    M00_AXI_awsize,
    M00_AXI_awvalid,
    M00_AXI_bid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rid,
    M00_AXI_rlast,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wid,
    M00_AXI_wlast,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arregion,
    S00_AXI_arsize,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awregion,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid,
    S01_ACLK,
    S01_ARESETN,
    S01_AXI_araddr,
    S01_AXI_arburst,
    S01_AXI_arcache,
    S01_AXI_arlen,
    S01_AXI_arlock,
    S01_AXI_arprot,
    S01_AXI_arqos,
    S01_AXI_arready,
    S01_AXI_arregion,
    S01_AXI_arsize,
    S01_AXI_arvalid,
    S01_AXI_awaddr,
    S01_AXI_awburst,
    S01_AXI_awcache,
    S01_AXI_awlen,
    S01_AXI_awlock,
    S01_AXI_awprot,
    S01_AXI_awqos,
    S01_AXI_awready,
    S01_AXI_awregion,
    S01_AXI_awsize,
    S01_AXI_awvalid,
    S01_AXI_bready,
    S01_AXI_bresp,
    S01_AXI_bvalid,
    S01_AXI_rdata,
    S01_AXI_rlast,
    S01_AXI_rready,
    S01_AXI_rresp,
    S01_AXI_rvalid,
    S01_AXI_wdata,
    S01_AXI_wlast,
    S01_AXI_wready,
    S01_AXI_wstrb,
    S01_AXI_wvalid);
  input ACLK;
  input [0:0]ARESETN;
  input M00_ACLK;
  input [0:0]M00_ARESETN;
  output [31:0]M00_AXI_araddr;
  output [1:0]M00_AXI_arburst;
  output [3:0]M00_AXI_arcache;
  output [0:0]M00_AXI_arid;
  output [3:0]M00_AXI_arlen;
  output [1:0]M00_AXI_arlock;
  output [2:0]M00_AXI_arprot;
  output [3:0]M00_AXI_arqos;
  input M00_AXI_arready;
  output [2:0]M00_AXI_arsize;
  output M00_AXI_arvalid;
  output [31:0]M00_AXI_awaddr;
  output [1:0]M00_AXI_awburst;
  output [3:0]M00_AXI_awcache;
  output [0:0]M00_AXI_awid;
  output [3:0]M00_AXI_awlen;
  output [1:0]M00_AXI_awlock;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  input M00_AXI_awready;
  output [2:0]M00_AXI_awsize;
  output M00_AXI_awvalid;
  input [2:0]M00_AXI_bid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [63:0]M00_AXI_rdata;
  input [2:0]M00_AXI_rid;
  input M00_AXI_rlast;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [63:0]M00_AXI_wdata;
  output [0:0]M00_AXI_wid;
  output M00_AXI_wlast;
  input M00_AXI_wready;
  output [7:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input S00_ACLK;
  input [0:0]S00_ARESETN;
  input [31:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [7:0]S00_AXI_arlen;
  input [1:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [3:0]S00_AXI_arregion;
  input [2:0]S00_AXI_arsize;
  input S00_AXI_arvalid;
  input [31:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [7:0]S00_AXI_awlen;
  input [1:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [3:0]S00_AXI_awregion;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;
  input S01_ACLK;
  input [0:0]S01_ARESETN;
  input [31:0]S01_AXI_araddr;
  input [1:0]S01_AXI_arburst;
  input [3:0]S01_AXI_arcache;
  input [7:0]S01_AXI_arlen;
  input [1:0]S01_AXI_arlock;
  input [2:0]S01_AXI_arprot;
  input [3:0]S01_AXI_arqos;
  output S01_AXI_arready;
  input [3:0]S01_AXI_arregion;
  input [2:0]S01_AXI_arsize;
  input S01_AXI_arvalid;
  input [31:0]S01_AXI_awaddr;
  input [1:0]S01_AXI_awburst;
  input [3:0]S01_AXI_awcache;
  input [7:0]S01_AXI_awlen;
  input [1:0]S01_AXI_awlock;
  input [2:0]S01_AXI_awprot;
  input [3:0]S01_AXI_awqos;
  output S01_AXI_awready;
  input [3:0]S01_AXI_awregion;
  input [2:0]S01_AXI_awsize;
  input S01_AXI_awvalid;
  input S01_AXI_bready;
  output [1:0]S01_AXI_bresp;
  output S01_AXI_bvalid;
  output [31:0]S01_AXI_rdata;
  output S01_AXI_rlast;
  input S01_AXI_rready;
  output [1:0]S01_AXI_rresp;
  output S01_AXI_rvalid;
  input [31:0]S01_AXI_wdata;
  input S01_AXI_wlast;
  output S01_AXI_wready;
  input [3:0]S01_AXI_wstrb;
  input S01_AXI_wvalid;

  wire axi_ic_ps7_S_AXI_ACP_ACLK_net;
  wire [0:0]axi_ic_ps7_S_AXI_ACP_ARESETN_net;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARADDR;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARBURST;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARCACHE;
  wire [7:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARLEN;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARLOCK;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARPROT;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARQOS;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARREADY;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARREGION;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARSIZE;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWADDR;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWBURST;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWCACHE;
  wire [7:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWLEN;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWLOCK;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWPROT;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWQOS;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWREADY;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWREGION;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWSIZE;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWVALID;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BREADY;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BRESP;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RDATA;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RLAST;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RREADY;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RRESP;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WDATA;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WLAST;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WREADY;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WSTRB;
  wire axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARADDR;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARBURST;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARCACHE;
  wire [7:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARLEN;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARLOCK;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARPROT;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARQOS;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARREADY;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARREGION;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARSIZE;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWADDR;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWBURST;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWCACHE;
  wire [7:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWLEN;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWLOCK;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWPROT;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWQOS;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWREADY;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWREGION;
  wire [2:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWSIZE;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWVALID;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BREADY;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BRESP;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RDATA;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RLAST;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RREADY;
  wire [1:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RRESP;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RVALID;
  wire [31:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WDATA;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WLAST;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WREADY;
  wire [3:0]axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WSTRB;
  wire axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WVALID;
  wire [31:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARADDR;
  wire [1:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARBURST;
  wire [3:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARCACHE;
  wire [0:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARID;
  wire [3:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARLEN;
  wire [1:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARLOCK;
  wire [2:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARPROT;
  wire [3:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARQOS;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARREADY;
  wire [2:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARSIZE;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARVALID;
  wire [31:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWADDR;
  wire [1:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWBURST;
  wire [3:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWCACHE;
  wire [0:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWID;
  wire [3:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWLEN;
  wire [1:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWLOCK;
  wire [2:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWPROT;
  wire [3:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWQOS;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWREADY;
  wire [2:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWSIZE;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWVALID;
  wire [2:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BID;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BREADY;
  wire [1:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BRESP;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BVALID;
  wire [63:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RDATA;
  wire [2:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RID;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RLAST;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RREADY;
  wire [1:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RRESP;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RVALID;
  wire [63:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WDATA;
  wire [0:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WID;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WLAST;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WREADY;
  wire [7:0]m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WSTRB;
  wire m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WVALID;
  wire [31:0]s00_couplers_to_xbar_ARADDR;
  wire [1:0]s00_couplers_to_xbar_ARBURST;
  wire [3:0]s00_couplers_to_xbar_ARCACHE;
  wire [7:0]s00_couplers_to_xbar_ARLEN;
  wire [0:0]s00_couplers_to_xbar_ARLOCK;
  wire [2:0]s00_couplers_to_xbar_ARPROT;
  wire [3:0]s00_couplers_to_xbar_ARQOS;
  wire [0:0]s00_couplers_to_xbar_ARREADY;
  wire [2:0]s00_couplers_to_xbar_ARSIZE;
  wire s00_couplers_to_xbar_ARVALID;
  wire [31:0]s00_couplers_to_xbar_AWADDR;
  wire [1:0]s00_couplers_to_xbar_AWBURST;
  wire [3:0]s00_couplers_to_xbar_AWCACHE;
  wire [7:0]s00_couplers_to_xbar_AWLEN;
  wire [0:0]s00_couplers_to_xbar_AWLOCK;
  wire [2:0]s00_couplers_to_xbar_AWPROT;
  wire [3:0]s00_couplers_to_xbar_AWQOS;
  wire [0:0]s00_couplers_to_xbar_AWREADY;
  wire [2:0]s00_couplers_to_xbar_AWSIZE;
  wire s00_couplers_to_xbar_AWVALID;
  wire s00_couplers_to_xbar_BREADY;
  wire [1:0]s00_couplers_to_xbar_BRESP;
  wire [0:0]s00_couplers_to_xbar_BVALID;
  wire [63:0]s00_couplers_to_xbar_RDATA;
  wire [0:0]s00_couplers_to_xbar_RLAST;
  wire s00_couplers_to_xbar_RREADY;
  wire [1:0]s00_couplers_to_xbar_RRESP;
  wire [0:0]s00_couplers_to_xbar_RVALID;
  wire [63:0]s00_couplers_to_xbar_WDATA;
  wire s00_couplers_to_xbar_WLAST;
  wire [0:0]s00_couplers_to_xbar_WREADY;
  wire [7:0]s00_couplers_to_xbar_WSTRB;
  wire s00_couplers_to_xbar_WVALID;
  wire [31:0]s01_couplers_to_xbar_ARADDR;
  wire [1:0]s01_couplers_to_xbar_ARBURST;
  wire [3:0]s01_couplers_to_xbar_ARCACHE;
  wire [7:0]s01_couplers_to_xbar_ARLEN;
  wire [0:0]s01_couplers_to_xbar_ARLOCK;
  wire [2:0]s01_couplers_to_xbar_ARPROT;
  wire [3:0]s01_couplers_to_xbar_ARQOS;
  wire [1:1]s01_couplers_to_xbar_ARREADY;
  wire [2:0]s01_couplers_to_xbar_ARSIZE;
  wire s01_couplers_to_xbar_ARVALID;
  wire [31:0]s01_couplers_to_xbar_AWADDR;
  wire [1:0]s01_couplers_to_xbar_AWBURST;
  wire [3:0]s01_couplers_to_xbar_AWCACHE;
  wire [7:0]s01_couplers_to_xbar_AWLEN;
  wire [0:0]s01_couplers_to_xbar_AWLOCK;
  wire [2:0]s01_couplers_to_xbar_AWPROT;
  wire [3:0]s01_couplers_to_xbar_AWQOS;
  wire [1:1]s01_couplers_to_xbar_AWREADY;
  wire [2:0]s01_couplers_to_xbar_AWSIZE;
  wire s01_couplers_to_xbar_AWVALID;
  wire s01_couplers_to_xbar_BREADY;
  wire [3:2]s01_couplers_to_xbar_BRESP;
  wire [1:1]s01_couplers_to_xbar_BVALID;
  wire [127:64]s01_couplers_to_xbar_RDATA;
  wire [1:1]s01_couplers_to_xbar_RLAST;
  wire s01_couplers_to_xbar_RREADY;
  wire [3:2]s01_couplers_to_xbar_RRESP;
  wire [1:1]s01_couplers_to_xbar_RVALID;
  wire [63:0]s01_couplers_to_xbar_WDATA;
  wire s01_couplers_to_xbar_WLAST;
  wire [1:1]s01_couplers_to_xbar_WREADY;
  wire [7:0]s01_couplers_to_xbar_WSTRB;
  wire s01_couplers_to_xbar_WVALID;
  wire [31:0]xbar_to_m00_couplers_ARADDR;
  wire [1:0]xbar_to_m00_couplers_ARBURST;
  wire [3:0]xbar_to_m00_couplers_ARCACHE;
  wire [0:0]xbar_to_m00_couplers_ARID;
  wire [7:0]xbar_to_m00_couplers_ARLEN;
  wire [0:0]xbar_to_m00_couplers_ARLOCK;
  wire [2:0]xbar_to_m00_couplers_ARPROT;
  wire [3:0]xbar_to_m00_couplers_ARQOS;
  wire xbar_to_m00_couplers_ARREADY;
  wire [3:0]xbar_to_m00_couplers_ARREGION;
  wire [2:0]xbar_to_m00_couplers_ARSIZE;
  wire [0:0]xbar_to_m00_couplers_ARVALID;
  wire [31:0]xbar_to_m00_couplers_AWADDR;
  wire [1:0]xbar_to_m00_couplers_AWBURST;
  wire [3:0]xbar_to_m00_couplers_AWCACHE;
  wire [0:0]xbar_to_m00_couplers_AWID;
  wire [7:0]xbar_to_m00_couplers_AWLEN;
  wire [0:0]xbar_to_m00_couplers_AWLOCK;
  wire [2:0]xbar_to_m00_couplers_AWPROT;
  wire [3:0]xbar_to_m00_couplers_AWQOS;
  wire xbar_to_m00_couplers_AWREADY;
  wire [3:0]xbar_to_m00_couplers_AWREGION;
  wire [2:0]xbar_to_m00_couplers_AWSIZE;
  wire [0:0]xbar_to_m00_couplers_AWVALID;
  wire [0:0]xbar_to_m00_couplers_BID;
  wire [0:0]xbar_to_m00_couplers_BREADY;
  wire [1:0]xbar_to_m00_couplers_BRESP;
  wire xbar_to_m00_couplers_BVALID;
  wire [63:0]xbar_to_m00_couplers_RDATA;
  wire [0:0]xbar_to_m00_couplers_RID;
  wire xbar_to_m00_couplers_RLAST;
  wire [0:0]xbar_to_m00_couplers_RREADY;
  wire [1:0]xbar_to_m00_couplers_RRESP;
  wire xbar_to_m00_couplers_RVALID;
  wire [63:0]xbar_to_m00_couplers_WDATA;
  wire [0:0]xbar_to_m00_couplers_WLAST;
  wire xbar_to_m00_couplers_WREADY;
  wire [7:0]xbar_to_m00_couplers_WSTRB;
  wire [0:0]xbar_to_m00_couplers_WVALID;

  assign M00_AXI_araddr[31:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARADDR;
  assign M00_AXI_arburst[1:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARBURST;
  assign M00_AXI_arcache[3:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARCACHE;
  assign M00_AXI_arid[0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARID;
  assign M00_AXI_arlen[3:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARLEN;
  assign M00_AXI_arlock[1:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARLOCK;
  assign M00_AXI_arprot[2:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARPROT;
  assign M00_AXI_arqos[3:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARQOS;
  assign M00_AXI_arsize[2:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARSIZE;
  assign M00_AXI_arvalid = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARVALID;
  assign M00_AXI_awaddr[31:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWADDR;
  assign M00_AXI_awburst[1:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWBURST;
  assign M00_AXI_awcache[3:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWCACHE;
  assign M00_AXI_awid[0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWID;
  assign M00_AXI_awlen[3:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWLEN;
  assign M00_AXI_awlock[1:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWLOCK;
  assign M00_AXI_awprot[2:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWPROT;
  assign M00_AXI_awqos[3:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWQOS;
  assign M00_AXI_awsize[2:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWSIZE;
  assign M00_AXI_awvalid = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWVALID;
  assign M00_AXI_bready = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BREADY;
  assign M00_AXI_rready = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RREADY;
  assign M00_AXI_wdata[63:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WDATA;
  assign M00_AXI_wid[0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WID;
  assign M00_AXI_wlast = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WLAST;
  assign M00_AXI_wstrb[7:0] = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WSTRB;
  assign M00_AXI_wvalid = m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WVALID;
  assign S00_AXI_arready = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWREADY;
  assign S00_AXI_bresp[1:0] = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[31:0] = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RDATA;
  assign S00_AXI_rlast = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RVALID;
  assign S00_AXI_wready = axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WREADY;
  assign S01_AXI_arready = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARREADY;
  assign S01_AXI_awready = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWREADY;
  assign S01_AXI_bresp[1:0] = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BRESP;
  assign S01_AXI_bvalid = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BVALID;
  assign S01_AXI_rdata[31:0] = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RDATA;
  assign S01_AXI_rlast = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RLAST;
  assign S01_AXI_rresp[1:0] = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RRESP;
  assign S01_AXI_rvalid = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RVALID;
  assign S01_AXI_wready = axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WREADY;
  assign axi_ic_ps7_S_AXI_ACP_ACLK_net = ACLK;
  assign axi_ic_ps7_S_AXI_ACP_ARESETN_net = ARESETN[0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARADDR = S00_AXI_araddr[31:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARLEN = S00_AXI_arlen[7:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARLOCK = S00_AXI_arlock[1:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARREGION = S00_AXI_arregion[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWADDR = S00_AXI_awaddr[31:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWLOCK = S00_AXI_awlock[1:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWREGION = S00_AXI_awregion[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RREADY = S00_AXI_rready;
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARADDR = S01_AXI_araddr[31:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARBURST = S01_AXI_arburst[1:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARCACHE = S01_AXI_arcache[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARLEN = S01_AXI_arlen[7:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARLOCK = S01_AXI_arlock[1:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARPROT = S01_AXI_arprot[2:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARQOS = S01_AXI_arqos[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARREGION = S01_AXI_arregion[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARSIZE = S01_AXI_arsize[2:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARVALID = S01_AXI_arvalid;
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWADDR = S01_AXI_awaddr[31:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWBURST = S01_AXI_awburst[1:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWCACHE = S01_AXI_awcache[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWLEN = S01_AXI_awlen[7:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWLOCK = S01_AXI_awlock[1:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWPROT = S01_AXI_awprot[2:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWQOS = S01_AXI_awqos[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWREGION = S01_AXI_awregion[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWSIZE = S01_AXI_awsize[2:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWVALID = S01_AXI_awvalid;
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BREADY = S01_AXI_bready;
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RREADY = S01_AXI_rready;
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WDATA = S01_AXI_wdata[31:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WLAST = S01_AXI_wlast;
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WSTRB = S01_AXI_wstrb[3:0];
  assign axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WVALID = S01_AXI_wvalid;
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARREADY = M00_AXI_arready;
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWREADY = M00_AXI_awready;
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BID = M00_AXI_bid[2:0];
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BRESP = M00_AXI_bresp[1:0];
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BVALID = M00_AXI_bvalid;
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RDATA = M00_AXI_rdata[63:0];
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RID = M00_AXI_rid[2:0];
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RLAST = M00_AXI_rlast;
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RRESP = M00_AXI_rresp[1:0];
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RVALID = M00_AXI_rvalid;
  assign m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WREADY = M00_AXI_wready;
  m00_couplers_imp_F6WOYG m00_couplers
       (.M_ACLK(axi_ic_ps7_S_AXI_ACP_ACLK_net),
        .M_ARESETN(axi_ic_ps7_S_AXI_ACP_ARESETN_net),
        .M_AXI_araddr(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARADDR),
        .M_AXI_arburst(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARBURST),
        .M_AXI_arcache(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARCACHE),
        .M_AXI_arid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARID),
        .M_AXI_arlen(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARLEN),
        .M_AXI_arlock(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARLOCK),
        .M_AXI_arprot(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARPROT),
        .M_AXI_arqos(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARQOS),
        .M_AXI_arready(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARREADY),
        .M_AXI_arsize(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARSIZE),
        .M_AXI_arvalid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_ARVALID),
        .M_AXI_awaddr(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWADDR),
        .M_AXI_awburst(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWBURST),
        .M_AXI_awcache(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWCACHE),
        .M_AXI_awid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWID),
        .M_AXI_awlen(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWLEN),
        .M_AXI_awlock(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWLOCK),
        .M_AXI_awprot(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWPROT),
        .M_AXI_awqos(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWQOS),
        .M_AXI_awready(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWREADY),
        .M_AXI_awsize(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWSIZE),
        .M_AXI_awvalid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_AWVALID),
        .M_AXI_bid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BID),
        .M_AXI_bready(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BREADY),
        .M_AXI_bresp(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BRESP),
        .M_AXI_bvalid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_BVALID),
        .M_AXI_rdata(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RDATA),
        .M_AXI_rid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RID),
        .M_AXI_rlast(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RLAST),
        .M_AXI_rready(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RREADY),
        .M_AXI_rresp(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RRESP),
        .M_AXI_rvalid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_RVALID),
        .M_AXI_wdata(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WDATA),
        .M_AXI_wid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WID),
        .M_AXI_wlast(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WLAST),
        .M_AXI_wready(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WREADY),
        .M_AXI_wstrb(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WSTRB),
        .M_AXI_wvalid(m00_couplers_to_axi_ic_ps7_S_AXI_ACP_WVALID),
        .S_ACLK(axi_ic_ps7_S_AXI_ACP_ACLK_net),
        .S_ARESETN(axi_ic_ps7_S_AXI_ACP_ARESETN_net),
        .S_AXI_araddr(xbar_to_m00_couplers_ARADDR),
        .S_AXI_arburst(xbar_to_m00_couplers_ARBURST),
        .S_AXI_arcache(xbar_to_m00_couplers_ARCACHE),
        .S_AXI_arid(xbar_to_m00_couplers_ARID),
        .S_AXI_arlen(xbar_to_m00_couplers_ARLEN),
        .S_AXI_arlock(xbar_to_m00_couplers_ARLOCK),
        .S_AXI_arprot(xbar_to_m00_couplers_ARPROT),
        .S_AXI_arqos(xbar_to_m00_couplers_ARQOS),
        .S_AXI_arready(xbar_to_m00_couplers_ARREADY),
        .S_AXI_arregion(xbar_to_m00_couplers_ARREGION),
        .S_AXI_arsize(xbar_to_m00_couplers_ARSIZE),
        .S_AXI_arvalid(xbar_to_m00_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m00_couplers_AWADDR),
        .S_AXI_awburst(xbar_to_m00_couplers_AWBURST),
        .S_AXI_awcache(xbar_to_m00_couplers_AWCACHE),
        .S_AXI_awid(xbar_to_m00_couplers_AWID),
        .S_AXI_awlen(xbar_to_m00_couplers_AWLEN),
        .S_AXI_awlock(xbar_to_m00_couplers_AWLOCK),
        .S_AXI_awprot(xbar_to_m00_couplers_AWPROT),
        .S_AXI_awqos(xbar_to_m00_couplers_AWQOS),
        .S_AXI_awready(xbar_to_m00_couplers_AWREADY),
        .S_AXI_awregion(xbar_to_m00_couplers_AWREGION),
        .S_AXI_awsize(xbar_to_m00_couplers_AWSIZE),
        .S_AXI_awvalid(xbar_to_m00_couplers_AWVALID),
        .S_AXI_bid(xbar_to_m00_couplers_BID),
        .S_AXI_bready(xbar_to_m00_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m00_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m00_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m00_couplers_RDATA),
        .S_AXI_rid(xbar_to_m00_couplers_RID),
        .S_AXI_rlast(xbar_to_m00_couplers_RLAST),
        .S_AXI_rready(xbar_to_m00_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m00_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m00_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m00_couplers_WDATA),
        .S_AXI_wlast(xbar_to_m00_couplers_WLAST),
        .S_AXI_wready(xbar_to_m00_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m00_couplers_WSTRB),
        .S_AXI_wvalid(xbar_to_m00_couplers_WVALID));
  s00_couplers_imp_QU0DDF s00_couplers
       (.M_ACLK(axi_ic_ps7_S_AXI_ACP_ACLK_net),
        .M_ARESETN(axi_ic_ps7_S_AXI_ACP_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_xbar_ARADDR),
        .M_AXI_arburst(s00_couplers_to_xbar_ARBURST),
        .M_AXI_arcache(s00_couplers_to_xbar_ARCACHE),
        .M_AXI_arlen(s00_couplers_to_xbar_ARLEN),
        .M_AXI_arlock(s00_couplers_to_xbar_ARLOCK),
        .M_AXI_arprot(s00_couplers_to_xbar_ARPROT),
        .M_AXI_arqos(s00_couplers_to_xbar_ARQOS),
        .M_AXI_arready(s00_couplers_to_xbar_ARREADY),
        .M_AXI_arsize(s00_couplers_to_xbar_ARSIZE),
        .M_AXI_arvalid(s00_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s00_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s00_couplers_to_xbar_AWCACHE),
        .M_AXI_awlen(s00_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s00_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s00_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s00_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s00_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s00_couplers_to_xbar_AWSIZE),
        .M_AXI_awvalid(s00_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s00_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s00_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s00_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s00_couplers_to_xbar_RDATA),
        .M_AXI_rlast(s00_couplers_to_xbar_RLAST),
        .M_AXI_rready(s00_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s00_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s00_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s00_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s00_couplers_to_xbar_WLAST),
        .M_AXI_wready(s00_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s00_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_xbar_WVALID),
        .S_ACLK(axi_ic_ps7_S_AXI_ACP_ACLK_net),
        .S_ARESETN(axi_ic_ps7_S_AXI_ACP_ARESETN_net),
        .S_AXI_araddr(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARADDR),
        .S_AXI_arburst(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARBURST),
        .S_AXI_arcache(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARCACHE),
        .S_AXI_arlen(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARLEN),
        .S_AXI_arlock(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARPROT),
        .S_AXI_arqos(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARQOS),
        .S_AXI_arready(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARREADY),
        .S_AXI_arregion(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARREGION),
        .S_AXI_arsize(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARSIZE),
        .S_AXI_arvalid(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWADDR),
        .S_AXI_awburst(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWBURST),
        .S_AXI_awcache(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWCACHE),
        .S_AXI_awlen(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWLEN),
        .S_AXI_awlock(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWPROT),
        .S_AXI_awqos(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWQOS),
        .S_AXI_awready(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWREADY),
        .S_AXI_awregion(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWREGION),
        .S_AXI_awsize(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWSIZE),
        .S_AXI_awvalid(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_AWVALID),
        .S_AXI_bready(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BRESP),
        .S_AXI_bvalid(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_BVALID),
        .S_AXI_rdata(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RDATA),
        .S_AXI_rlast(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RLAST),
        .S_AXI_rready(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RREADY),
        .S_AXI_rresp(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RRESP),
        .S_AXI_rvalid(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_RVALID),
        .S_AXI_wdata(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WDATA),
        .S_AXI_wlast(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WLAST),
        .S_AXI_wready(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(axi_ic_ps7_S_AXI_ACP_to_s00_couplers_WVALID));
  s01_couplers_imp_1OALJYZ s01_couplers
       (.M_ACLK(axi_ic_ps7_S_AXI_ACP_ACLK_net),
        .M_ARESETN(axi_ic_ps7_S_AXI_ACP_ARESETN_net),
        .M_AXI_araddr(s01_couplers_to_xbar_ARADDR),
        .M_AXI_arburst(s01_couplers_to_xbar_ARBURST),
        .M_AXI_arcache(s01_couplers_to_xbar_ARCACHE),
        .M_AXI_arlen(s01_couplers_to_xbar_ARLEN),
        .M_AXI_arlock(s01_couplers_to_xbar_ARLOCK),
        .M_AXI_arprot(s01_couplers_to_xbar_ARPROT),
        .M_AXI_arqos(s01_couplers_to_xbar_ARQOS),
        .M_AXI_arready(s01_couplers_to_xbar_ARREADY),
        .M_AXI_arsize(s01_couplers_to_xbar_ARSIZE),
        .M_AXI_arvalid(s01_couplers_to_xbar_ARVALID),
        .M_AXI_awaddr(s01_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s01_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s01_couplers_to_xbar_AWCACHE),
        .M_AXI_awlen(s01_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s01_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s01_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s01_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s01_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s01_couplers_to_xbar_AWSIZE),
        .M_AXI_awvalid(s01_couplers_to_xbar_AWVALID),
        .M_AXI_bready(s01_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s01_couplers_to_xbar_BRESP),
        .M_AXI_bvalid(s01_couplers_to_xbar_BVALID),
        .M_AXI_rdata(s01_couplers_to_xbar_RDATA),
        .M_AXI_rlast(s01_couplers_to_xbar_RLAST),
        .M_AXI_rready(s01_couplers_to_xbar_RREADY),
        .M_AXI_rresp(s01_couplers_to_xbar_RRESP),
        .M_AXI_rvalid(s01_couplers_to_xbar_RVALID),
        .M_AXI_wdata(s01_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s01_couplers_to_xbar_WLAST),
        .M_AXI_wready(s01_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s01_couplers_to_xbar_WSTRB),
        .M_AXI_wvalid(s01_couplers_to_xbar_WVALID),
        .S_ACLK(axi_ic_ps7_S_AXI_ACP_ACLK_net),
        .S_ARESETN(axi_ic_ps7_S_AXI_ACP_ARESETN_net),
        .S_AXI_araddr(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARADDR),
        .S_AXI_arburst(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARBURST),
        .S_AXI_arcache(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARCACHE),
        .S_AXI_arlen(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARLEN),
        .S_AXI_arlock(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARLOCK),
        .S_AXI_arprot(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARPROT),
        .S_AXI_arqos(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARQOS),
        .S_AXI_arready(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARREADY),
        .S_AXI_arregion(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARREGION),
        .S_AXI_arsize(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARSIZE),
        .S_AXI_arvalid(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_ARVALID),
        .S_AXI_awaddr(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWADDR),
        .S_AXI_awburst(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWBURST),
        .S_AXI_awcache(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWCACHE),
        .S_AXI_awlen(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWLEN),
        .S_AXI_awlock(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWLOCK),
        .S_AXI_awprot(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWPROT),
        .S_AXI_awqos(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWQOS),
        .S_AXI_awready(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWREADY),
        .S_AXI_awregion(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWREGION),
        .S_AXI_awsize(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWSIZE),
        .S_AXI_awvalid(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_AWVALID),
        .S_AXI_bready(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BREADY),
        .S_AXI_bresp(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BRESP),
        .S_AXI_bvalid(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_BVALID),
        .S_AXI_rdata(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RDATA),
        .S_AXI_rlast(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RLAST),
        .S_AXI_rready(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RREADY),
        .S_AXI_rresp(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RRESP),
        .S_AXI_rvalid(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_RVALID),
        .S_AXI_wdata(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WDATA),
        .S_AXI_wlast(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WLAST),
        .S_AXI_wready(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WREADY),
        .S_AXI_wstrb(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WSTRB),
        .S_AXI_wvalid(axi_ic_ps7_S_AXI_ACP_to_s01_couplers_WVALID));
  zc702_xbar_1 xbar
       (.aclk(axi_ic_ps7_S_AXI_ACP_ACLK_net),
        .aresetn(axi_ic_ps7_S_AXI_ACP_ARESETN_net),
        .m_axi_araddr(xbar_to_m00_couplers_ARADDR),
        .m_axi_arburst(xbar_to_m00_couplers_ARBURST),
        .m_axi_arcache(xbar_to_m00_couplers_ARCACHE),
        .m_axi_arid(xbar_to_m00_couplers_ARID),
        .m_axi_arlen(xbar_to_m00_couplers_ARLEN),
        .m_axi_arlock(xbar_to_m00_couplers_ARLOCK),
        .m_axi_arprot(xbar_to_m00_couplers_ARPROT),
        .m_axi_arqos(xbar_to_m00_couplers_ARQOS),
        .m_axi_arready(xbar_to_m00_couplers_ARREADY),
        .m_axi_arregion(xbar_to_m00_couplers_ARREGION),
        .m_axi_arsize(xbar_to_m00_couplers_ARSIZE),
        .m_axi_arvalid(xbar_to_m00_couplers_ARVALID),
        .m_axi_awaddr(xbar_to_m00_couplers_AWADDR),
        .m_axi_awburst(xbar_to_m00_couplers_AWBURST),
        .m_axi_awcache(xbar_to_m00_couplers_AWCACHE),
        .m_axi_awid(xbar_to_m00_couplers_AWID),
        .m_axi_awlen(xbar_to_m00_couplers_AWLEN),
        .m_axi_awlock(xbar_to_m00_couplers_AWLOCK),
        .m_axi_awprot(xbar_to_m00_couplers_AWPROT),
        .m_axi_awqos(xbar_to_m00_couplers_AWQOS),
        .m_axi_awready(xbar_to_m00_couplers_AWREADY),
        .m_axi_awregion(xbar_to_m00_couplers_AWREGION),
        .m_axi_awsize(xbar_to_m00_couplers_AWSIZE),
        .m_axi_awvalid(xbar_to_m00_couplers_AWVALID),
        .m_axi_bid(xbar_to_m00_couplers_BID),
        .m_axi_bready(xbar_to_m00_couplers_BREADY),
        .m_axi_bresp(xbar_to_m00_couplers_BRESP),
        .m_axi_bvalid(xbar_to_m00_couplers_BVALID),
        .m_axi_rdata(xbar_to_m00_couplers_RDATA),
        .m_axi_rid(xbar_to_m00_couplers_RID),
        .m_axi_rlast(xbar_to_m00_couplers_RLAST),
        .m_axi_rready(xbar_to_m00_couplers_RREADY),
        .m_axi_rresp(xbar_to_m00_couplers_RRESP),
        .m_axi_rvalid(xbar_to_m00_couplers_RVALID),
        .m_axi_wdata(xbar_to_m00_couplers_WDATA),
        .m_axi_wlast(xbar_to_m00_couplers_WLAST),
        .m_axi_wready(xbar_to_m00_couplers_WREADY),
        .m_axi_wstrb(xbar_to_m00_couplers_WSTRB),
        .m_axi_wvalid(xbar_to_m00_couplers_WVALID),
        .s_axi_araddr({s01_couplers_to_xbar_ARADDR,s00_couplers_to_xbar_ARADDR}),
        .s_axi_arburst({s01_couplers_to_xbar_ARBURST,s00_couplers_to_xbar_ARBURST}),
        .s_axi_arcache({s01_couplers_to_xbar_ARCACHE,s00_couplers_to_xbar_ARCACHE}),
        .s_axi_arid({1'b0,1'b0}),
        .s_axi_arlen({s01_couplers_to_xbar_ARLEN,s00_couplers_to_xbar_ARLEN}),
        .s_axi_arlock({s01_couplers_to_xbar_ARLOCK,s00_couplers_to_xbar_ARLOCK}),
        .s_axi_arprot({s01_couplers_to_xbar_ARPROT,s00_couplers_to_xbar_ARPROT}),
        .s_axi_arqos({s01_couplers_to_xbar_ARQOS,s00_couplers_to_xbar_ARQOS}),
        .s_axi_arready({s01_couplers_to_xbar_ARREADY,s00_couplers_to_xbar_ARREADY}),
        .s_axi_arsize({s01_couplers_to_xbar_ARSIZE,s00_couplers_to_xbar_ARSIZE}),
        .s_axi_arvalid({s01_couplers_to_xbar_ARVALID,s00_couplers_to_xbar_ARVALID}),
        .s_axi_awaddr({s01_couplers_to_xbar_AWADDR,s00_couplers_to_xbar_AWADDR}),
        .s_axi_awburst({s01_couplers_to_xbar_AWBURST,s00_couplers_to_xbar_AWBURST}),
        .s_axi_awcache({s01_couplers_to_xbar_AWCACHE,s00_couplers_to_xbar_AWCACHE}),
        .s_axi_awid({1'b0,1'b0}),
        .s_axi_awlen({s01_couplers_to_xbar_AWLEN,s00_couplers_to_xbar_AWLEN}),
        .s_axi_awlock({s01_couplers_to_xbar_AWLOCK,s00_couplers_to_xbar_AWLOCK}),
        .s_axi_awprot({s01_couplers_to_xbar_AWPROT,s00_couplers_to_xbar_AWPROT}),
        .s_axi_awqos({s01_couplers_to_xbar_AWQOS,s00_couplers_to_xbar_AWQOS}),
        .s_axi_awready({s01_couplers_to_xbar_AWREADY,s00_couplers_to_xbar_AWREADY}),
        .s_axi_awsize({s01_couplers_to_xbar_AWSIZE,s00_couplers_to_xbar_AWSIZE}),
        .s_axi_awvalid({s01_couplers_to_xbar_AWVALID,s00_couplers_to_xbar_AWVALID}),
        .s_axi_bready({s01_couplers_to_xbar_BREADY,s00_couplers_to_xbar_BREADY}),
        .s_axi_bresp({s01_couplers_to_xbar_BRESP,s00_couplers_to_xbar_BRESP}),
        .s_axi_bvalid({s01_couplers_to_xbar_BVALID,s00_couplers_to_xbar_BVALID}),
        .s_axi_rdata({s01_couplers_to_xbar_RDATA,s00_couplers_to_xbar_RDATA}),
        .s_axi_rlast({s01_couplers_to_xbar_RLAST,s00_couplers_to_xbar_RLAST}),
        .s_axi_rready({s01_couplers_to_xbar_RREADY,s00_couplers_to_xbar_RREADY}),
        .s_axi_rresp({s01_couplers_to_xbar_RRESP,s00_couplers_to_xbar_RRESP}),
        .s_axi_rvalid({s01_couplers_to_xbar_RVALID,s00_couplers_to_xbar_RVALID}),
        .s_axi_wdata({s01_couplers_to_xbar_WDATA,s00_couplers_to_xbar_WDATA}),
        .s_axi_wlast({s01_couplers_to_xbar_WLAST,s00_couplers_to_xbar_WLAST}),
        .s_axi_wready({s01_couplers_to_xbar_WREADY,s00_couplers_to_xbar_WREADY}),
        .s_axi_wstrb({s01_couplers_to_xbar_WSTRB,s00_couplers_to_xbar_WSTRB}),
        .s_axi_wvalid({s01_couplers_to_xbar_WVALID,s00_couplers_to_xbar_WVALID}));
endmodule
