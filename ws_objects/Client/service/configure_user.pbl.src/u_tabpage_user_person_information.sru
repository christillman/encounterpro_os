$PBExportHeader$u_tabpage_user_person_information.sru
forward
global type u_tabpage_user_person_information from u_tabpage_user_base
end type
type sle_last_name from singlelineedit within u_tabpage_user_person_information
end type
type st_last_name_title from statictext within u_tabpage_user_person_information
end type
type st_first_name_title from statictext within u_tabpage_user_person_information
end type
type sle_first_name from singlelineedit within u_tabpage_user_person_information
end type
type st_middle_name_title from statictext within u_tabpage_user_person_information
end type
type sle_middle_name from singlelineedit within u_tabpage_user_person_information
end type
type sle_name_prefix from singlelineedit within u_tabpage_user_person_information
end type
type st_name_prefix_title from statictext within u_tabpage_user_person_information
end type
type sle_name_suffix from singlelineedit within u_tabpage_user_person_information
end type
type st_name_suffix_title from statictext within u_tabpage_user_person_information
end type
type sle_degree from singlelineedit within u_tabpage_user_person_information
end type
type st_degree_title from statictext within u_tabpage_user_person_information
end type
type st_user_status from statictext within u_tabpage_user_person_information
end type
type st_user_status_title from statictext within u_tabpage_user_person_information
end type
type st_user_full_name_title from statictext within u_tabpage_user_person_information
end type
type sle_full_name from singlelineedit within u_tabpage_user_person_information
end type
type st_specialty from statictext within u_tabpage_user_person_information
end type
type st_specialty_title from statictext within u_tabpage_user_person_information
end type
end forward

global type u_tabpage_user_person_information from u_tabpage_user_base
string tag = "Person"
integer width = 2921
integer height = 1312
sle_last_name sle_last_name
st_last_name_title st_last_name_title
st_first_name_title st_first_name_title
sle_first_name sle_first_name
st_middle_name_title st_middle_name_title
sle_middle_name sle_middle_name
sle_name_prefix sle_name_prefix
st_name_prefix_title st_name_prefix_title
sle_name_suffix sle_name_suffix
st_name_suffix_title st_name_suffix_title
sle_degree sle_degree
st_degree_title st_degree_title
st_user_status st_user_status
st_user_status_title st_user_status_title
st_user_full_name_title st_user_full_name_title
sle_full_name sle_full_name
st_specialty st_specialty
st_specialty_title st_specialty_title
end type
global u_tabpage_user_person_information u_tabpage_user_person_information

type variables

end variables

forward prototypes
public subroutine set_fields ()
public subroutine refresh ()
end prototypes

public subroutine set_fields ();

return

end subroutine

public subroutine refresh ();sle_full_name.text	= user.user_full_name

sle_last_name.text = user.last_name
sle_first_name.text = user.first_name
sle_middle_name.text = user.middle_name
sle_name_prefix.text = user.name_prefix
sle_name_suffix.text = user.name_suffix
sle_degree.text = user.degree



if isnull(user.specialty_id) then
	st_specialty.text = "<N/A>"
else
	st_specialty.text = datalist.specialty_description(user.specialty_id)
end if

if user.user_status = "OK" then
	st_user_status.text = "Active"
else
	st_user_status.text = "Inactive"
end if


end subroutine

on u_tabpage_user_person_information.create
int iCurrent
call super::create
this.sle_last_name=create sle_last_name
this.st_last_name_title=create st_last_name_title
this.st_first_name_title=create st_first_name_title
this.sle_first_name=create sle_first_name
this.st_middle_name_title=create st_middle_name_title
this.sle_middle_name=create sle_middle_name
this.sle_name_prefix=create sle_name_prefix
this.st_name_prefix_title=create st_name_prefix_title
this.sle_name_suffix=create sle_name_suffix
this.st_name_suffix_title=create st_name_suffix_title
this.sle_degree=create sle_degree
this.st_degree_title=create st_degree_title
this.st_user_status=create st_user_status
this.st_user_status_title=create st_user_status_title
this.st_user_full_name_title=create st_user_full_name_title
this.sle_full_name=create sle_full_name
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_last_name
this.Control[iCurrent+2]=this.st_last_name_title
this.Control[iCurrent+3]=this.st_first_name_title
this.Control[iCurrent+4]=this.sle_first_name
this.Control[iCurrent+5]=this.st_middle_name_title
this.Control[iCurrent+6]=this.sle_middle_name
this.Control[iCurrent+7]=this.sle_name_prefix
this.Control[iCurrent+8]=this.st_name_prefix_title
this.Control[iCurrent+9]=this.sle_name_suffix
this.Control[iCurrent+10]=this.st_name_suffix_title
this.Control[iCurrent+11]=this.sle_degree
this.Control[iCurrent+12]=this.st_degree_title
this.Control[iCurrent+13]=this.st_user_status
this.Control[iCurrent+14]=this.st_user_status_title
this.Control[iCurrent+15]=this.st_user_full_name_title
this.Control[iCurrent+16]=this.sle_full_name
this.Control[iCurrent+17]=this.st_specialty
this.Control[iCurrent+18]=this.st_specialty_title
end on

