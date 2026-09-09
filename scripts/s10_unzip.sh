#!/bin/bash

#set -x

if [ "$#" -lt 1 ]; then
    echo "Error: Not enough arguments."
    echo "Usage: $0 <group>"
    exit 1
fi

GROUP="$1"

if [ ! -d "/workspace/submissions/$GROUP" ]; then
    echo "Error: '/workspace/submissions/$GROUP' is not a directory."
    exit 1
fi

# Create a list of zip files (without .zip extension)
find "/workspace/submissions/$GROUP" -maxdepth 1 -type f -name "*.zip" -printf "%f\n" | sed 's/.zip$//' > "/workspace/submissions/$GROUP/submissions.txt"

while IFS= read -r E; do
    echo "Processing: $E"

    unzip -a -u -d "/workspace/submissions/$GROUP/$E" "/workspace/submissions/$GROUP/$E.zip" >/dev/null

    # Remove __MACOSX directory if present
    if [ -d "/workspace/submissions/$GROUP/$E/__MACOSX" ]; then
        echo "  → Removing __MACOSX directory"
        rm -rf "/workspace/submissions/$GROUP/$E/__MACOSX"
    fi

    # Detect and flatten an extra subdirectory (e.g., "$E/$E" or "$E/<random_folder>")
    SUBDIRS=($(find "/workspace/submissions/$GROUP/$E" -mindepth 1 -maxdepth 1 -type d ! -name "__MACOSX"))

    if [ "${#SUBDIRS[@]}" -eq 1 ]; then
        echo "  → Flattening nested subdirectory: ${SUBDIRS[0]##*/}"
        mv "${SUBDIRS[0]}"/* "/workspace/submissions/$GROUP/$E"/ 2>/dev/null
        rmdir "${SUBDIRS[0]}" 2>/dev/null || true
    fi

done < "/workspace/submissions/$GROUP/submissions.txt"