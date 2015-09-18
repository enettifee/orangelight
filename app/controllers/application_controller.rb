class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  # include Blacklight::Folders::ApplicationControllerBehavior
  before_filter :protect
  # Please be sure to impelement current_user and user_session. Blacklight depends on
  # these methods in order to perform user specific actions.

  layout 'blacklight'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def protect
    @ips = load_ip_whitelist
    unless @ips.nil? or @ips.include? request.remote_ip
       redirect_to 'http://library.princeton.edu', status: 302
    end
  end

  def load_ip_whitelist
    YAML.load(File.open("./config/ip_whitelist.yml"))
  end

end
