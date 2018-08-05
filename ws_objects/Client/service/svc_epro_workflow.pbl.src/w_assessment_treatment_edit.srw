$PBExportHeader$w_assessment_treatment_edit.srw
forward
global type w_assessment_treatment_edit from w_window_base
end type
type st_title from statictext within w_assessment_treatment_edit
end type
type st_treatment_type_title from statictext within w_assessment_treatment_edit
end type
type cb_attributes from commandbutton within w_assessment_treatment_edit
end type
type cb_done from commandbutton within w_assessment_treatment_edit
end type
type st_treatment_mode_title from statictext within w_assessment_treatment_edit
end type
type st_treatment_description from statictext within w_assessment_treatment_edit
end type
type st_treatment_mode from statictext within w_assessment_treatment_edit
end type
type cb_change_description from commandbutton within w_assessment_treatment_edit
end type
type cb_change_mode from commandbutton within w_assessment_treatment_edit
end type
type st_update_list from statictext within w_assessment_treatment_edit
end type
type st_dont_update_list from statictext within w_assessment_treatment_edit
end type
type cb_cancel from commandbutton within w_assessment_treatment_edit
end type
type st_workplan_title from statictext within w_assessment_treatment_edit
end type
type st_child_items_title from statictext within w_assessment_treatment_edit
end type
type st_update_list_title from statictext within w_assessment_treatment_edit
end type
type st_workplan_description from statictext within w_assessment_treatment_edit
end type
type cb_change_workplan from commandbutton within w_assessment_treatment_edit
end type
type dw_child_items from u_dw_pick_list within w_assessment_treatment_edit
end type
type pb_delete from u_picture_button within w_assessment_treatment_edit
end type
type cb_change_child_items from commandbutton within w_assessment_treatment_edit
end type
type st_group_title from statictext within w_assessment_treatment_edit
end type
type st_group from statictext within w_assessment_treatment_edit
end type
type cb_change_group from commandbutton within w_assessment_treatment_edit
end type
end forward

global type w_assessment_treatment_edit from w_window_base
integer x = 201
integer y = 200
integer width = 2528
integer height = 1432
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_title st_title
st_treatment_type_title st_treatment_type_title
cb_attributes cb_attributes
cb_done cb_done
st_treatment_mode_title st_treatment_mode_title
st_treatment_description st_treatment_description
st_treatment_mode st_treatment_mode
cb_change_description cb_change_description
cb_change_mode cb_change_mode
st_update_list st_update_list
st_dont_update_list st_dont_update_list
cb_cancel cb_cancel
st_workplan_title st_workplan_title
st_child_items_title st_child_items_title
st_update_list_title st_update_list_title
st_workplan_description st_workplan_description
cb_change_workplan cb_change_workplan
dw_child_items dw_child_items
pb_delete pb_delete
cb_change_child_items cb_change_child_items
st_group_title st_group_title
st_group st_group
cb_change_group cb_change_group
end type
global w_assessment_treatment_edit w_assessment_treatment_edit

type variables

str_assessment_treatment_definition treatment_def

string followup_flag
string followup_workplan_type


boolean editable

end variables

forward prototypes
public function integer display_treatment ()
end prototypes

public function integer display_treatment ();long ll_count
string ls_temp
string ls_description
string ls_treatment_type

ls_description = datalist.treatment_type_description(treatment_def.treatment_type)
if isnull(ls_description) then
	st_title.text = "Composite Treatment"
else
	st_title.text = ls_description + " Treatment"
end if

st_treatment_description.text = treatment_def.treatment_description

ls_temp = f_attribute_find_attribute(treatment_def.attributes, "treatment_mode")
if isnull(ls_temp) then
	st_treatment_mode.text = "<Default Mode>"
else
	st_treatment_mode.text = ls_temp
end if

followup_flag = upper(datalist.treatment_type_followup_flag(treatment_def.treatment_type))
if isnull(treatment_def.definition_id) or isnull(ls_description) then
	// If we have an unsaved treatment or a composite treatment then don't show the workplan or
	// child treatment controls
	st_workplan_title.visible = false
	st_child_items_title.visible = false
	st_workplan_description.visible = false
	cb_change_workplan.visible = false
	cb_change_child_items.visible = false
	dw_child_items.visible = false
	if isnull(ls_description) then
		// If this is a composite, then don't show the treatment mode controls
		st_treatment_mode_title.visible = false
		st_treatment_mode.visible = false
		cb_change_mode.visible = false
	end if
