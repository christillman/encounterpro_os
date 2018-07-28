$PBExportHeader$w_scan_letter.srw
$PBExportComments$Obsolete
forward
global type w_scan_letter from w_window_base
end type
type sle_description from singlelineedit within w_scan_letter
end type
type st_desc from statictext within w_scan_letter
end type
type st_title from statictext within w_scan_letter
end type
type pb_cancel from u_picture_button within w_scan_letter
end type
type pb_done from u_picture_button within w_scan_letter
end type
end forward

global type w_scan_letter from w_window_base
integer x = 430
integer y = 388
integer width = 2011
integer height = 988
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
sle_description sle_description
st_desc st_desc
st_title st_title
pb_cancel pb_cancel
pb_done pb_done
end type
global w_scan_letter w_scan_letter

type variables

end variables

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_title.text = popup.title
end event

on w_scan_letter.create
int iCurrent
call super::create
this.sle_description=create sle_description
this.st_desc=create st_desc
this.st_title=create st_title
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_description
this.Control[iCurrent+2]=this.st_desc
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.pb_cancel
this.Control[iCurrent+5]=this.pb_done
end on

on w_scan_letter.destroy
call super::destroy
destroy(this.sle_description)
destroy(this.st_desc)
destroy(this.st_title)
destroy(this.pb_cancel)
destroy(this.pb_done)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_scan_letter
end type

type sle_description from singlelineedit within w_scan_letter
integer x = 59
integer y = 284
integer width = 1893
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_desc from statictext within w_scan_letter
integer x = 69
integer y = 208
integer width = 352
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Description:"
boolean focusrectangle = false
end type

type st_title from statictext within w_scan_letter
integer width = 2007
integer height = 108
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_scan_letter
integer x = 73
integer y = 696
integer taborder = 0
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.item)
closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_scan_letter
integer x = 1669
integer y = 696
integer taborder = 20
boolean default = true
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

if trim(sle_description.text) = "" then
	open(w_pop_message, "You must enter a description")
	return
end if

popup_return.item = sle_description.text

closewithreturn(parent, popup_return)

end event

