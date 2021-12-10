$PBExportHeader$w_new_db.srw
forward
global type w_new_db from w_window_full_response
end type
type st_4 from statictext within w_new_db
end type
type st_2 from statictext within w_new_db
end type
type st_3 from statictext within w_new_db
end type
type sle_server from singlelineedit within w_new_db
end type
type sle_db from singlelineedit within w_new_db
end type
type sle_dbms from singlelineedit within w_new_db
end type
type st_office_title from statictext within w_new_db
end type
type sle_office_id from singlelineedit within w_new_db
end type
end forward

global type w_new_db from w_window_full_response
integer x = 503
integer y = 176
integer width = 1353
integer height = 1368
string title = "Enter Billing Database Parameters"
st_4 st_4
st_2 st_2
st_3 st_3
sle_server sle_server
sle_db sle_db
sle_dbms sle_dbms
st_office_title st_office_title
sle_office_id sle_office_id
end type
global w_new_db w_new_db

type variables

end variables

on w_new_db.create
int iCurrent
call super::create
this.st_4=create st_4
this.st_2=create st_2
this.st_3=create st_3
this.sle_server=create sle_server
this.sle_db=create sle_db
this.sle_dbms=create sle_dbms
this.st_office_title=create st_office_title
this.sle_office_id=create sle_office_id
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.sle_server
this.Control[iCurrent+5]=this.sle_db
this.Control[iCurrent+6]=this.sle_dbms
this.Control[iCurrent+7]=this.st_office_title
this.Control[iCurrent+8]=this.sle_office_id
end on

on w_new_db.destroy
call super::destroy
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_server)
destroy(this.sle_db)
destroy(this.sle_dbms)
destroy(this.st_office_title)
destroy(this.sle_office_id)
end on

event open;str_popup popup



popup = message.powerobjectparm
if popup.data_row_count <> 4 then
//	sle_dbms.text = "SQL Native Client"
	sle_db.text = ""
	sle_server.text = ""
	sle_office_id.text = ""
else
//	sle_dbms.text = popup.items[1]
	sle_server.text = popup.items[2]
	sle_db.text = popup.items[3]
	sle_office_id.text = popup.items[4]
end if

sle_dbms.text = "SQL Native Client"


end event

type pb_epro_help from w_window_full_response`pb_epro_help within w_new_db
integer taborder = 50
end type

type st_config_mode_menu from w_window_full_response`st_config_mode_menu within w_new_db
end type

type pb_done from w_window_full_response`pb_done within w_new_db
integer x = 1029
integer y = 1016
integer taborder = 0
boolean default = true
end type

event pb_done::clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 4

popup_return.items[1] = sle_dbms.text
popup_return.items[2] = sle_server.text
popup_return.items[3] = sle_db.text
popup_return.items[4] = sle_office_id.text

closewithreturn(parent, popup_return)


end event

type pb_cancel from w_window_full_response`pb_cancel within w_new_db
integer x = 46
integer y = 1016
integer taborder = 0
end type

event pb_cancel::clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0


closewithreturn(parent, popup_return)


end event

type st_4 from statictext within w_new_db
integer x = 114
integer y = 88
integer width = 1111
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Server"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_new_db
integer x = 114
integer y = 304
integer width = 1111
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Database"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_new_db
integer x = 114
integer y = 736
integer width = 1111
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "DBMS"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_server from singlelineedit within w_new_db
integer x = 114
integer y = 164
integer width = 1111
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_db from singlelineedit within w_new_db
integer x = 114
integer y = 376
integer width = 1111
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_dbms from singlelineedit within w_new_db
integer x = 114
integer y = 800
integer width = 1111
integer height = 92
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "MSS"
end type

type st_office_title from statictext within w_new_db
integer x = 114
integer y = 520
integer width = 1111
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Office ID"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_office_id from singlelineedit within w_new_db
integer x = 114
integer y = 588
integer width = 1111
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

