#!/bin/bash

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# Source the retrieve_cached_value.sh file
source "$DIR/../cache/retrieve_cached_value.sh"

# Source the fetch_latest_version.sh file
source "$DIR/../api/fetch_latest_version.sh"

# Source the update_cache.sh file
source "$DIR/../cache/update_cache.sh"

# Function to fetch the latest version
get_latest_version() {
    local store_cache_file="$1"
    local url="$2"
    local cache_duration="$3"
    local debug_latest_version="$4"
    local latest_version

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

    display_info "Check if cache file exists"
    if [[ -f "$store_cache_file" ]]; then
        display_info "^___ Yes, The cache file exists."
        
        display_info "Check if the cache file is within the cache duration"
        if [[ $(($(date +%s) - $(stat -c %Y "$store_cache_file"))) -le $cache_duration ]]; then
            display_info "^___ Yes, retrieve cached value for latest_version"
            latest_version=$(retrieve_cached_value "$store_cache_file" "latest_version")
        else
            display_info "^___ No, fetch latest version from public GitHubAPI"
            latest_version=$(fetch_latest_version "$store_cache_file" "$url")

            update_cache "$store_cache_file" "latest_version" "$latest_version"
            display_info "Cache updated with new latest_version"
        fi
    else
        display_info "^___ No, $store_cache_file does not exist."
        touch "$store_cache_file"
        display_info "The file was created."

        latest_version=$(fetch_latest_version "$store_cache_file" "$url")
        display_info "Latest version version: $latest_version"

        update_cache "$store_cache_file" "latest_version" "$latest_version"
        display_info "Cache updated with new latest_version"
    fi

    echo "$latest_version"
}