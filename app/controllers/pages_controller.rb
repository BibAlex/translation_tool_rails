class PagesController < ActionController::Base
  layout 'pages'
  def home
    @page_title = I18n.t(:page_title_application_home)
  end
end
