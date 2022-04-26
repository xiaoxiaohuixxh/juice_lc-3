.PHONY:all $(JUICERV_TEST) run

VERILATOR ?=verilator

VERILATOR_ROOT=/usr/bin/

MOD_NAME := jlc3

JUICERV_TEST := ../../../rtl/core/jlc3.v
JUICERV_TEST += ../../../rtl/core/pc.v
JUICERV_TEST += ../../../rtl/core/id.v
JUICERV_TEST += ../../../rtl/core/alu.v
JUICERV_TEST += ../../../rtl/core/regs.v
JUICERV_TEST += ../../../rtl/core/ctrl.v
JUICERV_TEST += ../../../rtl/core/instr.v
JUICERV_TEST += ../../../rtl/core/mem.v
JUICERV_TEST += ../../../rtl/core/mux_1to2_16b.v
JUICERV_TEST += ../../../rtl/core/mux_2to1_16b.v
JUICERV_TEST += ../../../rtl/core/mux_3to1_16b.v

CPP_SRC := main.cpp
# clean:

all: $(JUICERV_TEST)
# $(VERILATOR) +incdir+../../../rtl/core/ --debug --trace-fst -Wall --cc $^ --exe $(CPP_SRC)
# $(VERILATOR) +incdir+../../../rtl/core/ --debug --trace -Wall --cc $^ --exe $(CPP_SRC)
	$(VERILATOR) +incdir+../../../rtl/core/  --top-module $(MOD_NAME) --trace -Wall --cc $^ --exe $(CPP_SRC)
	make -C obj_dir -f V$(MOD_NAME).mk V$(MOD_NAME)

run: all
	./obj_dir/V$(MOD_NAME)

clean:
	rm -rf obj_dir