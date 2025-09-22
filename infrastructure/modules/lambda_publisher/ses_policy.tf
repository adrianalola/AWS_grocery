resource "aws_iam_role_policy" "lambda_ses" {
  name = "${var.project_name}-lambda-ses-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "AllowSesSend",
        Effect : "Allow",
        Action : [
          "ses:SendEmail",
          "ses:SendTemplatedEmail"
        ],
        Resource : "*"
      }
    ]
  })
}
