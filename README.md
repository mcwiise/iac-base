# Base Infrastructure

This repository contains Terraform scripts for provisioning the foundational infrastructure used in projects developed at Stamper Labs.

## Getting Started

### Install the following tools

* [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform).
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions).
* [Homebrew](https://brew.sh/).
* [JDK 17](https://formulae.brew.sh/formula/openjdk@17)

### Setup profiles and credencials for AWS CLI

Grab the secret and access keys from the AWS web console, and run the following steps:

1. Open `config` file for edition:

    ```bash
    nano ~/.aws/config
    ```

2. Paste the following content:

    ```ini
    [profile tonnika.prod]
    region = us-east-1
    ```

3. Open the `credentials` file for edition:

    ```bash
    nano ~/.aws/credentials
    ```

4. Paste the following content:

    ```ini
    [profile tonnika.prod]
    aws_access_key_id = your_aws_access_key_id
    aws_secret_access_key = your_aws_secret_access_key
    ```

5. Verify configuration:

    ```bash
    aws sts get-caller-identity --profile tonnika.prod
    ```

## Installation

Follow these steps to configure input variables for Terraform scripts and apply infrastructure changes:

1. Open `prod.tfvars` file for edition:

    ```bash
    nano ./envs/prod/prod.tfvars
    ```

2. Paste the following content:

    ```hcl
    aws_access_key = "your aws access key"
    aws_secret_key = "your aws secret key"
    region         = "us-east-1"
    ami_id         = "ami-06b21ccaeff8cd686"
    instance_type  = "t2.micro"
    env            = "prod"
    ```

3. Initialize terraform working directory:

    ```bash
    ./gradlew tfInitProd
    ```

4. Review the terraform plan:

    ```bash
    ./gradlew tfPlanProd
    ```

5. Apply changes:

    ```bash
    # Be carefull, this command by pass the manual confirmation
    ./gradlew tfApplyProd
    ```

6. Destroy changes:

    ```bash
    # Be carefull, this command by pass the manual confirmation
    ./gradlew tfDestroyProd
    ```

## Additional Configuration

### Configure jenkins to start with HTTPS

1. SSH into the Jenkins EC2 Instance:

2. Edit the Jenkins Service Configuration

    ```shell
    sudo systemctl edit jenkins
    ```

3. Add HTTPS Configuration

    ```bash
    [Service]
    Environment="JENKINS_PORT=-1"
    Environment="JENKINS_HTTPS_PORT=8443"
    Environment="JENKINS_HTTPS_KEYSTORE=/var/lib/jenkins/.ssl/server.jks"
    Environment="JENKINS_HTTPS_KEYSTORE_PASSWORD=password"
    ```

4. Reload and Restart Jenkins

    ```shell
    sudo systemctl daemon-reload
    sudo systemctl restart jenkins
    ```

5. Verify Jenkins Status

    ```shell
    sudo systemctl status jenkins
    ```

## Command Line Interface

The following are the available commands

```shell
# Initialize terraform working directory
./gradlew tfInitProd

# Review the terraform plan
./gradlew tfPlanProd

# Apply changes to the infrastructure
./gradlew tfApplyProd

# Check for formatting issues in source code
./gradlew tfFormatCheck

# Fix formatting issies in source code
./gradlew tfFormat
```
