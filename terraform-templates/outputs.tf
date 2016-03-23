output "rails_frontend_url" {
  value = "http://${aws_elb.rails_frontend.dns_name}"
}

output "sinatra_backend_url" {
  value = "http://${aws_elb.sinatra_backend.dns_name}:${var.sinatra_backend_port}"
}