# Create EC2 web_server type instance t2.micro & attach vpc_security_group & iam_instance_profile
resource "aws_instance" "web_server" {
  ami                    = "ami-1234567890" # AMI palsu khusus emulator
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name #Role ditempelkan disini  

# FIX Result #2: Enkripsi disk utama (OS)
  root_block_device {
    encrypted = true
  }

  # FIX Result #1: Paksa penggunaan IMDSv2 untuk keamanan metadata
  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "DevSecOps-Local-EC2"
    Environment = "Development"
  }

}
