class SelectionBatch < ActiveRecord::Base
  require 'will_paginate/array'
  
  def self.load_all(current_page, finished)
    query_string = "select selection_batches.*,
    (select count(*) from taxon_concepts where
    selection_id=selection_batches.id)
    as pending_taxon_count from selection_batches where "
    if finished > 0
      query_string += " not "
    end
    query_string += " exists (select * from taxon_concepts where selection_id=selection_batches.id and taxon_status_id<2)"
    query_string += " order by date_selected desc "
    SelectionBatch.find_by_sql(query_string).paginate(:page => current_page, :per_page => ITEMS_PER_PAGE)
  end
  
  def self.get_pending_batches_count
    SelectionBatch.count_by_sql('select count(*) as total_count from selection_batches
    where exists
    (select * from taxon_concepts where selection_id=selection_batches.id and taxon_status_id<2)') 
  end
  
  def self.get_finished_batches_count  
    SelectionBatch.count_by_sql('select count(*) as total_count from selection_batches
    where not exists
    (select * from taxon_concepts where selection_id=selection_batches.id and taxon_status_id<2)') 
  end
  
  def self.get_species_count(id)
    SelectionBatch.count_by_sql("select count(*) as total_count from taxon_concepts where selection_id=#{id}")
  end
  
  def self.load_by_id(id)
    SelectionBatch.find_by_sql("select selection_batches.*,
      (select count(*) from taxon_concepts where selection_id=selection_batches.id) as total_taxon_count
      from selection_batches where id=#{id};")
  end
  
end
