`include "def.v"
module jlc3_soc(
     input wire rst_i_w
    ,input wire clk_i_w
    ,input wire en_i_w
    ,output wire    txd_i_w
);

    wire[15:0] jlc3_instr_w;
    wire[15:0] jlc3_pc_w;

    wire        jlc3_wreg_en_w;
    wire        jlc3_wreg_sel_w; // mem_rdat or alu_output
    wire        jlc3_mem_en_w;
    wire[1:0]   jlc3_mem_addr_sel_w;  // mem_rdat or alu_output or imm
    wire        jlc3_mem_wr_rd_w;
    wire        jlc3_mem_wr_rd_frommux_w;
    wire        jlc3_mem2_en_w;
    wire[1:0]   jlc3_mem2_addr_sel_w;  // mem_rdat or alu_output or imm
    wire        jlc3_mem2_wr_rd_w;
    wire        jlc3_alu_output_dir_w; // alu to mem_addr or reg
    wire        jlc3_alu_en_w;
    wire        jlc3_alu_en_fromctrl_w;
    wire[2:0]   jlc3_alu_op_w;
    wire        jlc3_alu_in_dir_w;  // pc or reg
    wire        jlc3_read_reg1_en_w;
    wire        jlc3_read_reg2_en_w;
    wire[2:0]   jlc3_dst_reg_addr_w;
    wire[2:0]   jlc3_read_reg1_addr_w;
    wire[2:0]   jlc3_read_reg2_addr_w;
    wire        jlc3_imm_or_reg_w;
    wire[15:0]  jlc3_simm_w;
    wire[1:0]   jlc3_setpc_ismem_or_imm_reg1_w; // mem_rdat or imm or reg1
    wire[2:0]   jlc3_psr_nzp_w;
    wire[1:0]   jlc3_setpc_w;  // disable , direct set pc or offset

    wire[15:0]  jlc3_rreg1_dat_w;
    wire[15:0]  jlc3_rreg2_dat_w;

    wire[15:0] jlc3_setpc_addr_w;
    
    wire[15:0] jlc3_mem_rdat_w;

    wire[15:0] jlc3_alu_s2_w;
    wire[15:0] jlc3_alu_s1_w;
    
    // wire[2:0] jlc3_alu_op_fromctrl_w;

    wire[1:0]   jlc3_mem_addr_sel_fromctrl_w;  // mem_rdat or alu_output or imm

    wire[15:0] jlc3_mem_addr_w;
    wire[15:0] jlc3_alu_out_w;
    wire jlc3_pc_en_fromctrl_w;
    wire jlc3_instr_en_fromctrl_w;
    wire jlc3_id_en_fromctrl_w;
    wire jlc3_mem_en_fromctrl_w;
    wire[15:0] jlc3_pc_addr_fromctrl_w;
    wire jlc3_jmp_fromctrl_w;
    wire jlc3_wreg_en_fromctrl_w;

    wire jlc3_mem_wr_rd_fromctrl_w;
    // wire jlc3_alu_output_dir_fromctrl_w;

    wire[15:0] jlc3_wdat_w;
    
    wire [15:0] jlc3_alu_out_selmem_w;
    wire [15:0] jlc3_alu_out_selwreg_w;


    wire            uart0_send_w;
    wire[7:0]       uart0_schar_w;
    wire[1:0]       uart0_sta_w;

    wire jlc_instr_mem_sel_w;
    wire[15:0] jlc_instr_mem_addrsel_w;
    wire[15:0] jlc_instr_mem_datsel_w;
    pc jlc3_pc (
         .clk_i_w(clk_i_w)
        ,.rst_i_w(rst_i_w)
        ,.en_i_w(jlc3_pc_en_fromctrl_w)
        ,.jmp_i_w(jlc3_jmp_fromctrl_w)
        ,.pc_addr_i_w(jlc3_pc_addr_fromctrl_w)
        ,.pc_o_r(jlc3_pc_w)
    );

    // instr jlc3_instr (
    //      .clk_i_w(clk_i_w)
    //     ,.rst_i_w(rst_i_w)
    //     ,.en_i_w(jlc3_instr_en_fromctrl_w)
    //     ,.pc_i_w(jlc3_pc_w)
    //     ,.instr_o_r(jlc3_instr_w)
    // );

    id jlc3_id (
        //  .clk_i_w(clk_i_w)
        // ,
        .rst_i_w(rst_i_w)
        ,.en_i_w(jlc3_id_en_fromctrl_w)
        ,.instr_i_w(jlc3_instr_w)
        ,.wreg_en_o_r(jlc3_wreg_en_w)
        ,.wreg_sel_o_r(jlc3_wreg_sel_w) // mem_rdat or alu_output
        ,.mem_en_o_r(jlc3_mem_en_w)
        ,.mem_addr_sel_o_r(jlc3_mem_addr_sel_w)  // mem_rdat or alu_output or imm
        ,.mem_wr_rd_o_r(jlc3_mem_wr_rd_w)
        ,.mem2_en_o_r(jlc3_mem2_en_w)
        ,.mem2_addr_sel_o_r(jlc3_mem2_addr_sel_w)  // mem_rdat or alu_output or imm
        ,.mem2_wr_rd_o_r(jlc3_mem2_wr_rd_w)
        ,.alu_output_dir_o_r(jlc3_alu_output_dir_w) // alu to mem_addr or reg
        ,.alu_en_o_r(jlc3_alu_en_w)
        ,.alu_op_o_r(jlc3_alu_op_w)
        ,.alu_in_dir_o_r(jlc3_alu_in_dir_w)  // pc or reg
        ,.read_reg1_en_o_r(jlc3_read_reg1_en_w)
        ,.read_reg2_en_o_r(jlc3_read_reg2_en_w)
        ,.dst_reg_addr_o_r(jlc3_dst_reg_addr_w)
        ,.read_reg1_addr_o_r(jlc3_read_reg1_addr_w)
        ,.read_reg2_addr_o_r(jlc3_read_reg2_addr_w)
        ,.imm_or_reg_o_r(jlc3_imm_or_reg_w)
        ,.simm_o_r(jlc3_simm_w)
        ,.setpc_ismem_or_imm_reg1_o_r(jlc3_setpc_ismem_or_imm_reg1_w) // mem_rdat or imm or reg1
        ,.psr_nzp_i_w(jlc3_psr_nzp_w)
        ,.setpc_o_r(jlc3_setpc_w)  // disable , direct set pc or offset
    );
    regs jlc3_reg(
         .clk_i_w(clk_i_w)
        ,.rst_i_w(rst_i_w)
        ,.r_en1_i_w(jlc3_read_reg1_en_w)
        ,.r_addr1_i_w(jlc3_read_reg1_addr_w)
        ,.r_dat1_o_r(jlc3_rreg1_dat_w)
        ,.r_en2_i_w(jlc3_read_reg2_en_w)
        ,.r_addr2_i_w(jlc3_read_reg2_addr_w)
        ,.r_dat2_o_r(jlc3_rreg2_dat_w)
        ,.w_en_i_w(jlc3_wreg_en_fromctrl_w)
        ,.w_addr_i_w(jlc3_dst_reg_addr_w)
        ,.w_dat_i_w(jlc3_wdat_w)
        ,.psr_nzp_o_r(jlc3_psr_nzp_w)
    );

    mux_3to1_16b jlc3_memaddr_mux_3to1(
         .sel(jlc3_mem_addr_sel_fromctrl_w)
        ,.in1(jlc3_alu_out_selmem_w) // alu
        ,.in2(jlc3_mem_rdat_w) // mem
        ,.in3(jlc3_simm_w) // imm
        ,.out(jlc3_mem_addr_w)
    );

    mux_3to1_16b jlc3_pcaddr_mux_3to1(
         .sel(jlc3_setpc_ismem_or_imm_reg1_w)
        ,.in1(jlc3_mem_rdat_w)
        ,.in2(jlc3_simm_w)
        ,.in3(jlc3_rreg1_dat_w)
        ,.out(jlc3_setpc_addr_w)
    );
    // mux_1to2_16b jlc3_alu_out_dir_mux_1to2(
    //      .sel(jlc3_alu_output_dir_w)
    //     ,.in(jlc3_alu_out_w)
    //     ,.out1(jlc3_alu_out_selwreg_w) // wreg
    //     ,.out2(jlc3_alu_out_selmem_w) // memaddr
    // );

    reg[15:0] jlc3_alu_out_selmem_r;
    reg[15:0] jlc3_alu_out_selwreg_r;
    assign jlc3_alu_out_selmem_w = jlc3_alu_out_selmem_r;
    assign jlc3_alu_out_selwreg_w = jlc3_alu_out_selwreg_r;
    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            jlc3_alu_out_selmem_r <= 16'b0;
            jlc3_alu_out_selwreg_r <= 16'b0;
        end else begin
            if(jlc3_alu_output_dir_w) begin
                jlc3_alu_out_selmem_r <= jlc3_alu_out_w;
            end else begin
                jlc3_alu_out_selwreg_r <= jlc3_alu_out_w;
            end
        end
    end

    mux_2to1_16b jlc3_alus2_mux_2to1(
         .sel(jlc3_imm_or_reg_w)
        ,.in1(jlc3_rreg2_dat_w)
        ,.in2(jlc3_simm_w)
        ,.out(jlc3_alu_s2_w)
    );

    mux_2to1_16b jlc3_wreg_dat_mux_2to1(
         .sel(jlc3_wreg_sel_w)
        ,.in1(jlc3_alu_out_selwreg_w) // alu
        ,.in2(jlc3_mem_rdat_w) // mem
        ,.out(jlc3_wdat_w)
    );

    mux_2to1_16b jlc3_pc_or_reg1_mux_2to1 (
         .sel(jlc3_alu_in_dir_w)
        ,.in1(jlc3_pc_w) // pc
        ,.in2(jlc3_rreg1_dat_w) // reg1
        ,.out(jlc3_alu_s1_w)
    );

    alu jlc3_alu(
        //  .clk_i_w(clk_i_w)
        // ,
        .rst_i_w(rst_i_w)
        ,.en_i_w(jlc3_alu_en_fromctrl_w)
        ,.op_i_w(jlc3_alu_op_w)
        ,.s1_i_w(jlc3_alu_s1_w)
        ,.s2_i_w(jlc3_alu_s2_w)
        ,.out_o_r(jlc3_alu_out_w)
    );

    mux_2to1_1b jlc3_instr_mem_mux_2to1(
         .sel(jlc3_instr_en_fromctrl_w)
        ,.in1(jlc3_mem_en_fromctrl_w)
        ,.in2(jlc3_instr_en_fromctrl_w)
        ,.out(jlc_instr_mem_sel_w)
    );
    reg jlc3_mem_wr_rd_fromctrl_read_r;
    // wire jlc3_mem_wr_rd_fromctrl_w;
    always @(negedge rst_i_w) begin
        if(!rst_i_w) begin
            jlc3_mem_wr_rd_fromctrl_read_r <= `mem_rd;
        end else begin
        end
    end
    mux_2to1_1b jlc3_instr_mem_dirsel_mux_2to1(
         .sel(jlc3_instr_en_fromctrl_w)
        ,.in1(jlc3_mem_wr_rd_fromctrl_w)
        ,.in2(jlc3_mem_wr_rd_fromctrl_read_r)
        ,.out(jlc3_mem_wr_rd_frommux_w)
    );

    mux_2to1_16b jlc3_instr_mem_addr_mux_2to1(
         .sel(jlc3_instr_en_fromctrl_w)
        ,.in1(jlc3_mem_addr_w)
        ,.in2(jlc3_pc_w)
        ,.out(jlc_instr_mem_addrsel_w)
    );
    
    // mux_1to2_16b jlc3_instr_mem_dat_mux_1to2(
    //      .sel(jlc3_instr_en_fromctrl_w)
    //     ,.in(jlc_instr_mem_datsel_w)
    //     ,.out1(jlc3_mem_rdat_w)
    //     ,.out2(jlc3_instr_w)
    // );
    reg[15:0] jlc_instr_mem_instr_r;
    reg[15:0] jlc_instr_mem_dat_r;
    assign jlc3_mem_rdat_w = jlc_instr_mem_dat_r;
    assign jlc3_instr_w = jlc_instr_mem_instr_r;
    always @(posedge clk_i_w or negedge rst_i_w) begin
        if(!rst_i_w) begin
            jlc_instr_mem_instr_r <= 16'b0;
            jlc_instr_mem_dat_r <= 16'b0;
        end else begin
            if(jlc3_instr_en_fromctrl_w) begin
                jlc_instr_mem_instr_r <= jlc_instr_mem_datsel_w;
            end else if(jlc_instr_mem_sel_w) begin
                jlc_instr_mem_dat_r <= jlc_instr_mem_datsel_w;
            end
        end
    end

    mem_ctrl jlc3_mem(
         .clk_i_w(clk_i_w)
        ,.rst_i_w(rst_i_w)
        ,.en_i_w(jlc_instr_mem_sel_w)
        ,.addr_i_w(jlc_instr_mem_addrsel_w)
        ,.wr_i_w(jlc3_mem_wr_rd_frommux_w)
        ,.wdat_i_w(jlc3_rreg2_dat_w)
        ,.rdat_o_r(jlc_instr_mem_datsel_w)
        ,.send_o_r(uart0_send_w)
        ,.schar_o_r(uart0_schar_w)
        ,.sta_i_w(uart0_sta_w)
    );
    ctrl jlc3_ctrl(
         .clk_i_w(clk_i_w)
        ,.rst_i_w(rst_i_w)
        ,.en_i_w(en_i_w)
        ,.pc_i_w(jlc3_pc_w)
        ,.wreg_en_i_w(jlc3_wreg_en_w)
        ,.mem_en_i_w(jlc3_mem_en_w)
        ,.mem_addr_sel_i_w(jlc3_mem_addr_sel_w)  // mem_rdat or alu_output or imm
        ,.mem_wr_rd_i_w(jlc3_mem_wr_rd_w)
        ,.mem2_en_i_w(jlc3_mem2_en_w)
        ,.mem2_addr_sel_i_w(jlc3_mem2_addr_sel_w)  // mem_rdat or alu_output or imm
        ,.mem2_wr_rd_i_w(jlc3_mem2_wr_rd_w)
        ,.alu_en_i_w(jlc3_alu_en_w)
        // ,.simm_i_w(jlc3_simm_w)
        ,.setpc_i_w(jlc3_setpc_w)  // disable , direct set pc or offset
        ,.setpc_addr_i_w(jlc3_setpc_addr_w)
        ,.pc_en_o_r(jlc3_pc_en_fromctrl_w)
        ,.instr_en_o_r(jlc3_instr_en_fromctrl_w)
        ,.id_en_o_r(jlc3_id_en_fromctrl_w)
        ,.alu_en_o_r(jlc3_alu_en_fromctrl_w)
        ,.mem_en_o_r(jlc3_mem_en_fromctrl_w)
        ,.pc_addr_o_r(jlc3_pc_addr_fromctrl_w)
        ,.pc_jmp_o_r(jlc3_jmp_fromctrl_w)
        ,.mem_addr_sel_o_r(jlc3_mem_addr_sel_fromctrl_w)  // mem_rdat or alu_output or imm
        ,.mem_wr_rd_o_r(jlc3_mem_wr_rd_fromctrl_w)
        ,.wreg_en_o_r(jlc3_wreg_en_fromctrl_w)
        // ,.alu_output_dir_o_r(jlc3_alu_output_dir_fromctrl_w)
        // ,.alu_op_o_r(jlc3_alu_op_fromctrl_w)
    );


    simple_uart_send m_simple_uart_send(
         .rst_i_w(rst_i_w)
        ,.clk_i_w(clk_i_w)
        ,.en_i_w(en_i_w)
        ,.send_i_w(uart0_send_w)
        ,.schar_i_w(uart0_schar_w)
        ,.sta_o_r(uart0_sta_w)
        ,.txd_o_r(txd_i_w)
    );


endmodule