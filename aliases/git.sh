#!/bin/sh

######################################
################# Most Used Aliases
######################################
alias git-c='git checkout'
alias git-p='git pull'
alias git-cb='git checkout -b'
alias git-ap='git add --all --intent-to-add && git add --patch && git status'
alias git-pap='pre-commit run -a && git add --all --intent-to-add && git add --patch && git status'
alias git-co='git commit -m'
alias git-pu='git push -u origin HEAD'
alias git-main='git clean --force && git reset --hard && git checkout main && git pull'

######################################
################# Branch
######################################
alias git-switch-to-previous-branch='git checkout -'
# https://stackoverflow.com/questions/1274057/how-to-make-git-forget-about-a-file-that-was-tracked-but-is-now-in-gitignore
# untracked files will be done after next commit
alias git-untrack-file='git rm --cached'
alias git-untrack-folder='git rm -r --cached'

git-Branch-remove() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git branch -D $1;
}
######################################
################# Commit
######################################
alias git-commit-Description='git commit -m' # "commit description"
alias git-commit-amend-new-Description='git commit --amend -m' # Add staged files to commit and edit last commit message
alias git-commit-add-and-amend='git-add-patch & git commit --amend' # add new edit to the last unpushed commit
alias git-add-to-previous-commit='git commit --amend --no-edit'

# Edit last commit message
git-commit-edit-last-unpushed-Description() {
	if [ -z "$1" ]; then
		echo "Commit message is missing";
		return 0;
	fi
	git commit --amend -m "$1";
}
######################################
################# Log
######################################
alias git-log='git log --graph --oneline --decorate'
alias git-log-Filename-changes='git log -p'
alias git-log-list='git log --pretty="%ar - %h - %an - %s"'

# Retrieve all commits by message
git-log-Search() {
	if [ -z "$1" ]; then
		echo "Search string is missing";
		return 0;
	fi
	git log --all --grep='$1';
}
######################################
################# Diff
######################################
alias git-diff-staged='git fetch origin HEAD && git diff --staged' # diff with HEAD
alias git-diff-with-remote-head='git fetch origin HEAD && git diff origin HEAD' # diff between local and remote HEAD (main if still no remote)
alias git-diff-with-origin-main='git fetch origin main && git diff origin/main' # diff between current and remote main
alias git-diff-current-with-Branchname='git fetch origin && git diff' # diff between current and remote main

# you can give remote branch name with prefix origin/ before the branchnames for both side
# example: git-diff-FromBranch-ToBranch origin/master origin/develop
git-diff-FromBranch-ToBranch() {
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "branch names are missing";
		return 0;
	fi
	git fetch origin # usefull if one of the branch is a remote one
	git diff $1 $2
}

git-diff-FromBranch-ToBranch-for-a-File() {
	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "branch names are missing";
		return 0;
	fi
	if [ -z "$3" ]; then
		echo "file name is missing";
		return 0;
	fi
	git diff $1..$2 -- $3
}

######################################
################# Merge
######################################
alias git-merge-with-origin-main='git fetch && git merge origin/main'
alias git-merge-with-origin-master='git fetch && git merge origin/master'

# Merge last N commits even if they have been pushed
# git-merge-last-n-commit develop 4
git-merge-to-Branchname-last-Number-of-commit() {
	if [ -z "$1" ]; then
		echo "Parameter branch name is missing";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Number of commit you want to merge is missing";
		return 0;
	fi
	read \?"Choose fixup for other commits than the first one [press enter to continue]"
	git rebase -i $1~$2 $1
}

# Merge last N commits even if they have been pushed
# git-merge-last-n-commit develop 4
git-merge-to-Branchname-last-Number-of-commit-and-push() {
	if [ -z "$1" ]; then
		echo "Parameter branch name is missing";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Number of commit you want to merge is missing";
		return 0;
	fi
	read \?"Choose fixup for other commits than the first one [press enter to continue]"
	if git rebase -i $1~$2 $1; then
		git push -u origin +$1
	fi
}

git-merge-with-RemoteBranchName() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git merge origin/$1;
}

git-merge-with-LocalBranchName() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git merge $1;
}

######################################
################# Checkout
######################################

git-checkout-remote-Branchname() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git fetch;
	git checkout -t origin/$1;
}

######################################
################# Remote
######################################

alias git-remote-display='git remote -v'

# After this command if the repo is empty you can do these commands:
# git push -u origin --all
# git push -u origin --tags
git-remote-set-origin-URL(){
	if [ -z "$1" ]; then
		echo "Parameter remote URL is missing";
		return 0;
	fi
	git remote set-url origin $1
}

alias git-list-branch-remote-not-merged='git fetch && git branch -r --sort=-committerdate --no-merged'

