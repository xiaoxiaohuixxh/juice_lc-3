
`include "simple_uart_def.v"
module simple_uart_send(
     input  wire        rst_i_w
    ,input  wire        clk_i_w
    ,input  wire        en_i_w
    ,input  wire        send_i_w
    ,input  wire[7:0]   schar_i_w
    ,output reg[1:0]    sta_o_r
    ,output reg         txd_o_r
);

    reg[2:0] send_sta_r;
    reg[2:0] send_nxtsta_r;

    reg[3:0] send_dat_item_r;

    `define send_sta_idle       3'b000
    `define send_sta_start      3'b001
    `define send_sta_send_dat   3'b010
    `define send_sta_stopflag   3'b011
    // `define send_sta_startflag  3'b010
    // `define send_sta_sumflag    3'b100



    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            send_dat_item_r <= 4'd0;
        end else begin
            if(en_i_w) begin
                case(send_sta_r)
                    `send_sta_idle: begin
                    end
                    `send_sta_start: begin
                        send_dat_item_r <= 4'd0;
                    end
                    `send_sta_send_dat: begin
                        send_dat_item_r <= send_dat_item_r + 1;
                    end
                    `send_sta_stopflag: begin

                    end
                    default: begin
                    
                    end
                endcase
            end
        end
    end

    always @(*) begin
        if(!rst_i_w) begin
            send_nxtsta_r = `send_sta_idle;
        end else begin
            if(en_i_w) begin
                case(send_sta_r)
                    `send_sta_idle: begin
                    end
                    `send_sta_start: begin
                        send_nxtsta_r = `send_sta_send_dat;
                    end
                    `send_sta_send_dat: begin
                        if(send_dat_item_r == 8) begin
                            send_nxtsta_r = `send_sta_stopflag;
                        end
                    end
                    `send_sta_stopflag: begin
                        send_nxtsta_r = `send_sta_idle;
                    end
                    default: begin
                    end
                endcase
            end
        end
    end

    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            sta_o_r <= `simple_uart_idle;
        end else begin
            if(en_i_w) begin
                case(send_sta_r)
                    `send_sta_idle: begin
                        sta_o_r <=  sta_o_r & 2'b10;
                    end
                    `send_sta_start: begin
                        sta_o_r <=  sta_o_r | `simple_uart_send;
                    end
                    `send_sta_send_dat: begin
                        
                    end
                    `send_sta_stopflag: begin
                        
                    end
                    default: begin
                        sta_o_r <= `simple_uart_idle;
                    end
                endcase
            end
        end
    end

    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            txd_o_r <= 1'b1;
        end else begin
            if(en_i_w) begin
                case(send_sta_r)
                    `send_sta_idle: begin
                        txd_o_r <= 1'b1;
                    end
                    `send_sta_start: begin
                        txd_o_r <= 1'b0;
                    end
                    `send_sta_send_dat: begin
                        txd_o_r <= schar_i_w[send_dat_item_r-1];
                    end
                    `send_sta_stopflag: begin
                        txd_o_r <= 1'b1;
                    end
                    default: begin
                    
                    end
                endcase
            end
        end
    end


    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            send_sta_r <= `send_sta_idle;
        end else begin
            if(en_i_w) begin
                if(send_i_w) begin
                    send_sta_r <= `send_sta_start;
                end else begin
                    send_sta_r <= send_nxtsta_r;
                end
            end
        end
    end

endmodule