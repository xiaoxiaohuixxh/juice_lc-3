.PHONY:all $(JUICERV_TEST)

VERILATOR ?=verilator

JUICERV_TEST := ../../../rtl/core/regs.v

CPP_SRC := main.cpp
# clean:

all: $(JUICERV_TEST)
	$(VERILATOR) -Wall --cc $^ --exe $(CPP_SRC)
	make -C obj_dir -f Vregs.mk Vregs

run: all
	./obj_dir/Vregs
