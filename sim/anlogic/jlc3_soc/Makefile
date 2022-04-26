.PHONY:all $(JUICERV_TEST) dc dl

VERILATOR ?=verilator

VERILATOR_ROOT=/usr/bin/

MOD_NAME := jlc3_soc

CPP_SRC := main.cpp
# clean:

TD_BIN_EXE := D:\Anlogic\TD4.6.4\bin\td_commands_prompt.exe
TD_BIN_ELF := td

all: dc


packrom:
	../../../../tools/LC-3_Assembler/nglc3asm ./rom/lc3.asm
	echo '\n' >> ./rom/lc3.bin

dc: | packrom all
	$(TD_BIN_ELF) td.tcl

dl: dc
	$(TD_BIN_ELF) program.tcl
	

clean:
	rm -rf rom/*.dbg rom/*.lst rom/*.obj rom/*.sym rom/*.vconst .tmp_* .jlc3_soc.al.bak td_*.log
	rm -f *.area *.db *.timing *.tsm

win:
	make -C ../../../sim/yosys_pack clean
	make -C ../../../sim/yosys_pack rtl
	$(TD_BIN_EXE) td.tcl

flash_win:win
	make -C ../../../sim/yosys_pack clean
	make -C ../../../sim/yosys_pack rtl
	$(TD_BIN_EXE) program.tcl

