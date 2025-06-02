`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 11:20:56 PM
// Design Name: 
// Module Name: cpu_integration
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

module cpu_integration (
    input         clk, reset,       // Clock and reset for sequential logic
    output [31:0] PC,               // Current program counter value 
    input  [31:0] Instr,            // Current instruction from instruction memory
    input  [31:0] ReadData,         // Data read from memory
    
    output        MemWrite,         // Memory write
    output [31:0] Mem_WrAddr,       // Memory address to write (from ALU)
    output [31:0] Mem_WrData,       // Memory data to write (from register)
    
    output [31:0] Result            // output
);
wire        funct7bit5,ALUSrc, RegWrite, Jump, jalr,Zero,ALUbit31;
wire [1:0]  ResultSrc, ImmSrc;
wire [2:0]  ALUControl,funct3;

controller  control_main   (Instr[6:0], funct3, funct7bit5, Zero,ALUbit31,
                ResultSrc, MemWrite, PCSrc, ALUSrc, RegWrite, Jump,jalr,
                ImmSrc, ALUControl);

datapath    datapath_main  (clk, reset, ResultSrc, PCSrc,
                ALUSrc, RegWrite, ImmSrc, ALUControl,jalr,
                Zero, ALUbit31,PC, Instr, Mem_WrAddr, Mem_WrData, ReadData, Result,SrcA,SrcB);
                
assign funct3 = Instr[14:12];
assign funct7bit5 = Instr[30];
endmodule
