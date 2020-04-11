#!/bin/bash

while true; do
    filename="out-$(date +%Y-%m-%dT%H:%M:%S).csv"
    echo "getting $filename"
    /usr/local/bin/rtl_433 -T 86400 -F "csv:$filename"
done

