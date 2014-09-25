class UsersController < ApplicationController
  include ApplicationHelper
  layout 'pages'
  before_filter :restrict_login, except: [:login, :login_attempt]
                                        
  before_filter :check_authentication, except: [:login, :new, :create, :index, :logout,
                                                :login_attempt, :edit, :update]
  
  def new
    @id = 0
    @user = User.new
    @page_title = I18n.t(:page_title_users)
    @countries = Country.load_all
    @action = "create"
    @method = "post"
    @statuses = Status.all
  end
  
  def create
    @countries = Country.load_all
    params.delete :controller
    params.delete :action
    params.delete :password_confirmation
    user_roles = params.select { |key, value| key.to_s.match(/status/) }
    params.delete_if { |key, value| key.to_s.match(/status/) }
    @user = User.new(params)
    if @user.save
      
      # add roles
      user_roles.each do |key, value|
        if value.to_i == 1
          status = Status.find_by_label(key[key.index("_") + 1, key.length])
          UsersStatus.create(user_id: @user.id, status_id: status.id) if status
        end
      end
      flash.now[:notice] = I18n.t(:alert_notice_user_successfuly_created)
      flash.keep
      redirect_to :controller => :users, :action => :index
    else
      flash.now[:error] = I18n.t(:alert_error_failed_to_create_user)
      @statuses = Status.all
      render :new
    end
  end
  
  def index
   @page_title = I18n.t(:page_title_users)
   @users = User.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE).order('name ASC')
   @statuses = Status.all
 end
  
  def change_password_attempt
    @user = User.find(params[:id])
    if @user.password == params[:old_password]
      if @user.update_attributes(password: params[:password])
        flash.now[:notice] = I18n.t(:flash_notice_password_changed)
      else
      end
    else
      flash.now[:error] = I18n.t(:flash_error_invalid_old_password)
    end
    flash.keep
    render :change_password
  end
  
  def change_password
  end
  
  def edit
    @id = params[:id]
    @user = User.find(@id)
    @page_title = I18n.t(:page_title_users)
    @countries = Country.load_all
    @action = "update"
    @method = "put"
    @statuses = Status.all
    @pending_taxons = [] if params[:pending].nil? || params[:pending]
  end
  
  def update
    @countries = Country.load_all
    @user = User.find(params[:id])
    @message = ""
    @statuses = Status.all
    update = true 
    user_roles = params.select { |key, value| key.to_s.match(/status/) }
    @pending_taxons = []
    
    user_roles.each do |key, value|
      key = key[key.index("_") + 1, key.length]
      status = Status.find_by_label(key)
      if status &&  @user.has_privilige?(status.id) && value.to_i == 0
        pending_taxons_phase = TaxonConcept.select_taxon_concepts_pending_for_phase_by_user(@user.id, status.id)
         if pending_taxons_phase.count > 0
           pending_taxons_phase.each do |item|
             @pending_taxons << item
           end
           update = false
         end
      end
    end
        
    params.delete :controller
    params.delete :action
    params.delete :id
    params.delete_if { |key, value| key.to_s.match(/status/) }
    
    if @user.update_attributes(params) && update
      # add roles
      @user.delete_all_roles
      user_roles.each do |key, value|
        if value.to_i == 1
          status = Status.find_by_label(key[key.index("_") + 1, key.length])
          UsersStatus.create(user_id: @user.id, status_id: status.id) if status
        end
      end
      
      flash.now[:notice] = I18n.t(:alert_notice_user_successfuly_updated)
      flash.keep
      redirect_to :controller => :users, :action => :index
    else
      flash.now[:error] = I18n.t(:alert_error_failed_to_update_user)
      render :edit, { pending: update }
    end
#    ?>
#    <script>
#    alert('Changes have been saved');
#    window.location='list_users.php';
#    </script>
#    <?
  end
  
  def change_profile
    @user = User.find_by_id(params[:id])
    @countries = Country.load_all
  end
  
  def change_profile_attempt
    @countries = Country.load_all
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash.now[:notice] = I18n.t(:flash_notice_changes_saved)
    end
    flash.keep
    render :change_profile
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
  
  def log_in(user)
    session[:user_id] = user.id
    session[:name] = user.name 
    session[:selector] = user.selector
    session[:super_admin] = user.super_admin
    user_status_list = UsersStatus.where(user_id: user.id)
    roles = ""
    user_status_list.each do |user_status|
      roles += Status.find(user_status.status_id) + "," 
    end
    session[:roles] = roles
  end
  
  def log_out
    session.clear
  end
end
