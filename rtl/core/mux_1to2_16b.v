
module mux_1to2_16b(
     input wire sel
    ,input wire[15:0] in
    ,output wire[15:0] out1
    ,output wire[15:0] out2
);
    assign out1 = (sel == 1'b0) ? in : 16'b0;
    assign out2 = (sel == 1'b1) ? in : 16'b0;
endmodule