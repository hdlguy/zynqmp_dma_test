# top.xdc - this file contains the constraints shared by the fpga versions for the Avnet carrier and the PP custom carrier with MAX2771 on-board.
# This constraint file should be applied for synthesis and implementation.

# the clock from the MAX2771
create_clock -period 30.547 -name adcclkin [get_ports adcclkin]

set_input_delay -clock adcclkin -max 28.0 [get_ports {adc_*_*_data[*]}]; # setup
set_input_delay -clock adcclkin -min  1.0 [get_ports {adc_*_*_data[*]}]; # hold

set_property IOB TRUE            [get_ports {adc_hi_*_data[*]}]

set_property IOB TRUE [get_ports {max_hi_spi_*}];

# These deconstrain signals of capture_ram that cross clock boundaries.
set_max_delay -from [get_pins capture_ram_inst/sr_reg/C] -to [get_pins {axi_regfile_inst/axi_rdata_reg[4]/D}]               20.1
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[4][0]/C}] -to [get_pins {capture_ram_inst/start_reg_reg[2]/D}]  20.1
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}] -to [get_pins {capt_data_reg[*]/D}]                   20.1
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}] -to [get_pins capt_dv_reg/D]                          20.1
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}] -to [get_pins {capt_data_reg[*]/S}]                   20.1
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}] -to [get_pins emu_reset_reg_reg/D]                    20.1
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}] -to [get_pins capt_dv_reg/S]                          20.1
set_max_delay -from [get_pins capture_ram_inst/done_reg/C]            -to [get_pins {axi_regfile_inst/axi_rdata_reg[4]/D}]  20.1
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[4][0]/C}] -to [get_pins {capture_ram_inst/start_reg_reg[1]/D}]  20.1
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[4][*]/C}] -to [get_pins {capture_ram_inst/dv_count_reg[*]/D}]   20.1


set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[17][0]*/C}] -to [get_pins bb_dv_reg/*]          20.3
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[17][0]*/C}] -to [get_pins {bb_real_reg[*]/*}]   20.3
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[17][0]*/C}] -to [get_pins {bb_imag_reg[*]/*}]   20.3

# These deconstrain signals of gps_receiver that cross clock boundaries.
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}]           -to [get_pins {receiver_inst/chan_reset_q_reg[*]/D}]                                            20.2
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}]           -to [get_pins {receiver_inst/genblk1[*].rx_chan_inst/doppler_nco_inst/phase_reg[*]/D}]          20.2
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]_replica/C}]   -to [get_pins {receiver_inst/genblk1[*].rx_chan_inst/doppler_nco_inst/phase_reg[*]/D}]          20.2
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}]           -to [get_pins {receiver_inst/genblk1[*].rx_chan_inst/start_con_inst/start_count_reg[*]/D}]      20.2
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[25][*]*/C}]         -to [get_pins {receiver_inst/genblk1[*].rx_chan_inst/track_control_inst/dopp_freq_reg[*]/D}]    20.2
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]*/C}]          -to [get_pins {receiver_inst/genblk1[*].rx_chan_inst/code_delay_nco_inst/q_reg/D}]              20.2
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]*/C}]          -to [get_pins {receiver_inst/genblk1[*].rx_chan_inst/track_control_inst/dopp_freq_reg[*]/D}]    20.2
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[20][0]/C}]          -to [get_pins waas_if_inst/reset_q_reg/D] 20.2


set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]*/C}] -to [get_pins {gps_emu_inst/genblk1[*].sat_chan_inst/scaled_*_reg/DSP_M_DATA_INST/V[*]}] 20.5
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]*/C}] -to [get_pins {gps_emu_inst/genblk1[*].sat_chan_inst/scaled_*_reg/DSP_M_DATA_INST/U[*]}] 20.5
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}]  -to [get_pins {gps_emu_inst/genblk1[*].sat_chan_inst/code_nco_inst/q_reg/D}] 20.5
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}]  -to [get_pins {gps_emu_inst/genblk1[*].sat_chan_inst/doppler_nco_inst/phase_reg[*]/D}] 20.5
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}]  -to [get_pins {gps_emu_inst/genblk1[*].sat_chan_inst/code_nco_inst/ph_inc_reg[*]/D}] 20.5
set_max_delay -from [get_pins {axi_regfile_inst/slv_reg_reg[*][*]/C}]  -to [get_pins gps_emu_inst/reset_reg_reg/D] 20.5

set_max_delay -from [get_pins {receiver_inst/genblk1[*].rx_chan_inst/bitgen_inst/sum_out_imag_reg[*]/C}] -to [get_pins {axi_regfile_inst/axi_rdata_reg[*]/D}] 20.6
set_max_delay -from [get_pins {receiver_inst/genblk1[*].rx_chan_inst/bitgen_inst/sum_out_real_reg[*]/C}] -to [get_pins {axi_regfile_inst/axi_rdata_reg[*]/D}] 20.6
set_max_delay -from [get_pins {receiver_inst/genblk1[*].rx_chan_inst/bitgen_inst/time_out_reg[*]/C}]     -to [get_pins {axi_regfile_inst/axi_rdata_reg[*]/D}] 20.6
set_max_delay -from [get_pins waas_if_inst/bank_reg/C] -to [get_pins {axi_regfile_inst/axi_rdata_reg[4]/D}] 20.6


set_max_delay -from [get_pins {genblk1[*].dv_2_intr_inst/dv_pulse_reg/C}] -to [get_pins {genblk1[*].dv_2_intr_inst/dv_pulse_cross_reg[1]_srl2/D}]  4.1
set_max_delay -from [get_pins waas_dv_2_intr/dv_pulse_reg/C]              -to [get_pins {waas_dv_2_intr/dv_pulse_cross_reg[1]_srl2/D}]             4.1


