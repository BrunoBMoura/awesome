#!/bin/bash

# Get a list of all available sinks.
sink_info=$(pactl list sinks | grep 'Name:\|Description:')
sinks=()

# Parse the sink info to get the sink name and description
# concatenated by a single dash ' - '.
while IFS= read -r line; do
    if [[ $line == *"Name:"* ]]; then
        sink_name=${line##*: }
    elif [[ $line == *"Description:"* ]]; then
        sink_description=${line##*: }
        sinks+=("$sink_description - $sink_name")
    fi
done <<< "$sink_info"

# Use Rofi to display the list and choose a sink.
chosen_sink=$(printf '%s\n' "${sinks[@]}" | rofi -i -dmenu)

if [ -n "$chosen_sink" ]; then
    # Extract the actual sink (system and readable) names from the chosen string.
    chosen_sink_name=$(echo "$chosen_sink" | awk -F ' - ' '{print $2}')
    chosen_sink_readable_name=$(echo "$chosen_sink" | awk -F ' - ' '{print $1}')

    # Set the chosen sink as the default sink.
    pactl set-default-sink "$chosen_sink_name"

    # And move existing audio streams to the new sink,
    for stream in $(pactl list short sink-inputs | awk '{print $1}'); do
        pactl move-sink-input "$stream" "$chosen_sink_name"
    done

    # Finally, notify that the new sink is now set.
    notify-send "Audio output switched to: $chosen_sink_readable_name"
fi

