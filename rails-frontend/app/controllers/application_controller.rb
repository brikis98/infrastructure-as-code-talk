require 'net/http'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Example endpoint that calls the sinatra-backend
  def index
    url = URI.parse(backend_addr)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    @text = res.body
  end

  # This endpoint is used for health checks. It should return a 200 OK when the app is up and ready to serve requests.
  def health
    render plain: "OK"
  end

  def backend_addr
    # This environment variable is set by Docker linking or via our custom Terraform code as a very simple "service
    # discovery" mechanism. For more info, see:
    # https://docs.docker.com/engine/userguide/networking/default_network/dockerlinks/#environment-variables
    sinatra_tcp_addr = ENV["SINATRA_BACKEND_PORT"]

    # The address will be of the form, tcp://172.17.0.5:5432, so we replace the tcp with http and add a trailing slash
    sinatra_tcp_addr.sub(/^tcp:/, 'http:') + "/"
  end
end
