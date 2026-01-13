#!/usr/bin/env bash
clear

echo -e "\e[1;97m"
echo "██╗████████╗███████╗     ██╗   ██╗████████╗ █████╗ ███╗   ██╗███████╗██╗  ██╗"
echo "██║╚══██╔══╝╚══███╔╝     ╚██╗ ██╔╝╚══██╔══╝██╔══██╗████╗  ██║██╔════╝██║  ██║"
echo "██║   ██║     ███╔╝       ╚████╔╝    ██║   ███████║██╔██╗ ██║███████╗███████║"
echo "██║   ██║    ███╔╝         ╚██╔╝     ██║   ██╔══██║██║╚██╗██║╚════██║██╔══██║"
echo "██║   ██║   ███████╗        ██║      ██║   ██║  ██║██║ ╚████║███████║██║  ██║"
echo "╚═╝   ╚═╝   ╚══════╝        ╚═╝      ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"
echo -e "\e[0m"

echo "=========================================================="
echo "              AI MASTER IS HERE BY (ITZ_YTANSH            "
echo "=========================================================="

mkdir -p ~/TheAI_Master/outputs

type() {
  for ((i=0;i<${#1};i++)); do
    printf "%s" "${1:$i:1}"
    sleep 0.02
  done
  echo
}

ai_intro() {
  type "🤖 THE AI MASTER"
  sleep 0.5
  type "Hello 👋 I am your personal AI."
  type "What do you want to do today?"
}

auto_reply() {
  msg="$1"
  case "$msg" in
    *minecraft*|*server*)
      type "Minecraft ke liye main sab janta hoon 😈"
      type "Free hosting, plugins, setup — sab!"
      ;;
    *hosting*|*vps*)
      type "Free hosting possible hai, lekin smart tarike se."
      type "Main tumhe real methods bataunga."
      ;;
    *youtube*)
      type "YouTube growth ke liye consistency + idea important hai."
      ;;
    *)
      type "Interesting question 🤔 let me think..."
      ;;
  esac
}

image_gen() {
  read -p "Enter image prompt: " p
  type "Generating image for: $p"
  curl -s https://picsum.photos/600 -o ~/TheAI_Master/outputs/image.png
  type "✅ Image downloaded to outputs folder"
}

chat_mode() {
  ai_intro
  while true; do
    read -p "You ➜ " msg
    [[ "$msg" == "exit" ]] && break
    echo "You: $msg" >> ~/TheAI_Master/outputs/chat.txt
    auto_reply "$msg"
    echo "AI: replied to $msg" >> ~/TheAI_Master/outputs/chat.txt
  done
}

menu() {
  echo "----------------------------"
  echo "🤖 THE AI MASTER"
  echo "1) AI Chat"
  echo "2) Generate Image"
  echo "3) Idea Generator"
  echo "0) Exit"
  echo "----------------------------"
  read -p "Choose: " opt

  case $opt in
    1) chat_mode ;;
    2) image_gen ;;
    3)
      type "Here is a crazy idea for you 😈"
      echo "Start a one-click hosting system" > ~/TheAI_Master/outputs/ideas.txt
      ;;
    0) exit ;;
  esac
}

menu
