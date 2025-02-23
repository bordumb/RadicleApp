#!/usr/bin/env bash
set -e

# ------------------------------------------------------------------------------
# print_heartwood_structure.sh
#
# This script prints out the file structure of RustCore/Heartwood, using `tree`
# if available, or `ls -R` as a fallback. Run it from the root of your project.
# ------------------------------------------------------------------------------

TARGET_DIR="RustCore/Heartwood"

if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: $TARGET_DIR does not exist."
  exit 1
fi

echo "Showing file structure for $TARGET_DIR"
echo

# Prefer `tree` for a nice directory listing, otherwise fallback to `ls -R`.
if command -v tree >/dev/null 2>&1; then
  tree "$TARGET_DIR"
else
  echo "'tree' command not found; using ls -R instead."
  echo
  ls -R "$TARGET_DIR"
fi
