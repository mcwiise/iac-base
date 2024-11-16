variable "policy_name" {
  type        = string
  description = "Name of the IAM policy"
}

variable "policy_description" {
  type        = string
  description = "Description of the IAM policy"
}

variable "policy_document" {
  type        = string
  description = "Policy document in JSON format"
}

variable "role_name" {
  type        = string
  description = "Name of the IAM role"
}

variable "assume_role_policy" {
  type        = string
  description = "Assume role policy document in JSON format"
}

variable "instance_profile_name" {
  type        = string
  description = "Name of the instance profile"
}