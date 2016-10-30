/*
 * ethernet_wrap.cpp
 *
 *  Created on: Jul 6, 2016
 *      Author: sskalick
 */

//#include "zc706_net.h"
#include <stdlib.h>
#include <stdint.h>

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

#ifndef LOCAL
typedef struct {
	char packetBuffer[MTU_SIZE];
	struct sockaddr_ll linkLayerAddress;
    int sockfd;
} SocketEthernetFace;
#endif

void
mock_read_wrapper(MockEthernetFace *face, uint8_t *buf, unsigned *len)
{
    //printf("LOG %d %s: read\n", face->id, face->name);
    Buffer *buffer = (Buffer *) face->queue->get(face->id);
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

    face->queue->put(target, packetBuffer);
}

#ifndef LOCAL

void
socket_read_wrapper(SocketEthernetFace *face, uint8_t *buf, unsigned &len)
{
    memset(face->packetBuffer, 0, MTU_SIZE);

    // XXX: read from packet buffer into the output buffer

    int destAddressLength = 0;
    int numBytesReceived = recvfrom(face->socketfd, packetBuffer, MTU_SIZE, 0, (struct sockaddr *) &linkLayerAddress, &destAddressLength);
    if (numBytesReceived < 0) {
        printf("Receive failed\n");
    }
}

void
socket_write_wrapper(SocketEthernetFace *face, uint8_t *buf, unsigned len)
{
    int packetSize = 0; // XXX: compute this

    // XXX: copy the buffer into the packet buffer and send

	int numBytesSent = sendto(face->sockfd, face->packetBuffer, packetSize, 0, (struct sockaddr*) &face->linkLayerAddress, sizeof(struct sockaddr_ll));
    if (numBytesSent < 0) {
        printf("Send failed\n");
        exit(-1);
    }
}

#endif

#ifndef LOCAL

/*
 * Call platform function and pass buffer to copy into, and length of packet
 * 		- argument buf is expected to be large enough to hold an entire packet
 */
void
read_data_wrapper(EthernetFace *face, uint8_t *buf, unsigned *len)
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
write_data_wrapper(EthernetFace *face, uint8_t *buf, unsigned len)
{
	unsigned wbuf0[1],wbuf1[1];

	// Call hardware function to copy packet to hardware eth core
	write_data(wbuf1, wbuf0, buf, len);

	// Write data to platform function
	pf_write_data(wbuf0);

	// Write control to platform function
	pf_write_control(wbuf1);
}

#endif

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

#ifndef LOCAL

static SocketEthernetFace *
_createSocketFace(char *device, unsigned char *dst)
{
    SocketEthernetFace *face = (SocketEthernetFace *) sds_alloc(sizeof(SocketEthernetFace));

    int sockfd = 0;
	if ((sockfd = socket(AF_PACKET, SOCK_RAW, IPPROTO_RAW)) == -1) {
        perror("Unable to create a raw socket.\n");
        free(generator);
	    return NULL;
	}

	// Get the interface index
    struct ifreq interfaceIndex;
	struct ifreq interfaceMAC;
	memset(&interfaceIndex, 0, sizeof(struct ifreq));
	strncpy(interfaceIndex.ifr_name, device, IFNAMSIZ - 1);
	if (ioctl(sockfd, SIOCGIFINDEX, &interfaceIndex) < 0) {
	    perror("SIOCGIFINDEX");
        free(generator);
        return NULL;
    }

    // Get the interface MAC address
	memset(&interfaceMAC, 0, sizeof(struct ifreq));
	strncpy(interfaceMAC.ifr_name, device, IFNAMSIZ-1);
	if (ioctl(sockfd, SIOCGIFHWADDR, &interfaceMAC) < 0) {
	    perror("SIOCGIFHWADDR");
        free(generator);
        return NULL;
    }

	// Initialize the Ethernet header with the source
    memset(packetBuffer, 0, BUF_SIZ);
    struct ether_header *eh = (struct ether_header *) packetBuffer;
	packetBuffer->bytes[0] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[0];
	packetBuffer->bytes[1] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[1];
    packetBuffer->bytes[2] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[2];
	packetBuffer->bytes[3] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[3];
	packetBuffer->bytes[4] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[4];
	packetBuffer->bytes[5] = ((uint8_t *)&interfaceMAC.ifr_hwaddr.sa_data)[5];

	packetBuffer->bytes[0] = dst[0];
	packetBuffer->bytes[1] = dst[1];
	packetBuffer->bytes[2] = dst[2];
	packetBuffer->bytes[3] = dst[3];
	packetBuffer->bytes[4] = dst[4];
	packetBuffer->bytes[5] = dst[5];

    // Set the Ethertype
	eh->ether_type = htons(ETH_P_IP);

    // Set the link layer address
	linkLayerAddress.sll_ifindex = interfaceIndex.ifr_ifindex;
	linkLayerAddress.sll_halen = ETH_ALEN;

	// Set the link layer destination MAC address
	linkLayerAddress.sll_addr[0] = dst[0];
	linkLayerAddress.sll_addr[1] = dst[1];
	linkLayerAddress.sll_addr[2] = dst[2];
	linkLayerAddress.sll_addr[3] = dst[3];
	linkLayerAddress.sll_addr[4] = dst[4];
	linkLayerAddress.sll_addr[5] = dst[5];
}

#endif

#ifndef LOCAL
EthernetFace *
ethernet_CreatePhysicalFace()
{
    EthernetFace *face = _createEmptyFace();

    face->read_wrapper = (void (*)(void *, unsigned *, unsigned &)) read_data_wrapper;
    face->write_wrapper = (void (*)(void *, unsigned *, unsigned)) write_data_wrapper;
    face->instance = face;

    return face;
}
#endif

EthernetFace *
ethernet_CreateSocketFace(char *device, unsigned char *dst)
{
    EthernetFace *face = _createEmptyFace();

    // XXX: do things

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

    Queue *queue = new Queue();
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