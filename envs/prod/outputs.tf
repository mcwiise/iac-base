output "ec2_elastic_ip" {
  value       = module.ec2.ec2_elastic_ip
  description = "The Elastic IP of the deployed EC2 instance"
}

output "instance_id" {
  value = module.ec2.instance_id
}
