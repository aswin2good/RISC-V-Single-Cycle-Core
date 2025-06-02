

module main_decoder (
    input  [6:0] opcode,       // Opcode from instruction
    input  [2:0] funct3,       // funct3 field from instruction
    input        Zero, ALUbit31, // Flags from ALU (Zero flag and Sign/Comparison flag)
    output [1:0] ResultSrc,    // Selects result source for write-back
    output       MemWrite,     // Memory write enable
    output       Branch,       // Branch control signal
    output       ALUSrc,       // ALU source select (immediate or register)
    output       RegWrite,     // Register write enable
    output       Jump, jalr,   // Control signals for jump/jalr
    output [1:0] ImmSrc,       // Selects immediate type
    output [1:0] ALUOp         // Tells ALU what operation to perform
);

reg [10:0] controls;  // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_ALUOp_Jump_jalr
reg new_branch;

always @(*) begin
    new_branch = 0;
    casez (opcode)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_ALUOp_Jump_jalr
        7'b0000011: controls = 11'b1_00_1_0_01_00_0_0; // lw
        7'b0100011: controls = 11'b0_01_1_1_00_00_0_0; // sw
        7'b0110011: controls = 11'b1_xx_0_0_00_10_0_0; // R-type
        7'b1100011: begin //branch
		  controls = 11'b0_10_0_0_00_01_0_0; 
		  case(funct3)
		      3'b000: new_branch =Zero;//beq
		      3'b001: new_branch =!Zero;//bne
		      3'b101: new_branch =!ALUbit31;//bge
		      3'b111: new_branch =!ALUbit31;//bgeu
		      3'b100: new_branch =ALUbit31;//blt
		      3'b110: new_branch =ALUbit31;//bltu
		  endcase
		  end
        7'b0010011: controls = 11'b1_00_1_0_00_10_0_0; // I-type ALU
		7'b0?10111: controls = 11'b1_xx_x_0_11_xx_0_0;  //lui or auipc
		7'b1100111: controls = 11'b1_00_1_0_10_00_0_1;  //jalr 
        7'b1101111: controls = 11'b1_11_0_0_10_00_1_0; // jal
        default:    controls = 11'bx_xx_x_x_xx_xx_x_x; // don't care case
    endcase
end
assign Branch = new_branch;
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUOp, Jump,jalr} = controls;
endmodule




