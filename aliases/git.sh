#!/usr/bin/env bash

# new repo
#git init
#git add .
#git commit -m "first commit"
#git remote add origin https://github.com/rakodev/react-native-meals.git
#git push -u origin master

# push an existing project
#git remote add origin https://github.com/rakodev/react-native-meals.git
#git push -u origin master

# https://stackoverflow.com/questions/14491727/git-add-patch-to-include-new-files?answertab=active#tab-top
alias git-add-patch='git add --intent-to-add . && git add --patch'
# https://stackoverflow.com/questions/1274057/how-to-make-git-forget-about-a-file-that-was-tracked-but-is-now-in-gitignore
# untracked files will be done after next commit
alias git-untrack-file='git rm --cached'
alias git-untrack-folder='git rm -r --cached'
alias git-file-history='git log -p' # <file path>
alias git-log='git log --graph --oneline --decorate'
alias git-switch-to-previous-branch='git checkout -'
alias git-commit='git commit -m' # "commit description"
alias git-add-to-previous-commit='git commit --amend --no-edit'
alias git-log-changes='git log -p'
alias git-log-list='git log --pretty="%ar - %h - %an - %s"'
alias git-commit-amend='git-add-patch & git commit --amend' # add new edit to the last unpushed commit

# use it like this git-edit-last-pushed-commit 5054777864e4345d115f80025f913a403381d6c8 "my commit message I want"
git-edit-last-pushed-commit() {
	if [ -z "$1" ]; then
		echo "Last good commit SHA1 is missing!";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Commit message is missing!";
		return 0;
	fi
	git reset $1
	git commit -am "$2"
	git push -f
}

# $1 is the sha1 of the commit you want to come back
# $2 is the branch name you want to push to undo unwanted commit
git-undo-to-last-good-commit() {
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

# example: git-stash
# example: git-stash push -m "WIP: new lambda function"
git-stash-push() {
	if [ $1 ]; then
		git stash push -m "$1"
	else
		git stash
	fi
}

alias git-stash-list='git stash list'

# use git list and then use
# git-stash-pop 2 // 2 is the number in the list
git-stash-pop(){
	if [ $1 ]; then
		git stash pop stash@{$1}
	else
		git stash pop
	fi
}

# git fetch checkout <branch>
git-fetch-checkout() {
	if [ -z "$1" ]; then
		echo "Branch name is missing!";
		return 0;
	fi
	git fetch origin $1;
	git checkout --track origin/$1 2>/dev/null || git checkout $1;
	git pull;
}

git-fetch-all() {
	git fetch --all;
}

# git reset hard
git-reset-hard() {
	if [ -z "$1" ]; then
		echo "Parameter branch name is missing!";
		return 0;
	fi
	git fetch origin
	git reset --hard origin/$1;
}

# git rebase interactive <last commit hash on the parent branch>
# do a git log to see the last commits
# pick one and squash (s) the others
git-rebase-interactive() {
	if [ -z "$1" ]; then
		echo "Parameter last commit hash is missing!";
		return 0;
	fi
	git rebase --interactive $1;
	echo ""
	echo "Now run git-force-push"
	echo ""
}

# Merge last N commits even if they have been pushed
# git-merge-last-n-commit develop 4
git-merge-last-n-commit() {
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

# git force push
git-force-push() {
	git push origin HEAD -f;
}

git-show-remote-url(){
	git remote -v;
	#git config --get remote.origin.url;
	#git remote show origin;
}

# After this command if the repo is empty you can do these commands:
# git push -u origin --all
# git push -u origin --tags
git-set-remote-url(){
	if [ -z "$1" ]; then
		echo "Parameter remote URL is missing";
		return 0;
	fi
	git remote set-url origin $1
}

git-remove-local-branch() {
    if [ -z "$1" ]; then
		echo "Parameter branch name is missing";
		return 0;
	fi
    git branch -D $1;
}

git-copy-ssh-key() {
    if [[ -e ~/.ssh/id_rsa.pub ]]; then
        pbcopy < ~/.ssh/id_rsa.pub
    else
        echo "You need first to generate a ssh key with this command:";
        echo "ssh-keygen -t rsa -b 4096 -C ""your_email@example.com"""
    fi
}

# git add & commit
# git-commit "commit message" branchName
git-commit-and-create-new-branch() {
	# assign default branch master if branchName is empty
    branchName=${2:-master};
    if [ -z "$1" ]; then
		echo "Commit message is missing";
		return 0;
	fi

	git checkout -b $branchName;
	git add .;
	git commit -m "$1";
}

# Edit last commit message
git-edit-last-commit-message() {
	if [ -z "$1" ]; then
		echo "Commit message is missing";
		return 0;
	fi
	git commit --amend -m "$1";
}

# Add something to the last commit without writing message again
git-add-last-commit() {
	git add . && git commit --amend --no-edit;
}

# git create branch, add, commit & push
# git-acp "commit message" branchName
git-create-add-commit-push() {
    # if not branchName is given, then do it with HEAD
    branchName=${2:-HEAD};
    if [ -z "$1" ]; then
		echo "Commit message is missing";
		return 0;
	fi
	if [ -n $2 ]; then
		git checkout -b $branchName;
	fi	
	git add .;
	git commit -m "$1";
	if [ -n $2 ]; then
		git push -u origin $branchName;
	else
		git push -u origin HEAD
	fi	
}

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

git-new-branch() {
    if [ -z "$1" ]; then
		echo "Commit message is missing";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Branch name is missing";
		return 0;
	fi
	git checkout -b $2;
	git add .;
	git commit -m "$1";
}

git-reset-current-changes() {
	git clean --force && git reset --hard;
}


# Retrieve all commits by message
git-log-search-in-message() {
	if [ -z "$1" ]; then
		echo "Search string is missing";
		return 0;
	fi
	git log --all --grep='$1';
}

git-checkout-remote-branch() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git fetch;
	git checkout -t origin/$1;
}

git-create-new-local-branch() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git checkout -b $1;
}

git-switch-to-local-branch() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git checkout $1;
}

git-list-remote-branch-not-merged() {
	git branch -r --sort=-committerdate --no-merged
}

git-list-remote-branch() {
	git for-each-ref --sort=-committerdate refs/remotes --format='%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:magenta)%(authorname)%(color:reset)|%(color:blue)%(subject)' --color=always | column -ts'|'
}

git-list-local-branch () {
	git for-each-ref --sort=-committerdate refs/heads --format='%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:magenta)%(authorname)%(color:reset)|%(color:blue)%(subject)' --color=always | column -ts'|'
}

git-branch-remove() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git branch -D $1;
}

git-merge-with-remote-branch() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git merge origin/$1;
}

git-merge-with-local-branch() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git merge $1;
}

git-config-list() {
	git config user.name
	git config user.email
}