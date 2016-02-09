set moduleName set_assign_val
set isCombinational 0
set isDatapathOnly 0
set isPipelined 0
set pipeline_type none
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set C_modelName {set_assign_val}
set C_modelType { void 0 }
set C_modelArgList { 
	{ dest int 32 regular {axi_master 1}  }
	{ data1 int 30 regular  }
	{ tmp int 32 regular  }
	{ src int 32 regular  }
}
set C_modelArgMapList {[ 
	{ "Name" : "dest", "interface" : "axi_master", "bitwidth" : 32, "direction" : "WRITEONLY"} , 
 	{ "Name" : "data1", "interface" : "wire", "bitwidth" : 30, "direction" : "READONLY"} , 
 	{ "Name" : "tmp", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} , 
 	{ "Name" : "src", "interface" : "wire", "bitwidth" : 32, "direction" : "READONLY"} ]}
# RTL Port declarations: 
set portNum 54
set portList { 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst sc_in sc_logic 1 reset -1 active_high_sync } 
	{ ap_start sc_in sc_logic 1 start -1 } 
	{ ap_done sc_out sc_logic 1 predone -1 } 
	{ ap_idle sc_out sc_logic 1 done -1 } 
	{ ap_ready sc_out sc_logic 1 ready -1 } 
	{ m_axi_dest_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_dest_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_dest_AWADDR sc_out sc_lv 32 signal 0 } 
	{ m_axi_dest_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_dest_AWLEN sc_out sc_lv 32 signal 0 } 
	{ m_axi_dest_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_dest_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_dest_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_dest_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_dest_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_dest_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_dest_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_dest_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_dest_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_dest_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_dest_WDATA sc_out sc_lv 32 signal 0 } 
	{ m_axi_dest_WSTRB sc_out sc_lv 4 signal 0 } 
	{ m_axi_dest_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_dest_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_dest_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_dest_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_dest_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_dest_ARADDR sc_out sc_lv 32 signal 0 } 
	{ m_axi_dest_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_dest_ARLEN sc_out sc_lv 32 signal 0 } 
	{ m_axi_dest_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_dest_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_dest_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_dest_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_dest_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_dest_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_dest_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_dest_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_dest_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_dest_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_dest_RDATA sc_in sc_lv 32 signal 0 } 
	{ m_axi_dest_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_dest_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_dest_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_dest_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_dest_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_dest_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_dest_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_dest_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_dest_BUSER sc_in sc_lv 1 signal 0 } 
	{ data1 sc_in sc_lv 30 signal 1 } 
	{ tmp sc_in sc_lv 32 signal 2 } 
	{ src sc_in sc_lv 32 signal 3 } 
}
set NewPortList {[ 
	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst", "role": "default" }} , 
 	{ "name": "ap_start", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "start", "bundle":{"name": "ap_start", "role": "default" }} , 
 	{ "name": "ap_done", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "predone", "bundle":{"name": "ap_done", "role": "default" }} , 
 	{ "name": "ap_idle", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "done", "bundle":{"name": "ap_idle", "role": "default" }} , 
 	{ "name": "ap_ready", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "ready", "bundle":{"name": "ap_ready", "role": "default" }} , 
 	{ "name": "m_axi_dest_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "AWVALID" }} , 
 	{ "name": "m_axi_dest_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "AWREADY" }} , 
 	{ "name": "m_axi_dest_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dest", "role": "AWADDR" }} , 
 	{ "name": "m_axi_dest_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "AWID" }} , 
 	{ "name": "m_axi_dest_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dest", "role": "AWLEN" }} , 
 	{ "name": "m_axi_dest_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "dest", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_dest_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "dest", "role": "AWBURST" }} , 
 	{ "name": "m_axi_dest_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "dest", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_dest_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dest", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_dest_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "dest", "role": "AWPROT" }} , 
 	{ "name": "m_axi_dest_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dest", "role": "AWQOS" }} , 
 	{ "name": "m_axi_dest_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dest", "role": "AWREGION" }} , 
 	{ "name": "m_axi_dest_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "AWUSER" }} , 
 	{ "name": "m_axi_dest_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "WVALID" }} , 
 	{ "name": "m_axi_dest_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "WREADY" }} , 
 	{ "name": "m_axi_dest_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dest", "role": "WDATA" }} , 
 	{ "name": "m_axi_dest_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dest", "role": "WSTRB" }} , 
 	{ "name": "m_axi_dest_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "WLAST" }} , 
 	{ "name": "m_axi_dest_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "WID" }} , 
 	{ "name": "m_axi_dest_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "WUSER" }} , 
 	{ "name": "m_axi_dest_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "ARVALID" }} , 
 	{ "name": "m_axi_dest_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "ARREADY" }} , 
 	{ "name": "m_axi_dest_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dest", "role": "ARADDR" }} , 
 	{ "name": "m_axi_dest_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "ARID" }} , 
 	{ "name": "m_axi_dest_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dest", "role": "ARLEN" }} , 
 	{ "name": "m_axi_dest_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "dest", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_dest_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "dest", "role": "ARBURST" }} , 
 	{ "name": "m_axi_dest_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "dest", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_dest_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dest", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_dest_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "dest", "role": "ARPROT" }} , 
 	{ "name": "m_axi_dest_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dest", "role": "ARQOS" }} , 
 	{ "name": "m_axi_dest_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "dest", "role": "ARREGION" }} , 
 	{ "name": "m_axi_dest_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "ARUSER" }} , 
 	{ "name": "m_axi_dest_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "RVALID" }} , 
 	{ "name": "m_axi_dest_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "RREADY" }} , 
 	{ "name": "m_axi_dest_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "dest", "role": "RDATA" }} , 
 	{ "name": "m_axi_dest_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "RLAST" }} , 
 	{ "name": "m_axi_dest_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "RID" }} , 
 	{ "name": "m_axi_dest_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "RUSER" }} , 
 	{ "name": "m_axi_dest_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "dest", "role": "RRESP" }} , 
 	{ "name": "m_axi_dest_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "BVALID" }} , 
 	{ "name": "m_axi_dest_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "BREADY" }} , 
 	{ "name": "m_axi_dest_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "dest", "role": "BRESP" }} , 
 	{ "name": "m_axi_dest_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "BID" }} , 
 	{ "name": "m_axi_dest_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "dest", "role": "BUSER" }} , 
 	{ "name": "data1", "direction": "in", "datatype": "sc_lv", "bitwidth":30, "type": "signal", "bundle":{"name": "data1", "role": "default" }} , 
 	{ "name": "tmp", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "tmp", "role": "default" }} , 
 	{ "name": "src", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "src", "role": "default" }}  ]}
set Spec2ImplPortList { 
	dest { m_axi {  { m_axi_dest_AWVALID VALID 1 1 }  { m_axi_dest_AWREADY READY 0 1 }  { m_axi_dest_AWADDR ADDR 1 32 }  { m_axi_dest_AWID ID 1 1 }  { m_axi_dest_AWLEN LEN 1 32 }  { m_axi_dest_AWSIZE SIZE 1 3 }  { m_axi_dest_AWBURST BURST 1 2 }  { m_axi_dest_AWLOCK LOCK 1 2 }  { m_axi_dest_AWCACHE CACHE 1 4 }  { m_axi_dest_AWPROT PROT 1 3 }  { m_axi_dest_AWQOS QOS 1 4 }  { m_axi_dest_AWREGION REGION 1 4 }  { m_axi_dest_AWUSER USER 1 1 }  { m_axi_dest_WVALID VALID 1 1 }  { m_axi_dest_WREADY READY 0 1 }  { m_axi_dest_WDATA DATA 1 32 }  { m_axi_dest_WSTRB STRB 1 4 }  { m_axi_dest_WLAST LAST 1 1 }  { m_axi_dest_WID ID 1 1 }  { m_axi_dest_WUSER USER 1 1 }  { m_axi_dest_ARVALID VALID 1 1 }  { m_axi_dest_ARREADY READY 0 1 }  { m_axi_dest_ARADDR ADDR 1 32 }  { m_axi_dest_ARID ID 1 1 }  { m_axi_dest_ARLEN LEN 1 32 }  { m_axi_dest_ARSIZE SIZE 1 3 }  { m_axi_dest_ARBURST BURST 1 2 }  { m_axi_dest_ARLOCK LOCK 1 2 }  { m_axi_dest_ARCACHE CACHE 1 4 }  { m_axi_dest_ARPROT PROT 1 3 }  { m_axi_dest_ARQOS QOS 1 4 }  { m_axi_dest_ARREGION REGION 1 4 }  { m_axi_dest_ARUSER USER 1 1 }  { m_axi_dest_RVALID VALID 0 1 }  { m_axi_dest_RREADY READY 1 1 }  { m_axi_dest_RDATA DATA 0 32 }  { m_axi_dest_RLAST LAST 0 1 }  { m_axi_dest_RID ID 0 1 }  { m_axi_dest_RUSER USER 0 1 }  { m_axi_dest_RRESP RESP 0 2 }  { m_axi_dest_BVALID VALID 0 1 }  { m_axi_dest_BREADY READY 1 1 }  { m_axi_dest_BRESP RESP 0 2 }  { m_axi_dest_BID ID 0 1 }  { m_axi_dest_BUSER USER 0 1 } } }
	data1 { ap_none {  { data1 in_data 0 30 } } }
	tmp { ap_none {  { tmp in_data 0 32 } } }
	src { ap_none {  { src in_data 0 32 } } }
}
