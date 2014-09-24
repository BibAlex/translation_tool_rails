class UsersStatus < ActiveRecord::Base
   belongs_to :status
   belongs_to :user
   attr_accessible :status_id, :user_id
end

