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
    std::unique_lock<std::mutex> lock(mutex);
        
    QueueEntry *entry = (QueueEntry *) malloc(sizeof(QueueEntry));
    entry->id = id;
    entry->item = item;

    _buffer.push_back(entry);

    lock.unlock();
}

void *
Queue::get(int id)
{
    while (true) {
        std::unique_lock<std::mutex> lock(mutex);
        condition.wait(lock, [this](){ return _buffer.size() > 0; });

        for (std::vector<void*>::iterator itr = _buffer.begin(); itr != _buffer.end(); itr++) {
            QueueEntry *entry = (QueueEntry* )*itr;
            if (entry->id == id) {
                // return it
                _buffer.erase(itr);
                lock.unlock();
                condition.notify_all();
                return entry;
            }
        }
        lock.unlock();
        condition.notify_all();
    }
    return NULL;
}
