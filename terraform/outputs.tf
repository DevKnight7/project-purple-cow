output "account_id" {
  value = local.account_id
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.project_purple_cow.invoke_url
}

output "sns_topic" {
  value = aws_sns_topic.ssl_updates.id
}
