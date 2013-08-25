#! /bin/bash
# Usage: Zips given directories into .cbz (Comic Book ZIP) archives of the smame name (eg "folder name.cbz").

complete="/Applications/iTunes.app/Contents/Resources/complete.aif"
remove_flag="m"
recursive_flag="r"
test_flag="T"
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
		echo "USAGE: cbz [-k][-h] DIRECTORY ..."
		echo "-h print this help screen"
		echo "-k keep originals"
		exit 0
		;;
#		"o")
#			open_flag="true"
#			;;
	esac
done

#exec > >( lolcat )			# send stdout to lolcat
#exec 2>&1					# merge stderr into stdout

echo "Running: zip -$remove_flag$recursive_flag$test_flag$compression out.cbz in -x *.DS_Store *[Tt]humbs.db"

for target in "$@"
do
	if [[ -e $target ]]
	then
		if [[ -d $target ]]
		then
			echo "Archiving \"$target\""
			# -m delete originals, -r recursive, -T test zip, -9 maximum compression, -x exclude list
			zip -"$remove_flag$recursive_flag$test_flag$compression" "$target.cbz" "$target" -x "*.DS_Store" "*[Tt]humbs.db"
			
#				if [[ $open_flag == "true" ]]
#				then
#					echo "Opening $target.cbz"
#					open "$target.cbz"
#				fi
			
		else
			echo "\"$target\" is not a directory or not readable. Skipping."
		fi #-d
	else
		echo "\"$target\" does not exist."
	fi
done

#When done play the iTunes done sound.
if [[ -e $complete && -r $complete ]]
then
	afplay "$complete"
else
	echo "Sorry, the complete sound \"$complete\" could not be found or read."
fi