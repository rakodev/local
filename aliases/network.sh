#!/bin/sh

# Trace a domain, example:
# dig-trace docker.com
dig-trace() {
    if [ -z "$1" ]; then
		echo "Parameter domain is missing";
		return 0;
	fi
    dig $1 +trace
}

# List all the requests
tcpdump-all() {
    sudo tcpdump -i any -s 0 -v -n -l | egrep -i "POST /|GET /|Host:"
}

# List only the host requests
tcpdump-host() {
    sudo tcpdump -i any -s 0 -v -n -l | egrep -i "Host:"
}