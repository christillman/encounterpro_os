$PBExportHeader$w_map_resource.srw
forward
global type w_map_resource from w_window_full_response
end type
type sle_appointment from singlelineedit within w_map_resource
end type
type st_newflag from statictext within w_map_resource
end type
type st_2 from statictext within w_map_resource
end type
type st_3 from statictext within w_map_resource
end type
type st_4 from statictext within w_map_resource
end type
type st_encounter_type from statictext within w_map_resource
end type
type sle_resource from singlelineedit within w_map_resource
end type
type st_1 from statictext within w_map_resource
end type
type st_5 from statictext within w_map_resource
end type
type st_userid from statictext within w_map_resource
end type
type cb_1 from commandbutton within w_map_resource
end type
type st_6 from statictext within w_map_resource
end type
type cb_2 from commandbutton within w_map_resource
end type
type st_7 from statictext within w_map_resource
end type
type em_sort_sequence from editmask within w_map_resource
end type
type st_8 from statictext within w_map_resource
end type
type sle_resource_text from singlelineedit within w_map_resource
end type
type st_9 from statictext within w_map_resource
end type
end forward

global type w_map_resource from w_window_full_response
sle_appointment sle_appointment
st_newflag st_newflag
st_2 st_2
st_3 st_3
st_4 st_4
st_encounter_type st_encounter_type
sle_resource sle_resource
st_1 st_1
st_5 st_5
st_userid st_userid
cb_1 cb_1
st_6 st_6
cb_2 cb_2
st_7 st_7
em_sort_sequence em_sort_sequence
st_8 st_8
sle_resource_text sle_resource_text
st_9 st_9
end type
global w_map_resource w_map_resource

type variables
string recordtype
string encounter_mode='D'
string license_flag = '%'
string userid
long resource_sequence
integer sort_sequence
string encounter_type
end variables

on w_map_resource.create
int iCurrent
call super::create
this.sle_appointment=create sle_appointment
this.st_newflag=create st_newflag
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_encounter_type=create st_encounter_type
this.sle_resource=create sle_resource
this.st_1=create st_1
this.st_5=create st_5
this.st_userid=create st_userid
this.cb_1=create cb_1
this.st_6=create st_6
this.cb_2=create cb_2
this.st_7=create st_7
this.em_sort_sequence=create em_sort_sequence
this.st_8=create st_8
this.sle_resource_text=create sle_resource_text
this.st_9=create st_9
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_appointment
this.Control[iCurrent+2]=this.st_newflag
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_encounter_type
this.Control[iCurrent+7]=this.sle_resource
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.st_userid
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.st_6
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.st_7
this.Control[iCurrent+15]=this.em_sort_sequence
this.Control[iCurrent+16]=this.st_8
this.Control[iCurrent+17]=this.sle_resource_text
this.Control[iCurrent+18]=this.st_9
end on

on w_map_resource.destroy
call super::destroy
destroy(this.sle_appointment)
destroy(this.st_newflag)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_encounter_type)
destroy(this.sle_resource)
destroy(this.st_1)
destroy(this.st_5)
destroy(this.st_userid)
destroy(this.cb_1)
destroy(this.st_6)
destroy(this.cb_2)
destroy(this.st_7)
destroy(this.em_sort_sequence)
destroy(this.st_8)
destroy(this.sle_resource_text)
destroy(this.st_9)
end on

event open;call super::open;str_popup popup

popup = message.powerobjectparm
if popup.data_row_count <> 9 then
	log.log(this,"open()","invalid parameters",4)
	close(this)
end if

recordtype = popup.items[1]
resource_sequence = long(popup.items[2])
sle_appointment.text = popup.items[3]
sle_resource.text = popup.items[4]
encounter_type = popup.items[5]
st_userid.text = popup.items[6]
st_newflag.text = popup.items[7]
em_sort_sequence.text = popup.items[8]
sle_resource_text.text = popup.items[9]

if not isnull(encounter_type) then
	SELECT description
	INTO :st_encounter_type.text
	FROM c_Encounter_Type
	WHERE encounter_type = :encounter_type;
end if

end event

type pb_epro_help from w_window_full_response`pb_epro_help within w_map_resource
integer x = 2551
integer y = 36
end type

type st_config_mode_menu from w_window_full_response`st_config_mode_menu within w_map_resource
integer x = 416
integer y = 1540
end type

