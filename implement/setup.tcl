# This script sets up a Vivado project with all ip references resolved.
close_project -quiet
file delete -force proj.xpr *.os *.jou *.log proj.srcs proj.cache proj.runs
#
create_project -force proj 
set_property board_part em.avnet.com:ultrazed_eg_iocc_production:part0:1.0 [current_project]
set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
load_features ipintegrator

update_ip_catalog

read_ip ../source/test_bram/test_bram.xci
read_ip ../source/bram_ila/bram_ila.xci

upgrade_ip -quiet  [get_ips *]
generate_target {all} [get_ips *]

# make the Zynq block diagram
source ../source/system.tcl
generate_target {synthesis implementation} [get_files ./proj.srcs/sources_1/bd/system/system.bd]
set_property synth_checkpoint_mode None    [get_files ./proj.srcs/sources_1/bd/system/system.bd]

# Read in the hdl source.

read_verilog -sv ../source/top.sv
set_property top top [current_fileset]

read_xdc ../source/top.xdc
read_xdc ../source/pins.xdc
set_property used_in_synthesis false [get_files ../source/pins.xdc]

close_project

#########################


