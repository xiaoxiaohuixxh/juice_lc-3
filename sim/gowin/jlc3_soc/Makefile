.PHONY:all $(JUICERV_TEST) dc dl

MOD_NAME := jlc3_soc

CPP_SRC := main.cpp
# clean:



GW_BIN_EXE := D:\Gowin\Gowin_V1.9.8\IDE\bin\gw_sh.exe
# GW_BIN_ELF := /Gowin/Gowin_V1.9.8/IDE/bin/gw_sh
GW_BIN_ELF := gw_sh

all: dc


packrom:
	../../../../tools/LC-3_Assembler/nglc3asm ./rom/lc3.asm
	echo '\n' >> ./rom/lc3.bin

dc: | packrom all
	$(GW_BIN_ELF) ./build_jlc3.tcl

dl: dc
	$(TD_BIN_ELF) program.tcl
	

clean:
	rm -rf rom/*.dbg rom/*.lst rom/*.obj rom/*.sym rom/*.vconst .tmp_* .jlc3_soc.al.bak td_*.log
	rm -f impl


win:
	$(GW_BIN_EXE) ./build_jlc3.tcl

clean:
	rm -rf impl