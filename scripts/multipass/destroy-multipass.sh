#!/usr/bin/env bash

multipass delete --all
multipass purge

sudo launchctl unload /Library/LaunchDaemons/com.canonical.multipassd.plist

sudo rm -rf /var/root/Library/Application\ Support/multipassd
sudo rm -rf /var/root/Library/Caches/multipassd

rm -rf ~/Library/Application\ Support/multipass
