#!/bin/bash

echo "Command 2 - 1"
echo "Command 2 - 2"
sleep 1
echo "Command 2 - 3"
echo "Command 2 - 4"
sleep 1
echo "Command 2 - 5"
if [[ -z $1 ]]; then
	exit 0
else
	exit 1
fi