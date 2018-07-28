$PBExportHeader$w_svc_edit_encounter.srw
forward
global type w_svc_edit_encounter from w_window_base
end type
type cb_be_back from commandbutton within w_svc_edit_encounter
end type
type cb_done from commandbutton within w_svc_edit_encounter
end type
type st_title from statictext within w_svc_edit_encounter
end type
type st_date_title from statictext within w_svc_edit_encounter
end type
type st_encounter_date from statictext within w_svc_edit_encounter
end type
type st_encounter_description_title from statictext within w_svc_edit_encounter
end type
type st_encounter_type_title from statictext within w_svc_edit_encounter
end type
type st_encounter_type from statictext within w_svc_edit_encounter
end type
type st_encounter_time_title from statictext within w_svc_edit_encounter
end type
type st_encounter_time from statictext within w_svc_edit_encounter
end type
type st_supervising_doctor_title from statictext within w_svc_edit_encounter
end type
type st_supervising_doctor from statictext within w_svc_edit_encounter
end type
type st_indirect_flag_title from statictext within w_svc_edit_encounter
end type
type st_indirect_flag from statictext within w_svc_edit_encounter
end type
type st_new_flag_title from statictext within w_svc_edit_encounter
end type
type st_new_flag from statictext within w_svc_edit_encounter
end type
type st_encounter_description from statictext within w_svc_edit_encounter
end type
type cb_clear_supervising_doctor from commandbutton within w_svc_edit_encounter
end type
type st_1 from statictext within w_svc_edit_encounter
end type
type st_attending_doctor from statictext within w_svc_edit_encounter
end type
type st_referring_doctor from statictext within w_svc_edit_encounter
end type
type st_4 from statictext within w_svc_edit_encounter
end type
type cb_clear_referring_doctor from commandbutton within w_svc_edit_encounter
end type
end forward

global type w_svc_edit_encounter from w_window_base
string title = "Retry Posting"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
cb_be_back cb_be_back
cb_done cb_done
st_title st_title
st_date_title st_date_title
st_encounter_date st_encounter_date
st_encounter_description_title st_encounter_description_title
st_encounter_type_title st_encounter_type_title
st_encounter_type st_encounter_type
st_encounter_time_title st_encounter_time_title
st_encounter_time st_encounter_time
st_supervising_doctor_title st_supervising_doctor_title
st_supervising_doctor st_supervising_doctor
st_indirect_flag_title st_indirect_flag_title
st_indirect_flag st_indirect_flag
st_new_flag_title st_new_flag_title
st_new_flag st_new_flag
st_encounter_description st_encounter_description
cb_clear_supervising_doctor cb_clear_supervising_doctor
st_1 st_1
st_attending_doctor st_attending_doctor
st_referring_doctor st_referring_doctor
st_4 st_4
cb_clear_referring_doctor cb_clear_referring_doctor
end type
global w_svc_edit_encounter w_svc_edit_encounter

type variables
u_component_service service

str_encounter_description original_encounter
str_encounter_description modified_encounter


end variables

forward prototypes
public function integer save_changes ()
end prototypes

public function integer save_changes ();str_popup_return popup_return

// Encounter Description
if f_string_modified(original_encounter.description, modified_encounter.description) then
	current_patient.encounters.modify_encounter( &
						modified_encounter.encounter_id, &
						"encounter_description", &
						modified_encounter.description )
end if


// Encounter Date
if original_encounter.encounter_date <> modified_encounter.encounter_date then
	current_patient.encounters.modify_encounter( &
						modified_encounter.encounter_id, &
						"encounter_date", &
						string(modified_encounter.encounter_date, "[shortdate] [time]") )
end if

// Indirect Flag
if f_string_modified(original_encounter.indirect_flag, modified_encounter.indirect_flag) then
	current_patient.encounters.modify_encounter( &
						modified_encounter.encounter_id, &
						"indirect_flag", &
						modified_encounter.indirect_flag )
end if

// Referring Doctor
if f_string_modified(original_encounter.referring_doctor, modified_encounter.referring_doctor) then
	current_patient.encounters.modify_encounter( &
						modified_encounter.encounter_id, &
						"referring_doctor", &
						modified_encounter.referring_doctor )
end if

// Attending Doctor
if f_string_modified(original_encounter.attending_doctor, modified_encounter.attending_doctor) then
	current_patient.encounters.modify_encounter( &
						modified_encounter.encounter_id, &
						"attending_doctor", &
						modified_encounter.attending_doctor )
end if

