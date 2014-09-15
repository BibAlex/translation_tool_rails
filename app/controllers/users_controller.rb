class UsersController < ApplicationController
  def change_password
    
  end
  
  def edit
    @user = User.find_by_id(params[:id])
    @countries = Country.load_all
  end
  
  def update
    @countries = Country.load_all
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash.now[:notice] = I18n.t("changes_saved")
    end
    flash.keep
    render :action => :edit
  end
  
  def logout
    
  end
end
