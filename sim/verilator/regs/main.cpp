#include <stdlib.h>
#include "Vregs.h"
#include "verilated.h"



void test_inital_and_read(Vregs *tb,bool msg_en){
    // test inital and read regs
    for (size_t i = 0; i < 8; i++)
    {        
        tb->r_addr1_i_w = i;
        tb->r_dat1_o_r = i;
        tb->r_en1_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        tb->clk_i_w = 1; // clk pluse once
        tb->eval();
    }
    for (size_t i = 0; i < 8; i++)
    {        
        tb->r_addr1_i_w = i;
        tb->r_dat1_o_r = i;
        tb->r_en1_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        tb->clk_i_w = 1; // clk pluse once
        tb->eval();
        // printf("r_dat1_o_r %02x\n",tb->r_dat1_o_r);
        if(tb->r_dat1_o_r == 0){
            msg_en?printf("addr %02d r_dat1_o_r %02x pass\n",i,tb->r_dat1_o_r):0;
        }else{
            printf("addr %02d r_dat1_o_r %02x fail\n",i,tb->r_dat1_o_r);
            exit(-1);
        }
    }
    tb->r_en1_i_w = 0; // close port 1

    for (size_t i = 0; i < 8; i++)
    {        
        tb->r_addr2_i_w = i;
        tb->r_dat2_o_r = i;
        tb->r_en2_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        tb->clk_i_w = 1; // clk pluse once
        tb->eval();
    }
    for (size_t i = 0; i < 8; i++)
    {        
        tb->r_addr2_i_w = i;
        tb->r_dat2_o_r = i;
        tb->r_en2_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        tb->clk_i_w = 1; // clk pluse once
        tb->eval();
        // printf("r_dat2_o_r %02x\n",tb->r_dat1_o_r);
        if(tb->r_dat2_o_r == 0){
            msg_en?printf("addr %02d r_dat2_o_r %02x pass\n",i,tb->r_dat2_o_r):0;
        }else{
            printf("addr %02d r_dat2_o_r %02x fail\n",i,tb->r_dat2_o_r);
            exit(-1);
        }
    }
    tb->r_en2_i_w = 0; // close port 2
}
void test_write(Vregs *tb,bool msg_en){
    // test inital and read regs
    for (size_t i = 0; i < 8; i++)
    {        
        tb->w_addr_i_w = i;
        tb->w_dat_i_w = i;
        tb->w_en_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        tb->clk_i_w = 1; // clk pluse once
        tb->eval();
    }
    tb->w_en_i_w = 0;
    for (size_t i = 0; i < 8; i++)
    {        
        tb->r_addr1_i_w = i;
        tb->r_dat1_o_r = 0;
        tb->r_en1_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        tb->clk_i_w = 1; // clk pluse once
        tb->eval();
        // printf("r_dat1_o_r %02x\n",tb->r_dat1_o_r);
        if(tb->r_dat1_o_r == i){
            msg_en?printf("addr %02d r_dat1_o_r %02x pass\n",i,tb->r_dat1_o_r):0;
        }else{
            printf("addr %02d r_dat1_o_r %02x fail\n",i,tb->r_dat1_o_r);
            exit(-1);
        }
    }
}

void test_read_write_same_addr(Vregs *tb,bool msg_en){
    // Read and write the same address at the same time
    // clean regs
    for (size_t i = 0; i < 8; i++)
    {        
        tb->w_addr_i_w = i;
        tb->w_dat_i_w = i;
        tb->w_en_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        tb->clk_i_w = 1; // clk pluse once
        tb->eval();
    }
    tb->w_en_i_w = 0;
    for (size_t i = 0; i < 8; i++)
    {   
        tb->w_addr_i_w = i;
        tb->w_dat_i_w = i;
        tb->r_addr1_i_w = i;
        tb->r_dat1_o_r = 0;
        tb->r_en1_i_w = 1;
        tb->w_en_i_w = 1;
        tb->clk_i_w = 0;
        tb->eval();
        tb->clk_i_w = 1; // clk pluse once
        tb->eval();
        // printf("r_dat1_o_r %02x\n",tb->r_dat1_o_r);
        if(tb->r_dat1_o_r == i){
            msg_en?printf("addr %02d r_dat1_o_r %02x pass\n",i,tb->r_dat1_o_r):0;
        }else{
            printf("addr %02d r_dat1_o_r %02x fail\n",i,tb->r_dat1_o_r);
            exit(-1);
        }
    }
}
int main(int argc, char **argv) {
	// Initialize Verilators variables
	Verilated::commandArgs(argc, argv);

	// Create an instance of our module under test
	Vregs *tb = new Vregs;
    bool msg_en = false;
	// Tick the clock until we are done
	while(!Verilated::gotFinish()) {
    // input   wire                                clk_i_w, 
    // input   wire                                rst_i_w,

    // input wire                                  r_en1_i_w,
    // input wire [`INSTR_REG_ADDR_WIDTH]          r_addr1_i_w,
    // output reg [RegWidth-1:0]                   r_dat1_o_r,

    // input wire                                  r_en2_i_w,
    // input wire [`INSTR_REG_ADDR_WIDTH]          r_addr2_i_w,
    // output reg [RegWidth-1:0]                   r_dat2_o_r,

    // input wire                                  w_en_i_w,
    // input wire [`INSTR_REG_ADDR_WIDTH]          w_addr_i_w,
    // input wire [RegWidth-1:0]                   w_dat_i_w
		tb->rst_i_w = 0;
        tb->eval();
        tb->rst_i_w = 1;
        tb->eval();
		tb->clk_i_w = 1;
		tb->eval();
        printf("---%s-----------------------------------------\r\n","test_inital_and_read");
        test_inital_and_read(tb,msg_en);
        printf("---%s-----------------------------------------\r\n","test_inital_and_read pass");
        printf("---%s-----------------------------------------\r\n","test_write");
        test_write(tb,msg_en);
        printf("---%s-----------------------------------------\r\n","test_write pass");
        printf("---%s-----------------------------------------\r\n","test_read_write_same_addr");
        test_read_write_same_addr(tb,msg_en);
        printf("---%s-----------------------------------------\r\n","test_read_write_same_addr pass");
        tb->w_en_i_w = 0; // must be reset write enable flag
        tb->rst_i_w = 0;
        tb->eval();
        tb->rst_i_w = 1;
        tb->eval();
        printf("---%s-----------------------------------------\r\n","test clean regs for rst");
        for (size_t i = 0; i < 8; i++)
        {        
            tb->r_addr1_i_w = i;
            tb->r_dat1_o_r = 0;
            tb->r_en1_i_w = 1;
            tb->clk_i_w = 0;
            tb->eval();
            tb->clk_i_w = 1; // clk pluse once
            tb->eval();
            // printf("r_dat1_o_r %02x\n",tb->r_dat1_o_r);
            if(tb->r_dat1_o_r == 0){
                msg_en?printf("addr %02d r_dat1_o_r %02x pass\n",i,tb->r_dat1_o_r):0;
            }else{
                printf("addr %02d r_dat1_o_r %02x fail\n",i,tb->r_dat1_o_r);
                exit(-1);
            }
        }
        printf("---%s-----------------------------------------\r\n","test clean regs for rst pass");
        
		tb->clk_i_w = 0;
        exit(0);
	} exit(EXIT_SUCCESS);
}

