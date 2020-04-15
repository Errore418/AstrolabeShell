#!/bin/bash

echo "Command 1 - 1"
echo "Command 1 - 2"
sleep 1
echo "Command 1 - 3"
echo "Command 1 - 4"
sleep 1
echo "Command 1 - 5"
if [[ -z $1 ]]; then
	exit 0
else
	exit 1
fi