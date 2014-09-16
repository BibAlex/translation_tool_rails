class UsersController < ApplicationController
  
  layout 'pages'
  before_filter :check_authentication, only: [:change_profile, :change_profile_attempt,
                                              :change_password, :change_password_attempt]
  before_filter :restrict_login, only: [:index]
  
  def new
    @id = 0
    @user = User.new
    @page_title = I18n.t(:page_title_users)
    @action = "create"
    @method = "post"
  end
  
  def create
    redirect_to :controller => :users, :action => :index
#    if (isset($_POST["name"]))
#      if (trim(strtolower($_POST["email"])) == '') 
#        $message .= '<br>Invalid email';  
#      end
#      if (BLL_users::email_exists($id, trim(strtolower($_POST["email"])))) 
#        $message = 'Email already exists';  
#      end
#      if ($id == 0)
#        if (trim(strtolower($_POST["username"])) == '') 
#          $message .= '<br>Invalid username'; 
#        end
#        if (BLL_users::username_exists($id, trim(strtolower($_POST["username"]))))
#          $message .= '<br>Username already taken'; 
#        end
#        if (trim(strtolower($_POST["password"])) == '')
#          $message .= '<br>Invalid password'; 
#        end
#      end
#    if ($id!=0)
#      if ($message == '') 
#        if ($user->translator == 1 && $_POST["translator"]==0)
#          $pending_translation = BLL_taxon_concepts::Select_pending_taxon_concepts_ForTranslation_ByTranslator('slave',$id,'','','2',1,100000);
#          echo(count($pending_translation));
#          if (count($pending_translation)>0)
#            $message .= 'One or more species are assigned/picked to this user for translation, please reassign and click save<br>';
#            if ($_SESSION['task_distributor'] == 1)
#              foreach($pending_translation as $taxon_concept) do
#                $message .= '<li><a href="../task_distribution/reassign_species.php?id='.$taxon_concept->id.'&selection_id='.$taxon_concept->selection_id.'" target="_blank">'.$taxon_concept->scientificName.'</a></li>';
#              end
#              $message .= '<br/>';
#            end
#          end
#        end
#        if ($user->linguistic_reviewer == 1 && $_POST["linguistic_reviewer"]==0)
#          $pending_ling_review = BLL_taxon_concepts::Select_pending_taxon_concepts_ForLingReview_ByUser('slave',$id,0,'','2',1,100000);
#          if (count($pending_ling_review)>0)
#            $message .= 'One or more species are assigned to this user for linguistic reviewing, please reassign and click save<br>';
#            if ($_SESSION['task_distributor'] == 1)
#              foreach($pending_ling_review as $taxon_concept) do
#                $message .= '<li><a href="../task_distribution/reassign_species.php?id='.$taxon_concept->id.'&selection_id='.$taxon_concept->selection_id.'" target="_blank">'.$taxon_concept->scientificName.'</a></li>';
#              end
#              $message .= '<br/>';
#            end
#          end
#        end
#        if ($user->scientific_reviewer == 1 && $_POST["scientific_reviewer"]==0)
#          $pending_scientific_review = BLL_taxon_concepts::Select_pending_taxon_concepts_ForScienReview_ByUser('slave',$id,0,'','2',1,100000);
#          if (count($pending_scientific_review)>0)
#            $message .= 'One or more species are assigned to this user for scientific reviewing, please reassign and click save<br>';
#            if ($_SESSION['task_distributor'] == 1)
#              foreach($pending_scientific_review as $taxon_concept) do
#                $message .= '<li><a href="../task_distribution/reassign_species.php?id='.$taxon_concept->id.'&selection_id='.$taxon_concept->selection_id.'" target="_blank">'.$taxon_concept->scientificName.'</a></li>';
#              end
#              $message .= '<br/>';
#            end
#          end
#        end
#      end
#    end
#    if ($message == '')
#      if ($user->id ==0)
#        $user->username = trim(strtolower($_POST["username"]));
#        $user->password = trim(strtolower($_POST["password"]));
#      end
#      $user->name = trim($_POST["name"]);
#      $user->email = trim(strtolower($_POST["email"])); 
#      $user->active = $_POST["active"];
#      $user->country_id = $_POST["country_id"];
#      $user->super_admin=$_POST["super_admin"];
#      $user->selector=$_POST["selector"];
#      $user->task_distributor=$_POST["task_distributor"]; 
#      $user->translator=$_POST["translator"];
#      $user->linguistic_reviewer=$_POST["linguistic_reviewer"];
#      $user->scientific_reviewer=$_POST["scientific_reviewer"];
#      $user->final_editor=$_POST["final_editor"]; 
#      BLL_users::save($user); 
#    end
#    ?>
#    <script>
#    alert('Changes have been saved');
#    window.location='list_users.php';
#    </script>
#    <?
  end
  
  def index
    @page_title = I18n.t(:page_title_users)
    @users = User.paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE).order('name DESC')
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
    redirect_to :controller => :users, :action => :change_password
  end
  
  def change_password
  end
  
  def edit
    @id = params[:id]
    @user = User.find(@id)
    @page_title = I18n.t(:page_title_users)
    @action = "update"
    @method = "put"
  end
  
  def update
