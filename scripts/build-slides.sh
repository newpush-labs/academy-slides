#!/bin/bash

# Find all .md files within the courses directory.
find ./courses -name "*.md" -print0 | while IFS= read -r -d $'\0' file; do
  # Extract the directory relative to 'courses/'.
  relative_dir=$(dirname "${file#./courses/}")
  # Extract the basename without the extension.
  base_name=$(basename "$file" .md)

  # Construct the output directory and base path.
  out_dir="/tmp/dist/courses/$relative_dir/$base_name"
  base_path="/academy-slides/courses/$relative_dir/$base_name"

  # Build the slides.
  nr build --out "$out_dir" --base "$base_path" "$file"
done

# Build the slides for the home page.
nr build --out "/tmp/dist/courses/home" --base "/academy-slides/courses/home" "./courses/home.md"

# Build the example slides from the themes/np-slides-theme/example.md file.
nr build --out "/tmp/dist/theme-demo" --base "/academy-slides/theme-demo" "./themes/np-slides-theme/example.md"
