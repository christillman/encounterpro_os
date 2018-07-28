$PBExportHeader$w_svc_assessment_review.srw
forward
global type w_svc_assessment_review from w_window_base
end type
type cb_done from commandbutton within w_svc_assessment_review
end type
type cb_be_back from commandbutton within w_svc_assessment_review
end type
type tab_assessment from u_tab_assessment_review within w_svc_assessment_review
end type
type tab_assessment from u_tab_assessment_review within w_svc_assessment_review
end type
end forward

global type w_svc_assessment_review from w_window_base
integer width = 2935
integer height = 1912
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean nested_user_object_resize = false
cb_done cb_done
cb_be_back cb_be_back
tab_assessment tab_assessment
end type
global w_svc_assessment_review w_svc_assessment_review

type variables
u_component_service service

end variables

forward prototypes
public subroutine refresh_tab ()
public subroutine refresh_tab (integer pi_tab)
end prototypes

public subroutine refresh_tab ();//if tab_properties.selectedtab > 0 then refresh_tab(tab_properties.selectedtab)

end subroutine

public subroutine refresh_tab (integer pi_tab);//long ll_count
//
//if isnull(pi_tab) or pi_tab <= 0 then return
//
//
//CHOOSE CASE tab_properties.control[pi_tab].tag
////	CASE "OVERVIEW"
////		tab_properties.tabpage_overview.assessment_overview()
////	CASE "ATTACHMENT"
////		tab_properties.tabpage_attachments.display_attachments()
//	CASE "BILLING"
//	CASE "PROPERTIES"
//		tab_properties.tabpage_properties.display_properties()
//END CHOOSE
//
//
//// Always update the attachments tab
//ll_count = tab_properties.tabpage_attachments.display_attachments()
//
//return
//
//
end subroutine

on w_svc_assessment_review.create
int iCurrent
call super::create
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.tab_assessment=create tab_assessment
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_done
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.tab_assessment
end on

on w_svc_assessment_review.destroy
call super::destroy
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.tab_assessment)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
long ll_menu_id
string ls_progress_key_required_flag
string ls_progress_key_enumerated_flag
string ls_progress_type
integer li_count
string ls_assessment_type
string lsa_tabpages[]

popup_return.item_count = 0

service = message.powerobjectparm

title = current_patient.id_line()

if isnull(service.problem_id) then
	log.log(this, "open", "Null problem_id", 4)
	closewithreturn(this, popup_return)
	return
end if

ls_assessment_type = current_patient.assessments.assessment_type(service.problem_id)


// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 8
end if

ll_menu_id = f_get_context_menu("Assessment", ls_assessment_type)
if isnull(ll_menu_id) then
	ll_menu_id = long(service.get_attribute("menu_id"))
end if
paint_menu(ll_menu_id)


state_attributes.attribute_count = 1
state_attributes.attribute[1].attribute = "problem_id"
state_attributes.attribute[1].value = string(service.problem_id)

tab_assessment.resize_tabs(width - 30, button_top - 30)

tab_assessment.initialize(service)
//lsa_tabpages[1] = "u_tabpage_assessment_attachments"
//lsa_tabpages[2] = "u_context_object_properties"

//tab_assessment.open_pages(lsa_tabpages, 2)

//tab_assessment.selecttab(1)

postevent("post_open")


end event

event close;integer i

for i = 1 to button_count
	closeuserobject(pbuttons[i])
	closeuserobject(titles[i])
next

button_count = 0

end event

event button_pressed;call super::button_pressed;tab_assessment.refresh()

//refresh_tab()

end event

event post_open;call super::post_open;string lsa_tabpages[]

//lsa_tabpages[1] = "u_tabpage_assessment_overview"
//lsa_tabpages[1] = "u_tabpage_assessment_attachments"
//lsa_tabpages[2] = "u_context_object_properties"
//
//tab_assessment.open_pages(lsa_tabpages, 2)
//
//tab_assessment.selecttab(1)
//
end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_assessment_review
boolean visible = true
integer x = 2661
integer y = 1576
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_assessment_review
integer x = 14
integer y = 1484
end type

type cb_done from commandbutton within w_svc_assessment_review
integer x = 2446
integer y = 1696
integer width = 443
integer height = 108
integer taborder = 160
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

type cb_be_back from commandbutton within w_svc_assessment_review
integer x = 1979
integer y = 1696
integer width = 443
integer height = 108
integer taborder = 170
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

type tab_assessment from u_tab_assessment_review within w_svc_assessment_review
integer width = 2921
integer height = 1476
boolean bringtotop = true
end type

