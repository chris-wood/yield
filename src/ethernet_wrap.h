/*
 * ethernet_wrap.h
 *
 *  Created on: Jul 6, 2016
 *      Author: sskalick
 */
#ifndef SRC_ETHERNET_WRAP_H_
#define SRC_ETHERNET_WRAP_H_

struct ethernet_face;
typedef struct ethernet_face EthernetFace;

EthernetFace *ethernet_CreatePhysicalFace();
EthernetFace *ethernet_CreateMockFace();

void ethernet_Read(EthernetFace *face, unsigned *buffer, unsigned &length);
void ethernet_Write(EthernetFace *face, unsigned *buffer, unsigned length);

//void read_data_wrapper(EthernetFace *face, unsigned *buf, unsigned &len);
//void write_data_wrapper(EthernetFace *face, unsigned *buf, unsigned len);

#endif /* SRC_ETHERNET_WRAP_H_ */
