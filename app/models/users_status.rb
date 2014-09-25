class UsersStatus < ActiveRecord::Base
  has_many :user
  has_many :status
  
  def self.get_users_of_specified_phase(phase_id)
    UsersStatus.find_by_sql("SELECT users.id as id, users.name as name, users.email as email
      FROM users_statuses
      inner join users ON users.id = users_statuses.user_id 
      WHERE
      status_id = #{phase_id}")
  end
end