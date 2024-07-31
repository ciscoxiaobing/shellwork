#!/bin/bash
# 定义一个函数，用于生成非黑色的随机颜色并输出文本
function color_echo {
  local random_color_code=$((RANDOM % 255 + 1))  # 生成1到255之间的随机颜色代码，排除0（黑色）
  echo -e "\033[38;5;${random_color_code}m${1}\033[0m"  # 输出带有颜色的文本
}


