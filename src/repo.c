#include "repo.h"
#include "buffer.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "siphash24.c"

typedef int bool;
#define true 1
#define false 0

#define BUCKET_CAPACITY 10
#define MIN_BUCKETS 16 // 2^4
#define KEYLEN 16
#define HASHLEN 8

struct key {
    Buffer *buffer;
};

struct value {
    Buffer *buffer;
};

struct repo_entry;
typedef struct repo_entry {
    Key *key;
    Value *value;
    uint8_t occupied;
} RepoEntry;

typedef struct repo_bucket {
    RepoEntry **entryList;
    uint32_t count;
    uint32_t capacity;
} RepoBucket;

struct repo {
    RepoBucket **buckets;
    uint32_t numBuckets;

    uint8_t key[KEYLEN];
    uint32_t layer;
};

RepoEntry *
repoEntry_Create()
{
    RepoEntry *entry = (RepoEntry *) malloc(sizeof(RepoEntry));
    entry->key = NULL;
    entry->value = NULL;
    entry->occupied = 0;
    return entry;
}

RepoBucket *
repoBucket_Create(uint32_t capacity)
{
    RepoBucket *bucket = (RepoBucket *) malloc(sizeof(RepoBucket));
    bucket->entryList = (RepoEntry **) malloc(sizeof(RepoEntry *) * capacity);
    for (int i = 0; i < capacity; i++) {
        bucket->entryList[i] = repoEntry_Create();
    }
    bucket->capacity = capacity;
    bucket->count = 0;
    return bucket;
}

bool
repoBucket_Insert(RepoBucket *bucket, Key *key, Value *value)
{
    if (bucket == NULL) {
        return false;
    } else if (bucket->count == bucket->capacity) {
        return false;
    } else {
        int index = bucket->count++;
        bucket->entryList[index]->occupied = 1;
        bucket->entryList[index]->key = key;
        bucket->entryList[index]->value = value;
        return true;
    }
}

Value *
repoBucket_Index(RepoBucket *bucket, Key *key)
{
    if (bucket == NULL) {
        return NULL;
    } else {
        for (int i = 0; i < bucket->count; i++) { // this iteration count is finite (-> set to BUCKET_SIZE)
            RepoEntry *entry = bucket->entryList[i];
            if (buffer_Compare(entry->key->buffer, key->buffer) == 0) {
                return entry->value;
            }
        }
        return NULL;
    }
}

// Linear scan through the bucket list
bool
repoBucket_Contains(RepoBucket *bucket, Key *key)
{
    if (bucket == NULL) {
        return false;
    } else {
        for (int i = 0; i < bucket->count; i++) { // this iteration count is finite (-> set to BUCKET_SIZE)
            RepoEntry *entry = bucket->entryList[i];
            if (buffer_Compare(entry->key->buffer, key->buffer) == 0) {
                return true;
            }
        }
        return false;
    }
}

Repo *
repo_Create()
{
    Repo *repo = (Repo *) malloc(sizeof(Repo));

    // this is just a huge matrix of entries of size (MIN_BUCKETS * BUCKET_CAPACITY)
    repo->buckets = (RepoBucket **)malloc(sizeof(RepoBucket **) * MIN_BUCKETS);
    repo->numBuckets = MIN_BUCKETS;

    for (int i = 0; i < MIN_BUCKETS; i++) {
        repo->buckets[i] = repoBucket_Create(BUCKET_CAPACITY);
    }

    // 4 bits to start
    repo->layer = 4;

    for (int i = 0; i < KEYLEN; ++i) {
        repo->key[i] = i;
    }

    return repo;
}


Value *
value_CreateFromArray(uint8_t *bytes, size_t length)
{
    Value *value = (Value *) malloc(sizeof(Value));
    value->buffer = buffer_CreateFromArray(bytes, length);
    return value;
}

int
value_Compare(Value *v1, Value *v2)
{
    return buffer_Compare(v1->buffer, v2->buffer);
}

Key *
key_CreateFromBuffer(Buffer *buffer)
{
    Key *key = (Key *) malloc(sizeof(key));
    key->buffer = buffer_Copy(buffer);
    return key;
}

int
repo_Add(Repo *repo, Key *key, Value *value)
{
    RepoEntry *entry = (RepoEntry *) malloc(sizeof(RepoEntry));
    entry->key = (Key *) malloc(sizeof(Key));
    entry->value = (Value *) malloc(sizeof(Value));

    entry->key->buffer = buffer_Copy(key->buffer);
    entry->value->buffer = buffer_Copy(value->buffer);


    // 1. Compute the hash
    uint8_t output[HASHLEN];
    memset(output, 0, HASHLEN);
    siphash(output, buffer_Overlay(entry->key->buffer), buffer_Size(entry->key->buffer), repo->key);

    // 2. Take the L(ayer) LSbs
    uint32_t bucket_id = output[0] & repo->layer; // mask out the bucket ID
    if (repoBucket_Insert(repo->buckets[bucket_id], key, value) == false) {
        // TODO: double the bucket size and then re-insert
    }

    // if (repo->head == NULL) {
    //     repo->head = entry;
    // } else {
    //     RepoEntry *curr = repo->head;
    //     while (curr->next != NULL) {
    //         curr = curr->next;
    //     }
    //     curr->next = entry;
    // }

    return 0;
}

