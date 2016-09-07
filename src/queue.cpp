#include <stdlib.h>

#include "queue.h"

typedef struct {
    int id;
    void *item;
} QueueEntry;

Queue::Queue()
{
    // empty
}

Queue::~Queue()
{
    // empty
}

void
Queue::put(int id, void *item)
{
    QueueEntry *entry = (QueueEntry *) malloc(sizeof(QueueEntry));
    entry->id = id;
    entry->item = item;

    _buffer.push_back(entry);
}

void *
Queue::get(int id)
{
    for (std::vector<void*>::iterator itr = _buffer.begin(); itr != _buffer.end(); itr++) {
        QueueEntry *entry = (QueueEntry* )*itr;
        if (entry->id == id) {
            _buffer.erase(itr);
            return entry->item;
        }
    }
    return NULL;
}
