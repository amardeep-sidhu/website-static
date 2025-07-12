

#!/bin/bash

# --- Configuration ---
# IMPORTANT: Set this to the base directory that contains your 'YYYY' (year) folders.
# For example, if your structure is /mnt/mydata/2024/01/01, then BASE_ARCHIVE_DIR should be /mnt/mydata.
BASE_ARCHIVE_DIR="/home/mobaxterm/hugo/website-source/content/blog" # <<< IMPORTANT: CHANGE THIS!

# --- Script Start ---

if [ ! -d "$BASE_ARCHIVE_DIR" ]; then
    echo "Error: BASE_ARCHIVE_DIR '$BASE_ARCHIVE_DIR' not found."
    echo "Please update the 'BASE_ARCHIVE_DIR' variable in the script to the root of your YYYY/MM/DD directories."
    exit 1
fi

echo "--- Verifying 'DD' (date) directories for emptiness ---"
echo "Searching for 'DD' directories under: $BASE_ARCHIVE_DIR/YYYY/MM/DD"
echo "------------------------------------------------------"
echo "If a 'DD' directory is empty of files, its 'rmdir' command will be printed below."
echo "Review these commands carefully before executing them manually."
echo "------------------------------------------------------"

# Use find to locate all 'DD' directories without regex.
# -type d: Only find directories.
# -path "${BASE_ARCHIVE_DIR}/????/??/??" : This is the glob pattern.
#   - ?: Matches any single character. This assumes YYYY, MM, and DD are always 4, 2, and 2 characters long respectively.
#   - If your YYYY/MM/DD directories are NOT exactly 4/2/2 characters (e.g., '1' instead of '01'), this will need adjustment.
# -print0: Prints results null-terminated, safe for directory names with spaces or special characters.
find "$BASE_ARCHIVE_DIR" -type d -path "${BASE_ARCHIVE_DIR}/????/??/??" -print0 | while IFS= read -r -d $'\0' dd_dir_path; do

    # Count files directly within this dd_dir_path
    # -maxdepth 1: Crucial to only look directly inside the DD directory itself
    # -type f: Only count actual files, not subdirectories
    file_count=$(find "$dd_dir_path" -maxdepth 1 -type f | wc -l)

    if [ "$file_count" -gt 0 ]; then
        echo "WARNING: Directory '$dd_dir_path' still contains $file_count file(s)!"
        echo "  Files found:"
        find "$dd_dir_path" -maxdepth 1 -type f
        echo "" # Add a blank line for readability
    else
        echo "INFO: Directory '$dd_dir_path' is empty of files. Suggested command:"
        echo "  rmdir \"$dd_dir_path\"" # Print the rmdir command
        echo "" # Add a blank line for readability
    fi

done

echo "------------------------------------------------------"
echo "Verification complete. Review the printed 'rmdir' commands above."
echo "You can copy and paste them into your terminal to execute them."
echo "Remember: 'rmdir' only removes truly empty directories."
echo "------------------------------------------------------"



