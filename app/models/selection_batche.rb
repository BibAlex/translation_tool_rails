class SelectionBatche < ActiveRecord::Base
  # attr_accessible :title, :body
  
  def self.save(params)
    criteria = "\""
    criteria += "<i>#{I18n.t(:hierarchy)}: </i>#{Hierarchy.get_name(params[:hierarchy_id])}<br>"
    criteria += "<i>#{I18n.t(:hierarchy_entry)}: </i>#{HierarchyEntry.get_name(params[:hierarchy_entry_id])}<br>"
    criteria += "<i>#{I18n.t(:have_text)} </i>"
    
    case (params[:have_text]) 
      when -1
        criteria += "#{I18n.t(:all)}"
      when 0
        criteria += "#{I18n.t(:users_tab_field_no)}"
      when 1
        criteria += "#{I18n.t(:users_tab_field_yes)}"
    end    
    criteria += "<br>"
    
    if (params[:have_text] != 0)
      criteria += "- <i>#{I18n.t(:vetted)} </i>"
      if (params[:text_vetted].include?(VETTED_UNKNOWN.to_s))
        criteria += "#{I18n.t(:unknown)} &nbsp;&nbsp;&nbsp;"
      end
      if (params[:text_vetted].include?(VETTED_UNTRUSTED.to_s))
        criteria += "#{I18n.t(:untrusted)} &nbsp;&nbsp;&nbsp;"
      end
      if (params[:text_vetted].include?(VETTED_TRUSTED.to_s))
        criteria += "#{I18n.t(:trusted)}"
      end
      
      criteria += "<br>"
      criteria += "<i>#{I18n.t(:curated)} </i>"
      
      case (params[:text_curated])
        when -1
          criteria += "#{I18n.t(:all)}"
        when 0
          criteria += "#{I18n.t(:users_tab_field_no)}"
        when 1
          criteria += "#{I18n.t(:users_tab_field_yes)}"
      end
      criteria += "<br>"
    end    
    
    criteria += "<i>#{I18n.t(:have_images)} </i>"
    case (params[:have_images])
      when -1
        criteria += "#{I18n.t(:all)}"
      when 0
        criteria += "#{I18n.t(:users_tab_field_no)}"
      when 1
        criteria += "#{I18n.t(:users_tab_field_yes)}"
    end
    criteria += "<br>"
    
    if (params[:have_images] != 0) 
      criteria += "- <i>#{I18n.t(:vetted)} </i>"
      if (params[:text_vetted].include?(VETTED_UNKNOWN.to_s))
        criteria += "#{I18n.t(:unknown)} &nbsp;&nbsp;&nbsp;"
      end
      if (params[:text_vetted].include?(VETTED_UNTRUSTED.to_s))
        criteria += "#{I18n.t(:untrusted)} &nbsp;&nbsp;&nbsp;"
      end
      if (params[:text_vetted].include?(VETTED_TRUSTED.to_s))
        criteria += "#{I18n.t(:trusted)}"
      end
      
      criteria += "<br>"
      criteria += "- <i>#{I18n.t(:curated)} </i>"
      
      case (params[:images_curated])
        when -1
          criteria += "#{I18n.t(:all)}"
        when 0
          criteria += "#{I18n.t(:users_tab_field_no)}"
        when 1
          criteria += "#{I18n.t(:users_tab_field_yes)}"
      end
      criteria += "<br>"
    end
    criteria += "<br><br>"
    criteria += "<b><u>#{I18n.t(:species)}</u></b><br>"
    
    params[:taxon_concept_array].each do |taxon_concept_id|
      taxon_concept = TaxonConcept.get_taxon_concept(taxon_concept_id.to_i)
      criteria += "#{TaxonConcept.get_name(taxon_concept.id, params[:hierarchy_id])}<br/>"
    end
    
    criteria += "\""
    selected_date = "\"#{Time.now}\""
    comment = "\"#{params[:comments]}\""
    
    connection = SelectionBatche.connection
    selection_id = connection.last_inserted_id(connection.insert("insert into selection_batches(criteria, comments, date_selected, user_id, hierarchy_id, priority_id) values (#{criteria}, #{comment} , #{selected_date}, #{params[:user_id]}, #{params[:hierarchy_id]}, #{params[:priority_id]});")) 

    total_selected_species = 0
    params[:taxon_concept_array].each do |taxon_concept_id|
      master_taxon = TaxonConcept.select_taxon_concept(MASTER, taxon_concept_id)
      if (master_taxon.id)
        if (!(TaxonConcept.exists_on_slave(master_taxon.id)))
          taxon_concept_name = "\"#{TaxonConcept.get_name(master_taxon.id, params[:hierarchy_id])}\""
          TaxonConcept.save_taxon_concept(master_taxon.id,
                                          master_taxon.supercedure_id,
                                          master_taxon.split_from,
                                          master_taxon.vetted_id,
                                          master_taxon.published,
                                          selection_id,
                                          taxon_concept_name)
          total_selected_species = total_selected_species + 1
        end
      end
    end
    
    # if (total_selected_species > 0) 
      # Notification.notify_task_distributor(id, session[:user_id].to_i, total_selected_species, criteria, comments)
    # end
  end
  
  def self.get_selected_taxons(selection_id)
    TaxonConcept.establish_connection(:adapter  => "mysql2",
                                      :host     => "localhost",
                                      :username => "root",
                                      :password => "root",
                                      :database => "#{SLAVE}_#{Rails.env}")
    TaxonConcept.find_by_sql("select * from taxon_concepts where selection_id=#{selection_id} order by scientificName")
  end
end
