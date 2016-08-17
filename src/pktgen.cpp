#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "pktgen.h"

const unsigned char DST_MAC[6] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

#define MTU_SIZE 1500

struct packet_generator {
    char *sourceFile;
    EthernetFace *face;
};

/*
static int
_fillPacket(PacketGenerator *generator)
{
    // XXX: load a wire-encoded interest into this packet

    buffer[offset++] = 0x00;
    buffer[offset++] = 0x01;
    buffer[offset++] = 0x02;
    buffer[offset++] = 0x03;

    return offset;
}
*/

PacketGenerator *
packetGenerator_Create(EthernetFace *face)
{
    PacketGenerator *generator = (PacketGenerator *) malloc(sizeof(PacketGenerator));
    generator->face = face;
    return generator;
}

void
packetGenerator_Send(PacketGenerator *gen)
{
    // pass
    
	// Fill in the Ethertype
	//packetSize += sizeof(struct ether_header);
}

Buffer *
packetGenerator_Receive(PacketGenerator *gen)
{
    return NULL;
}

