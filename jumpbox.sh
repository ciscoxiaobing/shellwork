#!/bin/sh
#admin jumpbox
trapper(){
    trap ':' INT EXIT TSTP TERM HUP
}

## color
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
} 

main(){
while :
do
      trapper
      clear

server1="xxxx"
server2="xxxx"
server3="xxxx"

green "1) $server1 - $server1"
green "2) $server2 - $server2"
green "3) $server3 - $server3"

read -p "`green 'Please input a number that you want to login:'`" num
case "$num" in
    1)
        echo "login into $server1."
        ssh root@$server1
        ;;
    2)
        echo "login into $server2."
        ssh root@$server2
        ;;
    3)
        echo "login into $server3."
        ssh root@$server3
        ;;
    110)
        read -p "Admin Passwd:" char
        if [ "$char" = "sb" ];then
          exit
          sleep 3
        fi
        ;;
    *)
        echo "select error."
        sleep 3
        esac
done
}
main
