#!/bin/bash

# Function to display a big title with colors
display_big_title() {
    local title="$1"

    # ANSI color codes
    local bold="\e[1m"
    local underline="\e[4m"
    local reset="\e[0m"
    local violet="\e[35m"
    local green="\e[32m"

    # Function to generate a full-width line of "=" characters
    generate_full_line() {
        local terminal_width=$(tput cols)
        local line=$(printf "%${terminal_width}s" | tr ' ' '=')
        echo -e "${violet}${line}${reset}"
    }

    # Function to calculate the padding
    calculate_padding() {
        local title_length=${#1}
        local terminal_width=$(tput cols)
        local padding=$(( (terminal_width - title_length) / 2 ))
        echo "${padding}"
    }

    # Get the padding for the title
    padding=$(calculate_padding "${title}")

    # Print the full-width top line
    echo "$(generate_full_line)"

    # Print the centered title
    echo -e "$(printf "%*s%s%*s" ${padding} "" "${bold}${green}${title}${reset}" ${padding} "")"

    # Print the full-width bottom line
    echo "$(generate_full_line)"
}