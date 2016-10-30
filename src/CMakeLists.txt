cmake_minimum_required(VERSION 3.6)
project(src)

set(CMAKE_C_STANDARD C99)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES
    arp.c
    buffer.c
    buffer.h
    common.h
    constructor.c
    driver.c
    ethernet_if.c
    ethernet_if.h
    ethernet_wrap.c
    ethernet_wrap.h
    hashmap.c
    hashmap.h
    parser.c
    parser.h
    pktgen.c
    pktgen.h
    pktgen_main.c
    queue.c
    queue.h
    repo.c
    repo.h
    ringbuffer.c
    sds_lib.h
    siphash24.c
    yield.c
    yield.h
    yield_main.c)

add_executable(src ${SOURCE_FILES})