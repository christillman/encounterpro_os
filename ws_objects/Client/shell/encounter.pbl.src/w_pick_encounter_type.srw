$PBExportHeader$w_pick_encounter_type.srw
forward
global type w_pick_encounter_type from w_window_base
end type
type st_search_title from statictext within w_pick_encounter_type
end type
type pb_up from u_picture_button within w_pick_encounter_type
end type
type pb_down from u_picture_button within w_pick_encounter_type
end type
type st_page from statictext within w_pick_encounter_type
end type
type st_top_20 from statictext within w_pick_encounter_type
end type
type st_search_status from statictext within w_pick_encounter_type
end type
type st_title from statictext within w_pick_encounter_type
end type
type st_description from statictext within w_pick_encounter_type
end type
type st_mode_direct from statictext within w_pick_encounter_type
end type
type cb_ok from commandbutton within w_pick_encounter_type
end type
type cb_new_encounter_type from commandbutton within w_pick_encounter_type
end type
type cb_cancel from commandbutton within w_pick_encounter_type
end type
type dw_encounter_types from u_dw_encounter_type_list within w_pick_encounter_type
end type
type st_encounter_mode_title from statictext within w_pick_encounter_type
end type
type st_mode_indirect from statictext within w_pick_encounter_type
end type
type st_mode_other from statictext within w_pick_encounter_type
end type
end forward

global type w_pick_encounter_type from w_window_base
integer height = 1836
windowtype windowtype = response!
st_search_title st_search_title
pb_up pb_up
pb_down pb_down
st_page st_page
st_top_20 st_top_20
st_search_status st_search_status
st_title st_title
st_description st_description
st_mode_direct st_mode_direct
cb_ok cb_ok
cb_new_encounter_type cb_new_encounter_type
cb_cancel cb_cancel
dw_encounter_types dw_encounter_types
st_encounter_mode_title st_encounter_mode_title
st_mode_indirect st_mode_indirect
st_mode_other st_mode_other
end type
global w_pick_encounter_type w_pick_encounter_type

type variables
string search_type
end variables

event open;call super::open;//////////////////////////////////////////////////////////////////////////////////////
//
// Description:Based on treatment type, set the datawindow object names for category
// alpha and top20. [ need to be generalized in future by replacing this case state
// -ment with treatmet component ]
//
// Created By:Mark														Creation dt: 
//
// Modified By:Sumathi Chinnasamy									Creation dt: 02/02/2000
/////////////////////////////////////////////////////////////////////////////////////

str_popup popup
string ls_mode
string ls_indirect_flag
boolean lb_params_found

lb_params_found = false
if isvalid(message) and not isnull(message) then
	if isvalid(message.powerobjectparm) and not isnull(message.powerobjectparm) then
		if lower(classname(message.powerobjectparm)) = "str_popup" then
			popup = message.powerobjectparm
		
			if popup.data_row_count = 2 then
				ls_mode = popup.items[1]
				ls_indirect_flag = popup.items[2]
				lb_params_found = true
			end if
		end if
	end if
end if

if not lb_params_found then
	ls_mode = "EDIT"
	ls_indirect_flag = "D"
end if

CHOOSE CASE upper(ls_indirect_flag)
	CASE "I"
		ls_indirect_flag ="I"
		st_mode_indirect.backcolor = color_object_selected
	CASE "N"
		ls_indirect_flag ="N"
		st_mode_other.backcolor = color_object_selected
	CASE ELSE
		ls_indirect_flag ="D"
		st_mode_direct.backcolor = color_object_selected
END CHOOSE

if upper(ls_mode) = "EDIT" then
	dw_encounter_types.mode = "EDIT"
	cb_cancel.visible = false
else
	dw_encounter_types.mode = "PICK"
end if

dw_encounter_types.specialty_id = current_user.common_list_id()

dw_encounter_types.object.description.width = dw_encounter_types.width - 150

dw_encounter_types.initialize(ls_indirect_flag)


