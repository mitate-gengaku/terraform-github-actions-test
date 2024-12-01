provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

data "aws_acm_certificate" "s3_acm" {
  provider = aws.use1
  domain = "images.shomotsu.net"
}