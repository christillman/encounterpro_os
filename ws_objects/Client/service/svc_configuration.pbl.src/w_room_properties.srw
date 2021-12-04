$PBExportHeader$w_room_properties.srw
forward
global type w_room_properties from w_window_base
end type
type sle_room_name from singlelineedit within w_room_properties
end type
type st_room_name_title from statictext within w_room_properties
end type
type st_title from statictext within w_room_properties
end type
type st_room_type from statictext within w_room_properties
end type
type st_room_type_title from statictext within w_room_properties
end type
type cb_cancel from commandbutton within w_room_properties
end type
type cb_ok from commandbutton within w_room_properties
end type
type st_clean from statictext within w_room_properties
end type
type st_dirty from statictext within w_room_properties
end type
type st_status_title from statictext within w_room_properties
end type
type st_status from statictext within w_room_properties
end type
type st_office from statictext within w_room_properties
end type
type st_office_title from statictext within w_room_properties
end type
type st_default_encounter_type from statictext within w_room_properties
end type
type st_encounter_type_title from statictext within w_room_properties
end type
type cb_clear_encounter_type from commandbutton within w_room_properties
end type
type st_dirty_flag_title from statictext within w_room_properties
end type
type st_dirty_flag_yes from statictext within w_room_properties
end type
type st_dirty_flag_no from statictext within w_room_properties
end type
type st_currently_title from statictext within w_room_properties
end type
type st_room_menu from statictext within w_room_properties
end type
type st_room_menu_title from statictext within w_room_properties
end type
type st_room_type_menu from statictext within w_room_properties
end type
type st_type_menu_title from statictext within w_room_properties
end type
type cb_clear_room_menu from commandbutton within w_room_properties
end type
type cb_clear_room_type_menu from commandbutton within w_room_properties
end type
end forward

global type w_room_properties from w_window_base
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_room_name sle_room_name
st_room_name_title st_room_name_title
st_title st_title
st_room_type st_room_type
st_room_type_title st_room_type_title
cb_cancel cb_cancel
cb_ok cb_ok
st_clean st_clean
st_dirty st_dirty
st_status_title st_status_title
st_status st_status
st_office st_office
st_office_title st_office_title
st_default_encounter_type st_default_encounter_type
st_encounter_type_title st_encounter_type_title
cb_clear_encounter_type cb_clear_encounter_type
st_dirty_flag_title st_dirty_flag_title
st_dirty_flag_yes st_dirty_flag_yes
st_dirty_flag_no st_dirty_flag_no
st_currently_title st_currently_title
st_room_menu st_room_menu
st_room_menu_title st_room_menu_title
st_room_type_menu st_room_type_menu
st_type_menu_title st_type_menu_title
cb_clear_room_menu cb_clear_room_menu
cb_clear_room_type_menu cb_clear_room_type_menu
end type
global w_room_properties w_room_properties

type variables
str_room room

boolean changed

long room_menu_id
long room_type_menu_id

string room_menu_context = "Room Checkin"
end variables

forward prototypes
public function integer refresh ()
public function integer update_room ()
end prototypes

public function integer refresh ();

sle_room_name.text = room.room_name

SELECT description
INTO :st_room_type.text
FROM c_Room_Type
WHERE room_type = :room.room_type;
if not tf_check() then return -1

if len(room.office_id) > 0 then
	st_office.text = datalist.office_description(room.office_id)
else
	st_office.text = ""
end if

if len(room.default_encounter_type) > 0 then
	st_default_encounter_type.text = datalist.encounter_type_description(room.default_encounter_type)
	cb_clear_encounter_type.visible = true
else
	st_default_encounter_type.text = ""
	cb_clear_encounter_type.visible = false
end if

if room.status = "OK" then
	st_status.text = "Active"
else
	st_status.text = "Inactive"
end if

if room.dirty_flag = "Y" then
	st_dirty_flag_yes.backcolor = color_object_selected
	st_dirty_flag_no.backcolor = color_object
	st_currently_title.visible = true
	st_clean.visible = true
	st_dirty.visible = true
	if room.room_status = "OK" then
		st_clean.backcolor = color_object_selected
		st_dirty.backcolor = color_object
	else
		st_clean.backcolor = color_object
		st_dirty.backcolor = color_object_selected
	end if
else
	st_dirty_flag_no.backcolor = color_object_selected
	st_dirty_flag_yes.backcolor = color_object
	st_currently_title.visible = false
	st_clean.visible = false
	st_dirty.visible = false
end if

if isnull(room_menu_id) then
	st_room_menu.text = "N/A"
else
	st_room_menu.text = datalist.menu_description(room_menu_id)
end if
if isnull(room_type_menu_id) then
	st_room_type_menu.text = "N/A"
else
	st_room_type_menu.text = datalist.menu_description(room_type_menu_id)
end if


return 1


end function

public function integer update_room ();string ls_null

setnull(ls_null)

