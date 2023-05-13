#!/bin/bash

# Function to update the cache file
update_cache() {
    local store_cache_file="$1"
    local key="$2"
    local value="$3"

    if [[ -f "$store_cache_file" ]]; then
        sed -i "/^$key=/d" "$store_cache_file"
    fi

    echo "$key=$value" >> "$store_cache_file"
}