git-list-branch-remote () {
	git for-each-ref --sort=-committerdate refs/remotes --format='%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:magenta)%(authorname)%(color:reset)|%(color:blue)%(subject)' --color=always | column -ts'|'
}

git-list-branch-local () {
	git for-each-ref --sort=-committerdate refs/heads --format='%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:magenta)%(authorname)%(color:reset)|%(color:blue)%(subject)' --color=always | column -ts'|'
}

######################################
################# Push
######################################
alias git-pu-force='git push origin HEAD -f'

# git create branch, add, commit & push
# git-acp "commit message" branchName
git-CommitDescription-and-create-Branch-to-push() {
    # if not branchName is given, then do it with HEAD
    branchName=${2:-HEAD};
    if [ -z "$1" ]; then
		echo "Commit message is missing";
		return 0;
	fi
	if [ -n $2 ]; then
		git checkout -b $branchName;
	fi	
	git-ap;
	git commit -m "$1";
	if [ -n $2 ]; then
		git push -u origin $branchName;
	else
		git push -u origin HEAD
	fi	
}
######################################
################# Fetch
######################################
alias git-fetch-all='git fetch --all'

# git fetch checkout <branch>
git-fetch-and-checkout-Branch() {
	if [ -z "$1" ]; then
		echo "Branch name is missing!";
		return 0;
	fi
	git fetch origin $1;
	git checkout --track origin/$1 2>/dev/null || git checkout $1;
	git pull;
}

# use it like this git-edit-last-pushed-commit "my commit message I want"
git-edit-last-pushed-commit-with-NewCommitMessage() {
	if [ -z "$1" ]; then
		echo "Commit message is missing!";
		return 0;
	fi
	git commit --amend -m "$1"
	git push --force-with-lease
}

# $1 is the sha1 of the commit you want to come back
# $2 is the branch name you want to push to undo unwanted commit
git-undo-to-LastGoodCommit-on-Branchname() {
	if [ -z "$1" ]; then
		echo "Last good commit SHA1 is missing!";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Branch name is missing!";
		return 0;
	fi
	git reset $1
	git push -f origin $2
}

######################################
################# Stash
######################################

alias git-stash-list='git stash list'

# example: git-stash
# example: git-stash "WIP: new lambda function"
git-stash-push-with-Description() {
	if [ $1 ]; then
		git stash push -m "$1"
	else
		git stash
	fi
}

# use git list and then use
# git-stash-pop 2 // 2 is the number in the list
git-stash-pop(){
	if [ $1 ]; then
		git stash pop stash@{$1}
	else
		git stash pop
	fi
}

######################################
################# Reset
######################################

# git reset hard
git-reset-hard-Branch() {
	if [ -z "$1" ]; then
		echo "Parameter branch name is missing!";
		return 0;
	fi
	git fetch origin $1
	git reset --hard origin/$1;
}

alias git-reset-current-changes='git clean --force && git reset --hard'

######################################
################# Rebase
######################################

# git rebase interactive <last commit hash on the parent branch>
# do a git log to see the last commits
# pick one and squash (s) the others
git-rebase-interactive-Branch() {
	if [ -z "$1" ]; then
		echo "Parameter last commit hash is missing!";
		return 0;
	fi
	git rebase --interactive $1;
	echo ""
	echo "Now run git push force if you did rebase commit that was already pushed"
	echo ""
}

######################################
################# Delete # Remove
######################################

git-delete-Branch-both-local-and-remote() {
	if [ -z "$1" ]; then
		echo "Parameter last commit hash is missing!";
		return 0;
	fi
	# delete branch remotely
	git push -d origin $1
	# delete branch locally
	git branch -D $1
}

######################################
################# Tools
######################################

git-copy-ssh-key() {
    if [[ -e ~/.ssh/id_rsa.pub ]]; then
        pbcopy < ~/.ssh/id_rsa.pub
    else
        echo "You need first to generate a ssh key with this command:";
        echo "ssh-keygen -t rsa -b 4096 -C ""your_email@example.com"""
    fi
}

######################################
################# Config
######################################

git-config-list-user() {
	git config user.name
	git config user.email
}

alias git-config-list-all-global='git config --global --list'
alias git-config-list-all-local='git config --local --list'

# git-config-global "Name LastName" "email@example.com"
git-config-set-global() {
    if [ -z "$1" ]; then
		echo "User name is missing";
		return 0;
	fi
    if [ -z "$2" ]; then
		echo "User email is missing";
		return 0;
	fi
    git config --global user.name "$1";
    git config --global user.email "$2";
}

git-config-set-local() {
    if [ -z "$1" ]; then
		echo "User name is missing";
		return 0;
	fi
    if [ -z "$2" ]; then
		echo "User email is missing";
		return 0;
	fi
    git config user.name "$1";
    git config user.email "$2";
}
