module "ec2" {
  source         = "../../modules/ec2"
  ami_id         = "ami-06b21ccaeff8cd686"
  instance_type  = "t2.micro"
  environment    = "prod"
}