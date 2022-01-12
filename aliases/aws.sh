#!/bin/sh

# https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
alias aws-edit-credentials='vim ~/.aws/credentials'
alias aws-edit-config='vim ~/.aws/config'
alias aws-list-profile='aws configure list-profiles'
# Validate a sam template file, you can also specify the template file location as a parameter
alias sam-validate='sam validate'
alias aws='docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
alias aws-get-caller-identity='aws sts get-caller-identity --query "Account" --output text'

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

aws-create-s3() {
	if [ -z "$1" ]; then
		echo "Bucket name is missing!";
		return 0;
	fi
	aws s3 mb s3://$1
}

aws-copy-to-s3(){
	if [ -z "$1" ]; then
		echo "File path is missing!";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Bucket name is missing!";
		return 0;
	fi
	aws s3 cp $1 s3://$2
}

# it shows you which status is currently your stack
aws-cloudformation-stack-status(){
	if [ -z "$1" ]; then
		echo "StackName is missing!";
		return 0;
	fi
	aws cloudformation describe-stacks --stack-name $1 --query "Stacks[0].StackStatus" --output text
}

# if you give a parameter, it'll filter only names containing this string
aws-s3-list() {
	if [ -z "$1" ]; then
		aws s3api list-buckets --query "Buckets[].Name" | tr -d '"' | tr -d ','
	else
		aws s3api list-buckets --query "Buckets[].Name" | grep $1 | tr -d '"' | tr -d ','
	fi
}

aws-s3-list-files-filter-by-FileExtentionType() {
	if [ -z "$1" ]; then
		echo "Please, specify which type of file you want";
		return 0;
	fi
	aws s3 ls --recursive | grep '\.$1$'
}

aws-s3-copy-From-To() {
	if [ -z "$1" ]; then
		echo "s3 bucket name and/or folder is missing!";
		return 0;
	fi
	if [ -z "$2" ]; then
		echo "Local path is missing!";
		return 0;
	fi
	aws s3 cp s3://$1 $2 --recursive
}

aws-s3-sync-From-To() {
	if [ -z "$1" ]; then
		echo "s3 bucket name and/or folder is missing!";
		return 0;
	fi
	aws s3 sync s3://$1 $2 
}

# aws s3 sync s3://961185673371-tf-state/env:/ ~/Downloads/octopus/st
# aws s3 cp s3://961185673371-tf-state/env:/ ~/Downloads/octopus/st --recursive