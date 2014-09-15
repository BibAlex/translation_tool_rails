class PagesController < ApplicationController
  def home
    @page_title = I18n.t(:page_title_application_home)
  end
end
