class TaxonConcept < ActiveRecord::Base
  
  require 'will_paginate/array'
  attr_accessible :taxon_status_id, :translator_id, :linguistic_reviewer_id, :scientific_reviewer_id,
                  :translator_assigned, :linguistic_assigned
  
                  
                        
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

  def self.select_taxon_concepts_pending_for_translation_by_user(user_id)
    TaxonConcept.find_by_sql("SELECT taxon_concepts.*, priorities.label as priority FROM taxon_concepts
      inner join selection_batches on selection_batches.id=selection_id
      inner join priorities on priorities.id=priority_id
      WHERE
      taxon_status_id=2
      AND translator_id=#{user_id}
      Order by sort_order, scientificName")
  end
  
  def self.select_taxon_concepts_pending_for_ling_review_by_user(user_id)
    TaxonConcept.find_by_sql("SELECT taxon_concepts.*, priorities.label as priority FROM taxon_concepts
      inner join selection_batches on selection_batches.id=selection_id
      inner join priorities on priorities.id=priority_id
      WHERE
      (taxon_status_id>=2 and taxon_status_id <5)
      AND linguistic_reviewer_id=#{user_id}
      order by sort_order, scientificName")
  end
    
  def self.select_taxon_concepts_pending_for_scien_review_by_user(user_id)
    TaxonConcept.find_by_sql("SELECT taxon_concepts.*, priorities.label as priority
      FROM taxon_concepts
      inner join selection_batches on selection_batches.id=selection_id
      inner join priorities on priorities.id=priority_id
      WHERE
      (taxon_status_id>=2 and taxon_status_id <4)
      AND scientific_reviewer_id=#{user_id}
      ")
  end
  
  def self.get_pending_distribution_count
    TaxonConcept.count_by_sql("select count(*)
      from taxon_concepts
      inner join selection_batches on selection_batches.id=taxon_concepts.selection_id
      inner join users on users.id=selection_batches.user_id
      inner join priorities on priorities.id=priority_id
      where taxon_status_id<=1 and taxon_update = 0")
  end
  
  def self.get_finished_distribution_count(keyword) 
    query_string = "select count(*) as Total_Pending from taxon_concepts 
    where taxon_status_id>=2 "
    if keyword != ''
      query_string += " and scientificName like #{keyword}"
    end
    TaxonConcept.count_by_sql(query_string)
  end
  
  def self.get_updated_taxons_count
    TaxonConcept.count_by_sql("SELECT COUNT(*) AS Total_Pending FROM taxon_concepts 
                               WHERE
                               taxon_update=1 ")
  end
  def self.get_pending_distribution(current_page, sort_by)
    query_string = "select taxon_concepts.*, users.name as selected_by, priorities.label as priority
    from taxon_concepts
    inner join selection_batches on selection_batches.id=taxon_concepts.selection_id
    inner join users on users.id=selection_batches.user_id
    inner join priorities on priorities.id=priority_id
    where taxon_status_id<=1 and taxon_update = 0"
    query_string += get_order_by_string(sort_by)
    TaxonConcept.find_by_sql(query_string).paginate(:page => current_page, :per_page => ITEMS_PER_PAGE)
  end
 
  def self.get_finished_distribution(keyword, current_page)
    query_string = "select taxon_concepts.*, status.label as taxon_status, priorities.label as priority
      from taxon_concepts
      inner join status on status.id=taxon_concepts.taxon_status_id
      inner join selection_batches on selection_batches.id=selection_id
      inner join priorities on priorities.id=priority_id
      where taxon_status_id>=2 "
    if keyword != ''
      query_string += " and scientificName like '#{keyword}' "
    end
    query_string += ' order by sort_order, scientificName '
    TaxonConcept.find_by_sql(query_string).paginate(:page => current_page, :per_page => ITEMS_PER_PAGE)
  end
  def self.get_updated_taxons(current_page, sort_by)
    query_string = "SELECT taxon_concepts.*, status.label AS taxon_status, priorities.label AS priority
    FROM taxon_concepts
    INNER JOIN status ON status.id=taxon_concepts.taxon_status_id
    INNER JOIN selection_batches ON selection_batches.id=selection_id
    INNER JOIN priorities ON priorities.id=priority_id
    WHERE taxon_update=1 "
    query_string += get_order_by_string(sort_by)
    TaxonConcept.find_by_sql(query_string).paginate(:page => current_page, :per_page => ITEMS_PER_PAGE)
  end
  
 
   
  def self.get_translation_assigned(id)
    return get_count(id, 'translator_id', false);
  end
 
  def self.get_translation_unassigned(id)
    return get_count(id, 'translator_id', true);
  end
 
  def self.taxon_search(keyword, current_page)
    TaxonConcept.find_by_sql("select taxon_concepts.*, status.label as taxon_status from taxon_concepts
    left outer join status on status.id=taxon_status_id
    where scientificName like '#{keyword}';").paginate(:page => current_page, :per_page => ITEMS_PER_PAGE)
  end
 
 
  def self.assign_taxon(id, translator_id, linguistic_reviewer_id, scientific_reviewer_id)
    debugger
    taxon_concept = TaxonConcept.find(id)
    taxon_concept.update_attributes(taxon_status_id: 2, translator_id: translator_id,
    linguistic_reviewer_id: linguistic_reviewer_id, scientific_reviewer_id: scientific_reviewer_id)
   
    if translator_id > 0
      taxon_concept.update_attributes(translator_assigned: 1)
    else
      taxon_concept.update_attributes(translator_assigned: 0)
    end
    
    if linguistic_reviewer_id > 0
      taxon_concept.update_attributes(linguistic_assigned: 1)
    else
      taxon_concept.update_attributes(linguistic_assigned: 0)
    end
       
#    // get names
#    BLL_names::download_names($id);
#    // get data objects
#    $dataobjects = BLL_data_objects::Select_DataObjects_ByTaxonConceptID('master',$id); 
#    foreach ($dataobjects as $dataobject) 
#    {
#    BLL_taxon_concepts::Insert_data_object_and_its_relations($dataobject,$id);
#    }
#    // get Images
#    $image_dataobjects = BLL_data_objects::Select_Images_ByTaxonConceptID('master',$id);
#    foreach ($image_dataobjects as $dataobject) 
#    {
#    BLL_taxon_concepts::Insert_data_object_and_its_relations($dataobject,$id);
#    }
#    //Check if taxon is attached to data objects of process id > 2, move taxon to next phase (scientific review)
#    $number_of_en_objects = BLL_data_objects::Count_DataObjects_ByTaxonConceptID('slave',$id);
#    $number_of_ar_objects = BLL_a_data_objects::Count_a_dataObjects_ByTaxonConceptID($id,3);
#    if($number_of_en_objects == $number_of_ar_objects)
#    {
#    $arabic_objects = BLL_a_data_objects::Select_a_dataObjects_ByTaxonConceptID_And_Not_Hidden($id, 3);
#    if($arabic_objects != null && COUNT($arabic_objects) > 0){
#    $minProcess = 6;
#    foreach ($arabic_objects as $arabic_object) {
#    if($arabic_object->process_id < $minProcess){
#    $minProcess = $arabic_object->process_id;
#    }
#    }
#    }
#    BLL_taxon_concepts::Update_taxon_concepts_Status($id,$minProcess,$_SESSION['user_id']);
#    BLL_taxon_concepts::SendMailNotification($id,$minProcess,$_SESSION['user_id']); 
#    }
  end
  
private
  def self.get_order_by_string(sort_by)
    case sort_by
    when "id" 
      return ' order by taxon_concepts.id '
    when "user" 
      return ' order by selected_by ' 
    when "date" 
      return ' order by selection_date ' 
    when "name" 
      return ' order by scientificName ' 
    else 
      return ' order by priority ' 
    end
  end
  
  def self.get_count(id, column_name, is_zero)  
    query_string = "select count(*) as total_count from taxon_concepts where selection_id=#{id} and #{column_name}"
    if is_zero
      query_string += '=0'
    else
      query_string += '>0'
    end
    TaxonConcept.count_by_sql(query_string)
  end
end
