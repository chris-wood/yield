#include "buffer.h"

#define MAX_TABLE_SIZE 512000 // 500MB
static char tableArray[MAX_TABLE_SIZE];

#define KEY_SIZE 8
static char _hashmap_HashKey[KEY_SIZE] = "12345678";

static Buffer *
_hashmap_ComputeHashedKey(Buffer *key)
{
    // int siphash(uint8_t *out, const uint8_t *in, uint64_t inlen, const uint8_t *k)
    Buffer *hashedKey = buffer_Allocate(KEY_SIZE);

    int result = siphash(hashedKey->bytes, key->bytes, key->length, _hashmap_HashKey);
    if (result < 0) {
        buffer_Destroy(&hashedKey);
        return NULL;
    }

    return hashedKey;
}

static uint64_t
_hashMap_KeyToIndex(Buffer *key)
{
    uint64_t index = 0;
    for (int i = 0; i < key->length; i++) {
        index |= key->bytes[i] << ((key->length - i + 1) * 8);
    }
    return index;
}

static uint64_t
_hashMap_IndexToOffset(uint64_t index)
{
    return index * (3 + 1500); // 1 byte to mark the space, 2 for size, 1500 bytes for max size
}

bool
hashmap_Insert(Buffer *key, Buffer *value)
{
    Buffer *hashedKey = _hashmap_ComputeHashedKey(key);
    int index = _hashMap_KeyToIndex(hashedKey);
    int offset = _hashMap_IndexToOffset(index);

    bool found = false;
    if (tableArray[offset] == 0) {
        tableArray[offset] = 1;
        tableArray[offset + 1] = (uint8_t) ((key->length & 0xFF00) >> 8);
        tableArray[offset + 2] = (uint8_t) (key->length & 0xFF);

        memcpy(&tableArray[offset + 3], key->bytes, 1500); // 1500 is the max packet size
    } else{
        // TODO: handle collisions via probing later
        return false;
    }

    return true;
}

bool
hashmap_Lookup(Buffer *key, int *length, uint8_t **out)
{
    Buffer *hashedKey = _hashmap_ComputeHashedKey(key);
    int index = _hashMap_KeyToIndex(hashedKey);
    int offset = _hashMap_IndexToOffset(index);

    if (tableArray[offset] == 0) {
        return false;
    } else {
        *length = (tableArray[offset + 1] << 8) & 0xFF00;
        *length |= (tableArray[offset + 2]);
        *out = &tableArray[offset + 3];
    }
}
