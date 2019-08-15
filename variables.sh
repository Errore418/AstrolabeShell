#!/bin/bash

#file=PATH TO FILE

stringToSearch=liquibase
commentCharacter=#

if [[ -z "$file" ]]; then
	echo "Variable \"file\" is not set"
	exit 1
fi
