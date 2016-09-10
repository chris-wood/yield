FLAGS=LOCAL
yield-main:
	clang++ -std=c++11 -o yield yield_main.cpp yield.cpp repo.cpp parser.cpp ethernet_if.cpp ethernet_wrap.cpp buffer.cpp queue.cpp -D${FLAGS}

pktgen-main:
	clang++ -std=c++11 -o pktgen pktgen.cpp ethernet_wrap.cpp buffer.cpp queue.cpp -D${FLAGS}

driver-main: driver.cpp
	clang++ -std=c++11 -o driver driver.cpp pktgen.cpp yield.cpp ethernet_if.cpp ethernet_wrap.cpp queue.cpp repo.cpp parser.cpp buffer.cpp -D${FLAGS} -lpthread

all: yield pktgen
