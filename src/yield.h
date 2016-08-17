#ifndef yield_h_
#define yield_h_

#include "ethernet_wrap.h"
#include "repo.h"

struct yield_state;
typedef struct yield_state YieldState;

YieldState *yield_Create(EthernetFace *face, PacketRepo *repo);
int yield_ServeNIC(YieldState *state); 

#endif // yield_h_
