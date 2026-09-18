#!/bin/bash
echo "============================================"
echo " FINAL CLEANUP — confirmed items only"
echo " Windows VM & Ubuntu VM disk files: NOT touched"
echo "============================================"

df -h / | tail -1
echo ""

### 1. Ubuntu VM recovery backup snapshot (~4GB)
###    This is a separate backup copy, NOT the live VM itself.
###    Live Ubuntu VM (~/Virtual Machines.localized/Ubuntu...vmwarevm) stays untouched.
echo "[1/3] Removing VM recovery backup snapshot..."
rm -rf ~/Desktop/Ubuntu-VM-RECOVERY-BACKUP 2>/dev/null

### 2. WhatsApp locally cached media (~3GB)
###    Only the local Mac cache. Your chats, and the media on your phone / WhatsApp cloud
###    backup, are not affected.
echo "[2/3] Removing WhatsApp local media cache..."
rm -rf ~/Library/Group\ Containers/group.net.whatsapp.WhatsApp.shared/Message/Media 2>/dev/null


echo ""
echo "Done. Current disk space:"
df -h /
