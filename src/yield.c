#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include "sds_lib.h"

#include "repo.h"
#include "buffer.h"
#include "parser.h"

//#include "zc706_net.h"
//#include "ethernet_if.h"
//#include "ethernet_wrap.h"

// don't hate ~~
// #include "ccn-lite/ccn-lite-minimalrelay.c"

#define MTU_SIZE 1500
#define CLEAR(X, Y) (memset(X, 0, Y * sizeof(unsigned)))

#define sds_alloc malloc
#define sds_malloc malloc
#define sds_free free
#define sds_memcpy memcpy

static int
_processPacket(PacketRepo *repo, int length, uint8_t inputBuffer[length], uint8_t outputBuffer[MTU_SIZE])
{
    printf("Packet size is: %d\n\r", length);
    for (int i = 0; i < length; i++) {
        printf("packet data [%d] : %02x\n\r", i, inputBuffer[i]);
    }

    // fix to extract the name/keyid/hash
    Buffer *key = _readName(inputBuffer, length);
    Buffer *response = packetRepo_Lookup(repo, key, NULL);

    memcmp(outputBuffer, response->bytes, response->length);
    return response->length;
}

static void
read_data_wrapper(uint8_t *buffer, int length)
{
    // pass
}

static void
write_data_buffer(uint8_t *buffer, int length)
{
    // pass
}

static int
_serveNIC(PacketRepo *repo, int bufferSize)
{
    uint8_t *inputBuffer = (uint8_t *) sds_alloc(bufferSize * sizeof(uint8_t));
    uint8_t *outputBuffer = (uint8_t *) sds_alloc(bufferSize * sizeof(uint8_t));
    int length = 0;

    for (;;) {
        // Read a packet
        read_data_wrapper(inputBuffer, length);
        CLEAR(outputBuffer, bufferSize);

        // Process the packet
        length = _processPacket(repo, length, inputBuffer, outputBuffer);
        if (length > 0 && length <= bufferSize) {

            // Write the result
            write_data_buffer(outputBuffer, length);
            CLEAR(outputBuffer, bufferSize);
        }
    }

    sds_free(inputBuffer);
    sds_free(outputBuffer);

    return 0;
}

int
main(int argc, char **argv)
{
    printf("Starting the forwarder,\n\r");

    // Create the repo
    PacketRepo *repo = packetRepo_LoadFromFile("test.bin");

    // Start serving packets
    return _serveNIC(repo, MTU_SIZE);
}
