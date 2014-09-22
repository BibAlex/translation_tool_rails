class TaskDistributionController < ApplicationController
  
  layout 'pages'
  
  def index
    @sort_by = params[:sort_by]
    @sort_by = "priority" if @sort_by == "" ||  @sort_by.nil?
    if params[:side_link] == "pending_species"
      @count = TaxonConcept.get_pending_distribution_count 
    elsif params[:side_link] == "reassign_species"
      @count = TaxonConcept.get_finished_distribution_count('')  
    elsif params[:side_link] == "updated_species"
      @count = TaxonConcept.get_updated_taxons_count 
    elsif params[:side_link] == "pending_tasks"
#      @list = BLL_selection_batches::load_all($current_page, $items_per_page, 0)
#      @count = @list.count 
      @count = 70000000
    elsif params[:side_link] == "finished_tasks"
      @count = TaxonConcept.get_pending_distribution_count 
    else
      @count = TaxonConcept.get_pending_distribution_count 
    end
  end
end