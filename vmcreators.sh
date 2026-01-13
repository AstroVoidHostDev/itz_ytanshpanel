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


echo "========================================"
echo "  🔥 ITZ_YTANSH KVM VM CREATOR MENU 🔥"
echo "========================================"
echo "1) 🔍 Check KVM Support"
echo "2) ⚙️ Enable Nested KVM"
echo "3) 🚀 Install KVM Stack"
echo "4) 🖥️ Create VM (Ryzen 9 Mode)"
echo "5) 📊 List VMs"
echo "6) 🛑 Stop VM"
echo "7) ❌ Delete VM"
echo "8) ➡️ Exit"
echo "=============================="
read -rp "Select Option: " opt

check_kvm() {
  echo "🔍 Checking Virtualization..."
  if egrep -c '(vmx|svm)' /proc/cpuinfo >/dev/null; then
    echo "✅ CPU Virtualization Supported"
  else
    echo "❌ Virtualization NOT Supported"
    exit 1
  fi

  if [ -e /dev/kvm ]; then
    echo "✅ KVM Available"
  else
    echo "❌ /dev/kvm not found"
    exit 1
  fi
}

enable_nested() {
  echo "⚙️ Enabling Nested Virtualization..."

  if lsmod | grep -q kvm_amd; then
    echo "options kvm_amd nested=1" > /etc/modprobe.d/kvm_amd.conf
    modprobe -r kvm_amd
    modprobe kvm_amd
  elif lsmod | grep -q kvm_intel; then
    echo "options kvm_intel nested=1" > /etc/modprobe.d/kvm_intel.conf
    modprobe -r kvm_intel
    modprobe kvm_intel
  else
    echo "❌ KVM module not loaded"
  fi

  echo "✅ Nested KVM Enabled"
}

install_kvm() {
  echo "🚀 Installing KVM Stack..."
  apt update -y
  apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst cpu-checker
  systemctl enable libvirtd --now
  echo "✅ KVM Installed"
}

create_vm() {
  read -rp "VM Name: " name
  read -rp "RAM (MB): " ram
  read -rp "CPU Cores: " cpu

  echo "🖥️ Creating VM (Ryzen 9 Emulation)..."

  virt-install \
  --name "$name" \
  --ram "$ram" \
  --vcpus "$cpu" \
  --cpu host-model,+topoext \
  --disk path=/var/lib/libvirt/images/$name.qcow2,size=20 \
  --os-variant ubuntu22.04 \
  --network network=default \
  --graphics none \
  --console pty,target_type=serial \
  --location 'http://archive.ubuntu.com/ubuntu/dists/jammy/main/installer-amd64/' \
  --extra-args 'console=ttyS0'

  echo "✅ VM Created"
}

case $opt in
  1) check_kvm ;;
  2) enable_nested ;;
  3) install_kvm ;;
  4) create_vm ;;
  5) virsh list --all ;;
  6) read -rp "VM Name: " vm; virsh shutdown "$vm" ;;
  7) read -rp "VM Name: " vm; virsh undefine "$vm" --remove-all-storage ;;
  8) exit ;;
  *) echo "❌ Invalid Option" ;;
esac
