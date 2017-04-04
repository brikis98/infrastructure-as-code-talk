output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.example_cluster.id}"
}

output "security_group_id" {
  value = "${aws_security_group.ecs_instance.id}"
}

output "iam_role_id" {
  value = "${aws_iam_role.ecs_instance.id}"
}

output "iam_role_name" {
  value = "${aws_iam_role.ecs_instance.name}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.ecs_cluster_instances.name}"
}