#include <stdlib.h>
#include <iostream>
#include <string>


#include "Vsimple_uart_send.h"


#include "verilated.h"
#include <verilated_vcd_c.h>	// Trace file format header
#include <verilated_fst_c.h>	// Trace file format header

// #define  PACK_3bit(a,b,c)  ( ((a)<<2) | ((b)<<1) | (c) )
// #define  PACK_4bit(a,b,c,d)  ( ((a)<<3) | ((b)<<2) | ((c)<<1) | (d) )
// #define  PACK_6bit(a,b,c,d,e,f)  ( ((a)<<5) | ((a)<<4) | ((c)<<3) | ((d)<<2) | ((e)<<1) | (f) )
// #define  PACK_9bit(a,b,c,d,e,f,g,h)  ( ((a)<<5) | ((a)<<4) | ((c)<<3) | ((d)<<2) | ((e)<<1) | (f) )

vluint64_t main_time = 0;	// Current simulation time (64-bit unsigned)
#define RUN_TIMES    100
vluint64_t run_count = 0;

// module simple_uart_send(
//      input  wire        rst_i_w
//     ,input  wire        clk_i_w
//     ,input  wire        en_i_w
//     ,input  wire        send_i_w
//     ,input  wire[7:0]   schar_i_w
//     ,output reg[1:0]    sta_o_r
//     ,output reg         txd_o_r
// );

int main(int argc, char **argv) {
	// Initialize Verilators variables
	Verilated::commandArgs(argc, argv);
    Verilated::debug(0);

	// Create an instance of our module under test
	Vsimple_uart_send *tb = new Vsimple_uart_send;
    Verilated::traceEverOn(true);	// Verilator must compute traced signals
    VL_PRINTF("Enabling waves...\n");
    VerilatedVcdC* tfp = new VerilatedVcdC;
    // VerilatedFstC* tfp = new VerilatedFstC;
    tb->trace(tfp, 0);	// Trace 99 levels of hierarchy
    tfp->open("vlt_dump.vcd");	// Open the dump file
    bool msg_en = false;
	// Tick the clock until we are done
	while(!Verilated::gotFinish()) {

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

        // tb->simple_uart_send__DOT__simple_uart_send_instr__DOT__rom_r[1] = 
        tb->en_i_w = 1;
        tb->rst_i_w = 1;
        tb->schar_i_w = 0x55;
        
        tb->send_i_w = 0;
        tb->clk_i_w = 0;
        tb->eval();
        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp
        tb->clk_i_w = 1;
        tb->eval();
        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

        tb->send_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp
        tb->clk_i_w = 1;
        tb->eval();
        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

        tb->send_i_w = 0;
        tb->clk_i_w = 0;
        tb->eval();
        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp
        tb->clk_i_w = 1;
        tb->eval();
        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

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
            
            // printf("------pc-%x----------\r\n",tb->simple_uart_send__DOT__simple_uart_send_pc_w);
        }
        tb->clk_i_w = 0;
        tb->eval();
        // tb->eval();
        printf("---%s-----------------------------------------\r\n","test simple_uart_send pass");

        main_time++;
        if (tfp) tfp->dump(main_time);	// Create waveform trace for this timestamp

        tb->final();

        if (tfp) tfp->close();
		// tb->clk_i_w = 0;
        exit(0);
	} exit(EXIT_SUCCESS);
}

