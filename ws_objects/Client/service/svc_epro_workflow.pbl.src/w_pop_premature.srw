$PBExportHeader$w_pop_premature.srw
forward
global type w_pop_premature from window
end type
type st_gaa from statictext within w_pop_premature
end type
type sle_weeks_premature from singlelineedit within w_pop_premature
end type
type st_age from statictext within w_pop_premature
end type
type st_date_of_birth from statictext within w_pop_premature
end type
type st_4 from statictext within w_pop_premature
end type
type st_3 from statictext within w_pop_premature
end type
type st_2 from statictext within w_pop_premature
end type
type st_1 from statictext within w_pop_premature
end type
type cb_no from commandbutton within w_pop_premature
end type
type cb_yes from commandbutton within w_pop_premature
end type
end forward

global type w_pop_premature from window
integer x = 439
integer y = 592
integer width = 2034
integer height = 864
windowtype windowtype = response!
long backcolor = 7191717
st_gaa st_gaa
sle_weeks_premature sle_weeks_premature
st_age st_age
st_date_of_birth st_date_of_birth
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
cb_no cb_no
cb_yes cb_yes
end type
global w_pop_premature w_pop_premature

on w_pop_premature.create
this.st_gaa=create st_gaa
this.sle_weeks_premature=create sle_weeks_premature
this.st_age=create st_age
this.st_date_of_birth=create st_date_of_birth
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_no=create cb_no
this.cb_yes=create cb_yes
this.Control[]={this.st_gaa,&
this.sle_weeks_premature,&
this.st_age,&
this.st_date_of_birth,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.cb_no,&
this.cb_yes}
end on

on w_pop_premature.destroy
destroy(this.st_gaa)
destroy(this.sle_weeks_premature)
destroy(this.st_age)
destroy(this.st_date_of_birth)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_no)
destroy(this.cb_yes)
end on

event open;


st_date_of_birth.text = string(current_patient.date_of_birth)
st_age.text = f_pretty_age(current_patient.date_of_birth, today())

sle_weeks_premature.text = string(current_patient.weeks_premature)
st_gaa.text = f_pretty_age(current_patient.gaa_date_of_birth, today())

end event

type st_gaa from statictext within w_pop_premature
integer x = 1157
integer y = 504
integer width = 526
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type sle_weeks_premature from singlelineedit within w_pop_premature
integer x = 1157
integer y = 360
integer width = 402
integer height = 104
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;date ld_gaa_date_of_birth
long ll_weeks_premature
date ld_date_of_conception

if isnumber(sle_weeks_premature.text) then
	ll_weeks_premature = long(sle_weeks_premature.text)
	if ll_weeks_premature >= 0 and ll_weeks_premature < 30 then
		ld_gaa_date_of_birth = relativedate(current_patient.date_of_birth, 7 * ll_weeks_premature)
		st_gaa.text = f_pretty_age(ld_gaa_date_of_birth, today())
	end if
end if


end event

type st_age from statictext within w_pop_premature
integer x = 1157
integer y = 228
integer width = 526
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_date_of_birth from statictext within w_pop_premature
integer x = 1157
integer y = 96
integer width = 526
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_4 from statictext within w_pop_premature
integer x = 142
integer y = 520
integer width = 974
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Gestational Adjusted Age (GAA):"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pop_premature
integer x = 142
integer y = 380
integer width = 974
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Weeks Premature:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pop_premature
integer x = 142
integer y = 244
integer width = 974
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Actual Age:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pop_premature
integer x = 142
integer y = 112
integer width = 974
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Date of Birth:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_no from commandbutton within w_pop_premature
integer x = 59
integer y = 672
integer width = 430
integer height = 136
integer taborder = 20
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

on clicked;str_popup_return popup_return

popup_return.item = "NO"
closewithreturn(parent, popup_return)

end on

type cb_yes from commandbutton within w_pop_premature
integer x = 1541
integer y = 676
integer width = 430
integer height = 136
integer taborder = 10
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "OK"
boolean default = true
end type

event clicked;long ll_weeks_premature
date ld_date_of_conception
string ls_progress
integer li_sts

if isnumber(sle_weeks_premature.text) then
	ll_weeks_premature = long(sle_weeks_premature.text)
	if ll_weeks_premature >= 0 and ll_weeks_premature < 30 and ll_weeks_premature <> current_patient.weeks_premature then
		ld_date_of_conception = relativedate(current_patient.date_of_birth, (ll_weeks_premature - 40) * 7)
		ls_progress = string(ld_date_of_conception, db_datetime_format)
		
		li_sts = current_patient.modify_patient("date_of_conception", ls_progress)
		if li_sts > 0 then
			current_patient.date_of_conception = ld_date_of_conception
			current_patient.calc_gaa()
		end if
	end if
end if

close(parent)

end event

