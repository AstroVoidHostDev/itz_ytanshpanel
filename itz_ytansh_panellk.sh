#!/bin/bash

# ================= COLORS =================
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
BOLD="\e[1m"
RESET="\e[0m"

# ================= BANNER =================
banner() {
clear
echo -e "${BOLD}${CYAN}"
echo "██╗████████╗███████╗     ██╗   ██╗████████╗ █████╗ ███╗   ██╗███████╗██╗  ██╗"
echo "██║╚══██╔══╝╚══███╔╝     ╚██╗ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██║  ██║"
echo "██║   ██║     ███╔╝       ╚████╔╝    ██║   ███████║██╔██╗ ██║███████╗███████║"
echo "██║   ██║    ███╔╝         ╚██╔╝     ██║   ██╔══██║██║╚██╗██║╚════██║██╔══██║"
echo "██║   ██║   ███████╗        ██║      ██║   ██║  ██║██║ ╚████║███████║██║  ██║"
echo "╚═╝   ╚═╝   ╚══════╝        ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "${RESET}"
echo -e "${BOLD}${YELLOW}        🚀 ITZ_YTANSH ATERNOS 24X7 CREATOR 🚀${RESET}"
echo
}

pause() {
read -p "Press ENTER to continue..."
}

# ================= DEP确保 =================
install_deps() {
echo -e "${CYAN}🔧 Installing dependencies...${RESET}"
apt update -y
apt install -y curl git zip unzip
curl -fsSL https://deb.nodesource.com/setup_23.x | bash -
apt install -y nodejs
npm install -g pm2
}

# ================= PANEL =================
install_panel() {
clear
banner
echo -e "${GREEN}📦 Installing Teryx PANEL...${RESET}"

install_deps

git clone https://github.com/teryxlabs/v4panel panel
cd panel || exit

npm install
npm run seed
npm run createUser

echo
echo -e "${GREEN}✅ PANEL INSTALLED SUCCESSFULLY${RESET}"
echo -e "${CYAN}▶ Start with:${RESET}"
echo -e "   node ."
echo -e "   or"
echo -e "   pm2 start . --name TERYX_PANEL"
pause
}

# ================= DAEMON =================
install_daemon() {
clear
banner
echo -e "${GREEN}⚙️ Installing Teryx DAEMON...${RESET}"

install_deps

git clone https://github.com/teryxlabs/daemon daemon
cd daemon || exit

npm install

echo
echo -e "${GREEN}✅ DAEMON INSTALLED SUCCESSFULLY${RESET}"
echo -e "${CYAN}▶ Start with:${RESET}"
echo -e "   node ."
echo -e "   or"
echo -e "   pm2 start . --name TERYX_DAEMON"
pause
}

# ================= MENU =================
while true
do
banner
echo -e "${YELLOW}[1] 🚀 Install Teryx PANEL"
echo -e "[2] ⚙️ Install Teryx DAEMON"
echo -e "[0] ❌ Exit${RESET}"
echo
read -p "Choose option -> " opt

case $opt in
  1) install_panel ;;
  2) install_daemon ;;
  0) exit ;;
  *) echo -e "${RED}Invalid option${RESET}"; pause ;;
esac
done
