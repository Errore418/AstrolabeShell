#!/bin/bash

deployTarget="/home/cnave/Documenti/Progetti/AstrolabeShell/deployFeature/deployTarget"
deployExtension=".dodeploy"
declare -A applicationDirs=( ["dummy.war"]="/home/cnave/Documenti/Progetti/AstrolabeShell/deployFeature/warDirectories/dummy.war" ["test.war"]="/home/cnave/Documenti/Progetti/AstrolabeShell/deployFeature/warDirectories/test.war" ["foobar.war"]="/home/cnave/Documenti/Progetti/AstrolabeShell/deployFeature/warDirectories/foobar.war" )

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
	regenerate_symlink
	touch "${deployTarget}/${1}${deployExtension}"
	echo "Deployed $1"
}

function print_applications {
	for i in "${!applicationNameOrdered[@]}"; do
		echo "$i - ${applicationNameOrdered[$i]}"
	done
}

function deploy_routine {
	mapfile -d '' applicationNameOrdered < <(printf "%s\\0" "${!applicationDirs[@]}" | sort -z)
	if [[ "$#" = "0" ]]; then
		echo "======================"
		echo "=== Deploy routine ==="
		echo "======================"
		echo "This routine is for deploying applications in $deployTarget"
		echo "Select an application:"
		print_applications
		echo -n "Your choice: "
		read -r choice
		if [[ $choice =~ ^[0-9]+$ && "$choice" -ge 0 && "$choice" -lt "${#applicationNameOrdered[@]}" ]]; then
			deploy_application "${applicationNameOrdered[$choice]}"
		fi
	fi
}

deploy_routine