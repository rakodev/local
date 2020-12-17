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

# git reset hard
git-reset-hard() {
	git reset --hard origin/HEAD;
	git pull;
}

# git rebase interactive <last commit hash on the parent branch>
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
git-merge-last-n-commit() {
	if [ -z "$1" ]; then
		echo "Parameter branch name is missing";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Number of commit you want to merge is missing";
		return 0;
	fi
	git rebase -i $1~$2 $1
	echo "choose fixup for other commits than the first one"
	git push -u origin +$1
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
git-commit() {
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

# git add, commit & push
# git-acp "commit message" branchName
git-acp() {
    # assign default branch master if branchName is empty
    branchName=${2:-master};
    if [ -z "$1" ]; then
		echo "Commit message is missing";
		return 0;
	fi

	git checkout -b $branchName;
	git add .;
	git commit -m "$1";
	git push -u origin $branchName;
}

# git-config-global "Name LastName" "email@example.com"
git-config-global() {
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

git-switch-branch() {
	git checkout $1;
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

