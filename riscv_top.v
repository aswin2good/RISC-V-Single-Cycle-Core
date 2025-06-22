`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 07:00:18 PM
// Design Name: 
// Module Name: riscv_top
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


module riscv_top(clk,reset,WriteDataM,DataAdrM,MemWriteM);
                           
    input clk;
    input reset;
    output [31:0] WriteDataM,DataAdrM;
    output MemWriteM;

    wire [31:0] Instr_F,PCF, ReadDataM;
    
    riscv_integrated ri(clk,reset,PCF,Instr_F,MemWriteM, DataAdrM,WriteDataM,ReadDataM);
    instruction_memory im(PCF,Instr_F);
    data_memory dm(clk, MemWriteM,DataAdrM,WriteDataM,ReadDataM);


endmodule

