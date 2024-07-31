#!/bin/bash  
##############################################################  
#输入数字运行相应命令  
##############################################################  
echo "Menu: "
cat << "EOF"
1. Start Book Docker Service.
2. Start Video Docker Service.
3. Start File Docker Service.
4. Check Current Services.
5. exit.
EOF
  
while :  
do  
  #捕获用户键入值  
  read -p "please input number :" n  
  
  #空输入检测  
  n1=`echo $n|sed s'/[0-9]//'g`  
  if [ -z "$n" ]  
  then  
    continue  
  fi  
  
  #非数字输入检测  
  if [ -n "$n1" ]  
  then  
    exit 0  
  fi  
  
  break  
done  
  
case $n in  
  1)  
    docker-compose -p book -f /root/book/docker-compose.yml up -d 
    ;;  
  2)  
    docker-compose -p video -f /gitlab1/aria2-ariang-x-docker-compose/h5ai/docker-compose.yml up -d 
    ;;  
  3)  
    docker-compose -p file -f /gitlab1/aria2-ariang-x-docker-compose/nextcloud/docker-compose.yml up -d 
    ;;  
  4)  
    ./sta.sh
    ;;  
  5)  
    exit 
    ;;  
  #输入数字非1-5的提示  
  *)  
    echo "please input number is [1-4]"  
    ;;  
esac
