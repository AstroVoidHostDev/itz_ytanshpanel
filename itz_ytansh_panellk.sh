#!/bin/bash

# ========== COLORS ==========
BOLD="\e[1m"
CYAN="\e[36m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

clear

# ========== BANNER ==========
echo -e "${BOLD}${CYAN}"
echo "██╗████████╗███████╗     ██╗   ██╗████████╗ █████╗ ███╗   ██╗███████╗██╗  ██╗"
echo "██║╚══██╔══╝╚══███╔╝     ╚██╗ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██║  ██║"
echo "██║   ██║     ███╔╝       ╚████╔╝    ██║   ███████║██╔██╗ ██║███████╗███████║"
echo "██║   ██║    ███╔╝         ╚██╔╝     ██║   ██╔══██║██║╚██╗██║╚════██║██╔══██║"
echo "╚═╝   ╚═╝   ╚══════╝        ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "${RESET}"
echo -e "${BOLD}${YELLOW}🚀 ITZ_YTANSH PANEL & DAEMON ONE-CLICK INSTALLER${RESET}\n"

# ========== MENU ==========
echo -e "${GREEN}[1] Install Teryx Panel"
echo -e "[2] Install Teryx Daemon${RESET}\n"
read -p "👉 Choose option (1/2): " opt

# ========== COMMON DEPENDENCIES ==========
install_common() {
  echo -e "${CYAN}🔧 Installing dependencies...${RESET}"
  apt update -y
  apt install -y git curl unzip zip
  curl -fsSL https://deb.nodesource.com/setup_23.x | bash -
  apt install -y nodejs
  npm install -g pm2
}

# ========== PANEL ==========
install_panel() {
  install_common

  echo -e "${CYAN}📥 Cloning Teryx Panel...${RESET}"
  rm -rf v4panel
  git clone https://github.com/teryxlabs/v4panel.git

  cd v4panel || exit 1

  echo -e "${CYAN}📦 Installing panel dependencies...${RESET}"
  npm install

  echo -e "${CYAN}🌱 Seeding database...${RESET}"
  npm run seed

  echo -e "${CYAN}👤 Create admin account (email/username/password)...${RESET}"
  npm run createUser

  read -p "▶️ Start panel now? (yes/no): " startp
  if [[ "$startp" == "yes" ]]; then
    pm2 start node --name teryx-panel -- .
    pm2 save
    echo -e "${GREEN}✅ Panel started successfully 🎉${RESET}"
    pm2 list
  else
    echo -e "${YELLOW}⏸ Panel installed but not started${RESET}"
  fi
}

# ========== DAEMON ==========
install_daemon() {
  install_common

  echo -e "${CYAN}📥 Cloning Teryx Daemon...${RESET}"
  rm -rf daemon
  git clone https://github.com/teryxlabs/daemon.git

  cd daemon || exit 1

  echo -e "${CYAN}📦 Installing daemon dependencies...${RESET}"
  npm install

  echo -e "${CYAN}⚙️ Configure daemon files as required (.env, node id, etc)${RESET}"

  read -p "▶️ Start daemon now? (yes/no): " startd
  if [[ "$startd" == "yes" ]]; then
    pm2 start node --name teryx-daemon -- .
    pm2 save
    echo -e "${GREEN}✅ Daemon started successfully 🚀${RESET}"
    pm2 list
  else
    echo -e "${YELLOW}⏸ Daemon installed but not started${RESET}"
  fi
}

# ========== RUN ==========
case $opt in
  1) install_panel ;;
  2) install_daemon ;;
  *) echo -e "${RED}❌ Invalid option${RESET}" ;;
esac
