#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include "yield.h"
#include "pktgen.h"

void
usage()
{
    fprintf(stderr, "usage: driver /path/to/interests /path/to/data\n");
}

void
sendPacket(EthernetFace *face, Buffer *packet)
{
    ethernet_Write(face, packet->bytes, packet->length);
}

Buffer *
receivePacket(EthernetFace *face)
{
    Buffer *packetBuffer = buffer_Allocate(1500); // XXX: the read function should probably return the allocated memory
    ethernet_Read(face, packetBuffer->bytes, (unsigned int *) &(packetBuffer->length));
    return packetBuffer;
}

int
main(int argc, char **argv)
{
    if (argc != 3) {
        usage();
        return -1;
    }

    char *interestFile = argv[1];
    char *dataFile = argv[2];

    EthernetFace *yieldFace = ethernet_CreateMockFace("yield");
    EthernetFace *pktgenFace = ethernet_CreateMockFace("pktgen");
    ethernet_Connect(yieldFace, pktgenFace);

    // Create the yield components
    PacketRepo *repo = packetRepo_LoadFromFile(dataFile);
    YieldState *state = yield_Create(yieldFace, repo);

    // Create the packet generator
    PacketGenerator *gen = packetGenerator_Create(interestFile);

    // Start sending and receiving packets
    printf("Retrieving %d packets\n", packetGenerator_PacketCount(gen));
    for (int i = 0; i < packetGenerator_PacketCount(gen); i++) {
        Buffer *nextPacket = packetGenerator_Next(gen);
        sendPacket(pktgenFace, nextPacket);
        yield_ServeNIC(state);
        Buffer *response = receivePacket(pktgenFace);
        if (response != NULL) {
            buffer_Display(response);
        }
    }
}

