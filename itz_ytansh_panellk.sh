#!/bin/bash
set -e

echo "🚀 Starting Panel Installation..."

# ---- Requirements ----
apt update -y
apt install -y curl git unzip nodejs npm

# ---- Clone Panel Repo ----
echo "📥 Cloning Panel Repository..."
git clone https://github.com/AstroVoidHostDev/itz_ytanshpanel.git v4panel
cd v4panel

# ---- Extract Panel ----
if [ ! -f panel.zip ]; then
  echo "❌ panel.zip not found!"
  exit 1
fi

echo "📦 Extracting panel.zip..."
unzip -o panel.zip

# ---- Check package.json ----
if [ ! -f package.json ]; then
  echo "❌ package.json missing after unzip!"
  exit 1
fi

# ---- Install Node Modules ----
echo "📦 Installing Node dependencies..."
npm install

# ---- Config Setup ----
echo "⚙️ Panel Configuration"
read -p "Admin Email: " P_EMAIL
read -p "Admin Username: " P_USER
read -s -p "Admin Password: " P_PASS
echo ""

cat > config.json <<EOF
{
  "port": 3000,
  "sessionSecret": "CHANGE_ME_SECRET",
  "remoteKey": "CHANGE_ME_DAEMON_KEY",
  "admin": {
    "email": "$P_EMAIL",
    "username": "$P_USER",
    "password": "$P_PASS"
  }
}
EOF

echo "✅ Panel Config Saved"

# ---- Start Panel ----
read -p "🚀 Start Panel now? (yes/no): " START
if [[ "$START" == "yes" ]]; then
  node index.js
else
  echo "ℹ️ Start later using: cd v4panel && node index.js"
fi
