# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"
provider "aws" {
  region = "eu-west-1"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_default_subnet" "public_subnet_1_cidr" {
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = {
    Name = "Default subnet 1"
  }
}

resource "aws_default_subnet" "public_subnet_2_cidr" {
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = {
    Name = "Default subnet 2"
  }
}
resource "aws_default_subnet" "public_subnet_3_cidr" {
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = {
    Name = "Default subnet 3"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name                    = "${var.ec2_key_pair_name}"
  user_data = <<-EOF
    #! /bin/bash
    sudo apt-get update
    sudo apt-get install nginx -y
    sudo service nginx start
    echo "<h1>Deployed via Terraform</h1>" | sudo tee /usr/share/nginx/html/index.html
    EOF

  tags = {
    Name = "HelloWorld"
  }
}