UPDATE r
SET room_name = :room.room_name,
	room_sequence = :room.room_sequence,
	room_type = :room.room_type,
	room_status = :room.room_status,
	computer_id = :room.computer_id,
	office_id = :room.office_id,
	status = :room.status,
	default_encounter_type = :room.default_encounter_type,
	dirty_flag = :room.dirty_flag
FROM o_Rooms r
WHERE room_id = :room.room_id;
if not tf_check() then return -1

// Save the menu selections

sqlca.jmj_set_menu_selection(room_menu_context, room.room_id, ls_null, ls_null, room_menu_id)
if not tf_check() then return -1

sqlca.jmj_set_menu_selection(room_menu_context, room.room_type, ls_null, ls_null, room_type_menu_id)
if not tf_check() then return -1

return 1



end function

event open;call super::open;string ls_room_id

ls_room_id = message.stringparm

if isnull(ls_room_id) then
	log.log(this, "w_room_properties:open", "NULL room_id", 4)
	close(this)
	return
end if

room = datalist.get_room(ls_room_id)
if isnull(room.room_id) or trim(room.room_id) = "" then
	log.log(this, "w_room_properties:open", "Invalid room_id(" + ls_room_id + ")", 4)
	close(this)
	return
end if


room_menu_id = f_get_context_menu(room_menu_context, room.room_id)
room_type_menu_id = f_get_context_menu(room_menu_context, room.room_type)


refresh()

end event

on w_room_properties.create
int iCurrent
call super::create
this.sle_room_name=create sle_room_name
this.st_room_name_title=create st_room_name_title
this.st_title=create st_title
this.st_room_type=create st_room_type
this.st_room_type_title=create st_room_type_title
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.st_clean=create st_clean
this.st_dirty=create st_dirty
this.st_status_title=create st_status_title
this.st_status=create st_status
this.st_office=create st_office
this.st_office_title=create st_office_title
this.st_default_encounter_type=create st_default_encounter_type
this.st_encounter_type_title=create st_encounter_type_title
this.cb_clear_encounter_type=create cb_clear_encounter_type
this.st_dirty_flag_title=create st_dirty_flag_title
this.st_dirty_flag_yes=create st_dirty_flag_yes
this.st_dirty_flag_no=create st_dirty_flag_no
this.st_currently_title=create st_currently_title
this.st_room_menu=create st_room_menu
this.st_room_menu_title=create st_room_menu_title
this.st_room_type_menu=create st_room_type_menu
this.st_type_menu_title=create st_type_menu_title
this.cb_clear_room_menu=create cb_clear_room_menu
this.cb_clear_room_type_menu=create cb_clear_room_type_menu
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_room_name
this.Control[iCurrent+2]=this.st_room_name_title
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_room_type
this.Control[iCurrent+5]=this.st_room_type_title
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.cb_ok
this.Control[iCurrent+8]=this.st_clean
this.Control[iCurrent+9]=this.st_dirty
this.Control[iCurrent+10]=this.st_status_title
this.Control[iCurrent+11]=this.st_status
this.Control[iCurrent+12]=this.st_office
this.Control[iCurrent+13]=this.st_office_title
this.Control[iCurrent+14]=this.st_default_encounter_type
this.Control[iCurrent+15]=this.st_encounter_type_title
this.Control[iCurrent+16]=this.cb_clear_encounter_type
this.Control[iCurrent+17]=this.st_dirty_flag_title
this.Control[iCurrent+18]=this.st_dirty_flag_yes
this.Control[iCurrent+19]=this.st_dirty_flag_no
this.Control[iCurrent+20]=this.st_currently_title
this.Control[iCurrent+21]=this.st_room_menu
this.Control[iCurrent+22]=this.st_room_menu_title
this.Control[iCurrent+23]=this.st_room_type_menu
this.Control[iCurrent+24]=this.st_type_menu_title
this.Control[iCurrent+25]=this.cb_clear_room_menu
this.Control[iCurrent+26]=this.cb_clear_room_type_menu
end on

on w_room_properties.destroy
call super::destroy
destroy(this.sle_room_name)
destroy(this.st_room_name_title)
destroy(this.st_title)
destroy(this.st_room_type)
destroy(this.st_room_type_title)
destroy(this.cb_cancel)
destroy(this.cb_ok)
destroy(this.st_clean)
destroy(this.st_dirty)
destroy(this.st_status_title)
destroy(this.st_status)
destroy(this.st_office)
destroy(this.st_office_title)
destroy(this.st_default_encounter_type)
destroy(this.st_encounter_type_title)
destroy(this.cb_clear_encounter_type)
destroy(this.st_dirty_flag_title)
destroy(this.st_dirty_flag_yes)
destroy(this.st_dirty_flag_no)
destroy(this.st_currently_title)
destroy(this.st_room_menu)
destroy(this.st_room_menu_title)
destroy(this.st_room_type_menu)
destroy(this.st_type_menu_title)
destroy(this.cb_clear_room_menu)
destroy(this.cb_clear_room_type_menu)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_room_properties
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_room_properties
integer x = 59
integer y = 1612
end type

type sle_room_name from singlelineedit within w_room_properties
integer x = 1001
integer y = 248
integer width = 1486
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

