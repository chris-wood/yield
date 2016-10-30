cmake_minimum_required(VERSION 3.6)
project(src)

set(CMAKE_C_STANDARD C99)

set(YIELD_SOURCES
        yield_main.c
        yield.c
        repo.c
        parser.c
        ethernet_if.c
        ethernet_wrap.c
        buffer.c
        queue.c)

set(DRIVER_SOURCES
        driver.c
        yield.c
        ethernet_if.c
        ethernet_wrap.c
        queue.c
        repo.c
        parser.c
        buffer.c)

add_executable(yield ${YIELD_SOURCES})
#add_executable(pktgen ${PKTGEN_SOURCES})
add_executable(driver ${DRIVER_SOURCES})
