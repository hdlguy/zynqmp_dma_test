// reference design to test dma to an from a bram array.
module top (
    output  logic[7:0]      led
);

    assign led = 8'hf3;

//    logic           axi_aclk;
//    logic [0:0]     axi_aresetn;
    
    logic [15:0]    bram0_addr;
    logic           bram0_clk;
    logic [31:0]    bram0_din;
    logic [31:0]    bram0_dout;
    logic           bram0_en;
    logic           bram0_rst;
    logic [3:0]     bram0_we;
  
    system system_i (
        .axi_aclk       (),
        .axi_aresetn    (),
        .bram0_addr     (bram0_addr),
        .bram0_clk      (bram0_clk),
        .bram0_din      (bram0_din),
        .bram0_dout     (bram0_dout),
        .bram0_en       (bram0_en),
        .bram0_rst      (bram0_rst),
        .bram0_we       (bram0_we)
    );
    
    test_bram test_bram_inst (
        .clka   (bram0_clk),            // input wire clka
        .ena    (bram0_en),             // input wire ena
        .wea    (bram0_we),             // input wire [3 : 0] wea
        .addra  (bram0_addr[15:2]),     // input wire [13 : 0] addra
        .dina   (bram0_din),            // input wire [31 : 0] dina
        .douta  (bram0_dout)            // output wire [31 : 0] douta
    );
    
    bram_ila bram_ila_inst ( .clk(bram0_clk), .probe0({bram0_en,bram0_we,bram0_addr,bram0_din,bram0_dout}) ); // 85
              
endmodule