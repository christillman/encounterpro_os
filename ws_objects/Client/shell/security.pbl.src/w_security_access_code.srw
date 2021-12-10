$PBExportHeader$w_security_access_code.srw
forward
global type w_security_access_code from window
end type
type st_sticky from statictext within w_security_access_code
end type
type st_sticky_title from statictext within w_security_access_code
end type
type st_prompt from statictext within w_security_access_code
end type
type cb_done from commandbutton within w_security_access_code
end type
type pb_cancel from u_picture_button within w_security_access_code
end type
type cb_clear from commandbutton within w_security_access_code
end type
type st_asterisks from statictext within w_security_access_code
end type
type cb_0 from commandbutton within w_security_access_code
end type
type cb_9 from commandbutton within w_security_access_code
end type
type cb_8 from commandbutton within w_security_access_code
end type
type cb_7 from commandbutton within w_security_access_code
end type
type cb_6 from commandbutton within w_security_access_code
end type
type cb_5 from commandbutton within w_security_access_code
end type
type cb_4 from commandbutton within w_security_access_code
end type
type cb_3 from commandbutton within w_security_access_code
end type
type cb_2 from commandbutton within w_security_access_code
end type
type cb_1 from commandbutton within w_security_access_code
end type
end forward

global type w_security_access_code from window
integer x = 1787
integer y = 120
integer width = 978
integer height = 1640
windowtype windowtype = response!
long backcolor = 7191717
st_sticky st_sticky
st_sticky_title st_sticky_title
st_prompt st_prompt
cb_done cb_done
pb_cancel pb_cancel
cb_clear cb_clear
st_asterisks st_asterisks
cb_0 cb_0
cb_9 cb_9
cb_8 cb_8
cb_7 cb_7
cb_6 cb_6
cb_5 cb_5
cb_4 cb_4
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
end type
global w_security_access_code w_security_access_code

type variables
string mode = "LOGON"
string access_id
boolean sticky_logon

boolean variable_password_length
integer password_length

end variables

forward prototypes
public subroutine number_pressed (string ps_number)
public subroutine logon ()
end prototypes

public subroutine number_pressed (string ps_number);access_id += ps_number
st_asterisks.text += "* "
if not variable_password_length and len(access_id) = password_length then logon()

end subroutine

public subroutine logon ();str_popup_return popup_return

popup_return.item_count = 2
popup_return.items[1] = access_id
popup_return.items[2] = f_boolean_to_string(sticky_logon)

closewithreturn(this, popup_return)


end subroutine

event open;str_popup popup
string ls_temp
integer li_logon_timeout
boolean lb_computer_secure

access_id = ""
st_asterisks.text = ""

popup = message.powerobjectparm

mode = popup.item
st_prompt.text = popup.title

ls_temp = f_get_global_preference("PREFERENCES", "variable_password_length")
lb_computer_secure = datalist.get_preference_boolean("PREFERENCES", "computer_secure", false) 
li_logon_timeout = datalist.get_preference_int("PREFERENCES", "logon_timeout", 15)

if lower(left(ls_temp, 1)) = "t" then
	variable_password_length = true
	password_length = 0
else
	variable_password_length = false
	password_length = f_get_global_preference_int("PREFERENCES", "password_length")
	if isnull(password_length) or password_length <= 0 then password_length = 3
end if

if not variable_password_length then
	st_sticky_title.y -= 168
	st_sticky.y -= 168
	height -= 168
	cb_done.visible = false
end if

if mode = "NOLOGON" or lb_computer_secure = false then
	st_sticky_title.visible = false
	st_sticky.visible = false
	height -= 188
end if

sticky_logon = false

if not isnull(main_window) and isvalid(main_window) then
	x = main_window.x + (main_window.width - width) / 2
	y = main_window.y + (main_window.height - height) / 2
end if

timer(li_logon_timeout, this)

end event

on timer;pb_cancel.triggerevent("clicked")

end on

