module dff_tb(
     input wire rst_i_w
    ,input wire clk_i_w
    ,input wire holden_i_w

    ,input wire[15:0] din_i_w
    ,output reg[15:0] qout_o_r
);

    dff #(
        .DW(16)
    ) m_dff (
         .clk_i_w(clk_i_w)
        ,.rst_i_w(rst_i_w)
        ,.holden_i_w(holden_i_w)

        ,.defv_i_w(16'haaaa)
        ,.din_i_w(din_i_w)
        ,.qout_o_r(qout_o_r)
    );

endmodule