# The load balancer that distributes load between the EC2 Instances
resource "aws_elb" "rails_frontend" {
  name = "rails-frontend"
  subnets = ["${split(",", var.elb_subnet_ids)}"]
  security_groups = ["${aws_security_group.rails_frontend_elb.id}"]
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30

    # The rails-frontend has a health check endpoint at the /health URL
    target = "HTTP:${var.rails_frontend_port}/health"
  }

  listener {
    instance_port = "${var.rails_frontend_port}"
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

# The securty group that controls what traffic can go in and out of the ELB
resource "aws_security_group" "rails_frontend_elb" {
  name = "rails-frontend-elb"
  description = "The security group for the rails-frontend ELB"
  vpc_id = "${var.vpc_id}"

  # Outbound Everything
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The ECS Task that specifies what Docker containers we need to run the rails-frontend.
# Note the SINATRA_BACKEND_PORT environment variable which we point to the sinatra-backend ELB as a simple "service
# discovery" mechanism. The format replicates the behavior of Docker links, which we use in the docker-compose.yml file,
# so the same approach works in both prod and dev. For more info, see:
# https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/#environment-variables
resource "aws_ecs_task_definition" "rails_frontend" {
  family = "rails-frontend"
  container_definitions = <<EOF
[
  {
    "name": "rails-frontend",
    "image": "${var.rails_frontend_image}:${var.rails_frontend_version}",
    "cpu": 1024,
    "memory": 768,
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.rails_frontend_port},
        "hostPort": ${var.rails_frontend_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {"name": "RAILS_ENV", "value": "production"},
      {"name": "SINATRA_BACKEND_PORT", "value": "tcp://${aws_elb.sinatra_backend.dns_name}:${var.sinatra_backend_port}"}
    ]
  }
]
EOF
}

# A long-running ECS Service for the rails-frontend Task
resource "aws_ecs_service" "rails_frontend" {
  name = "rails-frontend"
  cluster = "${aws_ecs_cluster.example_cluster.id}"
  task_definition = "${aws_ecs_task_definition.rails_frontend.arn}"
  depends_on = ["aws_iam_role_policy.ecs_service_policy"]
  desired_count = 2
  deployment_minimum_healthy_percent = 50
  iam_role = "${aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.rails_frontend.id}"
    container_name = "rails-frontend"
    container_port = "${var.rails_frontend_port}"
  }
}