// Supervising Doctor
if f_string_modified(original_encounter.supervising_doctor, modified_encounter.supervising_doctor) then
	current_patient.encounters.modify_encounter( &
						modified_encounter.encounter_id, &
						"supervising_doctor", &
						modified_encounter.supervising_doctor )
end if

// New Flag
if f_string_modified(original_encounter.new_flag, modified_encounter.new_flag) then
	current_patient.encounters.modify_encounter( &
						modified_encounter.encounter_id, &
						"new_flag", &
						modified_encounter.new_flag )
end if


// Always do the encounter_type last because we want all the other modifications
// to affect the workplan selection
if original_encounter.encounter_type <> modified_encounter.encounter_type then
	current_patient.encounters.modify_encounter( &
						modified_encounter.encounter_id, &
						"encounter_type", &
						modified_encounter.encounter_type)
	
	if not isnull(current_patient.open_encounter) then
		if service.encounter_id = current_patient.open_encounter.encounter_id &
		 and current_patient.open_encounter.encounter_status = "OPEN" then
			openwithparm(w_pop_yes_no, "The Encounter Type has been changed.  Do you wish to cancel the existing encounter workplan and order a new one?")
			popup_return = message.powerobjectparm
			if popup_return.item = "YES" then
				current_patient.open_encounter.order_encounter_workplan()
			end if
		end if
	end if
end if



return 1


end function

on w_svc_edit_encounter.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.st_title=create st_title
this.st_date_title=create st_date_title
this.st_encounter_date=create st_encounter_date
this.st_encounter_description_title=create st_encounter_description_title
this.st_encounter_type_title=create st_encounter_type_title
this.st_encounter_type=create st_encounter_type
this.st_encounter_time_title=create st_encounter_time_title
this.st_encounter_time=create st_encounter_time
this.st_supervising_doctor_title=create st_supervising_doctor_title
this.st_supervising_doctor=create st_supervising_doctor
this.st_indirect_flag_title=create st_indirect_flag_title
this.st_indirect_flag=create st_indirect_flag
this.st_new_flag_title=create st_new_flag_title
this.st_new_flag=create st_new_flag
this.st_encounter_description=create st_encounter_description
this.cb_clear_supervising_doctor=create cb_clear_supervising_doctor
this.st_1=create st_1
this.st_attending_doctor=create st_attending_doctor
this.st_referring_doctor=create st_referring_doctor
this.st_4=create st_4
this.cb_clear_referring_doctor=create cb_clear_referring_doctor
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_date_title
this.Control[iCurrent+5]=this.st_encounter_date
this.Control[iCurrent+6]=this.st_encounter_description_title
this.Control[iCurrent+7]=this.st_encounter_type_title
this.Control[iCurrent+8]=this.st_encounter_type
this.Control[iCurrent+9]=this.st_encounter_time_title
this.Control[iCurrent+10]=this.st_encounter_time
this.Control[iCurrent+11]=this.st_supervising_doctor_title
this.Control[iCurrent+12]=this.st_supervising_doctor
this.Control[iCurrent+13]=this.st_indirect_flag_title
this.Control[iCurrent+14]=this.st_indirect_flag
this.Control[iCurrent+15]=this.st_new_flag_title
this.Control[iCurrent+16]=this.st_new_flag
this.Control[iCurrent+17]=this.st_encounter_description
this.Control[iCurrent+18]=this.cb_clear_supervising_doctor
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.st_attending_doctor
this.Control[iCurrent+21]=this.st_referring_doctor
this.Control[iCurrent+22]=this.st_4
this.Control[iCurrent+23]=this.cb_clear_referring_doctor
end on

on w_svc_edit_encounter.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.st_title)
destroy(this.st_date_title)
destroy(this.st_encounter_date)
destroy(this.st_encounter_description_title)
destroy(this.st_encounter_type_title)
destroy(this.st_encounter_type)
destroy(this.st_encounter_time_title)
destroy(this.st_encounter_time)
destroy(this.st_supervising_doctor_title)
destroy(this.st_supervising_doctor)
destroy(this.st_indirect_flag_title)
destroy(this.st_indirect_flag)
destroy(this.st_new_flag_title)
destroy(this.st_new_flag)
destroy(this.st_encounter_description)
destroy(this.cb_clear_supervising_doctor)
destroy(this.st_1)
destroy(this.st_attending_doctor)
destroy(this.st_referring_doctor)
destroy(this.st_4)
destroy(this.cb_clear_referring_doctor)
end on

