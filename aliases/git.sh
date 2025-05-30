#!/bin/sh

######################################
################# Most Used Aliases
######################################
alias git-i='git init'
alias git-c='git checkout'
alias git-p='git pull --ff-only' # https://blog.sffc.xyz/post/185195398930/why-you-should-use-git-pull-ff-only
alias git-cb='git checkout -b'
alias git-ap='git add --all --intent-to-add && git add --patch && git diff --name-only --diff-filter=ACMRTUXB | xargs git status'
alias git-add-all='git add --all && git status'
alias git-undo-add='git reset --'
alias git-pap='pre-commit run -a && git-ap'
alias git-co='git commit -m'
alias git-pu='git push -u origin +HEAD'
alias git-main='git stash -u && git clean --force && git reset --hard && git checkout main && git pull'
alias git-conflict='git mergetool'
alias git-remove-merged-branch-to-main="git fetch && git branch --merged | egrep -v 'main' | xargs git branch -d"
alias git-commit-interactive='f() { COMMIT_HASH=$(git log --oneline -n 20 | fzf | awk "{print \$1}"); echo "Enter new branch name: "; read BRANCH_NAME; git checkout -b $BRANCH_NAME; COMMITS=$(git rev-list --reverse $COMMIT_HASH..HEAD); while IFS= read -r commit; do echo "Reverting commit $commit"; git revert --no-edit -m 1 $commit || break; done <<< "$COMMITS"; echo "Enter target branch to show you the changes (default: main): "; read TARGET_BRANCH; TARGET_BRANCH=${TARGET_BRANCH:-main}; git diff $TARGET_BRANCH..$BRANCH_NAME; echo -e "Created new branch $BRANCH_NAME and reverted commits from now to $COMMIT_HASH (not including). \n Compared changes with $TARGET_BRANCH. \n\n You are now ready to push your branch."; unset -f f; }; f'

######################################
################# Branch
######################################
alias git-switch-to-previous-branch='git checkout -'
# https://stackoverflow.com/questions/1274057/how-to-make-git-forget-about-a-file-that-was-tracked-but-is-now-in-gitignore
# untracked files will be done after next commit
alias git-untrack-file='git rm --cached'
alias git-untrack-folder='git rm -r --cached'
alias git-list-remote-branches-merged='git branch -r --merged main'
# alias git-list-remote-branches='echo "----- Merged -----" && git branch -r --merged | grep -v HEAD | sed 's/origin\///' && echo "----- Not Merged -----" && git branch -r --no-merged | grep -v HEAD | sed \'s/origin\///\''
alias git-delete-local-pushed-branches='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

git-Branch-remove() {
	if [ -z "$1" ]; then
		echo "branch name is missing";
		return 0;
	fi
	git branch -D $1;
}

######################################
################# Amend
######################################

alias git-amend='git commit --amend --no-edit' # Add staged files to last commit
alias git-amend-and-edit-Message='git commit --amend -m' # Add staged files to last commit and edit last commit message

######################################
################# Log
######################################
alias git-log='git log --no-merges --graph --pretty=fuller -p'
# https://git-scm.com/docs/git-log#Documentation/git-log.txt-emHem
alias git-log-list='git log --no-merges --pretty="%as - %h - %an - %s"'
alias git-log-Filename-changes='git log -p'

git-log-grep-by-Keyword() {
	if [ -z "$1" ]; then
		echo "Search string is missing";
		return 0;
	fi
	git log --no-merges --pretty="%as - %h - %an - %s" --grep='$1'
}

# Retrieve all commits by message
git-log-Search() {
	if [ -z "$1" ]; then
		echo "Search string is missing";
		return 0;
	fi
	git log --all --grep='$1';
}

git-log-with-diff-SinceInDays-for-File() {
	if [ -z "$1" ]; then
		echo "Filename is missing";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Filename is missing";
		return 0;
	fi
	git log -p --since="$2 days ago" $1
}

