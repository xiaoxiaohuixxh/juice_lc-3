`include "def.v"
module mem_ctrl(
     input wire             clk_i_w
    ,input wire             rst_i_w
    ,input wire             en_i_w

    ,input wire[15:0]       addr_i_w

    ,input wire             wr_i_w
    ,input wire[15:0]       wdat_i_w

    ,output reg[15:0]       rdat_o_r

    ,output  reg             send_o_r
    ,output  reg[7:0]        schar_o_r
    ,input  wire[1:0]       sta_i_w
);

    `define   mem_size   1024
    `define   uart0_waddr   1025
    `define   uart0_raddr   1026
    `define   uart0_saddr   1027
    `define   uart0_seaddr   1028
    reg [15:0]      mem_reg_r[`mem_size:0];
    /* verilator lint_off UNUSED */
    reg [15:0]      uart0_dat;
    /* verilator lint_on UNUSED */
    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            // mem_reg_r[0] <= {4'b0001, 3'b010 , 3'b010 , 1'b1 , 5'b10_111}; // ADD DR=010 SR=010 imm5=10_111
            // mem_reg_r[1] <= {4'b0001, 3'b010 , 3'b010 , 1'b1 , 5'b10_101}; // ADD DR=010 SR=010 imm5=10_101
            // mem_reg_r[2] <= {4'b0001, 3'b010 , 3'b010 , 1'b1 , 5'b10_101}; // ADD DR=010 SR=010 imm5=10_101
            // $readmemh("rom/lc3.txt",mem_reg_r);
            $readmemb("rom/lc3.bin",mem_reg_r);
            
            // $display("mem write addr 00 dat %x",mem_reg_r[0]);
            // $display("mem write addr 01 dat %x",mem_reg_r[1]);
            // $display("mem write addr 02 dat %x",mem_reg_r[2]);
            // $display("mem write addr 03 dat %x",mem_reg_r[3]);
            // $display("mem write addr 04 dat %x",mem_reg_r[4]);
            send_o_r <= 1'b0;
            schar_o_r <= 8'b0;
        end else begin
            if(en_i_w) begin
                case(wr_i_w)
                    `mem_wr: begin
                        // $display("mem write addr %x dat %x",addr_i_w, wdat_i_w);
                        if(addr_i_w <= `mem_size) begin
                            $display("mem write addr %d dat %x",addr_i_w, wdat_i_w);
                            /* verilator lint_off WIDTH */
                            mem_reg_r[addr_i_w] <= wdat_i_w;
                            /* verilator lint_on WIDTH */
                        end else if(addr_i_w ==  `uart0_waddr)begin
                            /* verilator lint_off WIDTH */
                            schar_o_r <= wdat_i_w[7:0];
                            $display("uart0 write %x %c", wdat_i_w , wdat_i_w);
                            /* verilator lint_on WIDTH */
                        end else if(addr_i_w ==  `uart0_seaddr)begin
                            $display("uart0 uart0_seaddr %x", wdat_i_w[0]);
                            send_o_r <= wdat_i_w[0];
                        end else if(addr_i_w ==  `uart0_raddr)begin
                            $display("uart0 read error %x", wdat_i_w);
                        end
                    end
                    `mem_rd: begin
                    end
                    default: begin

                    end
                endcase
            end
        end
    end

    always @(*) begin
        if(!rst_i_w) begin
            rdat_o_r = 16'b0;
        end else begin
            if(en_i_w) begin
                case(wr_i_w)
                    `mem_wr: begin
                    end
                    `mem_rd: begin
                        if(addr_i_w <= `mem_size) begin
                            /* verilator lint_off WIDTH */
                            // $display("mem read addr %d dat %x",addr_i_w, mem_reg_r[addr_i_w]);
                            rdat_o_r = mem_reg_r[addr_i_w];
                            /* verilator lint_on WIDTH */
                        end else if(addr_i_w ==  `uart0_waddr)begin
                            $display("uart0 write error %x", rdat_o_r);
                        end else if(addr_i_w ==  `uart0_raddr)begin
                            $display("uart0 read %x", rdat_o_r);
                        end else if(addr_i_w ==  `uart0_saddr)begin
                            $display("uart0 read stac %x", sta_i_w);
                            rdat_o_r = {{14{1'b0}},sta_i_w};
                        end
                    end
                    default: begin

                    end
                endcase
            end
        end
    end

endmodule