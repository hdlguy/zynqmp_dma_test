// Top module of the Xilinx Zu3EG FPGA design for the Ultrazed module on the Avnet I/O carrier (proto V1).
// ADC data is received on the 32MHz adcclk then transitioned to the 256MHz dsp clock for processing.
import timepack::*;

module top (
    // Data interface from MAX2771 ADCs
    input   logic           adcclkin,
    input   logic[1:0]      adc_hi_i_data,
    input   logic[1:0]      adc_hi_q_data,
    // Three wire SPI interface to MAX2771
    output  logic           max_hi_spi_sclk,
    output  logic           max_hi_spi_csn,
    inout   logic           max_hi_spi_sdio,
    // lock detect signals from MAX synthesizer.
    input   logic           max_hi_ld,
    input   logic           max_lo_ld,
    //
    output  logic[7:0]      led,
    //
    output  logic           oe_hi,
    output  logic           oe_lo
);

    localparam integer Nchan = 8; // number of receiver channels
    
    // Tie the output enable lines for the MAX data lines high.
    assign oe_hi = 1'b1;
    assign oe_lo = 1'b1;

    // the block diagram providing the AXI interface from the processors.
    logic           axi_aclk;
    logic [0:0]     axi_aresetn;
    // AXI bus for register file.
    logic [39:0]    M00_AXI_araddr;
    logic [2:0]     M00_AXI_arprot;
    logic           M00_AXI_arready;
    logic           M00_AXI_arvalid;
    logic [39:0]    M00_AXI_awaddr;
    logic [2:0]     M00_AXI_awprot;
    logic           M00_AXI_awready;
    logic           M00_AXI_awvalid;
    logic           M00_AXI_bready;
    logic [1:0]     M00_AXI_bresp;
    logic           M00_AXI_bvalid;
    logic [31:0]    M00_AXI_rdata;
    logic           M00_AXI_rready;
    logic [1:0]     M00_AXI_rresp;
    logic           M00_AXI_rvalid;
    logic [31:0]    M00_AXI_wdata;
    logic           M00_AXI_wready;
    logic [3:0]     M00_AXI_wstrb;
    logic           M00_AXI_wvalid;
    // AXI bus for MAX2771 SPI controller.
    logic [39:0]    M01_AXI_araddr;
    logic [2:0]     M01_AXI_arprot;
    logic           M01_AXI_arready;
    logic           M01_AXI_arvalid;
    logic [39:0]    M01_AXI_awaddr;
    logic [2:0]     M01_AXI_awprot;
    logic           M01_AXI_awready;
    logic           M01_AXI_awvalid;
    logic           M01_AXI_bready;
    logic [1:0]     M01_AXI_bresp;
    logic           M01_AXI_bvalid;
    logic [31:0]    M01_AXI_rdata;
    logic           M01_AXI_rready;
    logic [1:0]     M01_AXI_rresp;
    logic           M01_AXI_rvalid;
    logic [31:0]    M01_AXI_wdata;
    logic           M01_AXI_wready;
    logic [3:0]     M01_AXI_wstrb;
    logic           M01_AXI_wvalid;
    // interface to capture ram
    logic [15:0]    capt_bram_addr;
    logic           capt_bram_clk;
    logic [31:0]    capt_bram_din;
    logic [31:0]    capt_bram_dout;
    logic           capt_bram_en;
    logic           capt_bram_rst;
    logic [3:0]     capt_bram_we;
    // interface to waas ram
    logic [15:0]    waas_bram_addr;
    logic           waas_bram_clk;
    logic [31:0]    waas_bram_din;
    logic [31:0]    waas_bram_dout;
    logic           waas_bram_en;
    logic           waas_bram_rst;
    logic [3:0]     waas_bram_we;    
    
    logic[Nchan+1-1:0]      rx_intr; // the extra interrupt is for waas
    
    system system_i (
        .axi_aclk           (axi_aclk),
        .axi_aresetn        (axi_aresetn),
        //
        .rx_int(rx_intr),
        //
        .M00_AXI_araddr     (M00_AXI_araddr),
        .M00_AXI_arprot     (M00_AXI_arprot),
        .M00_AXI_arready    (M00_AXI_arready),
        .M00_AXI_arvalid    (M00_AXI_arvalid),
        .M00_AXI_awaddr     (M00_AXI_awaddr),
        .M00_AXI_awprot     (M00_AXI_awprot),
        .M00_AXI_awready    (M00_AXI_awready),
        .M00_AXI_awvalid    (M00_AXI_awvalid),
        .M00_AXI_bready     (M00_AXI_bready),
        .M00_AXI_bresp      (M00_AXI_bresp),
        .M00_AXI_bvalid     (M00_AXI_bvalid),
        .M00_AXI_rdata      (M00_AXI_rdata),
        .M00_AXI_rready     (M00_AXI_rready),
        .M00_AXI_rresp      (M00_AXI_rresp),
        .M00_AXI_rvalid     (M00_AXI_rvalid),
        .M00_AXI_wdata      (M00_AXI_wdata),
        .M00_AXI_wready     (M00_AXI_wready),
        .M00_AXI_wstrb      (M00_AXI_wstrb),
        .M00_AXI_wvalid     (M00_AXI_wvalid),
        //
        .M01_AXI_araddr     (M01_AXI_araddr),
        .M01_AXI_arprot     (M01_AXI_arprot),
        .M01_AXI_arready    (M01_AXI_arready),
        .M01_AXI_arvalid    (M01_AXI_arvalid),
        .M01_AXI_awaddr     (M01_AXI_awaddr),
        .M01_AXI_awprot     (M01_AXI_awprot),
        .M01_AXI_awready    (M01_AXI_awready),
        .M01_AXI_awvalid    (M01_AXI_awvalid),
        .M01_AXI_bready     (M01_AXI_bready),
        .M01_AXI_bresp      (M01_AXI_bresp),
        .M01_AXI_bvalid     (M01_AXI_bvalid),
        .M01_AXI_rdata      (M01_AXI_rdata),
        .M01_AXI_rready     (M01_AXI_rready),
        .M01_AXI_rresp      (M01_AXI_rresp),
        .M01_AXI_rvalid     (M01_AXI_rvalid),
        .M01_AXI_wdata      (M01_AXI_wdata),
        .M01_AXI_wready     (M01_AXI_wready),
        .M01_AXI_wstrb      (M01_AXI_wstrb),
        .M01_AXI_wvalid     (M01_AXI_wvalid),
        //        
        .capt_bram_addr (capt_bram_addr),
        .capt_bram_clk  (capt_bram_clk),
        .capt_bram_din  (capt_bram_din),
        .capt_bram_dout (capt_bram_dout),
        .capt_bram_en   (capt_bram_en),
        .capt_bram_rst  (capt_bram_rst),
        .capt_bram_we   (capt_bram_we),
        //        
        .waas_bram_addr (waas_bram_addr),
        .waas_bram_clk  (waas_bram_clk),
        .waas_bram_din  (waas_bram_din),
        .waas_bram_dout (waas_bram_dout),
        .waas_bram_en   (waas_bram_en),
        .waas_bram_rst  (waas_bram_rst),
        .waas_bram_we   (waas_bram_we)        
    );
    

    // clock generator for the dsp clocks, one MMCM.
    logic clk_locked, dspclk, adcclk;
    clkwiz    clkwiz_inst ( .clkin(adcclkin), .reset(1'b0), .locked(clk_locked), .clkout(adcclk), .clkoutx4(dspclk) );
    
    // let's make a dedicated counter so software can do some rough time measurements.
    logic[31:0] sw_time;
    always_ff @(posedge axi_aclk) sw_time <= sw_time+1;


    // Let's flash LEDs with the adc clock. make it flash the same as the axi clock counter. round((32*1.023/100)*(2^28)/2) = 43937515
    logic [27:0] adc_led_count;
    logic adc_led_toggle;
    always_ff @(posedge adcclk) begin
        if (43937515==adc_led_count) begin 
            adc_led_count <= 0;
            adc_led_toggle <= ~adc_led_toggle;
        end else begin
            adc_led_count <= adc_led_count + 1;
        end
    end
    assign led[7] = adc_led_toggle; 


    // Let's flash LEDs with the axi clock.
    logic [31:0] led_count;
    logic led_count_disable, led_count_clear;
    always_ff @(posedge axi_aclk) begin
        if (1==led_count_clear) begin       
                led_count <= 0;
        end else begin
            if (1==led_count_disable) begin            
                led_count <= led_count;
            end else begin
                led_count <= led_count + 1;
            end
        end
    end
    assign led[6] = led_count[27];    
    assign led[5] = clk_locked;
    assign led[4] = max_hi_ld;
    

    // register ADC data. These are constrained to be located in the IO logic.
    logic [1:0] adc_hi_i_data_reg, adc_hi_q_data_reg;
    always_ff @(posedge adcclk) begin
        adc_hi_i_data_reg <= adc_hi_i_data;
        adc_hi_q_data_reg <= adc_hi_q_data;
    end
    

    // here we transition from the 32MHz adcclk to the 256MHz dspclk.
    // The two clocks are aligned by the MMCM but at a 1:8 frequency ratio.
    logic adc_cross_dv;
    logic [1:0] adc_hi_cross_i, adc_hi_cross_q;
    clock_crosser #(.WIDTH(4)) clock_crosser_inst (
        .slowclk(adcclk),                        .din( {adc_hi_i_data_reg, adc_hi_q_data_reg}),
        .fastclk(dspclk), .dv_out(adc_cross_dv), .dout({adc_hi_cross_i, adc_hi_cross_q})
    );


    // convert 2 bit "unsigned binary" I+Q data to four bits I+Q.
    logic[3:0] four_bit_hi_q, four_bit_hi_i;
    logic four_bit_hi_dv;
    const logic[3:0] flut [0:3] = { 4'hA, 4'hE, 4'h2, 4'h6 }; // = -6, -2, +2, +6 - see table 12
    always_ff @(posedge dspclk) begin
        four_bit_hi_dv <= adc_cross_dv;
        four_bit_hi_q  <= flut[adc_hi_cross_q];
        four_bit_hi_i  <= flut[adc_hi_cross_i];
    end

    // filter (if not commented out)
    logic[3:0] filt_bb_imag, filt_bb_real;
    logic filt_bb_dv;
//    assign filt_bb_dv   = four_bit_hi_dv;
//    assign filt_bb_imag = four_bit_hi_i;
//    assign filt_bb_real = four_bit_hi_q;
    match_filt match_filt_inst (.clk(dspclk), .dv_in(four_bit_hi_dv), .din_imag(four_bit_hi_i), .din_real(four_bit_hi_q), .dv_out(filt_bb_dv), .dout_imag(filt_bb_imag), .dout_real(filt_bb_real) ); 


/*
    // convert 3 bit "unsigned binary" encoded I-only samples to four bit two's complement
    logic[3:0] four_bit_hi_i;
    logic four_bit_hi_dv;
    const logic[3:0] flut [0:7] = { 4'b1001, 4'b1011, 4'b1101, 4'b1111, 4'b0001, 4'b0011, 4'b0101, 4'b0111 }; // { -7, -5, -3, -1, +1, +3, +5, +7 }
    always_ff @(posedge dspclk) begin
        four_bit_hi_dv <= adc_cross_dv;
        four_bit_hi_i  <= flut[{adc_hi_cross_i[1:0], adc_hi_cross_q[1]}];
    end
    
    // mix with -Fs/4 and halfband low-pass filter to remove image at Fs/2
    logic[3:0] filt_bb_imag, filt_bb_real;
    logic filt_bb_dv;
    mix_filt mix_filt_inst (.clk(dspclk), .dv_in(four_bit_hi_dv), .d_in(four_bit_hi_i), .dv_out(filt_bb_dv), .dout_imag(filt_bb_imag), .dout_real(filt_bb_real));
*/       


/*
    // this is a simple datagenerator that puts out SV 21 at Fdopp = ?
    logic[3:0] dgen_imag, dgen_real;
    logic dgen_dv;
    dgen dgen_inst ( .clk(dspclk), .dv_in(adc_cross_dv), .dv_out(dgen_dv), .dout_imag(dgen_imag), .dout_real(dgen_real) );
*/

/*
module gps_emulator #(
    parameter int Nsat = 4
)(
    input  logic            clk,                    // this is the system clock.
    input  logic            reset,                  // active high reset. to be controlled by software and released at time zero.
    input  logic            dv_in,                  // this sets the sample cadence.
    input  logic[31:0]      dop_freq    [Nsat-1:0], // the doppler frequency for each satellite.
    input  logic[31:0]      code_freq   [Nsat-1:0], // the code rate for each satellite. should be (1.023e6 + Fdopp/1540)
    input  logic[15:0]      gain        [Nsat-1:0], // the gain of each satellite
    input  logic[5:0]       ca_sel      [Nsat-1:0], // the C/A sequence of each satellite 0-35 corresponds to SV 1-36. SV 37 not supported.
    // quantized baseband
    output logic       dv_out,
    output logic[3:0]  real_out,  imag_out
);
*/

    // programmable gps test source.
    logic emu_reset;
    logic[31:0] emu_dopp_freq [3:0];
    logic[31:0] emu_code_freq [3:0];
    logic[15:0] emu_gain [3:0];
    logic[5:0] emu_ca_sel [3:0];
    logic[3:0] dgen_imag, dgen_real;
    logic dgen_dv;
    gps_emulator #(.Nsat(4)) gps_emu_inst (.clk(dspclk), .reset(emu_reset), .dv_in(adc_cross_dv), .dop_freq(emu_dopp_freq), .code_freq(emu_code_freq), .gain(emu_gain), .ca_sel(emu_ca_sel), .dv_out(dgen_dv), .imag_out(dgen_imag), .real_out(dgen_real));
    
    // here we put a mux to select between antenna data and the dgen
    logic[3:0] bb_imag, bb_real;
    logic bb_dv;
    logic dgen_sel;
    always_ff @(posedge dspclk) begin
        if (1==dgen_sel) begin
            bb_imag <= dgen_imag;
            bb_real <= dgen_real;
            bb_dv   <= dgen_dv;
        end else begin
            bb_imag <= filt_bb_imag;
            bb_real <= filt_bb_real;
            bb_dv   <= filt_bb_dv;
        end
    end


    // the epoch timer produces a pulse every 32*1023 samples.
    logic epoch;
    logic[63:0] time_count;
    epoch_timer epoch_timer_inst (.clk(dspclk), .dv_in(bb_dv), .epoch(epoch), .time_count(time_count));

        

    // This is a logic analyzer to look at the baseband signal going into the gps receiver.
    //baseband_ila baseband_ila_inst(.clk(dspclk), .probe0({epoch, bb_dv, four_bit_hi_dv, adc_cross_dv}), .probe1({bb_imag, bb_real, four_bit_hi_i, adc_hi_cross_i, adc_hi_cross_q}) ); // 4, 4+4+4+2+2=16


    // Here we put a ram to support capture of baseband data.  It is 64K samples deep. Capture is synchronized to the local epoch.
    logic capture_start, capture_done;
    logic[5:0] capture_dec;
    capture_ram capture_ram_inst (
        .clk        (dspclk),
        .epoch      (epoch),
        .start      (capture_start),
        .dec        (capture_dec),
        .done       (capture_done),
        .dv_in      (bb_dv),
        .din        ({bb_imag, bb_real}),
        .bram_clk   (capt_bram_clk),
        .bram_ena   (capt_bram_en),
        .bram_wea   (capt_bram_we),
        .bram_addr  (capt_bram_addr),
        .bram_din   (capt_bram_din),
        .bram_dout  (capt_bram_dout)
    );

    
    // the gps receiver
    logic[14:0]         start_delay [Nchan-1:0];
    logic[31:0]         start_dopp  [Nchan-1:0];
    logic[5:0]          ca_sel      [Nchan-1:0];
    logic[Nchan-1:0]    chan_reset;        
    logic[Nchan-1:0]    rx_dv_out;
    logic[31:0]         sum_imag    [Nchan-1:0]; 
    logic[31:0]         sum_real    [Nchan-1:0];
    logic[63:0]         time_out    [Nchan-1:0]; 
    logic[Nchan-1:0]    waas_dv;
    logic[31:0]         waas_sum    [Nchan-1:0];
    receiver #(
        .Nchan(Nchan)) receiver_inst (.clk(dspclk), .epoch(epoch), .time_in(time_count),
        .start_delay(start_delay), .start_dopp(start_dopp), .ca_sel(ca_sel), .chan_reset(chan_reset),
        .dv_in(bb_dv), .din_imag(bb_imag), .din_real(bb_real), 
        .dv_out(rx_dv_out), .sum_imag(sum_imag), .sum_real(sum_real), .time_out(time_out),
        .waas_dv_out(waas_dv), .waas_sum(waas_sum)
    );
    

    
    // stretch the receiver datavalid pulse and cross to the axi clock for the interrupt controller.
    genvar chanvar;
    generate for (chanvar=0; chanvar<Nchan; chanvar++) begin    
        dv_2_intr dv_2_intr_inst ( .fastclk(dspclk), .dv_in(rx_dv_out[chanvar]), .slowclk(axi_aclk), .intr_out(rx_intr[chanvar]) );                        
    end endgenerate
    
    
    // The WAAS data interface on channel 7 only.
    logic waas_if_dv, waas_reset, waas_bank;
    waas_if waas_if_inst (.clk(dspclk), .reset(waas_reset), .dv_in(waas_dv[7]), .din(waas_sum[7]), .bank(waas_bank), .dv_out(waas_if_dv), 
        .bram_clk(waas_bram_clk), .bram_ena(waas_bram_en), .bram_addr(waas_bram_addr[10:0]), .bram_dout(waas_bram_dout) );
    // create the interrupt pulse for the waas interface.
    dv_2_intr waas_dv_2_intr ( .fastclk(dspclk), .dv_in(waas_if_dv), .slowclk(axi_aclk), .intr_out(rx_intr[Nchan]) ); 
    

    // Here begins the section containing the AXI peripherals.
    // The first one on AXI bus M00 is a register file for all control and status registers needed by the receiver logic.
    // The next two on AXI M01 and M02 are custom SPI controllers for the two MAX2771 RF front-end chips.


    // This register file gives software contol over unit under test (UUT).    
    localparam integer Nsys_reg = 24;                       // Number of system registers.
    localparam integer Nregs_per_chan = 16;                 // number of regs per receiver channel
    localparam integer Nchan_reg = Nregs_per_chan*Nchan+5;  // Number of registers needed for the entire receiver.
    localparam integer Nemu = 4;                            // number of satellite channels in the gps emulator.
    localparam integer Nemu_reg = Nemu*4;                   // number of registers needed for emu control
    localparam integer Nreg = Nsys_reg+Nchan_reg+Nemu_reg;  // number of 32 bit registers in the register file.
    localparam integer Nreg_addr = $clog2(Nreg) + 2;        // number of address bits used by register file.

    logic [Nreg-1:0][31:0] slv_reg, slv_read;

    // system registers
    assign slv_read[0] = 32'h05010100;
    assign slv_read[1] = linuxtime; //32'h76543210;
    
    assign led_count_clear   = slv_reg[2][8];
    assign led_count_disable = slv_reg[2][12];
    assign slv_read[2]       = slv_reg[2];
    
    assign slv_read[3][1] = max_hi_ld;
    assign slv_read[3][0] = max_lo_ld;
    
    assign capture_start = slv_reg[4][0];
    assign slv_read[4][3:0] = slv_reg[4][3:0];
    assign slv_read[4][4] = capture_done;
    assign capture_dec = slv_reg[4][20:16];
    assign slv_read[4][31:8] = slv_reg[4][31:8];

    assign slv_read[10][3:0] = slv_reg[10][3:0];
    assign slv_read[10][31:8] = slv_reg[10][31:8];
  
    assign slv_read[11] = led_count;
    
    assign led[0]          = slv_reg[12][0];
    assign led[1]          = slv_reg[13][0];
    assign led[2]          = slv_reg[14][0];
    assign led[3]          = slv_reg[15][0];
    assign slv_read[15:12] = slv_reg[15:12];

    // individual channel resets in a single register
    assign chan_reset = slv_reg[16][Nchan-1:0];
    assign slv_read[16] = slv_reg[16];

    assign dgen_sel     = slv_reg[17][0];
    assign slv_read[17] = slv_reg[17];
    
    assign slv_read[18] = sw_time;

    assign emu_reset = slv_reg[19][0];
    assign slv_read[19] = slv_reg[19];
    
    assign waas_reset = slv_reg[20][0];
    assign slv_read[20][4] = waas_bank;

    // repeated receiver registers
    generate for (chanvar=0; chanvar<Nchan; chanvar++) begin
        assign start_delay      [chanvar]                  = slv_reg[Nsys_reg+Nregs_per_chan*chanvar+0][14:0];
        assign slv_read[Nsys_reg+Nregs_per_chan*chanvar+0] = slv_reg[Nsys_reg+Nregs_per_chan*chanvar+0];

        assign start_dopp       [chanvar]                  = slv_reg[Nsys_reg+Nregs_per_chan*chanvar+1];
        assign slv_read[Nsys_reg+Nregs_per_chan*chanvar+1] = slv_reg[Nsys_reg+Nregs_per_chan*chanvar+1];

        assign ca_sel           [chanvar]                  = slv_reg[Nsys_reg+Nregs_per_chan*chanvar+2][5:0];
        assign slv_read[Nsys_reg+Nregs_per_chan*chanvar+2] = slv_reg[Nsys_reg+Nregs_per_chan*chanvar+2];

        assign slv_read[Nsys_reg+Nregs_per_chan*chanvar+4] = sum_imag[chanvar];
        assign slv_read[Nsys_reg+Nregs_per_chan*chanvar+5] = sum_real[chanvar];
        assign slv_read[Nsys_reg+Nregs_per_chan*chanvar+6] = time_out[chanvar][31: 0];
        assign slv_read[Nsys_reg+Nregs_per_chan*chanvar+7] = time_out[chanvar][63:32];
    end endgenerate

    // repeated emulator registers
    generate for (chanvar=0; chanvar<Nemu; chanvar++) begin
        assign emu_dopp_freq    [chanvar]                  = slv_reg[Nsys_reg+Nchan_reg+4*chanvar+0];
        assign slv_read[Nsys_reg+Nchan_reg+4*chanvar+0]    = slv_reg[Nsys_reg+Nchan_reg+4*chanvar+0];

        assign emu_code_freq    [chanvar]                  = slv_reg[Nsys_reg+Nchan_reg+4*chanvar+1];
        assign slv_read[Nsys_reg+Nchan_reg+4*chanvar+1]    = slv_reg[Nsys_reg+Nchan_reg+4*chanvar+1];

        assign emu_gain         [chanvar]                  = slv_reg[Nsys_reg+Nchan_reg+4*chanvar+2][15:0];
        assign slv_read[Nsys_reg+Nchan_reg+4*chanvar+2]    = slv_reg[Nsys_reg+Nchan_reg+4*chanvar+2];

        assign emu_ca_sel       [chanvar]                  = slv_reg[Nsys_reg+Nchan_reg+4*chanvar+3][5:0];
        assign slv_read[Nsys_reg+Nchan_reg+4*chanvar+3]    = slv_reg[Nsys_reg+Nchan_reg+4*chanvar+3];

    end endgenerate


	axi_regfile_v1_0_S00_AXI #	(
		.C_S_AXI_DATA_WIDTH(32),
		.C_S_AXI_ADDR_WIDTH(Nreg_addr)
	) axi_regfile_inst (
        // register interface
        .slv_read(slv_read), 
        .slv_reg (slv_reg),  
        .slv_wr_pulse(),
        // axi interface
		.S_AXI_ACLK    (axi_aclk),
		.S_AXI_ARESETN (axi_aresetn),
        //
		.S_AXI_ARADDR  (M00_AXI_araddr ),
		.S_AXI_ARPROT  (M00_AXI_arprot ),
		.S_AXI_ARREADY (M00_AXI_arready),
		.S_AXI_ARVALID (M00_AXI_arvalid),
		.S_AXI_AWADDR  (M00_AXI_awaddr ),
		.S_AXI_AWPROT  (M00_AXI_awprot ),
		.S_AXI_AWREADY (M00_AXI_awready),
		.S_AXI_AWVALID (M00_AXI_awvalid),
		.S_AXI_BREADY  (M00_AXI_bready ),
		.S_AXI_BRESP   (M00_AXI_bresp  ),
		.S_AXI_BVALID  (M00_AXI_bvalid ),
		.S_AXI_RDATA   (M00_AXI_rdata  ),
		.S_AXI_RREADY  (M00_AXI_rready ),
		.S_AXI_RRESP   (M00_AXI_rresp  ),
		.S_AXI_RVALID  (M00_AXI_rvalid ),
		.S_AXI_WDATA   (M00_AXI_wdata  ),
		.S_AXI_WREADY  (M00_AXI_wready ),
		.S_AXI_WSTRB   (M00_AXI_wstrb  ),
		.S_AXI_WVALID  (M00_AXI_wvalid )
	);

    // this is the spi interface to the high band MAX2771
    logic max_hi_spi_tri, max_hi_spi_miso, max_hi_spi_mosi;
    max2771_spi #(.Nwait(49)) max2771_hi_spi_inst (
        // spi signals
        .spi_sclk       (max_hi_spi_sclk),
        .spi_csn        (max_hi_spi_csn),
        .spi_mosi       (max_hi_spi_mosi),
        .spi_tri        (max_hi_spi_tri),
        .spi_miso       (max_hi_spi_miso),
        // AXI-4 Lite
		.S_AXI_ACLK    (axi_aclk),
		.S_AXI_ARESETN (axi_aresetn),
		.S_AXI_ARADDR  (M01_AXI_araddr ),
		.S_AXI_ARPROT  (M01_AXI_arprot ),
		.S_AXI_ARREADY (M01_AXI_arready),
		.S_AXI_ARVALID (M01_AXI_arvalid),
		.S_AXI_AWADDR  (M01_AXI_awaddr ),
		.S_AXI_AWPROT  (M01_AXI_awprot ),
		.S_AXI_AWREADY (M01_AXI_awready),
		.S_AXI_AWVALID (M01_AXI_awvalid),
		.S_AXI_BREADY  (M01_AXI_bready ),
		.S_AXI_BRESP   (M01_AXI_bresp  ),
		.S_AXI_BVALID  (M01_AXI_bvalid ),
		.S_AXI_RDATA   (M01_AXI_rdata  ),
		.S_AXI_RREADY  (M01_AXI_rready ),
		.S_AXI_RRESP   (M01_AXI_rresp  ),
		.S_AXI_RVALID  (M01_AXI_rvalid ),
		.S_AXI_WDATA   (M01_AXI_wdata  ),
		.S_AXI_WREADY  (M01_AXI_wready ),
		.S_AXI_WSTRB   (M01_AXI_wstrb  ),
		.S_AXI_WVALID  (M01_AXI_wvalid )
    );
    // bidirectional tri-state buffer on max_spi_sdio.
    assign max_hi_spi_sdio = (1==max_hi_spi_tri) ? 1'bz : max_hi_spi_mosi;
    assign max_hi_spi_miso = max_hi_spi_sdio;
        

endmodule

