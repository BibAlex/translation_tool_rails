module ApplicationHelper
  
  # def  load_hierarchy_list(auto_submit, onchange_function, selected_index)
     # hierarchy_select = ""
     # hierarchies = Hierarchy.load_all
#      
     # if auto_submit
      # on_change_option = 'document.frm.submit();'
     # elsif onchange_function
       # on_change_option = ".$onchange_function.'(this.value)"
     # else
       # on_change_option = ""
     # end
     # hierarchy_select += "<select name='lstHierarchy', onchange = #{on_change_option}, style='width: 100%'>"
     # hierarchy_select += "<option value='0'></option>"
#      
     # hierarchies.each do |hierarchy|
       # hierarchy_entry_option = "<option value= #{hierarchy.id}"
       # hierarchy_entry_option += ", selected = true>"  if selected_index == hierarchy.id
       # hierarchy_entry_option += ">"
       # hierarchy_entry_option += "#{hierarchy.label}"
       # hierarchy_entry_option += "</option>"
       # hierarchy_select += hierarchy_entry_option
     # end
     # hierarchy_select
  # end
end
