$PBExportHeader$w_svc_config_vaccine_schedule.srw
forward
global type w_svc_config_vaccine_schedule from w_window_base
end type
type cb_ok from commandbutton within w_svc_config_vaccine_schedule
end type
type tab_vaccine_schedule from u_tab_vaccine_schedule_config within w_svc_config_vaccine_schedule
end type
type tab_vaccine_schedule from u_tab_vaccine_schedule_config within w_svc_config_vaccine_schedule
end type
end forward

global type w_svc_config_vaccine_schedule from w_window_base
integer height = 1836
boolean controlmenu = false
windowtype windowtype = response!
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_ok cb_ok
tab_vaccine_schedule tab_vaccine_schedule
end type
global w_svc_config_vaccine_schedule w_svc_config_vaccine_schedule

type variables
u_component_service service

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();tab_vaccine_schedule.refresh()

return 1

end function

on w_svc_config_vaccine_schedule.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.tab_vaccine_schedule=create tab_vaccine_schedule
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.tab_vaccine_schedule
end on

on w_svc_config_vaccine_schedule.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.tab_vaccine_schedule)
end on

event open;call super::open;integer li_sts
string ls_config_object_id
str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

ls_config_object_id = service.get_attribute("config_object_id")
if isnull(ls_config_object_id) then
	log.log(this, "w_svc_config_vaccine_schedule:open", "No config_object_id", 4)
	closewithreturn(this, popup_return)
	return
end if	

li_sts = f_get_config_object_info(ls_config_object_id, tab_vaccine_schedule.config_object_info)
if li_sts <= 0 then
	log.log(this, "w_svc_config_vaccine_schedule:open", "Error getting config object info", 4)
	closewithreturn(this, popup_return)
	return
end if	

title = tab_vaccine_schedule.config_object_info.description
if tab_vaccine_schedule.config_object_info.installed_version > 0 then
	title += ",  Version " + string(tab_vaccine_schedule.config_object_info.installed_version)
end if

cb_ok.x = width - cb_ok.width - 100
cb_ok.y = height - cb_ok.height - 150

tab_vaccine_schedule.width = width
tab_vaccine_schedule.height = cb_ok.y - 50

tab_vaccine_schedule.initialize(service)

tab_vaccine_schedule.resize_tabs(tab_vaccine_schedule.width, tab_vaccine_schedule.height)

refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_config_vaccine_schedule
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_config_vaccine_schedule
end type

type cb_ok from commandbutton within w_svc_config_vaccine_schedule
integer x = 2432
integer y = 1576
integer width = 402
integer height = 112
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;str_popup_return popup_return
str_popup popup
integer li_sts

if tab_vaccine_schedule.rule_changes then
	popup.title = "There are rule changes that have not beed saved"
	popup.data_row_count = 2
	popup.items[1] = "Save Changes and Exit"
	popup.items[2] = "Exit WITHOUT saving changes"
	
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return
	
	if popup_return.item_indexes[1] = 2 then
		openwithparm(w_pop_yes_no, "Are you sure you wish to exit WITHOUT saveing the rule changes?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
	end if
	
	tab_vaccine_schedule.save_changes()
end if


popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type tab_vaccine_schedule from u_tab_vaccine_schedule_config within w_svc_config_vaccine_schedule
integer width = 2894
integer height = 1544
integer taborder = 20
boolean bringtotop = true
end type

