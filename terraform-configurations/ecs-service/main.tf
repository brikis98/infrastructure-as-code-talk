# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS SERVICE TO RUN A LONG-RUNNING ECS TASK
# We also associate the ECS Service with an ELB, which can distribute traffic across the ECS Tasks.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_service" "service" {
  name = "${var.name}"
  cluster = "${var.ecs_cluster_id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count = "${var.desired_count}"
  iam_role = "${aws_iam_role.ecs_service_role.arn}"

  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
  deployment_maximum_percent = "${var.deployment_maximum_percent}"

  load_balancer {
    elb_name = "${var.elb_name}"
    container_name = "${var.name}"
    container_port = "${var.container_port}"
  }

  depends_on = ["aws_iam_role_policy.ecs_service_policy"]
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS TASK TO RUN A DOCKER CONTAINER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_task_definition" "task" {
  family = "${var.name}"
  container_definitions = <<EOF
[
  {
    "name": "${var.name}",
    "image": "${var.image}:${var.image_version}",
    "cpu": ${var.cpu},
    "memory": ${var.memory},
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.container_port},
        "hostPort": ${var.host_port},
        "protocol": "tcp"
      }
    ],
    "environment": [${join(",", data.template_file.env_vars.*.rendered)}]
  }
]
EOF
}

# Convert the environment variables the user passed-in into the format expected for for an ECS Task:
#
# "environment": [
#    {"name": "NAME", "value": "VALUE"},
#    {"name": "NAME", "value": "VALUE"},
#    ...
# ]
#
data "template_file" "env_vars" {
  count = "${var.num_env_vars}"
  template = <<EOF
{"name": "${element(keys(var.env_vars), count.index)}", "value": "${lookup(var.env_vars, element(keys(var.env_vars), count.index))}"}
EOF
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM ROLE FOR THE ECS SERVICE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "ecs_service_role" {
  name = "${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_role.json}"
}

data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# ATTACH IAM PERMISSIONS TO THE IAM ROLE
# This IAM Policy allows the ECS Service to communicate with EC2 Instances.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role_policy" "ecs_service_policy" {
  name = "ecs-service-policy"
  role = "${aws_iam_role.ecs_service_role.id}"
  policy = "${data.aws_iam_policy_document.ecs_service_policy.json}"
}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress"
    ]
  }
}
