# # #!/bin/bash

# # #set -x

# # if [ "$#" -lt 1 ];
# # then
# #     echo "Error. Not enough arguments.\n"
# #     echo "./unzip_all <group>"
# #     exit -1
# # fi

# # ls -1 $1 > $1.txt

# # LIST=$(cat $1.txt | sed 's/.zip//g')

# # for E in $LIST; do
# # 	echo $E

# # 	unzip -a -u -d $1/$E $1/$E".zip"

# # 	#Si al descomprimir existe el subdirectorio se quita el subdirectorio extra
# # 	if [ -d $1/$E/$E ]; then
# # 		mv $1/$E/$E/* $1/$E
# # 		rmdir $1/$E/$E
# # 	fi
# # done

#!/bin/bash

#set -x

if [ "$#" -lt 1 ]; then
    echo "Error: Not enough arguments."
    echo "Usage: $0 <group>"
    exit 1
fi

GROUP_DIR="$1"

if [ ! -d "$GROUP_DIR" ]; then
    echo "Error: '$GROUP_DIR' is not a directory."
    exit 1
fi

# Create a list of zip files (without .zip extension)
find "$GROUP_DIR" -maxdepth 1 -type f -name "*.zip" -printf "%f\n" | sed 's/.zip$//' > "$GROUP_DIR/files.txt"

while IFS= read -r E; do
    echo "Processing: $E"

    unzip -a -u -d "$GROUP_DIR/$E" "$GROUP_DIR/$E.zip" >/dev/null

    # Remove __MACOSX directory if present
    if [ -d "$GROUP_DIR/$E/__MACOSX" ]; then
        echo "  → Removing __MACOSX directory"
        rm -rf "$GROUP_DIR/$E/__MACOSX"
    fi

    # # # If an extra subdirectory exists with the same name as the zip, flatten it
    # # if [ -d "$GROUP_DIR/$E/$E" ]; then
    # #     echo "  → Flattening nested directory"
    # #     mv "$GROUP_DIR/$E/$E"/* "$GROUP_DIR/$E"/
    # #     rmdir "$GROUP_DIR/$E/$E"
    # # fi
    # Detect and flatten an extra subdirectory (e.g., "$E/$E" or "$E/<random_folder>")
    SUBDIRS=($(find "$GROUP_DIR/$E" -mindepth 1 -maxdepth 1 -type d ! -name "__MACOSX"))

    if [ "${#SUBDIRS[@]}" -eq 1 ]; then
        echo "  → Flattening nested subdirectory: ${SUBDIRS[0]##*/}"
        mv "${SUBDIRS[0]}"/* "$GROUP_DIR/$E"/ 2>/dev/null
        rmdir "${SUBDIRS[0]}" 2>/dev/null || true
    fi

done < "$GROUP_DIR/files.txt"

# Optional: clean up file list
#rm "$GROUP_DIR/files.txt"

