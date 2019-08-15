#!/bin/bash
file=setenv.sh
propertiesToSearch=liquibase
commentCharacter=#
enableArgument=enable
disableArgument=disable

function loop_over_properties {
	local IFS=$'\n'
	for line in $(grep $propertiesToSearch $file)
	do
		if [[ $1 = $enableArgument ]]; then
			enable_properties $line
		elif [[ $1 = $disableArgument ]]; then
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

if [ "$#" = "0" ]; then
	echo "This routine is for enable or disable lines that contains $propertiesToSearch in file $file"
	echo "Select an option:"
	echo "0 - Enable lines"
	echo "1 - Disable lines"
	echo -n "Your choice: "
	read -n1 choice
	echo -e -n "\n"
	if [[ $choice = "0" ]]; then
		loop_over_properties $enableArgument
	elif [[ $choice = "1" ]]; then
		loop_over_properties $disableArgument
	fi
else
	loop_over_properties $1	
fi
exit 0
