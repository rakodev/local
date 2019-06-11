#!/usr/bin/env bash

# git fetch checkout <branch>
git-fetch-checkout() {
	if [ -z "$1" ]; then
		echo "Branch name is missing!";
		exit;
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
git-rebase-interactive() {
	if [ -z "$1" ]; then
		echo "Parameter last commit hash is missing!";
		exit;
	fi
	git rebase --interactive $1;
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

git-set-remote-url(){
	if [ -z "$1" ]; then
		echo "Parameter remote URL is missing";
		exit;
	fi
	git remote set-url origin $1
}