`include "def.v"

module id (
    //  input   wire           clk_i_w
    // ,
     input   wire           rst_i_w
    ,input wire             en_i_w
    ,input wire[15:0]       instr_i_w

    ,output reg             wreg_en_o_r
    ,output reg             wreg_sel_o_r // mem_rdat or alu_output

    ,output reg             mem_en_o_r
    ,output reg[1:0]        mem_addr_sel_o_r  // mem_rdat or alu_output or imm

    ,output reg             mem_wr_rd_o_r

    
    ,output reg             mem2_en_o_r
    ,output reg[1:0]        mem2_addr_sel_o_r  // mem_rdat or alu_output or imm

    ,output reg             mem2_wr_rd_o_r

    ,output reg             alu_output_dir_o_r // alu to mem_addr or reg

    ,output reg             alu_en_o_r
    ,output reg[2:0]        alu_op_o_r

    ,output reg             alu_in_dir_o_r  // pc or reg

    ,output reg             read_reg1_en_o_r
    ,output reg             read_reg2_en_o_r

    ,output reg[2:0]        dst_reg_addr_o_r
    ,output reg[2:0]        read_reg1_addr_o_r
    ,output reg[2:0]        read_reg2_addr_o_r

    ,output reg             imm_or_reg_o_r
    ,output reg[15:0]       simm_o_r
    ,output reg[1:0]        setpc_ismem_or_imm_reg1_o_r // mem_rdat or imm or reg1


    ,input wire[2:0]        psr_nzp_i_w

    ,output reg[1:0]        setpc_o_r  // disable , direct set pc or offset
);

    wire [3:0]  instr_op_w = instr_i_w[15:12];
    wire [2:0]  instr_r1_w = instr_i_w[11:9];
    wire [2:0]  instr_r2_w = instr_i_w[8:6];
    wire [2:0]  instr_r3_w = instr_i_w[2:0];
    wire [4:0]  instr_imm5_w = instr_i_w[4:0];
    wire [8:0]  instr_pcoffset9_w = instr_i_w[8:0];
    wire [5:0]  instr_offset6_w = instr_i_w[5:0];
    wire [10:0] instr_pcoffset11_w = instr_i_w[10:0];
    wire [7:0]  instr_trapvect8_w = instr_i_w[7:0];
    
    wire [2:0]  instr_nzp_w = instr_i_w[11:9];

    wire instr_isimm_w = instr_i_w[5];
    wire instr_isoffset_w = instr_i_w[11];

    always @(*) begin
        if(!rst_i_w) begin
            read_reg1_addr_o_r = 3'b000;
            read_reg2_addr_o_r = 3'b000;
            dst_reg_addr_o_r = 3'b000;
        end else begin
            if(en_i_w) begin
                // $display("jlc3 id op %b",instr_op_w);
                // $display("jlc3 id instr %x",instr_i_w);
                // $display("jlc3 id instr_pcoffset11_w %x",instr_pcoffset11_w);
                // $display("jlc3 id instr_pcoffset11_w %x",{{5{instr_pcoffset11_w[10]}},instr_pcoffset11_w[10:0]}+1);
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    dst_reg_addr_o_r = instr_r1_w;
                    read_reg1_addr_o_r = instr_r2_w;
                end
                `INSTR_OP_ADD,`INSTR_OP_AND: begin
                    // $display("jlc3 id op add");
                    dst_reg_addr_o_r = instr_r1_w;
                    if(instr_isimm_w == 1'b1) begin
                        read_reg1_addr_o_r = instr_r2_w;
                    end else begin
                        read_reg1_addr_o_r = instr_r2_w;
                        read_reg2_addr_o_r = instr_r3_w;
                    end
                end
                `INSTR_OP_LEA: begin
                    dst_reg_addr_o_r = instr_r1_w;
                end
                `INSTR_OP_LD: begin
                    // $display("jlc3 id LD offset %d",instr_pcoffset9_w);
                    dst_reg_addr_o_r = instr_r1_w;
                end
                `INSTR_OP_ST: begin
                    read_reg1_addr_o_r = instr_r1_w;
                end
                `INSTR_OP_LDR: begin
                    dst_reg_addr_o_r = instr_r1_w;
                    read_reg1_addr_o_r = instr_r2_w;
                end
                `INSTR_OP_STR: begin
                    // $display("jlc3 id STR offset %d",instr_offset6_w);
                    read_reg1_addr_o_r = instr_r2_w;
                    read_reg2_addr_o_r = instr_r1_w;
                end
                `INSTR_OP_LDI: begin
                    dst_reg_addr_o_r = instr_r1_w;
                end
                `INSTR_OP_STI: begin
                    read_reg1_addr_o_r = instr_r1_w;
                end
                `INSTR_OP_BR_NOP: begin
                end
                `INSTR_OP_JMP_RET: begin
                    read_reg1_addr_o_r = instr_r2_w;
                end
                `INSTR_OP_JSR_JSRR: begin
                    if(instr_isoffset_w) begin
                        dst_reg_addr_o_r = 7;
                    end else begin
                        dst_reg_addr_o_r = 7;
                        read_reg1_addr_o_r = instr_r2_w;
                    end
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                end
                default: begin

                end
                endcase
            end
        end
    end

    always @(*) begin
        if(!rst_i_w) begin
            simm_o_r = 16'h0000;
        end else begin
            if(en_i_w) begin
                
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                end
                `INSTR_OP_ADD,`INSTR_OP_AND: begin
                    if(instr_isimm_w == 1'b1) begin
                        simm_o_r = {{12{instr_imm5_w[4]}},instr_imm5_w[3:0]}; // sign extend to 16 bits
                    end
                end
                `INSTR_OP_LEA: begin
                    simm_o_r = {{8{instr_pcoffset9_w[8]}},instr_pcoffset9_w[7:0]} + 1; // sign extend to 16 bits
                end
                `INSTR_OP_LD: begin
                    simm_o_r = {{8{instr_pcoffset9_w[8]}},instr_pcoffset9_w[7:0]} + 1; // sign extend to 16 bits
                end
                `INSTR_OP_ST: begin
                    simm_o_r = {{8{instr_pcoffset9_w[8]}},instr_pcoffset9_w[7:0]} + 1; // sign extend to 16 bits
                end
                `INSTR_OP_LDR: begin
                    simm_o_r = {{11{instr_offset6_w[5]}},instr_offset6_w[4:0]}; // sign extend to 16 bits
                end
                `INSTR_OP_STR: begin
                    simm_o_r = {{11{instr_offset6_w[5]}},instr_offset6_w[4:0]}; // sign extend to 16 bits
                end
                `INSTR_OP_LDI: begin
                    simm_o_r = {{8{instr_pcoffset9_w[8]}},instr_pcoffset9_w[7:0]} + 1; // sign extend to 16 bits
                end
                `INSTR_OP_STI: begin
                    simm_o_r = {{8{instr_pcoffset9_w[8]}},instr_pcoffset9_w[7:0]} + 1; // sign extend to 16 bits
                end
                `INSTR_OP_BR_NOP: begin
                    simm_o_r = {{8{instr_pcoffset9_w[8]}},instr_pcoffset9_w[7:0]} + 1;// sign extend to 16 bits
                end
                `INSTR_OP_JMP_RET: begin
                    
                end
                `INSTR_OP_JSR_JSRR: begin
                    if(instr_isoffset_w) begin
                        simm_o_r = {{5{instr_pcoffset11_w[10]}},instr_pcoffset11_w[10:0]} + 1; // sign extend to 16 bits
                    end else begin
                        // simm_o_r = {{6{instr_pcoffset11_w[10]}},instr_pcoffset11_w[9:0]}; // sign extend to 16 bits
                    end
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                    simm_o_r = {{8{1'b0}},instr_trapvect8_w[7:0]};
                    // simm_o_r = instr_trapvect8_w[7:0];
                end
                default: begin

                end
                endcase
            end
        end
    end

/*
instr        wreg_en_o_r
not             1
add             1
and             1
lea             1
ld              1
st              0
ldr             1
str             0
ldi             1
sti             0
br/nop          0
jmp/ret         0
jsr/jsrr        1
rti             0
trap            1
*/
    always @(*) begin
        if(!rst_i_w) begin
            wreg_en_o_r = 1'b0;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    wreg_en_o_r = 1'b1;
                end
                `INSTR_OP_ADD: begin
                    if(instr_isimm_w == 1'b1) begin
                        wreg_en_o_r = 1'b1;
                    end else begin
                        wreg_en_o_r = 1'b1;
                    end
                end
                `INSTR_OP_AND: begin
                    if(instr_isimm_w == 1'b1) begin
                        wreg_en_o_r = 1'b1;
                    end else begin
                        wreg_en_o_r = 1'b1;
                    end
                end
                `INSTR_OP_LEA: begin
                    wreg_en_o_r = 1'b1;
                end
                `INSTR_OP_LD: begin
                    wreg_en_o_r = 1'b1;
                end
                `INSTR_OP_ST: begin
                    wreg_en_o_r = 1'b0;
                end
                `INSTR_OP_LDR: begin
                    wreg_en_o_r = 1'b1;
                end
                `INSTR_OP_STR: begin
                    wreg_en_o_r = 1'b0;
                end
                `INSTR_OP_LDI: begin
                    wreg_en_o_r = 1'b1;
                end
                `INSTR_OP_STI: begin
                    wreg_en_o_r = 1'b0;
                end
                `INSTR_OP_BR_NOP: begin
                    wreg_en_o_r = 1'b0;
                end
                `INSTR_OP_JMP_RET: begin
                    wreg_en_o_r = 1'b0;
                end
                `INSTR_OP_JSR_JSRR: begin
                    wreg_en_o_r = 1'b1;
                end
                `INSTR_OP_RTI: begin
                    wreg_en_o_r = 1'b0;
                end
                `INSTR_OP_TRAP: begin
                    wreg_en_o_r = 1'b1;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*
instr        wreg_sel_o_r
not             alu
add             alu
and             alu
lea             alu
ld              mem
st              x
ldr             mem
str             x
ldi             mem
sti             x
br/nop          x
jmp/ret         x
jsr/jsrr        alu
rti             x
trap            x
*/
    always @(*) begin
        if(!rst_i_w) begin
            wreg_sel_o_r = `wreg_sel_alu;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    wreg_sel_o_r = `wreg_sel_alu;
                end
                `INSTR_OP_ADD: begin
                    if(instr_isimm_w == 1'b1) begin
                        wreg_sel_o_r = `wreg_sel_alu;
                    end else begin
                        wreg_sel_o_r = `wreg_sel_alu;
                    end
                end
                `INSTR_OP_AND: begin
                    if(instr_isimm_w == 1'b1) begin
                        wreg_sel_o_r = `wreg_sel_alu;
                    end else begin
                        wreg_sel_o_r = `wreg_sel_alu;
                    end
                end
                `INSTR_OP_LEA: begin
                    wreg_sel_o_r = `wreg_sel_alu;
                end
                `INSTR_OP_LD: begin
                    wreg_sel_o_r = `wreg_sel_mem;
                end
                `INSTR_OP_ST: begin
                    
                end
                `INSTR_OP_LDR: begin
                    wreg_sel_o_r = `wreg_sel_mem;
                end
                `INSTR_OP_STR: begin
                    
                end
                `INSTR_OP_LDI: begin
                    wreg_sel_o_r = `wreg_sel_mem;
                end
                `INSTR_OP_STI: begin
                    
                end
                `INSTR_OP_BR_NOP: begin
                    
                end
                `INSTR_OP_JMP_RET: begin
                    
                end
                `INSTR_OP_JSR_JSRR: begin
                    wreg_sel_o_r = `wreg_sel_alu;
                end
                `INSTR_OP_RTI: begin
                    
                end
                `INSTR_OP_TRAP: begin
                    
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        mem_en_o_r
not             0
add             0
and             0
lea             0
ld              1
st              1
ldr             1
str             1
ldi             1
sti             1
br/nop          0
jmp/ret         0
jsr/jsrr        0
rti             0
trap            1
*/
    always @(*) begin
        if(!rst_i_w) begin
            mem_en_o_r = 1'b0;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    mem_en_o_r = 1'b0;
                end
                `INSTR_OP_ADD: begin
                    if(instr_isimm_w == 1'b1) begin
                        mem_en_o_r = 1'b0;
                    end else begin
                        mem_en_o_r = 1'b0;
                    end
                end
                `INSTR_OP_AND: begin
                    if(instr_isimm_w == 1'b1) begin
                        mem_en_o_r = 1'b0;
                    end else begin
                        mem_en_o_r = 1'b0;
                    end
                end
                `INSTR_OP_LEA: begin
                    mem_en_o_r = 1'b0;
                end
                `INSTR_OP_LD: begin
                    mem_en_o_r = 1'b1;
                end
                `INSTR_OP_ST: begin
                    mem_en_o_r = 1'b1;
                end
                `INSTR_OP_LDR: begin
                    mem_en_o_r = 1'b1;
                end
                `INSTR_OP_STR: begin
                    mem_en_o_r = 1'b1;
                end
                `INSTR_OP_LDI: begin
                    mem_en_o_r = 1'b1;
                end
                `INSTR_OP_STI: begin
                    mem_en_o_r = 1'b1;
                end
                `INSTR_OP_BR_NOP: begin
                    mem_en_o_r = 1'b0;
                end
                `INSTR_OP_JMP_RET: begin
                    mem_en_o_r = 1'b0;
                end
                `INSTR_OP_JSR_JSRR: begin
                    mem_en_o_r = 1'b0;
                end
                `INSTR_OP_RTI: begin
                    mem_en_o_r = 1'b1;
                end
                `INSTR_OP_TRAP: begin
                    mem_en_o_r = 1'b1;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*
instr        mem_addr_sel_o_r
not             x
add             x
and             x
lea             x
ld              alu
st              alu
ldr             alu
str             alu
ldi             alu
sti             alu
br/nop          x
jmp/ret         x
jsr/jsrr        x
rti             x
trap            imm
*/
    always @(*) begin
        if(!rst_i_w) begin
            mem_addr_sel_o_r = `mem_addr_sel_alu;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                end
                `INSTR_OP_ADD: begin
                end
                `INSTR_OP_AND: begin
                end
                `INSTR_OP_LEA: begin
                end
                `INSTR_OP_LD: begin
                    mem_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_ST: begin
                    mem_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_LDR: begin
                    mem_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_STR: begin
                    mem_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_LDI: begin
                    mem_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_STI: begin
                    mem_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_BR_NOP: begin
                    
                end
                `INSTR_OP_JMP_RET: begin
                    
                end
                `INSTR_OP_JSR_JSRR: begin
                    
                end
                `INSTR_OP_RTI: begin
                    
                end
                `INSTR_OP_TRAP: begin
                    mem_addr_sel_o_r = `mem_addr_sel_imm;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end
/*

instr        mem_wr_rd_o_r
not             x
add             x
and             x
lea             x
ld              r
st              w
ldr             r
str             w
ldi             r
sti             r
br/nop          x
jmp/ret         x
jsr/jsrr        x
rti             x
trap            r
*/
    always @(*) begin
        if(!rst_i_w) begin
            mem_wr_rd_o_r = `mem_rd;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                end
                `INSTR_OP_ADD: begin
                end
                `INSTR_OP_AND: begin
                end
                `INSTR_OP_LEA: begin
                end
                `INSTR_OP_LD: begin
                    mem_wr_rd_o_r = `mem_rd;
                end
                `INSTR_OP_ST: begin
                    mem_wr_rd_o_r = `mem_wr;
                end
                `INSTR_OP_LDR: begin
                    mem_wr_rd_o_r = `mem_rd;
                end
                `INSTR_OP_STR: begin
                    mem_wr_rd_o_r = `mem_wr;
                end
                `INSTR_OP_LDI: begin
                    mem_wr_rd_o_r = `mem_rd;
                end
                `INSTR_OP_STI: begin
                    mem_wr_rd_o_r = `mem_rd;
                end
                `INSTR_OP_BR_NOP: begin
                    
                end
                `INSTR_OP_JMP_RET: begin
                    
                end
                `INSTR_OP_JSR_JSRR: begin
                    
                end
                `INSTR_OP_RTI: begin
                    
                end
                `INSTR_OP_TRAP: begin
                    mem_wr_rd_o_r = `mem_rd;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end
/*

instr        mem2_en_o_r
not             0
add             0
and             0
lea             0
ld              0
st              0
ldr             0
str             0
ldi             1
sti             1
br/nop          0
jmp/ret         0
jsr/jsrr        0
rti             0
trap            0
*/

    always @(*) begin
        if(!rst_i_w) begin
            mem2_en_o_r = 1'b0;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_ADD: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_AND: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_LEA: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_LD: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_ST: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_LDR: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_STR: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_LDI: begin
                    mem2_en_o_r = 1'b1;
                end
                `INSTR_OP_STI: begin
                    mem2_en_o_r = 1'b1;
                end
                `INSTR_OP_BR_NOP: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_JMP_RET: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_JSR_JSRR: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_RTI: begin
                    mem2_en_o_r = 1'b0;
                end
                `INSTR_OP_TRAP: begin
                    mem2_en_o_r = 1'b0;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        mem2_addr_sel_o_r
not             0
add             0
and             0
lea             0
ld              0
st              0
ldr             0
str             0
ldi             mem
sti             mem
br/nop          0
jmp/ret         0
jsr/jsrr        0
rti             0
trap            0
*/

    always @(*) begin
        if(!rst_i_w) begin
            mem2_addr_sel_o_r = `mem_addr_sel_alu;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_ADD: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_AND: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_LEA: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_LD: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_ST: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_LDR: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_STR: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_LDI: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_mem;
                end
                `INSTR_OP_STI: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_mem;
                end
                `INSTR_OP_BR_NOP: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_JMP_RET: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_JSR_JSRR: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_RTI: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                `INSTR_OP_TRAP: begin
                    mem2_addr_sel_o_r = `mem_addr_sel_alu;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end


/*

instr        mem2_wr_rd_o_r
not             x
add             x
and             x
lea             x
ld              x
st              x
ldr             x
str             x
ldi             r
sti             w
br/nop          x
jmp/ret         x
jsr/jsrr        x
rti             x
trap            x

*/
    always @(*) begin
        if(!rst_i_w) begin
            mem2_wr_rd_o_r = `mem_rd;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                end
                `INSTR_OP_ADD: begin
                end
                `INSTR_OP_AND: begin
                end
                `INSTR_OP_LEA: begin
                end
                `INSTR_OP_LD: begin
                end
                `INSTR_OP_ST: begin
                end
                `INSTR_OP_LDR: begin
                end
                `INSTR_OP_STR: begin
                end
                `INSTR_OP_LDI: begin
                    mem2_wr_rd_o_r = `mem_rd;
                end
                `INSTR_OP_STI: begin
                    mem2_wr_rd_o_r = `mem_wr;
                end
                `INSTR_OP_BR_NOP: begin
                end
                `INSTR_OP_JMP_RET: begin
                end
                `INSTR_OP_JSR_JSRR: begin
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        alu_output_dir_o_r
not             reg
add             reg
and             reg
lea             reg
ld              mem_addr
st              mem_addr
ldr             mem_addr
str             mem_addr
ldi             mem_addr
sti             mem_addr
br/nop          x 这里使用的alu是pc模块自带的
jmp/ret         x
jsr/jsrr        x
rti             x
trap            x
*/
    always @(*) begin
        if(!rst_i_w) begin
            alu_output_dir_o_r = `alu_output_dir_wreg;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    alu_output_dir_o_r = `alu_output_dir_wreg;
                end
                `INSTR_OP_ADD: begin
                    alu_output_dir_o_r = `alu_output_dir_wreg;
                end
                `INSTR_OP_AND: begin
                    alu_output_dir_o_r = `alu_output_dir_wreg;
                end
                `INSTR_OP_LEA: begin
                    alu_output_dir_o_r = `alu_output_dir_wreg;
                end
                `INSTR_OP_LD: begin
                    alu_output_dir_o_r = `alu_output_dir_memaddr;
                end
                `INSTR_OP_ST: begin
                    alu_output_dir_o_r = `alu_output_dir_memaddr;
                end
                `INSTR_OP_LDR: begin
                    alu_output_dir_o_r = `alu_output_dir_memaddr;
                end
                `INSTR_OP_STR: begin
                    alu_output_dir_o_r = `alu_output_dir_memaddr;
                end
                `INSTR_OP_LDI: begin
                    alu_output_dir_o_r = `alu_output_dir_memaddr;
                end
                `INSTR_OP_STI: begin
                    alu_output_dir_o_r = `alu_output_dir_memaddr;
                end
                `INSTR_OP_BR_NOP: begin
                end
                `INSTR_OP_JMP_RET: begin
                end
                `INSTR_OP_JSR_JSRR: begin
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        alu_en_o_r
not             1
add             1
and             1
lea             1
ld              1
st              1
ldr             1
str             1
ldi             1
sti             1
br/nop          0
jmp/ret         0
jsr/jsrr        0
rti             0
trap            0
*/
    always @(*) begin
        if(!rst_i_w) begin
            alu_en_o_r = 1'b0;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_ADD: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_AND: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_LEA: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_LD: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_ST: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_LDR: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_STR: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_LDI: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_STI: begin
                    alu_en_o_r = 1'b1;
                end
                `INSTR_OP_BR_NOP: begin
                    alu_en_o_r = 1'b0;
                end
                `INSTR_OP_JMP_RET: begin
                    alu_en_o_r = 1'b0;
                end
                `INSTR_OP_JSR_JSRR: begin
                    alu_en_o_r = 1'b0;
                end
                `INSTR_OP_RTI: begin
                    alu_en_o_r = 1'b0;
                end
                `INSTR_OP_TRAP: begin
                    alu_en_o_r = 1'b0;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        alu_op_o_r
not             not
add             add
and             and
lea             add
ld              add
st              add
ldr             add
str             add
ldi             add
sti             add
br/nop          0
jmp/ret         0
jsr/jsrr        0
rti             0
trap            0

*/
    always @(*) begin
        if(!rst_i_w) begin
            alu_op_o_r = `ALU_OP_ADD;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    alu_op_o_r = `ALU_OP_NOT;
                end
                `INSTR_OP_ADD: begin
                    alu_op_o_r = `ALU_OP_ADD;
                end
                `INSTR_OP_AND: begin
                    alu_op_o_r = `ALU_OP_AND;
                end
                `INSTR_OP_LEA: begin
                    alu_op_o_r = `ALU_OP_ADD;
                end
                `INSTR_OP_LD: begin
                    alu_op_o_r = `ALU_OP_ADD;
                end
                `INSTR_OP_ST: begin
                    alu_op_o_r = `ALU_OP_ADD;
                end
                `INSTR_OP_LDR: begin
                    alu_op_o_r = `ALU_OP_ADD;
                end
                `INSTR_OP_STR: begin
                    alu_op_o_r = `ALU_OP_ADD;
                end
                `INSTR_OP_LDI: begin
                    alu_op_o_r = `ALU_OP_ADD;
                end
                `INSTR_OP_STI: begin
                    alu_op_o_r = `ALU_OP_ADD;
                end
                `INSTR_OP_BR_NOP: begin
                end
                `INSTR_OP_JMP_RET: begin
                end
                `INSTR_OP_JSR_JSRR: begin
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        alu_in_dir_o_r
not             reg
add             reg
and             reg
lea             pc
ld              pc
st              pc
ldr             reg
str             reg
ldi             pc
sti             pc
br/nop          x
jmp/ret         x
jsr/jsrr        pc
rti             x
trap            x

*/
    always @(*) begin
        if(!rst_i_w) begin
            alu_in_dir_o_r = `alu_in_ispc;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    alu_in_dir_o_r = `alu_in_isreg;
                end
                `INSTR_OP_ADD: begin
                    alu_in_dir_o_r = `alu_in_isreg;
                end
                `INSTR_OP_AND: begin
                    alu_in_dir_o_r = `alu_in_isreg;
                end
                `INSTR_OP_LEA: begin
                    alu_in_dir_o_r = `alu_in_ispc;
                end
                `INSTR_OP_LD: begin
                    alu_in_dir_o_r = `alu_in_ispc;
                end
                `INSTR_OP_ST: begin
                    alu_in_dir_o_r = `alu_in_ispc;
                end
                `INSTR_OP_LDR: begin
                    alu_in_dir_o_r = `alu_in_isreg;
                end
                `INSTR_OP_STR: begin
                    alu_in_dir_o_r = `alu_in_isreg;
                end
                `INSTR_OP_LDI: begin
                    alu_in_dir_o_r = `alu_in_ispc;
                end
                `INSTR_OP_STI: begin
                    alu_in_dir_o_r = `alu_in_ispc;
                end
                `INSTR_OP_BR_NOP: begin
                end
                `INSTR_OP_JMP_RET: begin
                end
                `INSTR_OP_JSR_JSRR: begin
                    alu_in_dir_o_r = `alu_in_ispc;
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        read_reg1_en_o_r
not             1
add             1
and             1
lea             0
ld              0
st              1
ldr             1
str             1
ldi             0
sti             1
br/nop          0
jmp/ret         1
jsr/jsrr        1
rti             0
trap            0
*/
    always @(*) begin
        if(!rst_i_w) begin
            read_reg1_en_o_r = 1'b0;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    read_reg1_en_o_r = 1'b1;
                end
                `INSTR_OP_ADD: begin
                    read_reg1_en_o_r = 1'b1;
                end
                `INSTR_OP_AND: begin
                    read_reg1_en_o_r = 1'b1;
                end
                `INSTR_OP_LEA: begin
                    read_reg1_en_o_r = 1'b0;
                end
                `INSTR_OP_LD: begin
                    read_reg1_en_o_r = 1'b0;
                end
                `INSTR_OP_ST: begin
                    read_reg1_en_o_r = 1'b1;
                end
                `INSTR_OP_LDR: begin
                    read_reg1_en_o_r = 1'b1;
                end
                `INSTR_OP_STR: begin
                    read_reg1_en_o_r = 1'b1;
                end
                `INSTR_OP_LDI: begin
                    read_reg1_en_o_r = 1'b0;
                end
                `INSTR_OP_STI: begin
                    read_reg1_en_o_r = 1'b1;
                end
                `INSTR_OP_BR_NOP: begin
                    read_reg1_en_o_r = 1'b0;
                end
                `INSTR_OP_JMP_RET: begin
                    read_reg1_en_o_r = 1'b1;
                end
                `INSTR_OP_JSR_JSRR: begin
                    if(instr_isoffset_w) begin
                        read_reg1_en_o_r = 1'b0;
                    end else begin
                        read_reg1_en_o_r = 1'b1;
                    end
                end
                `INSTR_OP_RTI: begin
                    read_reg1_en_o_r = 1'b0;
                end
                `INSTR_OP_TRAP: begin
                    read_reg1_en_o_r = 1'b0;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        read_reg2_en_o_r
not             0
add             reg=1,imm=0
and             reg=1,imm=0
lea             0
ld              0
st              0
ldr             0
str             1
ldi             0
sti             0
br/nop          0
jmp/ret         0
jsr/jsrr        0
rti             0
trap            0
*/
    always @(*) begin
        if(!rst_i_w) begin
            read_reg2_en_o_r = 1'b0;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_ADD: begin
                    if(instr_isimm_w == 1'b1) begin
                        read_reg2_en_o_r = 1'b0;
                    end else begin
                        read_reg2_en_o_r = 1'b1;
                    end
                end
                `INSTR_OP_AND: begin
                    if(instr_isimm_w == 1'b1) begin
                        read_reg2_en_o_r = 1'b0;
                    end else begin
                        read_reg2_en_o_r = 1'b1;
                    end
                end
                `INSTR_OP_LEA: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_LD: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_ST: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_LDR: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_STR: begin
                    read_reg2_en_o_r = 1'b1;
                end
                `INSTR_OP_LDI: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_STI: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_BR_NOP: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_JMP_RET: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_JSR_JSRR: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_RTI: begin
                    read_reg2_en_o_r = 1'b0;
                end
                `INSTR_OP_TRAP: begin
                    read_reg2_en_o_r = 1'b0;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        imm_or_reg_o_r alu的s2是imm还是reg
not             x
add             reg or imm
and             reg or imm
lea             imm
ld              imm
st              imm
ldr             imm
str             imm
ldi             imm
sti             imm
br/nop          imm
jmp/ret         x
jsr/jsrr        imm and is zero
rti             x
trap            x
*/
    always @(*) begin
        if(!rst_i_w) begin
            imm_or_reg_o_r = `s2_issimm;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                end
                `INSTR_OP_ADD: begin
                    if(instr_isimm_w == 1'b1) begin
                        imm_or_reg_o_r = `s2_issimm;
                    end else begin
                        imm_or_reg_o_r = `s2_isreg;
                    end
                end
                `INSTR_OP_AND: begin
                    if(instr_isimm_w == 1'b1) begin
                        imm_or_reg_o_r = `s2_issimm;
                    end else begin
                        imm_or_reg_o_r = `s2_isreg;
                    end
                end
                `INSTR_OP_LEA: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_LD: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_ST: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_LDR: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_STR: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_LDI: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_STI: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_BR_NOP: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_JMP_RET: begin
                end
                `INSTR_OP_JSR_JSRR: begin
                    imm_or_reg_o_r = `s2_issimm;
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr        setpc_ismem_or_imm_reg1_o_r
not             disable
add             disable
and             disable
lea             disable
ld              disable
st              disable
ldr             disable
str             disable
ldi             disable
sti             disable
br/nop          imm and is offset
jmp/ret         reg1
jsr/jsrr        imm and is offset
rti             interruptions
trap            mem and direct
*/
    always @(*) begin
        if(!rst_i_w) begin
            setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_ADD: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_AND: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_LEA: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_LD: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_ST: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_LDR: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_STR: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_LDI: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_STI: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_dis;
                end
                `INSTR_OP_BR_NOP: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_isimm;
                end
                `INSTR_OP_JMP_RET: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_isreg1;
                end
                `INSTR_OP_JSR_JSRR: begin
                    if(instr_isoffset_w) begin
                        setpc_ismem_or_imm_reg1_o_r = `setpc_isimm;
                    end else begin
                        setpc_ismem_or_imm_reg1_o_r = `setpc_isreg1;
                    end
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                    setpc_ismem_or_imm_reg1_o_r = `setpc_ismem;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end

/*

instr          setpc_o_r
not             disable
add             disable
and             disable
lea             disable
ld              disable
st              disable
ldr             disable
str             disable
ldi             disable
sti             disable
br/nop          offset
jmp/ret         direct
jsr/jsrr        offset
rti             interruptions
trap            direct
*/
    always @(*) begin
        if(!rst_i_w) begin
            setpc_o_r = `setpc_dis;
        end else begin
            if(en_i_w) begin
                case (instr_op_w)
                `INSTR_OP_NOT: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_ADD: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_AND: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_LEA: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_LD: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_ST: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_LDR: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_STR: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_LDI: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_STI: begin
                    setpc_o_r = `setpc_dis;
                end
                `INSTR_OP_BR_NOP: begin
                    if((instr_nzp_w & psr_nzp_i_w) != 0) begin
                        setpc_o_r = `setpc_offset;
                    end else begin
                        setpc_o_r = `setpc_dis;
                    end
                end
                `INSTR_OP_JMP_RET: begin
                    setpc_o_r = `setpc_direct;
                end
                `INSTR_OP_JSR_JSRR: begin
                    if(instr_isoffset_w) begin
                        setpc_o_r = `setpc_offset;
                    end else begin
                        setpc_o_r = `setpc_direct;
                    end
                end
                `INSTR_OP_RTI: begin
                end
                `INSTR_OP_TRAP: begin
                    setpc_o_r = `setpc_direct;
                end
                default:begin
                    // error 
                end
                endcase
            end
        end
    end
endmodule