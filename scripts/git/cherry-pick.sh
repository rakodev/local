#!/bin/bash

# Fetch the list of branches
branches=$(git branch --format='%(refname:short)')

# Function to show the commit list of a branch
show_commit_list() {
  branch=$1
  echo "Commit list for branch: $branch"
  git log --oneline $branch
  echo
}

# Function to cherry-pick a commit
cherry_pick_commit() {
  commit=$1
  git cherry-pick $commit
}

# Show the list of branches
echo "Available branches:"
echo "$branches"
echo

# Prompt for the branch selection
read -p "Enter the branch name to show commit list: " selected_branch

# Prompt for the commits
read -p "Please copy the commit hashes you want to cherry pick. (press Enter to see the list of commits): "

# Show the commit list of the selected branch
show_commit_list $selected_branch

# Prompt the user to copy commit hashes
echo "Copy the commit hashes you want to cherry-pick (separated by spaces):"
read -p "> " commit_hashes

# Convert the commit hashes into an array
IFS=' ' read -ra commit_hashes_array <<< "$commit_hashes"

# Loop to cherry-pick selected commits
for commit_hash in "${commit_hashes_array[@]}"
do
  # Cherry-pick the selected commit
  cherry_pick_commit $commit_hash
  echo "Cherry-picked commit: $commit_hash"
done
