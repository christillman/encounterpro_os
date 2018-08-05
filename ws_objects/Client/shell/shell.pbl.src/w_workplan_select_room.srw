$PBExportHeader$w_workplan_select_room.srw
forward
global type w_workplan_select_room from w_window_base
end type
type pb_done from u_picture_button within w_workplan_select_room
end type
type pb_cancel from u_picture_button within w_workplan_select_room
end type
type st_title from statictext within w_workplan_select_room
end type
type st_room_type_title from statictext within w_workplan_select_room
end type
type dw_room from u_dw_pick_list within w_workplan_select_room
end type
type st_room_title from statictext within w_workplan_select_room
end type
type dw_room_type from u_dw_pick_list within w_workplan_select_room
end type
type st_office_title from statictext within w_workplan_select_room
end type
type st_office from statictext within w_workplan_select_room
end type
type cb_1 from commandbutton within w_workplan_select_room
end type
type pb_1 from u_pb_help_button within w_workplan_select_room
end type
end forward

global type w_workplan_select_room from w_window_base
integer x = 329
integer y = 96
integer width = 2213
integer height = 1668
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
st_room_type_title st_room_type_title
dw_room dw_room
st_room_title st_room_title
dw_room_type dw_room_type
st_office_title st_office_title
st_office st_office
cb_1 cb_1
pb_1 pb_1
end type
global w_workplan_select_room w_workplan_select_room

type variables
long workplan_id
integer step_number

u_ds_data step_rooms
string default_room_type

string viewed_office_id

end variables

forward prototypes
public subroutine set_default_room_type ()
public subroutine set_room (string ps_room_id)
end prototypes

public subroutine set_default_room_type ();string ls_find
long ll_row

dw_room.visible = false
st_room_title.visible = false

dw_room_type.clear_selected()

if isnull(default_room_type) then return

ls_find = "room_type='" + default_room_type + "'"
ll_row = dw_room_type.find(ls_find, 1, dw_room_type.rowcount())
if ll_row > 0 then
	dw_room_type.object.selected_flag[ll_row] = 1
end if

end subroutine

public subroutine set_room (string ps_room_id);string ls_find
long ll_row
string ls_room_type

dw_room.visible = true
st_room_title.visible = true


if isnull(ps_room_id) then
	ps_room_id = default_room_type
	ls_room_type = ps_room_id
else
	SELECT room_type
	INTO :ls_room_type
	FROM o_Rooms
	WHERE room_id = :ps_room_id;
	if not tf_check() then return
	if sqlca.sqlcode = 100 then ls_room_type = ps_room_id
end if


// First select the correct room_type
dw_room_type.clear_selected()
ls_find = "room_type='" + ls_room_type + "'"
ll_row = dw_room_type.find(ls_find, 1, dw_room_type.rowcount())
if ll_row > 0 then
	dw_room_type.object.selected_flag[ll_row] = 1
	dw_room_type.event trigger selected(ll_row)
end if


// Then selected the specific room
dw_room.clear_selected()
ls_find = "room_id='" + ps_room_id + "'"
ll_row = dw_room.find(ls_find, 1, dw_room.rowcount())
if ll_row > 0 then
	dw_room.object.selected_flag[ll_row] = 1
	dw_room.event trigger selected(ll_row)
end if



end subroutine

on w_workplan_select_room.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.st_room_type_title=create st_room_type_title
this.dw_room=create dw_room
this.st_room_title=create st_room_title
this.dw_room_type=create dw_room_type
this.st_office_title=create st_office_title
this.st_office=create st_office
this.cb_1=create cb_1
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_room_type_title
this.Control[iCurrent+5]=this.dw_room
this.Control[iCurrent+6]=this.st_room_title
this.Control[iCurrent+7]=this.dw_room_type
this.Control[iCurrent+8]=this.st_office_title
this.Control[iCurrent+9]=this.st_office
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.pb_1
end on

on w_workplan_select_room.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.st_room_type_title)
destroy(this.dw_room)
destroy(this.st_room_title)
destroy(this.dw_room_type)
destroy(this.st_office_title)
destroy(this.st_office)
destroy(this.cb_1)
destroy(this.pb_1)
end on

event open;call super::open;string ls_filter
str_popup popup

popup = message.powerobjectparm

if popup.data_row_count <> 3 then
	log.log(this, "w_workplan_select_room:open", "Invalid Parameters", 4)
	close(this)
	return
end if

step_rooms = popup.objectparm
workplan_id = long(popup.items[1])
step_number = integer(popup.items[2])
default_room_type = popup.items[3]

