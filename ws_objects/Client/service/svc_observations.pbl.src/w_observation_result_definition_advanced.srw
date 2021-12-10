$PBExportHeader$w_observation_result_definition_advanced.srw
forward
global type w_observation_result_definition_advanced from w_window_base
end type
type st_title from statictext within w_observation_result_definition_advanced
end type
type st_result from statictext within w_observation_result_definition_advanced
end type
type st_2 from statictext within w_observation_result_definition_advanced
end type
type sle_display_mask from singlelineedit within w_observation_result_definition_advanced
end type
type cb_cancel from commandbutton within w_observation_result_definition_advanced
end type
type cb_ok from commandbutton within w_observation_result_definition_advanced
end type
type dw_range_rules from u_dw_pick_list within w_observation_result_definition_advanced
end type
type st_1 from statictext within w_observation_result_definition_advanced
end type
type cb_new_rule from commandbutton within w_observation_result_definition_advanced
end type
type cb_delete_rule from commandbutton within w_observation_result_definition_advanced
end type
type cb_new_age_range from commandbutton within w_observation_result_definition_advanced
end type
type cb_equivalence from commandbutton within w_observation_result_definition_advanced
end type
end forward

global type w_observation_result_definition_advanced from w_window_base
integer height = 1904
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
st_result st_result
st_2 st_2
sle_display_mask sle_display_mask
cb_cancel cb_cancel
cb_ok cb_ok
dw_range_rules dw_range_rules
st_1 st_1
cb_new_rule cb_new_rule
cb_delete_rule cb_delete_rule
cb_new_age_range cb_new_age_range
cb_equivalence cb_equivalence
end type
global w_observation_result_definition_advanced w_observation_result_definition_advanced

type variables
str_c_observation_result result

datawindowchild dwc_age_range
datawindowchild dwc_units

string age_range_category = "Result Ranges"

end variables

forward prototypes
public function integer save_changes ()
end prototypes

public function integer save_changes ();integer li_sts
string ls_display_mask
long i

// Reset the search sequences
dw_range_rules.sort()
for i = 1 to dw_range_rules.rowcount()
	dw_range_rules.object.search_sequence[i] = i
next

// Save the rules
li_sts = dw_range_rules.update()
if li_sts < 0 then
	openwithparm(w_pop_message, "Saving range rules failed")
	return -1
end if

if len(sle_display_mask.text) > 0 then
	ls_display_mask = sle_display_mask.text
else
	setnull(ls_display_mask)
end if

UPDATE c_Observation_Result
SET display_mask = :ls_display_mask
WHERE observation_id = :result.observation_id
AND result_sequence = :result.result_sequence;
if not tf_check() then return -1

return 1

end function

on w_observation_result_definition_advanced.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_result=create st_result
this.st_2=create st_2
this.sle_display_mask=create sle_display_mask
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.dw_range_rules=create dw_range_rules
this.st_1=create st_1
this.cb_new_rule=create cb_new_rule
this.cb_delete_rule=create cb_delete_rule
this.cb_new_age_range=create cb_new_age_range
this.cb_equivalence=create cb_equivalence
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_result
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_display_mask
this.Control[iCurrent+5]=this.cb_cancel
this.Control[iCurrent+6]=this.cb_ok
this.Control[iCurrent+7]=this.dw_range_rules
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_new_rule
this.Control[iCurrent+10]=this.cb_delete_rule
this.Control[iCurrent+11]=this.cb_new_age_range
this.Control[iCurrent+12]=this.cb_equivalence
end on

on w_observation_result_definition_advanced.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_result)
destroy(this.st_2)
destroy(this.sle_display_mask)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.dw_range_rules)
destroy(this.st_1)
destroy(this.cb_new_rule)
destroy(this.cb_delete_rule)
destroy(this.cb_new_age_range)
destroy(this.cb_equivalence)
end on

event open;call super::open;long ll_count

result = message.powerobjectparm

if isnull(result.observation_id) or isnull(result.result_sequence) then
	close(this)
	return
end if

	

st_result.text = result.observation_description + " - " + result.result

sle_display_mask.text = result.display_mask

