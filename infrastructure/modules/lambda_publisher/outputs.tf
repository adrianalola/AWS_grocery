output "lambda_function_name" {
  value       = aws_lambda_function.fn.function_name
  description = "Deployed Lambda function name"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.fn.arn
  description = "Deployed Lambda function ARN"
}
