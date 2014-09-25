class UsersStatus < ActiveRecord::Base
  belongs_to :status
  belongs_to :user
  attr_accessible :status_id, :user_id
  
  def self.get_users_of_specified_phase(phase_id)
    UsersStatus.find_by_sql("SELECT users.id as id, users.name as name, users.email as email
      FROM users_statuses
      inner join users ON users.id = users_statuses.user_id 
      WHERE
      status_id = #{phase_id}")
  end
end

