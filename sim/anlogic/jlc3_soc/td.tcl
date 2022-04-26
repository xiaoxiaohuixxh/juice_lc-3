import_device eagle_s20.db -package BG256
open_project jlc3_soc.al
elaborate -top jlc3_top
optimize_rtl
report_area -file "jlc3_rtl.area"
read_adc "io.adc"
export_db "jlc3_rtl.db"
map_macro
map
pack
report_area -file "jlc3_gate.area"
export_db "jlc3_gate.db"
start_timer
place
route
report_area -io_info -file "jlc3_phy.area"
export_db "jlc3_pr.db"
start_timer
report_timing -mode FINAL -net_info -ep_num 3 -path_num 3 -file "jlc3_phy.timing"
bitgen -bit "jlc3.bit" -version 0X00 -g ucode:00000000000000000000000000000000
