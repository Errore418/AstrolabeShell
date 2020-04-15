#!/bin/bash

declare -A commands
commands["Command 1"]="/home/cnave/Documenti/Progetti/AstrolabeShell/executeFeature/command1.sh"
commands["Command 2"]="/home/cnave/Documenti/Progetti/AstrolabeShell/executeFeature/command2.sh"
commands["Command 3"]="/home/cnave/Documenti/Progetti/AstrolabeShell/executeFeature/command3.sh"

mapfile -d '' commandNameOrdered < <(printf "%s\\0" "${!commands[@]}" | sort -z)

function check_range {
	for index in "${orderedArray[@]}"; do
		if [[ "$index" -ge "${#commandNameOrdered[@]}" ]]; then
			echo "$index is out of range"
			exit 1
		fi
	done
}

function execute_commands {
	mapfile -td '-' orderedArray < <(echo -n "$1")
	check_range
	for index in "${orderedArray[@]}"; do
		commandName=${commandNameOrdered[$index]}
		echo "==================== Execute $commandName ===================="
		eval "${commands[$commandName]}"
		if [[ $? == "0" ]]; then
			echo "$commandName executed successfully"
		else
			echo "$commandName execution failed"
			exit 1
		fi
	done
}

for i in "${!commandNameOrdered[@]}"; do
	echo "$i - ${commandNameOrdered[$i]}"
done
echo -n "Your choice: "
read -r choice
if [[ $choice =~ ^([0-9]+[-]?)+$ ]]; then
	echo $choice
	execute_commands "$choice"
fi