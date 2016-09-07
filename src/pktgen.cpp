#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>

#include <vector>

#include "pktgen.h"

const unsigned char DST_MAC[6] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

#define MTU_SIZE 1500

struct packet_generator {
    int index;
    int numberOfPackets;
    std::vector<Buffer *> interestPackets;
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

static Buffer *
_packetGenerator_ReadPacketBufferFromFile(FILE *fp)
{
    uint8_t header[8] = {0};
    bzero(header, 8);
    ssize_t numRead = fread(header, 1, 8, fp);
    if (numRead == 0) {
        return NULL;
    }

    // XXX: case for malformed packet stream
    uint16_t len = ((uint16_t)(header[2]) << 8) | (uint16_t)(header[3]);
    Buffer *packetBuffer = buffer_Allocate(len);
    memcpy(packetBuffer->bytes, header, 8); // move the header into the packet
    numRead = fread(packetBuffer->bytes + 8, 1, len - 8, fp);
    if (numRead != (len - 8)) {
        buffer_Destroy(&packetBuffer);
        return NULL;
    }

    return packetBuffer;
}

static bool
_packetGenerator_LoadFile(PacketGenerator *gen, char *file)
{
    FILE *fp = fopen(file, "rb");
    if (fp == NULL) {
        fprintf(stderr, "Error could not open %s in 'rb' mode %d \n", file, errno);
        return false;
    }

    while (true) {
        Buffer *packetBuffer = _packetGenerator_ReadPacketBufferFromFile(fp);
        if (packetBuffer == NULL) {
            break;
        }
        gen->interestPackets.push_back(packetBuffer);
        gen->numberOfPackets++;
    }

    return true;
}

PacketGenerator *
packetGenerator_Create(EthernetFace *face)
{
    PacketGenerator *generator = (PacketGenerator *) malloc(sizeof(PacketGenerator));
    generator->face = face;
    generator->index = 0;
    generator->numberOfPackets = 0;
    return generator;
}

void
packetGenerator_AddSourceFile(PacketGenerator *gen, char *interestFile)
{
    _packetGenerator_LoadFile(gen, interestFile);
}

void
packetGenerator_Send(PacketGenerator *gen)
{
    Buffer *packet = gen->interestPackets.at(gen->index);
    ethernet_Write(gen->face, packet->bytes, packet->length);
    gen->index = (gen->index + 1) % gen->interestPackets.size();
}

Buffer *
packetGenerator_Receive(PacketGenerator *gen)
{
    Buffer *packetBuffer = buffer_Allocate(1500); // XXX: the read function should probably return the allocated memory
    ethernet_Read(gen->face, packetBuffer->bytes, (unsigned int *) &(packetBuffer->length));
    return packetBuffer;
}

int
packetGenerator_PacketCount(PacketGenerator *gen)
{
    return gen->numberOfPackets;
}