#    if (isset($_POST["name"])) {
#          if (trim(strtolower($_POST["email"])) == '') {
#          $message .= '<br>Invalid email';  
#          }
#          if (BLL_users::email_exists($id, trim(strtolower($_POST["email"])))) {
#          $message = 'Email already exists';  
#          } 
#          if ($id == 0) {
#          if (trim(strtolower($_POST["username"])) == '') {
#          $message .= '<br>Invalid username'; 
#          }
#          if (BLL_users::username_exists($id, trim(strtolower($_POST["username"])))) {
#          $message .= '<br>Username already taken'; 
#          } 
#          if (trim(strtolower($_POST["password"])) == '') {
#          $message .= '<br>Invalid password'; 
#          } 
#        }
#        if ($id!=0) {
#        if ($message == '') { 
#        if ($user->translator == 1 && $_POST["translator"]==0) {
#        $pending_translation = BLL_taxon_concepts::Select_pending_taxon_concepts_ForTranslation_ByTranslator('slave',$id,'','','2',1,100000);
#        echo(count($pending_translation));
#        if (count($pending_translation)>0) {
#        $message .= 'One or more species are assigned/picked to this user for translation, please reassign and click save<br>';
#        if ($_SESSION['task_distributor'] == 1) {
#        foreach($pending_translation as $taxon_concept) {
#        $message .= '<li><a href="../task_distribution/reassign_species.php?id='.$taxon_concept->id.'&selection_id='.$taxon_concept->selection_id.'" target="_blank">'.$taxon_concept->scientificName.'</a></li>';
#        } 
#        $message .= '<br/>';
#        }
#        }
#        }
#        if ($user->linguistic_reviewer == 1 && $_POST["linguistic_reviewer"]==0) {
#        $pending_ling_review = BLL_taxon_concepts::Select_pending_taxon_concepts_ForLingReview_ByUser('slave',$id,0,'','2',1,100000);
#        if (count($pending_ling_review)>0) {
#        $message .= 'One or more species are assigned to this user for linguistic reviewing, please reassign and click save<br>';
#        if ($_SESSION['task_distributor'] == 1) {
#        foreach($pending_ling_review as $taxon_concept) {
#        $message .= '<li><a href="../task_distribution/reassign_species.php?id='.$taxon_concept->id.'&selection_id='.$taxon_concept->selection_id.'" target="_blank">'.$taxon_concept->scientificName.'</a></li>';
#        } 
#        $message .= '<br/>';
#        }
#        }
#        }
#        if ($user->scientific_reviewer == 1 && $_POST["scientific_reviewer"]==0) {
#        $pending_scientific_review = BLL_taxon_concepts::Select_pending_taxon_concepts_ForScienReview_ByUser('slave',$id,0,'','2',1,100000);
#        if (count($pending_scientific_review)>0) {
#        $message .= 'One or more species are assigned to this user for scientific reviewing, please reassign and click save<br>';
#        if ($_SESSION['task_distributor'] == 1) {
#        foreach($pending_scientific_review as $taxon_concept) {
#        $message .= '<li><a href="../task_distribution/reassign_species.php?id='.$taxon_concept->id.'&selection_id='.$taxon_concept->selection_id.'" target="_blank">'.$taxon_concept->scientificName.'</a></li>';
#        } 
#        $message .= '<br/>';
#        }
#        }
#        } 
#        }
#        }
#        if ($message == '') {
#        if ($user->id ==0) {
#        $user->username = trim(strtolower($_POST["username"]));
#        $user->password = trim(strtolower($_POST["password"]));
#        }
#        $user->name = trim($_POST["name"]);
#        $user->email = trim(strtolower($_POST["email"])); 
#        $user->active = $_POST["active"];
#        $user->country_id = $_POST["country_id"];
#        $user->super_admin=$_POST["super_admin"];
#        $user->selector=$_POST["selector"];
#        $user->task_distributor=$_POST["task_distributor"]; 
#        $user->translator=$_POST["translator"];
#        $user->linguistic_reviewer=$_POST["linguistic_reviewer"];
#        $user->scientific_reviewer=$_POST["scientific_reviewer"];
#        $user->final_editor=$_POST["final_editor"]; 
#        BLL_users::save($user); 
#        ?>
#        <script>
#        alert('Changes have been saved');
#        window.location='list_users.php';
#        </script>
#        <?
#        //break;
#        }
#        }
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
    redirect_to :controller => :users, :action => :change_profile
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
