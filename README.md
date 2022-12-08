# slash-nodejs-api-boilerplate
Slash NodeJs API Boilerplate

Terraform:

## Example: TODOS

Path of the infra: `infra/apps/admin-questionaires`

Terraform scripts:

```sh

yarn install --production

yarn build

cd infra/apps/admin-questionaires

# Init it first
terraform init

# Plan it
terraform plan

# apply with variables
# resources: https://dev.classmethod.jp/articles/i-tried-4-different-ways-to-assign-variable-in-terraform/
# when needed to add the var file?
# terraform apply -var-file="main.tfvars"

# Terraform apply
terraform apply

```