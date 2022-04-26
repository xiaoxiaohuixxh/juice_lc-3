.PHONY:all $(JUICERV_TEST) run

VIVADO ?= vivado

MOD_NAME := jlc3_top


# clean:
# getxilinx
all: | new dc

./zynq7020/jlc3_output/: new

packrom:
	../../../../tools/LC-3_Assembler/nglc3asm ./rom/lc3.asm
	echo '\n' >> ./rom/lc3.bin

new: packrom
	$(VIVADO) -mode batch -source ./create_zynq7020_batch.tcl

dc: ./zynq7020/jlc3_output/
	$(VIVADO) -mode batch -source ./run_zynq7020_batch.tcl


IGNORE_FILES := ./zynq7020/ \
				*.jou \
				*.log \
				.Xil



clean:
	rm -rf $(IGNORE_FILES)
