#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#include <pthread.h>

#include "yield.h"
#include "pktgen.h"
#include "common.h"
#include "repo.h"
#include "buffer.h"
#include "parser.h"

void
usage()
{
    fprintf(stderr, "usage: driver /path/to/interests /path/to/data\n");
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

    // Start the yield thread
    // pthread_t yieldThread;
    // int yieldThreadId = pthread_create(&yieldThread, NULL, (void *(*)(void *)) yield_ServeNIC, (void*) state);

    // Create the packet generator
    PacketGenerator *gen = packetGenerator_Create(pktgenFace);
    packetGenerator_AddSourceFile(gen, interestFile);

    // Start sending and receiving packets
    printf("Retrieving %d packets\n", packetGenerator_PacketCount(gen));
    for (int i = 0; i < packetGenerator_PacketCount(gen); i++) {
        packetGenerator_Send(gen);
        yield_ServeNIC(state);
        Buffer *response = packetGenerator_Receive(gen);
        if (response != NULL) {
            buffer_Display(response);
        }
    }
    printf("Done\n");

    // pthread_exit(NULL);
}
