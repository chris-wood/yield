#include "repo.h"

#include <stdio.h>
#include <stdint.h>
#include <string.h>

struct buffer {
    uint8_t *bytes;
    uint32_t length;
};

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
    struct repo_entry *next;
} RepoEntry;

struct repo {
    RepoEntry *head;
    uint32_t numEntries;
};

Repo *
repo_Create()
{
    Repo *repo = (Repo *) malloc(sizeof(Repo));

    repo->head = NULL;
    repo->numEntries = 0;

    return repo;
}

void
buffer_Display(FILE *fp, Buffer *b)
{
    for (int i = 0; i < b->length; i++) {
        fprintf(fp, "%x", b->bytes[i]);
    }
    fprintf(fp, "\n");
}

Buffer *
buffer_CreateEmpty()
{
    Buffer *buffer = (Buffer *) malloc(sizeof(Buffer));
    buffer->length = 0;
    buffer->bytes = NULL;
    return buffer;
}

Buffer *
buffer_CreateFromArray(uint8_t *bytes, size_t length)
{
    Buffer *buffer = (Buffer *) malloc(sizeof(Buffer));
    buffer->length = length;
    buffer->bytes = (uint8_t *) malloc(length);
    memcpy(buffer->bytes, bytes, length);
    return buffer;
}

Buffer *
buffer_Copy(Buffer *copy)
{
    Buffer *buffer = (Buffer *) malloc(sizeof(Buffer));
    buffer->length = copy->length;
    buffer->bytes = (uint8_t *) malloc(copy->length);
    memcpy(buffer->bytes, copy->bytes, copy->length);
    return buffer;
}

int
buffer_Compare(Buffer *this, Buffer *other)
{
    if (other == NULL || this == NULL) {
        return -1;
    } else if (this->length > other->length) {
        return 1;
    } else if (this->length < other->length) {
        return -1;
    } else {
        return memcmp(this->bytes, other->bytes, other->length);
    }
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
add(Repo *repo, Key *key, Value *value)
{
    RepoEntry *entry = (RepoEntry *) malloc(sizeof(RepoEntry));
    entry->key = (Key *) malloc(sizeof(Key));
    entry->value = (Value *) malloc(sizeof(Value));

    entry->key->buffer = buffer_Copy(key->buffer);
    entry->value->buffer = buffer_Copy(value->buffer);

    if (repo->head == NULL) {
        repo->head = entry;
    } else {
        RepoEntry *curr = repo->head;
        while (curr->next != NULL) {
            curr = curr->next;
        }
        curr->next = entry;
    }

    return 0;
}

Value *
set(Repo *repo, Key *key, Value *value)
{
    if (repo->head == NULL) {
        return NULL;
    } else {
        RepoEntry *curr = repo->head;
        while (curr != NULL) {
            if (buffer_Compare(curr->key->buffer, key->buffer) == 0) {
                Value *old = curr->value;

                curr->value->buffer = buffer_Copy(value->buffer);

                return old;
            }
            curr = curr->next;
        }
        return NULL;
    }
}

Value *
get(Repo *repo, Key *key)
{
    if (repo->head == NULL) {
        return NULL;
    } else {
        RepoEntry *curr = repo->head;
        while (curr != NULL) {
            if (buffer_Compare(curr->key->buffer, key->buffer) == 0) {
                return curr->value;
            }
            curr = curr->next;
        }
        return NULL;
    }
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
    Buffer *b = (Buffer *) malloc(sizeof(Buffer));
    b->bytes = malloc(len);
    b->length = len;
    memcpy(b->bytes, buffer + _getNameIndex(buffer, length), len);
    return b;
}

Buffer *
_readContentObjectHash(uint8_t *buffer, size_t length)
{
    size_t len = _getContentHashLength(buffer, length);
    if (len > 0) {
        Buffer *b = (Buffer *) malloc(sizeof(Buffer));
        b->bytes = malloc(len);
        b->length = len;
        memcpy(b->bytes, buffer + _getContentHashIndex(buffer, length), len);
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
        Buffer *b = (Buffer *) malloc(sizeof(Buffer));
        b->bytes = malloc(len);
        b->length = len;
        memcpy(b->bytes, buffer + _getKeyIdIndex(buffer, length), len);
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
    add(repo, key, value1);
    buffer_Display(stdout, value1->buffer);

    // 4. get from repo
    Value *value2 = get(repo, key);

    // 5. Sanity check
    printf("Equal? %d\n", value_Compare(value1, value2) == 0);

    return 0;
}
