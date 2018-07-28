HA$PBExportHeader$w_pop_picked_assessment_properties.srw
forward
global type w_pop_picked_assessment_properties from window
end type
type st_end_date_duration from statictext within w_pop_picked_assessment_properties
end type
type st_end_date_date from statictext within w_pop_picked_assessment_properties
end type
type st_onset_date from statictext within w_pop_picked_assessment_properties
end type
type st_onset_duration from statictext within w_pop_picked_assessment_properties
end type
type st_begin_date from statictext within w_pop_picked_assessment_properties
end type
type st_end_date from statictext within w_pop_picked_assessment_properties
end type
type st_begin_date_title from statictext within w_pop_picked_assessment_properties
end type
type st_end_date_title from statictext within w_pop_picked_assessment_properties
end type
type st_leave_open from statictext within w_pop_picked_assessment_properties
end type
type st_leave_open_title from statictext within w_pop_picked_assessment_properties
end type
type pb_cancel from u_picture_button within w_pop_picked_assessment_properties
end type
type st_description from statictext within w_pop_picked_assessment_properties
end type
type pb_ok from u_picture_button within w_pop_picked_assessment_properties
end type
end forward

global type w_pop_picked_assessment_properties from window
integer x = 434
integer y = 604
integer width = 2299
integer height = 1332
windowtype windowtype = response!
long backcolor = 33538240
st_end_date_duration st_end_date_duration
st_end_date_date st_end_date_date
st_onset_date st_onset_date
st_onset_duration st_onset_duration
st_begin_date st_begin_date
st_end_date st_end_date
st_begin_date_title st_begin_date_title
st_end_date_title st_end_date_title
st_leave_open st_leave_open
st_leave_open_title st_leave_open_title
pb_cancel pb_cancel
st_description st_description
pb_ok pb_ok
end type
global w_pop_picked_assessment_properties w_pop_picked_assessment_properties

type variables
str_picked_assessment assessment

end variables

event open;real lr_amount
string ls_unit

assessment = message.powerobjectparm

st_description.text = assessment.description

if not isnull(assessment.begin_date) then
	f_pretty_date_interval(assessment.begin_date, today(), lr_amount, ls_unit)
	st_begin_date.text = f_pretty_amount_unit(lr_amount, ls_unit) + " Ago"
	
	if not isnull(assessment.end_date) then
		f_pretty_date_interval(assessment.begin_date, assessment.end_date, lr_amount, ls_unit)
		st_end_date.text = f_pretty_amount_unit(lr_amount, ls_unit)
	else
		st_end_date.text = ""
	end if
else
	st_end_date_title.visible = false
	st_end_date.visible = false
	st_end_date_date.visible = false
	st_end_date_duration.visible = false
end if

if assessment.leave_open then
	st_leave_open.text = "Yes"
else
	st_leave_open.text = "No"
end if


end event

on w_pop_picked_assessment_properties.create
this.st_end_date_duration=create st_end_date_duration
this.st_end_date_date=create st_end_date_date
this.st_onset_date=create st_onset_date
this.st_onset_duration=create st_onset_duration
this.st_begin_date=create st_begin_date
this.st_end_date=create st_end_date
this.st_begin_date_title=create st_begin_date_title
this.st_end_date_title=create st_end_date_title
this.st_leave_open=create st_leave_open
this.st_leave_open_title=create st_leave_open_title
this.pb_cancel=create pb_cancel
this.st_description=create st_description
this.pb_ok=create pb_ok
this.Control[]={this.st_end_date_duration,&
this.st_end_date_date,&
this.st_onset_date,&
this.st_onset_duration,&
this.st_begin_date,&
this.st_end_date,&
this.st_begin_date_title,&
this.st_end_date_title,&
this.st_leave_open,&
this.st_leave_open_title,&
this.pb_cancel,&
this.st_description,&
this.pb_ok}
end on

