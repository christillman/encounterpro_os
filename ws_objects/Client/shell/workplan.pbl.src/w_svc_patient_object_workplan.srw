$PBExportHeader$w_svc_patient_object_workplan.srw
forward
global type w_svc_patient_object_workplan from w_window_base
end type
type cb_finished from commandbutton within w_svc_patient_object_workplan
end type
type cb_be_back from commandbutton within w_svc_patient_object_workplan
end type
type tv_workflow from u_tv_workflow within w_svc_patient_object_workplan
end type
end forward

global type w_svc_patient_object_workplan from w_window_base
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_finished cb_finished
cb_be_back cb_be_back
tv_workflow tv_workflow
end type
global w_svc_patient_object_workplan w_svc_patient_object_workplan

type variables
string workplan_type
string workplan_status

u_component_service service

end variables

on w_svc_patient_object_workplan.create
int iCurrent
call super::create
this.cb_finished=create cb_finished
this.cb_be_back=create cb_be_back
this.tv_workflow=create tv_workflow
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_finished
this.Control[iCurrent+2]=this.cb_be_back
this.Control[iCurrent+3]=this.tv_workflow
end on

on w_svc_patient_object_workplan.destroy
call super::destroy
destroy(this.cb_finished)
destroy(this.cb_be_back)
destroy(this.tv_workflow)
end on

event open;call super::open;
service = message.powerobjectparm

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if


tv_workflow.display_workflow(service.context_object, service.cpr_id, service.object_key)

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_patient_object_workplan
boolean visible = true
integer x = 2674
integer y = 16
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_patient_object_workplan
end type

type cb_finished from commandbutton within w_svc_patient_object_workplan
integer x = 2427
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 30
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

popup_return.item_count = 1
popup_return.items[1] = "CLOSE"

closewithreturn(parent, popup_return)
end event

type cb_be_back from commandbutton within w_svc_patient_object_workplan
integer x = 1961
integer y = 1612
integer width = 443
integer height = 108
integer taborder = 40
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

type tv_workflow from u_tv_workflow within w_svc_patient_object_workplan
integer x = 14
integer y = 12
integer width = 1856
integer height = 1576
integer taborder = 20
boolean bringtotop = true
end type

