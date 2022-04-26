.PHONY:all $(JUICERV_TEST) run

VERILATOR ?=verilator

MOD_NAME := id

JUICERV_TEST := ../../../rtl/core/id.v

CPP_SRC := main.cpp
# clean:

all: $(JUICERV_TEST)
# $(VERILATOR) +incdir+../../../rtl/core/ --debug --trace-fst -Wall --cc $^ --exe $(CPP_SRC)
	$(VERILATOR) +incdir+../../../rtl/core/ --debug --trace -Wall --cc $^ --exe $(CPP_SRC)
	make -C obj_dir -f V$(MOD_NAME).mk V$(MOD_NAME)

run: all
	./obj_dir/V$(MOD_NAME)

clean:
	rm -rf obj_dir