class AdminsController < ApplicationController
  before_filter :logged_in?, :ensure_admin

  def ensure_admin
    return true if current_user.admin
    flash[:error] = "The page you requested is not available" 
    redirect_to root_path
  end
end
