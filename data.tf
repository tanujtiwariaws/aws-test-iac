
# Data source to retrieve VPC information
data "aws_vpc" "compute" {
  id = var.webserver_vpc_id[var.env]  # Dynamically retrieve the VPC ID from input variable
}

# Data source to retrieve Subnet information
data "aws_subnet" "compute" {
  id = var.webserver_subnet_id[var.env]  # Dynamically retrieve the subnet ID from input variable
}