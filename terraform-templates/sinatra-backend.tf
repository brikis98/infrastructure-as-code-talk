# The load balancer that distributes load between the EC2 Instances
resource "aws_elb" "sinatra_backend" {
  name = "sinatra-backend"
  subnets = ["${split(",", var.elb_subnet_ids)}"]
  security_groups = ["${aws_security_group.sinatra_backend_elb.id}"]
  cross_zone_load_balancing = true

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 30

    # The sinatra-backend has a health check endpoint at the /health URL
    target = "HTTP:${var.sinatra_backend_port}/health"
  }

  listener {
    instance_port = "${var.sinatra_backend_port}"
    instance_protocol = "http"
    lb_port = "${var.sinatra_backend_port}"
    lb_protocol = "http"
  }
}

# The securty group that controls what traffic can go in and out of the ELB
resource "aws_security_group" "sinatra_backend_elb" {
  name = "sinatra-backend-elb"
  description = "The security group for the sinatra-backend ELB"
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
    from_port = "${var.sinatra_backend_port}"
    to_port = "${var.sinatra_backend_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The ECS Task that specifies what Docker containers we need to run the sinatra-backend
resource "aws_ecs_task_definition" "sinatra_backend" {
  family = "sinatra-backend"
  container_definitions = <<EOF
[
  {
    "name": "sinatra-backend",
    "image": "${var.sinatra_backend_image}:${var.sinatra_backend_version}",
    "cpu": 1024,
    "memory": 768,
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.sinatra_backend_port},
        "hostPort": ${var.sinatra_backend_port},
        "protocol": "tcp"
      }
    ],
    "environment": [
      {"name": "RACK_ENV", "value": "production"}
    ]
  }
]
EOF
}

# A long-running ECS Service for the sinatra-backend Task
resource "aws_ecs_service" "sinatra_backend" {
  name = "sinatra-backend"
  cluster = "${aws_ecs_cluster.example_cluster.id}"
  task_definition = "${aws_ecs_task_definition.sinatra_backend.arn}"
  depends_on = ["aws_iam_role_policy.ecs_service_policy"]
  desired_count = 2
  deployment_minimum_healthy_percent = 50
  iam_role = "${aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    elb_name = "${aws_elb.sinatra_backend.id}"
    container_name = "sinatra-backend"
    container_port = "${var.sinatra_backend_port}"
  }
}