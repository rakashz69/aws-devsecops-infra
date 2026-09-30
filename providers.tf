provider "aws" {
  region     = "ap-southeast-1"
  access_key = "test"
  secret_key = "test"

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
