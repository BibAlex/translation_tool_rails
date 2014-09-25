class TaskDistributionController < ApplicationController
  include ApplicationHelper
  layout 'pages'
  
  def index
    @sort_by = params[:sort_by]
    @sort_by = "priority" if @sort_by == "" ||  @sort_by.nil?
    if params[:side_link] == "pending_species"
      @page_title = "#{I18n.t(:task_distribution_tab_side_link_pending_species)}"
      @count = TaxonConcept.get_pending_distribution_count 
      @list = TaxonConcept.get_pending_distribution(params[:page], @sort_by)
    elsif params[:side_link] == "reassign_species"
      @page_title = "#{I18n.t(:task_distribution_tab_side_link_reassign_species)}"
      @count = TaxonConcept.get_finished_distribution_count('') 
      @list = TaxonConcept.get_finished_distribution('', params[:page]) 
    elsif params[:side_link] == "updated_species"
      @page_title = "#{I18n.t(:task_distribution_tab_side_link_updated_species)}"
      @count = TaxonConcept.get_updated_taxons_count 
      @list = TaxonConcept.get_updated_taxons(params[:page], @sort_by)
#    elsif params[:side_link] == "pending_tasks"
#      @page_title = "#{I18n.t(:task_distribution_tab_side_link_pending_tasks)}"
#      @list = SelectionBatch.load_all(params[:page], 0)
##      @count = get_pending_batches_count
#      @count = @list.count
#    elsif params[:side_link] == "finished_tasks"
#      @page_title = "#{I18n.t(:task_distribution_tab_side_link_finished_tasks)}"
#      @list = SelectionBatch.load_all(params[:page], 1)
    else
      @page_title = "#{I18n.t(:task_distribution_tab_side_link_search)}"
      #side_link = search
      @keyword = ""
      # search button is clicked
      if params[:keyword] != "" || !params[:keyword].nil?
        @keyword = params[:keyword]
        @list = TaxonConcept.taxon_search(@keyword, params[:page])
      end
    end
  end
  
  def assign_form
    @page_title = "#{I18n.t(:task_distribution_tab_page_title_reassign_taxon)}"
    @taxon_concept = TaxonConcept.find(params[:id])
    @translators = User.get_all_translators
    @linguistic_reviewers = User.get_all_linguistic_reviewers
    @scientific_reviwers = User.get_all_scientific_reviewers
    @side_link = params[:side_link]
    @controller = params[:back_controller]
    @action = params[:back_action]
  end
  
 
  def delete_from_hash(hash, delete_list)
    delete_list.each do |dl|
      hash.delete(dl)
    end
    hash
  end
  def assign
    delete_list = ["id","side_link", "back_controller", "back_action", 
                   "Distributor","controller", "action"]
    roles_values = params
    roles_values = delete_from_hash(roles_values, delete_list)
    debugger
    @taxon_concept = TaxonConcept.find(params[:id])
    
    
    
    if params[:side_link] == "updated_species"
      TaxonConcept.reassign_updated_taxon(@taxon_concept.id, 
                                          @taxon_concept.translator_id,
                                          old_translator_id,  
                                          @taxon_concept.linguistic_reviewer_id,
                                          old_linguistic_reviewer_id,
                                          @taxon_concept.scientific_reviewer_id,
                                          old_scientific_reviewer_id)
    else
      TaxonConcept.assign_taxon(@taxon_concept.id,
                                @taxon_concept.translator_id,
                                @taxon_concept.linguistic_reviewer_id,
                                @taxon_concept.scientific_reviewer_id)
    end
    @taxon_concept.save
    redirect_to :controller => "#{params[:back_controller]}", :action => "#{params[:back_action]}",
                :side_link => "#{params[:side_link]}"
  end
  
private 
  
  def must_assign_but_not(phase,  role_value)
    # it is select, has no value and it directly assign 
   user.nil?  && phase.dircectly_assigned
  end
  
  def return_to_pool(phase, user)
    user.nil?  && !phase.dircectly_assigned
  end
    
  def update_role(phase, user)
    if must_assign_but_not
      # return error missing role
    end
    
    if return_to_pool
      # send mail to all responsibles
      users = UsersStatus.get_users_of_specified_phase(phase.id)
      users.each do |user|
        if user.active == 1 && user.email != ''
 #          $message = 'Hi '.$user->name.',<br><br>New species ready for translation ('.$taxon_concept->scientificName.')<br><br>'.
 #          '<a target="_blank" href="'.$AEOL_url.'/eol_translation/applications/translation/list/poollist.php?process=2&id='.$id.'">Click here</a> to pick this species'
 #          SendMail.send_email(user.name, user.email, 'AEOL: New species ready for translation', message)
        end 
      end
    end
    
    if !user.nil? && @taxon_concept.get_responsible_id(phase.id) != user.id 
      #assign and send message to user
      TaxonConceptAssignLog.create(taxon_concept_id: @taxon_concept.id, 
        user_id: user.id, phase_id: phase.id, assign_date: Time.now, by_user_id: session[:user_id])
      if user.active == 1 && user.email != ''
        #        $message = 'Hi '.$user[0]->name.',<br><br>New species ready for translation ('.$taxon_concept->scientificName.')<br><br>'.
        #        '<a target="_blank" href="'.$AEOL_url.'/eol_translation/applications/translation/details/species.php?tid='.$id.'&trstatus=2&process=2">Click here</a> to translate this species';
        #        SendMail.send_email(user.email, 'AEOL: New species has been assigned', message)
      end
    end
  end
end