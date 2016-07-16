#include <stdio.h>
#include "sds_lib.h"
#include "zc706_net.h"
#include "ethernet_if.h"
#include "ethernet_wrap.h"

// don't hate ~~
#include "ccn-lite/ccn-lite-minimalrelay.c"

#define MTU_SIZE 1500
#define CLEAR(X, Y) (memset(X, 0, Y * sizeof(unsigned)))

static int
processPacket(struct ccnl_relay_s *relay, int length, unsigned *inputBuffer[length], unsigned *outputBuffer[MTU])
{
    printf("Packet size is: %d\n\r", length);
    for(unsigned i = 0; i < length; i++) {
        printf("packet data [%d] : %08X\n\r", i, inputBuffer[i]);
    }

    ccnl_core_RX(relay, 0, inputBuffer, length);

    return -1;
}

static int
serveNIC(struct ccnl_relay_s *relay, int bufferSize)
{
    unsigned *inputBuffer = (unsigned*) sds_alloc(bufferSize * sizeof(unsigned));
    unsigned *outputBuffer = (unsigned*) sds_alloc(bufferSize * sizeof(unsigned));
    int length = 0;

    for (;;) {
        // Read a packet
        read_data_wrapper(inputBuffer, length);
        CLEAR(outputBuffer, bufferSize);

        // Process the packet
        length = processPacket(relay, length, inputBuffer, outputBuffer);
        if (length > 0 && length <= MTU) {

            // Write the result
            write_data_buffer(outputBuffer, length);
            CLEAR(outputBuffer, bufferSize);
        }
    }

    sds_free(inputBuffer);
    sds_free(outputBuffer);

    return 0;
}

static struct ccnl_relay_s *
configureForwarder(int bufferSize)
{
    ccnl_core_init();

    struct ccnl_forward_s *fwd;
    struct ccnl_relay_s *relay = ccnl_malloc(sizeof(ccnl_relay_s));

    inet_aton(strtok(defaultgw,"/"), &sun.ip4.sin_addr);
    sun.ip4.sin_port = atoi(strtok(NULL, ""));
    fwd = (struct ccnl_forward_s *) ccnl_calloc(1, sizeof(*fwd));
    fwd->prefix = ccnl_URItoPrefix(prefix, suite, NULL, NULL);
    fwd->suite = suite;
    fwd->face = ccnl_get_face_or_create(&theRelay, 0, &sun.sa, sizeof(sun.ip4));
    fwd->face->flags |= CCNL_FACE_FLAGS_STATIC;
    relay->fib = fwd;

    return relay;
}

int
main(int argc, char **argv)
{
    printf("Starting the forwarder,\n\r");

    struct ccnl_relay_s *relay = configureForwarder(MTU);
    ccnl_set_timer(1000000, ccnl_minimalrelay_ageing, relay, 0);
    return serveNIC(relay, MTU);
}
