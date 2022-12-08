terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
  }

  required_version = "~> 1.0"
}

module serverless_deploy {
  source = "../../modules/serverless_deploy"

  provider = {
    region = "ap-southeast-1"
    runtime = "nodejs14.x"
  }
  application = {
    name = "slash-assessment"
    path = "admin-questionaires"
  }
  function = {
    name = "manageQuestionaires",
    handler = "index.handler"
  }
}