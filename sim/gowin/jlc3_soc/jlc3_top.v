module jlc3_top(
     input wire rst_i_w
    ,input wire clk_i_w
    ,output wire txd_o_w
);

    reg en_r = 1;

    // reg rst_r = 1;
    // reg[7:0]   rst_cnt;

    // always@(posedge clk_i_w) begin
    //     rst_cnt = rst_cnt + 1;
    // end
    // always@(posedge clk_i_w) begin
    //     if(rst_cnt > 100) begin
    //         rst_r = 0;
    //     end else if(rst_cnt > 200) begin
    //         rst_r = 1;
    //     end else begin
    //         rst_r = 0;
    //     end
    // end

    jlc3_soc m_jlc3_soc(
        .rst_i_w(rst_i_w)
        ,.clk_i_w(clk_i_w)
        ,.en_i_w(en_r)
        ,.txd_o_w(txd_o_w)
    );
    // initial
    // begin
    //     $dumpfile("jlc3_tb_vcs.vcd");        //生成的vcd文件名称
    //     $dumpvars(0, jlc3_tb);    //tb模块名称
    // end

//   initial
//      $monitor("At time %t, value = %h (%0d)",$time, value, value);
endmodule // test