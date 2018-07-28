$PBExportHeader$w_patient_data.srw
forward
global type w_patient_data from w_window_base
end type
type cb_be_back from commandbutton within w_patient_data
end type
type cb_finished from commandbutton within w_patient_data
end type
type tab_patient_data from u_tab_patient_data within w_patient_data
end type
type tab_patient_data from u_tab_patient_data within w_patient_data
end type
end forward

global type w_patient_data from w_window_base
string title = "Patient Information"
boolean controlmenu = false
windowtype windowtype = response!
cb_be_back cb_be_back
cb_finished cb_finished
tab_patient_data tab_patient_data
end type
global w_patient_data w_patient_data

type variables
u_component_service service
end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();tab_patient_data.refresh()

st_config_mode_menu.height = 48
st_config_mode_menu.y = button_top - 48
//st_config_mode_menu.text = ""

st_config_mode_menu.visible = config_mode

return 1

end function

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_menu_id
string ls_null

setnull(ls_null)

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

if isnull(current_patient) then
	log.log(this, "open", "No current patient", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 8
end if

ll_menu_id = f_get_context_menu("Chart", ls_null)
if isnull(ll_menu_id) then
	ll_menu_id = long(service.get_attribute("menu_id"))
end if
paint_menu(ll_menu_id)

tab_patient_data.resize_tabs(width - 30, button_top - 40)

postevent("post_open")


end event

on w_patient_data.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_finished=create cb_finished
this.tab_patient_data=create tab_patient_data
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_finished
this.Control[iCurrent+3]=this.tab_patient_data
end on

on w_patient_data.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_finished)
destroy(this.tab_patient_data)
end on

event post_open;call super::post_open;long ll_display_script_id
u_tabpage_patient_rtf luo_rtf
string ls_title
string ls_script_attribute
string ls_title_attribute
string ls_suffix
integer i

// See if we need to open an RTF page
i = 0
ls_script_attribute = "rtf_display_script_id"
ls_title_attribute = "rtf_display_script_title"
ls_suffix = ""
DO WHILE true
	if i > 0 then ls_suffix = "_" + string(i)
	
	service.get_attribute(ls_script_attribute + ls_suffix, ll_display_script_id)
	if isnull(ll_display_script_id) then exit

	ls_title = service.get_attribute(ls_title_attribute + ls_suffix)
	if isnull(ls_title) then ls_title = "Report"
	
	luo_rtf = tab_patient_data.open_page("u_tabpage_patient_rtf", false)
	if not isnull(luo_rtf) then
		luo_rtf.display_script_id = ll_display_script_id
		luo_rtf.text = ls_title
	end if
	
	i += 1
LOOP

service.get_attribute("followup_display_script_id", ll_display_script_id)
if isnull(ll_display_script_id) then ll_display_script_id = 2759
tab_patient_data.tabpage_followups.display_script_id = ll_display_script_id

service.get_attribute("referral_display_script_id", ll_display_script_id)
if isnull(ll_display_script_id) then ll_display_script_id = 2760
tab_patient_data.tabpage_referrals.display_script_id = ll_display_script_id

tab_patient_data.initialize()

tab_patient_data.selecttab(1)

end event

event button_pressed;call super::button_pressed;tab_patient_data.refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_patient_data
boolean visible = true
integer x = 2638
integer y = 1352
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_patient_data
end type

type cb_be_back from commandbutton within w_patient_data
integer x = 1966
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_finished from commandbutton within w_patient_data
integer x = 2432
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type tab_patient_data from u_tab_patient_data within w_patient_data
integer width = 2917
integer height = 1300
long backcolor = 33538240
tabposition tabposition = tabsonbottom!
end type

