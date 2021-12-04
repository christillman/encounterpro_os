$PBExportHeader$w_treatment_type_service_edit.srw
forward
global type w_treatment_type_service_edit from w_window_base
end type
type pb_done from u_picture_button within w_treatment_type_service_edit
end type
type pb_cancel from u_picture_button within w_treatment_type_service_edit
end type
type st_title from statictext within w_treatment_type_service_edit
end type
type st_before_title from statictext within w_treatment_type_service_edit
end type
type st_before_flag from statictext within w_treatment_type_service_edit
end type
type sle_button from singlelineedit within w_treatment_type_service_edit
end type
type st_button_title from statictext within w_treatment_type_service_edit
end type
type st_after_title from statictext within w_treatment_type_service_edit
end type
type st_after_flag from statictext within w_treatment_type_service_edit
end type
type sle_button_help from singlelineedit within w_treatment_type_service_edit
end type
type st_button_help_title from statictext within w_treatment_type_service_edit
end type
type sle_button_title from singlelineedit within w_treatment_type_service_edit
end type
type st_button_title_title from statictext within w_treatment_type_service_edit
end type
type st_tag_title from statictext within w_treatment_type_service_edit
end type
type st_observation_tag from statictext within w_treatment_type_service_edit
end type
type st_auto_perform_title from statictext within w_treatment_type_service_edit
end type
type st_auto_perform_flag from statictext within w_treatment_type_service_edit
end type
end forward

global type w_treatment_type_service_edit from w_window_base
integer x = 347
integer y = 272
integer width = 2514
integer height = 1640
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_title st_title
st_before_title st_before_title
st_before_flag st_before_flag
sle_button sle_button
st_button_title st_button_title
st_after_title st_after_title
st_after_flag st_after_flag
sle_button_help sle_button_help
st_button_help_title st_button_help_title
sle_button_title sle_button_title
st_button_title_title st_button_title_title
st_tag_title st_tag_title
st_observation_tag st_observation_tag
st_auto_perform_title st_auto_perform_title
st_auto_perform_flag st_auto_perform_flag
end type
global w_treatment_type_service_edit w_treatment_type_service_edit

type variables
string before_flag
string after_flag
string observation_tag
string auto_perform_flag

end variables

on w_treatment_type_service_edit.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_title=create st_title
this.st_before_title=create st_before_title
this.st_before_flag=create st_before_flag
this.sle_button=create sle_button
this.st_button_title=create st_button_title
this.st_after_title=create st_after_title
this.st_after_flag=create st_after_flag
this.sle_button_help=create sle_button_help
this.st_button_help_title=create st_button_help_title
this.sle_button_title=create sle_button_title
this.st_button_title_title=create st_button_title_title
this.st_tag_title=create st_tag_title
this.st_observation_tag=create st_observation_tag
this.st_auto_perform_title=create st_auto_perform_title
this.st_auto_perform_flag=create st_auto_perform_flag
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_before_title
this.Control[iCurrent+5]=this.st_before_flag
this.Control[iCurrent+6]=this.sle_button
this.Control[iCurrent+7]=this.st_button_title
this.Control[iCurrent+8]=this.st_after_title
this.Control[iCurrent+9]=this.st_after_flag
this.Control[iCurrent+10]=this.sle_button_help
this.Control[iCurrent+11]=this.st_button_help_title
this.Control[iCurrent+12]=this.sle_button_title
this.Control[iCurrent+13]=this.st_button_title_title
this.Control[iCurrent+14]=this.st_tag_title
this.Control[iCurrent+15]=this.st_observation_tag
this.Control[iCurrent+16]=this.st_auto_perform_title
this.Control[iCurrent+17]=this.st_auto_perform_flag
end on

on w_treatment_type_service_edit.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_title)
destroy(this.st_before_title)
destroy(this.st_before_flag)
destroy(this.sle_button)
destroy(this.st_button_title)
destroy(this.st_after_title)
destroy(this.st_after_flag)
destroy(this.sle_button_help)
destroy(this.st_button_help_title)
destroy(this.sle_button_title)
destroy(this.st_button_title_title)
destroy(this.st_tag_title)
destroy(this.st_observation_tag)
destroy(this.st_auto_perform_title)
destroy(this.st_auto_perform_flag)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm

st_title.text = popup.title

if popup.data_row_count <> 7 then
	log.log(this, "w_treatment_type_service_edit:open", "Invalid Parameters", 4)
	close(this)
	return
end if

before_flag = popup.items[1]
after_flag = popup.items[2]
sle_button.text = popup.items[3]
sle_button_help.text = popup.items[4]
sle_button_title.text = popup.items[5]
observation_tag = popup.items[6]
auto_perform_flag = popup.items[7]


