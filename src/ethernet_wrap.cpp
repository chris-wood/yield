/*
 * ethernet_wrap.cpp
 *
 *  Created on: Jul 6, 2016
 *      Author: sskalick
 */

#include "zc706_net.h"
#include "ethernet_if.h"

/*
 * Call platform function and pass buffer to copy into, and length of packet
 * 		- argument buf is expected to be large enough to hold an entire packet
 */
void read_data_wrapper(unsigned *buf, unsigned &len) {
	//array to represent data stream from platform
	unsigned rbuf0[1];
	//read from platform function
	pf_read_data(rbuf0);
	//call hardware copy function to copy into software buffers
	read_data(rbuf0,buf,len);
}



/*
 * Call platform function and pass buffer to copy from, and length of packet
 */
void write_data_wrapper(unsigned *buf, unsigned len) {
	unsigned wbuf0[1],wbuf1[1];
	//call hardware function to copy packet to hardware eth core
	write_data(wbuf1,wbuf0,buf,len);
	//write data to platform function
	pf_write_data(wbuf0);
	//write control to platform function
	pf_write_control(wbuf1);
}
