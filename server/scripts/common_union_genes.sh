#!/bin/bash

f1=$1
f2=$2

join <(sort $f1 | awk '{print $1, $4}') <(sort $f2 | awk '{print $1, $4}') -j1
