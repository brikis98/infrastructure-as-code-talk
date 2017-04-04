# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create an EC2 instance
resource "aws_instance" "example_for_talk" {
  # AMI ID for Amazon Linux AMI 2016.03.0 (HVM) in us-east-1
  ami = "ami-0b33d91d"
  instance_type = "t2.micro"
}

