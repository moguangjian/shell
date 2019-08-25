#!/bin/bash
# 本脚本用于安装nodejs

# 定义 nodejs的版本
nodejs_ver="v10.16.3"
cd	/usr/local/
wget https://nodejs.org/dist/${nodejs_ver}/node-${nodejs_ver}-linux-x64.tar.xz
tar xf node-${nodejs_ver}-linux-x64.tar.xz
ln -s /usr/local/node-${nodejs_ver}-linux-x64/bin/node /usr/bin/node
ln -s /usr/local/node-${nodejs_ver}-linux-x64/bin/npm /usr/bin/npm
ln -s /usr/local/node-${nodejs_ver}-linux-x64/bin/npm /usr/bin/npx

# 安装cnpm 
npm install -g cnpm --registry=https://registry.npm.taobao.org
