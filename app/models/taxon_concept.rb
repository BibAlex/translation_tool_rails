class TaxonConcept < ActiveRecord::Base
  # attr_accessible :title, :body
  
    
  def self.exists_on_slave(id)
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{SLAVE}_#{Rails.env}")
    result = TaxonConcept.find_by_sql("SELECT 1 FROM taxon_concepts where id=#{id};")
    if result && result.count > 0
      return true
    else
      return false
    end
  end
  
  def self.get_taxon_concept(id)
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{MASTER}_#{Rails.env}")
    TaxonConcept.find(id)
  end
  
  def self.get_name(id, hierarchy_id)
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{MASTER}_#{Rails.env}")
    query_str = "SELECT string AS scientificName FROM hierarchy_entries
                 inner join names on names.id=name_id
                 WHERE taxon_concept_id=#{id} and hierarchy_id=#{hierarchy_id};"
    result = TaxonConcept.find_by_sql(query_str)
    if (result && result.count > 0)
      return result[0].scientificName
    else
      return ''
    end
  end
  
  def self.select_taxon_concept(db, id)
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{db}_#{Rails.env}")
    result = TaxonConcept.find_by_sql("SELECT * FROM taxon_concepts where id=#{id};")
    if(result && result.count > 0)
      return result[0]
    else
     return nil
    end
  end
  
  def self.save_taxon_concept(id, supercedure_id, split_from, vetted_id,
                              published, selection_id, scientificName)
                              
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{SLAVE}_#{Rails.env}")
    selection_date = "\"#{Time.now}\""                                 
    connection = TaxonConcept.connection
    connection.insert("insert into taxon_concepts
                        (id, supercedure_id, split_from, vetted_id, published,
                         selection_id, scientificName, selection_date, taxon_status_id)
                         values (#{id}, #{supercedure_id}, #{split_from}, #{vetted_id},
                         #{published}, #{selection_id},#{scientificName},#{selection_date} ,1);") 
  end
  
  def self.get_taxons_list(id_list, hierarchy_id)
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{MASTER}_#{Rails.env}")
    
    query_str = "select distinct he.taxon_concept_id, string as scientificName,            
                 (select count(distinct data_objects.id) from data_objects 
                 inner join data_objects_table_of_contents 
                 ON data_objects_table_of_contents.data_object_id=data_objects.id
                 inner join table_of_contents
                 ON table_of_contents.id=data_objects_table_of_contents.toc_id
                 inner join data_objects_taxon_concepts dotc
                 ON dotc.data_object_id=data_objects.id
                 inner join data_objects_hierarchy_entries dohe
                 On dohe.data_object_id=data_objects.id
                 where dotc.taxon_concept_id=he.taxon_concept_id
                 and dohe.visibility_id<> #{VISIBILITY_INVISIBLE}
                 and language_id = #{LANGUAGE_EN}
                 and data_type_id = #{DATA_TYPES_TEXT}
                 and data_objects.published=1 
                 and 
                 (
                 toc_id in (#{TOC_INCLUDED_PARENT_IDS})
                 or 
                 table_of_contents.parent_id in (#{TOC_INCLUDED_PARENT_IDS}))) 
                 as total_text_objects,
                 (select count(distinct(data_objects.id)) from data_objects
                 Inner join top_concept_images tc on tc.data_object_id=data_objects.id
                 Inner join data_objects_hierarchy_entries dohe on dohe.data_object_id=data_objects.id                           
                 where language_id=#{LANGUAGE_EN}
                 and published=1 
                 and tc.taxon_concept_id=he.taxon_concept_id
                 and dohe.visibility_id<> #{VISIBILITY_INVISIBLE}) as total_image_objects,
                 (select count(distinct data_objects.id) from data_objects 
                 inner join data_objects_taxon_concepts dotc
                 ON dotc.data_object_id=data_objects.id
                 inner join data_objects_hierarchy_entries dohe
                 On dohe.data_object_id=data_objects.id
                 where dotc.taxon_concept_id=he.taxon_concept_id
                 and dohe.visibility_id<> #{VISIBILITY_INVISIBLE}
                 and language_id= #{LANGUAGE_EN}
                 and (data_type_id in (#{DATA_TYPES_MEDIA}))
                 and data_objects.published=1 
                 and published=1) as total_other_objects
                 from hierarchy_entries he
                 left outer join names on names.id=name_id 
                 where taxon_concept_id in (#{id_list}) and hierarchy_id=#{hierarchy_id} order by scientificName"    
    
    TaxonConcept.find_by_sql(query_str)
  end
  
  def can_delete?(master_taxon_concept)
    if (self.taxon_status_id < 2 || (self.taxon_status_id == 2 &&
                                     ADataObject.Count_a_dataObjects_ByTaxonConceptID(master_taxon_concept.id,0) == 0 ))
      true
    else
      false
    end
  end
  
  def self.get_by_id(id)
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{SLAVE}_#{Rails.env}")
    TaxonConcept.find(id)
  end
  
  def self.delete_taxon(id)
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{SLAVE}_#{Rails.env}")
    taxon_concept = TaxonConcept.get_by_id(id)
    if taxon_concept
      taxon_concept.destroy
      connection = TaxonConcept.connection
      
      connection.execute("delete from data_objects_taxon_concepts where taxon_concept_id=#{id};")
      connection.execute("delete from taxon_concept_names where taxon_concept_id=#{id};")
      
      # delete unused data objects
      connection.execute("delete from data_objects where not exists (select * from data_objects_taxon_concepts where data_object_id=data_objects.id);")
      connection.execute("delete from a_data_objects where not exists (select * from data_objects where data_objects.id=a_data_objects.id);")
      
      user_id = taxon_concept.translator_id
      if (taxon_concept.taxon_status_id == 3)
        user_id = taxon_concept.linguistic_reviewer_id
      end
      if (taxon_concept.taxon_status_id == 4)
        user_id = taxon_concept.scientific_reviewer_id
      end
        
        # unlock data objects
        query_str = "update a_data_objects 
                     set locked=0,
                     taxon_concept_id=0
                     where
                     process_id= #{taxon_concept.taxon_status_id}
                     and
                     user_id=#{user_id}
                    and locked=1
                    and taxon_concept_id=#{taxon_concept.id};"
      connection.execute(query_str)      
      
      # delete unused names
      connection.execute("delete from names where not exists (select * from taxon_concept_names where name_id=names.id);")
      connection.execute("delete from a_names where taxon_id=#{id};")
    end
  end 
end
