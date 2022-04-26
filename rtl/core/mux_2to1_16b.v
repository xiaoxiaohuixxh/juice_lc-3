
module mux_2to1_16b(
     input wire sel
    ,input wire[15:0] in1
    ,input wire[15:0] in2
    ,output wire[15:0] out
);
    assign out = (sel == 1'b0) ? in1 : in2;
endmodule