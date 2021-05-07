#!/usr/bin/env bash

# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
alias aws-edit-credentials='vim ~/.aws/credentials'
alias aws-edit-config='vim ~/.aws/config'
alias aws-list-profile='aws configure list-profiles'

# aws-ssh-ec2 EC2Tutorial.pem 52.51.204.186
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