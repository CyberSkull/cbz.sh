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


while getopts "kho" flag
do
	case $flag in
    k) #clears remove flag
  		echo "Keeping originals."
  		remove_flag=""
  		;;
    h) #print usage
      echo -n "USAGE: ${style_command}cbz${reset_style_command} "
      echo -n "[${style_flag}-h${reset_style_flag}]"
      echo -n "[${style_flag}-k${reset_style_flag}] "
      echo    "${style_dir}DIRECTORY…${reset_style_dir}"
      echo "${style_flag}-h${reset_style_flag} Print this help screen."
      echo "${style_flag}-k${reset_style_flag} Keep originals."
      #echo "${style_flag}-o${reset_style_flag} Output directory."
      #echo "${style_flag}-q${reset_style_flag} Quite mode. No terminal output."
      #echo "${style_flag}-s${reset_style_flag} Silent mode. No sound when done."
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

        #Big fancy printout of the zip command.
				echo -n ${reset}${style_command}zip${reset_style_command}" " #zip
        echo -n ${style_flag}"-$remove_flag$recursive_flag$test_flag$symlink_flag$compression"${reset_style_flag}" " #flags
        echo -n \"${style_file}"$archive.cbz"${reset_style_file}"\" " #comic book zip archive
        echo -n \"${style_dir}"$target"${reset_style_dir}"\" " #source
        echo -n ${style_flag}"-x"${reset_style_flag}" " #exclude flag
        echo -n \"${style_exclude}"*.DS_Store"${reset_style_exclude}\"" " #exclude DS_Store
        echo -n \"${style_exclude}"*[Tt]humbs.db"${reset_style_exclude}\" #exclude Thumbs.db
        echo $reset

				# -m delete originals, -r recursive, -T test zip, -y store symlink, -9 maximum compression, -x exclude list
				zip -"$remove_flag$recursive_flag$test_flag$symlink_flag$compression" "$archive.cbz" "$target" -x "*.DS_Store" "*[Tt]humbs.db"
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
