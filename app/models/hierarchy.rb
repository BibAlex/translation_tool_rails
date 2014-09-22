class Hierarchy < ActiveRecord::Base
  
  
  def self.load_all
    Hierarchy.establish_connection(:adapter  => "mysql2",
                                   :host     => "localhost",
                                   :username => "root",
                                   :password => "root",
                                   :database => "#{MASTER}_#{Rails.env}")
    Hierarchy.find_by_sql("select id, label from hierarchies where browsable=1 order by label;")
  end
  
  def self.get_name(id)
   Hierarchy.establish_connection(:adapter  => "mysql2",
                                  :host     => "localhost",
                                  :username => "root",
                                  :password => "root",
                                  :database => "#{MASTER}_#{Rails.env}")
   id.nil? ? "" : Hierarchy.find(id).label
  end
end