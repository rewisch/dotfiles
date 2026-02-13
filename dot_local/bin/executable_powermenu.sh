#!/usr/bin/env bash

choice=$(printf "Shutdown\nReboot\nSuspend" |
  rofi -dmenu -p "Power" -i -lines 4 -columns 1 \
    -theme-str 'listview { columns: 1; }')

case "$choice" in
Shutdown)
  systemctl poweroff
  ;;
Reboot)
  systemctl reboot
  ;;
Suspend)
  systemctl suspend
  ;;
esac
