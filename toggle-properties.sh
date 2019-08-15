#!/bin/bash
file=setenv.sh
propertiesToSearch=liquibase
commentCharacter=#

function loop_over_properties {
	local IFS=$'\n'
	for line in $(grep $propertiesToSearch $file)
	do
		if [[ $1 = "enable" ]]; then
			enable_properties $line
		elif [[ $1 = "disable" ]]; then
			disable_properties $line
		fi
	done
}

function enable_properties {
	if [[ $1 =~ $commentCharacter ]]; then
		stringToInsert="${line//$commentCharacter}"
		change_properties $line $stringToInsert "Enabled line"
	fi
}

function disable_properties {
	if [[ ! $1 =~ $commentCharacter ]]; then
		stringToInsert="${commentCharacter}${line}"
		change_properties $line $stringToInsert "Disabled line"
	fi
}

function change_properties {
	sed -i "s/${1}/${2}/g" "$file"
	echo "$3 $1"
}

loop_over_properties $1

exit 0
