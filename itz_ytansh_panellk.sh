#!/bin/bash
set -e

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
echo "+=========== ITZ_YTANSH Hosting Installer (CodeSandBox) ===========+"
echo "1) 🔥 Install Panel"
echo "2) ⚡ Install Node (Coming Soon)"
echo "3) ❤️ Subscribe"
echo "4) ➡️ Exit"
echo "+==================================================+"
read -rp "Select option: " opt

spinner() {
  spin='|/-\'
  for i in {1..15}; do
    printf "\r⏳ Processing %s" "${spin:i%4:1}"
    sleep 0.2
  done
  echo
}

install_panel() {
  read -rp "⚙️ Are you sure? (yes/no): " confirm
  [[ "$confirm" == "yes" ]] || { echo "❌ Cancelled"; exit 1; }

  spinner

  echo "🚀 Installing Dependencies..."
  apt update -y
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs git zip unzip
  npm install -g pm2

  echo "📥 Cloning Panel..."
  git clone https://github.com/teryxlabs/v4panel
  cd v4panel
  apt install zip -y && unzip panel.zip

  echo "📦 Installing Node Modules..."
  npm install

  echo "🌱 Seeding Database..."
  npm run seed

  echo "👤 Create Panel User"
  npm run createUser || true

  echo "▶️ Starting Panel..."
  pm2 start index.js --name panel
  pm2 save
  pm2 startup systemd -u root --hp /root

  echo
  echo "======================================"
  echo "✅ PANEL INSTALLED SUCCESSFULLY"
  echo "🌐 URL: http://SERVER-IP:3000"
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
