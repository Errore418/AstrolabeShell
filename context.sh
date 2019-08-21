#!/bin/bash

contextDir=./localhost
currentContext=test.xml
archivedSuffix=.archived
temporarySuffix=.temp
openComment="<!--"
closeComment="-->"
aliasProperty=ALIAS
fileProperty=FILE
propertySeparator=:

contextFiles=($(ls $contextDir))

function printContextFiles {
	for i in "${!contextFiles[@]}"; do
		alias=$(findPropertyValue ${contextFiles[$i]} $aliasProperty)
		result="$i - ${contextFiles[$i]}"
		if [[ ! -z $alias ]]; then
			result="$result ($alias)"
		fi
		echo $result
	done
}

function findPropertyValue {
	fileToScan="${contextDir}/${1}"
	grep -oP "(?<=${2}${propertySeparator}).+(?=${closeComment})" $fileToScan
}

if [[ "$#" = "0" ]]; then
	echo "======================="
	echo "=== Context routine ==="
	echo "======================="
	echo "This routine is for swap context files in $contextDir"
	echo "Select a file:"
	printContextFiles
	echo -n "Your choice: "
	read choice
	echo "${contextFiles[$choice]}"
fi
