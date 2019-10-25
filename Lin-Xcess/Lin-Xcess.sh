#!/bin/bash

#Copying This Code Without Credits Will Open The Hell Ports For You and scratch your fireball too -_- 


trap 'printf "\n";stop;exit 1' 2
dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Install it. Aborting."; exit 1; }
}
                                     

banner() {
printf "\e[1;77m _       _                 _    _                     \e[0m\n"
printf "\e[1;77m| |     (_)               \ \  / /                    \e[0m\n"
printf "\e[1;77m| |      _ ____     ___    \ \/ / ____ ____  ___  ___ \e[0m\n"
printf "\e[1;77m| |     | |  _ \   (___)    )  ( / ___) _  )/___)/___)\e[0m\n"
printf "\e[1;77m| |_____| | | | |          / /\ ( (__( (/ /|___ |___ |\e[0m\n"
printf "\e[1;77m|_______)_|_| |_|         /_/  \_\____)____|___/(___/ \e[0m\n"
printf "\n"
printf "\e[1;93m       .:.:.\e[0m\e[1;77m Directory Xploiting Tool coded by:  @t4nny \e[0m\e[1;93m.:.:.\e[0m\n"
printf "\n"
printf "  \e[101m\e[1;77m:: Disclaimer: Developers assume no liability and are not    ::\e[0m\n"
printf "  \e[101m\e[1;77m:: responsible for any misuse or damage caused by Lin-Xcess ::\e[0m\n"
printf "\n"
printf "Copying This Code Without Credits Will Open The Hell Ports For You and scratch your fireball too -_- "

}

start()
{

pkill -f -2 ssh > /dev/null 2>&1
killall ssh > /dev/null 2>&1

default_port="4444"
printf '\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter Remote Port (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_port
read port
port="${port:-${default_port}}"

default_tld="ph1b3r0pt1ck"
printf '\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter TLD (Default:\e[0m\e[1;77m %s \e[0m\e[1;92m): \e[0m' $default_tld
read tld
tld="${tld:-${default_tld}}"

	
python -m SimpleHTTPServer $port 2> /dev/null > sendlink  &
sleep 5

printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting server...\e[0m\n"
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require SSH but it's not installed. Install it. Aborting."; exit 1; }
if [[ -e sendlink ]]; then
rm -rf sendlink
fi
$(which sh) -c 'ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R '$tld'.serveo.net:80:0.0.0.0:'$port' serveo.net 2> /dev/null > sendlink ' &
printf "\n"
sleep 10

send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
printf "\n"
printf '\n\e[1;93m[\e[0m\e[1;77m*\e[0m\e[1;93m] Send the direct link to target:\e[0m\e[1;77m %s \n' $send_link
}

dependencies
banner
start
