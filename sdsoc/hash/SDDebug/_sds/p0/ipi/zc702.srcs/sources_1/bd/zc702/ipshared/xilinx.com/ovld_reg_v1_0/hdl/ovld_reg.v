`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Xilinx
// Engineer: Sam Skalicky
//
// Create Date: 11/2/2015 10:05:03 AM
// Design Name: Output Valid Scalar Register
// Module Name: ovld_reg
// Project Name: SDSoC Framework
// Target Devices: Zynq
// Tool Versions: 2015.4
// Description: This module stores values as signaled by the valid signal and 
//      overwrites again and again until done signal, then produces an output
//      valid signal.
//
// Dependencies: None
//
// Revision: 1.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module ovld_reg (
    //Input data signals from Acc
    input [DATA_WIDTH-1:0] data_in,
    input vld_in,
    //Input Acc status signal
    input ap_done,
    //Same clock as Acc
    input clk,
    //Output data signals to adapter
    output [DATA_WIDTH-1:0] data_out,
    output vld_out
    );
        
parameter DATA_WIDTH=32;
    
    reg [DATA_WIDTH-1:0] data_reg;
    reg valid;
    
    assign vld_out = valid;
    assign data_out = data_reg;
    
    //Capture rising done signal
    Event_Pulse ep1 (
        .in(ap_done),
        .clk(clk),
        .rising_edge(vld_out),
        .falling_edge(),
        .both_edges()
    );
    
    //latch in new data as it is produced (overwriting old intermediary values)
    always @(posedge clk) begin
        if(vld_in == 1)
            data_reg <= data_in;
    end
    
endmodule