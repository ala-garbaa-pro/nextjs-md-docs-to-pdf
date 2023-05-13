
#!/bin/bash

# Function to fetch the latest version from the API
fetch_latest_version() {
    local response_code
    local latest_version
    local store_cache_file="$1"
    local url="$2"

    response_code=$(curl -s -o /dev/null -w "%{http_code}" "$url/releases/latest")

    if [[ $response_code == "200" ]]; then
        latest_version=$(curl -s "$url/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
        echo "$latest_version"
    else
        latest_version=$(retrieve_cached_value "$store_cache_file" "latest_version")
        if [[ -z "$latest_version" ]]; then
            exit 1
        fi
    fi
}