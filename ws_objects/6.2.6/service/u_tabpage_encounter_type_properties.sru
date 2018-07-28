HA$PBExportHeader$u_tabpage_encounter_type_properties.sru
forward
global type u_tabpage_encounter_type_properties from u_tabpage
end type
type st_close_encounter_workplan from statictext within u_tabpage_encounter_type_properties
end type
type st_close_workplan_title from statictext within u_tabpage_encounter_type_properties
end type
type st_em_code_group from statictext within u_tabpage_encounter_type_properties
end type
type st_em_code_group_title from statictext within u_tabpage_encounter_type_properties
end type
type st_bill_flag_title from statictext within u_tabpage_encounter_type_properties
end type
type st_bill_flag from statictext within u_tabpage_encounter_type_properties
end type
type st_mode_title from statictext within u_tabpage_encounter_type_properties
end type
type st_encounter_mode from statictext within u_tabpage_encounter_type_properties
end type
type cb_change_description from commandbutton within u_tabpage_encounter_type_properties
end type
type st_1 from statictext within u_tabpage_encounter_type_properties
end type
type sle_description from singlelineedit within u_tabpage_encounter_type_properties
end type
end forward

global type u_tabpage_encounter_type_properties from u_tabpage
integer width = 2971
string text = "Properties"
st_close_encounter_workplan st_close_encounter_workplan
st_close_workplan_title st_close_workplan_title
st_em_code_group st_em_code_group
st_em_code_group_title st_em_code_group_title
st_bill_flag_title st_bill_flag_title
st_bill_flag st_bill_flag
st_mode_title st_mode_title
st_encounter_mode st_encounter_mode
cb_change_description cb_change_description
st_1 st_1
sle_description sle_description
end type
global u_tabpage_encounter_type_properties u_tabpage_encounter_type_properties

type variables
string encounter_type

string bill_flag
string visit_code_group
long close_encounter_workplan_id

end variables
forward prototypes
public subroutine refresh ()
public function integer initialize (string ps_key)
end prototypes

public subroutine refresh ();long ll_count
long i
string ls_room_name
string ls_room_id
string ls_default_indirect_flag

SELECT bill_flag,
		description,
		default_indirect_flag,
		visit_code_group,
		close_encounter_workplan_id
INTO :bill_flag,
		:sle_description.text,
		:ls_default_indirect_flag, 
		:visit_code_group,
		:close_encounter_workplan_id
FROM c_Encounter_Type
WHERE encounter_type = :encounter_type;
if not tf_check() then return
if sqlca.sqlcode = 100 then
	log.log(this, "load_workplan()", "encounter_type not found (" + encounter_type + ")", 4)
	return
end if

if bill_flag = "Y" then
	st_bill_flag.text = "Yes"
else
	st_bill_flag.text = "No"
end if

if ls_default_indirect_flag = "D" then
	st_encounter_mode.text = "Direct"
elseif ls_default_indirect_flag = "I" then
	st_encounter_mode.text = "Indrect"
else
	st_encounter_mode.text = "Other"
end if

if isnull(visit_code_group) then
	st_em_code_group.text = "N/A"
else
	SELECT description
	INTO :st_em_code_group.text
	FROM em_visit_code_group
	WHERE visit_code_group = :visit_code_group;
	if not tf_check() then return
end if

if isnull(close_encounter_workplan_id) then
	st_close_encounter_workplan.text = "N/A"
else
	SELECT description
	INTO :st_close_encounter_workplan.text
	FROM c_Workplan
	WHERE workplan_id = :close_encounter_workplan_id;
	if not tf_check() then return
	if sqlca.sqlcode = 100 then
		st_close_encounter_workplan.text = "<Unknown " + string(close_encounter_workplan_id) + ">"
	end if
end if

return

end subroutine

public function integer initialize (string ps_key);encounter_type = ps_key

return 1

end function

