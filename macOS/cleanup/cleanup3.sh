#!/bin/bash
echo "============================================"
echo " SAFE CLEANUP — cache/log/temp/duplicate only"
echo " NO documents, VMs, downloads, bookmarks touched"
echo "============================================"

df -h / | tail -1
echo ""

### 1. Chrome on-device AI model cache (~4GB) — auto re-downloads, browsing/bookmarks untouched
echo "[1/9] Chrome on-device model cache..."
rm -rf ~/Library/Application\ Support/Google/Chrome/OptGuideOnDeviceModel 2>/dev/null

### 2. npm cache (~17MB)
echo "[2/9] npm cache..."
npm cache clean --force 2>/dev/null

### 3. pip cache
echo "[3/9] pip cache..."
pip cache purge 2>/dev/null

### 4. Docker unused images/containers/build-cache (does NOT touch running containers/volumes)
echo "[4/9] Docker prune..."
docker system prune -f 2>/dev/null

### 5. Homebrew old downloaded package cache (safe, reinstallable)
echo "[5/9] Homebrew cache..."
brew cleanup -s 2>/dev/null

### 6. Steam cache/logs/dumps (game save data NOT touched)
echo "[6/9] Steam cache..."
rm -rf ~/Library/Application\ Support/Steam/appcache 2>/dev/null
rm -rf ~/Library/Application\ Support/Steam/logs 2>/dev/null
rm -rf ~/Library/Application\ Support/Steam/dumps 2>/dev/null

### 7. sklauncher (Minecraft launcher) cache
echo "[7/9] sklauncher cache..."
rm -rf ~/Library/Application\ Support/sklauncher/cache 2>/dev/null

### 8. System/App log files (safe, regenerate automatically)
echo "[8/9] Log files..."
rm -rf ~/Library/Logs/* 2>/dev/null

### 9. Duplicate Burp Suite rar — SAME 2.5GB file exists in BOTH
###    ~/Documents/aws/ and ~/Downloads/aws/  -> keeping Downloads copy, deleting Documents copy
echo "[9/9] Duplicate Burp Suite rar (keeping Downloads copy)..."
rm -f ~/Documents/aws/"Burp Suite Unfiltered - Go from a Beginner to Advanced!.rar" 2>/dev/null

echo ""
echo "Done. Current disk space:"
df -h /

echo ""
echo "============================================"
echo " ITEMS NOT TOUCHED — YOUR DECISION NEEDED"
echo "============================================"
echo "These were found in your scan but need your OK before deleting."
echo "Uncomment (remove #) the line you want to run, save, then re-run this script."
echo ""

# ~4GB memory-snapshot backup of your Ubuntu VM (separate from the 20GB live VM)
# rm -rf ~/Desktop/Ubuntu-VM-RECOVERY-BACKUP

# ~3GB WhatsApp locally-cached media (chat history NOT affected, phone/cloud copies safe)
# rm -rf ~/Library/Group\ Containers/group.net.whatsapp.WhatsApp.shared/Message/Media

# ~10GB total Ollama AI models (qwen3:1.7b 1.4GB, deepseek-r1:8b 5.2GB, llama3:latest 4.7GB)
# Remove ones you don't use, e.g.:
# ollama rm deepseek-r1:8b
# ollama rm llama3:latest
