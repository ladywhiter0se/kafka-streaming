#!/bin/bash

sleep 20s;

for cmd in "$@"; do {
    echo "Process \"$cmd\" started";
    $cmd & pid=$!
    PID_LIST+=" $pid";
} done

trap "kill $PID_LIST" SIGINT

echo "Parallel process have started";

wait $PID_LIST;

echo
echo "All processes have completed";
