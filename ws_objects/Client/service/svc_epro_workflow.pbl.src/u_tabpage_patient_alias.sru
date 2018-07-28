$PBExportHeader$u_tabpage_patient_alias.sru
forward
global type u_tabpage_patient_alias from u_tabpage
end type
type cb_find_relation from commandbutton within u_tabpage_patient_alias
end type
type st_other_carrier from statictext within u_tabpage_patient_alias
end type
type dw_alias from u_dw_pick_list within u_tabpage_patient_alias
end type
type st_cpr_id from statictext within u_tabpage_patient_alias
end type
end forward

global type u_tabpage_patient_alias from u_tabpage
integer width = 2875
integer height = 1268
string text = "none"
cb_find_relation cb_find_relation
st_other_carrier st_other_carrier
dw_alias dw_alias
st_cpr_id st_cpr_id
end type
global u_tabpage_patient_alias u_tabpage_patient_alias

type variables

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();integer li_sts
string ls_temp

if isnull(current_patient) then
	log.log(this, "initialize()", "No current patient", 4)
	return -1
else
	st_cpr_id.text = current_patient.cpr_id
end if

dw_alias.settransobject(sqlca)

return 1

end function

public subroutine refresh ();//show_patient(current_patient.cpr_id)

dw_alias.object.t_background.width = dw_alias.width - 128

dw_alias.settransobject(sqlca)
dw_alias.retrieve(current_patient.cpr_id)

end subroutine

on u_tabpage_patient_alias.create
int iCurrent
call super::create
this.cb_find_relation=create cb_find_relation
this.st_other_carrier=create st_other_carrier
this.dw_alias=create dw_alias
this.st_cpr_id=create st_cpr_id
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_find_relation
this.Control[iCurrent+2]=this.st_other_carrier
this.Control[iCurrent+3]=this.dw_alias
this.Control[iCurrent+4]=this.st_cpr_id
end on

on u_tabpage_patient_alias.destroy
call super::destroy
destroy(this.cb_find_relation)
destroy(this.st_other_carrier)
destroy(this.dw_alias)
destroy(this.st_cpr_id)
end on

type cb_find_relation from commandbutton within u_tabpage_patient_alias
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
string text = "Add New Alias"
end type

event clicked;integer li_sts
str_popup popup
str_popup_return popup_return
str_patient_alias lstr_alias
long ll_count

// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
// displaycolumn		Max characters allowed

popup.title = "Enter or Select Alias Type"
popup.argument_count = 1
popup.argument[1] = "Patient Alias"
popup.multiselect = false
popup.displaycolumn = 12
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

lstr_alias.alias_type = popup_return.items[1]
lstr_alias.cpr_id = current_patient.cpr_id

SELECT count(*)
INTO :ll_count
FROM p_Patient_Alias
WHERE cpr_id = :lstr_alias.cpr_id
AND alias_type = :lstr_alias.alias_type
AND current_flag = 'Y';
if not tf_check() then return

if ll_count > 0 then
	openwithparm(w_pop_message, "The selected alias type already exists for this patient.  Either edit the existing alias or select a different alias type for the new alias.")
	return
end if

openwithparm(w_patient_alias_edit, lstr_alias)

refresh()

end event

type st_other_carrier from statictext within u_tabpage_patient_alias
integer x = 521
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
string text = "Patient Alias"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_alias from u_dw_pick_list within u_tabpage_patient_alias
integer x = 37
integer y = 168
integer width = 1847
integer height = 968
integer taborder = 10
string dataobject = "dw_patient_alias"
boolean vscrollbar = true
end type

event selected;call super::selected;str_patient_alias lstr_alias

lstr_alias.cpr_id = object.cpr_id[selected_row]
lstr_alias.alias_type = object.alias_type[selected_row]

openwithparm(w_patient_alias_edit, lstr_alias)


refresh()

end event

type st_cpr_id from statictext within u_tabpage_patient_alias
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

