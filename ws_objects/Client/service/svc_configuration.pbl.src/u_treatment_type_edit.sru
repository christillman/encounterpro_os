$PBExportHeader$u_treatment_type_edit.sru
forward
global type u_treatment_type_edit from userobject
end type
type pb_down from u_picture_button within u_treatment_type_edit
end type
type st_page from statictext within u_treatment_type_edit
end type
type pb_up from u_picture_button within u_treatment_type_edit
end type
type st_1 from statictext within u_treatment_type_edit
end type
type dw_treatment_types from u_dw_pick_list within u_treatment_type_edit
end type
type st_title from statictext within u_treatment_type_edit
end type
type pb_new_treatment_type from u_picture_button within u_treatment_type_edit
end type
end forward

global type u_treatment_type_edit from userobject
integer width = 2400
integer height = 1748
long backcolor = 33538240
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
pb_down pb_down
st_page st_page
pb_up pb_up
st_1 st_1
dw_treatment_types dw_treatment_types
st_title st_title
pb_new_treatment_type pb_new_treatment_type
end type
global u_treatment_type_edit u_treatment_type_edit

type variables
string treatment_type
string description
end variables

forward prototypes
public subroutine treatment_type_menu (long pl_row)
public subroutine display_treatment_types ()
public function integer initialize ()
end prototypes

public subroutine treatment_type_menu (long pl_row);str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
string ls_user_id
integer li_update_flag
string ls_treatment_type
string ls_temp

ls_treatment_type = dw_treatment_types.object.treatment_type[pl_row]

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Edit Treatment Type Definition"
	popup.button_titles[popup.button_count] = "Edit Treatment Type"
	buttons[popup.button_count] = "EDIT"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button13.bmp"
	popup.button_helps[popup.button_count] = "Delete Treatment Type"
	popup.button_titles[popup.button_count] = "Delete Treatment Type"
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
		popup.items[1] = ls_treatment_type
		popup.data_row_count = 1
		openwithparm(w_treatment_type_definition, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return
		dw_treatment_types.setitem(pl_row, "description", popup_return.descriptions[1])
	CASE "DELETE"
		ls_temp = "Are you sure you wish to delete the encounter type '" + dw_treatment_types.object.description[pl_row] + "'?"
		openwithparm(w_pop_yes_no, ls_temp)
		popup_return = message.powerobjectparm
		if popup_return.item = "YES" then
			UPDATE c_treatment_type
			SET status = 'NA'
			WHERE treatment_type = :ls_treatment_type;
			if not tf_check() then return
			dw_treatment_types.deleterow(pl_row)
		end if
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE

return


end subroutine

public subroutine display_treatment_types ();dw_treatment_types.retrieve()
dw_treatment_types.last_page = 0
dw_treatment_types.set_page(1, st_page.text)
if dw_treatment_types.last_page < 2 then
	pb_down.visible = false
	pb_up.visible = false
else
	pb_down.visible = true
	pb_up.visible = true
	pb_up.enabled = false
	pb_down.enabled = true
end if

end subroutine

public function integer initialize ();
dw_treatment_types.settransobject(sqlca)

display_treatment_types()
return 1

end function

on u_treatment_type_edit.create
this.pb_down=create pb_down
this.st_page=create st_page
this.pb_up=create pb_up
this.st_1=create st_1
this.dw_treatment_types=create dw_treatment_types
this.st_title=create st_title
this.pb_new_treatment_type=create pb_new_treatment_type
this.Control[]={this.pb_down,&
this.st_page,&
this.pb_up,&
this.st_1,&
this.dw_treatment_types,&
this.st_title,&
this.pb_new_treatment_type}
end on

on u_treatment_type_edit.destroy
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.st_1)
destroy(this.dw_treatment_types)
destroy(this.st_title)
destroy(this.pb_new_treatment_type)
end on

event constructor;dw_treatment_types.height = height - 20
end event

type pb_down from u_picture_button within u_treatment_type_edit
integer x = 1307
integer y = 244
integer width = 137
integer height = 116
integer taborder = 40
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_treatment_types.current_page
li_last_page = dw_treatment_types.last_page

dw_treatment_types.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
end event

type st_page from statictext within u_treatment_type_edit
integer x = 1275
integer y = 20
integer width = 302
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
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within u_treatment_type_edit
integer x = 1303
integer y = 88
integer width = 137
integer height = 116
integer taborder = 40
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_treatment_types.current_page

dw_treatment_types.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_1 from statictext within u_treatment_type_edit
integer x = 1705
integer y = 1480
integer width = 274
integer height = 200
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "New Treatment Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_treatment_types from u_dw_pick_list within u_treatment_type_edit
integer x = 9
integer y = 8
integer width = 1257
integer height = 1696
integer taborder = 10
string dataobject = "dw_treatment_type_edit_list"
boolean border = false
boolean livescroll = false
end type

event computed_clicked;call super::computed_clicked;treatment_type_menu(clicked_row)
clear_selected()
end event

event selected;call super::selected;treatment_type = object.treatment_type[selected_row]
description = object.treatment_type[selected_row]
end event

type st_title from statictext within u_treatment_type_edit
integer x = 1527
integer y = 76
integer width = 855
integer height = 240
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Select Treatment Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_new_treatment_type from u_picture_button within u_treatment_type_edit
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
string ls_treatment_type
string ls_base_treatment_type
integer i
integer li_count
integer li_sort_sequence
string ls_bill_flag
string ls_button
string ls_icon

popup.title = "Enter new Treatment Type description"

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]
ls_base_treatment_type = f_gen_key_string(ls_description, 22)
ls_treatment_type = ls_base_treatment_type
i = 0

DO
	SELECT count(*)
	INTO :li_count
	FROM c_treatment_type
	WHERE treatment_type = :ls_treatment_type;
	if not tf_check() then return
	if li_count = 0 then exit
	
	i += 1
	ls_treatment_type = ls_base_treatment_type + string(i)
	
LOOP WHILE i < 100

if i >= 100 then
	log.log(this, "clicked", "Unable to generate new treatment_type key (" + ls_description + ")", 4)
	return
end if

SELECT max(sort_sequence) + 1
INTO :li_sort_sequence
FROM c_treatment_type
WHERE treatment_type = :ls_treatment_type;
if not tf_check() then return
if isnull(li_sort_sequence) then li_sort_sequence = 1


ls_button = "button10.bmp"
ls_icon = "button10.bmp"


INSERT INTO c_treatment_type (
	treatment_type,
	description,
	sort_sequence,
	button,
	icon,
	status)
VALUES (
	:ls_treatment_type,
	:ls_description,
	:li_sort_sequence,
	:ls_button,
	:ls_icon,
	'OK' );
if not tf_check() then return

popup.data_row_count = 1
popup.items[1] = ls_treatment_type

openwithparm(w_treatment_type_definition, popup)
popup_return = message.powerobjectparm

//display_treatment_types()
end event

