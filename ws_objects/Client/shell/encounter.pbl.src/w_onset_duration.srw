$PBExportHeader$w_onset_duration.srw
forward
global type w_onset_duration from w_window_base
end type
type pb_done from u_picture_button within w_onset_duration
end type
type pb_cancel from u_picture_button within w_onset_duration
end type
type st_end_date_interval from statictext within w_onset_duration
end type
type st_other_date from statictext within w_onset_duration
end type
type st_title from statictext within w_onset_duration
end type
type st_instructions from statictext within w_onset_duration
end type
type st_current_encounter_title from statictext within w_onset_duration
end type
type st_current_encounter from statictext within w_onset_duration
end type
type st_how_long_ago_title from statictext within w_onset_duration
end type
type st_how_long_ago from statictext within w_onset_duration
end type
type st_other_encounter_title from statictext within w_onset_duration
end type
type st_other_date_title from statictext within w_onset_duration
end type
type st_onset_title from statictext within w_onset_duration
end type
type st_duration_title from statictext within w_onset_duration
end type
type st_end_date_date from statictext within w_onset_duration
end type
type st_end_date_or from statictext within w_onset_duration
end type
type st_end_date_interval_title from statictext within w_onset_duration
end type
type st_end_date_date_title from statictext within w_onset_duration
end type
type cb_clear_end_date from commandbutton within w_onset_duration
end type
type st_today_title from statictext within w_onset_duration
end type
type st_today from statictext within w_onset_duration
end type
type st_other_encounter from statictext within w_onset_duration
end type
end forward

global type w_onset_duration from w_window_base
integer x = 201
integer y = 132
integer width = 2528
integer height = 1680
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_done pb_done
pb_cancel pb_cancel
st_end_date_interval st_end_date_interval
st_other_date st_other_date
st_title st_title
st_instructions st_instructions
st_current_encounter_title st_current_encounter_title
st_current_encounter st_current_encounter
st_how_long_ago_title st_how_long_ago_title
st_how_long_ago st_how_long_ago
st_other_encounter_title st_other_encounter_title
st_other_date_title st_other_date_title
st_onset_title st_onset_title
st_duration_title st_duration_title
st_end_date_date st_end_date_date
st_end_date_or st_end_date_or
st_end_date_interval_title st_end_date_interval_title
st_end_date_date_title st_end_date_date_title
cb_clear_end_date cb_clear_end_date
st_today_title st_today_title
st_today st_today
st_other_encounter st_other_encounter
end type
global w_onset_duration w_onset_duration

type variables
long open_encounter_id
date begin_date
date end_date

real interval_amount
string interval_unit

str_encounter_description current_encounter

string object_name

string instructions = "This %object% occured in the past.  Please specify when this %object% occured."


end variables

forward prototypes
public subroutine set_begin_date (date pd_begin_date)
public subroutine display_end_date ()
end prototypes

public subroutine set_begin_date (date pd_begin_date);
if begin_date = pd_begin_date then return

// If the date changed then see if we have an end_date
if not isnull(interval_amount) and not isnull(interval_unit) then
	end_date = f_add_interval(pd_begin_date, int(interval_amount), interval_unit)
end if

begin_date = pd_begin_date

display_end_date()

end subroutine

public subroutine display_end_date ();
if isnull(end_date) then
	st_end_date_interval.text = ""
	st_end_date_date.text = ""
	setnull(interval_amount)
	setnull(interval_unit)
	cb_clear_end_date.visible = false
else
	// Convert the end date into an interval
	f_pretty_date_interval(begin_date, end_date, interval_amount, interval_unit)
	
	// Then convert the interval back into a date
	if isnull(interval_amount) or isnull(interval_unit) then
		setnull(end_date)
		setnull(interval_amount)
		setnull(interval_unit)
		st_end_date_interval.text = ""
		st_end_date_date.text = ""
		cb_clear_end_date.visible = false
	else
		st_end_date_interval.text = f_pretty_amount_unit(interval_amount, interval_unit)
		st_end_date_date.text = string(end_date, date_format_string)
		end_date = f_add_interval(begin_date, int(interval_amount), interval_unit)
		cb_clear_end_date.visible = true
	end if
end if

end subroutine

