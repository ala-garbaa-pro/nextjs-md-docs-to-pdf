#!/bin/bash

# File: config.sh

# GitHub API endpoint for the Next.js repository
export config__api_endpoint_url="https://api.github.com/repos/vercel/next.js"
export config__store_cache_file=".store.cache"
# Cache duration in seconds (1 hour = 3600 seconds)
export config__cache_duration=3600