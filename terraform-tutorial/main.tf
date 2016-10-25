# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

# Create an EC2 instance
resource "aws_instance" "example_for_talk" {
  # AMI ID for Amazon Linux AMI 2016.03.0 (HVM) in eu-west-1
  ami = "ami-d41d58a7"
  instance_type = "t2.micro"
}

