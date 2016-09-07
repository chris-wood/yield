#include <stdio.h>
#include <deque>
#include <vector>

class Queue {
public:
    Queue();
    virtual ~Queue();
    void put(int id, void *item);
    void *get(int id);
    std::vector<void *> _buffer;
};
