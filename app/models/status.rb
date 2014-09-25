class Status < ActiveRecord::Base
  
  def self.select_status_by_id(status_id)
    'Distribution' if(status_id == 0)
     status = Status.find_by_sql("select * from status where id = #{status_id};")
     status && status.first ? status.first.label : ''
  end
  
  def self.get_phases
    all = Status.all
    if all.include? "Distribution"
      all.delete("Distribution")
    end
    all
  end
  
  def self.get_phases_roles
    all = get_phases
    arr = []
    i = 0
    all.each do |status|
      arr[i] = status.role
      i+=1
    end  
    arr
  end
  def self.get_phases_ids
    all = get_phases
    arr = []
    i = 0
    all.each do |status|
      arr[i] = status.id
      i+=1
    end  
    arr
  end
end
