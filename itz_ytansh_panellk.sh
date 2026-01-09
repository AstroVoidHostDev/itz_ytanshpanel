#!/bin/bash
set -e

clear
echo "========================================="
echo "   ITZ_YTANSH – Teryx Panel & Daemon"
echo "========================================="
echo "1) Install Teryx Panel"
echo "2) Install Draco Daemon"
echo "3) Install BOTH (Panel + Daemon)"
echo "4) Exit"
echo "========================================="
read -p "Select option: " opt

# ---------- COMMON ----------
apt update -y
apt install -y curl git zip unzip

if ! command -v node >/dev/null 2>&1; then
  curl -sL https://deb.nodesource.com/setup_23.x | bash -
  apt install -y nodejs
fi

npm install -g pm2

# ---------- PANEL ----------
install_panel() {
  echo "🚀 Installing Teryx Panel..."

  cd /opt
  git clone https://github.com/teryxlabs/v4panel.git
  cd v4panel

  npm install
  npm run seed

  echo "👤 Create Admin User"
  npm run createUser

  # generate panel key
  PANEL_KEY=$(openssl rand -hex 32)

  cat > config.json <<EOF
{
  "panelKey": "$PANEL_KEY",
  "port": 3000
}
EOF

  pm2 start index.js --name teryx-panel
  pm2 save
  pm2 startup systemd -u root --hp /root

  echo "✅ Panel Installed"
  echo "🔑 PANEL API KEY: $PANEL_KEY"
}

# ---------- DAEMON ----------
install_daemon() {
  echo "⚙️ Installing Draco Daemon..."

  cd /opt
  git clone https://github.com/dragonlabsdev/daemon.git
  cd daemon

  npm install

  read -p "🌐 Enter PANEL URL (http://IP:3000): " PANEL_URL
  read -p "🔑 Enter PANEL API KEY: " PANEL_KEY

  DAEMON_KEY=$(openssl rand -hex 32)

  cat > .env <<EOF
PANEL_URL=$PANEL_URL
REMOTE_KEY=$PANEL_KEY
DAEMON_KEY=$DAEMON_KEY
PORT=8080
EOF

  pm2 start index.js --name draco-daemon
  pm2 save

  echo "✅ Daemon Installed"
  echo "🔑 DAEMON KEY: $DAEMON_KEY"
  echo "👉 Paste this DAEMON KEY in Panel config"
}

# ---------- MENU LOGIC ----------
case $opt in
  1) install_panel ;;
  2) install_daemon ;;
  3)
     install_panel
     install_daemon
     ;;
  4) exit ;;
  *) echo "❌ Invalid option" ;;
esac
