$PBExportHeader$w_pop_document_routes.srw
forward
global type w_pop_document_routes from w_window_base
end type
type dw_routes from datawindow within w_pop_document_routes
end type
type cb_ok from commandbutton within w_pop_document_routes
end type
type st_title from statictext within w_pop_document_routes
end type
type st_message from statictext within w_pop_document_routes
end type
type st_routes_title from statictext within w_pop_document_routes
end type
end forward

global type w_pop_document_routes from w_window_base
integer width = 2766
integer height = 1548
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_routes dw_routes
cb_ok cb_ok
st_title st_title
st_message st_message
st_routes_title st_routes_title
end type
global w_pop_document_routes w_pop_document_routes

on w_pop_document_routes.create
int iCurrent
call super::create
this.dw_routes=create dw_routes
this.cb_ok=create cb_ok
this.st_title=create st_title
this.st_message=create st_message
this.st_routes_title=create st_routes_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_routes
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_message
this.Control[iCurrent+5]=this.st_routes_title
end on

on w_pop_document_routes.destroy
call super::destroy
destroy(this.dw_routes)
destroy(this.cb_ok)
destroy(this.st_title)
destroy(this.st_message)
destroy(this.st_routes_title)
end on

event open;call super::open;str_popup popup
long ll_count
string ls_report_id
string ls_ordered_by
string ls_ordered_for
string ls_purpose
string ls_cpr_id
string ls_message
string ls_actor_class

popup = message.powerobjectparm


ls_ordered_by = popup.items[1]
ls_ordered_for = popup.items[2]
ls_purpose = popup.items[3]
ls_cpr_id = popup.items[4]
setnull(ls_report_id)

if popup.data_row_count > 4 then
	ls_report_id = popup.items[5]
end if

ls_actor_class = user_list.user_property(ls_ordered_for, "actor_class")

ls_message = "Routes for sending " + wordcap(popup.items[3]) + " documents to " + ls_actor_class + " recipients"

if len(popup.title) > 0 then
	st_title.text = popup.title
	st_routes_title.text = ls_message
else
	st_routes_title.visible = false
	st_title.text = ls_message
	dw_routes.y -= 100
end if


dw_routes.settransobject( sqlca)
ll_count = dw_routes.retrieve(ls_ordered_by, ls_ordered_for, ls_purpose, ls_cpr_id, ls_report_id)
if ll_count < 0 then
	st_message.text = "Error getting document routes"
elseif ll_count = 0 then
	st_message.text = "No document routes available"
end if



if len(st_message.text) > 0 then
	st_message.visible = true
else
	st_message.visible = false
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_pop_document_routes
integer x = 2830
integer y = 0
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_document_routes
end type

type dw_routes from datawindow within w_pop_document_routes
integer x = 91
integer y = 368
integer width = 2555
integer height = 1048
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dw_document_available_routes"
boolean vscrollbar = true
boolean livescroll = true
end type

type cb_ok from commandbutton within w_pop_document_routes
integer x = 2395
integer y = 1432
integer width = 343
integer height = 92
integer taborder = 20
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

event clicked;close(parent)

end event

type st_title from statictext within w_pop_document_routes
integer width = 2740
integer height = 244
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Document Routes for xxxxxxx"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_message from statictext within w_pop_document_routes
integer x = 9
integer y = 1436
integer width = 2363
integer height = 96
boolean bringtotop = true
integer textsize = -16
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

type st_routes_title from statictext within w_pop_document_routes
integer y = 284
integer width = 2752
integer height = 72
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Document Routes for <purpose>"
alignment alignment = center!
boolean focusrectangle = false
end type