on u_tabpage_encounter_type_properties.create
int iCurrent
call super::create
this.st_close_encounter_workplan=create st_close_encounter_workplan
this.st_close_workplan_title=create st_close_workplan_title
this.st_em_code_group=create st_em_code_group
this.st_em_code_group_title=create st_em_code_group_title
this.st_bill_flag_title=create st_bill_flag_title
this.st_bill_flag=create st_bill_flag
this.st_mode_title=create st_mode_title
this.st_encounter_mode=create st_encounter_mode
this.cb_change_description=create cb_change_description
this.st_1=create st_1
this.sle_description=create sle_description
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_close_encounter_workplan
this.Control[iCurrent+2]=this.st_close_workplan_title
this.Control[iCurrent+3]=this.st_em_code_group
this.Control[iCurrent+4]=this.st_em_code_group_title
this.Control[iCurrent+5]=this.st_bill_flag_title
this.Control[iCurrent+6]=this.st_bill_flag
this.Control[iCurrent+7]=this.st_mode_title
this.Control[iCurrent+8]=this.st_encounter_mode
this.Control[iCurrent+9]=this.cb_change_description
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.sle_description
end on

on u_tabpage_encounter_type_properties.destroy
call super::destroy
destroy(this.st_close_encounter_workplan)
destroy(this.st_close_workplan_title)
destroy(this.st_em_code_group)
destroy(this.st_em_code_group_title)
destroy(this.st_bill_flag_title)
destroy(this.st_bill_flag)
destroy(this.st_mode_title)
destroy(this.st_encounter_mode)
destroy(this.cb_change_description)
destroy(this.st_1)
destroy(this.sle_description)
end on

type st_close_encounter_workplan from statictext within u_tabpage_encounter_type_properties
integer x = 969
integer y = 776
integer width = 919
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_office_workplan_of_type_pick"
popup.title = "Select Workplan"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.add_blank_row = true
popup.blank_text = "N/A"
popup.argument_count = 2
popup.argument[1] = "Patient"
popup.argument[2] = "N"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(close_encounter_workplan_id)
else
	close_encounter_workplan_id = long(popup_return.items[1])
end if

text = popup_return.descriptions[1]


end event

type st_close_workplan_title from statictext within u_tabpage_encounter_type_properties
integer x = 453
integer y = 792
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Close Workplan:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_em_code_group from statictext within u_tabpage_encounter_type_properties
integer x = 969
integer y = 636
integer width = 919
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_em_visit_code_group"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(visit_code_group)
	text = "N/A"
else
	visit_code_group = popup_return.items[1]
	text = popup_return.descriptions[1]
end if


end event

type st_em_code_group_title from statictext within u_tabpage_encounter_type_properties
integer x = 453
integer y = 652
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "EM Code Group:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_flag_title from statictext within u_tabpage_encounter_type_properties
integer x = 453
integer y = 512
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Bill Encounter:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_bill_flag from statictext within u_tabpage_encounter_type_properties
integer x = 969
integer y = 496
integer width = 402
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if bill_flag = "Y" then
	bill_flag = "N"
	text = "No"
else
	bill_flag = "Y"
	text = "Yes"
end if


end event

type st_mode_title from statictext within u_tabpage_encounter_type_properties
integer x = 453
integer y = 372
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Encounter Mode:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_mode from statictext within u_tabpage_encounter_type_properties
event clicked pbm_bnclicked
integer x = 969
integer y = 356
integer width = 402
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_change_description from commandbutton within u_tabpage_encounter_type_properties
integer x = 2446
integer y = 136
integer width = 256
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Change"
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Enter new Encounter Type description"
popup.item = sle_description.text

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

sle_description.text = popup_return.items[1]

end event

type st_1 from statictext within u_tabpage_encounter_type_properties
integer x = 50
integer y = 48
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
boolean focusrectangle = false
end type

type sle_description from singlelineedit within u_tabpage_encounter_type_properties
integer x = 50
integer y = 132
integer width = 2368
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
end type

