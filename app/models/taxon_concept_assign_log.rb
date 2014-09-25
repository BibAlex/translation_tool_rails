class TaxonConceptAssignLog < ActiveRecord::Base
  attr_accessible :taxon_concept_id, :user_id, :phase_id, :by_user_id
  def self.taxon_concept_assign_log(taxon_concept_id, user_id, phase_id, by_user_id)
    TaxonConceptAssignLog.create(taxon_concept_id: taxon_concept_id, user_id: user_id,
                              phase_id: phase_id, by_user_id: by_user_id)
  end
  
  def self.get_responsible_for_specified_phase(taxon_concept_id, phase_id)
    resp = TaxonConceptAssignLog.find_by_taxon_concept_id_and_phase_id(taxon_concept_id, phase_id)
    if resp
      return resp.user_id
    else
      return 0
    end
  end
  
end
