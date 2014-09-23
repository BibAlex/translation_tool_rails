class TaxonConceptAssignLog < ActiveRecord::Base
  attr_accessible :taxon_concept_id, :user_id, :phase_id, :by_user_id
  def self.taxon_concept_assign_log(taxon_concept_id, user_id, phase_id, by_user_id)
    TaxonConceptAssignLog.create(taxon_concept_id: taxon_concept_id, user_id: user_id,
                              phase_id: phase_id, by_user_id: by_user_id)
  end
  
end
