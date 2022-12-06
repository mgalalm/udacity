# TODO: Designate a cloud provider, region, and credentials
provider "aws" {
  region  = "us-east-1"
  profile = "udacity"
}

# Provision 4 AWS t2.micro EC2 instances named Udacity T2
resource "aws_instance" "Udacity_T2" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  count         = 4
  subnet_id     = var.subnet_pub
}

# Provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  ami           = "ami-0742b4e673072066f"
  instance_type = "m4.large"
  count         = 2
  subnet_id     = var.subnet_pub
}
