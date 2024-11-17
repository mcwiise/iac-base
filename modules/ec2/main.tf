# Secrets Manager Data Sources
data "aws_secretsmanager_secret" "ssh_public_key_secret" {
  name = var.ssh_public_key_secret_name
}

data "aws_secretsmanager_secret_version" "ssh_public_key_secret_version" {
  secret_id = data.aws_secretsmanager_secret.ssh_public_key_secret.id
}

# EC2 Key Pair from Secrets Manager
resource "aws_key_pair" "ec2_instance_key_pair" {
  key_name   = var.key_pair_name
  public_key = jsondecode(data.aws_secretsmanager_secret_version.ssh_public_key_secret_version.secret_string)["public-key"]
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_instance_key_pair.key_name
  iam_instance_profile   = var.iam_instance_profile
  vpc_security_group_ids = var.security_group_ids
  user_data              = var.user_data

  tags = var.tags
}

# Allocate an Elastic IP
resource "aws_eip" "elastic_ip" {}

# Associate the Elastic IP with the instance
resource "aws_eip_association" "elastic_ip_association" {
  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.elastic_ip.id
}