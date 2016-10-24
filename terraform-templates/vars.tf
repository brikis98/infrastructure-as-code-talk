# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "key_pair_name" {
  description = "The name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster"
}

variable "vpc_id" {
  description = "The id of the VPC where the ECS cluster should run"
}

variable "elb_subnet_ids" {
  description = "A list of subnets where the ELBs should be deployed"
  type = "list"
}

variable "ecs_cluster_subnet_ids" {
  description = "A list of subnets where the EC2 instances for the ECS cluster should be deployed"
  type = "list"
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The region to apply these templates to (e.g. us-east-1)"
  default = "us-east-1"
}

variable "rails_frontend_image" {
  description = "The name of the Docker image to deploy for the Rails frontend (e.g. gruntwork/rails-frontend)"
  default = "gruntwork/rails-frontend"
}

variable "rails_frontend_version" {
  description = "The version (i.e. tag) of the Docker container to deploy for the Rails frontend (e.g. latest, 12345)"
  default = "v1"
}

variable "sinatra_backend_image" {
  description = "The name of the Docker image to deploy for the Sinatra backend (e.g. gruntwork/sinatra-backend)"
  default = "gruntwork/sinatra-backend"
}

variable "sinatra_backend_version" {
  description = "The version (i.e. tag) of the Docker container to deploy for the Sinatra backend (e.g. latest, 12345)"
  default = "v1"
}

variable "rails_frontend_port" {
  description = "The port the Rails frontend Docker container listens on for HTTP requests (e.g. 3000)"
  default = 3000
}

variable "sinatra_backend_port" {
  description = "The port the Sinatra backend Docker container listens on for HTTP requests (e.g. 4567)"
  default = 4567
}