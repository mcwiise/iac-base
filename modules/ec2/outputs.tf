output "instance_id" {
  value = aws_instance.this.id
}

output "ec2_elastic_ip" {
  value = aws_eip.elastic_ip.public_ip
  description = "The Elastic IP of the deployed EC2 instance"
}