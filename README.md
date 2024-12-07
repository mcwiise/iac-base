# Base Infrastructure

This repository contains Terraform scripts for provisioning the foundational infrastructure used in projects developed at Stamper Labs.

## Getting Started

### Install the following tools

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform).
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions).
- [Homebrew](https://brew.sh/).
- [JDK 17](https://formulae.brew.sh/formula/openjdk@17)

### Setup profiles and credencials for AWS C

Grab the secret and access keys from the AWS web console, and run the following steps:

1. Open `config` file for edition:

   ```bash
   # Create the .aws folder in case it does not exist
   mkdir ~/.aws/
   nano ~/.aws/config
   ```

2. Paste the following content:

   ```ini
   [profile stamper.prod]
   region = us-east-1
   ```

3. Open the `credentials` file for edition:

   ```bash
   nano ~/.aws/credentials
   ```

4. Paste the following content:

   ```ini
   [stamper.prod]
   aws_access_key_id = your_aws_access_key_id
   aws_secret_access_key = your_aws_secret_access_key
   ```

5. Verify configuration:

   ```bash
   aws sts get-caller-identity --profile stamper.prod
   ```

## Installation

Follow these steps to configure input variables for Terraform scripts and apply infrastructure changes:

1. Open `.zshrc` file for edition, and add AWS profile env variable

   ```bash
   # Set up the default profile
   export AWS_PROFILE="stamper.prod"
   ```

2. Create the tfstate bucket and enable versioning:

   ```bash
   aws --profile stamper.prod s3api create-bucket \
      --bucket prod-stamperlabs-tfstate-bucket \
      --region us-east-1 \
   ```

3. Enable bucket versioning:

   ```
   aws --profile stamper.prod s3api put-bucket-versioning \
      --bucket prod-stamperlabs-tfstate-bucket \
      --versioning-configuration Status=Enabled
   ```

4. Create the tfstate lock table:

   ```bash
   aws --profile stamper.prod dynamodb create-table \
      --table-name tfstate-locks \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST \
      --region us-east-1
   ```

5. Create a secret containing the public key for SSH access to the EC2 instance:

   ```bash
   aws --profile stamper.prod secretsmanager create-secret \
      --name prod-ec2-jenkins-piblic-key \
      --description "public key to ssh jenkins ec2 instance to" \
      --secret-string '{"public-key":"the ssh key"}' \
      --tags Key=Environment,Value=Production
   ```

6. Open `prod.tfvars` file for edition:

   ```bash
   nano ./envs/prod/prod.tfvars
   ```

7. Paste the following content:

   ```hcl
   aws_access_key = "your aws access key"
   aws_secret_key = "your aws secret key"
   region         = "us-east-1"
   ami_id         = "ami-06b21ccaeff8cd686"
   instance_type  = "t2.micro"
   env            = "prod"
   ```

8. Apply changes to infrastructure:

   ```bash
   # Initialize terraform working directory
   ./gradlew tfInitProd

   # Review the terraform plan
   ./gradlew tfPlanProd

   # Apply changes
   # Be careful, this command by pass the manual confirmation
   ./gradlew tfApplyProd
   ```

## Command Line Interface

The following are the available commands

```shell
# Initialize terraform working directory
./gradlew tfInitProd

# Review the terraform plan
./gradlew tfPlanProd

# Apply changes to the infrastructure
# bypassing manual confirmation
./gradlew tfApplyProd

# Destroy changes made to the infrastructure
# bypassing manual confirmation
./gradlew tfDestroyProd

# Check for formatting issues in source code
./gradlew tfFormatCheck

# Fix formatting issies in source code
./gradlew tfFormat
```