on w_onset_duration.create
int iCurrent
call super::create
this.pb_done=create pb_done
this.pb_cancel=create pb_cancel
this.st_end_date_interval=create st_end_date_interval
this.st_other_date=create st_other_date
this.st_title=create st_title
this.st_instructions=create st_instructions
this.st_current_encounter_title=create st_current_encounter_title
this.st_current_encounter=create st_current_encounter
this.st_how_long_ago_title=create st_how_long_ago_title
this.st_how_long_ago=create st_how_long_ago
this.st_other_encounter_title=create st_other_encounter_title
this.st_other_date_title=create st_other_date_title
this.st_onset_title=create st_onset_title
this.st_duration_title=create st_duration_title
this.st_end_date_date=create st_end_date_date
this.st_end_date_or=create st_end_date_or
this.st_end_date_interval_title=create st_end_date_interval_title
this.st_end_date_date_title=create st_end_date_date_title
this.cb_clear_end_date=create cb_clear_end_date
this.st_today_title=create st_today_title
this.st_today=create st_today
this.st_other_encounter=create st_other_encounter
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_done
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.st_end_date_interval
this.Control[iCurrent+4]=this.st_other_date
this.Control[iCurrent+5]=this.st_title
this.Control[iCurrent+6]=this.st_instructions
this.Control[iCurrent+7]=this.st_current_encounter_title
this.Control[iCurrent+8]=this.st_current_encounter
this.Control[iCurrent+9]=this.st_how_long_ago_title
this.Control[iCurrent+10]=this.st_how_long_ago
this.Control[iCurrent+11]=this.st_other_encounter_title
this.Control[iCurrent+12]=this.st_other_date_title
this.Control[iCurrent+13]=this.st_onset_title
this.Control[iCurrent+14]=this.st_duration_title
this.Control[iCurrent+15]=this.st_end_date_date
this.Control[iCurrent+16]=this.st_end_date_or
this.Control[iCurrent+17]=this.st_end_date_interval_title
this.Control[iCurrent+18]=this.st_end_date_date_title
this.Control[iCurrent+19]=this.cb_clear_end_date
this.Control[iCurrent+20]=this.st_today_title
this.Control[iCurrent+21]=this.st_today
this.Control[iCurrent+22]=this.st_other_encounter
end on

on w_onset_duration.destroy
call super::destroy
destroy(this.pb_done)
destroy(this.pb_cancel)
destroy(this.st_end_date_interval)
destroy(this.st_other_date)
destroy(this.st_title)
destroy(this.st_instructions)
destroy(this.st_current_encounter_title)
destroy(this.st_current_encounter)
destroy(this.st_how_long_ago_title)
destroy(this.st_how_long_ago)
destroy(this.st_other_encounter_title)
destroy(this.st_other_date_title)
destroy(this.st_onset_title)
destroy(this.st_duration_title)
destroy(this.st_end_date_date)
destroy(this.st_end_date_or)
destroy(this.st_end_date_interval_title)
destroy(this.st_end_date_date_title)
destroy(this.cb_clear_end_date)
destroy(this.st_today_title)
destroy(this.st_today)
destroy(this.st_other_encounter)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
real lr_amount
string ls_unit
long ll_encounter_id
integer li_sts
date ld_open_encounter_date

popup = message.powerobjectparm

popup_return.item_count = 0

if popup.data_row_count <> 4 then
	log.log(this, "w_onset_duration:open", "Invalid Parameters", 4)
	closewithreturn(this, popup_return)
	return
end if

st_title.text = popup.title

if trim(popup.items[1]) = "" then
	setnull(begin_date)
else
	begin_date = date(popup.items[1])
end if

if trim(popup.items[2]) = "" then
	setnull(end_date)
else
	end_date = date(popup.items[2])
end if

if trim(popup.items[3]) = "" then
	setnull(open_encounter_id)
else
	open_encounter_id = long(popup.items[3])
end if


object_name = lower(popup.items[4])

st_instructions.text = f_string_substitute(instructions, "%object%", object_name)
st_onset_title.text = wordcap(object_name) + " Onset"
st_duration_title.text = wordcap(object_name) + " Duration"


// Set the likely encounters

// Set the current encounter
if isnull(current_service) then
	setnull(ll_encounter_id)
else
	ll_encounter_id = current_service.encounter_id
end if

