#include <stdio.h>
#include "sds_lib.h"
#include "zc706_net.h"
#include "ethernet_if.h"
#include "ethernet_wrap.h"

#define MTU_SIZE 1500
#define CLEAR(X, Y) (memset(X, 0, Y * sizeof(unsigned)))

static int
processPacket(int length, unsigned *inputBuffer[length], unsigned *outputBuffer[MTU])
{
    printf("Packet size is: %d\n\r", length);
    for(unsigned i = 0; i < length; i++) {
        printf("packet data [%d] : %08X\n\r", i, inputBuffer[i]);
    }

    return -1;
}

static void
serveNIC(int bufferSize)
{
    unsigned *inputBuffer = (unsigned*) sds_alloc(bufferSize * sizeof(unsigned));
    unsigned *outputBuffer = (unsigned*) sds_alloc(bufferSize * sizeof(unsigned));
    int length = 0;

    for (;;) {
        // Read a packet
        read_data_wrapper(inputBuffer, length);
        CLEAR(outputBuffer, bufferSize);

        // Process the packet
        length = processPacket(length, inputBuffer, outputBuffer);
        if (length > 0 && length <= MTU) {

            // Write the result
            write_data_buffer(outputBuffer, length);
            CLEAR(outputBuffer, bufferSize);
        }
    }

    sds_free(inputBuffer);
    sds_free(outputBuffer);
}

int
main(int argc, char **argv)
{
    printf("Starting...\n\r");
    serveNIC(MTU);
    printf("Done!\n\r");
}
