# Output value definitions

output "app_todo_handler_arn" {
  description = "The ARN of Redshift Serverless."
  value = module.serverless_deploy.lambda_function_handler
}