# Create security group ingress http & egress 0.0.0.0./0
resource "aws_security_group" "web_sg" {
  name        = "allow_web_traffic"
  description = "Allow inbound HTTP traffic"
  vpc_id      = aws_vpc.local_vpc.id

  ingress {
    description = "Allow HTTP from 10.0.0.0/16"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  #   ingress {
  #    description = "HTTPS from anywhere"
  #    from_port   = 443
  #    to_port     = 443
  #    protocol    = "tcp"
  #    cidr_blocks = ["0.0.0.0/0"]
  #  }

  egress {
    description = "Allow All Outbound to 10.0.0.0/16"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }
}
