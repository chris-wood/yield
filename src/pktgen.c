#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <errno.h>

#include "pktgen.h"

const unsigned char DST_MAC[6] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

#define MTU_SIZE 1500

struct packet_generator {
    int index;
    Buffer **interestPackets;
    int numPackets;
};

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

static void
_packetGenerator_AppendPacket(PacketGenerator *gen, Buffer *packet)
{
    gen->numPackets++;
    if (gen->interestPackets == NULL) {
        gen->interestPackets = (Buffer **) malloc(sizeof(Buffer *));
    } else {
        gen->interestPackets = (Buffer **) realloc(gen->interestPackets, (gen->numPackets) * sizeof(Buffer *));
    }
    gen->interestPackets[gen->numPackets - 1] = packet;
}

static int
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
        _packetGenerator_AppendPacket(gen, packetBuffer);
    }

    return true;
}

PacketGenerator *
packetGenerator_Create(char *file)
{
    PacketGenerator *generator = (PacketGenerator *) malloc(sizeof(PacketGenerator));
    if (generator != NULL) {
        generator->index = 0;
        generator->interestPackets = NULL;
        generator->numPackets = 0;
        _packetGenerator_LoadFile(generator, file);
    }
    return generator;
}

Buffer *
packetGenerator_Next(PacketGenerator *gen)
{
    Buffer *buffer = gen->interestPackets[gen->index];
    gen->index = (gen->index + 1) % gen->numPackets;
    return buffer;
}

int
packetGenerator_PacketCount(PacketGenerator *gen)
{
    return gen->numPackets;
}
