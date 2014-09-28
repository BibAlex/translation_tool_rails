require 'will_paginate/array'
class PhasesController < ApplicationController
  layout 'list'
  
  before_filter :restrict_login
  
  def search
    @total_items = TaxonConcept.Count_taxon_concepts_ForTranslation_FromPool(SLAVE,session[:user_id],params[:spid],
                                                                params[:spname],params[:trstatus],
                                                                params[:phase])
    @taxons_concepts = TaxonConcept.Select_taxon_concepts_ForTranslation_FromPool(SLAVE,session[:user_id],params[:spid],
                                                             params[:spname],params[:trstatus],
                                                             params[:phase], params[:page])
    if params[:pickedID]
      TaxonConcept.Update_taxon_concepts_TranslationStatus(params[:pickedID]);
      TaxonConcept.taxon_concept_assign_log(params[:pickedID], session[:user_id], params[:phase], session[:user_id])
      @taxons_concepts = TaxonConcept.Select_taxon_concepts_ForTranslation_FromPool(SLAVE,session[:user_id],params[:spid],
                                                             params[:spname],params[:trstatus],
                                                             params[:phase], params[:page])
    end
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
  