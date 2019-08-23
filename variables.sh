#!/bin/bash

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
version=1.0

function checkVariable {	
	if [[ -z "${1}" ]]; then
		echo "Variable ${2} is not set"
		exit 1
	fi
}

checkVariable "${toggleFile}" "toggleFile"
checkVariable "${contextDir}" "contextDir"
checkVariable "${currentContext}" "currentContext"
