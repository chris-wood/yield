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
    
int
main(int argc, char **argv)
{
    EthernetFace *yieldFace = ethernet_CreateMockFace(0);
    EthernetFace *pktgenFace = ethernet_CreateMockFace(1);
    ethernet_Connect(yieldFace, pktgenFace);

    // Create the yield components
	PacketRepo *repo = packetRepo_LoadFromFile((char *) "test_data.bin");
    YieldState *state = yield_Create(yieldFace, repo);

    // Start the yield thread
    pthread_t yieldThread;
    int yieldThreadId = pthread_create(&yieldThread, NULL, (void *(*)(void *)) yield_ServeNIC, (void*) state);

    // Create the packet generator
    PacketGenerator *gen = packetGenerator_Create(pktgenFace);

    // Start sending and receiving packets
    for (int i = 0; i < 10; i++) {
        packetGenerator_Send(gen);
        Buffer *response = packetGenerator_Receive(gen);
    }

    pthread_exit(NULL);
}
