



// instr -> id -> read reg(0 cycle) -> alu -> mem1 -> mem2 -> reg write back -> update pc


`define INSTR_OP_NOT        4'b1001
`define INSTR_OP_ADD        4'b0001
`define INSTR_OP_AND        4'b0101
`define INSTR_OP_LEA        4'b1110
`define INSTR_OP_LD         4'b0010
`define INSTR_OP_ST         4'b0011
`define INSTR_OP_LDR        4'b0110
`define INSTR_OP_STR        4'b0111
`define INSTR_OP_LDI        4'b1010
`define INSTR_OP_STI        4'b1011
`define INSTR_OP_BR_NOP     4'b0000
`define INSTR_OP_JMP_RET    4'b1100
`define INSTR_OP_JSR_JSRR   4'b0100
`define INSTR_OP_RTI        4'b1000
`define INSTR_OP_TRAP       4'b1111
// `define INSTR_OP_RESERVED   4'b1101

// wreg_sel_o_r
`define wreg_sel_alu    1'b0
`define wreg_sel_mem    1'b1

// mem_addr_sel_o_r
`define mem_addr_sel_alu    2'b00
`define mem_addr_sel_mem    2'b01
`define mem_addr_sel_imm    2'b10

// mem_wr_rd_o_r
`define mem_wr              1'b0
`define mem_rd              1'b1

// alu_output_dir_o_r
`define alu_output_dir_wreg         1'b0
`define alu_output_dir_memaddr      1'b1


// alu_op_o_r
`define ALU_OP_ADD      3'b000
`define ALU_OP_AND      3'b001
`define ALU_OP_NOT      3'b010

// imm_or_reg_o_r
`define s2_isreg        1'b0
`define s2_issimm       1'b1

// alu_in_dir_o_r
`define alu_in_ispc     1'b0
`define alu_in_isreg    1'b1

// setpc_ismem_or_imm_reg1_o_r
`define setpc_ismem     2'b00
`define setpc_isimm     2'b01
`define setpc_isreg1    2'b10

// setpc_o_r
`define setpc_dis       2'b00
`define setpc_offset    2'b01
`define setpc_direct    2'b10

// wr_o_r
`define mem_wr       1'b0
`define mem_rd       1'b1
