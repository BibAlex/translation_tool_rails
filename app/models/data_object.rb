class DataObject < ActiveRecord::Base
  require 'will_paginate/array'
  DataObject.establish_connection(
   :adapter  => "mysql2",
   :host     => "localhost",
   :username => "root",
   :password => "root",
   :database => "eol_data_#{Rails.env}"
  )
  def self.get_text_count(id)
    DataObject.count_by_sql("select count(distinct data_objects.id) from data_objects
      inner join data_objects_table_of_contents
      ON data_objects_table_of_contents.data_object_id=data_objects.id
      inner join table_of_contents
      ON table_of_contents.id=data_objects_table_of_contents.toc_id
      inner join data_objects_taxon_concepts dotc
      ON dotc.data_object_id=data_objects.id
      inner join data_objects_hierarchy_entries dohe
      On dohe.data_object_id=data_objects.id
      where dotc.taxon_concept_id=#{id}
      and dohe.visibility_id<>#{VISIBILITY_INVISIBLE}
      and language_id=#{LANGUAGE_EN}
      and data_type_id=#{DATA_TYPES_TEXT}
      and data_objects.published=1
      and
      (
      toc_id in (#{TOC_INCLUDED_PARENT_IDS})
      or
      table_of_contents.parent_id in (#{TOC_INCLUDED_PARENT_IDS}))")
  end
  
  
  def self.get_images_count(id)
    DataObject.count_by_sql("select count(distinct(data_objects.id)) from data_objects
      Inner join top_concept_images tc on tc.data_object_id=data_objects.id
      Inner join data_objects_hierarchy_entries dohe on dohe.data_object_id=data_objects.id
      where language_id=#{LANGUAGE_EN}
      and published=1
      and tc.taxon_concept_id=#{id}
      and dohe.visibility_id<>#{VISIBILITY_INVISIBLE}")
  end
  
  def self.get_av_count(id) 
    DataObject.count_by_sql("select count(distinct data_objects.id) from data_objects
      inner join data_objects_hierarchy_entries dohe
      ON dohe.data_object_id=data_objects.id
      inner join hierarchy_entries he
      ON he.id=dohe.hierarchy_entry_id
      where taxon_concept_id=#{id}
      and language_id=#{LANGUAGE_EN}
      and data_type_id in (#{DATA_TYPES_MEDIA})
      and data_objects.published=1
      and dohe.visibility_id=#{VISIBILITY_INVISIBLE}")
  end
end