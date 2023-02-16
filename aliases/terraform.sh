#!/bin/sh

export TF_CLI_CONFIG_FILE="~/local/terraform/.terraformrc"

# Initialise a terraform project
alias tf-init='terraform init'
# Initialise without backend (no link to state file)
alias tf-init-without-backend='terraform init -backend=false'
# Validate your terraform syntax
alias tf-validate='terraform validate'
# Check terraform files
alias tf-plan='terraform plan'
# Apply all the plan
alias tf-apply='terraform apply'
# Destroy the plan
alias tf-destroy='terraform destroy'
# Rewrite Terraform configuration files to a canonical format and style
alias tf-fmt='terraform fmt'
alias tf-check='terraform fmt & terraform validate'
# Chexk for errors, deprecated syntax... https://github.com/terraform-linters/tflint
alias tf-lint='docker run --rm -v $(pwd):/data -t ghcr.io/terraform-linters/tflint'
# List all workspaces
alias tf-workspace-list='terraform workspace list'
# switch to a different workspace, add name of the selected workspace you want to switch to
alias tf-workspace-select='terraform workspace select'
# create new workspace, give the workspace name at the end of this command
alias tf-workspace-new='terraform workspace new'

# tfenv - https://github.com/tfutils/tfenv
alias tfenv-list-local='tfenv list'
alias tfenv-list-remote='tfenv list remote'
alias tfenv-use='tfenv use' # add terraform version
alias tfenv-uninstall-tf-version="tfenv uninstall" # add terraform version
alias tfenv-upgrade='git --git-dir=~/.tfenv/.git pull'

tf-show-Planfile-short() {
    terraform show $1 -no-color | grep -E '(^.*[#~+-] .*|^[[:punct:]]|Plan)'
}

tfenv-create-version-file () {
    echo $1 > .terraform-version
}

# Activate Terraform Logs for debug purpose
tf-log-trace () {
    export TF_LOG_PATH=trace.log
    export TF_LOG=TRACE
}
# Deactivate Terraform Logs
tf-log-deactivate () {
    export TF_LOG=
}