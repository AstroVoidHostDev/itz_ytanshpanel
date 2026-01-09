#!/bin/bash

set -e

clear

# ================== BANNER ==================
echo -e "\033[1;36m"
echo "██╗████████╗███████╗     ██╗   ██╗████████╗ █████╗ ███╗   ██╗███████╗██╗  ██╗"
echo "██║╚══██╔══╝╚══███╔╝     ╚██╗ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██║  ██║"
echo "██║   ██║     ███╔╝       ╚████╔╝    ██║   ███████║██╔██╗ ██║███████╗███████║"
echo "██║   ██║    ███╔╝         ╚██╔╝     ██║   ██╔══██║██║╚██╗██║╚════██║██╔══██║"
echo "╚═╝   ╚═╝   ╚══════╝        ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "\033[1;33m        🚀 ITZ_YTANSH TERYX PANEL&DEAMON INSTALLER 🚀"
echo -e "\033[0m"
echo ""

# ================== CHECK ROOT ==================
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root"
  exit 1
fi

# ================== MENU ==================
echo "Choose what to install:"
echo "1️⃣  Install PANEL (Teryx Panel)"
echo "2️⃣  Install DAEMON (Node)"
echo "3️⃣  Install BOTH (Panel + Daemon)"
echo ""
read -p "Enter choice [1/2/3]: " choice

# ================== COMMON ==================
echo "🔄 Updating system..."
apt update -y && apt upgrade -y

echo "📦 Installing dependencies..."
apt install -y curl git unzip zip build-essential

curl -fsSL https://deb.nodesource.com/setup_23.x | bash -
apt install -y nodejs

npm install -g pm2

# ================== PANEL ==================
install_panel() {
  echo "📥 Installing Teryx Panel..."
  git clone https://github.com/teryxlabs/v4panel panel
  cd panel

  echo "📦 Installing panel dependencies..."
  npm install

  echo "🌱 Seeding database..."
  npm run seed

  echo "👤 Creating admin user..."
  npm run createUser

  pm2 start node --name teryx-panel -- .
  cd ..
}

# ================== DAEMON ==================
install_daemon() {
  echo "📥 Installing Teryx Daemon..."
  git clone https://github.com/teryxlabs/daemon daemon
  cd daemon

  echo "📦 Installing daemon dependencies..."
  npm install

  pm2 start index.js --name teryx-daemon
  cd ..
}

# ================== RUN INSTALL ==================
case $choice in
  1) install_panel ;;
  2) install_daemon ;;
  3) install_panel && install_daemon ;;
  *) echo "❌ Invalid choice" && exit 1 ;;
esac

# ================== USER CONFIG ==================
echo ""
echo "🧑‍💻 FINAL CONFIGURATION"
read -p "📧 Enter Admin Email: " ADMIN_EMAIL
read -p "👤 Enter Username: " ADMIN_USER
read -s -p "🔐 Enter Password: " ADMIN_PASS
echo ""

cat <<EOF > itz_ytansh_config.txt
EMAIL=$ADMIN_EMAIL
USERNAME=$ADMIN_USER
PASSWORD=$ADMIN_PASS
EOF

echo "✅ Credentials saved locally (itz_ytansh_config.txt)"

# ================== START CONFIRM ==================
echo ""
read -p "🚀 Start Panel & Daemon now? (yes/no): " startnow

if [[ "$startnow" == "yes" ]]; then
  pm2 save
  pm2 startup
  pm2 list

  echo ""
  echo "🎉 SUCCESSFULLY STARTED!"
  echo "🟢 Panel & Daemon running"
  echo "🔥 Managed by ITZ_YTANSH"
else
  echo "⏹️ Installation complete. Not started."
fi

echo ""
echo "✅ DONE | ITZ_YTANSH GOD LEVEL INSTALLER 😈🔥"
