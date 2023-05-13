#!/bin/bash

# Function to display a line with normal color and bold value
display_global_info() {
    local label="$1"
    local value="$2"

    # ANSI color codes
    local bold="\e[1m"
    local normal_color="\e[39m"
    local blue_sky="\e[94m"
    local reset="\e[0m"

    echo -e "${bold}${normal_color}${label}:${reset} ${bold}${blue_sky}${value}${reset}"
}
