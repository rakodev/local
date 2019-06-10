#!/usr/bin/env bash

# git fetch checkout <branch>
gi-fc() {
	if [ -z "$1" ]; then
		echo "Branch name is missing!";
		exit;
	fi
	git fetch origin $1;
	git checkout --track origin/$1 2>/dev/null || git checkout $1;
	git pull;
}

# git reset hard
gi-rh() {
	git reset --hard origin/HEAD;
	git pull;
}

# git rebase interactive <last commit hash on the parent branch>
gi-ri() {
	if [ -z "$1" ]; then
		echo "Parameter last commit hash is missing!";
		exit;
	fi
	git rebase --interactive $1;
}

# git force push
gi-fp() {
	git push origin HEAD -f;
}

gi-show-remote-url(){
	git remote -v;
	#git config --get remote.origin.url;
	#git remote show origin;
}

gi-set-remote-url(){
	if [ -z "$1" ]; then
		echo "Parameter remote URL is missing";
		exit;
	fi
	git remote set-url origin $1
}