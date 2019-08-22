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
		regex="(\\${temporarySuffix}|\\${archivedSuffix})"
		if ! [[ ${contextFiles[$i]} = $currentContext || ${contextFiles[$i]} =~ $regex ]]; then
			setProperty ${contextFiles[$i]} $fileProperty ${contextFiles[$i]}
		fi
		fileWithAlias=$(formatFileWithAlias ${contextFiles[$i]})
		echo "$i - $fileWithAlias"
	done
}

function formatFileWithAlias {
	alias=$(findProperty ${1} $aliasProperty)
	result="$1"
	if [[ ! -z $alias ]]; then
		result="$result ($alias)"
	fi
	echo $result
}

function findProperty {
	fileToScan="${contextDir}/${1}"
	grep -oP "(?<=${openComment}${2}${propertySeparator}).+(?=${closeComment})" $fileToScan
}

function dropProperty {
	targetFile="${contextDir}/${1}"
	sed -i "/${openComment}${2}${propertySeparator}/d" $targetFile
}

function setProperty {
	dropProperty ${1} ${2}
	echo "${openComment}${2}${propertySeparator}${3}${closeComment}" >> $targetFile
}

function fileSelected {
	echo "The file $(formatFileWithAlias $1) has been selected"
	echo "Select an option:"
	echo "0 - Swap with ${currentContext}"
	echo "1 - Set alias"
	echo -n "Your choice: "
	read -n1 choice
	echo -e -n "\n"
	if [[ $choice = "0" ]]; then
		echo "Swapping isn't implemented yet"
	elif [[ $choice = "1" ]]; then
		echo -n "Insert an alias: "
		read newAlias
		setProperty $1 $aliasProperty "$newAlias"
		echo "Alias ${newAlias} correctly registered for file ${1}"
	fi
}

if [[ "$#" = "0" ]]; then
	echo "======================="
	echo "=== Context routine ==="
	echo "======================="
	echo "This routine is for swapping context files in $contextDir"
	echo "Select a file:"
	printContextFiles
	echo -n "Your choice: "
	read choice
	if [[ ! $choice =~ ^[0-9]+$ ]] || [[ "$choice" -lt 0 || "$choice" -gt "${#contextFiles[@]}" ]]; then
		exit 1
	fi
	fileSelected "${contextFiles[$choice]}"
fi
