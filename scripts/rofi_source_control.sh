#!/bin/bash

# Get the list of available sources
sources=($(pactl list short sources | awk '{print $2}'))

# Use Rofi to display the list and choose a source
chosen_source=$(printf '%s\n' "${sources[@]}" | rofi -dmenu -p "Select audio source:")

if [ -n "$chosen_source" ]; then
    # Set the chosen source as the default source
    pactl set-default-source "$chosen_source"

    # Show a notification
    notify-send "Audio source switched to $chosen_source"
fi

