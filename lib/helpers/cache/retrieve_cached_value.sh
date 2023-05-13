#!/bin/bash

# Function to retrieve cached values
retrieve_cached_value() {
    local store_cache_file="$1"
    local key="$2"
    local value

    if [[ -f "$store_cache_file" ]]; then
        value=$(grep -E "^$key=" "$store_cache_file" | cut -d "=" -f 2-)
    fi

    echo "$value"
}
