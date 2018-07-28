$PBExportHeader$w_patient_select_multi.srw
forward
global type w_patient_select_multi from w_window_base
end type
type cb_cancel from commandbutton within w_patient_select_multi
end type
type uo_patient_select from u_patient_select within w_patient_select_multi
end type
type dw_selected_patients from u_dw_pick_list within w_patient_select_multi
end type
type st_1 from statictext within w_patient_select_multi
end type
type cb_ok from commandbutton within w_patient_select_multi
end type
end forward

global type w_patient_select_multi from w_window_base
integer width = 2962
integer height = 1936
boolean controlmenu = false
windowtype windowtype = response!
boolean nested_user_object_resize = false
cb_cancel cb_cancel
uo_patient_select uo_patient_select
dw_selected_patients dw_selected_patients
st_1 st_1
cb_ok cb_ok
end type
global w_patient_select_multi w_patient_select_multi

type variables

end variables

on w_patient_select_multi.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.uo_patient_select=create uo_patient_select
this.dw_selected_patients=create dw_selected_patients
this.st_1=create st_1
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.uo_patient_select
this.Control[iCurrent+3]=this.dw_selected_patients
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_ok
end on

on w_patient_select_multi.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.uo_patient_select)
destroy(this.dw_selected_patients)
destroy(this.st_1)
destroy(this.cb_ok)
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

dw_selected_patients.object.patient_name.width = dw_selected_patients.width - 100
end event

type pb_epro_help from w_window_base`pb_epro_help within w_patient_select_multi
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_patient_select_multi
end type

type cb_cancel from commandbutton within w_patient_select_multi
integer x = 1911
integer y = 1688
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

type uo_patient_select from u_patient_select within w_patient_select_multi
integer width = 1865
integer height = 1832
integer taborder = 10
end type

event select_patient;call super::select_patient;string ls_patient_name
long ll_row

ls_patient_name = sqlca.fn_patient_full_name(ps_cpr_id)
if len(ls_patient_name) > 0 then
	ll_row = dw_selected_patients.insertrow(0)
	dw_selected_patients.object.cpr_id[ll_row] = ps_cpr_id
	dw_selected_patients.object.patient_name[ll_row] = ls_patient_name
end if


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

type dw_selected_patients from u_dw_pick_list within w_patient_select_multi
integer x = 1920
integer y = 244
integer width = 928
integer height = 1392
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_selected_patients"
end type

event selected;call super::selected;string ls_cpr_id
integer li_sts
w_pop_buttons lw_pop_buttons
string buttons[]
integer button_pressed
str_popup popup
str_popup_return popup_return
string ls_message
string ls_find
long ll_row
str_patient lstr_patient


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Patient From Selected List"
	popup.button_titles[popup.button_count] = "Remove Patient"
	buttons[popup.button_count] = "REMOVE"
End If

If True Then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
End If

popup.button_titles_used = True

If popup.button_count > 1 Then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	If button_pressed < 1 Or button_pressed > popup.button_count Then Return
ElseIf popup.button_count = 1 Then
	button_pressed = 1
Else
	Return
End If

CHOOSE CASE buttons[button_pressed]
	CASE "REMOVE"
		deleterow(selected_row)
	CASE "CANCEL"
	CASE ELSE
END CHOOSE

clear_selected()

Return

end event

type st_1 from statictext within w_patient_select_multi
integer x = 2025
integer y = 152
integer width = 713
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 25601220
string text = "Selected Patients"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_patient_select_multi
integer x = 2464
integer y = 1688
integer width = 402
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;str_popup_return popup_return
long i

popup_return.item_count = dw_selected_patients.rowcount()
if popup_return.item_count <= 0 then
	openwithparm(w_pop_message, "No patients selected")
	return
end if

for i = 1 to popup_return.item_count
	popup_return.items[i] = dw_selected_patients.object.cpr_id[i]
next

closewithreturn(parent, popup_return)


end event

