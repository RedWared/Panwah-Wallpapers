#!/bin/bash

# This script is made by Isaac David Orozco Delgado
# https://github.com/Reisy243

R='\e[0;31m'
G='\e[0;32m'
Y='\e[1;33m'
RS='\e[0m'

ERROR(){
	printf "${R}ERROR: ${RS}$1,${R} Aborting...${RS}\n"
	exit $2
}

INFO(){
	printf "${G}INFO: ${RS}$1"
}

WARN(){
	printf "${Y}WARN: ${RS}$1\n"
}

cmdChk() {
	if ! cmd=$(command -v "$1" 2>/dev/null); then
		ERROR "$1 not found" 1
	else
		printf "$1: ${G}found... ${RS}$cmd\n"
	fi
}

if ! [ "$0" = "./WallPack.sh" ]; then
	ERROR "Go to script directory for compile" 2
fi

sha256_enable=false
tgz_enable=false

tarName="Panwah-Wallpapers.tar"

cmdChk inkscape
cmdChk dirname

for cmd in $@; do
	if [ "$cmd" == "--sha256sums" ]; then
		cmdChk sha256sum
		sha256_enable=true
		if [ -f SHA256sums.txt ]; then
			rm SHA256sums.txt
		fi
	fi

	if [ "$cmd" = "--packtargz" ]; then
		cmdChk tar
		cmdChk gzip
		cmdChk fakeroot
		tgz_enable=true
		if [ -f "$tarName" ]; then
			rm $tarName
		fi
		if [ -f "${tarName}.gz" ]; then
			rm ${tarName}.gz
		fi
		fakeroot tar --append -f $tarName LICENSE
	fi
done

width=(1920 1336 1280)
height=(1080 768 720)

mkwahExport(){
	for ((num_res=0; num_res<${#width[@]}; num_res++)); do
		if [ -f "$1/Wah-$2-${width[$num_res]}x${height[$num_res]}.png" ]; then
			ERROR "$1/Wah-$2-${width[$num_res]}x${height[$num_res]}.png is already exported, you need delete *.png files for execute this script" 3
		else
			INFO "Exporting $1/Wah-$2.svg as $1/Wah-$2-${width[$num_res]}x${height[$num_res]}.png... "
			inkscape $1/Wah-$2.svg --export-filename="$1/Wah-$2-${width[$num_res]}x${height[$num_res]}.png" --export-width=${width[$num_res]} --export-height=${height[$num_res]}
			echo "done"
			if [ $sha256_enable = true ]; then
				INFO "Generating SHA256 sum for $1/Wah-$2-${width[$num_res]}x${height[$num_res]}.png... "
				sha256sum "$1/Wah-$2-${width[$num_res]}x${height[$num_res]}.png" >> SHA256sums.txt
				echo "done"
			fi
			if [ $tgz_enable = true ]; then
				INFO "Compresing $1/Wah-$2-${width[$num_res]}x${height[$num_res]}.png in $tarName... "
				fakeroot tar --append -f $tarName "$1/Wah-$2-${width[$num_res]}x${height[$num_res]}.png"
				echo "done"
			fi
		fi
	echo ""
	done
}

postmkwahExport(){
	if [ $tgz_enable = true ]; then
		if [ $sha256_enable = true ]; then
			INFO "Compresing SHA256sums.txt in $tarName... "
			fakeroot tar --append -f $tarName "SHA256sums.txt"
			echo "done"
		fi
		INFO "Compresing $tarName in ${tarName}.gz... "
		gzip -f $tarName
		echo "done"
	fi
}

mkwahExport Simple Simple
mkwahExport Simple Simple-Dark

postmkwahExport

INFO "All background(s) are exported successfully.\n"
