$PBExportHeader$w_workplan_item_flags.srw
forward
global type w_workplan_item_flags from w_window_base
end type
type st_cancel_workplan_flag from statictext within w_workplan_item_flags
end type
type st_required_title from statictext within w_workplan_item_flags
end type
type st_auto_perform_flag from statictext within w_workplan_item_flags
end type
type pb_done from u_picture_button within w_workplan_item_flags
end type
type pb_cancel from u_picture_button within w_workplan_item_flags
end type
type st_new_flag_title from statictext within w_workplan_item_flags
end type
type st_sex_title from statictext within w_workplan_item_flags
end type
type st_stage_title from statictext within w_workplan_item_flags
end type
type st_in_office_flag from statictext within w_workplan_item_flags
end type
type st_priority from statictext within w_workplan_item_flags
end type
type st_step_flag from statictext within w_workplan_item_flags
end type
type st_modes_title from statictext within w_workplan_item_flags
end type
type st_consolidate_flag from statictext within w_workplan_item_flags
end type
type st_owner_title from statictext within w_workplan_item_flags
end type
type st_owner_flag from statictext within w_workplan_item_flags
end type
type st_consolidate_title from statictext within w_workplan_item_flags
end type
type st_title from statictext within w_workplan_item_flags
end type
type st_tag_title from statictext within w_workplan_item_flags
end type
type st_observation_tag from statictext within w_workplan_item_flags
end type
end forward

global type w_workplan_item_flags from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_cancel_workplan_flag st_cancel_workplan_flag
st_required_title st_required_title
st_auto_perform_flag st_auto_perform_flag
pb_done pb_done
pb_cancel pb_cancel
st_new_flag_title st_new_flag_title
st_sex_title st_sex_title
st_stage_title st_stage_title
st_in_office_flag st_in_office_flag
st_priority st_priority
st_step_flag st_step_flag
st_modes_title st_modes_title
st_consolidate_flag st_consolidate_flag
st_owner_title st_owner_title
st_owner_flag st_owner_flag
st_consolidate_title st_consolidate_title
st_title st_title
st_tag_title st_tag_title
st_observation_tag st_observation_tag
end type
global w_workplan_item_flags w_workplan_item_flags

type variables
string in_office_flag
integer priority
string step_flag
string auto_perform_flag
string cancel_workplan_flag
string consolidate_flag
string owner_flag
string observation_tag
string workplan_in_office_flag
string step_in_office_flag

end variables

on w_workplan_item_flags.create
int iCurrent
call super::create
this.st_cancel_workplan_flag=create st_cancel_workplan_flag
this.st_required_title=create st_required_title
this.st_auto_perform_flag=create st_auto_perform_flag
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_new_flag_title=create st_new_flag_title
this.st_sex_title=create st_sex_title
this.st_stage_title=create st_stage_title
this.st_in_office_flag=create st_in_office_flag
this.st_priority=create st_priority
this.st_step_flag=create st_step_flag
this.st_modes_title=create st_modes_title
this.st_consolidate_flag=create st_consolidate_flag
this.st_owner_title=create st_owner_title
this.st_owner_flag=create st_owner_flag
this.st_consolidate_title=create st_consolidate_title
this.st_title=create st_title
this.st_tag_title=create st_tag_title
this.st_observation_tag=create st_observation_tag
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_cancel_workplan_flag
this.Control[iCurrent+2]=this.st_required_title
this.Control[iCurrent+3]=this.st_auto_perform_flag
this.Control[iCurrent+4]=this.pb_done
this.Control[iCurrent+5]=this.pb_cancel
this.Control[iCurrent+6]=this.st_new_flag_title
this.Control[iCurrent+7]=this.st_sex_title
this.Control[iCurrent+8]=this.st_stage_title
this.Control[iCurrent+9]=this.st_in_office_flag
this.Control[iCurrent+10]=this.st_priority
this.Control[iCurrent+11]=this.st_step_flag
this.Control[iCurrent+12]=this.st_modes_title
this.Control[iCurrent+13]=this.st_consolidate_flag
this.Control[iCurrent+14]=this.st_owner_title
this.Control[iCurrent+15]=this.st_owner_flag
this.Control[iCurrent+16]=this.st_consolidate_title
this.Control[iCurrent+17]=this.st_title
this.Control[iCurrent+18]=this.st_tag_title
this.Control[iCurrent+19]=this.st_observation_tag
end on

