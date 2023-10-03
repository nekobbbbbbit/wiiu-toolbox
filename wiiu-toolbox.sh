#!/bin/sh
H=5
W=60
SZ="$H $W"
CONFIG_FILE="config.txt"
_d()
{
	dialog --output-fd 1 --backtitle "Wii U Toolbox" "$@"
}

update_config()
{
	sed -i'.bak' -e "s/$1=.*/$1=$2/g" $CONFIG_FILE
}

get_config()
{
	pattern='[a-zA-Z0-9\s]*'
	grep -Eo "$1=.*" $CONFIG_FILE | sed "s/$1=\(.*\)/\1/g"
}

d_view_file()
{
	_d --title "$1" --editbox "$2" 15 70
}

d_edit_config()
{
	while true; do
		result=$(_d --title "$1" --inputmenu "" 15 70 10 \
			"Wii U Common Key" "$(get_config 'wiiu_common_key')" \
			"Rhythm Heaven Fever Key" "$(get_config 'rhythm_heaven_fever_key')")
		if [ $? == 1 ]; then
			break
		fi
		case $result in
			"RENAMED Wii U Common Key"*)
				update_config "wiiu_common_key" "$(echo $result | sed 's/RENAMED Wii U Common Key //g')"
			;;
			"RENAMED Rhythm Heaven Fever Key"*)
				update_config "rhythm_heaven_fever_key" "$(echo $result | sed 's/RENAMED Rhythm Heaven Fever Key //g')"
			;;
			*)
			;;
		esac
	done
	
}

root_menu()
{
	_d --title "Select an option" --cancel-label "Exit" --menu "" 15 60 8 \
		"Wii U VC Inject" "Inject a Wii VC game" \
		"Edit Config" "Exactly what it says on the box" \
		"Exit" "Exactly what it says on the box" 
}	

while true; do
	result=$(root_menu)
	if [ $? == 1 ]; then
		break
	fi
	case $result in
		"Wii U VC Inject")
			vi
			;;
		"Edit Config")
			d_edit_config "Config file" "config"
			;;
		"Exit")
			break
			;;
		*)
			;;
	esac
done
