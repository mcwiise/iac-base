provider "aws" {
  region     = var.region         # AWS region, can be defined in variables.tf
  access_key = var.aws_access_key # AWS access key, can be defined in variables.tf
  secret_key = var.aws_secret_key # AWS secret key, can be defined in variables.tf
}