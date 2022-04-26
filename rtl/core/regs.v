module regs (
     input   wire           clk_i_w
    ,input   wire           rst_i_w

    ,input wire             r_en1_i_w
    ,input wire [2:0]       r_addr1_i_w
    ,output reg [15:0]      r_dat1_o_r

    ,input wire             r_en2_i_w
    ,input wire [2:0]       r_addr2_i_w
    ,output reg [15:0]      r_dat2_o_r

    ,input wire             w_en_i_w
    ,input wire [2:0]       w_addr_i_w
    ,input wire [15:0]      w_dat_i_w

    ,output reg [2:0]       psr_nzp_o_r
);

    reg [15:0] reg_r0_r;
    reg [15:0] reg_r1_r;
    reg [15:0] reg_r2_r;
    reg [15:0] reg_r3_r;
    reg [15:0] reg_r4_r;
    reg [15:0] reg_r5_r;
    reg [15:0] reg_r6_r;
    reg [15:0] reg_r7_r;

    // write reg
    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            reg_r0_r <= 16'b0;
            reg_r1_r <= 16'b0;
            reg_r2_r <= 16'b0;
            reg_r3_r <= 16'b0;
            reg_r4_r <= 16'b0;
            reg_r5_r <= 16'b0;
            reg_r6_r <= 16'b0;
            reg_r7_r <= 16'b0;
        end else begin
            if(w_en_i_w) begin
                if(w_dat_i_w[15]) begin
                    psr_nzp_o_r <= 3'b100; // 负数
                end else if(|w_dat_i_w) begin
                    psr_nzp_o_r <= 3'b001; // 正数
                end else begin
                    psr_nzp_o_r <= 3'b010; // zero
                end
                case (w_addr_i_w)
                3'd0:begin
                    reg_r0_r <= w_dat_i_w;
                end
                3'd1:begin
                    reg_r1_r <= w_dat_i_w;
                end
                3'd2:begin
                    reg_r2_r <= w_dat_i_w;
                end
                3'd3:begin
                    reg_r3_r <= w_dat_i_w;
                end
                3'd4:begin
                    reg_r4_r <= w_dat_i_w;
                end
                3'd5:begin
                    reg_r5_r <= w_dat_i_w;
                end
                3'd6:begin
                    reg_r6_r <= w_dat_i_w;
                end
                3'd7:begin
                    reg_r7_r <= w_dat_i_w;
                end
                default:begin
                    
                end
                endcase
            end
        end
    end

    always @(*) begin
        if(!rst_i_w) begin
        end else begin
            if(r_en1_i_w) begin
                if(w_en_i_w && w_addr_i_w == r_addr1_i_w) begin
                    r_dat1_o_r = w_dat_i_w;
                end else begin
                    case (r_addr1_i_w)
                    3'd0:begin
                        r_dat1_o_r = reg_r0_r;
                    end
                    3'd1:begin
                        r_dat1_o_r = reg_r1_r;
                    end
                    3'd2:begin
                        r_dat1_o_r = reg_r2_r;
                    end
                    3'd3:begin
                        r_dat1_o_r = reg_r3_r;
                    end
                    3'd4:begin
                        r_dat1_o_r = reg_r4_r;
                    end
                    3'd5:begin
                        r_dat1_o_r = reg_r5_r;
                    end
                    3'd6:begin
                        r_dat1_o_r = reg_r6_r;
                    end
                    3'd7:begin
                        r_dat1_o_r = reg_r7_r;
                    end
                    default:begin
                        r_dat1_o_r = 0;
                    end
                    endcase
                end
            end
        end
    end

    always @(*) begin
        if(!rst_i_w) begin
        end else begin
            if(r_en2_i_w) begin
                if(w_en_i_w && w_addr_i_w == r_addr2_i_w) begin
                    r_dat2_o_r = w_dat_i_w;
                end else begin
                    case (r_addr2_i_w)
                    3'd0:begin
                        r_dat2_o_r = reg_r0_r;
                    end
                    3'd1:begin
                        r_dat2_o_r = reg_r1_r;
                    end
                    3'd2:begin
                        r_dat2_o_r = reg_r2_r;
                    end
                    3'd3:begin
                        r_dat2_o_r = reg_r3_r;
                    end
                    3'd4:begin
                        r_dat2_o_r = reg_r4_r;
                    end
                    3'd5:begin
                        r_dat2_o_r = reg_r5_r;
                    end
                    3'd6:begin
                        r_dat2_o_r = reg_r6_r;
                    end
                    3'd7:begin
                        r_dat2_o_r = reg_r7_r;
                    end
                    default:begin
                        r_dat2_o_r = 0;
                    end
                    endcase
                end
            end
        end
    end
endmodule // regs