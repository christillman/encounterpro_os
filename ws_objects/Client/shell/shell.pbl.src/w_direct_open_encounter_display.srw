$PBExportHeader$w_direct_open_encounter_display.srw
forward
global type w_direct_open_encounter_display from w_window_base
end type
type st_title from statictext within w_direct_open_encounter_display
end type
type cb_no from commandbutton within w_direct_open_encounter_display
end type
type cb_yes from commandbutton within w_direct_open_encounter_display
end type
type st_question from statictext within w_direct_open_encounter_display
end type
type dw_open_encounters from u_dw_pick_list within w_direct_open_encounter_display
end type
type pb_done from u_picture_button within w_direct_open_encounter_display
end type
type pb_cancel from u_picture_button within w_direct_open_encounter_display
end type
type st_statement from statictext within w_direct_open_encounter_display
end type
type pb_1 from u_pb_help_button within w_direct_open_encounter_display
end type
end forward

global type w_direct_open_encounter_display from w_window_base
integer x = 347
integer y = 272
integer width = 2213
integer height = 1440
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 33538240
st_title st_title
cb_no cb_no
cb_yes cb_yes
st_question st_question
dw_open_encounters dw_open_encounters
pb_done pb_done
pb_cancel pb_cancel
st_statement st_statement
pb_1 pb_1
end type
global w_direct_open_encounter_display w_direct_open_encounter_display

type variables
string new_flag
string sex
long age_range_id

end variables

on w_direct_open_encounter_display.create
int iCurrent
call super::create
this.st_title=create st_title
this.cb_no=create cb_no
this.cb_yes=create cb_yes
this.st_question=create st_question
this.dw_open_encounters=create dw_open_encounters
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_statement=create st_statement
this.pb_1=create pb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_title
this.Control[iCurrent+2]=this.cb_no
this.Control[iCurrent+3]=this.cb_yes
this.Control[iCurrent+4]=this.st_question
this.Control[iCurrent+5]=this.dw_open_encounters
this.Control[iCurrent+6]=this.pb_done
this.Control[iCurrent+7]=this.pb_cancel
this.Control[iCurrent+8]=this.st_statement
this.Control[iCurrent+9]=this.pb_1
end on

on w_direct_open_encounter_display.destroy
call super::destroy
destroy(this.st_title)
destroy(this.cb_no)
destroy(this.cb_yes)
destroy(this.st_question)
destroy(this.dw_open_encounters)
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_statement)
destroy(this.pb_1)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_count

popup = message.powerobjectparm

popup_return.item_count = 0

if popup.data_row_count <> 1 then
	log.log(this, "w_direct_open_encounter_display:open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

st_title.text = popup.title

dw_open_encounters.settransobject(sqlca)
li_count = dw_open_encounters.retrieve(popup.items[1])

if li_count <= 0 then
	popup_return.item_count = 1
	popup_return.items[1] = "0"
	closewithreturn(this, popup_return)
	return
end if


end event

type st_title from statictext within w_direct_open_encounter_display
integer width = 2213
integer height = 112
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_no from commandbutton within w_direct_open_encounter_display
integer x = 1175
integer y = 1220
integer width = 411
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "No"
boolean cancel = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type cb_yes from commandbutton within w_direct_open_encounter_display
integer x = 635
integer y = 1220
integer width = 411
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Yes"
boolean default = true
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 1
popup_return.items[1] = "Y"

closewithreturn(parent, popup_return)


end event

type st_question from statictext within w_direct_open_encounter_display
integer x = 407
integer y = 976
integer width = 1413
integer height = 168
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Are you sure you wish to open another direct encounter?"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_open_encounters from u_dw_pick_list within w_direct_open_encounter_display
integer x = 293
integer y = 416
integer width = 1778
integer height = 484
integer taborder = 10
string dataobject = "dw_open_direct_encounters"
boolean border = false
end type

type pb_done from u_picture_button within w_direct_open_encounter_display
boolean visible = false
integer x = 187
integer y = 1216
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

type pb_cancel from u_picture_button within w_direct_open_encounter_display
boolean visible = false
integer x = 87
integer y = 1156
integer taborder = 30
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_statement from statictext within w_direct_open_encounter_display
integer x = 302
integer y = 212
integer width = 1623
integer height = 168
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "The following direct encounters are already open for this patient:"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_1 from u_pb_help_button within w_direct_open_encounter_display
integer x = 1879
integer y = 1268
integer taborder = 20
boolean bringtotop = true
end type

