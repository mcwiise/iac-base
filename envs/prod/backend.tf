terraform {
  backend "s3" {
    bucket = "prod-stamperlabs-tfstate-bucket"      # S3 bucket name
    key    = "states/terraform.tfstate"      # Path within the bucket where the state file will be stored
    region = "us-east-1"                      # AWS region
    encrypt = true                            # Optional: Encrypt the state file
    dynamodb_table = "tfstate-locks"     # Optional: DynamoDB table for state locking (pre-requisite)
  }
}