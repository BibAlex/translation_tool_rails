require 'will_paginate/array'
class SelectionsController < ApplicationController
  layout 'selections'
  
  before_filter :restrict_login
                                        
  
  def index
    @btaches_count = SelectionBatche.count
    @selections = SelectionBatche.find_by_sql("select selection_batches.*, 
                                               (select count(*) from taxon_concepts where
                                               selection_id=selection_batches.id)
                                               as total_taxon_count from selection_batches
                                               order by date_selected desc").paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
  end
  
  def new
    
  end
  
  def search
    @selection_params = {hierarchy_entry_id: params[:hierarchy_entry_id],
                         have_text: params[:have_text], 
                         hierarchy_id: params[:lstHierarchy],
                         have_images: params[:have_images], 
                         text_curated: params[:text_curated],
                         text_vetted: params[:text_vetted], 
                         images_curated: params[:images_curated],
                         images_vetted: params[:images_vetted], 
                         select_hotlists: params[:select_hotlists]}
    
    text_curated = @selection_params[:text_curated].nil? ? nil : @selection_params[:text_curated].strip
    images_curated = @selection_params[:images_curated].nil? ? nil : @selection_params[:images_curated].strip         
    @hierarchy_entries = HierarchyEntry.search(@selection_params[:hierarchy_id],
                                               @selection_params[:hierarchy_entry_id],
                                               @selection_params[:have_text], 
                                               text_curated,
                                               @selection_params[:text_vetted],
                                               @selection_params[:have_images],
                                               images_curated,
                                               @selection_params[:images_vetted],
                                               params[:select_sub], @selection_params[:select_hotlist])
  end
  
  def save_search
    @selection_params = {hierarchy_entry_id: params[:hierarchy_entry_id],
                         have_text: params[:have_text], 
                         hierarchy_id: params[:hierarchy_id],
                         have_images: params[:have_images], 
                         text_curated: params[:text_curated],
                         text_vetted: params[:text_vetted], 
                         images_curated: params[:images_curated],
                         images_vetted: params[:images_vetted], 
                         select_hotlists: params[:select_hotlists],
                         taxon_concept_array: params[:taxon_concept]}
  end
  
  def create
    @selection_params = {hierarchy_entry_id: params[:hierarchy_entry_id],
                         have_text: params[:have_text], 
                         hierarchy_id: params[:hierarchy_id],
                         have_images: params[:have_images], 
                         text_curated: params[:text_curated],
                         text_vetted: params[:text_vetted], 
                         images_curated: params[:images_curated],
                         images_vetted: params[:images_vetted],
                         priority_id: params[:priority_id],
                         taxon_concept_array: params[:taxon_concept],
                         comments: params[:comments],
                         user_id: session[:user_id].to_i}
    @selection_batche = SelectionBatche.save(@selection_params)
    flash[:notice] = I18n.t(:flash_notice_changes_saved)
    redirect_to :controller => :selections, :action => :new
  end
  
  def hierarchy_tree
    parent_id = params[:id]
    hierarchy_id = params[:h_id]
    parent_id = 0 unless parent_id
    hierarchy_id = DEFAULT_HIERARCHY_ID unless hierarchy_id
    @hierarchy_entries = HierarchyEntry.find_siblings(hierarchy_id, parent_id)
    respond_to do |format|
        format.js
    end
  end
  
  def delete
    selection_batche = SelectionBatche.find(params[:id])
    selection_batche.destroy
    flash[:notice] = I18n.t(:flash_selection_deleted)
    redirect_to :controller => :selections, :action => :index
  end
  
  def show_taxons
    @selection = SelectionBatche.find(params[:id])
    @taxon_concepts = SelectionBatche.get_selected_taxons(@selection.id).paginate(:page => params[:page], :per_page => ITEMS_PER_PAGE)
    @taxon_ids = ''
    @taxon_concepts.each do |taxon_concept|
      @taxon_ids += ',' if @taxon_ids != ''
      @taxon_ids += taxon_concept.id.to_s
    end
    @taxon_count = 0
    if (@taxon_ids != '')
      @master_taxon_concepts = TaxonConcept.get_taxons_list(@taxon_ids, @selection.hierarchy_id)
      @taxon_count = @master_taxon_concepts.count
    end
  end
  
end