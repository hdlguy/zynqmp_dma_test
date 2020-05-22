# proto_top.xdc - this xdc file is used to fix the pinouts to run on the PP prototype version 1.
#
# The LED's - retained from Avnet Carrier 
set_property IOSTANDARD LVCMOS18 [get_ports {led[*]}]

set_property PACKAGE_PIN R7 [get_ports {led[0]}]	;# JX1_HP_DP_25_P
set_property PACKAGE_PIN T5 [get_ports {led[1]}]	;# JX1_HP_DP_24_P
set_property PACKAGE_PIN T7 [get_ports {led[2]}]	;# JX1_HP_DP_25_N
set_property PACKAGE_PIN T4 [get_ports {led[3]}]	;# JX1_HP_DP_24_N
set_property PACKAGE_PIN T3 [get_ports {led[4]}]	;# JX1_HP_DP_27_P
set_property PACKAGE_PIN U2 [get_ports {led[5]}]	;# JX1_HP_DP_27_N
set_property PACKAGE_PIN U6 [get_ports {led[6]}]	;# JX1_HP_DP_26_P
set_property PACKAGE_PIN U5 [get_ports {led[7]}]	;# JX1_HP_DP_26_N





