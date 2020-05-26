#include "xparameters.h"
#include  <stdint.h>
#include "xil_printf.h"

#define SIZE (XPAR_AXI_BRAM_CTRL_0_S_AXI_HIGHADDR - XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR + 1)

uint32_t read_buf[SIZE/4];

int main(void)
{

	// create a pointer to the BRAM array
	uint32_t* bram_buf = (uint32_t*)(XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR);

	uint32_t* timer = (uint32_t *)XPAR_AXI_GPIO_0_BASEADDR;

	uint32_t time1, time2;

	// initialize the BRAM array
	for (uint32_t i=0; i<(SIZE/4); i++) {
		bram_buf[i] = i;
	}

	// read back the BRAM array a few times.
	const uint32_t Nread = 100;
	time1 = *timer;
	for (uint32_t j=0; j<Nread; j++){
		for (uint32_t i=0; i<(SIZE/4); i++) {
			read_buf[i] = bram_buf[i];
		}
	}
	time2 = *timer;

	double runtime = (time2-time1)/100.0e6;
	xil_printf("time1 = 0x%08x\n\r", time1);
	xil_printf("time1 = 0x%08x\n\r", time2);
	xil_printf("delta time = %d\n\r", (int)(time2-time1));
	xil_printf("runtime = %d milliseconds\n\r", (int)(1000*runtime) );

	return 0;

}


