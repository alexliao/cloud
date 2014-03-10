class DefaultController < ApplicationController
  before_filter :log_access

  def index
  end
  
end