on u_tabpage_user_person_information.destroy
call super::destroy
destroy(this.sle_last_name)
destroy(this.st_last_name_title)
destroy(this.st_first_name_title)
destroy(this.sle_first_name)
destroy(this.st_middle_name_title)
destroy(this.sle_middle_name)
destroy(this.sle_name_prefix)
destroy(this.st_name_prefix_title)
destroy(this.sle_name_suffix)
destroy(this.st_name_suffix_title)
destroy(this.sle_degree)
destroy(this.st_degree_title)
destroy(this.st_user_status)
destroy(this.st_user_status_title)
destroy(this.st_user_full_name_title)
destroy(this.sle_full_name)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
end on

type sle_last_name from singlelineedit within u_tabpage_user_person_information
integer x = 558
integer y = 284
integer width = 1001
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.last_name = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"last_name", &
										user.last_name)
else
	setnull(user.last_name)
end if


end event

type st_last_name_title from statictext within u_tabpage_user_person_information
integer x = 128
integer y = 300
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Last Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_first_name_title from statictext within u_tabpage_user_person_information
integer x = 128
integer y = 428
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "First Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_first_name from singlelineedit within u_tabpage_user_person_information
integer x = 558
integer y = 412
integer width = 1001
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.first_name = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"first_name", &
										user.first_name)
else
	setnull(user.first_name)
end if


end event

type st_middle_name_title from statictext within u_tabpage_user_person_information
integer x = 119
integer y = 556
integer width = 416
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Middle Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_middle_name from singlelineedit within u_tabpage_user_person_information
integer x = 558
integer y = 540
integer width = 1001
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.middle_name = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"middle_name", &
										user.middle_name)
else
	setnull(user.middle_name)
end if


end event

type sle_name_prefix from singlelineedit within u_tabpage_user_person_information
integer x = 558
integer y = 668
integer width = 1001
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.name_prefix = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"name_prefix", &
										user.name_prefix)
else
	setnull(user.name_prefix)
end if


end event

type st_name_prefix_title from statictext within u_tabpage_user_person_information
integer x = 128
integer y = 684
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Name Prefix:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_name_suffix from singlelineedit within u_tabpage_user_person_information
integer x = 558
integer y = 796
integer width = 1001
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.name_suffix = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"name_suffix", &
										user.name_suffix)
else
	setnull(user.name_suffix)
end if


end event

type st_name_suffix_title from statictext within u_tabpage_user_person_information
integer x = 128
integer y = 812
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Name Suffix:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_degree from singlelineedit within u_tabpage_user_person_information
integer x = 558
integer y = 924
integer width = 1001
integer height = 108
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 100
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.degree = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"degree", &
										user.degree)
else
	setnull(user.degree)
end if


end event

type st_degree_title from statictext within u_tabpage_user_person_information
integer x = 128
integer y = 940
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Degree:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_user_status from statictext within u_tabpage_user_person_information
integer x = 2336
integer y = 428
integer width = 530
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_license_flag
str_popup_return popup_return
integer li_sts

if isnull(user.user_id) then
	if user.user_status = "OK" then
		user.user_status = "NA"
		text = "Inactive"
	else
		user.user_status = "OK"
		text = "Active"
	end if
else
	if user.user_status = "OK" then
		ls_license_flag = user_list.user_property(user.user_id, "license_flag")
		if not isnull(ls_license_flag) then
			openwithparm(w_pop_yes_no, "You are about to make inactive a licensed user.  You will not be able to re-activate this user for " + string(reactdays) + " days.  Are you sure you want to do this?")
			popup_return = message.powerobjectparm
			if popup_return.item <> "YES" then return
		end if
		li_sts = user_list.inactivate_user(user.user_id)
		if li_sts = 1 then
			user.user_status = "NA"
			text = "Inactive"
		end if
	else
		li_sts = user_list.activate_user(user.user_id)
		if li_sts = 1 then
			user.user_status = "OK"
			text = "Active"
		end if
	end if
end if

set_fields()


end event

type st_user_status_title from statictext within u_tabpage_user_person_information
integer x = 1938
integer y = 444
integer width = 375
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_user_full_name_title from statictext within u_tabpage_user_person_information
integer x = 183
integer y = 24
integer width = 352
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Display As:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_full_name from singlelineedit within u_tabpage_user_person_information
integer x = 558
integer y = 12
integer width = 1646
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if len(trim(text)) > 0 then
	user.user_full_name = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"user_full_name", &
										user.user_full_name)
else
	openwithparm(w_pop_message, "Display As may not be empty")
	text = user.user_full_name
end if


end event

type st_specialty from statictext within u_tabpage_user_person_information
integer x = 2336
integer y = 288
integer width = 530
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_specialty_id

ls_specialty_id = f_pick_specialty("")
if isnull(ls_specialty_id) then return

text = datalist.specialty_description(ls_specialty_id)
user.specialty_id = ls_specialty_id

user_list.set_user_progress( user.user_id, &
									"Modify", &
									"specialty_id", &
									user.specialty_id)

end event

type st_specialty_title from statictext within u_tabpage_user_person_information
integer x = 1989
integer y = 308
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

