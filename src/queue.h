#include <stdio.h>
#include <deque>
#include <thread>
#include <mutex>
#include <vector>
#include <condition_variable>

class Queue {
public:
    Queue();
    virtual ~Queue();
    void put(int id, void *item);
    void *get(int id);
private:
    std::mutex mutex;
    std::condition_variable condition;
    std::vector<void *> _buffer;
};
