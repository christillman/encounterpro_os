$PBExportHeader$w_pop_choices_2.srw
forward
global type w_pop_choices_2 from w_window_base
end type
type st_title from statictext within w_pop_choices_2
end type
type cb_1 from commandbutton within w_pop_choices_2
end type
type cb_2 from commandbutton within w_pop_choices_2
end type
end forward

global type w_pop_choices_2 from w_window_base
integer x = 439
integer y = 592
integer width = 2377
integer height = 880
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
st_title st_title
cb_1 cb_1
cb_2 cb_2
end type
global w_pop_choices_2 w_pop_choices_2

type variables
long default_response

end variables

event open;call super::open;string ls_temp
str_popup popup
long ll_timeout

popup = message.powerobjectparm

if popup.data_row_count < 2 then
	log.log(this, "w_pop_choices_2:open", "Invalid parameters", 4)
	closewithreturn(this, 0)
	return
end if

if gnv_app.cpr_mode = "SERVER" then
	log.log(this, "w_pop_choices_2:open", "Invalid parameters", 4)
	closewithreturn(this, 0)
	return
end if

cb_1.text = popup.items[1]
cb_2.text = popup.items[2]

if popup.data_row_count >= 4 then
	default_response = long(popup.items[3])
	ll_timeout = long(popup.items[4])
else
	default_response = 1
	ll_timeout = 30
end if

timer(ll_timeout)

if len(cb_1.text) > 35 then cb_1.textsize = -10
if len(cb_2.text) > 35 then cb_2.textsize = -10

st_title.text = popup.title

end event

on w_pop_choices_2.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.cb_2
end on

on w_pop_choices_2.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_1)
destroy(this.cb_2)
end on

event timer;closewithreturn(this, default_response)

end event

type st_title from statictext within w_pop_choices_2
integer x = 160
integer y = 96
integer width = 2016
integer height = 348
integer textsize = -12
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

type cb_1 from commandbutton within w_pop_choices_2
integer x = 507
integer y = 504
integer width = 1344
integer height = 108
integer taborder = 20
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Choice 1"
end type

event clicked;closewithreturn(parent, 1)

end event

type cb_2 from commandbutton within w_pop_choices_2
integer x = 507
integer y = 684
integer width = 1344
integer height = 108
integer taborder = 30
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Choice 2"
end type

event clicked;closewithreturn(parent, 2)

end event

