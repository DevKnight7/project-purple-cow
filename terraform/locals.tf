locals {
  region      = "us-east-1"
  account_id  = data.aws_caller_identity.current.account_id
  environment = "production"

  tags = {
    "Project"     = "purple-cow"
    "Environment" = local.environment
    "Owner"       = "Terraform"
  }
}