if isnull(ll_encounter_id) then
	setnull(ld_open_encounter_date)
	setnull(current_encounter.encounter_id)
	st_current_encounter.visible = false
	st_current_encounter_title.visible = false
	st_how_long_ago.y -= 168
	st_how_long_ago_title.y -= 168
	st_other_encounter.y -= 168
	st_other_encounter_title.y -= 168
	st_today.y -= 168
	st_today_title.y -= 168
	st_other_date.y -= 168
	st_other_date_title.y -= 168
else
	li_sts = current_patient.encounters.encounter(current_encounter, ll_encounter_id)
	st_current_encounter.text = string(current_encounter.encounter_date, date_format_string)
end if

// Set the today button
st_today.text = string(today())

// Now figure out which button is already pressed
ld_open_encounter_date = date(current_patient.encounters.encounter_date(open_encounter_id))

if open_encounter_id = current_encounter.encounter_id &
 and (begin_date = ld_open_encounter_date or isnull(begin_date) ) then
 	begin_date = ld_open_encounter_date
	st_current_encounter.backcolor = color_object_selected
elseif not isnull(open_encounter_id)  &
 and (begin_date = ld_open_encounter_date or isnull(begin_date) ) then
	begin_date = ld_open_encounter_date
	st_other_encounter.text = string(begin_date, date_format_string)
	st_other_encounter.backcolor = color_object_selected
elseif not isnull(begin_date) then
	if begin_date = today() then
		st_today.backcolor = color_object_selected
	else
		st_other_date.text = string(begin_date, date_format_string)
		st_other_date.backcolor = color_object_selected
	end if
end if


// See if we should display the duration
if not popup.multiselect then
	setnull(end_date)
	st_end_date_interval_title.visible = false
	st_end_date_date_title.visible = false
	st_end_date_or.visible = false
	st_end_date_interval.visible = false
	st_end_date_date.visible = false
	st_duration_title.visible = false
	st_onset_title.x += 550
	st_current_encounter.x += 550
	st_current_encounter_title.x += 550
	st_how_long_ago.x += 550
	st_how_long_ago_title.x += 550
	st_other_encounter.x += 550
	st_other_encounter_title.x += 550
	st_today.x += 550
	st_today_title.x += 550
	st_other_date.x += 550
	st_other_date_title.x += 550
	st_onset_title.text = "Treatment Date"
end if

display_end_date()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_onset_duration
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_onset_duration
end type

type pb_done from u_picture_button within w_onset_duration
integer x = 2181
integer y = 1392
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return


popup_return.item_count = 3
popup_return.items[1] = string(begin_date, "[shortdate]")
popup_return.items[2] = string(end_date, "[shortdate]")
popup_return.items[3] = string(open_encounter_id)

closewithreturn(parent, popup_return)

end event

type pb_cancel from u_picture_button within w_onset_duration
integer x = 73
integer y = 1392
boolean bringtotop = true
boolean cancel = true
boolean originalsize = false
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return


popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type st_end_date_interval from statictext within w_onset_duration
integer x = 1650
integer y = 944
integer width = 544
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp
date ld_end_date

if isnull(begin_date) then
	openwithparm(w_pop_message, "You must select an onset before selecting a duration.")
	return
end if

ld_end_date = end_date

ls_temp = f_select_date_interval(ld_end_date, "Treatment Duration", begin_date, "DURATION")
if isnull(ls_temp) then return

if ld_end_date > today() then
	openwithparm(w_pop_message, "The end date cannot be in the future")
	return
end if

end_date = ld_end_date

display_end_date()

end event

type st_other_date from statictext within w_onset_duration
integer x = 727
integer y = 1112
integer width = 544
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp
date ld_begin_date

ld_begin_date = begin_date
ls_temp = f_select_date(ld_begin_date, "Treatment Date")
if isnull(ls_temp) then return

if ld_begin_date > today() then
	openwithparm(w_pop_message, "The begin date cannot be in the future")
	return
end if

if ld_begin_date < date(current_patient.date_of_birth) then
	openwithparm(w_pop_message, "The begin date cannot be prior to the birth of the patient")
	return
end if


backcolor = color_object_selected
st_how_long_ago.backcolor = color_object
st_other_encounter.backcolor = color_object
st_current_encounter.backcolor = color_object
st_today.backcolor = color_object

set_begin_date(ld_begin_date)
text = string(begin_date, date_format_string)


end event

