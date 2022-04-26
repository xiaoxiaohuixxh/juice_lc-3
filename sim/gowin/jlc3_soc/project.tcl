add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/alu.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/ctrl.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/id.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/mux_1to2_16b.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/mux_2to1_16b.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/mux_2to1_1b.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/mux_3to1_16b.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/pc.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/core/regs.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/rtl/peripherals/simple_uart_send.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/sim/gowin/jlc3_soc/jlc3_soc.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/sim/gowin/jlc3_soc/jlc3_top.v"
add_file -type verilog "/home/juice/prj/juicecc/lc3_verilog/juicelc3/sim/gowin/jlc3_soc/mem_ctrl.v"
add_file -type cst "/home/juice/prj/juicecc/lc3_verilog/juicelc3/sim/gowin/jlc3_soc/jlc3_soc_pin.cst"
set_device GW1NSR-LV4CQN48PC7/I6 -name GW1NSR-4C
set_option -synthesis_tool gowinsynthesis
set_option -output_base_name jlc3
set_option -top_module jlc3_top
set_option -include_path {"../../../build";"../../../rtl/ahb_lite_v3/build/"}
set_option -verilog_std v2001
set_option -vhdl_std vhd1993
set_option -dsp_balance 0
set_option -print_all_synthesis_warning 1
set_option -allow_duplicate_modules 0
set_option -multi_file_compilation_unit 1
set_option -auto_constraint_io 0
set_option -default_enum_encoding default
set_option -compiler_compatible 1
set_option -disable_io_insertion 0
set_option -fix_gated_and_generated_clocks 1
set_option -frequency Auto
set_option -looplimit 2000
set_option -maxfan 10000
set_option -pipe 1
set_option -resolve_multiple_driver 0
set_option -resource_sharing 1
set_option -retiming 0
set_option -run_prop_extract 1
set_option -rw_check_on_ram 1
set_option -supporttypedflt 0
set_option -symbolic_fsm_compiler 1
set_option -synthesis_onoff_pragma 0
set_option -update_models_cp 0
set_option -write_apr_constraint 1
set_option -gen_sdf 1
set_option -gen_io_cst 1
set_option -gen_ibis 0
set_option -gen_posp 1
set_option -gen_text_timing_rpt 1
set_option -gen_sim_netlist 1
set_option -show_init_in_vo 0
set_option -show_all_warn 1
set_option -timing_driven 1
set_option -use_scf 0
set_option -ireg_in_iob 1
set_option -oreg_in_iob 1
set_option -ioreg_in_iob 1
set_option -cst_warn_to_error 1
set_option -rpt_auto_place_io_info 0
set_option -place_option 0
set_option -route_option 0
set_option -inc 
set_option -use_jtag_as_gpio 0
set_option -use_sspi_as_gpio 0
set_option -use_mspi_as_gpio 0
set_option -use_ready_as_gpio 0
set_option -use_done_as_gpio 0
set_option -use_reconfign_as_gpio 0
set_option -use_mode_as_gpio 1
set_option -use_i2c_as_gpio 0
set_option -bit_format bin
set_option -bit_crc_check 1
set_option -bit_compress 0
set_option -bit_encrypt 0
set_option -bit_encrypt_key 00000000000000000000000000000000
set_option -bit_security 1
set_option -bit_incl_bsram_init 1
set_option -bg_programming off
set_option -i2c_slave_addr 00
set_option -secure_mode 0
set_option -loading_rate default
set_option -spi_flash_addr 00000000
set_option -program_done_bypass 0
set_option -wakeup_mode 0
set_option -user_code default
set_option -unused_pin default