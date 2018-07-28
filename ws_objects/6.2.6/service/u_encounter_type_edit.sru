HA$PBExportHeader$u_encounter_type_edit.sru
forward
global type u_encounter_type_edit from userobject
end type
type pb_up from u_picture_button within u_encounter_type_edit
end type
type pb_down from u_picture_button within u_encounter_type_edit
end type
type st_page from statictext within u_encounter_type_edit
end type
type st_mode_title from statictext within u_encounter_type_edit
end type
type st_encounter_mode from statictext within u_encounter_type_edit
end type
type st_1 from statictext within u_encounter_type_edit
end type
type dw_encounter_types from u_dw_pick_list within u_encounter_type_edit
end type
type st_title from statictext within u_encounter_type_edit
end type
type pb_new_observation from u_picture_button within u_encounter_type_edit
end type
end forward

global type u_encounter_type_edit from userobject
integer width = 2400
integer height = 1748
long backcolor = 33538240
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
pb_up pb_up
pb_down pb_down
st_page st_page
st_mode_title st_mode_title
st_encounter_mode st_encounter_mode
st_1 st_1
dw_encounter_types dw_encounter_types
st_title st_title
pb_new_observation pb_new_observation
end type
global u_encounter_type_edit u_encounter_type_edit

type variables
string encounter_mode

end variables

forward prototypes
public subroutine encounter_type_menu (long pl_row)
public function integer display_encounter_types ()
public function integer initialize ()
end prototypes

public subroutine encounter_type_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_encounter_type
string ls_temp

ls_encounter_type = dw_encounter_types.object.encounter_type[pl_row]

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Encounter Type Definition"
	popup.button_titles[popup.button_count] = "Edit Encounter Type"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Encounter Type"
	popup.button_titles[popup.button_count] = "Delete Encounter Type"
	buttons[popup.button_count] = "DELETE"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "EDIT"
		popup.items[1] = ls_encounter_type
		popup.data_row_count = 1
		openwithparm(w_Encounter_Type_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		dw_encounter_types.setitem(pl_row, "description", popup_return.descriptions[1])
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the encounter type '" + dw_encounter_types.object.description[pl_row] + "'?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			UPDATE c_Encounter_Type
			SET status = 'NA'
			WHERE encounter_type = :ls_encounter_type;
			if not tf_check() then return
			dw_encounter_types.deleterow(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public function integer display_encounter_types ();integer li_sts

li_sts = dw_encounter_types.retrieve(encounter_mode)
if li_sts < 0 then return -1

dw_encounter_types.last_page = 0
dw_encounter_types.set_page(1, st_page.text)
if dw_encounter_types.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if

return 1

end function

public function integer initialize ();integer li_sts

dw_encounter_types.settransobject(sqlca)

encounter_mode = 'D'
st_encounter_mode.text = 'Direct'

li_sts = display_encounter_types()
if li_sts < 0 then return -1

return 1

end function

on u_encounter_type_edit.create
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_mode_title=create st_mode_title
this.st_encounter_mode=create st_encounter_mode
this.st_1=create st_1
this.dw_encounter_types=create dw_encounter_types
this.st_title=create st_title
this.pb_new_observation=create pb_new_observation
this.Control[]={this.pb_up,&
this.pb_down,&
this.st_page,&
this.st_mode_title,&
this.st_encounter_mode,&
this.st_1,&
this.dw_encounter_types,&
this.st_title,&
this.pb_new_observation}
end on

on u_encounter_type_edit.destroy
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_mode_title)
destroy(this.st_encounter_mode)
destroy(this.st_1)
destroy(this.dw_encounter_types)
destroy(this.st_title)
destroy(this.pb_new_observation)
end on

event constructor;dw_encounter_types.height = height - 20
end event

type pb_up from u_picture_button within u_encounter_type_edit
integer x = 1230
integer y = 16
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_encounter_types.current_page

dw_encounter_types.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within u_encounter_type_edit
integer x = 1230
integer y = 144
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_encounter_types.current_page
li_last_page = dw_encounter_types.last_page

dw_encounter_types.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within u_encounter_type_edit
integer x = 1234
integer y = 268
integer width = 347
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
boolean focusrectangle = false
end type

type st_mode_title from statictext within u_encounter_type_edit
integer x = 1582
integer y = 572
integer width = 521
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_encounter_mode from statictext within u_encounter_type_edit
integer x = 1463
integer y = 648
integer width = 754
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
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
integer li_sts
string ls_button

popup.dataobject = "dw_domain_translate_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "ENCOUNTER_MODE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

encounter_mode = popup_return.items[1]
text = popup_return.descriptions[1]

display_encounter_types()

end event

type st_1 from statictext within u_encounter_type_edit
integer x = 1691
integer y = 1480
integer width = 311
integer height = 200
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "New Encounter Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_encounter_types from u_dw_pick_list within u_encounter_type_edit
integer x = 9
integer y = 8
integer width = 1221
integer height = 1696
integer taborder = 10
string dataobject = "dw_encounter_type_by_mode_list"
boolean border = false
end type

event selected;call super::selected;encounter_type_menu(selected_row)
clear_selected()

end event

type st_title from statictext within u_encounter_type_edit
integer x = 1449
integer y = 24
integer width = 855
integer height = 360
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Select Encounter Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_new_observation from u_picture_button within u_encounter_type_edit
event clicked pbm_bnclicked
integer x = 1719
integer y = 1264
integer taborder = 40
boolean default = true
string picturename = "b_new10.bmp"
string disabledname = "b_push10.bmp"
end type

event clicked;str_popup popup
str_popup_return popup_return
//integer li_selected_flag
//long ll_row
//long ll_workplan_id
string ls_description
string ls_encounter_type
string ls_base_encounter_type
integer i
integer li_count
integer li_sort_sequence
string ls_bill_flag
string ls_button
string ls_icon

popup.title = "Enter new Encounter Type description"

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]
ls_base_encounter_type = f_gen_key_string(ls_description, 22)
ls_encounter_type = ls_base_encounter_type
i = 0

