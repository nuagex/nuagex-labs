#!/bin/bash

interfaces=($(ip -o link show | awk -F': ' '{print $2}' | grep ^eth[2-9][0-9]*$))
for interface in "${interfaces[@]}"; do
    tc qdisc del dev $interface root
done