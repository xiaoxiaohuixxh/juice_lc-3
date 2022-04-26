`include "def.v"
module ctrl(
     input   wire           clk_i_w
    ,input   wire           rst_i_w

    ,input wire             en_i_w

    // ID input
    ,input wire             wreg_en_i_w
    ,input wire             mem_en_i_w
    ,input wire[1:0]        mem_addr_sel_i_w  // mem_rdat or alu_output or imm
    ,input wire             mem_wr_rd_i_w

    ,input wire             mem2_en_i_w
    ,input wire[1:0]        mem2_addr_sel_i_w  // mem_rdat or alu_output or imm
    ,input wire             mem2_wr_rd_i_w

    ,input wire             alu_en_i_w
    // ,input wire[15:0]       simm_i_w
    ,input wire[15:0]       pc_i_w
    ,input wire[1:0]        setpc_i_w  // disable , direct set pc or offset


    // mux input
    ,input wire[15:0]       setpc_addr_i_w


    // output
    ,output reg             pc_en_o_r
    ,output reg             instr_en_o_r
    ,output reg             id_en_o_r
    ,output reg             alu_en_o_r
    ,output reg             mem_en_o_r

    ,output reg[15:0]       pc_addr_o_r
    ,output reg             pc_jmp_o_r

    ,output reg[1:0]        mem_addr_sel_o_r  // mem_rdat or alu_output or imm
    ,output reg             mem_wr_rd_o_r

    ,output reg             wreg_en_o_r

    // ,output reg             alu_output_dir_o_r
    // ,output reg[2:0]        alu_op_o_r


);

    // reg pp1_pc_reg_r [15:0];
    `define ctrl_sta_reset          4'd0
    `define ctrl_sta_stall          4'd1
    `define ctrl_sta_instr          4'd2
    `define ctrl_sta_id             4'd3
    `define ctrl_sta_alu            4'd4
    `define ctrl_sta_mem1           4'd5
    `define ctrl_sta_mem2           4'd6
    `define ctrl_sta_wreg           4'd7
    `define ctrl_sta_updatepc       4'd8

    reg[3:0]    ctrl_sta_r;
    reg[3:0]    ctrl_nxtsta_r;

    always @(*) begin
        if(!rst_i_w) begin
            pc_jmp_o_r = 1'b0;
            pc_addr_o_r = 16'b0;
        end else begin
            if(en_i_w) begin
                case(setpc_i_w)
                `setpc_dis: begin
                    pc_jmp_o_r = 1'b0;
                    pc_addr_o_r = 16'b0;
                end
                `setpc_offset: begin
                    pc_jmp_o_r = 1'b1;
                    pc_addr_o_r = pc_i_w + setpc_addr_i_w;
                end
                `setpc_direct: begin
                    pc_jmp_o_r = 1'b1;
                    pc_addr_o_r = pc_i_w + setpc_addr_i_w;
                end
                default: begin

                end
                endcase
            end
        end
    end
    always @(*) begin
        if(!rst_i_w) begin
            ctrl_nxtsta_r = `ctrl_sta_reset;
        end else begin
            if(en_i_w) begin
                case(ctrl_sta_r)
                    `ctrl_sta_reset: begin
                        instr_en_o_r = 1'b1;
                        ctrl_nxtsta_r = `ctrl_sta_instr;
                    end
                    `ctrl_sta_instr: begin
                        instr_en_o_r = 1'b0;
                        id_en_o_r = 1'b1;
                        // $display("*****jlc3 ctrl id enter***********************");
                        ctrl_nxtsta_r = `ctrl_sta_id;
                    end
                    `ctrl_sta_id: begin
                        id_en_o_r = 1'b0;
                        if(alu_en_i_w) begin // 判断是否需要alu
                            alu_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_alu;
                        end else if(mem_en_i_w) begin // 判断是否需要mem1
                            mem_en_o_r = 1'b1;
                            mem_addr_sel_o_r = mem_addr_sel_i_w;
                            mem_wr_rd_o_r = mem_wr_rd_i_w;
                            ctrl_nxtsta_r = `ctrl_sta_mem1;
                        end else if(mem2_en_i_w) begin
                            mem_en_o_r = 1'b1;
                            mem_addr_sel_o_r = mem2_addr_sel_i_w;
                            mem_wr_rd_o_r = mem2_wr_rd_i_w;
                            ctrl_nxtsta_r = `ctrl_sta_mem2;
                        end else if(wreg_en_i_w) begin
                            wreg_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_wreg;
                        end else begin
                            pc_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_updatepc;
                        end
                    end
                    `ctrl_sta_alu: begin
                        alu_en_o_r = 1'b0;
                        if(mem_en_i_w) begin // 判断是否需要mem1
                            mem_en_o_r = 1'b1;
                            mem_addr_sel_o_r = mem_addr_sel_i_w;
                            mem_wr_rd_o_r = mem_wr_rd_i_w;
                            ctrl_nxtsta_r = `ctrl_sta_mem1;
                        end else if(mem2_en_i_w) begin
                            mem_en_o_r = 1'b1;
                            mem_addr_sel_o_r = mem2_addr_sel_i_w;
                            mem_wr_rd_o_r = mem2_wr_rd_i_w;
                            ctrl_nxtsta_r = `ctrl_sta_mem2;
                        end else if(wreg_en_i_w) begin
                            wreg_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_wreg;
                        end else begin
                            pc_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_updatepc;
                        end
                    end
                    `ctrl_sta_mem1: begin
                        if(mem2_en_i_w) begin
                            mem_en_o_r = 1'b1;
                            mem_addr_sel_o_r = mem2_addr_sel_i_w;
                            mem_wr_rd_o_r = mem2_wr_rd_i_w;
                            ctrl_nxtsta_r = `ctrl_sta_mem2;
                        end else if(wreg_en_i_w) begin
                            mem_en_o_r = 1'b0;
                            wreg_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_wreg;
                        end else begin
                            mem_en_o_r = 1'b0;
                            pc_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_updatepc;
                        end
                    end
                    `ctrl_sta_mem2: begin
                        mem_en_o_r = 1'b0;
                        if(wreg_en_i_w) begin
                            wreg_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_wreg;
                        end else begin
                            pc_en_o_r = 1'b1;
                            ctrl_nxtsta_r = `ctrl_sta_updatepc;
                        end
                    end
                    `ctrl_sta_wreg: begin
                        wreg_en_o_r = 1'b0;
                        pc_en_o_r = 1'b1;
                        ctrl_nxtsta_r = `ctrl_sta_updatepc;
                    end
                    `ctrl_sta_updatepc: begin
                        pc_en_o_r = 1'b0;
                        ctrl_nxtsta_r = `ctrl_sta_reset;
                    end
                    `ctrl_sta_stall: begin
                        
                    end
                    default: begin
                        ctrl_nxtsta_r = `ctrl_sta_reset;
                    end
                endcase
            end
        end
    end
    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            ctrl_sta_r <= `ctrl_sta_reset;
        end else begin
            if(en_i_w) begin
                ctrl_sta_r <= ctrl_nxtsta_r;
            end
        end
    end

endmodule