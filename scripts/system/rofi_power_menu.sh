#!/bin/bash

choice=$(echo -e "Shutdown\nRestart\nLock Screen\nLogout" | rofi -dmenu -i)
case "$choice" in
    "Shutdown")
        confirmation=$(echo -e "Yes\nNo" | rofi -dmenu -i -mesg "Shutdown?")
        case "$confirmation" in
            "Yes") sudo shutdown -h now ;;
            *) ;;
        esac
        sudo shutdown -h now ;;
    "Restart")
        confirmation=$(echo -e "Yes\nNo" | rofi -dmenu -i -mesg "Shutdown?")
        case "$confirmation" in
            "Yes") sudo shutdown -r now ;;
            *) ;;
        esac
    "Logout") awesome -q ;;
    *) ;;
esac

