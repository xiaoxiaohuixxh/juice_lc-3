module jlc3_top(
     input wire rst_i_w
    ,input wire clk_i_w
);

    reg en_r = 1;
    jlc3 jlc3_m(
        .rst_i_w(rst_i_w)
        ,.clk_i_w(clk_i_w)
        ,.en_i_w(en_r)
    );
    // initial
    // begin
    //     $dumpfile("jlc3_tb_vcs.vcd");        //生成的vcd文件名称
    //     $dumpvars(0, jlc3_tb);    //tb模块名称
    // end

//   initial
//      $monitor("At time %t, value = %h (%0d)",$time, value, value);
endmodule // test