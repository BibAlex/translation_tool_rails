class User < ActiveRecord::Base
   belongs_to :country
   has_many :statuses
   attr_accessible :name, :email, :country_id, :password, :active, :username, :super_admin, 
                    :selector, :task_distributor, :translator, :scientific_reviewer,
                    :linguistic_reviewer, :final_editor
   attr_accessor :password_confirmation
   @email_format_re = %r{^(?:[_\+a-z0-9-]+)(\.[_\+a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i
   validates :email, :presence => true, :format => @email_format_re,
             :uniqueness => { :case_sensitive => false }
   validates :name, :presence => true
   validates :password, :presence => true,
             :confirmation => true,
             :length => {:within => 8..16}
  validates :username, :presence => true,
            :length => {:within => 8..16},
            :uniqueness => { :case_sensitive => false }
               
  def self.authenticate(username, password)
    return nil if username.nil? || password.nil?
    self.find_by_username_and_password(username, password)
  end
  
  def status
    (self.active == 1 ? I18n.t(:active) : I18n.t(:in_active))
  end
  
  def self.get_user_name(id) 
    user = User.find(id)  
    if user
      return user.name
    else
      return ''
    end
  end
  
  def self.get_all_translators
    User.where(translator: 1)
  end
  
  def self.get_all_linguistic_reviewers
    User.where(linguistic_reviewer: 1)
  end
    
  def self.get_all_scientific_reviewers
    User.where(scientific_reviewer: 1)
  end
  
  def has_privilige?(status_id)
    result = UsersStatus.where("user_id = ? and status_id = ?", self.id, status_id)
    result.first.nil? ? false : true 
  end
  
  def delete_all_roles
    records = UsersStatus.where("user_id = ? ", self.id)
    records.each do |record|
      record.destroy if record
    end
  end
end
