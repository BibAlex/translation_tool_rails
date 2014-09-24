class PagesController < ApplicationController
  include ApplicationHelper
  def home
    return redirect_to :controller => :users, :action => :login if !is_logged_in?
    @page_title = I18n.t(:page_title_application_home)
  end
end
