$PBExportHeader$w_display_route_errors.srw
forward
global type w_display_route_errors from w_window_base
end type
type dw_errors from datawindow within w_display_route_errors
end type
type cb_done from commandbutton within w_display_route_errors
end type
type st_message from statictext within w_display_route_errors
end type
type st_title from statictext within w_display_route_errors
end type
type cbx_send_anyways from checkbox within w_display_route_errors
end type
end forward

global type w_display_route_errors from w_window_base
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean auto_resize_window = false
boolean auto_resize_objects = false
boolean nested_user_object_resize = false
dw_errors dw_errors
cb_done cb_done
st_message st_message
st_title st_title
cbx_send_anyways cbx_send_anyways
end type
global w_display_route_errors w_display_route_errors

on w_display_route_errors.create
int iCurrent
call super::create
this.dw_errors=create dw_errors
this.cb_done=create cb_done
this.st_message=create st_message
this.st_title=create st_title
this.cbx_send_anyways=create cbx_send_anyways
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_errors
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.st_message
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.cbx_send_anyways
end on

on w_display_route_errors.destroy
call super::destroy
destroy(this.dw_errors)
destroy(this.cb_done)
destroy(this.st_message)
destroy(this.st_title)
destroy(this.cbx_send_anyways)
end on

event open;call super::open;str_document_send_error_status lstr_document_send_error_status
str_document_send lstr_document_send
string ls_message
string ls_recipient
long ll_count
long i
string ls_allow_override

lstr_document_send = message.powerobjectparm


ls_message = "The following errors were reported in association with sending your document"

ls_recipient = user_list.user_full_name(lstr_document_send.ordered_for)
if len(ls_recipient) > 0 then
	ls_message += " to " + ls_recipient
end if

if len(lstr_document_send.document_route) > 0 then
	ls_message += " via " + lstr_document_send.document_route
end if

st_message.text = ls_message

dw_errors.settransobject(sqlca)
ll_count = dw_errors.retrieve(lstr_document_send.patient_workplan_item_id, lstr_document_send.ordered_for, lstr_document_send.document_route)
if ll_count <= 0 then
	lstr_document_send_error_status.error_count = 0
	closewithreturn(this, lstr_document_send_error_status)
	return
end if
for i = 1 to ll_count
	ls_allow_override = dw_errors.object.allow_override[i]
	if upper(ls_allow_override) = 'N' then
		cbx_send_anyways.visible = false
		exit
	end if
next


// Center this window over the main window
if isvalid(main_window) and not isnull(main_window) then
	x = main_window.x + ((main_window.width - width) / 2)
	y = main_window.y + ((main_window.height - height) / 2)
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_display_route_errors
integer x = 2857
integer y = 4
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_display_route_errors
end type

type dw_errors from datawindow within w_display_route_errors
integer x = 123
integer y = 556
integer width = 2647
integer height = 964
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "dw_jmj_check_document_route_errors"
boolean vscrollbar = true
boolean livescroll = true
end type

type cb_done from commandbutton within w_display_route_errors
integer x = 2359
integer y = 1596
integer width = 494
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;str_document_send_error_status lstr_document_send_error_status
long i
long ll_severity

lstr_document_send_error_status.error_count = dw_errors.rowcount()
lstr_document_send_error_status.send_anyways = cbx_send_anyways.checked

lstr_document_send_error_status.max_severity = 0
for i = 1 to lstr_document_send_error_status.error_count
	ll_severity = dw_errors.object.severity[i]
	if ll_severity > lstr_document_send_error_status.max_severity then
		lstr_document_send_error_status.max_severity = ll_severity
	end if
next

		

closewithreturn(parent, lstr_document_send_error_status)

end event

type st_message from statictext within w_display_route_errors
integer x = 123
integer y = 192
integer width = 2647
integer height = 272
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "The following errors were reported in association with sending your document"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_display_route_errors
integer width = 2921
integer height = 116
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Send Document Error"
alignment alignment = center!
boolean focusrectangle = false
end type

type cbx_send_anyways from checkbox within w_display_route_errors
integer x = 96
integer y = 1612
integer width = 1321
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Send Document anyways (Not Recommended)"
end type

