#!/bin/bash

choice=$(echo -e "Shutdown\nRestart\nLogout" | rofi -dmenu -i)
case "$choice" in
    "Shutdown")
        confirmation=$(echo -e "Yes\nNo" | rofi -dmenu -i -mesg "Shutdown?")
        case "$confirmation" in
            "Yes") shutdown now ;;
            *) ;;
        esac
        ;;
    "Restart")
        confirmation=$(echo -e "Yes\nNo" | rofi -dmenu -i -mesg "Restart?")
        case "$confirmation" in
            "Yes") shutdown -r now ;;
            *) ;;
        esac
        ;;
    "Logout") awesome -q ;;
    *) ;;
esac

