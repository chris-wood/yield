#!/bin/bash

URI_FILE=$1
INT_FILE=${URI_FILE}.int
DATA_FILE=${URI_FILE}.data

INTEREST_BUILDER=$2
CONTENT_BUILDER=$3
CONTENT_SIZE=$4

### flag for COMPUTE_HASH
### param for DATA_SIZE

while read l; do
    if [ ${#l} -ne 0 ]; then
        echo $l

        # - create data packet with the name and data size
        ${CONTENT_BUILDER} $l ${CONTENT_SIZE} > tmp.data

        # - compute hash of the packet
        dissect -i tmp.data -d SHA256 > tmp.hash

        # - create interest with the same name and hash
        ${INTEREST_BUILDER} $l "" `cat tmp.hash` > tmp.int

        cat tmp.int >> ${INT_FILE}
        cat tmp.data >> ${DATA_FILE}

        rm -rf tmp.data
        rm -rf tmp.hash
    fi
done < $URI_FILE

