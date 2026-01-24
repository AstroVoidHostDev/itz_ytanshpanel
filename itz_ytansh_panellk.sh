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
echo "+=========== ITZ_YTANSH Hosting Installer ===========+"
echo "1) 🔥 Install Panel"
echo "2) ⚡ Install Node (Coming Soon)"
echo "3) 📊 Install Dashboard"
echo "4) ❤️ Subscribe"
echo "5) ➡️ Exit"
echo "+===================================================+"
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
  read -rp "⚙️ Install Panel? (yes/no): " confirm
  [[ "$confirm" == "yes" ]] || exit 1

  spinner
  apt update -y
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs git zip unzip
  npm install -g pm2

  git clone https://github.com/teryxlabs/v4panel
  cd v4panel
  npm install
  npm run seed
  npm run createUser || true

  pm2 start index.js --name panel
  pm2 save
  pm2 startup systemd -u root --hp /root

  echo "✅ PANEL READY → http://SERVER-IP:3000"
}

install_dashboard() {
  read -rp "⚙️ Install Dashboard? (yes/no): " confirm
  [[ "$confirm" == "yes" ]] || exit 1

  spinner

  apt update -y
  apt install -y nodejs npm git zip unzip nano
  npm install -g pm2

  echo "📥 Cloning Dashboard..."
  git clone https://github.com/dragonlabsdev/dash
  cd dash

  echo "⚙️ Auto Configuring .env ..."

  cat > .env <<EOF
# PANEL settings
PANEL_URL=http://127.0.0.1:3000
PANEL_KEY=hpk_auto_generated_key

# Referral
REFERRAL_BONUS=100
REFERRED_USER_BONUS=50
MAX_REFERRAL_CODES=5
BASE_URL=http://SERVER-IP:25002

# Linkvertise
LINKVERTISE_ENABLED=false
LINKVERTISE_USER_ID=none
LINKVERTISE_API_KEY=none
LINKVERTISE_REWARD_AMOUNT=5
LINKVERTISE_DAILY_LIMIT=3

# Discord Auth
DISCORD_SERVER=https://discord.gg/qFSuMVvtcE
DISCORD_CLIENT_ID=auto_client_id
DISCORD_CLIENT_SECRET=auto_secret
DISCORD_CALLBACK_URL=http://SERVER-IP:25002/callback/discord
PASSWORD_LENGTH=10

# Proxy Check
PROXYCHECK_KEY=0000000000000000000000000000

# Webhook
DISCORD_WEBHOOK_URL=none
DISCORD_NOTIFICATIONS_ENABLED=false
EMBED_THUMBNAIL_URL=https://avatars.githubusercontent.com/u/202085680?v=4

# Session
SESSION_SECRET=$(openssl rand -hex 16)

# API
API_KEY=$(openssl rand -hex 5)

# AFK
AFK_TIME=60

APP_NAME=Draco
APP_LOGO=https://avatars.githubusercontent.com/u/202085680?v=4
APP_URL=http://SERVER-IP:25002
APP_PORT=25002

# Admin
ADMIN_USERS=admin@example.com

# Logs
LOGS_PATH=./storage/logs/services.log
LOGS_ERROR_PATH=./storage/logs/errors.log

# Plan
DEFAULT_PLAN=BASIC

# Cost
CPU_COST=750
RAM_COST=500
DISK_COST=400
BACKUP_COST=250
DATABASE_COST=250
ALLOCATION_COST=500

VERSION=3.0
EOF

  echo "📦 Installing Dependencies..."
  npm install

  echo "▶️ Starting Dashboard..."
  pm2 start index.js --name dashboard
  pm2 save
  pm2 startup systemd -u root --hp /root

  echo
  echo "======================================"
  echo "✅ DASHBOARD INSTALLED"
  echo "🌐 URL: http://SERVER-IP:25002"
  echo "🧠 PM2: pm2 list"
  echo "======================================"
}

subscribe() {
  clear
  echo "❤️ SUPPORT ME ❤️"
  echo "👉 https://www.youtube.com/@ITZ_YT_ANSH_OFFICIAL"
}

case $opt in
  1) install_panel ;;
  2) echo "Coming Soon" ;;
  3) install_dashboard ;;
  4) subscribe ;;
  5) exit ;;
  *) echo "❌ Invalid Option" ;;
esac