if before_flag = "Y" then
	st_before_flag.text = "Yes"
else
	before_flag = "N"
	st_before_flag.text = "No"
end if

if after_flag = "Y" then
	st_after_flag.text = "Yes"
else
	after_flag = "N"
	st_after_flag.text = "No"
end if

if auto_perform_flag = "Y" then
	st_auto_perform_flag.text = "Yes"
else
	auto_perform_flag = "N"
	st_auto_perform_flag.text = "No"
end if

if isnull(observation_tag) then
	st_observation_tag.text = "N/A"
else
	st_observation_tag.text = observation_tag
end if

end event

type pb_epro_help from w_window_base`pb_epro_help within w_treatment_type_service_edit
end type

type pb_done from u_picture_button within w_treatment_type_service_edit
integer x = 2181
integer y = 1356
integer taborder = 10
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;long ll_row
str_popup_return popup_return


popup_return.items[1] = before_flag
popup_return.descriptions[1] = st_before_flag.text
popup_return.items[2] = after_flag
popup_return.descriptions[2] = st_after_flag.text
popup_return.items[3] = sle_button.text
popup_return.descriptions[3] = sle_button.text
popup_return.items[4] = sle_button_help.text
popup_return.descriptions[4] = sle_button_help.text
popup_return.items[5] = sle_button_title.text
popup_return.descriptions[5] = sle_button_title.text
popup_return.items[6] = observation_tag
popup_return.descriptions[6] = st_observation_tag.text
popup_return.items[7] = auto_perform_flag
popup_return.descriptions[7] = st_auto_perform_flag.text

popup_return.item_count = 7
	
closewithreturn(parent, popup_return)



end event

type pb_cancel from u_picture_button within w_treatment_type_service_edit
integer x = 73
integer y = 1356
integer taborder = 40
boolean bringtotop = true
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_treatment_type_service_edit
integer width = 2514
integer height = 132
boolean bringtotop = true
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
alignment alignment = center!
boolean focusrectangle = false
end type

type st_before_title from statictext within w_treatment_type_service_edit
integer x = 311
integer y = 188
integer width = 1061
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Visible Before Workplan Completes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_before_flag from statictext within w_treatment_type_service_edit
integer x = 1403
integer y = 168
integer width = 293
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if before_flag = "Y" then
	before_flag = "N"
	text = "No"
else
	before_flag = "Y"
	text = "Yes"
end if

end event

type sle_button from singlelineedit within w_treatment_type_service_edit
integer x = 699
integer y = 856
integer width = 1390
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_button_title from statictext within w_treatment_type_service_edit
integer x = 389
integer y = 868
integer width = 288
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Button:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_after_title from statictext within w_treatment_type_service_edit
integer x = 311
integer y = 344
integer width = 1061
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Visible After Workplan Completes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_after_flag from statictext within w_treatment_type_service_edit
integer x = 1403
integer y = 324
integer width = 293
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if after_flag = "Y" then
	after_flag = "N"
	text = "No"
else
	after_flag = "Y"
	text = "Yes"
end if

end event

type sle_button_help from singlelineedit within w_treatment_type_service_edit
integer x = 699
integer y = 1192
integer width = 1390
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_button_help_title from statictext within w_treatment_type_service_edit
integer x = 306
integer y = 1204
integer width = 370
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Button Help:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_button_title from singlelineedit within w_treatment_type_service_edit
integer x = 699
integer y = 1024
integer width = 1390
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

type st_button_title_title from statictext within w_treatment_type_service_edit
integer x = 288
integer y = 1036
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Button Title:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_tag_title from statictext within w_treatment_type_service_edit
integer x = 677
integer y = 656
integer width = 695
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Observation Tag:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_observation_tag from statictext within w_treatment_type_service_edit
integer x = 1403
integer y = 636
integer width = 695
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_notranslate_list"
popup.datacolumn = 2
popup.displaycolumn = 2
popup.argument_count = 1
popup.argument[1] = "OBSERVATION_TAG"
popup.add_blank_row = true
popup.blank_text = "N/A"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	setnull(observation_tag)
else
	observation_tag = popup_return.items[1]
end if

text = popup_return.descriptions[1]


end event

type st_auto_perform_title from statictext within w_treatment_type_service_edit
integer x = 64
integer y = 500
integer width = 1307
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Auto-Perform For Past Treatments:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_auto_perform_flag from statictext within w_treatment_type_service_edit
integer x = 1403
integer y = 480
integer width = 293
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if auto_perform_flag = "Y" then
	auto_perform_flag = "N"
	text = "No"
else
	auto_perform_flag = "Y"
	text = "Yes"
end if

end event

