#!/bin/bash
sudo dnf install qbittorrent syncthing awesome rofi libreoffice geany thunderbird htop skim redshift-gtk evince gajim flatpak python3-pip keepassxc

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.telegram.desktop

