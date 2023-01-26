data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "sns.amazonaws.com"]
    }
  }
}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "../code/check_ssl_expiration.py"
  output_path = "purple-cow.zip"
}