type pb_done from w_window_full_response`pb_done within w_map_resource
integer x = 2510
integer y = 1384
end type

event pb_done::clicked;call super::clicked;str_popup_return popup_return
string ls_newflag
string ls_appointment_type

sort_sequence = long(em_sort_sequence.text)
if sort_sequence = 0 then setnull(sort_sequence)
If st_newflag.text = "Yes" then ls_newflag = "Y" else ls_newflag = "N"
If recordtype = 'NEW' then
	If isnull(sle_resource.text) or len(sle_resource.text) = 0 Then
		openwithparm(w_pop_message,"Enter a valid resource")
		sle_resource.setfocus()
		return
	End If
//	If isnull(sle_appointment.text) or len(sle_appointment.text) = 0 Then
//		openwithparm(w_pop_message,"Enter a valid appointment type")
//		sle_appointment.setfocus()
//		return
//	End If
//	If isnull(st_encounter_type.text) or len(st_encounter_type.text) = 0 Then
//		openwithparm(w_pop_message,"Select a valid encounter type")
//		st_encounter_type.setfocus()
//		return
//	End If
	Insert Into b_resource (
	appointment_type,
	resource,
	resource_text,
	encounter_type,
	user_id,
	new_flag,
	sort_sequence
	)
	values (
	:sle_appointment.text,
	:sle_resource.text,
	:sle_resource_text.text,
	:encounter_type,
	:userid,
	:ls_newflag,
	:sort_sequence
	)
	using sqlca;
	
	select max(resource_sequence)
	into :resource_sequence
	from b_resource
	using sqlca;
else
	Update b_resource
	set encounter_type = :encounter_type,
		resource = :sle_resource.text,
		resource_text = :sle_resource_text.text,
		appointment_type = :sle_appointment.text,
		user_id = :userid,
		new_flag = :ls_newflag,
		sort_sequence = :sort_sequence
	where resource_sequence = :resource_sequence
	Using sqlca;
end if 

popup_return.item_count = 7
popup_return.items[1] = sle_appointment.text
popup_return.items[2] = sle_resource.text
popup_return.items[3] = st_encounter_type.text
popup_return.items[4] = st_userid.text
popup_return.items[5] = ls_newflag
popup_return.items[6] = string(resource_sequence)
popup_return.items[7] = string(sort_sequence)
Closewithreturn(parent,popup_return)
end event

type pb_cancel from w_window_full_response`pb_cancel within w_map_resource
integer x = 41
integer y = 1384
end type

event pb_cancel::clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0
Closewithreturn(parent,popup_return)
end event

type sle_appointment from singlelineedit within w_map_resource
integer x = 718
integer y = 584
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
end type

type st_newflag from statictext within w_map_resource
integer x = 1010
integer y = 1320
integer width = 402
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
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if text = "No" then text = "Yes" else text = "No"
end event

type st_2 from statictext within w_map_resource
integer x = 1010
integer y = 1224
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
long backcolor = 33538240
string text = "New Flag"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_map_resource
integer x = 1120
integer y = 712
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
long backcolor = 33538240
string text = "Encounter Type"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_4 from statictext within w_map_resource
integer x = 1083
integer y = 488
integer width = 640
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "AppointmentType"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_encounter_type from statictext within w_map_resource
integer x = 754
integer y = 808
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

type sle_resource from singlelineedit within w_map_resource
integer x = 722
integer y = 160
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
end type

type st_1 from statictext within w_map_resource
integer x = 1088
integer y = 64
integer width = 640
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Resource"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_5 from statictext within w_map_resource
integer x = 1120
integer y = 968
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
long backcolor = 33538240
string text = "UserId"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_userid from statictext within w_map_resource
integer x = 754
integer y = 1064
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
str_popup_return popup_return
integer li_sts
string ls_button

popup.dataobject = "dw_user_list_by_provider_class"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 2
popup.argument[1] = license_flag
popup.argument[2] = 'OK' // user status
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

userid = popup_return.items[1]
text = popup_return.descriptions[1]
end event

type cb_1 from commandbutton within w_map_resource
integer x = 2162
integer y = 816
integer width = 402
integer height = 112
integer taborder = 31
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Direct"
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

type st_6 from statictext within w_map_resource
integer x = 2235
integer y = 720
integer width = 219
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Mode"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_map_resource
integer x = 2162
integer y = 1072
integer width = 402
integer height = 112
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "All"
end type

event clicked;str_popup popup
str_popup_return popup_return


popup.data_row_count = 4
popup.items[1] = "Physician"
popup.items[2] = "Extender"
popup.items[3] = "Staff"
popup.items[4] = "All"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

text = popup_return.items[1]

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		license_flag = "P"
	CASE 2
		license_flag = "E"
	CASE 3
		license_flag = "S"
	CASE 4
		license_flag = "%"
END CHOOSE


end event

type st_7 from statictext within w_map_resource
integer x = 2199
integer y = 976
integer width = 315
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Provider"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type em_sort_sequence from editmask within w_map_resource
integer x = 1559
integer y = 1320
integer width = 402
integer height = 112
integer taborder = 11
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type st_8 from statictext within w_map_resource
integer x = 1486
integer y = 1224
integer width = 549
integer height = 64
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Sort Sequence"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_resource_text from singlelineedit within w_map_resource
integer x = 722
integer y = 380
integer width = 1390
integer height = 96
integer taborder = 41
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type st_9 from statictext within w_map_resource
integer x = 1088
integer y = 284
integer width = 640
integer height = 96
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Resource Text"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

