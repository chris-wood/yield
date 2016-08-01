#ifndef buffer_h_
#define buffer_h_

#include <stdint.h>

typedef struct {
    uint8_t *bytes;
    size_t length;
} Buffer;

#endif // buffer_h_
