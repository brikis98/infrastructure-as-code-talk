output "elb_name" {
  value = "${aws_elb.elb.name}"
}

output "elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}

output "security_group_id" {
  value = "${aws_security_group.elb.id}"
}