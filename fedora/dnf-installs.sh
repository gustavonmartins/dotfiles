#!/bin/bash
sudo dnf install acl awesome evince flatpak fuse-libs gajim gnucash geany htop keepassxc libreoffice python3-pip obfs4 qbittorrent redshift-gtk rofi thunderbird tor torbrowser-launcher skim syncthing             

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.telegram.desktop

