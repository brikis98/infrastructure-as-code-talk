terraform {
  required_version = "> 0.9.0"
}

provider "aws" {
  region = "${var.region}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

module "ecs_cluster" {
  source = "./ecs-cluster"

  name = "ecs-example"
  size = 6
  instance_type = "t2.micro"
  key_pair_name = "${var.key_pair_name}"

  vpc_id = "${data.aws_vpc.default.id}"
  subnet_ids = ["${data.aws_subnet.default.*.id}"]

  # To keep the example simple to test, we allow SSH access from anywhere. In real-world use cases, you should lock 
  # this down just to trusted IP addresses.
  allow_ssh_from_cidr_blocks = ["0.0.0.0/0"]

  # Here, we allow the EC2 Instances in the ECS Cluster to recieve requests on the ports used by the rails-frontend
  # and sinatra-backend. To keep the example simple to test, we allow these requests from any IP, but in real-world
  # use cases, you should lock this down to just the IP addresses of the ELB and other trusted parties.
  allow_inbound_ports_and_cidr_blocks = "${map(
    var.rails_frontend_port, "0.0.0.0/0",
    var.sinatra_backend_port, "0.0.0.0/0"
  )}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE SINATRA BACKEND APP AND AN ELB FOR IT
# ---------------------------------------------------------------------------------------------------------------------

module "sinatra_backend" {
  source = "./ecs-service"

  name = "sinatra-backend"
  ecs_cluster_id = "${module.ecs_cluster.ecs_cluster_id}"
  
  image = "${var.sinatra_backend_image}"
  image_version = "${var.sinatra_backend_version}"
  cpu = 1024
  memory = 768
  desired_count = 2
  
  container_port = "${var.sinatra_backend_port}"
  host_port = "${var.sinatra_backend_port}"
  elb_name = "${module.sinatra_backend_elb.elb_name}"

  num_env_vars = 1
  env_vars = "${map("RACK_ENV", "production")}"
}

module "sinatra_backend_elb" {
  source = "./elb"

  name = "sinatra-backend-elb"

  vpc_id = "${data.aws_vpc.default.id}"
  subnet_ids = ["${data.aws_subnet.default.*.id}"]

  instance_port = "${var.sinatra_backend_port}"
  health_check_path = "health"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE RAILS FRONTEND APP AND AN ELB FOR IT
# ---------------------------------------------------------------------------------------------------------------------

module "rails_frontend" {
  source = "./ecs-service"

  name = "rails-frontend"
  ecs_cluster_id = "${module.ecs_cluster.ecs_cluster_id}"

  image = "${var.rails_frontend_image}"
  image_version = "${var.rails_frontend_version}"
  cpu = 1024
  memory = 768
  desired_count = 2

  container_port = "${var.rails_frontend_port}"
  host_port = "${var.rails_frontend_port}"
  elb_name = "${module.rails_frontend_elb.elb_name}"

  # Provide the URL of the sinatra-backend ELB using the same environment variable name and format as docker-compose
  num_env_vars = 2
  env_vars = "${map(
    "RACK_ENV", "production",
    "SINATRA_BACKEND_PORT", "tcp://${module.sinatra_backend_elb.elb_dns_name}"
  )}"
}

module "rails_frontend_elb" {
  source = "./elb"

  name = "rails-frontend-elb"

  vpc_id = "${data.aws_vpc.default.id}"
  subnet_ids = ["${data.aws_subnet.default.*.id}"]

  instance_port = "${var.rails_frontend_port}"
  health_check_path = "health"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY THIS EXAMPLE IN THE DEFAULT SUBNETS OF THE DEFAULT VPC
# To keep this example as easy to use as possible, we deploy into the default subnets of your default VPC. That means
# everything is accessible publicy, which is fine for learning/experimenting, but NOT a good practice for production.
# In real world use cases, you should run your code in the private subnets of a custom VPC.
#
# Note that if you do not have a default VPC (i.e. you have an older AWS account or you deleted the VPC), you will
# need to manually fill in the VPC and subnet IDs above.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {}

# Look up the default subnets in the AZs available to this account (up to a max of 3)
data "aws_subnet" "default" {
  count = "${min(length(data.aws_availability_zones.available.names), 3)}"
  default_for_az = true
  vpc_id = "${data.aws_vpc.default.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
}