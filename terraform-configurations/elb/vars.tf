# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED MODULE PARAMETERS
# These variables must be passed in by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  description = "The name of the ELB"
}

variable "vpc_id" {
  description = "The ID of the VPC in which to deploy the ELB."
}

variable "subnet_ids" {
  description = "The subnet IDs in which to deploy the ELB."
  type = "list"
}

variable "instance_port" {
  description = "The port the EC2 Instance is listening on. The ELB will route traffic to this port."
}

variable "health_check_path" {
  description = "The path on the instance the ELB can use for health checks. Do NOT include a leading slash."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "lb_port" {
  description = "The port the ELB listens on."
  default = 80
}