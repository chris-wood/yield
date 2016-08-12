#include "buffer.h"

Buffer *
buffer_Allocate(int size)
{
    Buffer *buffer = (Buffer*) malloc(sizeof(Buffer));
    buffer->length = size;
    return buffer;
}

void
buffer_Destroy(Buffer **buffer)
{
    free(*buffer->bytes);
    free(*buffer);
    *buffer = NULL;
}