st_title.text = "Select Encounter Type"

if isnull(current_patient) then
	title = st_title.text
else
	title = current_patient.id_line()
end if


dw_encounter_types.search_top_20()


end event

on w_pick_encounter_type.create
int iCurrent
call super::create
this.st_search_title=create st_search_title
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_top_20=create st_top_20
this.st_search_status=create st_search_status
this.st_title=create st_title
this.st_description=create st_description
this.st_mode_direct=create st_mode_direct
this.cb_ok=create cb_ok
this.cb_new_encounter_type=create cb_new_encounter_type
this.cb_cancel=create cb_cancel
this.dw_encounter_types=create dw_encounter_types
this.st_encounter_mode_title=create st_encounter_mode_title
this.st_mode_indirect=create st_mode_indirect
this.st_mode_other=create st_mode_other
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_search_title
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_top_20
this.Control[iCurrent+6]=this.st_search_status
this.Control[iCurrent+7]=this.st_title
this.Control[iCurrent+8]=this.st_description
this.Control[iCurrent+9]=this.st_mode_direct
this.Control[iCurrent+10]=this.cb_ok
this.Control[iCurrent+11]=this.cb_new_encounter_type
this.Control[iCurrent+12]=this.cb_cancel
this.Control[iCurrent+13]=this.dw_encounter_types
this.Control[iCurrent+14]=this.st_encounter_mode_title
this.Control[iCurrent+15]=this.st_mode_indirect
this.Control[iCurrent+16]=this.st_mode_other
end on

on w_pick_encounter_type.destroy
call super::destroy
destroy(this.st_search_title)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_top_20)
destroy(this.st_search_status)
destroy(this.st_title)
destroy(this.st_description)
destroy(this.st_mode_direct)
destroy(this.cb_ok)
destroy(this.cb_new_encounter_type)
destroy(this.cb_cancel)
destroy(this.dw_encounter_types)
destroy(this.st_encounter_mode_title)
destroy(this.st_mode_indirect)
destroy(this.st_mode_other)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_encounter_type
boolean visible = true
integer x = 2039
integer y = 1588
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_encounter_type
end type

type st_search_title from statictext within w_pick_encounter_type
integer x = 1902
integer y = 540
integer width = 558
integer height = 88
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 7191717
string text = "Search Options"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from u_picture_button within w_pick_encounter_type
integer x = 1440
integer y = 120
integer width = 137
integer height = 116
integer taborder = 20
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

type pb_down from u_picture_button within w_pick_encounter_type
integer x = 1440
integer y = 244
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

type st_page from statictext within w_pick_encounter_type
integer x = 1577
integer y = 120
integer width = 274
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Page 99/99"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_top_20 from statictext within w_pick_encounter_type
integer x = 1490
integer y = 648
integer width = 677
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Short List"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if search_type = "TOP20" then
	if dw_encounter_types.search_description = "Personal List" then
		dw_encounter_types.search_top_20(false)
	else
		dw_encounter_types.search_top_20(true)
	end if
else
	if dw_encounter_types.search_description = "Personal List" then
		dw_encounter_types.search_top_20(true)
	else
		dw_encounter_types.search_top_20(false)
	end if
end if


end event

type st_search_status from statictext within w_pick_encounter_type
integer x = 1486
integer y = 784
integer width = 1381
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_title from statictext within w_pick_encounter_type
integer width = 2926
integer height = 108
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_description from statictext within w_pick_encounter_type
integer x = 2190
integer y = 648
integer width = 677
integer height = 108
integer taborder = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Description"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;dw_encounter_types.search_description()

end event

type st_mode_direct from statictext within w_pick_encounter_type
integer x = 1696
integer y = 328
integer width = 279
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Direct"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_mode_indirect.backcolor = color_object
st_mode_other.backcolor = color_object

dw_encounter_types.initialize("D")

dw_encounter_types.search()

end event

