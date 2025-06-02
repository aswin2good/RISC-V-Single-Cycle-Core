
module controller (
    input  [6:0] opcode,         // opcode
    input  [2:0] funct3,     // funct3 field (instruction type info)
    input        funct7bit5,   // funct7[5] (for ALU control, for example, add/sub)
    input        Zero,       // ALU output == 0 (used for branches)
    input        ALUbit31,     // ALU result MSB (used for signed comparisons)
    
    output [1:0] ResultSrc,  // selects ALU/memory/PC+4 result
    output       MemWrite,   // enable memory write
    output       PCSrc,      // select source of next PC (branch/jump)
    output       ALUSrc,     // ALU second operand: register vs immediate
    output       RegWrite,   // enable register write
    output       Jump,       // instruction is `jal`
    output       jalr,       // instruction is `jalr`
    output [1:0] ImmSrc,     // selects immediate type (I, S, B, etc.)
    output [2:0] ALUControl  // final ALU operation selector
);

	 
wire [1:0] ALUOp;
wire       Branch;

main_decoder    md (opcode, funct3,Zero,ALUbit31,ResultSrc, MemWrite, Branch,
                    ALUSrc, RegWrite, Jump,jalr, ImmSrc, ALUOp);

alu_decoder     ad (opcode[5], funct3, funct7bit5, ALUOp, ALUControl);


assign PCSrc = Branch | Jump;
endmodule
