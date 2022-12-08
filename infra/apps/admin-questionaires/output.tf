# Output value definitions

output "app_admin_questionaires_handler_arn" {
  description = "The ARN of Redshift Serverless."
  value = module.serverless_deploy.lambda_function_handler_arn
}