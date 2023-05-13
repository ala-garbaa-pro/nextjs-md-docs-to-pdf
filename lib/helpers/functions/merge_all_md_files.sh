#!/bin/bash

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

merge_md_files() {
    local directory="$1"
    local output_file="$2"

    # Get all Markdown files in the specified directory
    md_files=()
    while IFS= read -r -d '' file; do
        [[ $file == *.md ]] && md_files+=("$file")
    done < <(find "$directory" -type f -name "*.md" -print0)

    # Sort the Markdown files alphabetically
    IFS=$'\n' md_files=($(sort <<<"${md_files[*]}"))

    # Merge Markdown files into a single string
    merged_content=""
    for md_file in "${md_files[@]}"; do
        content=$(<"$md_file")
        merged_content+="$content\n\n"
    done

    # Write the merged content to a new Markdown file
    echo -e "$merged_content" > "$output_file"
}

merge_all_md_files() {
    local docs_folder="$1"
    local folder_path="$DIR/../../../work/$docs_folder"
    directory="$folder_path"
    output_file="$folder_path.md"
    merge_md_files "$directory" "$output_file"
}
