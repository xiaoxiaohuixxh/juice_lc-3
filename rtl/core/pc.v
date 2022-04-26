module pc (
     input   wire           clk_i_w
    ,input   wire           rst_i_w

    ,input wire             en_i_w
    ,input wire             jmp_i_w
    ,input wire [15:0]      pc_addr_i_w

    ,output reg[15:0]       pc_o_r
);

    reg [15:0] pc_reg_r;
    
    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            pc_o_r <= 16'b0;
        end else begin
            if(en_i_w) begin
                if(jmp_i_w) begin
                    pc_o_r <= pc_addr_i_w;
                end else begin
                    pc_o_r <= pc_reg_r;
                end
            end
        end
    end
    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            pc_reg_r <= 16'b0;
        end else begin
            if(en_i_w) begin
                if(jmp_i_w) begin
                    pc_reg_r <= pc_addr_i_w;
                end else begin
                    pc_reg_r <= pc_reg_r + 1;
                end
            end
        end
    end

endmodule