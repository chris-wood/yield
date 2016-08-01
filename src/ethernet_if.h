
#ifndef _COPY_DATA_H_
#define _COPY_DATA_H_

#define BUF_SIZE_BYTES 1520
#define BUF_SIZE 512

#ifdef __SDSVHLS__
#include "ap_axi_sdata.h"

void read_data(ap_axiu<32,1,1,1> *fifo, unsigned *buf, unsigned &len);

#else

#pragma SDS data mem_attribute (buf:CACHEABLE|PHYSICAL_CONTIGUOUS)
#pragma SDS data zero_copy(buf[0:BUF_SIZE])
void read_data(unsigned *fifo, unsigned *buf, unsigned &len);

#endif



#pragma SDS data mem_attribute (buf:CACHEABLE|PHYSICAL_CONTIGUOUS)
#pragma SDS data copy (control[0:6], data[0:len], buf[0:len])
#pragma SDS data data_mover(buf:AXIDMA_SIMPLE)
#pragma SDS data sys_port(buf:ACP)
#pragma SDS data access_pattern (control:SEQUENTIAL, data:SEQUENTIAL, buf:SEQUENTIAL)
void write_data(unsigned *control, unsigned *data, unsigned *buf, unsigned len);


#endif
