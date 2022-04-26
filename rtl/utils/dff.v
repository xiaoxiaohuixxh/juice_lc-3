module dff # (
     parameter DW = 16
)(
     input wire clk_i_w
    ,input wire rst_i_w
    ,input wire holden_i_w

    ,input wire[DW-1:0] defv_i_w
    ,input wire[DW-1:0] din_i_w
    ,output reg[DW-1:0] qout_o_r
);
    reg[DW-1:0] qout_r;

    always @(*) begin
        if(!rst_i_w | holden_i_w) begin
            qout_r = defv_i_w;
        end else begin
            qout_r = din_i_w;
        end
    end

    always @(posedge clk_i_w or negedge rst_i_w) begin
        qout_o_r <= qout_r;
    end
    
endmodule