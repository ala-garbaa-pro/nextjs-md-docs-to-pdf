#!/bin/bash

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Source the retrieve_cached_value.sh file
source "$DIR/../cache/retrieve_cached_value.sh"

# Source the update_cache.sh file
source "$DIR/../cache/update_cache.sh"

# Function to get the last push date
get_last_push_date() {
    local last_push_date
    local store_cache_file="$1"
    local debug_latest_version="$2"

    # Function to display information
    display_info() {
        local message="$1"
        if [[ "$debug_latest_version" == "debug_true" ]]; then
            echo "DEBUG(get_latest_version): $message"
        fi
    }

    if [[ "$debug_latest_version" == "debug_true" ]]; then
        echo -e "\n"
    fi

    # Retrieve cached last_push_date if available
    display_info "Retrieve cached last_push_date if available"
    last_push_date=$(retrieve_cached_value "last_push_date")

    if [[ -z "$last_push_date" ]]; then
        display_info "^___ No, fetch last push date from public GitHubAPI"
        local response=$(curl -s "$url/commits?per_page=1")
        last_push_date=$(echo "$response" | grep -Po '"date": "\K.*?(?=")' | head -n 1)
        last_push_date=$(date -u -d "$last_push_date" +"%Y-%m-%d")
        update_cache "$store_cache_file" "last_push_date" "$last_push_date"
        display_info "update the cache with new last push date"
    fi

    echo "$last_push_date"
}