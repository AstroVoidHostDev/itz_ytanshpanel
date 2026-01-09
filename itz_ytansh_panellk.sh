#!/bin/bash
set -e

# ===============================
# Colors & Emojis
# ===============================
GREEN="\e[32m"
RED="\e[31m"
CYAN="\e[36m"
YELLOW="\e[33m"
RESET="\e[0m"

# ===============================
# Banner
# ===============================
clear
echo -e "${CYAN}"
echo "██╗████████╗███████╗     ██╗   ██╗████████╗ █████╗ ███╗   ██╗███████╗██╗  ██╗"
echo "██║╚══██╔══╝╚══███╔╝     ╚██╗ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██║  ██║"
echo "██║   ██║     ███╔╝       ╚████╔╝    ██║   ███████║██╔██╗ ██║███████╗███████║"
echo "██║   ██║    ███╔╝         ╚██╔╝     ██║   ██╔══██║██║╚██╗██║╚════██║██╔══██║"
echo "╚═╝   ╚═╝   ╚══════╝        ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "${RESET}"
echo -e "🚀 ${GREEN}ITZ_YTANSH PROFESSIONAL INSTALLER${RESET}"
echo ""

# ===============================
# Menu
# ===============================
echo -e "${YELLOW}Select what to install:${RESET}"
echo "1️⃣  Teryx Panel"
echo "2️⃣  Teryx Daemon"
read -p "👉 Enter choice (1/2): " CHOICE

# ===============================
# Dependencies
# ===============================
echo -e "\n📦 Installing dependencies..."
apt update -y
apt install -y git curl zip unzip

curl -fsSL https://deb.nodesource.com/setup_23.x | bash -
apt install -y nodejs

# ===============================
# PANEL INSTALL
# ===============================
if [[ "$CHOICE" == "1" ]]; then
  echo -e "\n📥 Cloning Teryx Panel..."
  git clone https://github.com/teryxlabs/v4panel.git
  cd v4panel

  # 🔍 AUTO FIND package.json
  if [[ -f "panel/package.json" ]]; then
    cd panel
  else
    echo -e "${RED}❌ package.json not found. Install failed.${RESET}"
    exit 1
  fi

  echo -e "\n📦 Installing panel dependencies..."
  npm install

  echo -e "\n🌱 Seeding database..."
  npm run seed

  echo -e "\n👤 Creating admin user..."
  npm run createUser

  read -p "▶️ Start Panel now? (yes/no): " START_PANEL
  if [[ "$START_PANEL" == "yes" ]]; then
    echo -e "${GREEN}🚀 Starting Panel...${RESET}"
    node .
  else
    echo -e "ℹ️ You can start later using: node ."
  fi
fi

# ===============================
# DAEMON INSTALL
# ===============================
if [[ "$CHOICE" == "2" ]]; then
  echo -e "\n📥 Cloning Teryx Daemon..."
  git clone https://github.com/teryxlabs/daemon.git
  cd daemon

  if [[ -f "daemon/package.json" ]]; then
    cd daemon
  else
    echo -e "${RED}❌ package.json not found in daemon.${RESET}"
    exit 1
  fi

  echo -e "\n📦 Installing daemon dependencies..."
  npm install

  read -p "▶️ Start Daemon now? (yes/no): " START_DAEMON
  if [[ "$START_DAEMON" == "yes" ]]; then
    echo -e "${GREEN}🚀 Starting Daemon...${RESET}"
    node .
  else
    echo -e "ℹ️ You can start later using: node ."
  fi
fi

echo -e "\n✅ ${GREEN}Installation completed successfully!${RESET}"
