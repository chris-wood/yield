#!/bin/bash

URI_FILE=$1
INT_FILE=$2
DATA_FILE=$3

### flag for COMPUTE_HASH
### param for DATA_SIZE

# 1. for each line in URI_FILE
# 2. create data packet with the name and data size
# 3. compute hash of the packet
# 4. create interest with the same name and hash