dw_room_type.settransobject(sqlca)
dw_room.settransobject(sqlca)

ls_filter = "workplan_id=" + string(workplan_id) + " and step_number=" + string(step_number)
step_rooms.setfilter(ls_filter)
step_rooms.filter()

dw_room_type.retrieve("")

setnull(viewed_office_id)
set_default_room_type()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_workplan_select_room
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_workplan_select_room
end type

type pb_done from u_picture_button within w_workplan_select_room
integer x = 1888
integer y = 1364
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;long ll_row
str_popup_return popup_return


popup_return.item_count = 1
popup_return.items[1] = default_room_type

step_rooms.setfilter("")
step_rooms.filter()

closewithreturn(parent, popup_return)



end event

type pb_cancel from u_picture_button within w_workplan_select_room
boolean visible = false
integer x = 69
integer y = 1364
integer taborder = 50
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_workplan_select_room
integer width = 2208
integer height = 132
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Select Room"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_room_type_title from statictext within w_workplan_select_room
integer x = 197
integer y = 336
integer width = 626
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Room Type"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_room from u_dw_pick_list within w_workplan_select_room
integer x = 1029
integer y = 420
integer width = 1152
integer height = 904
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_room_list_by_type_and_office"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_find
long ll_row

if isnull(viewed_office_id) then return

ls_find = "office_id='" + viewed_office_id + "'"
ll_row = step_rooms.find(ls_find, 1, step_rooms.rowcount())
if ll_row <= 0 then
	ll_row = step_rooms.insertrow(0)
	step_rooms.object.workplan_id[ll_row] = workplan_id
	step_rooms.object.step_number[ll_row] = step_number
	step_rooms.object.office_id[ll_row] = viewed_office_id
end if

step_rooms.object.room_id[ll_row] = object.room_id[selected_row]

end event

type st_room_title from statictext within w_workplan_select_room
integer x = 1143
integer y = 336
integer width = 745
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Specific Room"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_room_type from u_dw_pick_list within w_workplan_select_room
integer x = 197
integer y = 420
integer width = 722
integer height = 904
integer taborder = 40
boolean bringtotop = true
string dataobject = "dw_c_room_type"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;string ls_room_type
string ls_description
long ll_row

ls_room_type = object.room_type[selected_row]
ls_description = object.description[selected_row]

if isnull(viewed_office_id) then
	default_room_type = ls_room_type
else
	dw_room.retrieve(ls_room_type, viewed_office_id)
	ll_row = dw_room.insertrow(1)
	dw_room.object.room_name[ll_row] = "Any " + ls_description + " Room"
	dw_room.object.room_id[ll_row] = ls_room_type
	dw_room.object.selected_flag[ll_row] = 1
	dw_room.event trigger selected(ll_row)
end if


end event

type st_office_title from statictext within w_workplan_select_room
integer x = 448
integer y = 196
integer width = 311
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Office:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_office from statictext within w_workplan_select_room
integer x = 795
integer y = 184
integer width = 791
integer height = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "<Default Room Type>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
string ls_find
long ll_row
string ls_room_id

popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2
popup.add_blank_row = true
popup.blank_text = "<Default Room Type>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.descriptions[1]

if popup_return.items[1] = "" then
	setnull(viewed_office_id)
	set_default_room_type()
	return
end if

viewed_office_id = popup_return.items[1]

ls_find = "step_number=" + string(step_number) + " and office_id='" + viewed_office_id + "'"
ll_row = step_rooms.find(ls_find, 1, step_rooms.rowcount())
if ll_row > 0 then
	ls_room_id = step_rooms.object.room_id[ll_row]
else
	setnull(ls_room_id)
end if

set_room(ls_room_id)
	


end event

type cb_1 from commandbutton within w_workplan_select_room
integer x = 832
integer y = 1420
integer width = 544
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear Assignment"
end type

event clicked;string ls_find
long ll_row

dw_room_type.clear_selected()

if isnull(viewed_office_id) then
	setnull(default_room_type)
else
	ls_find = "office_id='" + viewed_office_id + "'"
	ll_row = step_rooms.find(ls_find, 1, step_rooms.rowcount())
	if ll_row > 0 then step_rooms.deleterow(ll_row)
	dw_room.clear_selected()
	dw_room.visible = false
end if


end event

type pb_1 from u_pb_help_button within w_workplan_select_room
integer x = 1618
integer y = 1476
integer taborder = 20
boolean bringtotop = true
end type