else
	CHOOSE CASE followup_flag
		CASE "F", "R"
			st_workplan_title.visible = true
			st_child_items_title.visible = true
			st_workplan_description.visible = true
			cb_change_workplan.visible = true
			cb_change_child_items.visible = true
			dw_child_items.visible = true
			if isnull(treatment_def.followup_workplan_id) then
				st_workplan_description.text = "<None>"
			else
				SELECT description
				INTO :st_workplan_description.text
				FROM c_Workplan
				WHERE workplan_id = :treatment_def.followup_workplan_id;
				if not tf_check() then return -1
			end if
			
			ll_count = dw_child_items.retrieve(treatment_def.definition_id)
			
			if followup_flag = "F" then
				followup_workplan_type = "Followup"
				st_workplan_title.text = "Followup Workplan"
				st_child_items_title.text = "Followup Treatment Items"
			else
				followup_workplan_type = "Referral"
				st_workplan_title.text = "Referral Workplan"
				st_child_items_title.text = "Referral Treatment Items"
			end if
		CASE ELSE
			st_workplan_title.visible = false
			st_child_items_title.visible = false
			st_workplan_description.visible = false
			cb_change_workplan.visible = false
			cb_change_child_items.visible = false
			dw_child_items.visible = false
	END CHOOSE
end if

if not dw_child_items.visible then
	st_update_list_title.x = (width - st_update_list_title.width) / 2
	st_update_list.x = st_update_list_title.x
	st_dont_update_list.x = st_update_list_title.x + st_update_list_title.width - st_dont_update_list.width
end if

if isnull(treatment_def.parent_definition_id) then
	st_group.text = "N/A"
else
	SELECT treatment_description,
			treatment_type
	INTO :st_group.text,
			:ls_treatment_type
	FROM u_assessment_treat_definition
	WHERE definition_id = :treatment_def.parent_definition_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		setnull(treatment_def.parent_definition_id)
		st_group.text = "N/A"
	end if
	
	if ls_treatment_type = "!COMPOSITE" then
		st_group.visible = true
		st_group_title.visible = true
		cb_change_group.visible = true
	else
		st_group.visible = false
		st_group_title.visible = false
		cb_change_group.visible = false
	end if
end if

if treatment_def.definition_id > 0 then
	// The treatment list is already updated
	st_update_list_title.visible = false
	st_dont_update_list.visible = false
	st_update_list.visible = false
else
	// Set the update_list backcolor according the the upate_flag
	if treatment_def.update_flag = 2 then
		st_update_list.backcolor = color_object_selected
	else
		st_dont_update_list.backcolor = color_object_selected
	end if
end if

// Finally, if the user is not privileged, then turn off the rest of the edit controls
// If the current user doesn't match the list user, then this must be a common list
if treatment_def.user_id <> current_user.user_id and not current_user.check_privilege("Common Treatment Lists") then
	st_update_list_title.visible = false
	st_dont_update_list.visible = false
	st_update_list.visible = false
	cb_change_group.visible = false
	cb_change_child_items.visible = false
	cb_change_description.visible = false
	cb_change_mode.visible = false
	cb_change_workplan.visible = false
	pb_delete.visible = false
	cb_cancel.visible = false
	editable = false
else
	editable = true
end if


return 1


end function

event open;call super::open;integer li_sts
long ll_definition_id

treatment_def = message.powerobjectparm

dw_child_items.settransobject(sqlca)

li_sts = display_treatment()
if li_sts <= 0 then
	log.log(this, "w_assessment_treatment_edit:open", "Error displaying treatment definition", 4)
	close(this)
	return
end if


end event

on w_assessment_treatment_edit.create
int iCurrent
call super::create
this.st_title=create st_title
this.st_treatment_type_title=create st_treatment_type_title
this.cb_attributes=create cb_attributes
this.cb_done=create cb_done
this.st_treatment_mode_title=create st_treatment_mode_title
this.st_treatment_description=create st_treatment_description
this.st_treatment_mode=create st_treatment_mode
this.cb_change_description=create cb_change_description
this.cb_change_mode=create cb_change_mode
this.st_update_list=create st_update_list
this.st_dont_update_list=create st_dont_update_list
this.cb_cancel=create cb_cancel
this.st_workplan_title=create st_workplan_title
this.st_child_items_title=create st_child_items_title
this.st_update_list_title=create st_update_list_title
this.st_workplan_description=create st_workplan_description
this.cb_change_workplan=create cb_change_workplan
this.dw_child_items=create dw_child_items
this.pb_delete=create pb_delete
this.cb_change_child_items=create cb_change_child_items
this.st_group_title=create st_group_title
this.st_group=create st_group
this.cb_change_group=create cb_change_group
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.st_treatment_type_title
this.Control[iCurrent+3]=this.cb_attributes
this.Control[iCurrent+4]=this.cb_done
this.Control[iCurrent+5]=this.st_treatment_mode_title
this.Control[iCurrent+6]=this.st_treatment_description
this.Control[iCurrent+7]=this.st_treatment_mode
this.Control[iCurrent+8]=this.cb_change_description
this.Control[iCurrent+9]=this.cb_change_mode
this.Control[iCurrent+10]=this.st_update_list
this.Control[iCurrent+11]=this.st_dont_update_list
this.Control[iCurrent+12]=this.cb_cancel
this.Control[iCurrent+13]=this.st_workplan_title
this.Control[iCurrent+14]=this.st_child_items_title
this.Control[iCurrent+15]=this.st_update_list_title
this.Control[iCurrent+16]=this.st_workplan_description
this.Control[iCurrent+17]=this.cb_change_workplan
this.Control[iCurrent+18]=this.dw_child_items
this.Control[iCurrent+19]=this.pb_delete
this.Control[iCurrent+20]=this.cb_change_child_items
this.Control[iCurrent+21]=this.st_group_title
this.Control[iCurrent+22]=this.st_group
this.Control[iCurrent+23]=this.cb_change_group
end on

