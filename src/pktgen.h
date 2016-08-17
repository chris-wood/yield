#ifndef pktgen_h_
#define pktgen_h_

#include "buffer.h"
#include "ethernet_wrap.h"

struct packet_generator;
typedef struct packet_generator PacketGenerator;

PacketGenerator *packetGenerator_Create(EthernetFace *face);

// XXX: pick a better name
void packetGenerator_Send(PacketGenerator *gen);
Buffer *packetGenerator_Receive(PacketGenerator *gen);

#endif // pktgen_h_