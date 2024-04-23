#!/bin/bash

# Function to process a single file
process_file() {
    input_file="$1"
    word_count=0
    # Temporary file to store modified text content
    temp_text_file=$(mktemp)
    # Temporary file to store modified odt content
    temp_odt_file=$(mktemp)

    # Check file extension
    if [[ "$input_file" == *.odt ]]; then
        # Extract text content from .odt file
        odt2txt "$input_file" > "$temp_text_file"
    else
        # For other file types, assume it's a text file
        cp "$input_file" "$temp_text_file"
    fi

    # Process each line of the input file
    while IFS= read -r line; do
        # Calculate the number of words in the current line
        line_word_count=$(echo "$line" | wc -w)
        # Output the total word count followed by the line if it contains words
        if [ "$line_word_count" -gt 0 ]; then
            echo -e "${word_count}\t${line}"
        else
            echo "$line" # Output the line as it is if it doesn't contain words
        fi
        # Increment the total word count for the next line
        word_count=$((word_count + line_word_count))
    done < "$temp_text_file" > "$temp_odt_file"

    # Convert modified text back to .odt format if necessary
    if [[ "$input_file" == *.odt ]]; then
        # Convert modified text back to .odt format
        libreoffice --convert-to odt "$temp_odt_file"
    fi
    mv "$temp_odt_file" "$input_file"

    # Clean up temporary files
    rm "$temp_text_file"
    rm ./tmp.odt
}

# If no argument is provided, process all .txt and .odt files in the current directory
if [ $# -eq 0 ]; then
    for file in *.txt *.odt; do
        if [ -f "$file" ]; then
            process_file "$file"
        fi
    done
# If an argument is provided, process the specified file
else
    process_file "$1"
fi
