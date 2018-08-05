$PBExportHeader$u_component_service_execute_sql.sru
forward
global type u_component_service_execute_sql from u_component_service
end type
end forward

global type u_component_service_execute_sql from u_component_service
end type
global u_component_service_execute_sql u_component_service_execute_sql

forward prototypes
public function integer xx_do_service ()
end prototypes

public function integer xx_do_service ();string ls_sql
string ls_are_you_sure_prompt
string ls_success_message
string ls_failure_message
str_popup_return popup_return

get_attribute("sql", ls_sql)
if isnull(ls_sql) then
	log.log(this, "u_component_service_execute_sql.xx_do_service:0009", "No sql attribute", 4)
	return 2
end if


// First substitute the context
ls_sql = f_string_substitute_attributes(ls_sql, f_get_context_attributes())

// Then substitute in any other attributes found
ls_sql = f_string_substitute_attributes(ls_sql, get_attributes())

get_attribute("are_you_sure_prompt", ls_are_you_sure_prompt)
get_attribute("success_message", ls_success_message)
get_attribute("failure_message", ls_failure_message)
if isnull(ls_failure_message) then ls_failure_message = "Operation"

if len(ls_are_you_sure_prompt) > 0 and cpr_mode <> "SERVER" then
	openwithparm(w_pop_yes_no, ls_are_you_sure_prompt)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 2
end if

EXECUTE IMMEDIATE :ls_sql;
if not tf_check() then
	openwithparm(w_pop_message, ls_failure_message)
	return 2
end if

if len(ls_success_message) > 0 then
	openwithparm(w_pop_message, ls_success_message)
end if

return 1

end function

on u_component_service_execute_sql.create
call super::create
end on

on u_component_service_execute_sql.destroy
call super::destroy
end on

