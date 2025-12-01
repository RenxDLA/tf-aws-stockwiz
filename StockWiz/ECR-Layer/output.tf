output "ecr_repository_url" {
  description = "ECR Repository URL"
  value       = module.ecr.ecr_repository_url
}

output "lambda_url" {
  description = "Lambda function url"
  value       = module.lambda.lambda_url
}