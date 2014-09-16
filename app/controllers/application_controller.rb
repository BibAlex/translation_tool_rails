class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'pages'
  
  def check_authentication
    if !is_logged_in?
      redirect_to :controller => :users, :action => :login
      return false
    end
    if session[:user_id].to_i != params[:id].to_i
      flash.now[:error] = I18n.t(:flash_error_access_denied)
      flash.keep
      redirect_to :controller => :pages, :action => :home
      return false
    end
    return true
  end
  
  def is_logged_in?
    session[:user_id].nil? ? false : true
  end
  
end
