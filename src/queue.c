#include <stdlib.h>

#include "queue.h"

typedef struct {
    int id;
    void *item;
} QueueEntry;

struct queue {
    int numEntries;
    QueueEntry **entries;
};

Queue *
queue_Create()
{
    Queue *queue = (Queue *) malloc(sizeof(Queue));
    queue->numEntries = 0;
    queue->entries = NULL;
}

void
queue_Put(Queue *queue, int id, void *item)
{
    QueueEntry *entry = (QueueEntry *) malloc(sizeof(QueueEntry));
    entry->id = id;
    entry->item = item;

    queue->numEntries++;
    if (queue->entries == NULL) {
        queue->entries = (QueueEntry **) malloc((queue->numEntries) * sizeof(QueueEntry *));
    } else {
        queue->entries = (QueueEntry **) realloc(queue->entries, (queue->numEntries) * sizeof(QueueEntry *));
    }

    queue->entries[queue->numEntries - 1] = entry;
}

void *
queue_Get(Queue *queue, int id)
{
    for (int i = 0; i < queue->numEntries; i++) {
        QueueEntry  *entry = queue->entries[i];
        if (entry->id == id) {

        }
    }
    return NULL;
}
