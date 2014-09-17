class TaxonConcept < ActiveRecord::Base
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
end
