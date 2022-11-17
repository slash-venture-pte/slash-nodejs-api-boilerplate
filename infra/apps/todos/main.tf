# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 4.0.0"
#     }
#     random = {
#       source  = "hashicorp/random"
#       version = "~> 3.1.0"
#     }
#     archive = {
#       source  = "hashicorp/archive"
#       version = "~> 2.2.0"
#     }
#   }

#   required_version = "~> 1.0"
# }

# provider "aws" {
#   region = var.serverless_conf.provider.region
# }

# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = lower("${var.serverless_conf.application.name}-${var.serverless_conf.function.name}-bucket")
# }


# resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
#   bucket = aws_s3_bucket.lambda_bucket.id
#   acl    = "private"
# }

# resource "random_pet" "lambda_bucket_name" {
#   prefix = "learn-terraform-functions"
#   length = 4
# }

# resource "aws_s3_bucket" "lambda_bucket" {
#   bucket = random_pet.lambda_bucket_name.id
# }

# resource "aws_s3_bucket_acl" "bucket_acl" {
#   bucket = aws_s3_bucket.lambda_bucket.id
#   acl    = "private"
# }