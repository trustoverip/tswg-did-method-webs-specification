#!/bin/bash

# Define normative keywords
keywords="MUST|MUST NOT|REQUIRED|SHALL|SHALL NOT|SHOULD|SHOULD NOT|RECOMMENDED|NOT RECOMMENDED|MAY|OPTIONAL"

# Iterate over all files in the spec directory
for file in $(find spec -type f); do
    # Read the file line by line
    while IFS= read -r line; do
        # Check if the line contains a normative keyword and does not start with '1. ' (allowing whitespace prefixes)
        echo "$line" | awk -v file="$file" -v keywords="$keywords" '( $0 ~ keywords ) && !( $0 ~ /^[[:space:]]*1. / ) {print "File: " file ", Line: " FNR ", Text: " $0}'
    done < "$file"
done