on w_workplan_item_flags.destroy
call super::destroy
destroy(this.st_cancel_workplan_flag)
destroy(this.st_required_title)
destroy(this.st_auto_perform_flag)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_new_flag_title)
destroy(this.st_sex_title)
destroy(this.st_stage_title)
destroy(this.st_in_office_flag)
destroy(this.st_priority)
destroy(this.st_step_flag)
destroy(this.st_modes_title)
destroy(this.st_consolidate_flag)
destroy(this.st_owner_title)
destroy(this.st_owner_flag)
destroy(this.st_consolidate_title)
destroy(this.st_title)
destroy(this.st_tag_title)
destroy(this.st_observation_tag)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return

popup = message.powerobjectparm

st_title.text = popup.title

popup_return.item_count = 0

if popup.data_row_count <> 9 then
	log.log(this, "w_workplan_item_flags:open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

in_office_flag = popup.items[1]
priority = integer(popup.items[2])
step_flag = popup.items[3]
auto_perform_flag = popup.items[4]
cancel_workplan_flag = popup.items[5]
consolidate_flag = popup.items[6]
owner_flag = popup.items[7]
observation_tag = popup.items[8]
step_in_office_flag = popup.items[9]
workplan_in_office_flag = popup.item

if step_in_office_flag = "Y" or step_in_office_flag = "X" then
	if in_office_flag = "Y" then
		st_in_office_flag.text = "In Office"
	else
		in_office_flag = "N"
		st_in_office_flag.text = "Out Of Office"
	end if
elseif step_in_office_flag = "N" then
	in_office_flag = "N"
	st_in_office_flag.text = "Out Of Office"
	st_in_office_flag.enabled = false
end if

if isnull(priority) then
	st_priority.text = "NA"
else
	st_priority.text = datalist.domain_item_description( "Workplan Item Priority", string(priority))
	if isnull(st_priority.text) then
		st_priority.text = string(priority)
	end if
end if

if step_in_office_flag = in_office_flag or step_in_office_flag = "X" then
	if step_flag = "Y" then
		st_step_flag.text = "Yes"
	else
		step_flag = "N"
		st_step_flag.text = "No"
	end if
else
	step_flag = "N"
	st_step_flag.text = "No"
	st_step_flag.enabled = false
end if

if auto_perform_flag = "Y" then
	st_auto_perform_flag.text = "Yes"
else
	auto_perform_flag = "N"
	st_auto_perform_flag.text = "No"
end if

if cancel_workplan_flag = "Y" then
	st_cancel_workplan_flag.text = "Yes"
else
	cancel_workplan_flag = "N"
	st_cancel_workplan_flag.text = "No"
end if

if consolidate_flag = "Y" then
	st_consolidate_flag.text = "Yes"
else
	consolidate_flag = "N"
	st_consolidate_flag.text = "No"
end if

if owner_flag = "Y" then
	st_owner_flag.text = "Yes"
else
	owner_flag = "N"
	st_owner_flag.text = "No"
end if

if isnull(observation_tag) then
	st_observation_tag.text = "NA"
else
	st_observation_tag.text = observation_tag
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_workplan_item_flags
integer x = 2656
integer y = 164
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_workplan_item_flags
end type

type st_cancel_workplan_flag from statictext within w_workplan_item_flags
integer x = 1074
integer y = 784
integer width = 229
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if cancel_workplan_flag = "Y" then
	cancel_workplan_flag = "N"
	text = "No"
else
	cancel_workplan_flag = "Y"
	text = "Yes"
end if


end event

type st_required_title from statictext within w_workplan_item_flags
integer x = 55
integer y = 800
integer width = 997
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Required:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_auto_perform_flag from statictext within w_workplan_item_flags
integer x = 1074
integer y = 1040
integer width = 229
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if auto_perform_flag = "Y" then
	auto_perform_flag = "N"
	text = "No"
else
	auto_perform_flag = "Y"
	text = "Yes"
end if


end event

type pb_done from u_picture_button within w_workplan_item_flags
integer x = 2578
integer y = 1488
integer taborder = 10
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;long ll_row
str_popup_return popup_return

popup_return.item_count = 8

popup_return.items[1] = in_office_flag
popup_return.descriptions[1] = st_in_office_flag.text
popup_return.items[2] = string(priority)
popup_return.descriptions[2] = st_priority.text
popup_return.items[3] = step_flag
popup_return.descriptions[3] = st_step_flag.text
popup_return.items[4] = auto_perform_flag
popup_return.descriptions[4] = st_auto_perform_flag.text
popup_return.items[5] = cancel_workplan_flag
popup_return.descriptions[5] = st_cancel_workplan_flag.text
popup_return.items[6] = consolidate_flag
popup_return.descriptions[6] = st_consolidate_flag.text
popup_return.items[7] = owner_flag
popup_return.descriptions[7] = st_owner_flag.text
popup_return.items[8] = observation_tag
popup_return.descriptions[8] = st_observation_tag.text


closewithreturn(parent, popup_return)



end event

type pb_cancel from u_picture_button within w_workplan_item_flags
integer x = 64
integer y = 1484
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_new_flag_title from statictext within w_workplan_item_flags
integer x = 393
integer y = 288
integer width = 379
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Where:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_sex_title from statictext within w_workplan_item_flags
integer x = 1842
integer y = 544
integer width = 242
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Priority:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_stage_title from statictext within w_workplan_item_flags
integer x = 55
integer y = 544
integer width = 997
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Counts Towards Step Completion:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_in_office_flag from statictext within w_workplan_item_flags
integer x = 795
integer y = 272
integer width = 507
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Out Of Office"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 2
popup.items[1] = "In Office"
popup.items[2] = "Out Of Office"
if workplan_in_office_flag = "N" then
	popup.data_row_count = 3
	popup.items[3] = "<Workplan>"
end if
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]
if popup_return.item_indexes[1] = 1 then
	in_office_flag = "Y"
