
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

  source_hash = "${filebase64sha256(data.archive_file.lambda_archive.output_path)}"

}
#  More : https://github.com/rahman95/terraform-lambda-typescript-starter/blob/master/terraform/lambda.tf

resource "aws_lambda_function" "lambda_handler" {
  function_name = "${var.application.name}-${var.function.name}-${var.apigateway.stage}"

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

resource "aws_cloudwatch_log_group" "lambda_handler" {
  name = "/aws/lambda/${aws_lambda_function.lambda_handler.function_name}"

  retention_in_days = 30
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
    },
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

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# resource "aws_apigatewayv2_integration" "lambda_handler" {
#   count = var.apigateway.count

#   api_id = var.apigateway.restid

#   # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route
#   integration_uri    = "${var.apigateway.endpoint}/${var.apigateway.stage}/${var.application.uri}/{proxy}"
#   integration_type   = "HTTP_PROXY"
#   integration_method = "ANY"
 
# }

# resource "aws_apigatewayv2_route" "lambda_handler_root" {
#   count = length(aws_apigatewayv2_integration.lambda_handler)

#   api_id = var.apigateway.restid

#   route_key = "ANY /"
#   target    = "integrations/${one(aws_apigatewayv2_integration.lambda_handler[*].id)}"
# }

# resource "aws_apigatewayv2_route" "lambda_handler" {
#   count = length(aws_apigatewayv2_integration.lambda_handler)

#   api_id = var.apigateway.restid

#   route_key = "ANY /${var.apigateway.stage}/${var.application.uri}/{proxy+}"
#   target    = "integrations/${one(aws_apigatewayv2_integration.lambda_handler[*].id)}"
# }
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${var.apigateway.restid}"
  parent_id   = "${var.apigateway.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id = "${var.apigateway.restid}"
  resource_id      = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "ANY"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${var.apigateway.restid}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.lambda_handler.invoke_arn}"
}

# resource "aws_api_gateway_method" "proxy_root" {
#   rest_api_id = "${var.apigateway.restid}"
#   resource_id  = "${var.apigateway.root_resource_id}"
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda_root" {
#   rest_api_id = "${var.apigateway.restid}"
#   resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
#   http_method = "${aws_api_gateway_method.proxy_root.http_method}"

#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "${aws_lambda_function.lambda_handler.invoke_arn}"
# }
resource "aws_api_gateway_deployment" "lambda_apig_deploy" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    # aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = "${var.apigateway.restid}"
  stage_name  = "${var.apigateway.stage}"
}

resource "aws_lambda_permission" "api_gw" {
  # count = length(aws_api_gateway_resource.proxy)

  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_handler.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.apigateway.arn}/*/*"
}