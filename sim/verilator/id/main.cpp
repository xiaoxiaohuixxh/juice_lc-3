#include <stdlib.h>
#include "Vid.h"
#include "verilated.h"
#include <verilated_vcd_c.h>	// Trace file format header
#include <verilated_fst_c.h>	// Trace file format header


#define  PACK_3bit(a,b,c)  ( ((a)<<2) | ((b)<<1) | (c) )
#define  PACK_4bit(a,b,c,d)  ( ((a)<<3) | ((b)<<2) | ((c)<<1) | (d) )
#define  PACK_6bit(a,b,c,d,e,f)  ( ((a)<<5) | ((a)<<4) | ((c)<<3) | ((d)<<2) | ((e)<<1) | (f) )

vluint64_t main_time = 0;	// Current simulation time (64-bit unsigned)
void test_not_instr(Vid *tb,VerilatedVcdC* tfp,bool msg_en){
    // NOT test
    tb->en_i_w = 1;
    tb->rst_i_w = 1;
    tb->clk_i_w = 0;
    tb->instr_i_w = (PACK_4bit(1,0,0,1) << 12 ) | (PACK_3bit(1,0,1) << 9 ) | (PACK_3bit(0,1,0) << 6 ) | (PACK_6bit(1,1,1,1,1,1)); // NOT
    tb->eval();
    main_time++;
    if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

    tb->clk_i_w = 1;
    tb->eval();
    main_time++;
    if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp


    tb->clk_i_w = 0;
    tb->eval();

    if(tb->wreg_en_o_r != 1){
        printf("---%s---tb->wreg_en_o_r=%d--------------------------------------\r\n","NOT test fail",tb->wreg_en_o_r);
    }else{
        // tb->eval();
        printf("---%s-----------------------------------------\r\n","test id pass");
    }

    main_time++;
    if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp
}

int main(int argc, char **argv) {
	// Initialize Verilators variables
	Verilated::commandArgs(argc, argv);
    Verilated::debug(0);

	// Create an instance of our module under test
	Vid *tb = new Vid;
    Verilated::traceEverOn(true);	// Verilator must compute traced signals
    VL_PRINTF("Enabling waves...\n");
    VerilatedVcdC* tfp = new VerilatedVcdC;
    // VerilatedFstC* tfp = new VerilatedFstC;
    tb->trace(tfp, 99);	// Trace 99 levels of hierarchy
    tfp->open("vlt_dump.vcd");	// Open the dump file
    bool msg_en = false;
	// Tick the clock until we are done
	while(!Verilated::gotFinish()) {
        // module id (
        //      input   wire           clk_i_w
        //     ,input   wire           rst_i_w

        //     ,input wire             en_i_w
        //     ,input wire[15:0]       instr_i_w

        //     ,output reg             wreg_en_o_r
        //     ,output reg             wreg_sel_o_r // mem_rdat or alu_output

        //     ,output reg             mem_en_o_r
        //     ,output reg[1:0]        mem_addr_sel_o_r  // mem_rdat or alu_output or imm

        //     ,output reg             mem_wr_rd_o_r

            
        //     ,output reg             mem2_en_o_r
        //     ,output reg[1:0]        mem2_addr_sel_o_r  // mem_rdat or alu_output or imm

        //     ,output reg             mem2_wr_rd_o_r

        //     ,output reg             alu_output_dir_o_r // alu to mem_addr or reg

        //     ,output reg             alu_en_o_r
        //     ,output reg[2:0]        alu_op_o_r

        //     ,output reg             alu_in_dir_o_r  // pc or reg

        //     ,output reg             read_reg1_en_o_r
        //     ,output reg             read_reg2_en_o_r

        //     ,output reg[2:0]        read_reg1_addr_o_r
        //     ,output reg[2:0]        read_reg2_addr_o_r

        //     ,output reg             imm_or_reg_o_r
        //     ,output reg[15:0]       simm_o_r
        //     ,output reg[1:0]        setpc_ismem_or_imm_reg1_o_r // mem_rdat or imm or reg1


        //     ,input wire[2:0]        psr_nzp_i_w

        //     ,output reg[1:0]        setpc_o_r  // disable , direct set pc or offset
        // );
		// tb->instr_i_w = 

        tb->rst_i_w = 1;
        tb->clk_i_w = 1;
        tb->en_i_w = 0;
		tb->eval();
        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

        tb->rst_i_w = 0;
		tb->eval();
        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

        test_not_instr(tb,tfp,msg_en);

        tb->final();

        if (tfp) tfp->close();
		// tb->clk_i_w = 0;
        exit(0);
	} exit(EXIT_SUCCESS);
}

