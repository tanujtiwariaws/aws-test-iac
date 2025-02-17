module "aws_ec2" {
  source = "./modules/aws-ec2"  # Path to your EC2 module
  
  env                   = var.env
  aws_region            = var.aws_region
  ami_id                = var.webserver_ami_id[var.env]
  instance_type         = var.webserver_instance_type
  key_name              = var.webserver_key_name
  subnet_id             = var.webserver_subnet_id[var.env]
  instance_name         = var.webserver_instance_name
  security_group_description = var.webserver_security_group_description
  vpc_id                = var.webserver_vpc_id[var.env]
  user_data             = var.webserver_user_data_script
  ec2_custom_ingress = var.webserver_ec2_custom_ingress
  ec2_custom_egress  = var.webserver_ec2_custom_egress
}
