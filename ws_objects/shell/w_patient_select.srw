HA$PBExportHeader$w_patient_select.srw
forward
global type w_patient_select from w_window_base
end type
type cb_cancel from commandbutton within w_patient_select
end type
type uo_patient_select from u_patient_select within w_patient_select
end type
end forward

global type w_patient_select from w_window_base
boolean controlmenu = false
windowtype windowtype = response!
boolean nested_user_object_resize = false
cb_cancel cb_cancel
uo_patient_select uo_patient_select
end type
global w_patient_select w_patient_select

type variables

end variables

on w_patient_select.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.uo_patient_select=create uo_patient_select
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.uo_patient_select
end on

on w_patient_select.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.uo_patient_select)
end on

event open;call super::open;str_patient lstr_patient

uo_patient_select.initialize()
uo_patient_select.clear()

if isvalid(message.powerobjectparm) then
	if classname(message.powerobjectparm) = "str_patient" then
		lstr_patient = message.powerobjectparm
		uo_patient_select.set_search(lstr_patient)
	end if
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_patient_select
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_patient_select
end type

type cb_cancel from commandbutton within w_patient_select
integer x = 2432
integer y = 1548
integer width = 402
integer height = 112
integer taborder = 90
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item = "CANCEL"
popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type uo_patient_select from u_patient_select within w_patient_select
integer taborder = 10
end type

event select_patient;call super::select_patient;str_popup_return popup_return

popup_return.item = "PATIENT=" + ps_cpr_id
popup_return.items[1] = ps_cpr_id
popup_return.item_count = 1

closewithreturn(parent, popup_return)


end event

on uo_patient_select.destroy
call u_patient_select::destroy
end on

event new_patient;call super::new_patient;integer li_sts
long ll_encounter_id

setnull(ll_encounter_id)

if isnull(current_patient) then
	li_sts = service_list.do_service(cpr_id, ll_encounter_id, "PATIENT_DATA") 
end if


this.event TRIGGER select_patient(ps_cpr_id)

end event

