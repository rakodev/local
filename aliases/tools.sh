#!/usr/bin/env bash

# Zip all files in current directory (hidden files included)
zip-all-in-current-directory() {
    if [ -z "$1" ]; then
		echo "Output filename is missing!";
		return 0;
	fi
    zip -r $1.zip .
}
