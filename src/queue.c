#include <stdlib.h>

#include "queue.h"

struct queue_entry;

typedef struct queue_entry {
    int id;
    void *item;
    struct queue_entry *next;
} QueueEntry;

struct queue {
    QueueEntry *head;
};

Queue *
queue_Create()
{
    Queue *queue = (Queue *) malloc(sizeof(Queue));
    queue->head = NULL;
}

void
queue_Put(Queue *queue, int id, void *item)
{
    QueueEntry *entry = (QueueEntry *) malloc(sizeof(QueueEntry));
    entry->id = id;
    entry->item = item;
    entry->next = NULL;

    if (queue->head == NULL) {
        queue->head = entry;
        return;
    }

    QueueEntry *curr = queue->head;
    QueueEntry *prev = NULL;
    while (curr != NULL) {
        prev = curr;
        curr = curr->next;
    }
    prev->next = entry;
}

void *
queue_Get(Queue *queue, int id)
{
    if (queue->head == NULL) {
        return NULL;
    }

    QueueEntry *curr = queue->head;
    if (curr->next == NULL) {
        if (curr->id == id) {
            return curr->item;
        } else {
            return NULL;
        }
    }

    QueueEntry *prev = NULL;
    while (curr != NULL && curr->id != id) {
        prev = curr;
        curr = curr->next;
    }

    if (curr == NULL) {
        return NULL;
    } else {
        prev->next = curr->next;
        void *item = curr->item;

        // XXX: release the memory for the current one here
        // free(curr);

        return item;
    }

    return NULL;
}
