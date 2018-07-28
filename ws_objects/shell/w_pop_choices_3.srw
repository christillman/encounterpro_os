HA$PBExportHeader$w_pop_choices_3.srw
forward
global type w_pop_choices_3 from w_window_base
end type
type cb_3 from commandbutton within w_pop_choices_3
end type
type st_title from statictext within w_pop_choices_3
end type
type cb_1 from commandbutton within w_pop_choices_3
end type
type cb_2 from commandbutton within w_pop_choices_3
end type
end forward

global type w_pop_choices_3 from w_window_base
integer x = 439
integer y = 592
integer width = 2377
integer height = 1176
boolean titlebar = false
string title = ""
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
cb_3 cb_3
st_title st_title
cb_1 cb_1
cb_2 cb_2
end type
global w_pop_choices_3 w_pop_choices_3

event open;call super::open;string ls_temp
str_popup popup

popup = message.powerobjectparm

if popup.data_row_count <> 3 then
	log.log(this, "open", "Invalid parameters", 4)
	close(this)
	return
end if

cb_1.text = popup.items[1]
cb_2.text = popup.items[2]
cb_3.text = popup.items[3]

if len(cb_1.text) > 35 then cb_1.textsize = -10
if len(cb_2.text) > 35 then cb_2.textsize = -10
if len(cb_3.text) > 35 then cb_3.textsize = -10

st_title.text = popup.title

end event

on w_pop_choices_3.create
int iCurrent
call super::create
this.cb_3=create cb_3
this.st_title=create st_title
this.cb_1=create cb_1
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.st_title
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cb_2
end on

on w_pop_choices_3.destroy
call super::destroy
destroy(this.cb_3)
destroy(this.st_title)
destroy(this.cb_1)
destroy(this.cb_2)
end on

type pb_epro_help from w_window_base`pb_epro_help within w_pop_choices_3
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_pop_choices_3
end type

type cb_3 from commandbutton within w_pop_choices_3
integer x = 507
integer y = 956
integer width = 1344
integer height = 108
integer taborder = 40
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Choice 3"
end type

event clicked;closewithreturn(parent, 3)

end event

type st_title from statictext within w_pop_choices_3
integer x = 160
integer y = 76
integer width = 2016
integer height = 460
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

type cb_1 from commandbutton within w_pop_choices_3
integer x = 507
integer y = 596
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

type cb_2 from commandbutton within w_pop_choices_3
integer x = 507
integer y = 776
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

