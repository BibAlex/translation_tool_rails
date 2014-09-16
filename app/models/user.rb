class User < ActiveRecord::Base
   belongs_to :country
   attr_accessible :name, :email, :country_id, :password
   
   @email_format_re = %r{^(?:[_\+a-z0-9-]+)(\.[_\+a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i
   validates :email, :presence => true, :format => @email_format_re,
             :uniqueness => { :case_sensitive => false }
   validates :name, :presence => true
  
  def self.authenticate(username, password)
    return nil if username.nil? || password.nil?
    self.find_by_username_and_password(username, password)
  end
  
  def status
    (self.active == 1 ? I18n.t(:active) : I18n.t(:in_active))
  end
end
