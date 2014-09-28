module PhasesHelper
  
  def get_phase_action(process)
    phase = Status.first
    if (phase.label == "Distribution" && process.to_i == 2)
      I18n.t(:phase_translate)
    elsif (phase.label != "Distribution" && process.to_i == 1)
      I18n.t(:phase_translate)
    else
      I18n.t(:phase_review)
    end
  end
  
  def is_translate?(process)
    phase = Status.first
    if (phase.label == "Distribution" && process.to_i == 2)
      true
    elsif (phase.label != "Distribution" && process.to_i == 1)
      true
    else
      false
    end
  end
  
  def get_specises_status_and_action(taxon, process)
    status = "<img src='/images/pending.png' title='pending species'/>"
    action = get_phase_action(process)
    if(taxon.taxon_status_id > process.to_i)
      status = "<img src='/images/finished.png' title='finished species'/>"
      action = "#{I18n.t(:phase_view)}"
    end
    [status, action]
  end
  
  def get_phase_title(trstatus)
    if trstatus == COMPLETED
      I18n.t(:phase_completed_species)
    elsif trstatus == PENDING
      I18n.t(:phase_pending_species)
    else
      I18n.t(:phase_unassigned_species)
    end
  end
  
end

