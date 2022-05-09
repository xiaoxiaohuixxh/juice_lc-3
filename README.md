# JUICE LC3
Author: Li.XiongHui(juicemail@163.com)
### 1. clone this project
```
git clone https://gitee.com/xunxiaohuii/juice_lc-3

or

git clone https://github.com/xiaoxiaohuixxh/juice_lc-3
```
### 2. download and compile verilator simulator
2.1 download verilator source code , install the tools of dependence for compile verilator 
```
# Prerequisites:
sudo apt-get install git perl python3 make autoconf g++ flex bison ccache
sudo apt-get install libgoogle-perftools-dev numactl perl-doc
sudo apt-get install libfl2  # Ubuntu only (ignore if gives error)
sudo apt-get install libfl-dev  # Ubuntu only (ignore if gives error)
sudo apt-get install zlibc zlib1g zlib1g-dev  # Ubuntu only (ignore if gives error)

cd juice_lc-3/juicelc3/tools

git clone https://github.com/verilator/verilator   # Only first time
cd verilator
git pull         # Make sure git repository is up-to-date
git tag          # See what versions exist
git checkout aa86c777f4787db7d10fbbbb5019ed4d20a7fcfb  # switch to v4.220 version
```

2.2 compile the verilator source code
```
unset VERILATOR_ROOT  # For bash
autoconf         # Create ./configure script
./configure      # Configure and create Makefile
make -j `nproc`  # Build Verilator itself (if error, try just 'make')
./bin/verilator --version
```
the version for my verilator is ``` Verilator 4.221 devel rev v4.220-35-g2b91d764 ```

### 3. design compile juicelc3 soc demo
``` pwd ``` is xxx/juice_lc-3/juicelc3/tools/verilator
switch to juicelc3 soc demo directory
```
cd ../../sim/verilator/jlc3_soc
chmod +x ../../../tools/LC-3_Assembler/nglc3asm
```
run design compile
```
make run # will be automaticlly run dc,compile asm code and run demo
```

```
➜  jlc3_soc git:(master) ✗ make run                                                                              
../../../tools/LC-3_Assembler/nglc3asm ./rom/lc3.asm
Assembling "./rom/lc3.asm"

First Pass
----------
First Pass successful
Symbol table written to file "./rom/lc3.sym"

Second Pass
-----------
Second Pass successful
Binary file written to file "./rom/lc3.bin"
Hexadecimal file written to file "./rom/lc3_hex.bin"
echo '\n' >> ./rom/lc3.bin
verilator +incdir+../../../rtl/peripherals +incdir+../../../rtl/core/  --top-module jlc3_soc --trace -Wall -Wno-LATCH -Wno-EOFNEWLINE --cc jlc3_soc.v mem_ctrl.v ../../../rtl/core/pc.v ../../../rtl/core/id.v ../../../rtl/core/alu.v ../../../rtl/core/regs.v ../../../rtl/core/ctrl.v ../../../rtl/core/mux_1to2_16b.v ../../../rtl/core/mux_2to1_16b.v ../../../rtl/core/mux_3to1_16b.v ../../../rtl/peripherals/simple_uart_send.v --exe main.cpp
make -C obj_dir -f Vjlc3_soc.mk Vjlc3_soc
make[1]: Entering directory '/home/juice/prj/juice_lc-3/juicelc3/sim/verilator/jlc3_soc/obj_dir'
ccache g++  -I.  -MMD -I/home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include -I/home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -std=gnu++14 -Os -c -o main.o ../main.cpp
ccache g++  -I.  -MMD -I/home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include -I/home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -std=gnu++14 -Os -c -o verilated.o /home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include/verilated.cpp
ccache g++  -I.  -MMD -I/home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include -I/home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -std=gnu++14 -Os -c -o verilated_vcd_c.o /home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include/verilated_vcd_c.cpp
/usr/bin/perl /home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/bin/verilator_includer -DVL_INCLUDE_OPT=include Vjlc3_soc.cpp Vjlc3_soc___024root__DepSet_h4f076a71__0.cpp Vjlc3_soc__Trace__0.cpp Vjlc3_soc__ConstPool_0.cpp Vjlc3_soc___024root__Slow.cpp Vjlc3_soc___024root__DepSet_h4f076a71__0__Slow.cpp Vjlc3_soc__Syms.cpp Vjlc3_soc__Trace__0__Slow.cpp > Vjlc3_soc__ALL.cpp
ccache g++  -I.  -MMD -I/home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include -I/home/juice/prj/lc3_verilog/juicelc3/sim/verilator/sim/verilator/include/vltstd -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -DVM_TRACE_FST=0 -faligned-new -fcf-protection=none -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow      -std=gnu++14 -Os -c -o Vjlc3_soc__ALL.o Vjlc3_soc__ALL.cpp
echo "" > Vjlc3_soc__ALL.verilator_deplist.tmp
Archive ar -rcs Vjlc3_soc__ALL.a Vjlc3_soc__ALL.o
g++    main.o verilated.o verilated_vcd_c.o Vjlc3_soc__ALL.a      -o Vjlc3_soc
rm Vjlc3_soc__ALL.verilator_deplist.tmp
make[1]: Leaving directory '/home/juice/prj/juice_lc-3/juicelc3/sim/verilator/jlc3_soc/obj_dir'
./obj_dir/Vjlc3_soc
Enabling waves...
uart0 write 0041 A
uart0 write 0031 1
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0032 2
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0033 3
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0034 4
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0035 5
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0036 6
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0037 7
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0038 8
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0041 A
uart0 write 0031 1
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0032 2
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0033 3
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0034 4
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0035 5
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0036 6
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0037 7
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0038 8
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 uart0_seaddr 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0041 A
uart0 write 0031 1
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0032 2
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0033 3
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0034 4
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0035 5
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0036 6
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
uart0 read stac 1
uart0 read stac 1
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 read stac 0
uart0 write 0037 7
uart0 uart0_seaddr 0
uart0 uart0_seaddr 1
uart0 uart0_seaddr 0
---test jlc3_soc pass-----------------------------------------
```
thx for try!!! --- Li.XiongHui(juicemail@163.com)