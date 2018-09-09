$PBExportHeader$w_scan_control.srw
$PBExportComments$obsolete
forward
global type w_scan_control from w_window_base
end type
type cb_preview from commandbutton within w_scan_control
end type
type pb_cancel from u_picture_button within w_scan_control
end type
type cb_scan_multiple from commandbutton within w_scan_control
end type
end forward

global type w_scan_control from w_window_base
integer x = 430
integer y = 388
integer width = 2011
integer height = 340
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_preview cb_preview
pb_cancel pb_cancel
cb_scan_multiple cb_scan_multiple
end type
global w_scan_control w_scan_control

type variables
u_component_attachment attachment_image
boolean append_flag

end variables

event open;call super::open;str_popup popup

popup = message.powerobjectparm

attachment_image = popup.objectparm
if popup.item = "APPEND" then
	append_flag = true
else
	append_flag = false
end if

end event

on w_scan_control.create
int iCurrent
call super::create
this.cb_preview=create cb_preview
this.pb_cancel=create pb_cancel
this.cb_scan_multiple=create cb_scan_multiple
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_preview
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.cb_scan_multiple
end on

on w_scan_control.destroy
call super::destroy
destroy(this.cb_preview)
destroy(this.pb_cancel)
destroy(this.cb_scan_multiple)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_scan_control
end type

type cb_preview from commandbutton within w_scan_control
integer x = 631
integer y = 116
integer width = 457
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Scan Preview"
end type

event clicked;//attachment_image.preview()

end event

type pb_cancel from u_picture_button within w_scan_control
integer x = 69
integer y = 60
integer taborder = 0
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "CANCEL"

closewithreturn(parent, popup_return)

end event

type cb_scan_multiple from commandbutton within w_scan_control
event clicked pbm_bnclicked
integer x = 1435
integer y = 116
integer width = 457
integer height = 108
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Scan Pages"
end type

event clicked;//str_popup_return popup_return
//integer li_sts
//
//li_sts = attachment_image.scan(true, append_flag)
//if li_sts > 0 then
//	popup_return.item_count = 1
//	popup_return.items[1] = "SCANNED"
//	closewithreturn(parent, popup_return)
//end if
//
end event

