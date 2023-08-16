#!/bin/bash

choice=$(echo -e "Shutdown\nRestart" | rofi -dmenu -i -p "Power Menu")

case "$choice" in
    "Shutdown") sudo shutdown -h now ;;
    "Restart") sudo shutdown -r now ;;
    *) ;;
esac

