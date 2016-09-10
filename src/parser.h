#ifndef PARSER_H_
#define PARSER_H_

#include "buffer.h"

Buffer *parser_ReadName(uint8_t *buffer, size_t length);

Buffer *parser_ReadContentId(uint8_t *buffer, size_t length);

Buffer *parser_ReadKeyId(uint8_t *buffer, size_t length);

Buffer *parser_ReadIdentity(uint8_t *buffer, size_t length);

#endif // PARSER_H_