dw_range_rules.GetChild("age_range_id", dwc_age_range)
dw_range_rules.GetChild("unit_id", dwc_units)

dwc_age_range.settransobject(sqlca)
ll_count = dwc_age_range.retrieve(age_range_category)
if ll_count = 0 then
	// insert a dummy row to prevent the auto-retrieve of the child datawindow
	dwc_age_range.insertrow(0)
end if

dwc_units.settransobject(sqlca)
ll_count = dwc_units.retrieve(result.result_unit)
if ll_count = 0 then
	// insert a dummy row to prevent the auto-retrieve of the child datawindow
	dwc_units.insertrow(0)
end if

dw_range_rules.settransobject(sqlca)
dw_range_rules.retrieve(result.observation_id, result.result_sequence)



end event

type pb_epro_help from w_window_base`pb_epro_help within w_observation_result_definition_advanced
integer x = 2830
integer y = 64
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_observation_result_definition_advanced
end type

type st_title from statictext within w_observation_result_definition_advanced
integer width = 2921
integer height = 144
boolean bringtotop = true
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Result Advanced Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_result from statictext within w_observation_result_definition_advanced
integer x = 160
integer y = 204
integer width = 2597
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_2 from statictext within w_observation_result_definition_advanced
integer x = 251
integer y = 376
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Display Mask:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_display_mask from singlelineedit within w_observation_result_definition_advanced
integer x = 709
integer y = 360
integer width = 745
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_observation_result_definition_advanced
integer x = 73
integer y = 1656
integer width = 402
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)


end event

type cb_ok from commandbutton within w_observation_result_definition_advanced
integer x = 2418
integer y = 1656
integer width = 402
integer height = 112
integer taborder = 20
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

event clicked;integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

close(parent)


end event

type dw_range_rules from u_dw_pick_list within w_observation_result_definition_advanced
event dddw_dropped_down pbm_dwndropdown
integer x = 18
integer y = 624
integer width = 2880
integer height = 884
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_observation_result_range_edit"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type st_1 from statictext within w_observation_result_definition_advanced
integer x = 777
integer y = 532
integer width = 1362
integer height = 80
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 7191717
string text = "Normal / Abnormal Range Rules"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_rule from commandbutton within w_observation_result_definition_advanced
integer x = 850
integer y = 1528
integer width = 485
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Rule"
end type

event clicked;long ll_row

ll_row = dw_range_rules.insertrow(0)
dw_range_rules.scrolltorow(ll_row)

dw_range_rules.object.observation_id[ll_row] = result.observation_id
dw_range_rules.object.result_sequence[ll_row] = result.result_sequence
dw_range_rules.object.unit_id[ll_row] = result.result_unit
dw_range_rules.object.search_sequence[ll_row] = ll_row


end event

type cb_delete_rule from commandbutton within w_observation_result_definition_advanced
integer x = 1609
integer y = 1528
integer width = 485
integer height = 96
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Delete Rule"
end type

event clicked;long ll_row
str_popup_return popup_return

ll_row = dw_range_rules.getrow()
if ll_row > 0 then
	openwithparm(w_pop_yes_no, "Are you sure you want to delete the selected range rule?")
	popup_return = message.powerobjectparm
	if popup_return.item = "YES" then
		dw_range_rules.deleterow(ll_row)
	end if
end if


end event

type cb_new_age_range from commandbutton within w_observation_result_definition_advanced
integer x = 2354
integer y = 528
integer width = 457
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Age Range"
end type

event clicked;str_popup	popup

popup.data_row_count = 3
popup.items[1] = age_range_category
setnull(popup.items[2])
popup.items[3] = "Y"
Openwithparm(w_new_age_range,popup)

end event

type cb_equivalence from commandbutton within w_observation_result_definition_advanced
integer x = 1659
integer y = 360
integer width = 603
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Equivalence"
end type

event clicked;str_content_object lstr_item
w_object_equivalence lw_window

lstr_item.object_id = result.id
lstr_item.object_type = "Result"
lstr_item.object_key = result.observation_id + "|" + string(result.result_sequence)
lstr_item.description = st_result.text
lstr_item.owner_id = -1

openwithparm(lw_window, lstr_item, "w_object_equivalence")

end event

