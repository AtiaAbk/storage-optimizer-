#!/bin/bash
echo "Cleaning remaining items..."

rm -rf ~/Library/Application\ Support/Google/Chrome/OptGuideOnDeviceModel 2>/dev/null

npm cache clean --force 2>/dev/null

docker system prune -f 2>/dev/null

rm -f ~/Documents/aws/"Burp Suite Unfiltered - Go from a Beginner to Advanced!.rar" 2>/dev/null

rm -rf ~/Library/Application\ Support/Steam/appcache 2>/dev/null
rm -rf ~/Library/Application\ Support/Steam/logs 2>/dev/null
rm -rf ~/Library/Application\ Support/Steam/dumps 2>/dev/null

rm -rf ~/Library/Application\ Support/sklauncher/cache 2>/dev/null

rm -rf ~/Library/Group\ Containers/group.net.whatsapp.WhatsApp.shared/Message/Media 2>/dev/null

echo ""
echo "Done. Current disk space:"
df -h /