git-log-with-diff-UntilInDays-for-File() {
	if [ -z "$1" ]; then
		echo "Filename is missing";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Filename is missing";
		return 0;
	fi
	git log -p --until="$2 days ago" $1
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


git-diff-in-any-sub-folders() {
	find . -type d -name .git -execdir sh -c '
		if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && git rev-parse --verify HEAD >/dev/null 2>&1; then
			if ! git diff-index --quiet HEAD --; then
				echo "########################################################"
				echo "########################################################"
				echo "Repository: $(basename "$PWD")"
				echo "########################################################"
				echo "########################################################"
				echo "\n"
				git --no-pager diff
				echo "\n\n\n"
				exit 1
			fi
		fi
	' \;
}

######################################
################# Merge
######################################
alias git-merge-with-origin-main='git fetch && git merge origin/main'
alias git-merge-with-origin-master='git fetch && git merge origin/master'

# Merge last N commits even if they have been pushed
# git-merge-last-n-commit develop 4
git-merge-Number-of-commit() {
	branch_name=$(git rev-parse --abbrev-ref HEAD)
	if [ -z "$1" ]; then
		echo "Number of commit you want to merge is missing";
		return 0;
	fi
	read \?"Choose fixup for other commits than the first one [press enter to continue]"
	git rebase -i $branch_name~$1 $branch_name
}

git-merge-Number-of-commit-and-push() {
	branch_name=$(git rev-parse --abbrev-ref HEAD)
	if [ -z "$1" ]; then
		echo "Number of commit you want to merge is missing";
		return 0;
	fi
	read \?"Choose fixup for other commits than the first one [press enter to continue]"
	if git rebase -i $branch_name~$1 $branch_name; then
		git push -u origin +$branch_name
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
	git checkout -B $1 origin/$1;
	git pull;
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

git-stash-list-with-datetime() {
	git stash list --date=local
}
# alias git-stash-show='git stash show stash@{0} -p'
alias git-stash-show='f() { git stash show stash@{$1} -p; unset -f f; }; f'
alias git-stash-show-drop='f() { git stash show stash@{$1} -p; echo "Are you sure you want to drop this stash? (y/n) "; read REPLY; if [[ $REPLY =~ ^[Yy]$ ]]; then git stash drop stash@{$1}; fi; unset -f f; }; f'
# the script first checks for uncommitted changes using git diff-index --quiet HEAD --. If there are uncommitted changes, it prompts the user to commit or stage them before proceeding with the stash operation.
# alias git-stash-interactive='f() { if ! git diff-index --quiet HEAD --; then echo "You have uncommitted changes. Please commit or stage them before stashing."; return; fi; echo "Do you want to (s)tash current changes or (p)op? "; read ACTION; if [[ $ACTION =~ ^[Ss]$ ]]; then echo "Enter a message for the stash: "; read STASH_MESSAGE; git stash push -u -m "$STASH_MESSAGE"; echo "Changes stashed. Exiting."; unset -f f; return; fi; STASH_NUM=$(git stash list | fzf | cut -d "{" -f 2 | cut -d "}" -f 1); if [[ -z $STASH_NUM ]]; then echo "No stash selected. Exiting."; unset -f f; return; fi; git stash show stash@{$STASH_NUM} -p; echo "Do you want to (d)elete, (p)op or (q)uit this stash? "; read ACTION; if [[ $ACTION =~ ^[Dd]$ ]]; then git stash drop stash@{$STASH_NUM}; elif [[ $ACTION =~ ^[Pp]$ ]]; then git stash pop stash@{$STASH_NUM}; fi; unset -f f; }; f'

alias git-stash-interactive='f() { echo "Do you want to (s)tash current changes or (p)op? "; read ACTION; if [[ $ACTION =~ ^[Ss]$ ]]; then echo "Enter a message for the stash: "; read STASH_MESSAGE; git add --all; git stash push -u -m "$STASH_MESSAGE"; echo "Changes stashed. Exiting."; unset -f f; return; fi; STASH_NUM=$(git stash list | fzf | cut -d "{" -f 2 | cut -d "}" -f 1); if [[ -z $STASH_NUM ]]; then echo "No stash selected. Exiting."; unset -f f; return; fi; git stash show stash@{$STASH_NUM} -p; echo "Do you want to (d)elete, (p)op or (q)uit this stash? "; read ACTION; if [[ $ACTION =~ ^[Dd]$ ]]; then git stash drop stash@{$STASH_NUM}; elif [[ $ACTION =~ ^[Pp]$ ]]; then git stash pop stash@{$STASH_NUM}; fi; unset -f f; }; f'


# example: git-stash
# example: git-stash "WIP: new lambda function"
git-stash-push-with-Description() {
	git add .
	if [ $1 ]; then
		git stash push -m "$1"
	else
		git stash -u
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
		echo "Branch name is missing";
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

git-ssh-key-copy() {
    if [[ ! -e ~/.ssh/id_rsa.pub ]]; then
		echo "No ssh key found, creating one";
        ssh-keygen -t rsa -b 4096
    fi
    pbcopy < ~/.ssh/id_rsa.pub
	echo "SSH key copied to clipboard"
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


######################################
################# Git cache
######################################

git-remove-Filename-from-git-cache() {
	if [ -z "$1" ]; then
		echo "Filename is missing";
		return 0;
	fi
	git rm --cached $1
}

git-remove-Folder-from-git-cache() {
	if [ -z "$1" ]; then
		echo "Folder name is missing";
		return 0;
	fi
	git rm -r --cached $1
}
