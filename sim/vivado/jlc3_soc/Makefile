.PHONY:all $(JUICERV_TEST) run

VIVADO ?= vivado

MOD_NAME := jlc3_top


# clean:
# getxilinx
all: | new dc

./zynq7020/jlc3_output/: new

new: 
	$(VIVADO) -mode batch -source ./create_zynq7020_batch.tcl

dc: ./zynq7020/jlc3_output/
	$(VIVADO) -mode batch -source ./run_zynq7020_batch.tcl

debug_dc: dc
	$(VIVADO) -mode batch -source ./debug_jtag_zynq7020.tcl

debug:
	$(VIVADO) -mode batch -source ./debug_jtag_zynq7020.tcl


IGNORE_FILES := ./zynq7020/ \
				*.jou \
				*.log \
				.Xil \
				*.html \
				*.xml

clean:
	rm -rf $(IGNORE_FILES)
