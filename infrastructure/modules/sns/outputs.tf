output "topic_arn" {
  value       = aws_sns_topic.new_products.arn
  description = "SNS topic ARN for new products notifications"
}
