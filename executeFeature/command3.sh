#!/bin/bash

echo "Command 3 - 1"
echo "Command 3 - 2"
sleep 1
echo "Command 3 - 3"
echo "Command 3 - 4"
sleep 1
echo "Command 3 - 5"
if [[ -z $1 ]]; then
	exit 0
else
	exit 1
fi