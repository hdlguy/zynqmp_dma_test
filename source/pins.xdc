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

## Here are the max2771 signals
set_property PACKAGE_PIN AA3  [get_ports {adc_lo_q_data[0]}];  # JX1_HP_DP_08_N
set_property PACKAGE_PIN AA4  [get_ports {adc_lo_q_data[1]}];  # JX1_HP_DP_08_P
set_property PACKAGE_PIN Y4   [get_ports {adc_lo_i_data[1]}];  # JX1_HP_DP_10_N
set_property PACKAGE_PIN W4   [get_ports {adc_lo_i_data[0]}];  # JX1_HP_DP_10_P
set_property PACKAGE_PIN AB3  [get_ports {adcclkin}];          # JX1_HP_DP_19_GC_P
set_property PACKAGE_PIN Y1   [get_ports {adc_hi_q_data[0]}];  # JX1_HP_DP_09_N
set_property PACKAGE_PIN W1   [get_ports {adc_hi_q_data[1]}];  # JX1_HP_DP_09_P
set_property PACKAGE_PIN AB1  [get_ports {adc_hi_i_data[1]}];  # JX1_HP_DP_11_N
set_property PACKAGE_PIN AB2  [get_ports {adc_hi_i_data[0]}];  # JX1_HP_DP_11_P

set_property IOB TRUE            [get_ports {adc_hi_*_data[*]}]
set_property IOB TRUE            [get_ports {adc_lo_*_data[*]}]
set_property IOSTANDARD LVCMOS18 [get_ports {adc_hi_i_data[1]}];
set_property IOSTANDARD LVCMOS18 [get_ports {adc_hi_i_data[0]}];
set_property IOSTANDARD LVCMOS18 [get_ports {adc_hi_q_data[1]}];
set_property IOSTANDARD LVCMOS18 [get_ports {adc_hi_q_data[0]}];
set_property IOSTANDARD LVCMOS18 [get_ports {adcclkin}];
set_property IOSTANDARD LVCMOS18 [get_ports {adc_lo_i_data[1]}];
set_property IOSTANDARD LVCMOS18 [get_ports {adc_lo_i_data[0]}];
set_property IOSTANDARD LVCMOS18 [get_ports {adc_lo_q_data[1]}];
set_property IOSTANDARD LVCMOS18 [get_ports {adc_lo_q_data[0]}];

## Output enable pins for the level translators on the MAX2771 ADC data line.
set_property IOSTANDARD LVCMOS33 [get_ports {oe_hi}];
set_property IOSTANDARD LVCMOS33 [get_ports {oe_lo}];
set_property PACKAGE_PIN F9  [get_ports {oe_hi}];
set_property PACKAGE_PIN E9  [get_ports {oe_lo}];
## Lock detect lines
set_property IOSTANDARD LVCMOS33 [get_ports {max_hi_ld}];
set_property IOSTANDARD LVCMOS33 [get_ports {max_lo_ld}];
set_property PACKAGE_PIN D11 [get_ports {max_hi_ld}]	;# JX2_HD_SE_07_GC_P
set_property PACKAGE_PIN C11 [get_ports {max_lo_ld}]	;# JX2_HD_SE_07_GC_N

set_property IOSTANDARD LVCMOS33 [get_ports {max_hi_spi_*}];
set_property IOSTANDARD LVCMOS33 [get_ports {max_lo_spi_*}];
set_property PACKAGE_PIN E12 [get_ports {max_hi_spi_sdio}]	;# JX2_HD_SE_08_P
set_property PACKAGE_PIN D12 [get_ports {max_hi_spi_sclk}]	;# JX2_HD_SE_08_N
set_property PACKAGE_PIN G12 [get_ports {max_hi_spi_csn}]	;# JX2_HD_SE_09_P
set_property PACKAGE_PIN F12 [get_ports {max_lo_spi_csn}]	;# JX2_HD_SE_09_N
set_property PACKAGE_PIN H11 [get_ports {max_lo_spi_sdio}]	;# JX2_HD_SE_10_P
set_property PACKAGE_PIN G11 [get_ports {max_lo_spi_sclk}]	;# JX2_HD_SE_10_N





