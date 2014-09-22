class TaxonConceptsController < ApplicationController
  before_filter :restrict_login
  
  def delete
    TaxonConcept. delete_taxon(params[:id])
    redirect_to :back
  end
end
