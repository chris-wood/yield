/*
 * ethernet_wrap.cpp
 *
 *  Created on: Jul 6, 2016
 *      Author: sskalick
 */

#include "zc706_net.h"
#include "ethernet_if.h"

struct ethernet_face {
    void *instance;
    void (*read_wrapper)(unsigned *, unsigned &);
    void (*write_wrapper)(unsigned *, unsigned);
};

typedef struct {
    void *x; // ring buffer
} MockEthernetFace;

static EthernetFace *
_createEmptyFace(void)
{
    EthernetFace *face = (EthernetFace *) sds_alloc(sizeof(EthernetFace));
    return face;
}

static MockEthernetFace *
_createMockFace(void)
{
    MockEthernetFace *face = (MockEthernetFace *) sds_alloc(sizeof(MockEthernetFace));
    return face;
}

EthernetFace *
ethernet_CreatePhysicalFace()
{
    EthernetFace *face = _createEmptyFace();

    face->read_wrapper = read_data_wrapper;
    face->write_wrapper = write_data_wrapper;
    face->instance = face;

    return face;
}

EthernetFace *
ethernet_CreateMockFace()
{
    EthernetFace *face = _createEmptyFace();

    face->read_wrapper = mock_read_wrapper;
    face->write_wrapper = mock_write_wrapper;
    face->instance = _createMockFace();

    return face;
}

void 
mock_read_wrapper(MockEthernetFace *face, unsigned *buf, unsigned &len) 
{
    // read from the ring buffer   
}

void 
mock_write_wrapper(MockEthernetFace *face, unsigned *buf, unsigned len) 
{
    // write to the ring buffer
}

void 
ethernet_Read(EthernetFace *face, unsigned *buffer, unsigned &length)
{
    face->read_wrapper(face->instance, buffer, length);
}

void 
ethernet_Write(EthernetFace *face, unsigned *buffer, unsigned length)
{
    face->write_wrapper(face->instance, buffer, length);
}

/*
 * Call platform function and pass buffer to copy into, and length of packet
 * 		- argument buf is expected to be large enough to hold an entire packet
 */
void 
read_data_wrapper(EthernetFace *face, unsigned *buf, unsigned &len) 
{
	// Array to represent data stream from platform
	unsigned rbuf0[1];

	// Read from platform function
	pf_read_data(rbuf0);

	// Call hardware copy function to copy into software buffers
	read_data(rbuf0, buf, len);
}

/*
 * Call platform function and pass buffer to copy from, and length of packet
 */
void 
write_data_wrapper(EthernetFace *face, unsigned *buf, unsigned len) 
{
	unsigned wbuf0[1],wbuf1[1];

	// Call hardware function to copy packet to hardware eth core
	write_data(wbuf1, wbuf0, buf, len);

	// Write data to platform function
	pf_write_data(wbuf0);

	// Write control to platform function
	pf_write_control(wbuf1);
}

