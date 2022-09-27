#!/bin/sh

alias which-shell-is-currently-running='ps -o comm= $$'
alias which-shell-is-my-default='echo $SHELL'
# Pyenv https://github.com/pyenv/pyenv/blob/master/COMMANDS.md#pyenv-global
alias list-python-versions-with-pyenv='ls -l $(pyenv root)/versions'
alias list-all-python-available='pyenv install --list'
alias show-python-fullpath='pyenv which python'
# Remove all log files in current directory and its subfolders
alias tools-remove-log-files='find . -type f -name "*.log" -exec rm -f {} \;'

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

# tools-search-in-Folder-this-File . "pre*"
tools-search-in-Folder-this-File() {
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

# if you'd like to exclude dir add this extra param like this:  
# --exclude-dir=".terraform"
# if you'd like to include only certain type of files, use this:
# --include="*.tf"
alias tools-search-String-in-Folder="grep -r -i -n -I"
alias tools-search-String-in-Folder-exclude-hidden-folder="grep -r -i -n -I --exclude-dir='.*'"

tools-search-String-in-File() {
	if [ -z "$1" ]; then
		echo "String is missing!";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "File is missing!";
		return 0;
	fi
	cat $2 | grep -o $1 | wc -l
}

tools-search-in-Folder-this-String-in-this-FileExtention() {
	if [ -z "$1" ]; then
		echo "folder is missing!";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "String is missing!";
		return 0;
	fi
	if [ -z "$3" ]; then
		echo "File type is missing!";
		return 0;
	fi
	grep -r -i -n --include="*.$3" $2 $1
}

tools-search-in-Folder-this-String-in-this-FileExtention-ExcludeFolder() {
	if [ -z "$1" ]; then
		echo "folder is missing!";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "String is missing!";
		return 0;
	fi
	if [ -z "$3" ]; then
		echo "File type is missing!";
		return 0;
	fi
	if [ -z "$4" ]; then
		echo "Folder to exclude is missing!";
		return 0;
	fi
	grep -r -i -n --include="*.$3" --exclude="*/$4/*" $2 $1
}

# show list of local shells
alias tools-list-shell='cat /etc/shells'
# to switch between shells, use this command like this: chsh -s /bin/sh

# https://chrisjean.com/view-csv-data-from-the-command-line/
tools-csv-beautifier() {
	# $1 is filepath
	# $2 is number of column for each row
	cat $1  | sed -e 's/,,/, ,/g' | column -s, -t | less -#$2 -N -S
}

# https://unix.stackexchange.com/questions/548892/how-to-json-escape-input
tools-json-encode-Filename-content() {
	if [ -z "$1" ]; then
		echo "filepath is missing!";
		return 0;
	fi
	jq -R -s '.' < $1
}

# give json as parameter inside single quotes
tools-json-encode-JsonString() {
	if [ -z "$1" ]; then
		echo "Json string is missing!";
		return 0;
	fi
	jq @json <<< $1
}
