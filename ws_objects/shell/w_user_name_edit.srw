HA$PBExportHeader$w_user_name_edit.srw
forward
global type w_user_name_edit from window
end type
type st_degree_title from statictext within w_user_name_edit
end type
type sle_degree from singlelineedit within w_user_name_edit
end type
type st_name_suffix_title from statictext within w_user_name_edit
end type
type sle_name_suffix from singlelineedit within w_user_name_edit
end type
type st_name_prefix_title from statictext within w_user_name_edit
end type
type sle_name_prefix from singlelineedit within w_user_name_edit
end type
type sle_middle_name from singlelineedit within w_user_name_edit
end type
type st_middle_name_title from statictext within w_user_name_edit
end type
type sle_first_name from singlelineedit within w_user_name_edit
end type
type st_first_name_title from statictext within w_user_name_edit
end type
type st_last_name_title from statictext within w_user_name_edit
end type
type st_title from statictext within w_user_name_edit
end type
type cb_cancel from commandbutton within w_user_name_edit
end type
type cb_finished from commandbutton within w_user_name_edit
end type
type sle_last_name from singlelineedit within w_user_name_edit
end type
end forward

global type w_user_name_edit from window
integer x = 649
integer y = 252
integer width = 1586
integer height = 1264
boolean titlebar = true
string title = "Import Selected Files"
windowtype windowtype = response!
long backcolor = 33538240
event postopen ( )
st_degree_title st_degree_title
sle_degree sle_degree
st_name_suffix_title st_name_suffix_title
sle_name_suffix sle_name_suffix
st_name_prefix_title st_name_prefix_title
sle_name_prefix sle_name_prefix
sle_middle_name sle_middle_name
st_middle_name_title st_middle_name_title
sle_first_name sle_first_name
st_first_name_title st_first_name_title
st_last_name_title st_last_name_title
st_title st_title
cb_cancel cb_cancel
cb_finished cb_finished
sle_last_name sle_last_name
end type
global w_user_name_edit w_user_name_edit

type variables
str_actor_name actor_name
str_actor_name original_actor_name

boolean changed = false

end variables

on w_user_name_edit.create
this.st_degree_title=create st_degree_title
this.sle_degree=create sle_degree
this.st_name_suffix_title=create st_name_suffix_title
this.sle_name_suffix=create sle_name_suffix
this.st_name_prefix_title=create st_name_prefix_title
this.sle_name_prefix=create sle_name_prefix
this.sle_middle_name=create sle_middle_name
this.st_middle_name_title=create st_middle_name_title
this.sle_first_name=create sle_first_name
this.st_first_name_title=create st_first_name_title
this.st_last_name_title=create st_last_name_title
this.st_title=create st_title
this.cb_cancel=create cb_cancel
this.cb_finished=create cb_finished
this.sle_last_name=create sle_last_name
this.Control[]={this.st_degree_title,&
this.sle_degree,&
this.st_name_suffix_title,&
this.sle_name_suffix,&
this.st_name_prefix_title,&
this.sle_name_prefix,&
this.sle_middle_name,&
this.st_middle_name_title,&
this.sle_first_name,&
this.st_first_name_title,&
this.st_last_name_title,&
this.st_title,&
this.cb_cancel,&
this.cb_finished,&
this.sle_last_name}
end on

on w_user_name_edit.destroy
destroy(this.st_degree_title)
destroy(this.sle_degree)
destroy(this.st_name_suffix_title)
destroy(this.sle_name_suffix)
destroy(this.st_name_prefix_title)
destroy(this.sle_name_prefix)
destroy(this.sle_middle_name)
destroy(this.st_middle_name_title)
destroy(this.sle_first_name)
destroy(this.st_first_name_title)
destroy(this.st_last_name_title)
destroy(this.st_title)
destroy(this.cb_cancel)
destroy(this.cb_finished)
destroy(this.sle_last_name)
end on

event open;
actor_name = message.powerobjectparm
original_actor_name = actor_name
original_actor_name.changed = false

if len(actor_name.edit_screen_title) > 0 then
	st_title.text = actor_name.edit_screen_title
elseif len(actor_name.actor_class) > 0 then
	st_title.text = wordcap(actor_name.actor_class) + " Name"
else
	st_title.text = "User Name"
end if


sle_last_name.text = actor_name.last_name
sle_first_name.text = actor_name.first_name
sle_middle_name.text = actor_name.middle_name
sle_name_prefix.text = actor_name.name_prefix
sle_name_suffix.text = actor_name.name_suffix
sle_degree.text = actor_name.degree


end event

type st_degree_title from statictext within w_user_name_edit
integer x = 78
integer y = 860
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Degree:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_degree from singlelineedit within w_user_name_edit
integer x = 507
integer y = 844
integer width = 1001
integer height = 108
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true

end event

type st_name_suffix_title from statictext within w_user_name_edit
integer x = 78
integer y = 732
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Name Suffix:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_suffix from singlelineedit within w_user_name_edit
integer x = 507
integer y = 716
integer width = 1001
integer height = 108
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true

end event

type st_name_prefix_title from statictext within w_user_name_edit
integer x = 78
integer y = 604
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Name Prefix:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_prefix from singlelineedit within w_user_name_edit
integer x = 507
integer y = 588
integer width = 1001
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true

end event

type sle_middle_name from singlelineedit within w_user_name_edit
integer x = 507
integer y = 460
integer width = 1001
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true

end event

type st_middle_name_title from statictext within w_user_name_edit
integer x = 69
integer y = 476
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Middle Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_first_name from singlelineedit within w_user_name_edit
integer x = 507
integer y = 332
integer width = 1001
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true

end event

type st_first_name_title from statictext within w_user_name_edit
integer x = 78
integer y = 348
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "First Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_last_name_title from statictext within w_user_name_edit
integer x = 78
integer y = 220
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Last Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_title from statictext within w_user_name_edit
integer width = 1618
integer height = 120
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "User Name"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_user_name_edit
integer x = 64
integer y = 1028
integer width = 402
integer height = 112
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
end type

event clicked;closewithreturn(parent, original_actor_name)

end event

type cb_finished from commandbutton within w_user_name_edit
integer x = 1019
integer y = 1028
integer width = 517
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;

if len(trim(sle_last_name.text)) > 0 then
	actor_name.last_name = trim(sle_last_name.text)
else
	setnull(actor_name.last_name)
end if
	
if len(trim(sle_first_name.text)) > 0 then
	actor_name.first_name = trim(sle_first_name.text)
else
	setnull(actor_name.first_name)
end if
	
if len(trim(sle_middle_name.text)) > 0 then
	actor_name.middle_name = trim(sle_middle_name.text)
else
	setnull(actor_name.middle_name)
end if
	
if len(trim(sle_name_prefix.text)) > 0 then
	actor_name.name_prefix = trim(sle_name_prefix.text)
else
	setnull(actor_name.name_prefix)
end if
	
if len(trim(sle_name_suffix.text)) > 0 then
	actor_name.name_suffix = trim(sle_name_suffix.text)
else
	setnull(actor_name.name_suffix)
end if
	
if len(trim(sle_degree.text)) > 0 then
	actor_name.degree = trim(sle_degree.text)
else
	setnull(actor_name.degree)
end if

actor_name.changed = changed

closewithreturn(parent, actor_name)

end event

type sle_last_name from singlelineedit within w_user_name_edit
integer x = 507
integer y = 204
integer width = 1001
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;changed = true

end event

