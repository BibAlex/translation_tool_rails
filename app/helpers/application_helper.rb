module ApplicationHelper
 
  def send_email(to_name, to_mail, subject, message)
    Notifier.contact_message(to_name, to_mail, subject, message+"#{I18n.t(:email_signature)}").deliver 
  end
 
  def get_roles_array(roles)
    roles.split(',')
  end
  
end