type st_title from statictext within w_onset_duration
integer width = 2519
integer height = 128
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
string text = "none"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_instructions from statictext within w_onset_duration
integer x = 384
integer y = 160
integer width = 1746
integer height = 192
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "This treatment occured in the past.  Please specify when this treatment occured."
alignment alignment = center!
boolean focusrectangle = false
end type

type st_current_encounter_title from statictext within w_onset_duration
integer x = 151
integer y = 628
integer width = 558
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Current Encounter:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_current_encounter from statictext within w_onset_duration
integer x = 727
integer y = 608
integer width = 544
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_how_long_ago.backcolor = color_object
st_other_encounter.backcolor = color_object
st_other_date.backcolor = color_object
st_today.backcolor = color_object

open_encounter_id = current_encounter.encounter_id
set_begin_date(date(current_encounter.encounter_date))

end event

type st_how_long_ago_title from statictext within w_onset_duration
integer x = 82
integer y = 1300
integer width = 626
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "How Long Ago:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_how_long_ago from statictext within w_onset_duration
integer x = 727
integer y = 1280
integer width = 544
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp
date ld_begin_date

ld_begin_date = begin_date
ls_temp = f_select_date_interval(ld_begin_date, "Treatment Date", today(), "ONSET")
if isnull(ls_temp) then return

backcolor = color_object_selected
st_current_encounter.backcolor = color_object
st_other_encounter.backcolor = color_object
st_other_date.backcolor = color_object
st_today.backcolor = color_object

set_begin_date(ld_begin_date)
text = ls_temp


end event

type st_other_encounter_title from statictext within w_onset_duration
integer x = 82
integer y = 796
integer width = 626
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Other Encounter:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_other_date_title from statictext within w_onset_duration
integer x = 82
integer y = 1132
integer width = 626
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Other Date:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_onset_title from statictext within w_onset_duration
integer x = 206
integer y = 440
integer width = 1047
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Treatment Onset"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_duration_title from statictext within w_onset_duration
integer x = 1358
integer y = 440
integer width = 1129
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Treatment Duration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_end_date_date from statictext within w_onset_duration
integer x = 1650
integer y = 656
integer width = 544
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp
date ld_end_date

if isnull(begin_date) then
	openwithparm(w_pop_message, "You must select an onset before selecting a duration.")
	return
end if

ld_end_date = end_date

ls_temp = f_select_date(ld_end_date, "Treatment End Date")
if isnull(ls_temp) then return

if ld_end_date < begin_date then
	openwithparm(w_pop_message, "The end date cannot be prior to the begin date")
	return
end if

if ld_end_date > today() then
	openwithparm(w_pop_message, "The end date cannot be in the future")
	return
end if

end_date = ld_end_date

display_end_date()

end event

type st_end_date_or from statictext within w_onset_duration
integer x = 1842
integer y = 780
integer width = 155
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "or"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_end_date_interval_title from statictext within w_onset_duration
integer x = 1650
integer y = 872
integer width = 544
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "For How Long"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_end_date_date_title from statictext within w_onset_duration
integer x = 1650
integer y = 584
integer width = 544
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Specific Date"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_clear_end_date from commandbutton within w_onset_duration
integer x = 1737
integer y = 1124
integer width = 370
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear End Date"
end type

event clicked;setnull(end_date)
display_end_date()

end event

type st_today_title from statictext within w_onset_duration
integer x = 82
integer y = 964
integer width = 626
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Today:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_today from statictext within w_onset_duration
integer x = 727
integer y = 944
integer width = 544
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
backcolor = color_object_selected
st_how_long_ago.backcolor = color_object
st_other_encounter.backcolor = color_object
st_current_encounter.backcolor = color_object
st_other_date.backcolor = color_object

set_begin_date(today())
text = string(begin_date)


end event

type st_other_encounter from statictext within w_onset_duration
integer x = 727
integer y = 776
integer width = 544
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return
integer li_sts
w_window_base lw_window

popup.title = "Select Encounter"
popup.data_row_count = 2
popup.items[1] = current_patient.cpr_id
popup.items[2] = "PICK"
openwithparm(lw_window, popup, "w_encounter_list_pick")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

backcolor = color_object_selected
st_current_encounter.backcolor = color_object
st_how_long_ago.backcolor = color_object
st_other_date.backcolor = color_object
st_today.backcolor = color_object

open_encounter_id = long(popup_return.items[1])
set_begin_date(date(current_patient.encounters.encounter_date(open_encounter_id)))
text = string(begin_date, date_format_string)


end event

