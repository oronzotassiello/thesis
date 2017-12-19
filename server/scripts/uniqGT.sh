#!/bin/bash

zcat ~/rnz/myout/0555/myGT/*.gz | sort | uniq -c > ~/rnz/myout/0555/myGT/uniqGT.out & \
zcat ~/rnz/myout/555/myGT/*.gz | sort | uniq -c > ~/rnz/myout/555/myGT/uniqGT.out & \
zcat ~/rnz/myout/155/myGT/*.gz | sort | uniq -c > ~/rnz/myout/155/myGT/uniqGT.out
