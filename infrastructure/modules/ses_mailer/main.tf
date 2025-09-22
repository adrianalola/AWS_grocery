terraform {
  required_version = ">= 1.6.0"
}

variable "project_name" { type = string }
variable "sns_topic_arn" { type = string }
variable "from_email" { type = string }
variable "to_email" { type = string }
variable "cf_domain" { type = string } # p.ej. dxxxx.cloudfront.net

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/../../lambda/sns_to_ses_mailer/app.py"
  output_path = "${path.module}/.build/sns_to_ses_mailer.zip"
}

resource "aws_iam_role" "role" {
  name = "${var.project_name}-sns-to-ses-mailer-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect : "Allow",
      Principal : { Service : "lambda.amazonaws.com" },
      Action : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "inline" {
  name = "${var.project_name}-sns-to-ses-mailer-policy"
  role = aws_iam_role.role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "SesSend"
        Effect : "Allow"
        Action : ["ses:SendEmail", "ses:SendRawEmail"]
        Resource : "*"
      },
      {
        Sid : "Logs"
        Effect : "Allow"
        Action : ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource : "*"
      }
    ]
  })
}

resource "aws_lambda_function" "fn" {
  function_name = "${var.project_name}-sns-to-ses-mailer"
  role          = aws_iam_role.role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.11"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  environment {
    variables = {
      FROM_EMAIL = var.from_email
      TO_EMAIL   = var.to_email
      CF_DOMAIN  = var.cf_domain
    }
  }
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowSNSTrigger"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fn.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}

resource "aws_sns_topic_subscription" "sub" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.fn.arn
}
