#!/bin/bash
set -e

# Root Check
if [ "$EUID" -ne 0 ]; then
  echo "❌ Run as root: sudo bash install.sh"
  exit 1
fi

clear
echo -e "\e[1;97m"
echo "██╗████████╗███████╗     ██╗   ██╗████████╗ █████╗ ███╗   ██╗███████╗██╗  ██╗"
echo "██║╚══██╔══╝╚══███╔╝     ╚██╗ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██║  ██║"
echo "██║   ██║     ███╔╝       ╚████╔╝    ██║   ███████║██╔██╗ ██║███████╗███████║"
echo "██║   ██║    ███╔╝         ╚██╔╝     ██║   ██╔══██║██║╚██╗██║╚════██║██╔══██║"
echo "██║   ██║   ███████╗        ██║      ██║   ██║  ██║██║ ╚████║███████║██║  ██║"
echo "╚═╝   ╚═╝   ╚══════╝        ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "\e[0m"

echo
echo "+=========== ITZ_YTANSH GOD INSTALLER ===========+"
echo "1) 🔥 Install Panel"
echo "2) ⚡ Install Node / Daemon (FULL AUTO)"
echo "3) ❤️ Subscribe"
echo "4) ➡️ Exit"
echo "+================================================+"
read -rp "Select option: " opt

spinner() {
  spin='|/-\\'
  for i in {1..20}; do
    printf "\r⏳ Processing %s" "${spin:i%4:1}"
    sleep 0.12
  done
  echo
}

install_node() {
  echo
  echo "⚡ INSTALLING NODE / DAEMON..."
  spinner

  echo "📦 Installing Dependencies..."
  apt update -y
  apt install -y curl git zip unzip software-properties-common

  echo "⬇️ Installing NodeJS 20 if missing..."
  if ! command -v node &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
  fi

  echo "📦 Installing PM2..."
  npm install -g pm2

  echo "📥 Cloning Daemon Repo..."
  if [ ! -d "daemon" ]; then
    git clone https://github.com/dragonlabsdev/daemon
  else
    echo "⚠️ Daemon folder exists — updating"
    cd daemon && git pull && cd ..
  fi

  cd daemon || exit

  echo "📦 Extracting daemon.zip..."
  if [ -f daemon.zip ]; then
    unzip -o daemon.zip
    cd daemon || true
  fi

  echo "📦 Installing Node Modules..."
  npm install --unsafe-perm || npm install --legacy-peer-deps

  echo
  echo "📜 PASTE YOUR CONFIGURATION BELOW"
  echo "----------------------------------"
  echo "When done, press CTRL+X then Y then ENTER"
  echo

  cat > config.json

  echo "▶️ Starting Node..."
  pm2 delete daemon 2>/dev/null || true
  pm2 start index.js --name daemon
  pm2 save
  pm2 startup

  SERVER_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')

  echo
  echo "======================================"
  echo "✅ NODE INSTALLED SUCCESSFULLY"
  echo "🌐 Node Online: http://$SERVER_IP"
  echo "⚡ PM2 Status: pm2 list"
  echo "======================================"

  echo
  echo "❤️ Subscribe To Itz_Ytansh"
  echo "👉 https://www.youtube.com/@ITZ_YT_ANSH_OFFICIAL"
}

install_panel() {
  echo "🔥 Panel Installer Coming Soon"
}

subscribe() {
  clear
  echo "❤️ SUPPORT ME ❤️"
  echo "👉 https://www.youtube.com/@ITZ_YT_ANSH_OFFICIAL"
}

case $opt in
  1) install_panel ;;
  2) install_node ;;
  3) subscribe ;;
  4) exit ;;
  *) echo "❌ Invalid Option" ;;
esac
