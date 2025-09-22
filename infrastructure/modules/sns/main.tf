resource "aws_sns_topic" "new_products" {
  name = "${var.project_name}-new-products"
}

data "aws_caller_identity" "me" {}

resource "aws_sns_topic_policy" "restrict_to_account" {
  arn = aws_sns_topic.new_products.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid : "AllowAccountPublishSubscribe",
        Effect : "Allow",
        Principal : { AWS : "arn:aws:iam::${data.aws_caller_identity.me.account_id}:root" },
        Action : ["sns:Publish", "sns:Subscribe", "sns:GetTopicAttributes", "sns:ListSubscriptionsByTopic"],
        Resource : aws_sns_topic.new_products.arn
      }
    ]
  })
}
