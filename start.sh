#!/bin/bash
# 检查是否以root用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以root用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到root用户，然后再次运行此脚本。"
    exit 1
fi

wget https://github.com/ignite/cli/releases/download/v0.27.1/ignite_0.27.1_linux_amd64.tar.gz
chmod +x ignite_0.27.1_linux_amd64.tar.gz
tar -xvf ignite_0.27.1_linux_amd64.tar.gz
sudo mv ignite /usr/local/bin
echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
source ~/.bashrc
ignite version
curl -sSL https://raw.githubusercontent.com/allora-network/allora-chain/main/install.sh | bash -s -- v0.0.7
sudo apt-get update  -y
sudo apt-get install -y make gcc
rm -rf /usr/local/go
curl -OL https://go.dev/dl/go1.22.4.linux-amd64.tar.gz 
sudo tar -C /usr/local -xvf go1.22.4.linux-amd64.tar.gz
source ~/.bashrc
go version

wget https://github.com/airchains-network/junction/releases/download/v0.1.0/junctiond
chmod +x junctiond
sudo mv junctiond /usr/local/bin
source ~/.bashrc
junctiond init moniker
wget https://github.com/airchains-network/junction/releases/download/v0.1.0/genesis.json
cp genesis.json ~/.junction/config/genesis.json
PEERS="e78a440c57576f3743e6aa9db00438462980927e@5.161.199.115:26656,d9a5e20668955bdd5c2fc28cffd6f06e23794638@[2a01:4f8:10a:3a51::2]:43456,61e609631e8be6e04c43ed3d7bfef23c064dc912@[2a01:4f8:221:26e0::2]:43456,f786dcc80601ddd33ba98c609795083ba418d740@158.220.119.11:43456,0b1159b05e940a611b275fe0006070439e5b6e69@[2a03:cfc0:8000:13::b910:277f]:13756,c8f6b1a795a6d9cd2ec39faf277163a9711fc81b@38.242.194.19:43456,ddd9aade8e12d72cc874263c8b854e579903d21c@178.18.240.65:26656,552d2a5c3d9889444f123d740a20237c89711109@109.199.96.143:43456,cc27f4e54a78b950adaf46e5413f92f5d53d2212@209.126.86.186:43456,f5b69a02abeb3340ccd266f049ed6aabc7c0ea88@94.72.114.150:43456"
sed -i 's|^persistent_peers *=.*|persistent_peers = "'$PEERS'"|' $HOME/.junction/config/config.toml
sed -i.bak -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025amf\"/;" ~/.junction/config/app.toml
rm -rf start.sh genesis.json
rm -rf ignite_0.27.1_linux_amd64.tar.gz go1.22.4.linux-amd64.tar.gz
screen -S airchains
junctiond start
