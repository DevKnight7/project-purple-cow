resource "aws_sns_topic" "ssl_updates" {
  name = "ssl-updates"
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.ssl_updates.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.project_purple_cow.arn
}

resource "aws_sns_topic_policy" "ssl_updates" {
  arn = aws_sns_topic.ssl_updates.arn

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "__default_policy_ID",
    "Statement" : [
      {
        Sid : "__default_statement_ID",
        Effect : "Allow",
        Principal : {
          "AWS" : "*"
        },
        Action : [
          "SNS:GetTopicAttributes",
          "SNS:SetTopicAttributes",
          "SNS:AddPermission",
          "SNS:RemovePermission",
          "SNS:DeleteTopic",
          "SNS:Subscribe",
          "SNS:ListSubscriptionsByTopic",
          "SNS:Publish"
        ],
        Resource : aws_sns_topic.ssl_updates.arn,
        Condition : {
          "StringEquals" : {
            "AWS:SourceOwner" : local.account_id
          }
        }
      }
    ]
  })
}
