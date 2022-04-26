
`include "def.v"
module alu(
    //  input wire           clk_i_w
    // ,
    input wire           rst_i_w
    ,input wire           en_i_w
    ,input wire[2:0]      op_i_w
    ,input wire[15:0]     s1_i_w
    ,input wire[15:0]     s2_i_w
    ,output reg[15:0]     out_o_r
    // ,output reg           ok_o_r
);
    wire [15:0] s1_w = s1_i_w == 16'hffff ? 0 : s1_i_w;
    wire [15:0] s2_w = s2_i_w == 16'hffff ? 0 : s2_i_w;
    always @(*) begin
        if(!rst_i_w) begin
            // ok_o_r = 1;
            out_o_r = 0;
        end else begin
            if(en_i_w) begin
                case(op_i_w)
                    `ALU_OP_ADD: begin
                        out_o_r = s1_w + s2_w;
                    end
                    `ALU_OP_AND: begin
                        out_o_r = s1_w & s2_w;
                    end
                    `ALU_OP_NOT: begin
                        out_o_r = ~(s1_w);
                    end
                    default: begin

                    end
                endcase
            end
        end
    end

endmodule // alu