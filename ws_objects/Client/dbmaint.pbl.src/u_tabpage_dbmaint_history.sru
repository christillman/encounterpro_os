$PBExportHeader$u_tabpage_dbmaint_history.sru
forward
global type u_tabpage_dbmaint_history from u_tabpage
end type
type dw_history from u_dw_pick_list within u_tabpage_dbmaint_history
end type
type pb_down from u_picture_button within u_tabpage_dbmaint_history
end type
type pb_up from u_picture_button within u_tabpage_dbmaint_history
end type
type st_page from statictext within u_tabpage_dbmaint_history
end type
type st_title from statictext within u_tabpage_dbmaint_history
end type
end forward

global type u_tabpage_dbmaint_history from u_tabpage
integer width = 2830
string text = "History"
dw_history dw_history
pb_down pb_down
pb_up pb_up
st_page st_page
st_title st_title
end type
global u_tabpage_dbmaint_history u_tabpage_dbmaint_history

on u_tabpage_dbmaint_history.create
int iCurrent
call super::create
this.dw_history=create dw_history
this.pb_down=create pb_down
this.pb_up=create pb_up
this.st_page=create st_page
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_history
this.Control[iCurrent+2]=this.pb_down
this.Control[iCurrent+3]=this.pb_up
this.Control[iCurrent+4]=this.st_page
this.Control[iCurrent+5]=this.st_title
end on

on u_tabpage_dbmaint_history.destroy
call super::destroy
destroy(this.dw_history)
destroy(this.pb_down)
destroy(this.pb_up)
destroy(this.st_page)
destroy(this.st_title)
end on

type dw_history from u_dw_pick_list within u_tabpage_dbmaint_history
integer x = 384
integer y = 180
integer width = 2112
integer height = 800
integer taborder = 10
string dataobject = "dw_database_action"
boolean border = false
end type

type pb_down from u_picture_button within u_tabpage_dbmaint_history
integer x = 2487
integer y = 316
integer width = 137
integer height = 116
integer taborder = 20
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;call super::clicked;integer li_page
integer li_last_page

li_page = dw_history.current_page
li_last_page = dw_history.last_page

dw_history.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true


end event

type pb_up from u_picture_button within u_tabpage_dbmaint_history
integer x = 2487
integer y = 184
integer width = 137
integer height = 116
integer taborder = 10
boolean bringtotop = true
boolean originalsize = false
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;call super::clicked;integer li_page

li_page = dw_history.current_page

dw_history.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true

end event

type st_page from statictext within u_tabpage_dbmaint_history
integer x = 2309
integer y = 108
integer width = 306
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Page 99/99"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within u_tabpage_dbmaint_history
integer x = 393
integer y = 68
integer width = 2057
integer height = 108
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Database Maintenance Operations"
alignment alignment = center!
boolean focusrectangle = false
end type

