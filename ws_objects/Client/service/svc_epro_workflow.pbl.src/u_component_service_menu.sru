$PBExportHeader$u_component_service_menu.sru
forward
global type u_component_service_menu from u_component_service
end type
end forward

global type u_component_service_menu from u_component_service
end type
global u_component_service_menu u_component_service_menu

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();boolean lb_auto_singleton
long ll_menu_id
string ls_temp
str_attributes lstr_attributes

get_attribute("menu_id", ll_menu_id)
if isnull(ll_menu_id) then
	log.log(this, "xx_do_service()", "No menu_id", 4)
	return 2
end if

get_attribute("auto_singleton", ls_temp)
if isnull(ls_temp) then ls_temp = "True"
lb_auto_singleton = f_string_to_boolean(ls_temp)

// Transfer our current context into the menu
lstr_attributes = f_get_context_attributes()

f_display_menu_with_attributes(ll_menu_id, lb_auto_singleton, lstr_attributes)

return 1

end function

on u_component_service_menu.create
call super::create
end on

on u_component_service_menu.destroy
call super::destroy
end on

