class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Example endpoint
  def index
    @text = "Goodbye, World"
  end

  # This action is used for health checks. It should return a 200 OK when the app is up and ready to serve requests.
  def status
    render plain: "OK"
  end
end
