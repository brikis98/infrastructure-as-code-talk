output "rails_frontend_url" {
  value = "http://${module.rails_frontend_elb.elb_dns_name}"
}

output "sinatra_backend_url" {
  value = "http://${module.sinatra_backend_elb.elb_dns_name}"
}