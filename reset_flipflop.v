
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
