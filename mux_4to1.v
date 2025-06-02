

module mux_4to1(
    input       [31:0] d0, d1, d2, d3,
    input       [1:0] select,
    output      [31:0] y
);

assign y = select[1] ? (select[0] ? d3 : d2) : (select[0] ? d1 : d0);

endmodule