on w_security_access_code.create
this.st_sticky=create st_sticky
this.st_sticky_title=create st_sticky_title
this.st_prompt=create st_prompt
this.cb_done=create cb_done
this.pb_cancel=create pb_cancel
this.cb_clear=create cb_clear
this.st_asterisks=create st_asterisks
this.cb_0=create cb_0
this.cb_9=create cb_9
this.cb_8=create cb_8
this.cb_7=create cb_7
this.cb_6=create cb_6
this.cb_5=create cb_5
this.cb_4=create cb_4
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.st_sticky,&
this.st_sticky_title,&
this.st_prompt,&
this.cb_done,&
this.pb_cancel,&
this.cb_clear,&
this.st_asterisks,&
this.cb_0,&
this.cb_9,&
this.cb_8,&
this.cb_7,&
this.cb_6,&
this.cb_5,&
this.cb_4,&
this.cb_3,&
this.cb_2,&
this.cb_1}
end on

on w_security_access_code.destroy
destroy(this.st_sticky)
destroy(this.st_sticky_title)
destroy(this.st_prompt)
destroy(this.cb_done)
destroy(this.pb_cancel)
destroy(this.cb_clear)
destroy(this.st_asterisks)
destroy(this.cb_0)
destroy(this.cb_9)
destroy(this.cb_8)
destroy(this.cb_7)
destroy(this.cb_6)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
end on

type st_sticky from statictext within w_security_access_code
integer x = 631
integer y = 1484
integer width = 233
integer height = 104
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

event clicked;if sticky_logon then
	text = "No"
	backcolor = color_object
	sticky_logon = false
else
	text = "Yes"
	backcolor = color_object_selected
	sticky_logon = true
end if

end event

type st_sticky_title from statictext within w_security_access_code
integer x = 78
integer y = 1496
integer width = 517
integer height = 76
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Stay Logged On:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_prompt from statictext within w_security_access_code
integer y = 8
integer width = 937
integer height = 84
integer textsize = -11
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_done from commandbutton within w_security_access_code
integer x = 64
integer y = 1196
integer width = 823
integer height = 216
integer taborder = 20
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
end type

event clicked;logon()

end event

type pb_cancel from u_picture_button within w_security_access_code
integer x = 64
integer y = 952
integer width = 256
integer height = 224
integer taborder = 10
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

setnull(popup_return.returnobject)
popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type cb_clear from commandbutton within w_security_access_code
integer x = 352
integer y = 952
integer width = 247
integer height = 216
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Clear"
end type

on clicked;access_id = ""
st_asterisks.text = ""

end on

type st_asterisks from statictext within w_security_access_code
integer y = 112
integer width = 937
integer height = 92
integer textsize = -20
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_0 from commandbutton within w_security_access_code
integer x = 640
integer y = 952
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&0"
end type

on clicked;number_pressed("0")

end on

type cb_9 from commandbutton within w_security_access_code
integer x = 640
integer y = 708
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&9"
end type

on clicked;number_pressed("9")

end on

type cb_8 from commandbutton within w_security_access_code
integer x = 352
integer y = 708
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&8"
end type

on clicked;number_pressed("8")

end on

type cb_7 from commandbutton within w_security_access_code
integer x = 64
integer y = 708
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&7"
end type

on clicked;number_pressed("7")

end on

type cb_6 from commandbutton within w_security_access_code
integer x = 640
integer y = 464
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&6"
end type

on clicked;number_pressed("6")

end on

type cb_5 from commandbutton within w_security_access_code
integer x = 352
integer y = 464
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&5"
end type

on clicked;number_pressed("5")

end on

type cb_4 from commandbutton within w_security_access_code
integer x = 64
integer y = 464
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&4"
end type

on clicked;number_pressed("4")

end on

type cb_3 from commandbutton within w_security_access_code
integer x = 640
integer y = 220
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&3"
end type

on clicked;number_pressed("3")

end on

type cb_2 from commandbutton within w_security_access_code
integer x = 352
integer y = 220
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&2"
end type

on clicked;number_pressed("2")

end on

type cb_1 from commandbutton within w_security_access_code
integer x = 64
integer y = 220
integer width = 247
integer height = 216
integer textsize = -24
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&1"
end type

on clicked;number_pressed("1")

end on

