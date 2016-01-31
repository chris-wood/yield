#ifndef CRYPTO_H_
#define CRYPTO_H_

#include "buffer.h"

struct crypto_context;
typedef struct crypto_context CryptoContext;

Buffer *encrypt(CryptoContext *context, Buffer *in);

#endif // CRYPTO_H_
