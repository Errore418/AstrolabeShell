#!/bin/bash

deployTarget="/home/cnave/Documenti/Progetti/AstrolabeShell/deployFeature/deployTarget"
deployExtension=".dodeploy"
declare -A applicationDirs
applicationDirs["dummy.war"]="/home/cnave/Documenti/Progetti/AstrolabeShell/deployFeature/warDirectories/dummy.war"
applicationDirs["test.war"]="/home/cnave/Documenti/Progetti/AstrolabeShell/deployFeature/warDirectories/test.war"
applicationDirs["foobar.war"]="/home/cnave/Documenti/Progetti/AstrolabeShell/deployFeature/warDirectories/foobar.war"

function regenerate_symlink {
	for applicationName in "${!applicationDirs[@]}"; do
		fileToCheck="${deployTarget}/${applicationName}"
		if [[ ! -L $fileToCheck ]]; then
			ln -s "${applicationDirs[$applicationName]}" "$fileToCheck"
			echo "Symlink regenerated for ${applicationName}"
		fi
	done
}

function deploy_application {
	find "$deployTarget" -maxdepth 1 -type f -delete
	regenerate_symlink
	touch "${deployTarget}/${1}${deployExtension}"
	echo "Deployed application $1"
}

function deploy_routine {
	mapfile -d '' applicationNameOrdered < <(printf "%s\\0" "${!applicationDirs[@]}" | sort -z)
	if [[ "$#" = "0" ]]; then
		echo "======================"
		echo "=== Deploy routine ==="
		echo "======================"
		echo "This routine is for deploying applications in $deployTarget"
		echo "Select an application:"
		for i in "${!applicationNameOrdered[@]}"; do
			echo "$i - ${applicationNameOrdered[$i]}"
		done
		echo -n "Your choice: "
		read -r choice
		if [[ $choice =~ ^[0-9]+$ && "$choice" -ge 0 && "$choice" -lt "${#applicationNameOrdered[@]}" ]]; then
			deploy_application "${applicationNameOrdered[$choice]}"
		fi
	fi
}

deploy_routine