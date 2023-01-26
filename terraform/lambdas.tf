resource "aws_iam_role" "lambda_role" {
  name               = "project-purple-cow"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  inline_policy {
    name = "ALLOW_SNS"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["sns:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

resource "aws_lambda_function" "project_purple_cow" {
  function_name    = "check_ssl_expiration"
  filename         = "purple-cow.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.9"
  handler          = "check_ssl_expiration.lambda_handler"
  timeout          = 10
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.project_purple_cow.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.project_purple_cow.execution_arn}/*/*"
}
