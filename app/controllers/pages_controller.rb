class PagesController < ActionController::Base
  layout 'pages'
  def home
    @some = "hello"
  end
end