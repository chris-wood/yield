`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Xilinx
// Engineer: Sam Skalicky
//
// Create Date: 07/16/2015 10:05:03 AM
// Design Name: Accelerator Trace Monitor
// Module Name: Event_Pulse
// Project Name: SDSoC Trace Framework
// Target Devices: Zynq
// Tool Versions: 2015.2
// Description: This module produces various pulses for different events of the
//      input signal: rising or falling edge or both edges.
//
// Dependencies: None
//
// Revision: 1.0
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Event_Pulse(
    input in,               //Input signal to monitor
    input clk,              //clock to sample the input signal at
    output rising_edge,     //Output pulse if a rising edge is found
    output falling_edge,    //Output pulse if a falling edge is found
    output both_edges       //Output pulse if any edge is found
    );

    reg [1:0] reg_i = 2'b0; //two bit register for identifying edges

    assign rising_edge = (~reg_i[1]) &  reg_i[0];  //rising edge
    assign falling_edge =  reg_i[1]  &(~reg_i[0]); //falling edge
    assign both_edges = ((~reg_i[1]) &  reg_i[0]) | (reg_i[1] & (~reg_i[0]));   //both edges

    //Shift in the signal every clock cycle
    always @(posedge clk)
    begin
        reg_i[0] <= in;
        reg_i[1] <= reg_i[0];
    end
endmodule
