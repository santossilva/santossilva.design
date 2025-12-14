#!/bin/bash

# Function to convert hex to decimal
hex2dec() {
    echo $((16#$1))
}

# Process each PNG file
for file in *.png; do
    if [[ $file =~ ([0-9]{3})-RGBart-([0-9A-F]{6})-framed-.* ]]; then
        hex="${BASH_REMATCH[2]}"
        r=$(hex2dec "${hex:0:2}")
        g=$(hex2dec "${hex:2:2}")
        b=$(hex2dec "${hex:4:2}")
        
        txtfile="${file%.png}.txt"
        cat > "$txtfile" << CAPTION
#$hex
($r, $g, $b)

Full · Half · Quarter · Eighth · Null
CAPTION
    fi
done
