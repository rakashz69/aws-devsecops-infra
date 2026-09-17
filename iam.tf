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