type cb_ok from commandbutton within w_pick_encounter_type
integer x = 2409
integer y = 1588
integer width = 402
integer height = 112
integer taborder = 21
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

event clicked;long ll_row
string ls_encounter_type

if dw_encounter_types.mode = "EDIT" then
	close(parent)
	return
end if

ll_row = dw_encounter_types.get_selected_row()
if ll_row <= 0 then return

ls_encounter_type = dw_encounter_types.object.encounter_type[ll_row]

closewithreturn(parent, ls_encounter_type)


end event

type cb_new_encounter_type from commandbutton within w_pick_encounter_type
integer x = 1819
integer y = 1140
integer width = 727
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "New Encounter Type"
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

u_ds_data dw_char_key

popup.title = "Enter new Encounter Type description"

openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

ls_description = popup_return.items[1]
ls_base_encounter_type = f_gen_key_string(ls_description, 22)
dw_char_key = CREATE u_ds_data
dw_char_key.set_dataobject("dw_sp_get_char_key_resultset")
dw_char_key.retrieve("c_Encounter_Type", "encounter_type", ls_base_encounter_type)

ls_encounter_type = dw_char_key.object.new_key[1]
li_sort_sequence = 1

CHOOSE CASE dw_encounter_types.indirect_flag
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
	:dw_encounter_types.indirect_flag,
	:ls_button,
	:ls_icon,
	'OK' );
if not tf_check() then return

popup.data_row_count = 1
popup.items[1] = ls_encounter_type

openwithparm(w_encounter_type_definition, popup)

end event

type cb_cancel from commandbutton within w_pick_encounter_type
integer x = 1531
integer y = 1588
integer width = 352
integer height = 112
integer taborder = 31
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

event clicked;string ls_null

setnull(ls_null)

closewithreturn(parent, ls_null)
end event

type dw_encounter_types from u_dw_encounter_type_list within w_pick_encounter_type
integer x = 14
integer y = 108
integer width = 1413
integer height = 1576
integer taborder = 11
end type

event encounter_types_loaded;call super::encounter_types_loaded;
search_type = current_search

st_top_20.backcolor = color_object
st_description.backcolor = color_object

CHOOSE CASE indirect_flag
	CASE "D"
		st_mode_direct.backcolor = color_object_selected
		st_mode_indirect.backcolor = color_object
		st_mode_other.backcolor = color_object
	CASE "I"
		st_mode_direct.backcolor = color_object
		st_mode_indirect.backcolor = color_object_selected
		st_mode_other.backcolor = color_object
	CASE "N"
		st_mode_direct.backcolor = color_object
		st_mode_indirect.backcolor = color_object
		st_mode_other.backcolor = color_object_selected
END CHOOSE

st_search_status.text = ps_description

CHOOSE CASE current_search
	CASE "TOP20"
		st_top_20.backcolor = color_object_selected
	CASE "DESCRIPTION"
		st_description.backcolor = color_object_selected
END CHOOSE

set_page(1, pb_up, pb_down, st_page)

if mode = "PICK" then cb_ok.enabled = false

end event

event unselected;call super::unselected;if mode = "PICK" then cb_ok.enabled = false

end event

event selected;call super::selected;if mode = "PICK" then cb_ok.enabled = true

end event

type st_encounter_mode_title from statictext within w_pick_encounter_type
integer x = 1883
integer y = 236
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Encounter Mode"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_mode_indirect from statictext within w_pick_encounter_type
integer x = 2043
integer y = 328
integer width = 279
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Indirect"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_mode_direct.backcolor = color_object
st_mode_other.backcolor = color_object

dw_encounter_types.initialize("I")

dw_encounter_types.search()

end event

type st_mode_other from statictext within w_pick_encounter_type
integer x = 2391
integer y = 328
integer width = 279
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Other"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_mode_direct.backcolor = color_object
st_mode_indirect.backcolor = color_object

dw_encounter_types.initialize("N")

dw_encounter_types.search()

end event

