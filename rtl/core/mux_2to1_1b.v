
module mux_2to1_1b(
     input wire sel
    ,input wire in1
    ,input wire in2
    ,output wire out
);
    assign out = (sel == 1'b0) ? in1 : in2;
endmodule