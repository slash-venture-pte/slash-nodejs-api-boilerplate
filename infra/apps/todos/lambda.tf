
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0.0"
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
  region = var.serverless_conf.provider.region
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = lower("${var.serverless_conf.application.name}-${var.serverless_conf.function.name}-deployment-bucket")
}




resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  bucket = aws_s3_bucket.lambda_bucket.id
  acl    = "private"
}

data "archive_file" "lambda_archive" {
  type        = "zip"
  source_dir  = "${path.module}/../../../dist/apps/${var.serverless_conf.application.path}"
  output_path = "${path.module}/../../../dist/apps/${var.serverless_conf.application.path}.zip"
}

# upload zip to s3 and then update lamda function from s3
resource "aws_s3_bucket_object" "lambda_archive_upload" {
  bucket = "${aws_s3_bucket.lambda_bucket.id}"
  key    = "${var.serverless_conf.application.name}/${var.serverless_conf.function.name}.zip"
  source = "${data.archive_file.lambda_archive.output_path}" # its mean it depended on zip
}
#  More : https://github.com/rahman95/terraform-lambda-typescript-starter/blob/master/terraform/lambda.tf

resource "aws_lambda_function" "lambda_handler" {
  function_name = var.serverless_conf.function.name

  depends_on = [
    aws_s3_bucket.lambda_bucket,
    aws_s3_bucket_acl.lambda_bucket_acl
  ]

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = aws_s3_bucket.lambda_bucket.id # ("${var.serverless_conf.application.name}-${var.serverless_conf.function.name}-bucket")
  s3_key    = "${var.serverless_conf.application.name}/${var.serverless_conf.function.name}.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "${var.serverless_conf.function.handler}"
  runtime = "${var.serverless_conf.provider.runtime}"

  role = "${aws_iam_role.lambda_exec.arn}"
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "${var.serverless_conf.function.name}-role"

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