on w_assessment_treatment_edit.destroy
call super::destroy
destroy(this.st_title)
destroy(this.st_treatment_type_title)
destroy(this.cb_attributes)
destroy(this.cb_done)
destroy(this.st_treatment_mode_title)
destroy(this.st_treatment_description)
destroy(this.st_treatment_mode)
destroy(this.cb_change_description)
destroy(this.cb_change_mode)
destroy(this.st_update_list)
destroy(this.st_dont_update_list)
destroy(this.cb_cancel)
destroy(this.st_workplan_title)
destroy(this.st_child_items_title)
destroy(this.st_update_list_title)
destroy(this.st_workplan_description)
destroy(this.cb_change_workplan)
destroy(this.dw_child_items)
destroy(this.pb_delete)
destroy(this.cb_change_child_items)
destroy(this.st_group_title)
destroy(this.st_group)
destroy(this.cb_change_group)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_assessment_treatment_edit
boolean visible = true
integer x = 1143
integer y = 1252
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_assessment_treatment_edit
end type

type st_title from statictext within w_assessment_treatment_edit
integer width = 2491
integer height = 116
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
alignment alignment = center!
boolean focusrectangle = false
end type

type st_treatment_type_title from statictext within w_assessment_treatment_edit
integer x = 119
integer y = 160
integer width = 425
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_attributes from commandbutton within w_assessment_treatment_edit
integer x = 480
integer y = 1244
integer width = 489
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Show Attributes"
end type

event clicked;openwithparm(w_attributes_display, treatment_def.attributes)

end event

type cb_done from commandbutton within w_assessment_treatment_edit
integer x = 1984
integer y = 1244
integer width = 439
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
end type

event clicked;str_popup_return popup_return

if editable then
	popup_return.item_count = 1
	popup_return.items[1] = "OK"
	popup_return.returnobject = treatment_def
else
	popup_return.item_count = 0
	popup_return.returnobject = treatment_def
end if

closewithreturn(parent, popup_return)

end event

type st_treatment_mode_title from statictext within w_assessment_treatment_edit
integer x = 320
integer y = 416
integer width = 507
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Treatment Mode:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_treatment_description from statictext within w_assessment_treatment_edit
integer x = 567
integer y = 160
integer width = 1705
integer height = 180
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
boolean focusrectangle = false
end type

type st_treatment_mode from statictext within w_assessment_treatment_edit
integer x = 846
integer y = 404
integer width = 905
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
boolean border = true
boolean focusrectangle = false
end type

type cb_change_description from commandbutton within w_assessment_treatment_edit
integer x = 2281
integer y = 248
integer width = 133
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Enter new description for this treatment"
popup.item = st_treatment_description.text

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if len(popup_return.items[1]) > 255 then
	openwithparm(w_pop_message, "The description for an item in a treatment list cannot exceed 255 characters.  The description has been truncated.")
	popup_return.items[1] = left(popup_return.items[1], 255)
end if

treatment_def.treatment_description = popup_return.items[1]
st_treatment_description.text = popup_return.items[1]

end event

type cb_change_mode from commandbutton within w_assessment_treatment_edit
integer x = 1760
integer y = 404
integer width = 133
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_treatment_mode_pick"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = treatment_def.treatment_type
popup.add_blank_row = true
popup.blank_text = "<Default Mode>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	f_attribute_delete_attribute(treatment_def.attributes, "treatment_mode")
else
	f_attribute_add_attribute(treatment_def.attributes, "treatment_mode", popup_return.items[1])
end if

st_treatment_mode.text = popup_return.descriptions[1]

end event

