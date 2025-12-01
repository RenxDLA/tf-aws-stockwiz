# Outputs from Network-Layer root module
output "public_subnet_ids" {
	description = "Public subnets IDs"
	value       = module.vpc.public_subnet_ids
}

output "vpc_id" {
	description = "VPC ID"
	value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
	description = "Private subnets IDs"
	value = module.vpc.private_subnet_ids
}