on w_pop_picked_assessment_properties.destroy
destroy(this.st_end_date_duration)
destroy(this.st_end_date_date)
destroy(this.st_onset_date)
destroy(this.st_onset_duration)
destroy(this.st_begin_date)
destroy(this.st_end_date)
destroy(this.st_begin_date_title)
destroy(this.st_end_date_title)
destroy(this.st_leave_open)
destroy(this.st_leave_open_title)
destroy(this.pb_cancel)
destroy(this.st_description)
destroy(this.pb_ok)
end on

type st_end_date_duration from statictext within w_pop_picked_assessment_properties
integer x = 1216
integer y = 584
integer width = 402
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "How long"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp

if isnull(assessment.begin_date) then
	openwithparm(w_pop_message, "You must select an onset before selecting a duration.")
	return
end if
ls_temp = f_select_date_interval(assessment.end_date, "Assessment Duration", assessment.begin_date, "DURATION")
if not isnull(ls_temp) then st_end_date.text = ls_temp

end event

type st_end_date_date from statictext within w_pop_picked_assessment_properties
integer x = 1641
integer y = 584
integer width = 402
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Specific Date"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp

if isnull(assessment.begin_date) then
	openwithparm(w_pop_message, "You must select an onset before selecting a duration.")
	return
end if
ls_temp = f_select_date(assessment.end_date, "Assessment Duration")
if not isnull(ls_temp) then st_end_date.text = ls_temp

end event

type st_onset_date from statictext within w_pop_picked_assessment_properties
integer x = 699
integer y = 584
integer width = 402
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Specific Date"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp

ls_temp = f_select_date(assessment.begin_date, "Assessment Onset")
if not isnull(ls_temp) then
	st_begin_date.text = ls_temp
	st_end_date_date.visible = true
	st_end_date_duration.visible = true
	st_end_date.visible = true
	st_end_date_title.visible = true
end if

end event

type st_onset_duration from statictext within w_pop_picked_assessment_properties
integer x = 274
integer y = 584
integer width = 402
integer height = 92
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "How long ago"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_temp

ls_temp = f_select_date_interval(assessment.begin_date, "Assessment Onset", today(), "ONSET")
if not isnull(ls_temp) then
	st_begin_date.text = ls_temp
	st_end_date_date.visible = true
	st_end_date_duration.visible = true
	st_end_date.visible = true
	st_end_date_title.visible = true
end if

end event

type st_begin_date from statictext within w_pop_picked_assessment_properties
integer x = 274
integer y = 448
integer width = 827
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_end_date from statictext within w_pop_picked_assessment_properties
integer x = 1216
integer y = 448
integer width = 827
integer height = 108
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
boolean focusrectangle = false
end type

type st_begin_date_title from statictext within w_pop_picked_assessment_properties
integer x = 274
integer y = 356
integer width = 827
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Onset"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_end_date_title from statictext within w_pop_picked_assessment_properties
integer x = 1216
integer y = 356
integer width = 827
integer height = 84
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Duration"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_leave_open from statictext within w_pop_picked_assessment_properties
integer x = 1326
integer y = 888
integer width = 178
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;
assessment.leave_open = not assessment.leave_open
if assessment.leave_open then
	text = "Yes"
else
	text = "No"
end if



end event

type st_leave_open_title from statictext within w_pop_picked_assessment_properties
integer x = 640
integer y = 908
integer width = 663
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Leave Assessment Open:"
alignment alignment = right!
boolean focusrectangle = false
end type

type pb_cancel from u_picture_button within w_pop_picked_assessment_properties
integer x = 55
integer y = 1056
integer taborder = 20
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;setnull(assessment.assessment_id)
setnull(assessment.description)
setnull(assessment.begin_date)
setnull(assessment.end_date)
setnull(assessment.leave_open)

closewithreturn(parent, assessment)

end event

type st_description from statictext within w_pop_picked_assessment_properties
integer width = 2299
integer height = 132
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Enter the ICD code of the assessment"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_ok from u_picture_button within w_pop_picked_assessment_properties
integer x = 1975
integer y = 1056
integer taborder = 10
boolean default = true
boolean originalsize = false
string picturename = "button26.bmp"
string disabledname = "button26.bmp"
end type

event clicked;call super::clicked;closewithreturn(parent, assessment)

end event

