#ifndef buffer_h_
#define buffer_h_

#include <stdint.h>

typedef struct {
    uint8_t *bytes;
    size_t length;
} Buffer;

Buffer *buffer_Create(size_t length, uint8_t bytes[length]);

#endif // buffer_h_
