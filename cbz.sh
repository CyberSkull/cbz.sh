#! /bin/zsh
# Usage: Zips given directories into .cbz (Comic Book ZIP) archives of the smame name (e.g. "folder name.cbz").

complete="/System/Applications/Music.app/Contents/Resources/complete.aif" #sound to play when all is done
remove_flag="m" #m removes originals after successful test
recursive_flag="r" #r follows all directories
test_flag="T" #T test archive to make sure nothing went wrong
symlink_flag="y" #y follow symlinks
compression="9" #9 for the highest compression level
#open_flag="false" #open the file after creating
count=0 #number of archives zipped

#text colors and format because the zsh colors function does not support underline
bold="\e[1m"
dim="\e[2m"
italic="\e[3m"
underline="\e[4m"
double_underline="\e[21m" #same as reset_bold, probalby not implemented
blink="\e[5m"
reverse="\e[7m"
hidden="\e[8m"
strikethrough="\e[9m"

reset="\e[0m"
reset_bold="\e[21m"
reset_dim="\e[22m" #clears bold too
reset_italic="\e[23m"
reset_underline="\e[24m"
reset_blink="\e[25m"
reset_reverse="\e[27m"
reset_hidden="\e[28m"
reset_strikethrough="\e[9m"

foreground="\e[39m"
black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
light_gray="\e[37m"
dark_gray="\e[90m"
light_red="\e[91m"
light_green="\e[92m"
light_yellow="\e[93m"
light_blue="\e[94m"
light_magenta="\e[95m"
light_cyan="\e[96m"

background="\e[49m"
bg_black="\e[40m"
bg_red="\e[41m"
bg_green="\e[42m"
bg_yellow="\e[43m"
bg_blue="\e[44m"
bg_magenta="\e[45m"
bg_cyan="\e[46m"
bg_light_gray="\e[47m"
bg_dark_gray="\e[100m"
bg_light_red="\e[101m"
bg_light_green="\e[102m"
bg_light_yellow="\e[103m"
bg_light_blue="\e[104m"
bg_light_magenta="\e[105m"
bg_light_cyan="\e[106m"

#OSC
icontab="\e]0;"
icontitle="\e]1;"
tabtitle="\e]2;"
documenttitle="\e]6;"
workingdirectory="\e]7;"

#using styles based on the above for cleaner code
style_command=$bold
reset_style_command=$reset_dim
reset_style_flag=$reset_dim
style_flag=$bold
style_file=$underline
reset_style_file=$reset_underline
style_dir=$blue$underline
reset_style_dir=$foreground$reset_underline
style_exclude=$dim$strikethrough
reset_style_exclude=$reset_dim$reset_strikethrough
style_error=$red$bold
reset_style_error=$reset
style_warn=$yellow
reset_style_warn=$reset

usage="USAGE:\t${style_command}`basename $0`${reset_style_command}"
usage+=" [${style_flag}-h${reset_style_flag}]"
usage+=" [${style_flag}-k${reset_style_flag}]"
usage+=" ${style_dir}DIRECTORY…${reset_style_dir}"
usage+="\n\t${style_flag}-h${reset_style_flag} Print this help screen."
usage+="\n\t${style_flag}-k${reset_style_flag} Keep originals."
#usage+="${style_flag}-o${reset_style_flag} Output directory."
#usage+="${style_flag}-q${reset_style_flag} Quite mode. No terminal output."
#usage+="${style_flag}-s${reset_style_flag} Silent mode. No sound when done."

function urlencode()
{
	local LC_ALL=C #clears locale flags, ensures multibyte characters get printed properly. I hope.
	local string=""
	local character=""

	for string in $@
	do
		for character in ${(s[])string}
		do
			case $character in
				[0-9a-zA-Z/.~_-])
					printf '%s' "$character"
					;;
				*)
					printf '%%%02X' "'$character"
					;;
			esac
		done
	done
}


if [ $# -eq 0 ] #print usage and quit if no arguments
then
	echo $usage
	exit 1
fi

echo -ne "${icontitle}Comic Book Zip\a" #set terminal icon & tab name to "CBZ", only applies to X-11
echo -ne "${workingdirectory}file://$(urlencode $(hostname)$(pwd)/)\a" #set working dicrectory

while getopts "kh" flag #process flags
do
	case $flag in
    k) #clears remove flag
  		echo "Keeping originals."
  		remove_flag=""
  		;;
    h) #print usage
      echo $usage
      exit 1
      ;;
	esac
done

for target in "$@"
do
	if [[ -e $target ]]	#exists
	then
		if [[ -d $target ]]	#directory
		then
			if [[ -r $target ]]	#readable
			then
        count+=1
				archive=${target%/}
				echo "${reset}Archiving: ${style_dir}$target${reset_style_dir}"
				echo -ne "${tabtitle}Archiving…\a" #set tab title to "Archiving…"
				echo -ne "${documenttitle}file://$(urlencode $(hostname)$(pwd)/$archive.cbz)\a" #set document to archive


        #Big fancy printout of the zip command.
				echo -ne ${reset}${style_command}zip${reset_style_command}" " #zip
        echo -ne ${style_flag}"-$remove_flag$recursive_flag$test_flag$symlink_flag$compression"${reset_style_flag}" " #flags
        echo -ne \"${style_file}"$archive.cbz"${reset_style_file}"\" " #comic book zip archive
        echo -ne \"${style_dir}"$target"${reset_style_dir}"\" " #source
        echo -ne ${style_flag}"-x"${reset_style_flag}" " #exclude flag
        echo -ne \"${style_exclude}"*.DS_Store"${reset_style_exclude}"\" " #exclude DS_Store
        echo -ne \"${style_exclude}"*[Tt]humbs.db"${reset_style_exclude}\" #exclude Thumbs.db
        echo $reset

				# -m delete originals, -r recursive, -T test zip, -y store symlink, -9 maximum compression, -x exclude list
				zip -"$remove_flag$recursive_flag$test_flag$symlink_flag$compression" "$archive.cbz" "$target" -x "*.DS_Store" "*[Tt]humbs.db"
				echo -ne "${tabtitle}\a" #set tab/window title to empty. Resets it?
				echo -ne "${documenttitle}\a" #set document to empty. Resets it?
				echo $reset

			else
				echo "${style_error}Not readable: ${style_dir}$target${reset_style_dir}${reset_error}"
        echo $reset
			fi	#-r
		else
			echo "${style_error}Not a directory: ${style_file}$target${reset_style_file}${reset_error}"
      echo $reset
		fi #-d
	else
		echo "${style_error}Not found: ${style_file}$target${reset_style_file}${reset_error}"
    echo $reset
	fi	#-e
done

#When done play the Music done sound.
if [[ $count > 0 ]] #Only make a sound if any work was attempted.
then
  if [[ -e $complete && -r $complete ]] #make sure there is a sound file to play
  then
  	afplay "$complete"
  else
  	echo "\a${style_warn}Sorry, the complete sound \"${style_file}$complete${reset_style_file}\" could not be found or read.${reset}"
  fi
fi

echo -ne "${icontab}\a${documenttitle}\a${workingdirectory}\a" #clear xterm names
