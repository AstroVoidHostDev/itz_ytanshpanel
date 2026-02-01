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
echo "2) ⚡ Install Node / Daemon"
echo "3) 🧩 Install Dashboard"
echo "4) ❤️ Subscribe"
echo "5) ➡️ Exit"
echo "+====================================================+"
read -rp "Select option: " opt

spinner() {
  spin='|/-\'
  for i in $(seq 1 20); do
    printf "\r⏳ Processing %s" "${spin:i%4:1}"
    sleep 0.12
  done
  echo
}

# ================= NODE INSTALL =================
install_node() {
  echo "⚡ INSTALLING NODE / DAEMON..."
  spinner

  apt update -y
  apt install -y curl git zip unzip software-properties-common

  if ! command -v node &>/dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt install -y nodejs
  fi

  npm install -g pm2

  echo "📥 Cloning Daemon Repo..."
  rm -rf daemon
  git clone https://github.com/dragonlabsdev/daemon
  cd daemon || exit

  if [ -f daemon.zip ]; then
    unzip -o daemon.zip
    cd daemon || true
  fi

  npm install --unsafe-perm || npm install --legacy-peer-deps

  echo
  echo "📜 PASTE CONFIGURE COMMAND BELOW"
  echo "Example:"
  echo "npm run configure -- --panel http://xxxxx-3000.csb.app --key xxxxxxxx"
  echo

  read -rp "👉 Paste here: " CONFIG_CMD

  PANEL_URL=$(echo "$CONFIG_CMD" | sed -n 's/.*--panel \([^ ]*\).*/\1/p')
  PANEL_KEY=$(echo "$CONFIG_CMD" | sed -n 's/.*--key \([^ ]*\).*/\1/p')

  if [[ -z "$PANEL_URL" || -z "$PANEL_KEY" ]]; then
    echo "❌ Invalid command format"
    exit 1
  fi

  FIXED_PANEL="http://localhost:3000"

  echo "⚙️ Running configure..."
  npm run configure -- --panel "$FIXED_PANEL" --key "$PANEL_KEY"

  pm2 delete daemon 2>/dev/null || true
  pm2 start index.js --name daemon
  pm2 save
  pm2 startup systemd -u root --hp /root

  SERVER_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip || hostname -I | awk '{print $1}')

  echo "✅ NODE INSTALLED SUCCESSFULLY"
  echo "🌐 Node Online: http://$SERVER_IP"
}

# ================= DASHBOARD INSTALL =================
install_dashboard() {
  echo "🧩 INSTALLING DASHBOARD..."
  spinner

  apt update -y
  apt install -y curl git zip unzip nano nodejs npm

  rm -rf dash
  git clone https://github.com/dragonlabsdev/dash
  cd dash || exit

  unzip -o dashboard.zip
  cd dash || exit

  echo
  echo "⚙️ DASHBOARD CONFIG SETUP"

  read -rp "👉 Panel URL: " PANEL_URL
  read -rp "👉 Panel API Key: " PANEL_KEY
  read -rp "👉 Hosting Discord Server Link: " DISCORD_SERVER
  read -rp "👉 Discord Client ID: " DISCORD_CLIENT_ID
  read -rp "👉 Discord Client Secret: " DISCORD_CLIENT_SECRET
  read -rp "👉 Discord Callback URL: " DISCORD_CALLBACK_URL
  read -rp "👉 Hosting Name: " APP_NAME
  read -rp "👉 Hosting Logo URL: " APP_LOGO
  read -rp "👉 Dashboard Public URL: " BASE_URL
  read -rp "👉 Admin Email: " ADMIN_EMAIL

  echo "📝 Creating .env..."

  cat > .env <<EOF
PANEL_URL=$PANEL_URL
PANEL_KEY=$PANEL_KEY

REFERRAL_BONUS=100
REFERRED_USER_BONUS=50
MAX_REFERRAL_CODES=5
BASE_URL=$BASE_URL

DISCORD_SERVER=$DISCORD_SERVER
DISCORD_CLIENT_ID=$DISCORD_CLIENT_ID
DISCORD_CLIENT_SECRET=$DISCORD_CLIENT_SECRET
DISCORD_CALLBACK_URL=$DISCORD_CALLBACK_URL
PASSWORD_LENGTH=10

SESSION_SECRET=default
API_KEY=active_key
AFK_TIME=60

APP_NAME=$APP_NAME
APP_LOGO=$APP_LOGO
APP_URL=$BASE_URL
APP_PORT=25002

ADMIN_USERS=$ADMIN_EMAIL

DEFAULT_PLAN=BASIC
CPU_COST=750
RAM_COST=500
DISK_COST=400

VERSION=3.0
EOF

  npm install

  pm2 delete dashboard 2>/dev/null || true
  pm2 start index.js --name dashboard
  pm2 save
  pm2 startup systemd -u root --hp /root

  echo "✅ DASHBOARD INSTALLED SUCCESSFULLY"
  echo "🌐 Dashboard Running on Port 25002"
}

# ================= PANEL PLACEHOLDER =================
install_panel() {
  echo "🔥 Panel Installer Coming Soon"
}

# ================= SUBSCRIBE =================
subscribe() {
  clear
  echo "❤️ SUPPORT ME ❤️"
  echo "👉 https://www.youtube.com/@ITZ_YT_ANSH_OFFICIAL"
}

# ================= MENU =================
case $opt in
  1) install_panel ;;
  2) install_node ;;
  3) install_dashboard ;;
  4) subscribe ;;
  5) exit ;;
  *) echo "❌ Invalid Option" ;;
esac
