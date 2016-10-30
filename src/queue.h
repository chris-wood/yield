#ifndef queue_h_
#define queue_h_

#include <stdio.h>

struct queue;
typedef struct queue Queue;

Queue *queue_Create();
void queue_Put(Queue *queue, int id, void *item);
void *queue_Get(Queue *queue, int id);

#endif // queue_h_