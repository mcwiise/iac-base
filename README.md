# Base Infrastructure
This repository contains Terraform scripts for provisioning the foundational infrastructure used in projects developed at Stamper Labs.
These scripts provide a consistent and automated way to set up and manage essential resources.

## Prerequisites
* Install [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform).
* Install [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions).
* Install [Homebrew](https://brew.sh/).
* Install [JDK 17](https://formulae.brew.sh/formula/openjdk@17)
* SSH Key: Have your .pem key available for SSH access to your EC2 instances.

## Installation

### 1. Create `prod.tfvars` file

Create `./envs/prod/prod.tfvars` file and place the following content:

```hcl
aws_access_key = "your aws access key"
aws_secret_key = "your aws secret key"
region         = "us-east-1"
ami_id         = "ami-06b21ccaeff8cd686"
instance_type  = "t2.micro"
env            = "prod"
```
### 2. Initialize terraform working directory

```shell
./gradlew tfInitProd
```
### 3. Review the terraform plan

```shell
./gradlew tfPlanProd
```

### 4. Apply changes

```shell
./gradlew tfApplyProd
```

## Configurations

### 1. Set Up Jenkins with HTTPS

* SSH into the Jenkins EC2 Instance

* Edit the Jenkins Service Configuration

    ```shell
    sudo systemctl edit jenkins
    ```

* Add HTTPS Configuration

    ```bash
    [Service]
    Environment="JENKINS_PORT=-1"
    Environment="JENKINS_HTTPS_PORT=8443"
    Environment="JENKINS_HTTPS_KEYSTORE=/var/lib/jenkins/.ssl/server.jks"
    Environment="JENKINS_HTTPS_KEYSTORE_PASSWORD=password"
    ```

* Reload and Restart Jenkins

    ```shell
    sudo systemctl daemon-reload
    sudo systemctl restart jenkins
    ```

* Verify Jenkins Status

    ```shell
    sudo systemctl status jenkins
    ```

## Command Line Interface

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