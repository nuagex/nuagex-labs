#!/bin/bash

interfaces=($(ip -o link show | awk -F': ' '{print $2}' | grep ^eth[2-9][0-9]*$))
for interface in "${interfaces[@]}"; do
    tc qdisc del dev $interface root
    tc qdisc add dev $interface root netem delay 100ms 20ms distribution normal loss 0.3% 25% duplicate 1% reorder 25% 50%
done