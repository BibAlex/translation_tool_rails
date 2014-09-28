require 'will_paginate/array'
class PhasesController < ApplicationController
  layout 'list'
  
  before_filter :restrict_login
  
  def search
    
  end
  
  def species
    @total_items = TaxonConcept.count_taxon_concepts_for_phase(SLAVE,session[:user_id],params[:spid],
                                                               params[:spname],params[:trstatus],
                                                               params[:phase])
    
    
    @taxons_concepts = TaxonConcept.taxon_concepts_for_phase(SLAVE,session[:user_id],params[:spid],
                                                    params[:spname],params[:trstatus],
                                                    params[:phase], params[:page])
  end
  
end
  