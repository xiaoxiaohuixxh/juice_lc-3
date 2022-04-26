.PHONY:all $(JUICERV_TEST) run

VERILATOR ?=verilator

VERILATOR_ROOT=/usr/bin/

MOD_NAME := dff_tb

JUICERV_TEST := ./dff_tb.v
JUICERV_TEST += ../../../rtl/core/pc.v

CPP_SRC := main.cpp
# clean:

all: $(JUICERV_TEST)
	$(VERILATOR) +incdir+../../../rtl/utils/  --top-module $(MOD_NAME) --trace -Wall --cc $^ --exe $(CPP_SRC)
	make -C obj_dir -f V$(MOD_NAME).mk V$(MOD_NAME)

run: all
	./obj_dir/V$(MOD_NAME)

wv:
	gtkwave ./vlt_dump.vcd

clean:
	rm -rf obj_dir