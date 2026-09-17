provider "aws" {
  region                      = "ap-southeast-1"
  access_key                  = "test"
  secret_key                  = "test"
  
  # Bypass validasi AWS asli
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  # Arahkan API EC2/VPC ke LocalStack
  endpoints {
    ec2 = "http://localhost:4566"
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}

# Create aws_vpc local 10.0.0.0/16
resource "aws_vpc" "local_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "DevSecOps-Local-VPC"
  }
}

# Create security group ingress http & egress 0.0.0.0./0
resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.local_vpc.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   ingress {
#    description = "HTTPS from anywhere"
#    from_port   = 443
#    to_port     = 443
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 web_server type instance t2.micro & attach vpc_security_group & iam_instance_profile
resource "aws_instance" "web_server" {
  ami                    = "ami-1234567890" # AMI palsu khusus emulator
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name #Role ditempelkan disini

  tags = {
    Name = "DevSecOps-Local-EC2"
  }
}

# Create Role & allow EC2 pake role nya
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_readonly_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement= [
     {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
	  Service = "ec2.amazonaws.com"
	  }
	}
     ]     
  })
}

#Create Jembatan (instance profile) untuk role bisa di pasang di EC2
resource "aws_iam_instance_profile" "ec2_profile" {
   name = "ec2_s3_profile"
   role = aws_iam_role.ec2_s3_role.name
}
