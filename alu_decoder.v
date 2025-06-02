`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 10:32:50 PM
// Design Name: 
// Module Name: alu_decoder
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


module alu_decoder (
    input            opcodebit5,         // bit 5 of the opcode (op[5])
    input [2:0]      funct3,       // funct3 field of instruction
    input            funct7bit5,     // bit 5 of funct7 field (funct7[5])
    input [1:0]      ALUOp,        // ALU operation type from main decoder
    output reg [2:0] ALUControl    // control signal sent to the ALU
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000; // Addition for example: lw/sw/auipc
        2'b01: ALUControl = 3'b001; // Subtraction (for branches)
        2'b10: begin case (funct3) // R-type or I-type ALU
                3'b000: begin
                    // R-type subtract
                    if   (funct7bit5 & opcodebit5) ALUControl = 3'b001; //sub
                    else                   ALUControl = 3'b000; // add
                end
                3'b001:  ALUControl = 3'b100;//sll, slli
                3'b010:  ALUControl = 3'b101; // slt, slti
				3'b011:  ALUControl = 3'b101; //sltu ,sltiu	 
                3'b100:  ALUControl = 3'b111;//xor, xori	 
				3'b101:  ALUControl = 3'b110; //srl, srli ,sra,srai	 
                3'b110:  ALUControl = 3'b011; // or, ori	 
                3'b111:  ALUControl = 3'b010; // and, andi
                default: ALUControl = 3'bxxx; // ???
            endcase
        end
    endcase
end

endmodule


