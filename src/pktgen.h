#ifndef pktgen_h_
#define pktgen_h_

#include "buffer.h"
#include "ethernet_wrap.h"

struct packet_generator;
typedef struct packet_generator PacketGenerator;

PacketGenerator *packetGenerator_Create(EthernetFace *face);

void packetGenerator_AddSourceFile(PacketGenerator *gen, char *interestFile);
void packetGenerator_Send(PacketGenerator *gen);
Buffer *packetGenerator_Receive(PacketGenerator *gen);
int packetGenerator_PacketCount(PacketGenerator *gen);

#endif // pktgen_h_
