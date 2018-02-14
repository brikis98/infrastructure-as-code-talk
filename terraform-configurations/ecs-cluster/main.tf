# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "example_cluster" {
  name = "${var.name}"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY AN AUTO SCALING GROUP (ASG)
# Each EC2 Instance in the ASG will register as an ECS Cluster Instance.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "ecs_cluster_instances" {
  name = "${var.name}"
  min_size = "${var.size}"
  max_size = "${var.size}"
  launch_configuration = "${aws_launch_configuration.ecs_instance.name}"
  vpc_zone_identifier = ["${var.subnet_ids}"]

  tag {
    key = "Name"
    value = "${var.name}"
    propagate_at_launch = true
  }
}

# Fetch the AWS ECS Optimized Linux AMI. Note that if you've never launched this AMI before, you have to accept the
# terms and conditions on this webpage or the EC2 instances will fail to launch:
# https://aws.amazon.com/marketplace/pp/B00U6QTYI2
data "aws_ami" "ecs" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

# The launch configuration for each EC2 Instance that will run in the ECS
# Cluster
resource "aws_launch_configuration" "ecs_instance" {
  name_prefix = "${var.name}-"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"
  security_groups = ["${aws_security_group.ecs_instance.id}"]
  image_id = "${data.aws_ami.ecs.id}"

  # A shell script that will execute when on each EC2 instance when it first boots to configure the ECS Agent to talk
  # to the right ECS cluster
  user_data = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=${var.name}" >> /etc/ecs/ecs.config
EOF

  # Important note: whenever using a launch configuration with an auto scaling
  # group, you must set create_before_destroy = true. However, as soon as you
  # set create_before_destroy = true in one resource, you must also set it in
  # every resource that it depends on, or you'll get an error about cyclic
  # dependencies (especially when removing resources). For more info, see:
  #
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  # https://terraform.io/docs/configuration/resources.html
  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN IAM ROLE FOR EACH INSTANCE IN THE CLUSTER
# We export the IAM role ID as an output variable so users of this module can attach custom policies.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "ecs_instance" {
  name = "${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_instance.json}"

  # aws_iam_instance_profile.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
  # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ecs_instance" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# To attach an IAM Role to an EC2 Instance, you use an IAM Instance Profile
resource "aws_iam_instance_profile" "ecs_instance" {
  name = "${var.name}"
  role = "${aws_iam_role.ecs_instance.name}"

  # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
  # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
  lifecycle {
    create_before_destroy = true
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# ATTACH IAM POLICIES TO THE IAM ROLE
# The IAM policy allows an ECS Agent running on each EC2 Instance to communicate with the ECS scheduler.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role_policy" "ecs_cluster_permissions" {
  name = "ecs-cluster-permissions"
  role = "${aws_iam_role.ecs_instance.id}"
  policy = "${data.aws_iam_policy_document.ecs_cluster_permissions.json}"
}

data "aws_iam_policy_document" "ecs_cluster_permissions" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:Submit*"
    ]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP THAT CONTROLS WHAT TRAFFIC CAN GO IN AND OUT OF THE CLUSTER
# We export the ID of the group as an output variable so users of this module can attach custom rules.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "ecs_instance" {
  name = "${var.name}"
  description = "Security group for the EC2 instances in the ECS cluster ${var.name}"
  vpc_id = "${var.vpc_id}"

  # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
  # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "all_outbound_all" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.ecs_instance.id}"
}

resource "aws_security_group_rule" "all_inbound_ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${var.allow_ssh_from_cidr_blocks}"]
  security_group_id = "${aws_security_group.ecs_instance.id}"
}

resource "aws_security_group_rule" "all_inbound_ports" {
  count = "${length(var.allow_inbound_ports_and_cidr_blocks)}"

  type = "ingress"
  from_port = "${element(keys(var.allow_inbound_ports_and_cidr_blocks), count.index)}"
  to_port = "${element(keys(var.allow_inbound_ports_and_cidr_blocks), count.index)}"
  protocol = "tcp"
  cidr_blocks = ["${lookup(var.allow_inbound_ports_and_cidr_blocks, element(keys(var.allow_inbound_ports_and_cidr_blocks), count.index))}"]
  security_group_id = "${aws_security_group.ecs_instance.id}"
}

