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
    elsif params[:side_link] == "pending_tasks"
      @page_title = "#{I18n.t(:task_distribution_tab_side_link_pending_tasks)}"
      @list = SelectionBatch.load_all(params[:page], 0)
#      @count = get_pending_batches_count
      @count = @list.count
    elsif params[:side_link] == "finished_tasks"
      @page_title = "#{I18n.t(:task_distribution_tab_side_link_finished_tasks)}"
      @list = SelectionBatch.load_all(params[:page], 1)
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
  
 
  
  def assign
    @taxon_concept = TaxonConcept.find(params[:id])
    old_translator_id =  @taxon_concept.translator_id
    old_scientific_reviewer_id =  @taxon_concept.scientific_reviewer_id
    old_linguistic_reviewer_id =  @taxon_concept.linguistic_reviewer_id
    update_translator
    update_scientific_reviewer
    update_linguistic_reviewer
    
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
  def update_translator
    debugger
     # if a new translator may be selected
     if params[:side_link] == "updated_species" ||
       ( @taxon_concept.taxon_status_id < 3 &&  @taxon_concept.translator_id != params["translator"].to_i)
       @taxon_concept.translator_id = params["translator"].to_i
       # if no one is selected (send to all users)
       if params["translator"].to_i == 0 
         users = User.all
         users.each do |user|
           if user.active == 1 && user.translator == 1 && user.email != ''
   #          $message = 'Hi '.$user->name.',<br><br>New species ready for translation ('.$taxon_concept->scientificName.')<br><br>'.
   #          '<a target="_blank" href="'.$AEOL_url.'/eol_translation/applications/translation/list/poollist.php?process=2&id='.$id.'">Click here</a> to pick this species'
   #          SendMail.send_email(user.name, user.email, 'AEOL: New species ready for translation', message)
           end 
         end
       else
         user = User.find(params["translator"])
         if user.active == 1 && user.email != ''
   #        $message = 'Hi '.$user[0]->name.',<br><br>New species ready for translation ('.$taxon_concept->scientificName.')<br><br>'.
   #        '<a target="_blank" href="'.$AEOL_url.'/eol_translation/applications/translation/details/species.php?tid='.$id.'&trstatus=2&process=2">Click here</a> to translate this species';
   #        SendMail.send_email(user.email, 'AEOL: New species has been assigned', message)
         end
       end
       TaxonConceptAssignLog.taxon_concept_assign_log(params[:id], params["translator"].to_i, 2, session[:user_id])
     end
   end
   
   def update_scientific_reviewer
     debugger
     if params[:side_link] == "updated_species" ||
       ( @taxon_concept.taxon_status_id < 4 &&  @taxon_concept.scientific_reviewer_id != params["scientific_reviewer"].to_i)
       @taxon_concept.scientific_reviewer_id = params["scientific_reviwer"].to_i
       if  @taxon_concept.taxon_status_id == 3 && params[:side_link] != "updated_species"
         user = User.find(params["scientific_reviwer"].to_i)
         if user.active == 1 && user.email != '' 
 #          $message = 'New species ready for revision <br><br>'.$taxon_concept->scientificName;
 #          SendMail::send_email($user[0]->email, 'AEOL: New species have been assigned for revision', 'New species have been assigned for revision<br><br>'.$taxon_concept->scientificName);
         end
       end
       TaxonConceptAssignLog.taxon_concept_assign_log(params[:id], params["scientific_reviwer"].to_i, 3, session[:user_id])
     end 
   end
   
   def update_linguistic_reviewer
     debugger
     if params[:side_link] == "updated_species" ||
        ( @taxon_concept.taxon_status_id < 5 &&  @taxon_concept.linguistic_reviewer_id != params["linguistic_reviewer"].to_i)
       @taxon_concept.linguistic_reviewer_id = params["linguistic_reviewer"].to_i
       if  @taxon_concept.taxon_status_id == 4 && params[:side_link] != "updated_species"
         user = User.find(params["linguistic_reviewer"].to_i)
         if user.active == 1 && user.email != ''
 #          $message = 'New species ready for revision <br><br>'.$taxon_concept->scientificName;
 #          SendMail::send_email($user[0]->email, 'AEOL: New species have been assigned for revision', 'New species have been assigned for revision<br><br>'.$taxon_concept->scientificName);
         end
       end
       TaxonConceptAssignLog.taxon_concept_assign_log(params[:id], params["linguistic_reviewer"].to_i, 4, session[:user_id])
     end
   end
end