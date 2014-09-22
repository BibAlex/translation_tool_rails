class Priority < ActiveRecord::Base
    
  def self.find_label(id)
    pr = Priority.find(id) 
    if pr
      return pr.label
    else
      return ''
    end
  end
end
