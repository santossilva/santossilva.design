#!/bin/bash

# Order by light (brightest to darkest), then R→G→B
# FFFFFF (765) -> FFFF00 (510) -> FF00FF (510) -> 00FFFF (510) -> FF0000 (255) -> 00FF00 (255) -> 0000FF (255) -> 000000 (0)

declare -a order=(
    "FFFFFF"  # 000_01 (765)
    "FFFF00"  # 000_02 (510) - R255,G255,B0
    "FF00FF"  # 000_03 (510) - R255,G0,B255
    "00FFFF"  # 000_04 (510) - R0,G255,B255
    "FF0000"  # 000_05 (255) - R255,G0,B0
    "00FF00"  # 000_06 (255) - R0,G255,B0
    "0000FF"  # 000_07 (255) - R0,G0,B255
    "000000"  # 000_08 (0)
)

counter=1
for hex in "${order[@]}"; do
    num=$(printf "%03d_%02d" 0 $counter)
    if [ -f "RGBart-${hex}-framed-"*.png ]; then
        mv RGBart-${hex}-framed-*.png ${num}-RGBart-${hex}-framed-*.png 2>/dev/null || \
        for file in RGBart-${hex}-framed-*.png; do
            [ -f "$file" ] && mv "$file" "${num}-${file}"
        done
    fi
    ((counter++))
done
