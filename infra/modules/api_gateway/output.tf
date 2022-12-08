# Output value definitions

output "apigateway_arn" {
  description = "The function handler of Lambda Execution ARN."
  value = aws_apigatewayv2_api.lambda.execution_arn
}

output "apigateway_id" {
  description = "The function handler of Lambda id."
  value = aws_apigatewayv2_api.lambda.id
}