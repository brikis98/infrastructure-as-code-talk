variable "rails_frontend_image" {
  description = "The name of the Docker image to deploy for the Rails frontend (e.g. gruntwork/rails-frontend)"
}

variable "rails_frontend_version" {
  description = "The version (i.e. tag) of the Docker container to deploy for the Rails frontend (e.g. latest, 12345)"
}

variable "rails_frontend_port" {
  description = "The port the Rails frontend Docker container listens on for HTTP requests (e.g. 3000)"
  default = 3000
}

variable "sinatra_backend_image" {
  description = "The name of the Docker image to deploy for the Sinatra backend (e.g. gruntwork/sinatra-backend)"
}

variable "sinatra_backend_version" {
  description = "The version (i.e. tag) of the Docker container to deploy for the Sinatra backend (e.g. latest, 12345)"
}

variable "sinatra_backend_port" {
  description = "The port the Sinatra backend Docker container listens on for HTTP requests (e.g. 4567)"
  default = 4567
}

variable "key_pair_name" {
  description = "The name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster"
}

variable "vpc_id" {
  description = "The id of the VPC where the ECS cluster should run"
}

variable "elb_subnet_ids" {
  description = "A comma-separated list of subnets where the ELBs should be deployed"
}

variable "ecs_cluster_subnet_ids" {
  description = "A comma-separated list of subnets where the EC2 instances for the ECS cluster should be deployed"
}

variable "region" {
  description = "The region to apply these templates to (e.g. us-east-1)"
}

variable "ami" {
  description = "The AMI for each EC2 instance in the cluster"
  # These are the ids for Amazon's ECS-Optimized Linux AMI from:
  # https://aws.amazon.com/marketplace/ordering?productId=4ce33fd9-63ff-4f35-8d3a-939b641f1931. Note that the very first
  # time, you have to accept the terms and conditions on that page or the EC2 instances will fail to launch!
  default = {
    us-east-1     = "ami-55870742"
    us-west-1     = "ami-07713767"
    eu-central-1  = "ami-3b54be54"
    eu-west-1     = "ami-c74127b4"
  }
}

