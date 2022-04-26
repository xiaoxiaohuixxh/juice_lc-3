
set_device GW1NSR-LV4CQN48PC7/I6 -name GW1NSR-4C

add_file -type cst ./jlc3_soc_pin.cst


add_file -type verilog mem_ctrl.v
add_file -type verilog ../../../rtl/core/pc.v
add_file -type verilog ../../../rtl/core/id.v
add_file -type verilog ../../../rtl/core/alu.v
add_file -type verilog ../../../rtl/core/regs.v
add_file -type verilog ../../../rtl/core/ctrl.v
add_file -type verilog ../../../rtl/core/mux_1to2_16b.v
add_file -type verilog ../../../rtl/peripherals/simple_uart_send.v
add_file -type verilog ../../../rtl/core/mux_3to1_16b.v
add_file -type verilog ../../../rtl/core/mux_2to1_16b.v
add_file -type verilog ../../../rtl/core/mux_2to1_1b.v
add_file -type verilog jlc3_soc.v
add_file -type verilog jlc3_top.v

set_option -output_base_name jlc3
set_option -top_module  jlc3_top
set_option -include_path {../../../build;../../../rtl/ahb_lite_v3/build/}

set_option -verilog_std v2001

set_option -print_all_synthesis_warning 1
set_option -show_all_warn 1
set_option -cst_warn_to_error 1
set_option -gen_text_timing_rpt 1       # 文本格式的时序报告
set_option -gen_sim_netlist 1           # 时序仿真模型文件
set_option -gen_posp 1                  # 器件布局文件
set_option -gen_io_cst 1                # port 端口的物理约束文件
set_option -gen_sdf 1                   # 产生 SDF 文件
set_option -use_mode_as_gpio 1          # led 引脚是mode脚

saveto -all_options project.tcl

run syn
run pnr
run all