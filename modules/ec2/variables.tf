variable "key_pair_name" {
  description = "Name of the key pair to create"
  type        = string
}

variable "ssh_public_key_secret_name" {
  description = "Name of the Secrets Manager secret containing the SSH public key"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile for the EC2 instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for the instance"
  type        = list(string)
}

variable "user_data" {
  description = "User data script for the EC2 instance"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the EC2 instance"
  type        = map(string)
}