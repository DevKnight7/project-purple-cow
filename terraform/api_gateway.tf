resource "aws_api_gateway_rest_api" "project_purple_cow" {
  name        = "project-purple-cow"
  description = "Terraform Serverless Application purple_cow"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.project_purple_cow.id
  parent_id   = aws_api_gateway_rest_api.project_purple_cow.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.project_purple_cow.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.project_purple_cow.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.project_purple_cow.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.project_purple_cow.id
  resource_id   = aws_api_gateway_rest_api.project_purple_cow.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.project_purple_cow.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.project_purple_cow.invoke_arn
}

resource "aws_api_gateway_deployment" "project_purple_cow" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root
  ]

  rest_api_id = aws_api_gateway_rest_api.project_purple_cow.id
  stage_name  = local.environment
}
