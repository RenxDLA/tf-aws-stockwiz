output "lambda_url" {
  description = "Lambda function url"
  value       = aws_lambda_function_url.ecr_lambda_url.function_url
}
