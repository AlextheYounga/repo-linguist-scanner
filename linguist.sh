#!/bin/bash

# Define the root directory to start searching from
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd 2>/dev/null)"
# Where we will store out linguist data
OUT_FOLDER="$SCRIPT_PATH/out"
# This is the file where we store the list of repos we've scanned
REPO_STORE="$SCRIPT_PATH/repos.txt"
# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

run_linguist() {
	local repo_path=$1
	cd $repo_path
	
	local repo_name=$(basename $repo_path)
	local output_file="$OUT_FOLDER/$repo_name.txt"
	
	# Run linguist command
	echo "Running linguist in $repo_path" # Add path to repo in output file
	echo "$repo_path" >$output_file
	github-linguist --json >>$output_file

	cd - >/dev/null # This guy wants to output stuff, so we need to suppress it
}

mkdir -p $OUT_FOLDER
declare -a repos
IFS=$'\n' repos=($(cat $REPO_STORE))

for repo_path in "${repos[@]}"; do
	# Do not run this async as a background process (using &). Will crash small servers. Ask me how I know lol.
	run_linguist "$repo_path"
done

wait