event post_open;call super::post_open;String ls_cpr_id
Long ll_encounter_id

ls_cpr_id = current_patient.cpr_id
ll_encounter_id = current_patient.open_encounter_id

UPDATE p_Patient_Encounter
SET billing_posted = "R"
WHERE cpr_id = :ls_cpr_id
AND encounter_id = :ll_encounter_id
AND billing_posted = "E";
if not tf_check() then return -1
if sqlca.sqlcode = 100 then return 0

Close(this)

end event

event open;call super::open;str_popup_return popup_return
long ll_menu_id
integer li_sts

popup_return.item_count = 0

service = message.powerobjectparm


if isnull(service.encounter_id) then
	log.log(this, "open", "Null encounter_id", 4)
	closewithreturn(this, popup_return)
	return
end if

title = current_patient.id_line()

li_sts = current_patient.encounters.encounter(original_encounter, service.encounter_id)
if li_sts <= 0 then
	log.log(this, "open", "Inavlid encounter_id (" + string(service.encounter_id) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

// Don't offer the "I'll Be Back" option for manual services
if service.manual_service then
	cb_be_back.visible = false
	max_buttons = 4
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

modified_encounter = original_encounter

st_encounter_description.text = modified_encounter.description
st_encounter_date.text = string(modified_encounter.encounter_date, date_format_string)
st_encounter_time.text = string(modified_encounter.encounter_date, time_format_string)
st_encounter_type.text = datalist.encounter_type_description(modified_encounter.encounter_type)
st_indirect_flag.text = datalist.domain_item_description("ENCOUNTER_MODE", modified_encounter.indirect_flag)

if isnull(modified_encounter.referring_doctor) then
	st_referring_doctor.text = "<None>"
	cb_clear_referring_doctor.visible = false
else
	st_referring_doctor.text = datalist.consultant_description(modified_encounter.referring_doctor)
end if

if isnull(modified_encounter.attending_doctor) then
	st_attending_doctor.text = "<None>"
else
	st_attending_doctor.text = user_list.user_full_name(modified_encounter.attending_doctor)
	st_attending_doctor.backcolor = user_list.user_color(modified_encounter.attending_doctor)
end if

if isnull(modified_encounter.supervising_doctor) then
	st_supervising_doctor.text = "<None>"
	cb_clear_supervising_doctor.visible = false
else
	st_supervising_doctor.text = user_list.user_full_name(modified_encounter.supervising_doctor)
	st_supervising_doctor.backcolor = user_list.user_color(modified_encounter.supervising_doctor)
end if

if modified_encounter.new_flag = "N" then
	st_new_flag.text = "Established"
else
	st_new_flag.text = "New"
end if


end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_edit_encounter
boolean visible = true
integer x = 2629
integer y = 1432
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_edit_encounter
end type

type cb_be_back from commandbutton within w_svc_edit_encounter
integer x = 1947
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_done from commandbutton within w_svc_edit_encounter
integer x = 2414
integer y = 1600
integer width = 443
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type st_title from statictext within w_svc_edit_encounter
integer width = 2921
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Edit Encounter Information"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_date_title from statictext within w_svc_edit_encounter
integer x = 64
integer y = 252
integer width = 507
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Encounter Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_date from statictext within w_svc_edit_encounter
integer x = 590
integer y = 236
integer width = 576
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "12/12/2000"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;date ld_encounter_date
time lt_encounter_time
string ls_text

ld_encounter_date = date(modified_encounter.encounter_date)
lt_encounter_time = time(modified_encounter.encounter_date)

ls_text = f_select_date(ld_encounter_date, "Encounter Date")
if isnull(ls_text) then return

modified_encounter.encounter_date = datetime(ld_encounter_date, lt_encounter_time)
text = ls_text

end event

type st_encounter_description_title from statictext within w_svc_edit_encounter
integer x = 160
integer y = 668
integer width = 411
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Description:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_type_title from statictext within w_svc_edit_encounter
integer x = 64
integer y = 460
integer width = 507
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Encounter Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_type from statictext within w_svc_edit_encounter
integer x = 590
integer y = 444
integer width = 1097
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Adult Office Visit"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
string ls_encounter_type

popup.data_row_count = 2
popup.items[1] = "PICK"
popup.items[2] = modified_encounter.indirect_flag

openwithparm(w_pick_encounter_type, popup)
ls_encounter_type = message.stringparm
if isnull(ls_encounter_type) then return

modified_encounter.encounter_type = ls_encounter_type
text = datalist.encounter_type_description(ls_encounter_type)


end event

type st_encounter_time_title from statictext within w_svc_edit_encounter
integer x = 1600
integer y = 252
integer width = 507
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Encounter Time:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_encounter_time from statictext within w_svc_edit_encounter
integer x = 2139
integer y = 236
integer width = 507
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "12:00:00"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
date ld_encounter_date
time lt_encounter_time

ld_encounter_date = date(modified_encounter.encounter_date)

popup.title = "Set Encounter Time"
popup.item = string(modified_encounter.encounter_date, date_format_string + " " + time_format_string)
openwithparm(w_pop_prompt_date_time, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 2 then return

lt_encounter_time = time(popup_return.items[2])

modified_encounter.encounter_date = datetime(ld_encounter_date, lt_encounter_time)

text = popup_return.items[2]

end event

type st_supervising_doctor_title from statictext within w_svc_edit_encounter
integer x = 174
integer y = 1084
integer width = 398
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Supervisor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_supervising_doctor from statictext within w_svc_edit_encounter
integer x = 590
integer y = 1068
integer width = 1006
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user(false, false, false)
if isnull(luo_user) then return

text = luo_user.user_full_name
backcolor = luo_user.color

modified_encounter.supervising_doctor = luo_user.user_id

cb_clear_supervising_doctor.visible = true

end event

type st_indirect_flag_title from statictext within w_svc_edit_encounter
integer x = 1865
integer y = 460
integer width = 242
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Mode:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_indirect_flag from statictext within w_svc_edit_encounter
integer x = 2139
integer y = 444
integer width = 507
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
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

modified_encounter.indirect_flag = popup_return.items[1]
text = popup_return.descriptions[1]


end event

type st_new_flag_title from statictext within w_svc_edit_encounter
integer x = 1696
integer y = 876
integer width = 521
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "New/Established:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_new_flag from statictext within w_svc_edit_encounter
integer x = 2231
integer y = 860
integer width = 416
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Established"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if modified_encounter.new_flag = "Y" then
	modified_encounter.new_flag = "N"
	text = "Established"
else
	modified_encounter.new_flag = "Y"
	text = "New"
end if

end event

type st_encounter_description from statictext within w_svc_edit_encounter
integer x = 590
integer y = 652
integer width = 2057
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.title = "Encounter Description"
popup.data_row_count = 2
popup.items[1] = "ENCDESC|" + modified_encounter.encounter_type
popup.items[2] = modified_encounter.description
openwithparm(w_pick_top_20_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

modified_encounter.description = left(popup_return.items[1], 80)
text = modified_encounter.description


end event

type cb_clear_supervising_doctor from commandbutton within w_svc_edit_encounter
integer x = 1605
integer y = 1108
integer width = 256
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(modified_encounter.supervising_doctor)
st_supervising_doctor.text = "<None>"
st_supervising_doctor.backcolor = color_object
visible = false

end event

type st_1 from statictext within w_svc_edit_encounter
integer x = 37
integer y = 876
integer width = 535
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Encounter Owner:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_attending_doctor from statictext within w_svc_edit_encounter
integer x = 590
integer y = 860
integer width = 1006
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;u_user luo_user

luo_user = user_list.pick_user(false, false, false)
if isnull(luo_user) then return

text = luo_user.user_full_name
backcolor = luo_user.color

modified_encounter.attending_doctor = luo_user.user_id


end event

type st_referring_doctor from statictext within w_svc_edit_encounter
integer x = 590
integer y = 1276
integer width = 1006
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "<None>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_pick_users lstr_pick_users
integer li_sts

lstr_pick_users.hide_users = true
lstr_pick_users.cpr_id = service.cpr_id
lstr_pick_users.actor_class = "Consultant"
lstr_pick_users.pick_screen_title = "Select Referring Provider"

li_sts = user_list.pick_users(lstr_pick_users)
if lstr_pick_users.selected_users.user_count < 1 then return

modified_encounter.referring_doctor = lstr_pick_users.selected_users.user[1].user_id
text = lstr_pick_users.selected_users.user[1].user_full_name

end event

type st_4 from statictext within w_svc_edit_encounter
integer x = 174
integer y = 1292
integer width = 398
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Referred By:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_clear_referring_doctor from commandbutton within w_svc_edit_encounter
integer x = 1605
integer y = 1312
integer width = 256
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;setnull(modified_encounter.referring_doctor)
st_referring_doctor.text = "<None>"
st_referring_doctor.backcolor = color_object
visible = false

end event

