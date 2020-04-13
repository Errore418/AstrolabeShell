#!/bin/bash

#	Copyright (C) 2019 Claudio Nave
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

#toggleFile=PATH TO TOGGLE FILE

stringToSearch=liquibase
commentCharacter=#

### CONTEXT VARIABLES ###

#contextDir=PATH TO CONTEXT DIRECTORY
#currentContext=NAME OF CURRENT CONTEXT

archivedSuffix=.archived
temporarySuffix=.temp
openComment="<!--"
closeComment="-->"
aliasProperty=ALIAS
fileProperty=FILE
propertySeparator=:

### SYSTEM VARIABLES ###

toggleRoutineArgument=toggle
contextRoutineArgument=context
versionArgument=version
enableArgument=enable
disableArgument=disable
version=1.1

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

collectErrors "toggleFile" "contextDir" "currentContext"
printErrors
