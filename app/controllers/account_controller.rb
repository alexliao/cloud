require 'yaml'
class AccountController < ApplicationController
  include CommonHelper
  before_filter :redirect_anonymous, :only => [:sign_out, :invite_link]
  before_filter :log_access
  
  #api
  def appversion
    app_version
  end
  def app_version
    return unless validate_format
    yml = YAML.load(File.open("app/views/account/app_changes_#{session[:lang]}.yml"))
    changes = yml["changes"]
    ret = []
    old_version = params[:client_version] ? params[:client_version].to_i : 0 
    changes.each do |change|
      ret << change if change["code"] > old_version
    end 
    api_response ret
  end
  
protected
  
end