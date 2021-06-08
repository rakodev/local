#!/usr/bin/env bash

# Initialise a terraform project
alias tf-init='terraform init'
# Validate your terraform syntax
alias tf-validate='terraform validate'
# Check terraform files
alias tf-plan='terraform plan'
# Apply all the plan
alias tf-apply='terraform apply'
# Destroy the plan
alias tf-destroy='terraform destroy'

# list all workspaces
alias tf-list='terraform workspace list'
# create new workspace, give the workspace name at the end of this command
alias tf-create-workspace='terraform workspace new'
