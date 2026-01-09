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
echo "=========== ITZ_YTANSH Teryx Panel & Daemon Installer ==========="
echo "1) Install Teryx Panel"
echo "2) Install Draco Daemon"
echo "3) Subscribe to ITZ_YTANSH ❤️"
echo "4) Exit"
echo "================================================================"
read -p "Select option: " opt

# ---------- PANEL ----------
install_panel() {
  echo "🚀 Installing Teryx Panel..."

  apt update -y
  curl -sL https://deb.nodesource.com/setup_23.x | bash -
  apt-get install -y nodejs git zip unzip
  npm install -g pm2

  git clone https://github.com/teryxlabs/v4panel
  cd v4panel

  apt install zip -y
  unzip panel.zip || true

  npm install
  npm run seed
  npm run createUser

  pm2 start index.js --name teryx-panel
  pm2 save
  pm2 startup

  echo
  echo "======================================"
  echo "✅ TERYX PANEL INSTALLED SUCCESSFULLY"
  echo "🌐 Panel is now running with PM2 (24/7)"
  echo "💡 Use: pm2 logs teryx-panel"
  echo "======================================"
}

# ---------- DAEMON ----------
install_daemon() {
  echo "⚙️ Installing Draco Daemon..."

  apt update -y
  apt install -y nodejs git zip unzip
  npm install -g pm2

  cd /opt
  git clone https://github.com/dragonlabsdev/daemon
  cd daemon

  apt install zip -y
  unzip daemon.zip || true
  cd daemon || true

  npm install

  echo
  echo "🔑 CONFIGURE DAEMON WITH PANEL"
  echo
  echo -e "\e[90mExample command:\e[0m"
  echo -e "\e[90mnpm run configure -- --panel http://panel.example.com --key d542xxxx-0xxx-45xx-b4xx-xxxxxxxxxx\e[0m"
  echo
  echo "👇 Paste your REAL command below:"
  read -p "> " USER_CMD

  # replace panel URL with localhost
  FIXED_CMD=$(echo "$USER_CMD" | sed -E 's|--panel https?://[^ ]+|--panel http://localhost:3000|')

  echo
  echo "✅ Using fixed command:"
  echo -e "\e[92m$FIXED_CMD\e[0m"
  echo

  eval $FIXED_CMD

  pm2 start index.js --name draco-daemon
  pm2 save
  pm2 startup

  echo
  echo "======================================"
  echo "✅ DAEMON CONFIGURED & STARTED"
  echo "🔗 Panel URL forced to http://localhost:3000"
  echo "⚙️ Running with PM2 (24/7)"
  echo "======================================"
}
# ---------- SUBSCRIBE ----------
subscribe() {
  clear
  echo
  echo "❤️ SUPPORT & SUBSCRIBE ❤️"
  echo
  echo "👉 https://www.youtube.com/@ITZ_YT_ANSH_OFFICIAL"
  echo "Thanks For Using Cmd Also!!"
}

case $opt in
  1) install_panel ;;
  2) install_daemon ;;
  3) subscribe ;;
  4) exit ;;
  *) echo "❌ Invalid option" ;;
esac
