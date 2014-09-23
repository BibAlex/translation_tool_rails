class TaxonConcept < ActiveRecord::Base
  require 'will_paginate/array'
  attr_accessible :taxon_status_id, :translator_id, :linguistic_reviewer_id, :scientific_reviewer_id,
  :translator_assigned, :linguistic_assigned
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
      AND scientific_reviewer_id=#{user_id}")
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
      query_string += " and scientificName like '#{keyword}'"
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
