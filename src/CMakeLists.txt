cmake_minimum_required(VERSION 3.6)
project(src)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

set(SOURCE_FILES
    arp.c
    buffer.cpp
    buffer.h
    common.h
    constructor.cpp
    driver.cpp
    ethernet_if.cpp
    ethernet_if.h
    ethernet_wrap.cpp
    ethernet_wrap.h
    hashmap.cpp
    hashmap.h
    parser.cpp
    parser.h
    pktgen.cpp
    pktgen.h
    pktgen_main.cpp
    queue.cpp
    queue.h
    repo.cpp
    repo.h
    ringbuffer.cpp
    sds_lib.h
    siphash24.c
    yield.cpp
    yield.h
    yield_main.cpp)

add_executable(src ${SOURCE_FILES})