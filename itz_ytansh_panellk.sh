#!/bin/bash
set -e

YELLOW="\e[1;33m"
GREEN="\e[1;32m"
RED="\e[1;31m"
RESET="\e[0m"

# Root Check
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}❌ Run as root: sudo bash install.sh${RESET}"
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
echo -e "\e[0m"         "❤️Subscribe For 2K Subs❤️"

echo
echo "+=========== CSB HOSTING INSTALLER ===========+"
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
    sleep 0.10
  done
  echo
}

# ================= FIX NODE + NPM =================
fix_node() {
  echo "🛠️ Fixing Node & npm conflicts..."

  apt remove -y npm nodejs || true
  apt autoremove -y
  apt clean

  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt install -y nodejs

  echo -e "${GREEN}✅ Node Installing..${RESET}"
}

# ================= NODE INSTALL =================
install_node() {
  echo "⚡ INSTALLING NODE / DAEMON..."
  spinner

  fix_node

  apt install -y curl git zip unzip software-properties-common
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
  echo -e "${YELLOW}📜 Example:${RESET} npm run configure -- --panel http://panel-url --key PANEL_KEY_HERE "
  echo -e "${RED}📢 Make Sure To Paste The As It Is Key Without Any Change... Otherwise It Will Not Work${RESET}"
  echo

  read -rp "👉 Paste configure Key Of Node: " CONFIG_CMD

  PANEL_URL=$(echo "$CONFIG_CMD" | sed -n 's/.*--panel \([^ ]*\).*/\1/p')
  PANEL_KEY=$(echo "$CONFIG_CMD" | sed -n 's/.*--key \([^ ]*\).*/\1/p')

  if [[ -z "$PANEL_URL" || -z "$PANEL_KEY" ]]; then
    echo -e "${RED}❌ Invalid configure command${RESET}"
    exit 1
  fi

  FIXED_PANEL="http://localhost:3000"

  npm run configure -- --panel "$FIXED_PANEL" --key "$PANEL_KEY"

  pm2 delete daemon 2>/dev/null || true
  pm2 start index.js --name daemon
  pm2 save
  pm2 startup systemd -u root --hp /root

  SERVER_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip || hostname -I | awk '{print $1}')

  echo -e "${GREEN}✅ NODE INSTALLED${RESET}"
  echo "🌐 Node Running: http://localhost:3002"
  echo "❤️ SUPPORT ITZ_YTANSH ❤️"
}

# ================= DASHBOARD INSTALL =================
install_dashboard() {
  echo "🧩 INSTALLING DASHBOARD..."
  spinner

  fix_node
  apt install -y curl git zip unzip nano

  rm -rf dash
  git clone https://github.com/dragonlabsdev/dash
  cd dash || exit

  unzip -o dashboard.zip
  cd dash || exit

  echo
  echo "⚙️ DASHBOARD CONFIG SETUP STARTED.."
  echo -e "${YELLOW}Examples shown in yellow for help${RESET}"
  echo

  read -rp "👉 Panel URL (${YELLOW}http://localhost:3000${RESET}): " PANEL_URL
  read -rp "👉 Panel API Key (${YELLOW}hpk_xxxxxxxxx${RESET}): " PANEL_KEY
  read -rp "👉 Hosting Discord Server (${YELLOW}https://discord.gg/xxxx${RESET}): " DISCORD_SERVER
  read -rp "👉 Discord Client ID (${YELLOW}123456789012345678${RESET}): " DISCORD_CLIENT_ID
  read -rp "👉 Discord Client Secret (${YELLOW}xxxxxxxxxxxx${RESET}): " DISCORD_CLIENT_SECRET

  echo -e "${YELLOW}👉 Example Callback URL:${RESET} https://xxxxx-25002.csb.app/callback/discord"
  read -rp "👉 Discord Callback URL: " DISCORD_CALLBACK_URL

  read -rp "👉 Hosting Name (${YELLOW}MyHosting${RESET}): " APP_NAME
  read -rp "👉 Hosting Logo URL (${YELLOW}https://logo.png${RESET}): " APP_LOGO
  read -rp "👉 Dashboard Public URL (${YELLOW}https://xxxxx-25002.csb.app${RESET}): " BASE_URL
  read -rp "👉 Admin Email (${YELLOW}admin@gmail.com${RESET}): " ADMIN_EMAIL

  echo "📝 Writing .env..."

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
RAM_COST=600
DISK_COST=400

VERSION=3.0
EOF

  npm install

  pm2 delete dashboard 2>/dev/null || true
  pm2 start index.js --name dashboard
  pm2 save
  pm2 startup systemd -u root --hp /root

  echo -e "${GREEN}✅ DASHBOARD INSTALLED${RESET}"
  echo "🌐 Dashboard Running on Port 25002"
  echo "❤️ SUPPORT ITZ_YTANSH ❤️"
}

# ================= PANEL =================
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
  echo "❤️ SUPPORT ITZ_YTANSH ❤️"
  echo "======================================"
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
