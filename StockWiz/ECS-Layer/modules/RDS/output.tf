output "db_endpoint" {
  description = "DB Endpoint mapped by environment"
  value       = { for k, inst in aws_db_instance.db : k => inst.endpoint }
}

output "db_port" {
  description = "DB Port mapped by environment"
  value       = { for k, inst in aws_db_instance.db : k => inst.port }
}

output "db_identifier" {
  description = "DB Identifier mapped by environment"
  value       = { for k, inst in aws_db_instance.db : k => inst.id }
}

output "db_address" {
  description = "DB address (hostname without port) mapped by environment"
  value       = { for k, inst in aws_db_instance.db : k => element(split(":", inst.endpoint), 0) }
}

output "db_name" {
  description = "DB Name mapped by environment"
  value       = { for k, inst in aws_db_instance.db : k => inst.db_name }
}
