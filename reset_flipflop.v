`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 11:01:25 PM
// Design Name: 
// Module Name: reset_flipflop
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

module reset_flipflop  (
    input       clk, rst,
    input       [31:0] d,
    output reg  [31:0] out
);

always @(posedge clk or posedge rst) begin
    if (rst) out <= 0;
    else     out <= d;
end

endmodule
