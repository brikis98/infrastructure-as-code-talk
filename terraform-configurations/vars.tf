# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  description = "The region where to deploy this code (e.g. us-east-1)."
  default = "us-east-1"
}

variable "key_pair_name" {
  description = "The name of the Key Pair that can be used to SSH to each EC2 instance in the ECS cluster. Leave blank to not include a Key Pair."
  default = ""
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