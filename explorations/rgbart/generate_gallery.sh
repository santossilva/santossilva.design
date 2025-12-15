#!/bin/bash

# Generate HTML gallery with single section
cat > index.html << 'HTML_START'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>In Between Channels</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <header>
        <h1>In Between Channels</h1>
        <p>Perceptual colour mixing in the mind</p>
    </header>
    
    <div class="filter-bar">
        <span class="filter-item active" data-value="FF">FF</span> · 
        <span class="filter-item active" data-value="7D">7D</span> · 
        <span class="filter-item active" data-value="40">40</span> · 
        <span class="filter-item active" data-value="20">20</span> · 
        <span class="filter-item active" data-value="00">00</span>
    </div>
    
    <main class="gallery">
        <div class="grid">
HTML_START

# Create array to store all images with their sort keys
declare -a images

# Process 01 full folder (000_XX)
for img in "01 full"/*.png; do
    if [ -f "$img" ]; then
        num=$(basename "$img" | grep -o '^[0-9_]*')
        images+=("$num|$img")
    fi
done

# Process 02Halvs folder
for folder in "02Halvs"/2025-* "02Halvs"/2026-*; do
    if [ -d "$folder" ]; then
        for img in "$folder"/*.png; do
            if [ -f "$img" ]; then
                num=$(basename "$img" | grep -o '^[0-9]*')
                images+=("$num|$img")
            fi
        done
    fi
done

# Process 03quarter folder
for folder in "03quarter"/2026-*; do
    if [ -d "$folder" ]; then
        for img in "$folder"/*.png; do
            if [ -f "$img" ]; then
                num=$(basename "$img" | grep -o '^[0-9]*')
                images+=("$num|$img")
            fi
        done
    fi
done

# Process 04eights folder
for folder in "04eights"/2026-*; do
    if [ -d "$folder" ]; then
        for img in "$folder"/*.png; do
            if [ -f "$img" ]; then
                num=$(basename "$img" | grep -o '^[0-9]*')
                images+=("$num|$img")
            fi
        done
    fi
done

# Sort images and output
IFS=$'\n' sorted=($(sort -t'|' -k1 <<<"${images[*]}"))
unset IFS

for entry in "${sorted[@]}"; do
    img="${entry#*|}"
    hex=$(echo "$img" | grep -o '[0-9A-F]\{6\}' | head -1)
    echo "            <div class=\"item\">" >> index.html
    echo "                <img src=\"$img\" alt=\"#$hex\">" >> index.html
    echo "            </div>" >> index.html
done

# Close HTML
cat >> index.html << 'HTML_END'
        </div>
    </main>
    
    <footer>
        <p>RGB Art Project © 2025</p>
    </footer>
    
    <div id="fullscreen-overlay" class="fullscreen-overlay">
        <div class="nav-arrow nav-left">‹</div>
        <img id="fullscreen-image" src="" alt="">
        <div class="nav-arrow nav-right">›</div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const filterItems = document.querySelectorAll('.filter-item');
            const items = document.querySelectorAll('.item');
            const overlay = document.getElementById('fullscreen-overlay');
            const fullscreenImg = document.getElementById('fullscreen-image');
            const navLeft = document.querySelector('.nav-left');
            const navRight = document.querySelector('.nav-right');
            let currentIndex = 0;
            let visibleItems = [];
            
            // Filter functionality
            filterItems.forEach(filter => {
                filter.addEventListener('click', function() {
                    this.classList.toggle('active');
                    applyFilters();
                });
            });
            
            function applyFilters() {
                const activeValues = Array.from(document.querySelectorAll('.filter-item.active'))
                    .map(f => f.dataset.value);
                
                items.forEach(item => {
                    const img = item.querySelector('img');
                    const hex = img.alt.replace('#', '');
                    
                    // Extract RGB pairs
                    const r = hex.substring(0, 2);
                    const g = hex.substring(2, 4);
                    const b = hex.substring(4, 6);
                    
                    // Check if all RGB values are in active filters
                    const rMatch = activeValues.includes(r);
                    const gMatch = activeValues.includes(g);
                    const bMatch = activeValues.includes(b);
                    
                    if (rMatch && gMatch && bMatch) {
                        item.style.display = '';
                    } else {
                        item.style.display = 'none';
                    }
                });
                
                updateVisibleItems();
            }
            
            function updateVisibleItems() {
                visibleItems = Array.from(items).filter(item => item.style.display !== 'none');
            }
            
            function showImage(index) {
                if (visibleItems.length === 0) return;
                
                currentIndex = index;
                if (currentIndex < 0) currentIndex = visibleItems.length - 1;
                if (currentIndex >= visibleItems.length) currentIndex = 0;
                
                const img = visibleItems[currentIndex].querySelector('img');
                fullscreenImg.src = img.src;
                fullscreenImg.alt = img.alt;
            }
            
            function navigateNext() {
                showImage(currentIndex + 1);
            }
            
            function navigatePrev() {
                showImage(currentIndex - 1);
            }
            
            // Fullscreen functionality
            updateVisibleItems();
            
            items.forEach((item, index) => {
                const img = item.querySelector('img');
                img.addEventListener('click', function() {
                    updateVisibleItems();
                    currentIndex = visibleItems.indexOf(item);
                    showImage(currentIndex);
                    overlay.classList.add('active');
                });
            });
            
            overlay.addEventListener('click', function(e) {
                if (e.target === overlay) {
                    this.classList.remove('active');
                }
            });
            
            navLeft.addEventListener('click', function(e) {
                e.stopPropagation();
                navigatePrev();
            });
            
            navRight.addEventListener('click', function(e) {
                e.stopPropagation();
                navigateNext();
            });
            
            // Keyboard navigation
            document.addEventListener('keydown', function(e) {
                if (!overlay.classList.contains('active')) return;
                
                if (e.key === 'ArrowLeft') {
                    navigatePrev();
                } else if (e.key === 'ArrowRight') {
                    navigateNext();
                } else if (e.key === 'Escape') {
                    overlay.classList.remove('active');
                }
            });
        });
    </script>
</body>
</html>
HTML_END

echo "Complete gallery generated!"
