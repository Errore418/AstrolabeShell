#!/bin/bash
source variables.sh

enableArgument=enable
disableArgument=disable

function loop_over_lines {
	local IFS=$'\n'
	for line in $(grep $stringToSearch $file)
	do
		if [[ $1 = $enableArgument ]]; then
			enable_line $line
		elif [[ $1 = $disableArgument ]]; then
			disable_line $line
		fi
	done
}

function enable_line {
	if [[ $1 =~ $commentCharacter ]]; then
		stringToInsert="${line//$commentCharacter}"
		change_properties $line $stringToInsert "Enabled line"
	fi
}

function disable_line {
	if [[ ! $1 =~ $commentCharacter ]]; then
		stringToInsert="${commentCharacter}${line}"
		change_properties $line $stringToInsert "Disabled line"
	fi
}

function change_properties {
	sed -i "s/${1}/${2}/g" "$file"
	echo "$3 $1"
}

function lines_routine {
	if [ "$#" = "0" ]; then
		echo "This routine is for enable or disable lines that contains $stringToSearch in file $file"
		echo "Select an option:"
		echo "0 - Enable lines"
		echo "1 - Disable lines"
		echo -n "Your choice: "
		read -n1 choice
		echo -e -n "\n"
		if [[ $choice = "0" ]]; then
			loop_over_lines $enableArgument
		elif [[ $choice = "1" ]]; then
			loop_over_lines $disableArgument
		fi
	else
		loop_over_lines $1
	fi
}

if [ "$#" = "0" ]; then
	echo "================================"
	echo "=== Welcome in TomcatSupport ==="
	echo "================================"
	echo "Select an option:"
	echo "0 - Enable or disable lines"
	echo -n "Your choice: "
	read -n1 choice
	echo -e "\n"
	if [[ $choice = "0" ]]; then
		lines_routine
	fi
fi
exit 0
