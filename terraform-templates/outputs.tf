output "elb_dns" {
  value = "${aws_elb.rails_example_app.dns_name}"
}