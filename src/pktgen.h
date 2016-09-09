#ifndef pktgen_h_
#define pktgen_h_

#include "buffer.h"
#include "ethernet_wrap.h"

struct packet_generator;
typedef struct packet_generator PacketGenerator;

PacketGenerator *packetGenerator_Create(char *sourceFile);

Buffer *packetGenerator_Next(PacketGenerator *gen);
int packetGenerator_PacketCount(PacketGenerator *gen);

#endif // pktgen_h_