Value *
repo_Set(Repo *repo, Key *key, Value *value)
{
    return NULL;

    // if (repo->head == NULL) {
    //     return NULL;
    // } else {
    //     RepoEntry *curr = repo->head;
    //     while (curr != NULL) {
    //         if (buffer_Compare(curr->key->buffer, key->buffer) == 0) {
    //             Value *old = curr->value;
    //
    //             curr->value->buffer = buffer_Copy(value->buffer);
    //
    //             return old;
    //         }
    //         curr = curr->next;
    //     }
    //     return NULL;
    // }
}

Value *
repo_Get(Repo *repo, Key *key)
{
    // 1. Compute the hash
    uint8_t output[HASHLEN];
    memset(output, 0, HASHLEN);
    siphash(output, buffer_Overlay(key->buffer), buffer_Size(key->buffer), repo->key);

    // 2. Index.
    uint32_t bucket_id = output[0] & repo->layer; // mask out the bucket ID
    Value *value = repoBucket_Index(repo->buckets[bucket_id], key);
    return value;
}

size_t
_getNameLength(uint8_t *buffer, size_t length)
{
    int offset = 6; // 4 for TL, 2 for T of the name
    uint16_t len = ((uint16_t)(buffer[offset]) << 8) | (uint16_t)(buffer[offset + 1]);
    return (size_t) len;
}

size_t
_getNameIndex(uint8_t *buffer, size_t length)
{
    return 8; // 8 + 4 + 4
}

size_t
_getContentHashIndex(uint8_t *buffer, size_t length) // skip past the name
{
    uint16_t typeIndex = _getNameIndex(buffer, length) + _getNameLength(buffer, length);
    uint16_t type;
    memcpy(&type, buffer + typeIndex, 2);
    if (type == 3) {
        return typeIndex + 4;
    } else if (type == 2) {
        uint16_t length;
        memcpy(&length, buffer + typeIndex + 2, 2);
        typeIndex = typeIndex + length + 4;
        memcpy(&type, &typeIndex, 2);

        if (type == 3) {
            return typeIndex + 4;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

size_t
_getContentHashLength(uint8_t *buffer, size_t length) // skip past the name
{
    int offset = _getContentHashIndex(buffer, length);
    if (offset > 0) {
        offset -= 2;
        uint16_t len = ((uint16_t)(buffer[offset]) << 8) | (uint16_t)(buffer[offset + 1]);
        return (size_t) len;
    } else {
        return 0;
    }
}

size_t
_getKeyIdIndex(uint8_t *buffer, size_t length)
{
    uint16_t typeIndex = _getNameIndex(buffer, length) + _getNameLength(buffer, length);
    uint16_t type;
    memcpy(&type, buffer + typeIndex, 2);
    if (type == 2) {
        return typeIndex + 4;
    } else {
        return -1;
    }
}

size_t
_getKeyIdLength(uint8_t *buffer, size_t length)
{
    int offset = _getContentHashIndex(buffer, length);
    if (offset > 0) {
        offset -= 2;
        uint16_t len = ((uint16_t)(buffer[offset]) << 8) | (uint16_t)(buffer[offset + 1]);
        return (size_t) len;
    } else {
        return 0;
    }
}

Buffer *
_readName(uint8_t *buffer, size_t length)
{
    size_t len = _getNameLength(buffer, length);
    Buffer *b = buffer_CreateFromArray(buffer + _getNameIndex(buffer, length), len);
    return b;
}

Buffer *
_readContentObjectHash(uint8_t *buffer, size_t length)
{
    size_t len = _getContentHashLength(buffer, length);
    if (len > 0) {
        Buffer *b = buffer_CreateFromArray(buffer + _getContentHashIndex(buffer, length), len);
        return b;
    } else {
        return NULL;
    }
}

Buffer *
_readKeyId(uint8_t *buffer, size_t length)
{
    size_t len = _getKeyIdLength(buffer, length);
    if (len > 0) {
        Buffer *b = buffer_CreateFromArray(buffer + _getKeyIdIndex(buffer, length), len);
        return b;
    } else {
        return NULL;
    }
}

int
main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "usage: repo <file>");
        exit(-1);
    }

    // 1. read in packet
    FILE *fp = fopen(argv[1], "rb");
    uint8_t buffer[1024];
    int numBytesRead = fread(buffer, 1, 1024, fp);

    // 2. extract key
    Buffer *rawKey = _readName(buffer, numBytesRead);
    Key *key = key_CreateFromBuffer(rawKey);
    buffer_Display(stdout, rawKey);

    // 3. insert into repo
    Repo *repo = repo_Create();
    Value *value1 = value_CreateFromArray(buffer, numBytesRead);
    repo_Add(repo, key, value1);
    buffer_Display(stdout, value1->buffer);

    // 4. get from repo
    Value *value2 = repo_Get(repo, key);

    // 5. Sanity check
    printf("Equal? %d\n", value_Compare(value1, value2) == 0);

    return 0;
}
