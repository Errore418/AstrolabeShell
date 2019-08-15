#!/bin/bash
file=setenv.sh
propertiesToSearch=liquibase
commentCharacter=#


IFS=$'\n'
for line in $(grep $propertiesToSearch $file)
do
	if [[ $line =~ $commentCharacter ]]; then
		stringToInsert="${line//$commentCharacter}"
		echo "Enabled line $line"
	else
		stringToInsert="${commentCharacter}${line}"
		echo "Disabled line $line"
	fi
	sed -i "s/${line}/${stringToInsert}/g" "$file"
done
