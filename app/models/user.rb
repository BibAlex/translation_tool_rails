class User < ActiveRecord::Base
  
  attr_accessor :entered_password
  validates :entered_password, :presence => true
  validates :username, :presence => true
  
  def self.authenticate(username, password)
    return nil if username.nil? || password.nil?
    self.find_by_username_and_password(username, password)
  end
end
