$PBExportHeader$w_svc_treatment_list.srw
forward
global type w_svc_treatment_list from w_window_base
end type
type cb_cancel from commandbutton within w_svc_treatment_list
end type
type cb_done from commandbutton within w_svc_treatment_list
end type
type cb_be_back from commandbutton within w_svc_treatment_list
end type
type st_assessment from statictext within w_svc_treatment_list
end type
type tab_new_treatments from u_tab_new_treatment within w_svc_treatment_list
end type
type tab_new_treatments from u_tab_new_treatment within w_svc_treatment_list
end type
end forward

global type w_svc_treatment_list from w_window_base
boolean controlmenu = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 2
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
cb_cancel cb_cancel
cb_done cb_done
cb_be_back cb_be_back
st_assessment st_assessment
tab_new_treatments tab_new_treatments
end type
global w_svc_treatment_list w_svc_treatment_list

type variables
String 		common_list_id,list_user_id
Integer 		update_flag
Boolean 		personal_list
String 		mode
date 			assessment_begin_date
date			assessment_end_date
Datastore	dw_child_treatments

u_ds_data treatment_attributes
u_ds_data efficacy
u_ds_data formulary

u_component_service service
str_assessment_description assessment

// arrary of treatment attributes
str_item_definition         treatment_attr[]

string single_treatment_list_id
string composite_treatment_list_id


end variables

event open;call super::open;////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Description:Loads the users/default treatments list 
//
// Created By:Mark																		Creation dt: 
//
// Modified By:Sumathi Chinnasamy													Modified On: 04/26/2000
////////////////////////////////////////////////////////////////////////////////////////////////////

String					ls_null, ls_in_office_flag, ls_temp
Boolean					lb_in_office
Long						i, ll_rows
// user defined
str_popup				popup
str_popup_return	popup_return
integer li_sts
long ll_menu_id

Setnull(ls_null)
popup_return.item_count = 0

service = message.powerobjectparm

title = current_patient.id_line()

if isnull(service.problem_id) then
	log.log(this, "w_svc_treatment_list.open.0027", "Null problem_id", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = current_patient.assessments.assessment(assessment, service.problem_id)
if li_sts <= 0 then
	log.log(this, "w_svc_treatment_list.open.0027", "Error getting assessment object (" + string(service.problem_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

st_assessment.text = f_assessment_description(assessment)

st_assessment.width = width
cb_done.x = width - cb_done.width - 30
cb_done.y = button_top
cb_cancel.x = cb_done.x - cb_cancel.width - 30
cb_cancel.y = cb_done.y
cb_be_back.x = cb_cancel.x - cb_be_back.width - 30
cb_be_back.y = cb_done.y
pb_epro_help.x = width - pb_epro_help.width - 20

tab_new_treatments.width = width
tab_new_treatments.height = height - 360


// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 3
end if

f_attribute_add_attribute(state_attributes, "problem_id", string(service.problem_id))

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


tab_new_treatments.initialize(service)


end event

on w_svc_treatment_list.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_assessment=create st_assessment
this.tab_new_treatments=create tab_new_treatments
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.cb_be_back
this.Control[iCurrent+4]=this.st_assessment
this.Control[iCurrent+5]=this.tab_new_treatments
end on

on w_svc_treatment_list.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_assessment)
destroy(this.tab_new_treatments)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_svc_treatment_list
integer x = 2871
integer y = 0
integer width = 206
boolean originalsize = false
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_treatment_list
end type

type cb_cancel from commandbutton within w_svc_treatment_list
integer x = 1961
integer y = 1604
integer width = 443
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"
closewithreturn(parent, popup_return)


end event

type cb_done from commandbutton within w_svc_treatment_list
integer x = 2427
integer y = 1604
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

event clicked;integer li_sts
str_popup_return popup_return
integer li_idx

cb_done.enabled = false
cb_be_back.enabled = false
cb_cancel.enabled = false

li_idx = f_please_wait_open()

li_sts = tab_new_treatments.order_selected_treatments()
if li_sts < 0 then
	cb_done.enabled = true
	cb_be_back.enabled = true
	cb_cancel.enabled = true
	f_please_wait_close(li_idx)
	return
end if

f_please_wait_close(li_idx)

popup_return.item_count = 1
popup_return.items[1] = "OK"
Closewithreturn(parent, popup_return)


end event

type cb_be_back from commandbutton within w_svc_treatment_list
integer x = 1495
integer y = 1604
integer width = 443
integer height = 108
integer taborder = 50
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

type st_assessment from statictext within w_svc_treatment_list
integer width = 2898
integer height = 96
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_new_treatments from u_tab_new_treatment within w_svc_treatment_list
integer y = 100
integer width = 2889
integer height = 1472
integer taborder = 20
end type

