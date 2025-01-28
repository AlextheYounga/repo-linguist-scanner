#!/bin/bash

# Define the root directory to start searching from
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd 2>/dev/null)"
SCAN_DIR=$1 # This is the directory to search for git repos
declare -a EMAILS # These are git authors we are going to search for.
declare -a BLACKLIST # File which contains repos we don't want to scan
declare -a EXISTING_REPOS # This is the file where we store the list of repos we've scanned

# This is the file where we store the list of repos we've scanned
REPO_STORE="$SCRIPT_PATH/repos.txt" 
touch "$REPO_STORE"

IFS=$'\n' EMAILS=($(cat "$SCRIPT_PATH/data/emails.txt" )) 
IFS=$'\n' BLACKLIST=($(cat "$SCRIPT_PATH/data/blacklist.txt")) 
IFS=$'\n' EXISTING_REPOS=($(cat "$REPO_STORE")) 

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color


repo_contains_author() {
	for email in "${EMAILS[@]}"; do
		# Count the number of characters in output but limit to 1.
		# That way if the output is empty, it will return 0 and if it has output, 1.
		local author_search=$(git log --author="$email" --oneline | head -c1 | wc -c)
		if [[ $author_search -eq 1 ]]; then
			echo -e "${GREEN}Found author commits in $git_dir${NC}"
			return 0
		fi
	done

	echo -e "${RED}No author commits in $git_dir, skipping${NC}"
	return 1
}

check_repo_authors() {
	local git_dir="$1"
	local REPO_STORE="$SCRIPT_PATH/repos.txt"
	cd $git_dir

	if repo_contains_author; then
		# Add line to repos.txt
		echo "$git_dir" >>$REPO_STORE
	fi

	cd - >/dev/null # This guy wants to output stuff, so we need to suppress it
}


# === Script start === #
declare -a repos
touch "$REPO_STORE"

# Get all repos from SCAN_DIR
echo -e "${YELLOW}Scanning git repos $SCAN_DIR...${NC}"
repos=($(find "$SCAN_DIR" -type d -name "*.git"))
repo_count=${#repos[@]}
echo -e "${GREEN}Found $repo_count repos.${NC}"

for repo_path in "${repos[@]}"; do
	# If repo is a .git folder, get the parent directory
	if [[ $(basename "$repo_path") == ".git" ]]; then
		repo_path=$(dirname "$repo_path")
	fi

	if [[ " ${EXISTING_REPOS[*]} " =~ [[:space:]]${repo_path}[[:space:]] ]]; then
		echo "Skipping $repo_path, already scanned"
		continue
	fi

	if [[ " ${BLACKLIST[*]} " =~ [[:space:]]${repo_path}[[:space:]] ]]; then
		echo "Skipping $repo_path, blacklisted"
		continue
	fi

	# Ensure either a working git repo or a bare repo
	if [ -d "$repo_path/.git" ] || [ -f "$repo_path/HEAD" ]; then
		echo -e "${YELLOW}Checking $repo_path...${NC}"
		check_repo_authors "$repo_path"
		wait
	fi
done

wait
