class Priority < ActiveRecord::Base
  # attr_accessible :title, :body
  
  def self.get_label(id)
    Priority.find(id).label
  end
  
  def self.load_all
    Priority.find_by_sql("SELECT * FROM priorities order by sort_order;")
  end
end
