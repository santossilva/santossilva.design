#!/bin/bash

# Starting date: December 18, 2025
start_date="2025-12-18"

# Function to add days to a date (macOS compatible)
add_days() {
    local date=$1
    local days=$2
    date -j -v+${days}d -f "%Y-%m-%d" "$date" "+%Y-%m-%d"
}

# Process all three folders
for folder in "02Halvs" "03quarter" "04eights"; do
    cd "/Users/carlossilva/Downloads/RBG project/$folder"
    
    # Find all numbered files
    for file in [0-9][0-9][0-9]-*.png; do
        if [[ $file =~ ^([0-9]{3})- ]]; then
            num="${BASH_REMATCH[1]}"
            # Remove leading zeros for calculation
            num_int=$((10#$num))
            
            # Calculate days offset (001 = day 0, 002 = day 1, etc.)
            days_offset=$((num_int - 1))
            
            # Calculate target date
            target_date=$(add_days "$start_date" $days_offset)
            
            # Create folder if it doesn't exist
            mkdir -p "$target_date"
            
            # Move both png and txt files
            mv "${num}-"*.png "$target_date/" 2>/dev/null
            mv "${num}-"*.txt "$target_date/" 2>/dev/null
            
            echo "Moved $num to $target_date in $folder"
        fi
    done
done
