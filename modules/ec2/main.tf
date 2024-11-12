resource "aws_security_group" "prod-jenkins-ci-server-security-group" {
  name        = "prod-jenkins-ci-server-security-group"
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

# Create IAM Policy
resource "aws_iam_policy" "prod-jenkins-secrets-access-policy" {
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

# Create IAM Role
resource "aws_iam_role" "prod-jenkins-ci-server-role" {
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

# Create IAM Instance Profile
resource "aws_iam_instance_profile" "prod-jenkins-ci-server-instance-profile" {
  name = "EC2SecretsManagerInstanceProfile"
  role = aws_iam_role.prod-jenkins-ci-server-role.name
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "prod-jenkins-ci-server-secrets-access-attachment" {
  role       = aws_iam_role.prod-jenkins-ci-server-role.name
  policy_arn = aws_iam_policy.prod-jenkins-secrets-access-policy.arn
}

data "aws_secretsmanager_secret" "prod-jenkins-ssh-public-key" {
  name = "prod-jenkins-ssh-public-key"  # Replace with your secret name
}

data "aws_secretsmanager_secret_version" "prod-jenkins-ssh-public-key-secret-version" {
  secret_id = data.aws_secretsmanager_secret.prod-jenkins-ssh-public-key.id
}

resource "aws_key_pair" "prod-jenkins-key-pair" {
  key_name   = "prod-jenkins-key-pair"
  public_key = jsondecode(data.aws_secretsmanager_secret_version.prod-jenkins-ssh-public-key-secret-version.secret_string)["public-key"]
}

resource "aws_instance" "prod-jenkins-ci-server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.prod-jenkins-key-pair.key_name
  user_data     = file("./install-jenkins.sh")

  iam_instance_profile = aws_iam_instance_profile.prod-jenkins-ci-server-instance-profile.name
  vpc_security_group_ids = [aws_security_group.prod-jenkins-ci-server-security-group.id]

  tags = {
    Name = "prod-jenkins-ci-server"
  }
}