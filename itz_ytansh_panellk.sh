#!/bin/bash
set -e

# Root check
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
echo "+=========== ITZ_YTANSH Hosting Installer ===========+"
echo "1) 🔥 Install Panel"
echo "2) ⚡ Install Node (Coming Soon)"
echo "3) ❤️ Subscribe"
echo "4) ➡️ Exit"
echo "+==================================================+"
read -rp "Select option: " opt

spinner() {
  spin='|/-\'
  for i in {1..18}; do
    printf "\r⏳ Processing %s" "${spin:i%4:1}"
    sleep 0.12
  done
  echo
}

install_panel() {
  read -rp "⚙️ Are you sure? (yes/no): " confirm
  [[ "$confirm" == "yes" ]] || { echo "❌ Cancelled"; exit 1; }

  spinner

  echo "🚀 Installing Dependencies..."
  apt update -y
  apt install -y curl git zip unzip software-properties-common

  echo "⬇️ Installing NodeJS 20..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs

  echo "📦 Installing PM2..."
  npm install -g pm2

  echo "📥 Cloning Panel Repo..."
  if [ ! -d "v4panel" ]; then
    git clone https://github.com/teryxlabs/v4panel
  fi

  cd v4panel || exit

  echo "📦 Extracting panel.zip if exists..."
  if [ -f panel.zip ]; then
    unzip -o panel.zip
  fi

  echo "🧹 Cleaning old node modules..."
  rm -rf node_modules package-lock.json

  echo "📦 Installing Node Modules (Fix npm errors)..."
  npm cache clean --force
  npm install --unsafe-perm || npm install --legacy-peer-deps

  echo "🌱 Running Seed (safe mode)..."
  npm run seed || echo "⚠️ Seed skipped (not required)"

  echo "👤 Create Panel User..."
  npm run createUser || true

  echo "▶️ Starting Panel..."
  pm2 delete panel 2>/dev/null || true
  pm2 start index.js --name panel
  pm2 save
  pm2 startup systemd -u root --hp /root

  SERVER_IP=$(curl -s ifconfig.me || echo "YOUR-SERVER-IP")

  echo
  echo "======================================"
  echo "✅ PANEL INSTALLED SUCCESSFULLY"
  echo "🌐 URL: http://localhost:3000"
  echo "🧠 PM2: pm2 list"
  echo "======================================"
}

install_node() {
  echo "🚧 Node / Daemon Coming Soon"
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
