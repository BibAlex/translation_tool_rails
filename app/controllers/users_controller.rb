class UsersController < ActionController::Base
  
  layout 'pages'
  
  def new
    @id = 0
    @user = User.new
    @page_title = I18n.t(:page_title_users)
  end
  
  def create
    
  end
  
  def index
    @page_title = I18n.t(:page_title_users)
    #list of alll users
  end
  
  def change_password
    
  end
  
  def change_profile
    
  end
  
  def login
    return redirect_to :controller => :pages, :action => :home if is_logged_in?
    @page_title = I18n.t(:page_title_login)
  end
  
  def login_attempt
    @user = User.authenticate(params[:username], params[:password])
    if @user.nil?
      flash.now[:error] = I18n.t(:flash_error_invalid_username_or_password)
      flash.keep
      redirect_to root_path
    else
      log_in(@user)
      redirect_to :controller => :pages, :action => :home
    end
  end
  
  def logout
    log_out
    redirect_to root_path
  end
  
  private
  
  def is_logged_in?
    session[:user_id].nil? ? false : true
  end
  
  def log_in(user)
    session[:user_id] = user.id
    session[:name] = user.name 
    session[:selector] = user.selector
    session[:task_distributor] = user.task_distributor
    session[:translator] = user.translator
    session[:scientific_reviewer] = user.scientific_reviewer
    session[:linguistic_reviewer] = user.linguistic_reviewer
    session[:final_editor] = user.final_editor
    session[:task_distributor] = user.task_distributor
    session[:super_admin] = user.super_admin
  end
  
  def log_out
    session.clear
  end
end
