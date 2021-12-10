$PBExportHeader$w_pick_room.srw
forward
global type w_pick_room from w_window_base
end type
type pb_up from u_picture_button within w_pick_room
end type
type pb_down from u_picture_button within w_pick_room
end type
type st_page from statictext within w_pick_room
end type
type st_title from statictext within w_pick_room
end type
type cb_ok from commandbutton within w_pick_room
end type
type cb_cancel from commandbutton within w_pick_room
end type
type st_1 from statictext within w_pick_room
end type
type pb_up_room from u_picture_button within w_pick_room
end type
type pb_down_room from u_picture_button within w_pick_room
end type
type st_page_room from statictext within w_pick_room
end type
type dw_office_pick from u_dw_pick_list within w_pick_room
end type
type dw_rooms from u_dw_pick_list within w_pick_room
end type
end forward

global type w_pick_room from w_window_base
integer height = 1836
boolean controlmenu = false
windowtype windowtype = response!
pb_up pb_up
pb_down pb_down
st_page st_page
st_title st_title
cb_ok cb_ok
cb_cancel cb_cancel
st_1 st_1
pb_up_room pb_up_room
pb_down_room pb_down_room
st_page_room st_page_room
dw_office_pick dw_office_pick
dw_rooms dw_rooms
end type
global w_pick_room w_pick_room

type variables
string pick_office_id

end variables

event open;call super::open;string ls_find
long ll_row
long ll_rowcount

dw_office_pick.settransobject(sqlca)
ll_rowcount = dw_office_pick.retrieve()

dw_rooms.settransobject(sqlca)

ls_find = "office_id='" + gnv_app.office_id + "'"
ll_row = dw_office_pick.find(ls_find, 1, ll_rowcount)
if ll_row < 1 then ll_row = 1

dw_office_pick.object.selected_flag[ll_row] = 1
pick_office_id = dw_office_pick.object.office_id[ll_row]

dw_rooms.retrieve(pick_office_id)

dw_office_pick.object.description.width = dw_office_pick.width - 46
dw_rooms.object.room_name.width = dw_rooms.width - 114

end event

on w_pick_room.create
int iCurrent
call super::create
this.pb_up=create pb_up
this.pb_down=create pb_down
this.st_page=create st_page
this.st_title=create st_title
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
this.st_1=create st_1
this.pb_up_room=create pb_up_room
this.pb_down_room=create pb_down_room
this.st_page_room=create st_page_room
this.dw_office_pick=create dw_office_pick
this.dw_rooms=create dw_rooms
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_up
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.st_page
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cb_ok
this.Control[iCurrent+6]=this.cb_cancel
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.pb_up_room
this.Control[iCurrent+9]=this.pb_down_room
this.Control[iCurrent+10]=this.st_page_room
this.Control[iCurrent+11]=this.dw_office_pick
this.Control[iCurrent+12]=this.dw_rooms
end on

on w_pick_room.destroy
call super::destroy
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.st_page)
destroy(this.st_title)
destroy(this.cb_ok)
destroy(this.cb_cancel)
destroy(this.st_1)
destroy(this.pb_up_room)
destroy(this.pb_down_room)
destroy(this.st_page_room)
destroy(this.dw_office_pick)
destroy(this.dw_rooms)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pick_room
boolean visible = true
integer x = 2629
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pick_room
integer x = 46
integer y = 1636
end type

type pb_up from u_picture_button within w_pick_room
integer x = 1166
integer y = 220
integer width = 137
integer height = 116
integer taborder = 20
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_office_pick.current_page

dw_office_pick.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type pb_down from u_picture_button within w_pick_room
integer x = 1166
integer y = 344
integer width = 137
integer height = 116
integer taborder = 10
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_office_pick.current_page
li_last_page = dw_office_pick.last_page

dw_office_pick.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true

end event

type st_page from statictext within w_pick_room
integer x = 1175
integer y = 464
integer width = 146
integer height = 128
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

type st_title from statictext within w_pick_room
integer x = 142
integer y = 116
integer width = 1024
integer height = 96
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Office"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_pick_room
integer x = 2322
integer y = 1568
integer width = 475
integer height = 112
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "OK"
boolean default = true
end type

event clicked;long ll_row
string ls_room_id
str_room lstr_room

ll_row = dw_rooms.get_selected_row()
if ll_row <= 0 then return

ls_room_id = dw_rooms.object.room_id[ll_row]
lstr_room = datalist.office_room(ls_room_id)
if isnull(lstr_room.room_id) then
	log.log(this, "w_pick_room.cb_ok.clicked:0011", "Room_id not found (" + ls_room_id + ")", 4)
	return
end if

closewithreturn(parent, lstr_room)


end event

type cb_cancel from commandbutton within w_pick_room
integer x = 82
integer y = 1568
integer width = 475
integer height = 112
integer taborder = 110
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

event clicked;str_room lstr_room

setnull(lstr_room.room_id)

closewithreturn(parent, lstr_room)


end event

type st_1 from statictext within w_pick_room
integer x = 1463
integer y = 120
integer width = 1024
integer height = 96
boolean bringtotop = true
integer textsize = -14
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Select Room"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up_room from u_picture_button within w_pick_room
integer x = 2583
integer y = 224
integer width = 137
integer height = 116
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_rooms.current_page

dw_rooms.set_page(li_page - 1, st_page_room.text)

if li_page <= 2 then enabled = false
pb_down_room.enabled = true

end event

type pb_down_room from u_picture_button within w_pick_room
integer x = 2583
integer y = 348
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_rooms.current_page
li_last_page = dw_rooms.last_page

dw_rooms.set_page(li_page + 1, st_page_room.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up_room.enabled = true

end event

type st_page_room from statictext within w_pick_room
integer x = 2592
integer y = 468
integer width = 146
integer height = 128
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

type dw_office_pick from u_dw_pick_list within w_pick_room
integer x = 128
integer y = 212
integer width = 1047
integer height = 1288
integer taborder = 11
string dataobject = "dw_office_pick"
boolean border = false
end type

event selected;call super::selected;
pick_office_id = object.office_id[selected_row]

dw_rooms.retrieve(pick_office_id)


end event

type dw_rooms from u_dw_pick_list within w_pick_room
integer x = 1454
integer y = 216
integer width = 1115
integer height = 1292
integer taborder = 21
string dataobject = "dw_room_list_office"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;cb_ok.enabled = true

end event

event unselected;call super::unselected;cb_ok.enabled = false

end event

