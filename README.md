# yield

# Motivational questions

- Why run over Ethernet instead of over IP? 
    - Drop in packet cache on the line?

# Questions

- What kind of speedup can we get with an FPGA CS over a software CS?
    - We would need to implement a high-performance CS in DPDK or netmap
- What metrics are we actually interested in?
    - Throughput
    - "Lookup" latency (time from request in to response out)
- Can we speed up fragmentation?
    - We would need to either pre-fragment content to the MTU size (preferred) or perform fragmentation on the fly (not preferred)
- Can we speed up encryption?  
    - Interest names would contain the encryption info, e.g., session ID, sequence number, etc.
    - The KVS would use that to lookup the encryption key and then perform encryption

# References

- http://cial.csie.ncku.edu.tw/presentation/group_pdf/(FPL%202013)%20A%20high-performance%20IPV6%20lookup%20engine%20on%20FPGA.pdf
- http://front.sjtu.edu.cn/~jinyh/gradCourse/Paper/Network%20Algorithmics%20and%20Economics/Poptrie%20A%20Compressed%20Trie%20with%20Population%20Count%20for%20Fast%20and%20Scalable%20Software%20IP%20Routing%20Table%20Lookup.pdf
- http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.294.4720&rep=rep1&type=pdf
- http://cial.csie.ncku.edu.tw/presentation/group_pdf/(TON%202012)%20FlashTrie%20Beyond%20100-Gbs%20IP%20Route%20Lookup%20Using%20Hash-Based%20Prefix-Compressed%20Trie.pdf
- http://www.eecs.harvard.edu/~kirsch/pubs/hashing_hardware/ton.pdf


memcached-related papers:
- http://people.inf.ethz.ch/zistvan/doc/paperM3C_3.pdf
- http://web.eecs.umich.edu/~twenisch/papers/isca13.pdf