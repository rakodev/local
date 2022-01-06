#!/bin/sh

alias which-shell-is-currently-running='ps -o comm= $$'
alias which-shell-is-my-default='echo $SHELL'
# Pyenv https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-global
alias list-python-versions-with-pyenv='ls -l $(pyenv root)/versions'
alias list-all-python-available='pyenv install --list'
alias show-python-fullpath='pyenv which python'

# Zip all files in current directory (hidden files included)
tools-zip-all-in-current-directory() {
    if [ -z "$1" ]; then
		echo "Output filename is missing!";
		return 0;
	fi
    zip -r $1.zip .
}

# https://stackoverflow.com/questions/18204904/fast-way-of-finding-lines-in-one-file-that-are-not-in-another?#answer-53426391
# $1 new file, $2 previous file
tools-diff-any-line-missing() {
	echo "Missing on the file $1"
	cat $2 $1 $1 | sort | uniq -u
	echo "------"
	echo "Missing on the file $2"
	cat $1 $2 $2 | sort | uniq -u
}

# only a different way to do the previous diff
tools-diff-any-line-missing-2() {
	echo "Missing on the file $1"
	comm -1 -3 <(sort $1) <(sort $2)
	echo "------"
	echo "Missing on the file $2"
	comm -1 -3 <(sort $2) <(sort $1)
}

tools-copy-file-content-to-clipboard() {
	if [ -z "$1" ]; then
		echo "File path is missing!";
		return 0;
	fi
	tr -d '\n' < $1 | pbcopy
}

# tools-find-in-Folder-this-File . "pre*"
tools-find-in-Folder-this-File() {
	if [ -z "$1" ]; then
		echo "folder is missing!";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "file name is missing!";
		return 0;
	fi
    find $1 -name $2
}