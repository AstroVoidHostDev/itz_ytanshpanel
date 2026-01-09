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
echo "+=========== ITZ_YTANSH  Hosting Installer (CodeSandBox) ===========+"
echo "1) 🔥 Install Panel"
echo "2) ⚡ Install Node"
echo "3) ❤️ Subscribe to ITZ_YTANSH "
echo "4) ➡️ Exit"
echo "+================================================================+"
read -p "Select option: " opt

# ---------- PANEL ----------
install_panel() {

  read -p "⚙️ Are you sure you want to install? (yes/no): " confirm
[[ "$confirm" == "yes" ]] || { echo "❌ Installation cancelled"; exit 1; }

  echo "🚀 Installing Panel..."

  apt update -y
  curl -sL https://deb.nodesource.com/setup_23.x | bash -
  apt-get install -y nodejs git zip unzip
  npm install -g pm2

echo "⚙️ Cloning Panel Files...."

  git clone https://github.com/teryxlabs/v4panel
  cd v4panel

echo "📂 Unziping Panel Files.."

  apt install zip -y
  unzip panel.zip || true

  npm install
  npm run seed

  echo "▶️ Creating User For Panel"
  
  npm run createUser
echo "🚀 Launching Panel"

  pm2 start index.js --name panel
  pm2 save
  pm2 startup

  echo
  echo "======================================"
  echo "✅  PANEL INSTALLED SUCCESSFULLY"
  echo "🌐 Panel is now Live In Port 3000"
  echo "💡 Use: pm2 list For 💥 Info"
  echo "👑 Owner Of Panel: **HopingBoyz**"
  echo "======================================"

  echo "🧩 For Node Relauch The Cmd!"
}

# ---------- DAEMON ----------
install_node() {

echo
echo "🚧 Node / Daemon is not available yet"
echo "⚙️  Working on it, please wait..."
}

spinner='|/-\'
for i in {1..20}; do
  printf "\r⏳ Initializing %s" "${spinner:i%4:1}"
  sleep 0.2
done

printf "\r✅ Status: Still in progress, please check back soon.\n"
echo

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
  2) install_node ;;
  3) subscribe ;;
  4) exit ;;
  *) echo "❌ Invalid option" ;;
esac
