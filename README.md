# slash-nodejs-api-boilerplate
Slash NodeJs API Boilerplate

Terraform:

## Example: TODOS

Path: apps/todos/infra

Terraform scripts:

```sh

yarn build

cd infra/apps/todos

terraform init

# apply with variables
# resources: https://dev.classmethod.jp/articles/i-tried-4-different-ways-to-assign-variable-in-terraform/

terraform apply -var-file="lambda.tfvars"


```