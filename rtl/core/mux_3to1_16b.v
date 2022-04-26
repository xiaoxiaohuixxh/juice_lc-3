
module mux_3to1_16b(
     input wire[1:0] sel
    ,input wire[15:0] in1
    ,input wire[15:0] in2
    ,input wire[15:0] in3
    ,output wire[15:0] out
);
    assign out = (sel == 2'b00) ? in1 :
                 ((sel == 2'b01) ? in2 : in3);
endmodule