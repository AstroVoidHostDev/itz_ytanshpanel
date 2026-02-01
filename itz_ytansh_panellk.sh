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
echo "+=========== ITZ_YTANSH HOSTING INSTALLER ===========+"
echo "1) 🔥 Install Panel"
echo "2) ⚡ Install Node / Daemon (BEST)"
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

# ================= PANEL INSTALLER =================
install_panel() {
  echo
  echo "🔥 INSTALLING PANEL..."
  spinner

  apt update -y
  apt install -y curl git zip unzip software-properties-common

  echo "⬇️ Installing NodeJS 20 if missing..."
  if ! command -v node &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
  fi

  echo "📦 Installing PM2..."
  npm install -g pm2

  echo "📥 Cloning Panel Repo..."
  if [ ! -d "v4panel" ]; then
    git clone https://github.com/teryxlabs/v4panel
  else
    cd v4panel && git pull && cd ..
  fi

  cd v4panel || exit

  echo "📦 Extracting panel.zip..."
  if [ -f panel.zip ]; then
    unzip -o panel.zip
  fi

  echo "🧹 Cleaning node modules..."
  rm -rf node_modules package-lock.json

  echo "📦 Installing Node Modules..."
  npm install --unsafe-perm || npm install --legacy-peer-deps

  echo "🌱 Running Seed..."
  npm run seed || echo "⚠️ Seed skipped"

  echo "👤 Create Panel User..."
  npm run createUser || true

  echo "▶️ Starting Panel..."
  pm2 delete panel 2>/dev/null || true
  pm2 start index.js --name panel
  pm2 save
  pm2 startup

  SERVER_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')

  echo
  echo "======================================"
  echo "✅ PANEL INSTALLED SUCCESSFULLY"
  echo "🌐 Panel URL: http://localhost:3000"
  echo "⚡ PM2: pm2 list"
  echo "======================================"
}

# ================= NODE INSTALLER =================
install_node() {
  echo
  echo "⚡ INSTALLING NODE / DAEMON..."
  spinner

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
  echo "📜 PASTE CONFIG COMMAND BELOW"
  echo "Example:"
  echo "npm run configure -- --panel http://xxxxx-3000.csb.app --key xxxxxxxx"
  echo

  read -rp "👉 Paste here: " CONFIG_CMD

  PANEL_URL=$(echo "$CONFIG_CMD" | grep -oP '(?<=--panel )\S+')
  PANEL_KEY=$(echo "$CONFIG_CMD" | grep -oP '(?<=--key )\S+')

  if [[ -z "$PANEL_URL" || -z "$PANEL_KEY" ]]; then
    echo "❌ Invalid command format"
    exit 1
  fi

  FIXED_PANEL="http://localhost:3000"

  echo
  echo "🔁 Panel URL Converted:"
  echo "❌ $PANEL_URL"
  echo "✅ $FIXED_PANEL"

  echo "⚙️ Running configure..."
  npm run configure -- --panel "$FIXED_PANEL" --key "$PANEL_KEY"

  echo "▶️ Starting Node..."
  pm2 delete daemon 2>/dev/null || true
  pm2 start index.js --name daemon
  pm2 save
  pm2 startup

  SERVER_IP=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')

  echo
  echo "======================================"
  echo "✅ NODE INSTALLED SUCCESSFULLY"
  echo "🌐 Node Online: http://localhost:3002"
  echo "⚡ PM2 Status: pm2 list"
  echo "======================================"

  echo
  echo "❤️ Subscribe To Itz_Ytansh"
  echo "👉 https://www.youtube.com/@ITZ_YT_ANSH_OFFICIAL"
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
