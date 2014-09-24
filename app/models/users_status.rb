class UsersStatus < ActiveRecord::Base
  has_many :user
  has_many :status
end