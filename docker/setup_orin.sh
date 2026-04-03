#!/bin/bash
# 声明这是一个 bash 脚本

# 1. 遇到任何错误直接退出，防止错上加错 (极客好习惯)
set -e

echo "🚀 开始初始化 Orin 开发环境..."

# 2. 更新系统源并升级基础软件
echo "📦 正在更新 apt 软件源..."
sudo apt update && sudo apt upgrade -y

# 3. 安装必备的系统级依赖 (C++编译、Git、网络工具)
echo "🛠️ 正在安装基础编译链和工具..."
sudo apt install -y build-essential cmake git curl wget python3-pip htop

# 4. 安装 Chromium 浏览器 (ARM64 生态)
echo "🌐 正在安装 Chromium 浏览器..."
sudo apt install -y chromium-browser

# 5. 半自动化安装 Clash Verge (以外部 deb 包为例)
# 这里假设你把 deb 包和脚本放在了同一个目录
CLASH_DEB="clash-verge_1.6.6_aarch64.deb"
if [ -f "$CLASH_DEB" ]; then
    echo "🛡️ 找到 Clash 安装包，正在安装..."
    sudo dpkg -i "$CLASH_DEB" || sudo apt install -f -y
else
    echo "⚠️ 未找到 $CLASH_DEB，跳过 Clash 安装。你可以稍后手动下载安装。"
fi

echo "✅ 宿主机基础环境配置完成！"

#在新机器上，打开终端，给这个脚本赋予执行权限，然后运行
#chmod +x setup_orin.sh
#./setup_orin.sh