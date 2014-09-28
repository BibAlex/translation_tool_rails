class AddStateIdToTaxonConcept < ActiveRecord::Migration
  def change
    add_column :taxon_concepts, :state_id, :integer, :default => 0
  end
end
