class Status < ActiveRecord::Base
  
  def self.select_status_by_id(status_id)
    'Distribution' if(status_id == 0)
     status = Status.find_by_sql("select * from status where id = #{status_id};")
     status && status.first ? status.first.label : ''
  end
end
