# zynqmp_dma_test
A project to develop bare metal dma transfers on Xilinx ZynqMP.

An FPGA design and XSDK software projects are included using Vivado 2019.1 tools.

## FPGA Design
A simple design is provided that contains a single 64KB bram array to use for DMA testing. ILA debug cores are attached to the bram interface and to the AXI bus so traffic can be observed.

To compile the FPGA change to the the  ./implement folder and run

    vivado -mode batch -source setup.tcl

    vivado -mode batch -source compile.tcl


## Software Project
The Xilinx xzdma_simple_example.c was modified to use the bram array as source for zdma transfers.

To run change to the ./sdk/dma_test folder and run

    xsct setup.tcl

    xsdk

Select ./sdk/dma_test/dma_test.sdk as the workspace.

