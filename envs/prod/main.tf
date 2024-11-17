module "security_group" {
  source      = "../../modules/security-group"
  name        = "prod-jenkins-ci-server-sg"
  description = "Security group for Jenkins CI server"
  ingress_rules = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow SSH" },
    { from_port = 8443, to_port = 8443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow HTTPS 8443" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Allow HTTPS 443" },
  ]
  egress_rules = [
    { from_port = 0, to_port = 0, protocol = "-1", cidr_blocks = ["0.0.0.0/0"], description = "Allow all outbound" },
  ]
}

module "iam" {
  source                = "../../modules/iam"
  policy_name           = "EC2SecretsManagerAccess"
  policy_description    = "Policy for accessing Secrets Manager"
  policy_document       = file("./policy/iam_policy.json")
  role_name             = "EC2SecretsManagerRole"
  assume_role_policy    = file("./policy/assume_role_policy.json")
  instance_profile_name = "EC2SecretsManagerInstanceProfile"
}

module "ec2" {
  source                     = "../../modules/ec2"
  ami_id                     = var.ami_id
  instance_type              = var.instance_type
  ssh_public_key_secret_name = "prod-jenkins-ssh-public-key"
  key_pair_name              = "prod-jenkins-key-pair"
  iam_instance_profile       = module.iam.instance_profile_name
  security_group_ids         = [module.security_group.id]
  user_data                  = file("./script/install-jenkins.sh")
  tags = {
    Name = "prod-jenkins-ci-server"
  }
}