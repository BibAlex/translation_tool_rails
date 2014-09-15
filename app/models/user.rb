class User < ActiveRecord::Base
  
  
  def self.authenticate(username, password)
    return nil if username.nil? || password.nil?
    self.find_by_username_and_password(username, password)
  end
end
