`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 11:03:59 PM
// Design Name: 
// Module Name: mux_4to1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux_4to1(
    input       [31:0] d0, d1, d2, d3,
    input       [1:0] select,
    output      [31:0] y
);

assign y = select[1] ? (select[0] ? d3 : d2) : (select[0] ? d1 : d0);

endmodule
