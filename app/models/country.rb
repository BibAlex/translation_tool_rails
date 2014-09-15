class Country < ActiveRecord::Base
  # attr_accessible :title, :body
  def self.load_all
    Country.order('name ASC')
  end
end
