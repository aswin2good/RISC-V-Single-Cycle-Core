
module datapath(
    input         clk, reset,                     // Clock and reset for sequential logic
    
    input [1:0]   ResultSrc,                      // Selects the data to write back to register file (mux4)
    input         PCSrc,                          // Chooses between PC+4 or branch target address (from branch decision)
    input         ALUSrc,                         // Chooses second ALU input: from register or immediate
    input         RegWrite,                       // Enables register write-back
    input [1:0]   ImmSrc,                         // Selects immediate format: I, S, B, J (for imm_extend)
    input [2:0]   ALUControl,                     // Selects the ALU operation
    input         jalr,                           // Enables jalr (register-indirect jump)



    input  [31:0] Instr,                          // Current instruction from instruction memory
    input  [31:0] ReadData,                       // Data read from memory

    output        Zero,                           // ALU output == 0 flag (for branch decision)
    output        ALUbit31,                       // MSB of ALU result (used for signed comparisons)
    output [31:0] PC,                             // Current program counter value 
    output [31:0] Mem_WrAddr,                     // Memory address to write (from ALU)
    output [31:0] Mem_WrData,                     // Memory data to write (from register)
    output [31:0] Result, SrcA, SrcB              // ALU output or write-back data, ALU operands
);

// Internal wires
wire [31:0] PCPlus4, PCTarget, PCNext, WriteData, ImmExt, ALUResult;
wire [31:0] Auipc, lAuipc, rs1, rs2, rd, PCjalr;

// Choose next PC: either PC+4 or branch/jump target
mux_2to1 pc_mux(PCPlus4, PCTarget, PCSrc, PCNext);           

// Choose between normal PC (PCNext) or jalr (ALUResult) target
mux_2to1 jalr_mux(PCNext, ALUResult, jalr, PCjalr);           

// Program Counter register with reset
reset_flipflop pc_ff(clk, reset, PCjalr, PC);                   

// PC + 4 (next instruction address)
adder_32bit pc_add_4(PC, 32'd4, PCPlus4);                        

// Register file: read rs1, rs2; write rd with `Result` if RegWrite is enabled
reg_file rfile(clk, RegWrite, rs1, rs2, rd, Result, SrcA, WriteData);

// Immediate extension: extract immediate from instruction using ImmSrc
immediate_extend immediate(Instr[31:7], ImmSrc, ImmExt);             

// Branch/jump target = PC + offset
adder_32bit pc_add_branch(PC, ImmExt, PCTarget);                

// Select second ALU input: register or immediate
mux_2to1 srcb_mux(WriteData, ImmExt, ALUSrc, SrcB);           

// ALU operation
alu ALU(SrcA, SrcB, ALUControl, ALUResult, Zero, Instr[30], Instr[12]);

// AUIPC target = PC + upper immediate
adder_32bit auipc_adder({Instr[31:12], 12'b0}, PC, Auipc);      

// Choose between LUI immediate and AUIPC result (for mux_4to1)
mux_2to1 luipc_mux({Instr[31:12], 12'b0}, Auipc, Instr[5], lAuipc);

// Final result selection for register write-back
// ALUResult, ReadData (from mem), PC+4, or lAuipc
mux_4to1 Result_mux(ALUResult, ReadData, PCPlus4, lAuipc, ResultSrc, Result);

// Assign memory interface signals
assign Mem_WrAddr = ALUResult;         // Address comes from ALU
assign Mem_WrData = WriteData;         // Data to write comes from rs2

// ALUbit31 is MSB of ALUResult (used for slt/bge comparisons)
assign ALUbit31 = ALUResult[31];

// Decode register numbers from instruction
assign rs1 = Instr[19:15];             // rs1 register number
assign rs2 = Instr[24:20];             // rs2 register number
assign rd  = Instr[11:7];              // rd destination register

endmodule
