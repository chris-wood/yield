#ifndef BUFFER_H_
#define BUFFER_H_

#include <stdio.h>
#include <stdint.h>
#include <string.h>

struct buffer;
typedef struct buffer Buffer;

void buffer_Display(FILE *fp, Buffer *b);
Buffer *buffer_CreateEmpty();
Buffer *buffer_CreateFromArray(uint8_t *bytes, size_t length);
Buffer *buffer_Copy(Buffer *copy);
int buffer_Compare(Buffer *this, Buffer *other);

size_t buffer_Size(Buffer *buffer);
uint8_t *buffer_Overlay(Buffer *buffer);

#endif // BUFFER_H_
