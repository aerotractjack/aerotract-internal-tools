#!/bin/bash

alias cl="clear"
alias p3="python3"
alias terrap="terraform plan --out=plan && terraform apply plan"
alias terrdap="terraform destroy -auto-approve && terraform plan --out=plan && terraform apply plan"
