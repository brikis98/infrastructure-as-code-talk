# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# Create an EC2 instance
resource "aws_instance" "example_for_talk" {
  # AMI ID for Amazon Linux AMI 2016.03.0 (HVM)
  ami = "ami-e2df388d"
  instance_type = "t2.micro"
}

