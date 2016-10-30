#include <stdlib.h>
#include <string.h>

#include "buffer.h"
#include "common.h"

Buffer *
buffer_Allocate(int size)
{
    Buffer *buffer = (Buffer *) malloc(sizeof(Buffer));
    buffer->length = size;
    buffer->bytes = (uint8_t *) malloc(size);
    return buffer;
}

Buffer *
buffer_Create(size_t length, uint8_t *bytes)
{
    Buffer *buffer = buffer_Allocate(length);
    memcpy(buffer->bytes, bytes, length);
    return buffer;
}

void
buffer_Destroy(Buffer **buffer)
{
    free((*buffer)->bytes);
    free(*buffer);
    *buffer = NULL;
}

void
buffer_Display(Buffer *buffer)
{
    for (int i = 0; i < buffer->length - 1; i++) {
        printf("%x", buffer->bytes[i]);
    }
    printf("%x\n", buffer->bytes[buffer->length - 1]);
}
