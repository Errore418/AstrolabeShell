#!/bin/bash

#	Copyright (C) 2019 2020 Claudio Nave
#
#	This file is part of AstrolabeShell.
#
#	AstrolabeShell is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	AstrolabeShell is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program.  If not, see <https://www.gnu.org/licenses/>.

### TOGGLE VARIABLES ###

#toggleFile="PATH TO TOGGLE FILE"

stringToSearch=liquibase
commentCharacter=#

### CONTEXT VARIABLES ###

#contextDir="PATH TO CONTEXT DIRECTORY"
#currentContext="NAME OF CURRENT CONTEXT"

archivedSuffix=.archived
temporarySuffix=.temp
openComment="<!--"
closeComment="-->"
aliasProperty=ALIAS
fileProperty=FILE
propertySeparator=:

### DEPLOY VARIABLES ###

#deployDir="PATH TO DEPLOY DIRECTORY"
#declare -A applicationDirs
#applicationDirs["APPLICATION NAME 1"]="PATH TO APPLICATION DIRECTORY 1"
#applicationDirs["APPLICATION NAME 2"]="PATH TO APPLICATION DIRECTORY 2"
#...

deployExtension=.dodeploy

### EXECUTE VARIABLES ###

#declare -A commands
#commands["COMMAND NAME 1"]="COMMAND 1"
#commands["COMMAND NAME 2"]="COMMAND 2"
#...

### SYSTEM VARIABLES ###

toggleRoutineArgument=--toggle
contextRoutineArgument=--context
deployRoutineArgument=--deploy
executeRoutineArgument=--execute
versionArgument=--version
enableArgument=enable
disableArgument=disable
version=1.2

### CHECK VARIABLES ROUTINE ###

function collectErrors {
	msgErrors=()
	for var in "$@"; do
		if [[ -z "${!var}" ]]; then
			msgError+=("Error: variable ${var} is not set")
		fi
	done
}

function printErrors {
	if [[ "${#msgError[@]}" -gt "0" ]]; then
		printf '%s\n' "${msgError[@]}"
		exit 1
	fi
}

collectErrors "toggleFile" "contextDir" "currentContext" "deployDir" "applicationDirs" "commands"
printErrors