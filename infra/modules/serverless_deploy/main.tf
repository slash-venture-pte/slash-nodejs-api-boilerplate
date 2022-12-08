
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.general.region
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = lower("${var.application.name}-${var.function.name}-deployment-bucket")
}


resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}
resource "random_uuid" "lambda_deploy_id" {
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_dir  = "${path.module}/../../../dist/apps/${var.application.path}"
  output_path = "${path.module}/../../../dist/apps/${var.application.path}.zip"
}

# Lib layers
data "archive_file" "layer_archive" {
  type        = "zip"
  source_dir  = "${path.module}/../../../dist/layers"
  output_path = "${path.module}/../../../dist/layers.zip"
}

# Nodemodule layer

data "archive_file" "layer_nodemodule_archive" {
  type        = "zip"
  source_dir  = "${path.module}/../../../dist/layers_nodejs"
  output_path = "${path.module}/../../../dist/layers_nodejs.zip"
}



resource "aws_lambda_layer_version" "dependency_layer" {
  filename            = data.archive_file.layer_archive.output_path
  layer_name          = "dependency_layer"
  compatible_runtimes = [var.general.runtime]
  source_code_hash    = "${filebase64sha256(data.archive_file.layer_archive.output_path)}"
}
resource "aws_lambda_layer_version" "nodemodules_layer" {
  filename            = data.archive_file.layer_nodemodule_archive.output_path
  layer_name          = "nodemodules_layer"
  compatible_runtimes = [var.general.runtime]
  source_code_hash    = "${filebase64sha256(data.archive_file.layer_nodemodule_archive.output_path)}"
}

# upload zip to s3 and then update lamda function from s3
resource "aws_s3_object" "lambda_archive_upload" {
  bucket = "${aws_s3_bucket.lambda_bucket.id}"
  key    = "${var.application.name}/${random_uuid.lambda_deploy_id.result}/${var.function.name}.zip"
  source = "${data.archive_file.lambda_archive.output_path}" # its mean it depended on zip

}
#  More : https://github.com/rahman95/terraform-lambda-typescript-starter/blob/master/terraform/lambda.tf

resource "aws_lambda_function" "lambda_handler" {
  function_name = var.function.name

  depends_on = [
    aws_s3_bucket.lambda_bucket,
    aws_s3_bucket_acl.lambda_bucket_acl
  ]
  layers = [aws_lambda_layer_version.dependency_layer.arn, aws_lambda_layer_version.nodemodules_layer.arn]

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = aws_s3_bucket.lambda_bucket.id # ("${var.application.name}-${var.function.name}-bucket")
  s3_key    = aws_s3_object.lambda_archive_upload.key

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "${var.function.handler}"
  runtime = "${var.general.runtime}"

  role = "${aws_iam_role.lambda_exec.arn}"

  source_code_hash = "${filebase64sha256(data.archive_file.lambda_archive.output_path)}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "${var.function.name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}