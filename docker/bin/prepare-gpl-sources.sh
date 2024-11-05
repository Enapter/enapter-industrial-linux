#!/bin/bash
# Script to archive a subset of packages matching specific license(s)
# Source and license files are copied into sub folders of package folder
deploy_dir="/home/build/tmp-glibc/deploy"
src_release_dir="$deploy_dir/source-release"

# Remove existing source-release directory
rm -rf "$src_release_dir"
mkdir -p "$src_release_dir"

find "$deploy_dir/sources" -mindepth 2 -maxdepth 2 -type d | while read -r d; do
  # Get package name from path
  p=$(basename "$d")
  p=${p%-*}
  p=${p%-*}

  # Only archive GPL packages
  numfiles=$(find "$deploy_dir/licenses" -wholename "*/$p/*GPL*" 2> /dev/null | wc -l)
  if [ "$numfiles" -ge 1 ]; then
    echo "Archiving $p"

    # Create directories for source and license
    mkdir -p "$src_release_dir/$p/source"
    mkdir -p "$src_release_dir/$p/license"

    # Copy source files
    cp "$d/"* "$src_release_dir/$p/source" 2> /dev/null

    # Copy license files
    find "$deploy_dir/licenses" -wholename "*/$p/*" -type f -exec cp {} "$src_release_dir/$p/license/" \; 2> /dev/null
  fi
done
