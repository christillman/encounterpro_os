HA$PBExportHeader$w_display_large_string.srw
forward
global type w_display_large_string from w_window_base
end type
type pb_help from u_pb_help_button within w_display_large_string
end type
type pb_done from u_picture_button within w_display_large_string
end type
type pb_cancel from u_picture_button within w_display_large_string
end type
type mle_large_string from multilineedit within w_display_large_string
end type
type st_title from statictext within w_display_large_string
end type
end forward

global type w_display_large_string from w_window_base
integer x = 0
integer y = 0
integer width = 2926
integer height = 1832
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 33538240
pb_help pb_help
pb_done pb_done
pb_cancel pb_cancel
mle_large_string mle_large_string
st_title st_title
end type
global w_display_large_string w_display_large_string

type variables
string cpr_id
long encounter_id
string observation_type
string observation_category_id




end variables

on w_display_large_string.create
int iCurrent
call super::create
this.pb_help=create pb_help
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.mle_large_string=create mle_large_string
this.st_title=create st_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_help
this.Control[iCurrent+2]=this.pb_done
this.Control[iCurrent+3]=this.pb_cancel
this.Control[iCurrent+4]=this.mle_large_string
this.Control[iCurrent+5]=this.st_title
end on

on w_display_large_string.destroy
call super::destroy
destroy(this.pb_help)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.mle_large_string)
destroy(this.st_title)
end on

event open;call super::open;str_popup popup
integer li_sts

popup = message.powerobjectparm

if popup.data_row_count <> 1 then
	log.log(this, "open", "Invalid Parameters", 4)
	close(this)
	return
end if

st_title.text = popup.title
mle_large_string.text = popup.items[1]

end event

type pb_help from u_pb_help_button within w_display_large_string
integer x = 2615
integer y = 8
end type

type pb_done from u_picture_button within w_display_large_string
integer x = 2569
integer y = 1552
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;close(parent)

end event

type pb_cancel from u_picture_button within w_display_large_string
boolean visible = false
integer x = 82
integer y = 1552
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

type mle_large_string from multilineedit within w_display_large_string
integer x = 37
integer y = 176
integer width = 2807
integer height = 1332
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_title from statictext within w_display_large_string
integer x = 32
integer y = 4
integer width = 2807
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

