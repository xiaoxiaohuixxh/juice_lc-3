#include <stdlib.h>
#include <iostream>
#include <string>


#include "Vjlc3_soc.h"


#include "verilated.h"
#include <verilated_vcd_c.h>	// Trace file format header
#include <verilated_fst_c.h>	// Trace file format header

// #define  PACK_3bit(a,b,c)  ( ((a)<<2) | ((b)<<1) | (c) )
// #define  PACK_4bit(a,b,c,d)  ( ((a)<<3) | ((b)<<2) | ((c)<<1) | (d) )
// #define  PACK_6bit(a,b,c,d,e,f)  ( ((a)<<5) | ((a)<<4) | ((c)<<3) | ((d)<<2) | ((e)<<1) | (f) )
// #define  PACK_9bit(a,b,c,d,e,f,g,h)  ( ((a)<<5) | ((a)<<4) | ((c)<<3) | ((d)<<2) | ((e)<<1) | (f) )

vluint64_t main_time = 0;	// Current simulation time (64-bit unsigned)
#define RUN_TIMES    2000
vluint64_t run_count = 0;

// int jlc3_mem_ctrl_write(int addr,int dat){

//     VL_PRINTF("mem_write addr 0x%x(%d) 0x%x(%d)\n",addr,addr,dat,dat);
// }

// int jlc3_mem_ctrl_read(int addr){

//     VL_PRINTF("mem_write addr 0x%x(%d) 0x%x(%d)\n",addr,addr,dat,dat);
// }

int main(int argc, char **argv) {
	// Initialize Verilators variables
	Verilated::commandArgs(argc, argv);
    Verilated::debug(0);

	// Create an instance of our module under test
	Vjlc3_soc *tb = new Vjlc3_soc;
    Verilated::traceEverOn(true);	// Verilator must compute traced signals
    VL_PRINTF("Enabling waves...\n");
    VerilatedVcdC* tfp = new VerilatedVcdC;
    // VerilatedFstC* tfp = new VerilatedFstC;
    tb->trace(tfp, 0);	// Trace 99 levels of hierarchy
    tfp->open("vlt_dump.vcd");	// Open the dump file
    bool msg_en = false;
	// Tick the clock until we are done
	while(!Verilated::gotFinish()) {
        // module jlc3_soc(
        //     input wire rst_i_w
        //     ,input wire clk_i_w
        //     ,input wire en_i_w
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

        // tb->jlc3_soc__DOT__jlc3_soc_instr__DOT__rom_r[1] = 
        tb->en_i_w = 1;
        tb->rst_i_w = 1;
        while(run_count++ < RUN_TIMES){
            // printf("------step-%d----------\r\n",run_count);
            tb->clk_i_w = 0;
            // tb->instr_i_w = (PACK_4bit(1,0,0,1) << 12 ) | (PACK_3bit(1,0,1) << 9 ) | (PACK_3bit(0,1,0) << 6 ) | (PACK_6bit(1,1,1,1,1,1)); // NOT
            tb->eval();
            main_time++;
            if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

            tb->clk_i_w = 1;
            tb->eval();
            main_time++;
            if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp
            
            // printf("------pc-%x----------\r\n",tb->jlc3_soc__DOT__jlc3_soc_pc_w);
        }
        tb->clk_i_w = 0;
        tb->eval();
        // tb->eval();
        printf("---%s-----------------------------------------\r\n","test jlc3_soc pass");

        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

        tb->final();

        if (tfp) tfp->close();
		// tb->clk_i_w = 0;
        exit(0);
	} exit(EXIT_SUCCESS);
}

