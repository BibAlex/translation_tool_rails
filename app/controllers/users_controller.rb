class UsersController < ApplicationController
  
  layout 'pages'
  before_filter :restrict_login, except: [:login]
                                        
  before_filter :check_authentication, except: [:login, :new, :create, :index, :logout]
  
  def new
    @id = 0
    @user = User.new
    @page_title = I18n.t(:page_title_users)
    @countries = Country.load_all
    @action = "create"
    @method = "post"
  end
  
  def create
    @countries = Country.load_all
    params.delete :controller
    params.delete :action
    params.delete :password_confirmation
    @user = User.new(params)
    if @user.save
      flash.now[:notice] = I18n.t(:alert_notice_user_successfuly_created)
      flash.keep
      redirect_to :controller => :users, :action => :index
    else
      flash.now[:error] = I18n.t(:alert_error_failed_to_create_user)
      render :new
    end
  end
  
  def index
   @page_title = I18n.t(:page_title_users)
   @users = User.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE).order('name ASC')
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
    @pending_translations = []
    @pending_ling_reviews = []
    @pending_scientific_reviews =[] 
  end
  
  def update
    @countries = Country.load_all
    @user = User.find(params[:id])
    @message = ""
    update = true 
    @pending_translations = []
    @pending_ling_reviews = []
    @pending_scientific_reviews =[] 
    if (@user.translator == 1 && params[:translator].to_i == 0)
      @pending_translations = TaxonConcept.select_taxon_concepts_pending_for_translation_by_user(@user.id);
    end
    if (@user.linguistic_reviewer == 1 && params[:linguistic_reviewer].to_i == 0)
      @pending_ling_reviews = TaxonConcept.select_taxon_concepts_pending_for_ling_review_by_user(@user.id);
    end
    if (@user.scientific_reviewer == 1 && params[:scientific_reviewer].to_i == 0)
      @pending_scientific_reviews = TaxonConcept.select_taxon_concepts_pending_for_scien_review_by_user(@user.id);
    end
    update = false if @pending_translations.count > 0 || @pending_ling_reviews.count > 0 || @pending_scientific_reviews.count > 0
    params.delete :controller
    params.delete :action
    params.delete :id
    if @user.update_attributes(params) && update
      flash.now[:notice] = I18n.t(:alert_notice_user_successfuly_updated)
      flash.keep
      redirect_to :controller => :users, :action => :index
    else
      flash.now[:error] = I18n.t(:alert_error_failed_to_update_user)
      render :edit
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
