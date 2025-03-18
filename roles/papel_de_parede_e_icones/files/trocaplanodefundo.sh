#!/bin/sh
dconf write /org/mate/desktop/background/picture-filename "'/home/fundo_ifsc_sj.jpg'"
gsettings set org.gnome.desktop.background picture-uri /home/fundo_ifsc_sj.jpg
gsettings set org.cinnamon.desktop.background picture-uri  "file:///home/fundo_ifsc_sj.jpg"