elseif popup_return.item_indexes[1] = 2 then
	in_office_flag = "N"
else
	in_office_flag = "W"
end if

if in_office_flag = "W" or step_in_office_flag = in_office_flag or step_in_office_flag = "X" then
	st_step_flag.enabled = true
else
	step_flag = "N"
	st_step_flag.text = "No"
	st_step_flag.enabled = false
end if

end event

type st_priority from statictext within w_workplan_item_flags
integer x = 2117
integer y = 528
integer width = 229
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "NA"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_bitmap
str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_domain_pick_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "Workplan Item Priority"
popup.add_blank_row = true
popup.blank_text = "NA"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 0 then return

text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	setnull(priority)
else
	priority = integer(popup_return.items[1])
end if


end event

type st_step_flag from statictext within w_workplan_item_flags
integer x = 1074
integer y = 528
integer width = 229
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_error

if step_in_office_flag = in_office_flag or step_in_office_flag = "X" then
	if step_flag = "Y" then
		step_flag = "N"
		text = "No"
	else
		step_flag = "Y"
		text = "Yes"
	end if
elseif step_in_office_flag = "Y" then
	ls_error = "An Out-Of-Office workplan item may not count towards step completion"
	ls_error += " in an In-Office workplan."
	openwithparm(w_pop_message, ls_error)
end if



end event

type st_modes_title from statictext within w_workplan_item_flags
integer x = 370
integer y = 1056
integer width = 681
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Perform Immediately:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_consolidate_flag from statictext within w_workplan_item_flags
integer x = 1074
integer y = 1296
integer width = 229
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if consolidate_flag = "Y" then
	consolidate_flag = "N"
	text = "No"
else
	consolidate_flag = "Y"
	text = "Yes"
end if


end event

type st_owner_title from statictext within w_workplan_item_flags
integer x = 1362
integer y = 288
integer width = 722
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Must Own Workplan:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_owner_flag from statictext within w_workplan_item_flags
integer x = 2117
integer y = 272
integer width = 229
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if owner_flag = "Y" then
	owner_flag = "N"
	text = "No"
else
	owner_flag = "Y"
	text = "Yes"
end if


end event

type st_consolidate_title from statictext within w_workplan_item_flags
integer x = 370
integer y = 1312
integer width = 681
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Consolidate:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_workplan_item_flags
integer width = 2921
integer height = 132
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_tag_title from statictext within w_workplan_item_flags
integer x = 1390
integer y = 800
integer width = 695
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Observation Tag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation_tag from statictext within w_workplan_item_flags
integer x = 2117
integer y = 784
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "OBSERVATION_TAG"
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(observation_tag)
else
	observation_tag = popup_return.items[1]
end if

text = popup_return.descriptions[1]


end event

