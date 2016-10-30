#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "pktgen.h"

int
main(int argc, char *argv[])
{
    EthernetFace *face = ethernet_CreateSocketFace("eth0", DST_MAC);

    // XXX: use the generator

	return 0;
}
