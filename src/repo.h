// set, add, and fetch

#include <stdlib.h>
#include <stdint.h>

#include "buffer.h"

struct repo;
typedef struct repo Repo;

struct key;
typedef struct key Key;

struct value;
typedef struct value Value;

Value *set(Repo *repo, Key *key, Value *value);
int add(Repo *repo, Key *key, Value *value);
Value *get(Repo *repo, Key *key);

int addSession(Repo *repo, Buffer *sessionId, Buffer *key);
