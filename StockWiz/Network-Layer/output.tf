# Outputs from Network-Layer root module
output "public_subnet_ids" {
	description = "Public subnets IDs that were created by the VPC module"
	value       = module.vpc.public_subnet_ids
}

output "vpc_id" {
	description = "VPC ID from VPC module"
	value       = module.vpc.vpc_id
}