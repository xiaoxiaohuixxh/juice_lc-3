.PHONY:all $(JUICERV_TEST) run

VERILATOR ?=verilator

VERILATOR_ROOT=/usr/bin/

MOD_NAME := jlc3_soc

JUICERV_TEST := ./jlc3_soc.v
JUICERV_TEST += ./mem_ctrl.v
JUICERV_TEST += ../../../rtl/core/pc.v
JUICERV_TEST += ../../../rtl/core/id.v
JUICERV_TEST += ../../../rtl/core/alu.v
JUICERV_TEST += ../../../rtl/core/regs.v
JUICERV_TEST += ../../../rtl/core/ctrl.v
JUICERV_TEST += ../../../rtl/core/mux_1to2_16b.v
JUICERV_TEST += ../../../rtl/core/mux_2to1_16b.v
JUICERV_TEST += ../../../rtl/core/mux_3to1_16b.v
JUICERV_TEST += ../../../rtl/peripherals/simple_uart_send.v

CPP_SRC := main.cpp
# clean:

all: $(JUICERV_TEST)
# $(VERILATOR) +incdir+../../../rtl/core/ --debug --trace-fst -Wall --cc $^ --exe $(CPP_SRC)
# $(VERILATOR) +incdir+../../../rtl/core/ --debug --trace -Wall --cc $^ --exe $(CPP_SRC)
	$(VERILATOR) +incdir+../../../rtl/peripherals +incdir+../../../rtl/core/  --top-module $(MOD_NAME) --trace -Wall --cc $^ --exe $(CPP_SRC)
	make -C obj_dir -f V$(MOD_NAME).mk V$(MOD_NAME)

packrom:
#	../../../../tools/lc3-master/lc3tools/lc3as ./rom/lc3.asm
	../../../../tools/LC-3_Assembler/nglc3asm ./rom/lc3.asm
	echo '\n' >> ./rom/lc3.bin
# ../../../../tools/lc3-master/lc3tools/lc3convert -b16 ./rom/lc3.bin

run: | packrom all
	./obj_dir/V$(MOD_NAME)


runo:
	./obj_dir/V$(MOD_NAME)

wv:
	gtkwave ./vlt_dump.vcd

clean:
	rm -rf obj_dir rom/*.dbg rom/*.lst rom/*.obj rom/*.sym rom/*.vconst  