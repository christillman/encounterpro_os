$PBExportHeader$w_config_treatment_types.srw
forward
global type w_config_treatment_types from w_window_base
end type
type pb_down from u_picture_button within w_config_treatment_types
end type
type st_page from statictext within w_config_treatment_types
end type
type pb_up from u_picture_button within w_config_treatment_types
end type
type dw_treatment_types from u_dw_pick_list within w_config_treatment_types
end type
type st_title from statictext within w_config_treatment_types
end type
type cb_new_treatment_type from commandbutton within w_config_treatment_types
end type
type cb_1 from commandbutton within w_config_treatment_types
end type
type sle_filter from singlelineedit within w_config_treatment_types
end type
type st_1 from statictext within w_config_treatment_types
end type
type st_filter_active from statictext within w_config_treatment_types
end type
type st_filter_inactive from statictext within w_config_treatment_types
end type
end forward

global type w_config_treatment_types from w_window_base
string title = "Treatment Types"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_down pb_down
st_page st_page
pb_up pb_up
dw_treatment_types dw_treatment_types
st_title st_title
cb_new_treatment_type cb_new_treatment_type
cb_1 cb_1
sle_filter sle_filter
st_1 st_1
st_filter_active st_filter_active
st_filter_inactive st_filter_inactive
end type
global w_config_treatment_types w_config_treatment_types

type variables
string treatment_type_status

end variables

forward prototypes
public subroutine treatment_type_menu (long pl_row)
public subroutine display_treatment_types ()
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

//if true then
//	popup.button_count = popup.button_count + 1
//	popup.button_icons[popup.button_count] = "button13.bmp"
//	popup.button_helps[popup.button_count] = "Delete Treatment Type"
//	popup.button_titles[popup.button_count] = "Delete Treatment Type"
//	buttons[popup.button_count] = "DELETE"
//end if
//
if popup.button_count > 1 then
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

public subroutine display_treatment_types ();dw_treatment_types.object.description.width = dw_treatment_types.width - 248
dw_treatment_types.retrieve(treatment_type_status)
dw_treatment_types.set_page(1, pb_up, pb_down, st_page)

end subroutine

on w_config_treatment_types.create
int iCurrent
call super::create
this.pb_down=create pb_down
this.st_page=create st_page
this.pb_up=create pb_up
this.dw_treatment_types=create dw_treatment_types
this.st_title=create st_title
this.cb_new_treatment_type=create cb_new_treatment_type
this.cb_1=create cb_1
this.sle_filter=create sle_filter
this.st_1=create st_1
this.st_filter_active=create st_filter_active
this.st_filter_inactive=create st_filter_inactive
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_down
this.Control[iCurrent+2]=this.st_page
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.dw_treatment_types
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.cb_new_treatment_type
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.sle_filter
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_filter_active
this.Control[iCurrent+11]=this.st_filter_inactive
end on

on w_config_treatment_types.destroy
call super::destroy
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.dw_treatment_types)
destroy(this.st_title)
destroy(this.cb_new_treatment_type)
destroy(this.cb_1)
destroy(this.sle_filter)
destroy(this.st_1)
destroy(this.st_filter_active)
destroy(this.st_filter_inactive)
end on

event open;call super::open;
dw_treatment_types.settransobject(sqlca)

treatment_type_status = 'OK'
st_filter_active.backcolor = color_object_selected

display_treatment_types()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_config_treatment_types
boolean visible = true
integer x = 1883
integer y = 1588
integer taborder = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_config_treatment_types
end type

type pb_down from u_picture_button within w_config_treatment_types
integer x = 1426
integer y = 140
integer width = 137
integer height = 116
integer taborder = 0
boolean bringtotop = true
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

type st_page from statictext within w_config_treatment_types
integer x = 1431
integer y = 260
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_config_treatment_types
integer x = 1431
integer y = 16
integer width = 137
integer height = 116
integer taborder = 0
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_treatment_types.current_page

dw_treatment_types.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type dw_treatment_types from u_dw_pick_list within w_config_treatment_types
integer x = 9
integer y = 8
integer width = 1408
integer height = 1696
integer taborder = 0
boolean bringtotop = true
string dataobject = "dw_treatment_type_config_pick_list"
boolean vscrollbar = true
boolean border = false
boolean livescroll = false
end type

event selected;call super::selected;treatment_type_menu(selected_row)
clear_selected()

end event

type st_title from statictext within w_config_treatment_types
integer x = 1605
integer y = 20
integer width = 1266
integer height = 144
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Select Treatment Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_new_treatment_type from commandbutton within w_config_treatment_types
integer x = 1787
integer y = 1248
integer width = 686
integer height = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Treatment Type "
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_description
string ls_treatment_type
string ls_base_treatment_type
integer i
integer li_count
integer li_sort_sequence
string ls_bill_flag
string ls_button
string ls_icon
u_ds_data dw_char_key

popup.title = "Enter new Treatment Type description"

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]
ls_base_treatment_type = f_gen_key_string(ls_description, 22)
dw_char_key = CREATE u_ds_data
dw_char_key.set_dataobject("dw_sp_get_char_key_resultset")
dw_char_key.retrieve("c_Treatment_Type", "treatment_type", ls_base_treatment_type)

ls_treatment_type = dw_char_key.object.new_key[1]

li_sort_sequence = 1
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

display_treatment_types()
end event

type cb_1 from commandbutton within w_config_treatment_types
integer x = 2345
integer y = 1588
integer width = 512
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
boolean cancel = true
end type

event clicked;close(parent)

end event

type sle_filter from singlelineedit within w_config_treatment_types
integer x = 1691
integer y = 472
integer width = 882
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_filter

ls_filter = trim(text)
if ls_filter = "" then
	dw_treatment_types.setfilter("")
else
	dw_treatment_types.setfilter("lower(left(description, " + string(len(ls_filter)) + ")) = '" + lower(ls_filter) + "'")
end if

dw_treatment_types.filter()
end event

type st_1 from statictext within w_config_treatment_types
integer x = 1705
integer y = 408
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
string text = "Filter"
boolean focusrectangle = false
end type

type st_filter_active from statictext within w_config_treatment_types
integer x = 1710
integer y = 656
integer width = 402
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_filter_active.backcolor = color_object_selected
st_filter_inactive.backcolor = color_object

treatment_type_status = 'OK'

display_treatment_types()

end event

type st_filter_inactive from statictext within w_config_treatment_types
integer x = 2149
integer y = 656
integer width = 402
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inactive"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;st_filter_active.backcolor = color_object
st_filter_inactive.backcolor = color_object_selected

treatment_type_status = 'NA'

display_treatment_types()

end event

