#IP pública instancia EC2
output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

#endpoint de la RDS privada
output "rds_private_endpoint" {
  description = "Endpoint of the private PostgreSQL RDS instance"
  value       = aws_db_instance.postgres_private.endpoint
}

# output "rds_public_endpoint" {
#   description = "Endpoint of the public PostgreSQL RDS instance"
#   value       = aws_db_instance.postgres.endpoint
# }

output "sns_topic_arn" {
  value       = module.sns.topic_arn
  description = "SNS topic ARN for new product notifications"
}

output "lambda_notifier_arn" {
  value       = module.lambda_publisher.lambda_function_arn
  description = "Lambda publisher ARN"
}
