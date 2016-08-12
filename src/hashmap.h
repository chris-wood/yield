#ifndef hashmap_h_
#define hashmap_h_

#include "buffer.h"

bool hashmap_Insert(Buffer *key, Buffer *value);

bool hashmap_Lookup(Buffer *key, int *length, uint8_t **out);

#endif // hashmap_h_
