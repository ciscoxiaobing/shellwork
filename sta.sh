#!/bin/bash  
  
# 清除屏幕  
clear  
  
# 显示系统信息  
echo "系统信息："  
uname -a  
echo "-----------------------------"  
  
# 显示内存使用情况  
echo "内存使用情况："  
free -h  
echo "-----------------------------"  
  
# 显示磁盘使用情况  
echo "磁盘使用情况："  
df -h  
echo "-----------------------------"  
  
# 显示CPU使用情况  
echo "CPU使用情况（每5秒更新一次，共3次）："  
vmstat 5 3  
echo "-----------------------------"  
  
# 显示当前运行的服务（仅适用于使用systemd的系统）  
echo "当前运行的服务："  
#systemctl list-units --type=service --state=running  
systemctl | grep running
echo "-----------------------------"  
  
# 显示网络连接  
echo "网络连接："  
netstat -tulnp  
netstat -na|grep ESTABLISHED|awk '{print $5}'|awk -F: '{print $1}'
echo "-----------------------------"  
  
# 显示最后登录的用户  
echo "最后登录的用户："  
last | head -n 5  
grep "Accepted " /var/log/secure | awk '{print $1,$2,$3,$9,$11}'
grep -o "Failed password" /var/log/secure
awk -F: '$3==0{print $1}' /etc/passwd
awk '/\$1|\$6/{print $1}' /etc/shadow
echo "-----------------------------"  
  
# 显示系统日志（例如，最后10行/var/log/messages）  
echo "系统日志（最后10行）："  
tail -n 10 /var/log/messages  
echo "-----------------------------"  

# 显示Docker容器
echo "当前运行的Docker容器: "
docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Labels}}"
echo "-----------------------------"  

# 链接状态
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'

  
# 等待用户按键后退出  
read -p "按任意键退出..." key
