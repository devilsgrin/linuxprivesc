red="\e[91m"
green="\e[92m"
yellow="\e[93m"
blue="\e[94m"
magenta="\e[95m"
reset="\e[0m"
bold="\e[1m"


user_info()
{
echo -e "\n$bold$green \t\t USER INFORMATION \n"

echo -e "$bold$green You Are:$red $USER\n" # CURRENT USER
echo -e "$bold$green ID($USER)= $red`id $USER 2>/dev/null`\n" # USER ID
echo -e "$bold$green GROUPS($USER)=  $red`groups $USER 2>/dev/null` \n" # GROUPS

echo -e "$bold$yellow########################################$reset\n"
echo -e "$bold$green \tCURRENT LOGGED USERS\n"
echo -e "$bold$red `w | sed '2!d' `\n $reset$bold$green`w | sed '3!d' 2>/dev/null` \n"

echo -e "$bold$yellow########################################$reset\n"
echo -e "$bold$green \tLAST LOGGINS (20)\n"
echo -e "$bold$red ` last | head -20 2>/dev/null` \n"

get_users
echo -e "$bold$green \tUSERS (/etc/passwd) \n"
echo -e "$bold$red `cat /etc/passwd 2>/dev/null` \n"
echo -e "$bold$yellow########################################$reset\n"

echo -e "$bold$green \tROOT USERS \n"
echo -e "$bold$red ` getent passwd {0..0} | awk -F: '{print $1}' 2>/dev/null` \n"
echo -e "$bold$yellow########################################$reset\n"

echo -e "$bold$green  \tGROUPS (/etc/group) \n"
echo -e "$bold$red ` cat /etc/group 2>/dev/null` \n"
echo -e "$bold$yellow########################################$reset\n"

echo -e "$bold$green \t UMASK VALUES \n"
echo -e "$bold$magenta WRITABLE FILES IN /home \n"
echo -e "$bold$red ` find -type f -maxdepth 1 -writable 2>/dev/null ` \n "

echo -e "$bold$magenta FILE PERMISSIONS IN /home \n"
echo -e "$bold$red ` paste <(ls -l 2>/dev/null | cut -c1-11) <(ls -l 2>/dev/null| grep -i "-" | cut -c11-100) ` \n "
}


system_info()
{
echo -e "$bold$magenta########################################$reset\n"

echo -e "$bold$green \t\t SYSTEM INFO\n"
echo -e "$bold$green Kernel Version: $reset $red `uname -ar` $reset\n"

echo -e "$bold$yellow########################################$reset\n"
echo -e "$bold$green/etc/os-release\n"
echo -e "$red`cat /etc/os-release` $reset\n" # /etc/os-release file
echo -e "$bold$yellow########################################$reset\n"

}

network_info()
{
echo -e "$bold$green \t\t NETWORK INFO \n"
echo -e "$bold$green Hostname: $red` cat /proc/sys/kernel/hostname ` "
echo -e "$bold$green Public Ip: $red`curl -s ipinfo.io/ip`"
echo -e "$bold$green Local Ip/Ip's: $red ` ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | awk '{print}' ORS=' ' ` \n"

echo -e "$bold$magenta########################################$reset"
echo -e "$bold$green/DNS Servers: /etc/resolv.conf $reset\n"
echo -e "$red` grep 'nameserver' /etc/resolv.conf` "
echo -e "$bold$magenta########################################$reset\n"

echo -e "$bold$green SERVICES ON LISTEN \n"
echo -e "$red` ss -lnpt | sed '2,3!d' ` \n "
echo -e "$bold$magenta########################################$reset\n"

echo -e "$bold$green NETWORK ROUTING \n"
echo -e "$bold$red ` route -n | sed '1d' ` \n "
echo -e "$bold$magenta########################################$reset\n"

}

get_users()
{
    echo -e "$bold$yellow########################################$reset\n"
    echo -e "$bold$green USERS (/home folder) $reset \n"
    getent passwd | grep '/home' | cut -d: -f1 > /tmp/user-list.txt

    local my_array=()
    # sonra bu dosyayi okuyarak her bir satırı bir liste icine atıyoruz
    while IFS= read -r line; do
	my_array+=( "$line" )
    done < <( cat /tmp/user-list.txt )
    # en son da bu listeyi okuyarak userlere sıra veriyoruz.
    USERS=${#my_array[@]}

    for (( user=0; user<$USERS ; user++ )); do
	echo -e "$bold$green $((user+1)). $reset $bold$red ${my_array[${user}]} \n"
    done

    echo -e "$bold$yellow########################################$reset\n"
}

user_info
