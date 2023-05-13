#!/bin/bash

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Check if the docs folder exists on the remote repository
clone_docs_folder() {
    local repo_owner="vercel"
    local repo_name="next.js"
    local docs_folder="$1"

    local response=$(curl --head -s -o /dev/null -w "%{http_code}" "https://api.github.com/repos/$repo_owner/$repo_name/contents/docs")
    
    if [ "$response" = "200" ]; then
        echo "The 'docs' folder exists in the remote repository."
        start_clone_docs_folder "$docs_folder"
    else
        echo "The 'docs' folder does not exist in the remote repository."
    fi
}

# clone docs folder
start_clone_docs_folder() {
    local folder_path="$DIR/../../../work/"
    local docs_folder="$1"

    cd "$folder_path" && \
    git clone https://github.com/vercel/next.js.git --depth 1 --filter=blob:none --sparse && \
    cd next.js && \
    git sparse-checkout init && \
    git sparse-checkout set docs && \
    mv ./docs "../$docs_folder" && \
    cd .. && \
    rm -rf next.js
}