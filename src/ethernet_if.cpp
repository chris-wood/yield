
#include "ethernet_if.h"


/*
 * Read from ethernet IP
 */
#ifdef __SDSVHLS__

void read_data(ap_axiu<32,1,1,1> *fifo, unsigned *buf, unsigned &len)
{
#pragma HLS interface axis port=fifo
#pragma HLS interface m_axi port=buf offset=direct
	bool done = false;
	int num_words = 0;
	while (!done) {
#pragma HLS pipeline
		if(fifo->last == 1)
			done = true;
		*buf++ = fifo++->data;
		num_words++;
	}
	len = num_words;
}

#else

void read_data(unsigned *fifo, unsigned *buf, unsigned &len) {
	for(int i=0; i<BUF_SIZE; i++)
		buf[i] = fifo[i];
	len = BUF_SIZE;
}

#endif


void write_data(unsigned *control, unsigned *data, unsigned *buf, unsigned len) {
	unsigned txC[6] = {0,0,0,0,2,0xA0000000};
	//copy control words
	for(int i=0; i<6; i++)
		control[i] = txC[i];

	for(int i=0; i<len; i++)
		data[i] = buf[i];
}
