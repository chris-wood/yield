#ifndef buffer_h_
#define buffer_h_

#include <stdint.h>

typedef struct {
    uint8_t *bytes;
    size_t length;
} Buffer;

Buffer *buffer_Create(size_t length, uint8_t bytes[length]);
Buffer *buffer_Allocate(int size);
void buffer_Destroy(Buffer **buffer);
void buffer_Display(Buffer *buffer);

#endif // buffer_h_