type st_update_list from statictext within w_assessment_treatment_edit
integer x = 2007
integer y = 740
integer width = 178
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_dont_update_list.backcolor = color_object
treatment_def.update_flag = 1


end event

type st_dont_update_list from statictext within w_assessment_treatment_edit
integer x = 2235
integer y = 740
integer width = 178
integer height = 104
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_update_list.backcolor = color_object
treatment_def.update_flag = 0

end event

type cb_cancel from commandbutton within w_assessment_treatment_edit
integer x = 1467
integer y = 1244
integer width = 439
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
popup_return.returnobject = treatment_def

closewithreturn(parent, popup_return)

end event

type st_workplan_title from statictext within w_assessment_treatment_edit
integer x = 229
integer y = 548
integer width = 599
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Followup Workplan:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_child_items_title from statictext within w_assessment_treatment_edit
integer x = 37
integer y = 668
integer width = 791
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Followup Treatment Items:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_update_list_title from statictext within w_assessment_treatment_edit
integer x = 1993
integer y = 656
integer width = 425
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
string text = "Update List"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_workplan_description from statictext within w_assessment_treatment_edit
integer x = 846
integer y = 536
integer width = 905
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
boolean border = true
boolean focusrectangle = false
end type

type cb_change_workplan from commandbutton within w_assessment_treatment_edit
integer x = 1760
integer y = 536
integer width = 133
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup popup
str_popup_return popup_return
long ll_workplan_id

popup.dataobject = "dw_followup_workplan_list"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = followup_workplan_type
popup.add_blank_row = true
popup.blank_text = "<None>"

Openwithparm(w_pop_pick, popup)
popup_return = Message.powerobjectparm
If popup_return.item_count <> 1 Then Return

if popup_return.items[1] = "" then
	setnull(ll_workplan_id)
else
	ll_workplan_id = Long(popup_return.items[1])
end if

treatment_def.followup_workplan_id = ll_workplan_id
st_workplan_description.text = popup_return.descriptions[1]


end event

type dw_child_items from u_dw_pick_list within w_assessment_treatment_edit
integer x = 846
integer y = 668
integer width = 1047
integer height = 384
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_child_treatment_defs"
boolean vscrollbar = true
end type

type pb_delete from u_picture_button within w_assessment_treatment_edit
integer x = 59
integer y = 1140
integer taborder = 11
boolean bringtotop = true
boolean originalsize = false
string picturename = "button13.bmp"
string disabledname = "b_push13.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you want to remove this treatment from the treatment list?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

popup_return.item_count = 1
popup_return.items[1] = "DELETE"
popup_return.returnobject = treatment_def

closewithreturn(parent, popup_return)

end event

type cb_change_child_items from commandbutton within w_assessment_treatment_edit
integer x = 1906
integer y = 960
integer width = 133
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;long ll_count

openwithparm(w_assessment_treatment_children, treatment_def)
ll_count = dw_child_items.retrieve(treatment_def.definition_id)

//str_popup popup
//
//popup_followup.objectparm2 = dw_therapies
//popup_followup.data_row_count = 3
//popup_followup.item = assessment.assessment_id
//popup_followup.items[1] = list_user_id
//popup_followup.items[2] = String(ll_definition_id)
//popup_followup.items[3] = ls_treatment_mode
//popup_followup.title = ls_treatment_desc
//Openwithparm(w_add_followup_treatments,popup_followup)
//// Get the array of treatment structure
//popup = Message.powerobjectparm
//lstr_treatments = popup.anyparm
//li_sts = Upperbound(lstr_treatments)
//// Append in instance array
//li_count = Upperbound(treatment_attr)
//For i = 1 to li_sts
//	li_count++
//	treatment_attr[li_count] = lstr_treatments[i]
//Next
//
end event

type st_group_title from statictext within w_assessment_treatment_edit
integer x = 594
integer y = 1096
integer width = 233
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Group:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_group from statictext within w_assessment_treatment_edit
integer x = 846
integer y = 1084
integer width = 905
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
boolean border = true
boolean focusrectangle = false
end type

type cb_change_group from commandbutton within w_assessment_treatment_edit
integer x = 1760
integer y = 1084
integer width = 133
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ". . ."
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_treatment_list_group_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.argument_count = 3
popup.argument[1] = treatment_def.assessment_id
popup.argument[2] = treatment_def.user_id
popup.argument[3] = "!COMPOSITE"
popup.add_blank_row = true
popup.blank_text = "<No Group>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(treatment_def.parent_definition_id)
	st_group.text = "N/A"
else
	treatment_def.parent_definition_id = long(popup_return.items[1])
	st_group.text = popup_return.descriptions[1]
end if


end event

