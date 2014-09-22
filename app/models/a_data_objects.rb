class ADataObject < ActiveRecord::Base
  # attr_accessible :title, :body
  
  def self.Count_a_dataObjects_ByTaxonConceptID(taxon_concept_id, process_id) 
    query_str = "SELECT COUNT(a_data_objects.id)
                 FROM a_data_objects INNER JOIN data_objects ON (a_data_objects.id=data_objects.id)
                 INNER JOIN  data_objects_taxon_concepts
                 ON (data_objects.id=data_objects_taxon_concepts.data_object_id)                         
                 WHERE  data_objects_taxon_concepts.taxon_concept_id=#{taxon_concept_id}  AND 
                 (  process_id>=#{process_id}  ) AND data_objects.hidden=0;"
    ADataObject.find_by_sql(query_str)
  end
end
