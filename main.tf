resource "aws_security_group" "security_group_jenkins" {
  name        = "security-group-jenkins"
  description = "Allow SSH and HTTP and HTTPS access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // Allow SSH from anywhere
  }

  # Allow HTTPS (port 8443) from anywhere
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to your specific IP range as needed
  }

  # Allow HTTPS (port 443) from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change this to your specific IP range as needed
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"           // Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]  // Allow all outbound traffic
  }
}

# Data source to retrieve the secret
data "aws_secretsmanager_secret" "prod_ec2_jenkins_ssh_public_key" {
  name = "prod-ec2-jenkins-ssh-public-key"  # Replace with your secret name
}

data "aws_secretsmanager_secret_version" "prod_ec2_jenkins_ssh_public_key_secret_version" {
  secret_id = data.aws_secretsmanager_secret.prod_ec2_jenkins_ssh_public_key.id
}

resource "aws_key_pair" "key_pair" {
  key_name   = "my-key-pair"
  public_key = jsondecode(data.aws_secretsmanager_secret_version.prod_ec2_jenkins_ssh_public_key_secret_version.secret_string)["public_key"]
}

data "aws_secretsmanager_secret" "prod_ec2_jenkins_keystore" {
  name = "prod-ec2-jenkins-keystore"  # Replace with your secret name
}

data "aws_secretsmanager_secret_version" "prod_ec2_jenkins_keystore_secret_version" {
  secret_id = data.aws_secretsmanager_secret.prod_ec2_jenkins_keystore.id
}


# Create IAM Policy
resource "aws_iam_policy" "secrets_manager_access" {
  name        = "EC2SecretsManagerAccess"
  description = "Policy to allow EC2 instances to access Secrets Manager"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2SecretsManagerInstanceProfile"
  role = aws_iam_role.ec2_role.name
}

# Create IAM Role
resource "aws_iam_role" "ec2_role" {
  name               = "EC2SecretsManagerRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.secrets_manager_access.arn
}

resource "aws_instance" "ec2_amazon_linux_jenkins" {
  ami           = "ami-06b21ccaeff8cd686" 
  instance_type = "t2.micro"
  key_name = aws_key_pair.key_pair.key_name
  user_data     = file("./install-jenkins.sh")

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  vpc_security_group_ids = [aws_security_group.security_group_jenkins.id]

  tags = {
    Name = "ec2_amazon_linux_jenkins"
  }
}