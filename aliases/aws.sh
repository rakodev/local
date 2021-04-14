#!/usr/bin/env bash

aws-ssh-ec2() {
    if [ -z "$1" ]; then
		echo "PEM file path is missing!";
		return 0;
	fi
    if [ -z "$2" ]; then
		echo "EC2 IP is missing!";
		return 0;
	fi
    ssh -i $1 ec2-user@$2
}