class Priority < ActiveRecord::Base
    
  def self.find_label(id)
    pr = Priority.find(id) 
    if pr
      return pr.label
    else
      return ''
    end
  end
  
  def self.load_all
    Priority.find_by_sql("SELECT * FROM priorities order by sort_order;")
  end
end
