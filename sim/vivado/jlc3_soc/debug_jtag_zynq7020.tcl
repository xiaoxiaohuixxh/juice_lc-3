
open_hw
connect_hw_server
create_hw_target my_svf_target
open_hw_target
# create_hw_device -idcode 01234567 -irlength 8 -mask ffffffff -part userPart1
set device0 [create_hw_device -part xc7z020clg400-2]

set_property PROGRAM.FILE {zynq7020/jlc3_output/bft.bit} $device0

current_hw_device [get_hw_devices xc7z020_1]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7z020_1] 0]
refresh_hw_target
program_hw_devices $device0
write_hw_svf zynq7020/jlc3_output/bft.svf -force
close_hw_target