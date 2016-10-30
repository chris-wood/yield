#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "sds_lib.h"

#include "common.h"
#include "repo.h"
#include "buffer.h"
#include "yield.h"
#include "ethernet_wrap.h"

int
main(int argc, char **argv)
{
    printf("Starting the forwarder\n\r");

    // Create the repo
    PacketRepo *repo = packetRepo_LoadFromFile((char *) "test_data.bin");
    printf("Repo initialized\n\r");

    // Create the Ethernet face
    //EthernetFace *face = ethernet_CreatePhysicalFace();

    // Create the Yield instance
    //YieldState *state = yield_Create(face, repo);

	// Start serving packets
	//yield_ServeNIC(state);

    return 0;
}
