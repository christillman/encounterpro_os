$PBExportHeader$w_map_appointment_type.srw
forward
global type w_map_appointment_type from w_window_full_response
end type
type sle_appointment from singlelineedit within w_map_appointment_type
end type
type st_newflag from statictext within w_map_appointment_type
end type
type st_2 from statictext within w_map_appointment_type
end type
type st_3 from statictext within w_map_appointment_type
end type
type st_4 from statictext within w_map_appointment_type
end type
type st_encounter_type from statictext within w_map_appointment_type
end type
type st_1 from statictext within w_map_appointment_type
end type
type st_5 from statictext within w_map_appointment_type
end type
type sle_appointment_text from singlelineedit within w_map_appointment_type
end type
type st_6 from statictext within w_map_appointment_type
end type
end forward

global type w_map_appointment_type from w_window_full_response
sle_appointment sle_appointment
st_newflag st_newflag
st_2 st_2
st_3 st_3
st_4 st_4
st_encounter_type st_encounter_type
st_1 st_1
st_5 st_5
sle_appointment_text sle_appointment_text
st_6 st_6
end type
global w_map_appointment_type w_map_appointment_type

type variables
string recordtype
string encounter_mode='D'
string encounter_type
end variables

on w_map_appointment_type.create
int iCurrent
call super::create
this.sle_appointment=create sle_appointment
this.st_newflag=create st_newflag
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_encounter_type=create st_encounter_type
this.st_1=create st_1
this.st_5=create st_5
this.sle_appointment_text=create sle_appointment_text
this.st_6=create st_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_appointment
this.Control[iCurrent+2]=this.st_newflag
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_encounter_type
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_appointment_text
this.Control[iCurrent+10]=this.st_6
end on

on w_map_appointment_type.destroy
call super::destroy
destroy(this.sle_appointment)
destroy(this.st_newflag)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_encounter_type)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.sle_appointment_text)
destroy(this.st_6)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm
if popup.data_row_count <> 5 then
	log.log(this,"w_map_appointment_type:open","invalid parameters",4)
	close(this)
end if

recordtype = popup.items[1]
sle_appointment.text = popup.items[2]
encounter_type = popup.items[3]
st_newflag.text = popup.items[4]
sle_appointment_text.text = popup.items[5]
if recordtype = 'NEW' then 
	sle_appointment.enabled = true
	sle_appointment.setfocus()
else
	if not isnull(encounter_type) then
		SELECT description
		INTO :st_encounter_type.text
		FROM c_Encounter_Type
		WHERE encounter_type = :encounter_type;
	end if
	sle_appointment.enabled = false
end if

end event

type pb_epro_help from w_window_full_response`pb_epro_help within w_map_appointment_type
integer x = 2450
integer y = 56
end type

type st_config_mode_menu from w_window_full_response`st_config_mode_menu within w_map_appointment_type
integer x = 517
integer y = 1456
integer height = 60
end type

type pb_done from w_window_full_response`pb_done within w_map_appointment_type
integer x = 2505
integer y = 1420
end type

event pb_done::clicked;call super::clicked;str_popup_return popup_return
string ls_newflag
string ls_appointment_type

If st_newflag.text = "Yes" then ls_newflag = "Y" else ls_newflag = "N"
If recordtype = 'NEW' then
	If isnull(sle_appointment.text) or len(sle_appointment.text) = 0 Then
		openwithparm(w_pop_message,"Enter a valid appointment type")
		sle_appointment.setfocus()
		return
	End If
	If isnull(st_encounter_type.text) or len(st_encounter_type.text) = 0 Then
		openwithparm(w_pop_message,"Enter a valid encounter type")
		st_encounter_type.setfocus()
		return
	End If
	Select appointment_type
	Into :ls_appointment_type
	From b_appointment_type
	where appointment_type = :sle_appointment.text
	using sqlca;
	
	if not isnull(ls_appointment_type) and len(ls_appointment_type) > 0 Then
		openwithparm(w_pop_message,"Appointment already exists")
		sle_appointment.text = ""
		sle_appointment.setfocus()
		return
	end if
	Insert Into b_appointment_type (
	appointment_type,
	appointment_text,
	encounter_type,
	new_flag
	)
	values (
	:sle_appointment.text,
	:sle_appointment_text.text,
	:encounter_type,
	:ls_newflag
	)
	using sqlca;
else
	Update b_appointment_type
	set encounter_type = :encounter_type,
		appointment_text = :sle_appointment_text.text,
		new_flag = :ls_newflag
	where appointment_type = :sle_appointment.text
	Using sqlca;
end if 

popup_return.item_count = 3
popup_return.items[1] = sle_appointment.text
popup_return.items[2] = st_encounter_type.text
popup_return.items[3] = ls_newflag
Closewithreturn(parent,popup_return)
end event

type pb_cancel from w_window_full_response`pb_cancel within w_map_appointment_type
integer x = 87
integer y = 1420
end type

event pb_cancel::clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0
Closewithreturn(parent,popup_return)
end event

type sle_appointment from singlelineedit within w_map_appointment_type
integer x = 791
integer y = 284
integer width = 1390
integer height = 96
integer taborder = 21
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 50
end type

type st_newflag from statictext within w_map_appointment_type
integer x = 1257
integer y = 1116
integer width = 402
integer height = 96
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if text = "No" then text = "Yes" else text = "No"
end event

type st_2 from statictext within w_map_appointment_type
integer x = 1248
integer y = 1000
integer width = 402
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "New Flag"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_map_appointment_type
integer x = 1175
integer y = 744
integer width = 576
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Encounter Type"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_map_appointment_type
integer x = 837
integer y = 172
integer width = 1266
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Appointment Type"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_encounter_type from statictext within w_map_appointment_type
integer x = 809
integer y = 840
integer width = 1353
integer height = 128
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
integer li_sts
string ls_button,ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = encounter_mode
openwithparm(w_config_encounter_types, popup)
ls_encounter_type = message.stringparm
if isnull(ls_encounter_type) or len(ls_encounter_type) = 0 Then return

encounter_type = ls_encounter_type
SELECT description
INTO :st_encounter_type.text
FROM c_Encounter_Type
WHERE encounter_type = :encounter_type;

end event

type st_1 from statictext within w_map_appointment_type
integer x = 2240
integer y = 708
integer width = 329
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Mode"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_map_appointment_type
integer x = 2240
integer y = 836
integer width = 329
integer height = 128
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Direct"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_domain_translate_list"
popup.datacolumn = 2
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = "ENCOUNTER_MODE"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

encounter_mode = popup_return.items[1]
text = popup_return.descriptions[1]


end event

type sle_appointment_text from singlelineedit within w_map_appointment_type
integer x = 786
integer y = 548
integer width = 1390
integer height = 96
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 50
end type

type st_6 from statictext within w_map_appointment_type
integer x = 1152
integer y = 452
integer width = 809
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "AppointmentType Text"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

