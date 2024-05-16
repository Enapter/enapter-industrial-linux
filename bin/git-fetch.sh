#!/bin/bash
# SPDX-FileCopyrightText: 2024 Enapter <developers@enapter.com>
# SPDX-License-Identifier: Apache-2.0

RED='\033[0;31m'
NC='\033[0m' # No Color

info() {
  echo "[INFO] $1"
}

error() {
  echo 1>&2
  echo -e "${RED}[ERROR] $1${NC}" 1>&2
  echo 1>&2
}

debug() {
  echo "[DEBUG] $1"
}

# Check if the correct number of arguments is provided
if [ $# -ne 3 ]; then
    error "Usage: $0 <folder_name> <repository_path> <revision/branch/tag>"
    exit 1
fi

FOLDER_NAME="$1"
REPOSITORY_PATH="$2"
REVISION="$3"

info "Fetching $REPOSITORY_PATH to $FOLDER_NAME"

# Check if the target folder is a git repository
if [ ! -d "$FOLDER_NAME/.git" ]; then
    info "The directory $FOLDER_NAME is not a Git repository. Cloning repository..."
    git clone "$REPOSITORY_PATH" "$FOLDER_NAME" || { error "Failed to clone repository."; exit 1; }
fi

# Ensure working directory is clean
git --git-dir="$FOLDER_NAME/.git" --work-tree="$FOLDER_NAME" reset --hard HEAD || { error "Failed to reset working directory."; exit 1; }

# Fetch and switch
git --git-dir="$FOLDER_NAME/.git" --work-tree="$FOLDER_NAME" fetch --all || { error "Failed to fetch repository updates."; exit 1; }

# Try to reset to origin/$REVISION (for branches or tags)
if git --git-dir="$FOLDER_NAME/.git" --work-tree="$FOLDER_NAME" reset --hard "origin/$REVISION"; then
    info "Successfully reset to origin/$REVISION."
else
    # If it fails, try to reset directly to $REVISION (for commit hashes)
    if git --git-dir="$FOLDER_NAME/.git" --work-tree="$FOLDER_NAME" reset --hard "$REVISION"; then
        info "Successfully reset to $REVISION."
    else
        error "Failed to reset to both origin/$REVISION and $REVISION."
        exit 1
    fi
fi
