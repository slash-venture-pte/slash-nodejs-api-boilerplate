# Output value definitions

output "lambda_function_handler_arn" {
  description = "The function handler ARN."
  value = aws_lambda_function.lambda_handler.arn
}