$PBExportHeader$u_tabpage_patient_followups.sru
forward
global type u_tabpage_patient_followups from u_tabpage
end type
type cb_find_relation from commandbutton within u_tabpage_patient_followups
end type
type st_other_carrier from statictext within u_tabpage_patient_followups
end type
type dw_relations from u_dw_pick_list within u_tabpage_patient_followups
end type
type st_cpr_id from statictext within u_tabpage_patient_followups
end type
end forward

global type u_tabpage_patient_followups from u_tabpage
integer width = 2875
integer height = 1268
string text = "none"
cb_find_relation cb_find_relation
st_other_carrier st_other_carrier
dw_relations dw_relations
st_cpr_id st_cpr_id
end type
global u_tabpage_patient_followups u_tabpage_patient_followups

type variables

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();integer li_sts
string ls_temp

if isnull(current_patient) then
	log.log(this, "u_tabpage_patient_followups.initialize.0005", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
end if

dw_relations.settransobject(sqlca)

return 1

end function

public subroutine refresh ();//show_patient(current_patient.cpr_id)

dw_relations.object.t_background.width = dw_relations.width - 128

dw_relations.settransobject(sqlca)
dw_relations.retrieve(current_patient.cpr_id)

end subroutine

on u_tabpage_patient_followups.create
int iCurrent
call super::create
this.cb_find_relation=create cb_find_relation
this.st_other_carrier=create st_other_carrier
this.dw_relations=create dw_relations
this.st_cpr_id=create st_cpr_id
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_find_relation
this.Control[iCurrent+2]=this.st_other_carrier
this.Control[iCurrent+3]=this.dw_relations
this.Control[iCurrent+4]=this.st_cpr_id
end on

on u_tabpage_patient_followups.destroy
call super::destroy
destroy(this.cb_find_relation)
destroy(this.st_other_carrier)
destroy(this.dw_relations)
destroy(this.st_cpr_id)
end on

type cb_find_relation from commandbutton within u_tabpage_patient_followups
integer x = 2094
integer y = 468
integer width = 521
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Find Relation"
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
str_patient lstr_patient
string ls_relationship
string ls_relation_cpr_id
long ll_row

lstr_patient.last_name = current_patient.last_name
openwithparm(w_patient_select, lstr_patient)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return
if popup_return.items[1] = current_patient.cpr_id then
	openwithparm(w_pop_message, "The selected patient is the same as the current patient.")
	return
end if

ls_relation_cpr_id = popup_return.items[1]

popup.title = "Relationship of Selected Patient"
popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "Patient Relationship"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_relationship = popup_return.items[1]


ll_row = dw_relations.insertrow(0)
dw_relations.object.cpr_id[ll_row] = current_patient.cpr_id
dw_relations.object.relation_cpr_id[ll_row] = ls_relation_cpr_id
dw_relations.object.relationship[ll_row] = ls_relationship
dw_relations.object.created_by[ll_row] = current_scribe.user_id


CHOOSE CASE lower(ls_relationship)
	CASE "sibling"
		dw_relations.object.maternal_sibling_flag[ll_row] = "Y"
		dw_relations.object.paternal_sibling_flag[ll_row] = "Y"
	CASE "maternal half sibling"
		dw_relations.object.maternal_sibling_flag[ll_row] = "Y"
	CASE "paternal half sibling"
		dw_relations.object.paternal_sibling_flag[ll_row] = "Y"
	CASE "parent"
		dw_relations.object.parent_flag[ll_row] = "Y"
	CASE "guardian"
		dw_relations.object.guardian_flag[ll_row] = "Y"
END CHOOSE

li_sts = dw_relations.update()

refresh()

end event

type st_other_carrier from statictext within u_tabpage_patient_followups
integer x = 489
integer y = 68
integer width = 846
integer height = 88
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Relations"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_relations from u_dw_pick_list within u_tabpage_patient_followups
integer x = 37
integer y = 168
integer width = 1847
integer height = 968
integer taborder = 10
string dataobject = "dw_patient_relations"
boolean vscrollbar = true
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
	popup.button_icons[popup.button_count] = "button_edit.bmp"
	popup.button_helps[popup.button_count] = "Edit Relation"
	popup.button_titles[popup.button_count] = "Edit Relation"
	buttons[popup.button_count] = "EDIT"
End If

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Remove Relation"
	popup.button_titles[popup.button_count] = "Remove Relation"
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
	CASE "EDIT"
		ls_cpr_id = object.relation_cpr_id[selected_row]
		li_sts = f_get_patient(ls_cpr_id, lstr_patient)
		if li_sts <= 0 then return
		
		popup.title = "Edit Relation"
		popup.objectparm = lstr_patient
		openwithparm(w_edit_patient_data, popup)
		popup_return = message.powerobjectparm
		if popup_return.item <> "OK" then return
		
		lstr_patient = popup_return.objectparm2
		f_update_patient(lstr_patient)
	CASE "REMOVE"
		openwithparm(w_pop_yes_no, "Are you sure you wish to remove this relation?")
		popup_return = message.powerobjectparm
		if popup_return.item <> "YES" then return
		
		object.status[selected_row] = "NA"
		update()
	CASE "CANCEL"
		Return
	CASE ELSE
END CHOOSE

refresh()

Return

end event

type st_cpr_id from statictext within u_tabpage_patient_followups
integer x = 27
integer y = 24
integer width = 375
integer height = 72
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