DO
	SELECT count(*)
	INTO :li_count
	FROM c_Encounter_Type
	WHERE encounter_type = :ls_encounter_type;
	if not tf_check() then return
	if li_count = 0 then exit
	
	i += 1
	ls_encounter_type = ls_base_encounter_type + string(i)
	
LOOP WHILE i < 100

if i >= 100 then
	log.log(this, "clicked", "Unable to generate new encounter_type key (" + ls_description + ")", 4)
	return
end if

SELECT max(sort_order) + 1
INTO :li_sort_sequence
FROM c_Encounter_Type
WHERE encounter_type = :ls_encounter_type;
if not tf_check() then return
if isnull(li_sort_sequence) then li_sort_sequence = 1


CHOOSE CASE encounter_mode
	CASE "D"
		ls_bill_flag = "Y"
		ls_button = "button10.bmp"
		ls_icon = "button10.bmp"
	CASE "I"
		ls_bill_flag = "N"
		ls_button = "button10.bmp"
		ls_icon = "button10.bmp"
	CASE "N"
		ls_bill_flag = "N"
		ls_button = "button10.bmp"
		ls_icon = "button10.bmp"
END CHOOSE

INSERT INTO c_Encounter_Type (
	encounter_type,
	description,
	sort_order,
	bill_flag,
	default_indirect_flag,
	button,
	icon,
	status)
VALUES (
	:ls_encounter_type,
	:ls_description,
	:li_sort_sequence,
	:ls_bill_flag,
	:encounter_mode,
	:ls_button,
	:ls_icon,
	'OK' );
if not tf_check() then return

popup.data_row_count = 1
popup.items[1] = ls_encounter_type

openwithparm(w_encounter_type_definition, popup)
popup_return = message.powerobjectparm

display_encounter_types()


end event

