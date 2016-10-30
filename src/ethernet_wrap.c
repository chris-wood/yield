/*
 * ethernet_wrap.cpp
 *
 *  Created on: Jul 6, 2016
 *      Author: sskalick
 */

//#include "zc706_net.h"
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "common.h"
#include "ethernet_if.h"
#include "ethernet_wrap.h"

#include "buffer.h"
#include "queue.h"

#include <arpa/inet.h>
#include <net/if.h>

#ifndef LOCAL
#include <netinet/ether.h>
#include <linux/if_packet.h>
#endif

#include <sys/ioctl.h>
#include <sys/socket.h>

#define MTU_SIZE 1500

struct ethernet_face {
    void *instance;
    void (*read_wrapper)(void *, unsigned *, unsigned *);
    void (*write_wrapper)(void *, unsigned *, unsigned);
};

typedef struct {
    int id;
    char *name;
    Queue *queue;
} MockEthernetFace;

void
mock_read_wrapper(MockEthernetFace *face, uint8_t *buf, unsigned *len)
{
    //printf("LOG %d %s: read\n", face->id, face->name);
    Buffer *buffer = (Buffer *) queue_Get(face->queue, face->id);
    if (buffer != NULL) {
        memcpy(buf, buffer->bytes, buffer->length);
        *len = buffer->length;
    };
}

void
mock_write_wrapper(MockEthernetFace *face, uint8_t *buf, unsigned len)
{
    //printf("LOG %d %s: write %d\n", face->id, face->name, len);
    int target = face->id == 0 ? 1 : 0;
    int length = 14 + len;

    Buffer *packetBuffer = buffer_Allocate(length);
    memset(packetBuffer->bytes, 0, length);

	packetBuffer->bytes[0] = ~(~target);
	packetBuffer->bytes[1] = ~(~target);
    packetBuffer->bytes[2] = ~(~target);
	packetBuffer->bytes[3] = ~(~target);
	packetBuffer->bytes[4] = ~(~target);
	packetBuffer->bytes[5] = ~(~target);

	packetBuffer->bytes[6] = ~target;
	packetBuffer->bytes[7] = ~target;
	packetBuffer->bytes[8] = ~target;
	packetBuffer->bytes[9] = ~target;
	packetBuffer->bytes[10] = ~target;
	packetBuffer->bytes[11] = ~target;

    // Set the Ethertype to CCNx
	packetBuffer->bytes[12] = 0x08;
	packetBuffer->bytes[13] = 0x01;
    
    // Save the packet bytes in the buffer
    memcpy(packetBuffer->bytes + 14, buf, len);

    queue_Put(face->queue, target, packetBuffer);
}

static EthernetFace *
_createEmptyFace(void)
{
    EthernetFace *face = (EthernetFace *) sds_alloc(sizeof(EthernetFace));
    return face;
}

static MockEthernetFace *
_createMockFace(char *name)
{
    MockEthernetFace *face = (MockEthernetFace *) sds_alloc(sizeof(MockEthernetFace));
    face->id = -1;
    face->name = (char *) sds_alloc(strlen(name) + 1);
    strcpy(face->name, name);
    return face;
}

EthernetFace *
ethernet_CreateMockFace(char *name)
{
    EthernetFace *face = _createEmptyFace();

    face->read_wrapper = (void (*)(void *, unsigned *, unsigned *)) mock_read_wrapper;
    face->write_wrapper = (void (*)(void *, unsigned *, unsigned)) mock_write_wrapper;
    face->instance = _createMockFace(name);

    return face;
}

void
ethernet_Connect(EthernetFace *faceA, EthernetFace *faceB)
{
    MockEthernetFace *fA = (MockEthernetFace *) faceA->instance;
    MockEthernetFace *fB = (MockEthernetFace *) faceB->instance;

    Queue *queue = queue_Create();
    fA->queue = queue;
    fA->id = 0;
    fB->queue = queue;
    fB->id = 1;
}

void
ethernet_Read(EthernetFace *face, uint8_t *buffer, unsigned *length)
{
    face->read_wrapper(face->instance, (unsigned *) buffer, length);
}

void
ethernet_Write(EthernetFace *face, uint8_t *buffer, unsigned length)
{
    face->write_wrapper(face->instance, (unsigned *) buffer, length);
}