event modified;
if len(text) > 0 then
	room.room_name = text
else
	openwithparm(w_pop_message, "The room name must not be empty")
	text = room.room_name
	return
end if

changed = true
refresh()



end event

type st_room_name_title from statictext within w_room_properties
integer x = 562
integer y = 264
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Room Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_room_properties
integer width = 2926
integer height = 144
boolean bringtotop = true
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Room Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_room_type from statictext within w_room_properties
integer x = 1001
integer y = 504
integer width = 1486
integer height = 104
integer taborder = 60
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

popup.dataobject = "dw_c_room_type"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return


room.room_type = popup_return.items[1]
text = popup_return.descriptions[1]

changed = true
refresh()


end event

type st_room_type_title from statictext within w_room_properties
integer x = 562
integer y = 520
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Room Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_room_properties
integer x = 50
integer y = 1668
integer width = 402
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

if changed then
	openwithparm(w_pop_yes_no, "Are you sure you wish exit without saving your changes?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

setnull(popup_return.item)
popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_ok from commandbutton within w_room_properties
integer x = 2464
integer y = 1668
integer width = 402
integer height = 112
integer taborder = 41
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

if changed then
	li_sts = update_room()
	if li_sts <= 0 then
		openwithparm(w_pop_message, "Error saving room data")
		return
	end if
end if


close(parent)

end event

type st_clean from statictext within w_room_properties
integer x = 1765
integer y = 1408
integer width = 357
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Clean"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;room.room_status = "OK"

changed = true
refresh()

end event

type st_dirty from statictext within w_room_properties
integer x = 2149
integer y = 1408
integer width = 357
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Dirty"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;room.room_status = "DIRTY"

changed = true
refresh()

end event

type st_status_title from statictext within w_room_properties
integer x = 507
integer y = 1212
integer width = 453
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Room Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_status from statictext within w_room_properties
integer x = 1001
integer y = 1196
integer width = 576
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Active"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if room.status = "OK" then
	room.status = "NA"
else
	room.status = "OK"
end if

changed = true
refresh()

end event

type st_office from statictext within w_room_properties
integer x = 1001
integer y = 800
integer width = 946
integer height = 104
integer taborder = 60
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

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]
room.office_id = popup_return.items[1]

changed = true
refresh()

end event

type st_office_title from statictext within w_room_properties
integer x = 562
integer y = 816
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Office:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_default_encounter_type from statictext within w_room_properties
integer x = 1001
integer y = 984
integer width = 1486
integer height = 104
integer taborder = 60
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
string ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = "I"

openwithparm(w_pick_encounter_type, popup)
ls_encounter_type = message.stringparm
if isnull(ls_encounter_type) then return

room.default_encounter_type = ls_encounter_type

changed = true
refresh()


end event

type st_encounter_type_title from statictext within w_room_properties
integer x = 160
integer y = 1000
integer width = 800
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Default Encounter Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_clear_encounter_type from commandbutton within w_room_properties
integer x = 2496
integer y = 1020
integer width = 242
integer height = 68
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(room.default_encounter_type)

changed = true
refresh()

end event

type st_dirty_flag_title from statictext within w_room_properties
integer x = 457
integer y = 1424
integer width = 503
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Auto Dirty Room:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_dirty_flag_yes from statictext within w_room_properties
integer x = 1001
integer y = 1408
integer width = 165
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;room.dirty_flag = "Y"

changed = true
refresh()

end event

type st_dirty_flag_no from statictext within w_room_properties
integer x = 1207
integer y = 1408
integer width = 165
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;room.dirty_flag = "N"

changed = true
refresh()

end event

type st_currently_title from statictext within w_room_properties
integer x = 1440
integer y = 1424
integer width = 306
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Currently:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_room_menu from statictext within w_room_properties
integer x = 1001
integer y = 352
integer width = 1486
integer height = 84
integer taborder = 60
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
w_window_base lw_pick

openwithparm(lw_pick, "General", "w_pick_menu")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

text = popup_return.descriptions[1]
room_menu_id = long(popup_return.items[1])

changed = true
refresh()


end event

type st_room_menu_title from statictext within w_room_properties
integer x = 562
integer y = 356
integer width = 398
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Room Menu:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_room_type_menu from statictext within w_room_properties
integer x = 1001
integer y = 620
integer width = 1486
integer height = 84
integer taborder = 60
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
w_window_base lw_pick

openwithparm(lw_pick, "General", "w_pick_menu")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

text = popup_return.descriptions[1]
room_type_menu_id = long(popup_return.items[1])

changed = true
refresh()


end event

type st_type_menu_title from statictext within w_room_properties
integer x = 366
integer y = 624
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Room Type Menu:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_clear_room_menu from commandbutton within w_room_properties
integer x = 2496
integer y = 368
integer width = 242
integer height = 68
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(room_menu_id)

changed = true
refresh()

end event

type cb_clear_room_type_menu from commandbutton within w_room_properties
integer x = 2496
integer y = 636
integer width = 242
integer height = 68
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(room_type_menu_id)

changed = true
refresh()

end event

