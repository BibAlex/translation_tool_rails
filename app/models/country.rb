class Country < ActiveRecord::Base
  def self.load_all
    Country.order('name ASC')
  end
end
