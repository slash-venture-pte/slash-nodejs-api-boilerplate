# Output value definitions

output "apigateway_arn" {
  description = "The function handler of Lambda Execution ARN."
  value = aws_api_gateway_rest_api.lambda.execution_arn
}

output "apigateway_id" {
  description = "The function handler of Lambda id."
  value = aws_api_gateway_rest_api.lambda.id
}
output "apigateway_root_resource_id" {
  description = "The function handler of Lambda id."
  value = aws_api_gateway_rest_api.lambda.root_resource_id
}
# output "apigateway_endpoint" {
#   description = "The endpoint of the API gateway."
#   value = aws_api_gateway_rest_api.lambda.
# }