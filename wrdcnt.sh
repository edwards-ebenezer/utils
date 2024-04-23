#!/bin/bash

# Function to process a single file
process_file() {
    input_file="$1"
    word_count=0
    # Temporary file to store modified content
    temp_file=$(mktemp)

    # Process each line of the input file
    while IFS= read -r line; do
        # Calculate the number of words in the current line
        line_word_count=$(echo "$line" | wc -w)
        # Output the total word count followed by the line
        echo -e "${word_count}\t${line}"
        # Increment the total word count for the next line
        word_count=$((word_count + line_word_count))
    done < "$input_file" > "$temp_file"

    # Overwrite the original file with the modified content
    mv "$temp_file" "$input_file"
}

# If no argument is provided, process all .txt files in the current directory
if [ $# -eq 0 ]; then
    for file in *.txt; do
        if [ -f "$file" ]; then
            process_file "$file"
        fi
    done
# If an argument is provided, process the specified file
else
    process_file "$1"
fi
