#!/bin/bash

source variables.sh

### TOGGLE ROUTINE ###

function loop_over_lines {
	while IFS= read -r line
	do
		if [[ $1 = "$enableArgument" ]]; then
			enable_line "$line"
		elif [[ $1 = "$disableArgument" ]]; then
			disable_line "$line"
		fi
	done < <(grep "$stringToSearch" "$toggleFile")
}

function enable_line {
	if [[ $1 =~ $commentCharacter ]]; then
		stringToInsert="${line//$commentCharacter}"
		change_line "$line" "$stringToInsert" "Enabled line"
	fi
}

function disable_line {
	if [[ ! $1 =~ $commentCharacter ]]; then
		stringToInsert="${commentCharacter}${line}"
		change_line "$line" "$stringToInsert" "Disabled line"
	fi
}

function change_line {
	sed -i "s/${1}/${2}/g" "$toggleFile"
	echo "$3 $1"
}

function toggle_routine {
	if [[ "$#" = "0" ]]; then
		echo "======================"
		echo "=== Toggle routine ==="
		echo "======================"
		echo "This routine is for enabling or disabling lines that contain $stringToSearch in file $toggleFile"
		echo "Select an option:"
		echo "0 - Enable lines"
		echo "1 - Disable lines"
		echo -n "Your choice: "
		read -r -n1 choice
		echo -e -n "\\n"
		if [[ $choice = "0" ]]; then
			loop_over_lines $enableArgument
		elif [[ $choice = "1" ]]; then
			loop_over_lines $disableArgument
		fi
	else
		loop_over_lines "$1"
	fi
}

### CONTEXT ROUTINE ###

function print_context_files {
	for i in "${!contextFiles[@]}"; do
		regex="(\\${temporarySuffix}|\\${archivedSuffix})"
		if ! [[ "${contextFiles[$i]}" = "$currentContext" || "${contextFiles[$i]}" =~ $regex ]]; then
			set_property "${contextFiles[$i]}" $fileProperty "${contextFiles[$i]}"
		fi
		fileWithAlias=$(format_file_with_alias "${contextFiles[$i]}")
		if [[ "${contextFiles[$i]}" = "$currentContext" ]]; then
			oldName=$(find_property "${contextFiles[$i]}" $fileProperty)
			fileWithAlias=$(append_if_not_null "${fileWithAlias}" "${oldName}")
		fi
		echo "$i - $fileWithAlias"
	done
}

function format_file_with_alias {
	alias=$(find_property "${1}" $aliasProperty)
	append_if_not_null "${1}" "$alias"
}

function append_if_not_null {
	result="$1"
	if [[ ! -z $2 ]]; then
		result="$result ($2)"
	fi
	echo "$result"
}

function find_property {
	fileToScan="${contextDir}/${1}"
	grep -oP "(?<=${openComment}${2}${propertySeparator}).+(?=${closeComment})" "$fileToScan"
}

function drop_property {
	targetFile="${contextDir}/${1}"
	sed -i "/${openComment}${2}${propertySeparator}.*${closeComment}/d" "$targetFile"
}

function set_property {
	drop_property "${1}" "${2}"
	echo "${openComment}${2}${propertySeparator}${3}${closeComment}" >> "$targetFile"
}

function acquire_alias {
	echo -n "Insert an alias: "
	read -r newAlias
	set_property "$1" $aliasProperty "$newAlias"
	echo "Alias ${newAlias} correctly registered for file ${1}"
}

function swap_files {
	tempFile="${currentContext}${temporarySuffix}"
	archivedFile=$(find_property "$currentContext" $fileProperty)
	if [[ -z $archivedFile ]]; then
		archivedFile="${currentContext}${archivedSuffix}"
	fi
	rename_file "$currentContext" "$tempFile"
	rename_file "$1" "$currentContext"
	rename_file "$tempFile" "$archivedFile"
	echo "Swapping completed"
}

function rename_file {
	oldFile="${contextDir}/${1}"
	newFile="${contextDir}/${2}"
	mv "$oldFile" "$newFile"
	echo "Renamed $1 to $2"
}

function file_selected {
	echo "The file $(format_file_with_alias "$1") has been chosen"
	echo "Select an option:"
	echo "0 - Swap with ${currentContext}"
	echo "1 - Set alias"
	echo -n "Your choice: "
	read -r -n1 choice
	echo -e -n "\\n"
	if [[ $choice = "0" && "$1" != "$currentContext" ]]; then
		swap_files "$1"
	elif [[ $choice = "1" ]]; then
		acquire_alias "$1"
	fi
}

function context_routine {
	mapfile -d '' contextFiles < <(find "$contextDir" -maxdepth 1 -type f -printf "%f\\0" | sort -z)
	if [[ "$#" = "0" ]]; then
		echo "======================="
		echo "=== Context routine ==="
		echo "======================="
		echo "This routine is for swapping context files in $contextDir"
		echo "Select a file:"
		print_context_files
		echo -n "Your choice: "
		read -r choice
		if [[ $choice =~ ^[0-9]+$ && "$choice" -ge 0 && "$choice" -lt "${#contextFiles[@]}" ]]; then
			file_selected "${contextFiles[$choice]}"
		fi
	fi
}

### VERSION ROUTINE ###

function version_routine {
	echo "TomcatSupport version ${version}"
}

### WELCOME ROUTINE ###

if [[ "$#" = "0" ]]; then
	echo "================================"
	echo "=== Welcome in TomcatSupport ==="
	echo "================================"
	echo "Select an option:"
	echo "0 - Enable or disable lines"
	echo "1 - Swap context files"
	echo "2 - Display current version"
	echo -n "Your choice: "
	read -r -n1 choice
	echo -e -n "\\n"
	if [[ $choice = "0" ]]; then
		toggle_routine
	elif [[ $choice = "1" ]]; then
		context_routine
	elif [[ $choice = "2" ]]; then
		version_routine
	fi
elif [[ $1 = "$toggleRoutineArgument" ]]; then
	toggle_routine "$2"
elif [[ $1 = "$contextRoutineArgument" ]]; then
	context_routine
elif [[ $1 = "$versionArgument" ]]; then
	version_routine
fi
exit 0
