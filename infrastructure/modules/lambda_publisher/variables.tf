variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN where the Lambda will publish"
  type        = string
}

variable "lambda_source_file" {
  description = "Absolute path to lambda app.py"
  type        = string
}
