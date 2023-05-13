#!/bin/bash

# -------------- SOURCES ----------------->
# Source the helpers.sh file
source ./lib/helpers/display/display_big_title.sh
source ./lib/helpers/display/display_global_info.sh

# Source the config.sh file
source ./lib/config.sh

# Source the get_latest_version.sh file
source lib/helpers/functions/get_latest_version.sh

# Source the get_last_push_date.sh file
source lib/helpers/functions/get_last_push_date.sh

# Source the check_docs_folder_exists.sh file
source lib/helpers/functions/check_docs_folder_exists.sh

# Source the clone_docs_folder.sh file
source lib/helpers/functions/clone_docs_folder.sh

# Source the merge_all_md_files.sh file
source lib/helpers/functions/merge_all_md_files.sh
# <-------------- SOURCES -----------------

##################################################################

# Display the big title
display_big_title "NextJS Docs To PDF"

# Fetch the latest version
latest_version=$(get_latest_version $config__store_cache_file $config__api_endpoint_url $config__cache_duration "debug_false")

# Get the last push date
last_push_date=$(get_last_push_date $config__store_cache_file "debug_false")

# Generate a unique ID using the latest version and the last push date
unique_id="next-js--${latest_version}--${last_push_date}"
docs_folder="docs--$unique_id"

# Print the values
echo -e ""
display_global_info "Latest Docs Version" "$latest_version"
display_global_info "Last Docs Push Date" "$last_push_date"
display_global_info "Generated Unique ID" "$unique_id"
display_global_info "Docs folder" "$docs_folder"
echo -e ""

check_docs_folder_exists "$docs_folder" display_global_info

if [ $? -eq 1 ]; then
    display_global_info "Start cloning the docs" "yes"
    clone_docs_folder "$docs_folder"
fi

echo ""

function merge_the_file_fn() {
    rm -fr "./work/$docs_folder.md"
    display_global_info "Merge all md files to one md file" "yes"
    merge_all_md_files "$docs_folder"
}

if [ -f "./work/$docs_folder.md" ]; then
    echo "The file './work/$docs_folder.md' already exists."
    echo "Do you want to merge them again? (y/n)"
    read merge_again

    if [ "$merge_again" == "y" ]; then
        # Perform the merge operation again
        echo "Perform the merge operation again"
        merge_the_file_fn
    else
        echo "Skipping the merge operation."
    fi
else
    # Perform the merge operation
    echo "Perform the merge operation"
    merge_the_file_fn
fi

echo ""


function convert_md_to_pdf_fn() {
rm -fr "./work/$docs_folder.pdf"
display_global_info "Convert md to pdf" "yes"
node <<EOF
const fs = require('fs');
const { marked } = require('marked');
const puppeteer = require('puppeteer');

// Read the Markdown file
fs.promises.readFile('./work/$docs_folder.md', 'utf8')
  .then((data) => {
    // Convert Markdown to HTML
    const html = marked(data);

    // Launch a headless Chrome browser
    puppeteer.launch()
      .then((browser) => {
        return browser.newPage()
          .then((page) => {
            // Set the HTML content of the page
            return page.setContent(html)
              .then(() => {
                // Generate the PDF
                return page.pdf({ path: './work/$docs_folder.pdf', format: 'A4' })
                  .then(() => {
                    // Close the browser
                    return browser.close();
                  });
              });
          });
      })
      .then(() => {
        console.log('Markdown converted to PDF and saved to ./work/$docs_folder.pdf');
      })
      .catch((error) => {
        console.error('Error converting to PDF:', error);
      });
  })
  .catch((err) => {
    console.error('Error reading file:', err);
  });
EOF
}



if [ -f "./work/$docs_folder.pdf" ]; then
    echo "The file './work/$docs_folder.pdf' already exists."
    echo "Do you want to convert it again? (y/n)"
    read convert_again

    if [ "$convert_again" == "y" ]; then
        # Perform the convert operation again
        echo "Perform the convert operation again"
        convert_md_to_pdf_fn
    else
        echo "Skipping the convert operation."
    fi
else
    # Perform the convert operation
    echo "Perform the convert operation"
    convert_md_to_pdf_fn
fi