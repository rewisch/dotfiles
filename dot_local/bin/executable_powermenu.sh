#!/usr/bin/env bash

choice=$(printf "Shutdown\nReboot\nCancel" | rofi -dmenu -p "Power")

case "$choice" in
  Shutdown)
    systemctl poweroff
    ;;
  Reboot)
    systemctl reboot
    ;;
esac
