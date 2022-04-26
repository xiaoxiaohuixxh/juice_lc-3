.PHONY:all $(JUICERV_TEST) run

VERILATOR ?=verilator

VERILATOR_ROOT=/usr/bin/

MOD_NAME := simple_uart_send

JUICERV_TEST := ../../../rtl/peripherals/simple_uart_send.v

CPP_SRC := main.cpp
# clean:

all: $(JUICERV_TEST)
# $(VERILATOR) +incdir+../../../rtl/core/ --debug --trace-fst -Wall --cc $^ --exe $(CPP_SRC)
# $(VERILATOR) +incdir+../../../rtl/core/ --debug --trace -Wall --cc $^ --exe $(CPP_SRC)
	$(VERILATOR) +incdir+../../../rtl/peripherals --top-module $(MOD_NAME) --trace -Wall --cc $^ --exe $(CPP_SRC)
	make -C obj_dir -f V$(MOD_NAME).mk V$(MOD_NAME)


run: all
	./obj_dir/V$(MOD_NAME)

wv:
	gtkwave ./vlt_dump.vcd

clean:
	rm -rf obj_dir vlt_dump.vcd