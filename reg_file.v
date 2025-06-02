

module reg_file (
    input       clk,
    input       wr_en,
    input       [4:0] rd_addr1, rd_addr2, wr_addr,
    input       [31:0] wr_data,
    
    
    output      [31:0] rd_data1, rd_data2
);

reg [31:0] reg_file_array [0:31];

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        reg_file_array[i] = 0;
    end
end

// register file write logic (synchronous)
always @(posedge clk) begin
    if (wr_en) reg_file_array[wr_addr] <= wr_data;
end

// register file read logic (combinational)
assign rd_data1 = ( rd_addr1 != 0 ) ? reg_file_array[rd_addr1] : 0;
assign rd_data2 = ( rd_addr2 != 0 ) ? reg_file_array[rd_addr2] : 0;

endmodule
