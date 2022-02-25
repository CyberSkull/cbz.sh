#! /bin/zsh
# Usage: Zips given directories into .cbz (Comic Book ZIP) archives of the smame name (eg "folder name.cbz").

complete="/System/Applications/Music.app/Contents/Resources/complete.aif"
remove_flag="m"
recursive_flag="r"
test_flag="T"
symlink_flag="y"
compression="9"
open_flag="false"

while getopts "kho" flag
do
	case $flag in
	"k")	#clears remove flag
		echo "Keeping originals."
		remove_flag=""
		;;
	"h")	#print usage
		echo "USAGE: cbz [-k][-h] DIRECTORY…"
		echo "-h print this help screen"
		echo "-k keep originals"
		#echo "-o output directory"
		exit 0
		;;
	esac
done

for target in "$@"
do
	if [[ -e $target ]]	#exists
	then
		if [[ -r $target ]]	#readable
		then
			if [[ -d $target ]]	#directory
			then
				archive=${target%/}
				echo "Archiving: $target"
				echo "zip -$remove_flag$recursive_flag$test_flag$symlink_flag$compression \"$archive.cbz\" \"$target\" -x \"*.DS_Store\" \"*[Tt]humbs.db\""
				# -m delete originals, -r recursive, -T test zip, -y store symlink, -9 maximum compression, -x exclude list
				zip -"$remove_flag$recursive_flag$test_flag$symlink_flag$compression" "$archive.cbz" "$target" -x "*.DS_Store" "*[Tt]humbs.db"
			else
				echo "Not a directory: $target"
			fi	#-d
		else
			echo "Not readable: $target"
		fi #-r
	else
		echo "Not found: $target"
	fi	#-e
done

#When done play the iTunes done sound.
if [[ -e $complete && -r $complete ]]
then
	afplay "$complete"
else
	echo "Sorry, the complete sound \"$complete\" could not be found or read."
fi
