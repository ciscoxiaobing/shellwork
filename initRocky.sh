#!/usr/bin/env bash
# **********************************************************#
# * Author        : Ano                                #
# * Create time   : 2024-09                                 #
# * Description   : 一键初始化系统                          #
# **********************************************************#

function random_color(){
    random_color_code=$((RANDOM % 256))
    echo -e "\033[38;5;${random_color_code}m${1}\033[0m"
}

function os_initial(){
  random_color "---Rocky_Linux9初始化脚本---"
  random_color "---关闭防火墙和selinux---"
  sleep 3
  systemctl stop firewalld
  systemctl disable firewalld
  setenforce 0
  sed -i 's/SELINUX=.*/SELINUX=permissive/' /etc/selinux/config 

  random_color "---替换yum源---"
  sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
      -i.bak \
      /etc/yum.repos.d/rocky*.repo
  dnf makecache


  random_color "---修改系统时区---"
  sleep 3 
  timedatectl set-timezone Asia/Shanghai 
  systemctl start chronyd
  systemctl enable chronyd



  random_color "---修改系统最大打开文件数---"
  sleep 3
  if ! cat /etc/security/limits.conf |grep "65535" &>/dev/null ;then
      echo "* soft nofile 65535" >>/etc/security/limits.conf
      echo "* hard nofile 65535" >>/etc/security/limits.conf
  fi


  random_color "---关闭系统swap分区---"
  swapoff -a
  sed -i '/swap/s/^/#/' /etc/fstab
}


if [ "$#" -eq 0 ];then
 random_color "执行时请跟上要修改的网卡名，以及新的网卡名称(sh xx eth1 eth2)"
 exit 1
fi

eth=$1
neweth=$2
function rename_grub(){
  random_color "---使用传统网卡名称来命名---"
 if grep -o "net.ifnames=0" /etc/default/grub >/dev/null 2>&1 ;then
      random_color "===当前系统已使用传统网卡名称来命名==="
       grep  "net.ifnames=0" /etc/default/grub
       exit 1
 else
            sed -i 's#\(GRUB_CMDLINE_LINUX="[^"]*\)"#\1 net.ifnames=0"#' /etc/default/grub
            if [ ! -f  /boot/efi/EFI/redhat/grub.cfg ] ;then
            random_color  "---当前系统基于BOIS引导模式---"
            random_color "---正在更新grub.cfg文件---"
            grub2-mkconfig -o /boot/grub2/grub.cfg
            else
            random_color "---当前系统基于UEFI引导模式---"
            random_color"---正在更新grub.cfg文件---"
            grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
            fi
 fi
}

function main(){
 local eth_config="/etc/NetworkManager/system-connections"
 if cat /etc/os-release |grep -o "Rocky Linux" 1>/dev/null ;then
  rename_grub
  nmcli c modify $eth con-name $neweth ifname $neweth
  mv ${eth_config}/$eth.nmconnection ${eth_config}/$neweth.nmconnection
  nmcli c reload
  random_color "配置文件修改完毕,请手动重启系统."
 else
  rename_grub
  sed -i "s/NAME=.*/NAME=$neweth/;s/DEVICE=.*/DEVICE=$neweth/" /etc/sysconfig/network-scripts/ifcfg-$eth
  mv /etc/sysconfig/network-scripts/ifcfg-$eth /etc/sysconfig/network-scripts/ifcfg-$neweth
  random_color "配置文件修改完毕,请手动重启系统."
 fi
}

os_initial
main
