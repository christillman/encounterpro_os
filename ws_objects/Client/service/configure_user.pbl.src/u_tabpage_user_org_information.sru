$PBExportHeader$u_tabpage_user_org_information.sru
forward
global type u_tabpage_user_org_information from u_tabpage_user_base
end type
type sle_organization_contact from singlelineedit within u_tabpage_user_org_information
end type
type st_contact_title from statictext within u_tabpage_user_org_information
end type
type st_director_title from statictext within u_tabpage_user_org_information
end type
type sle_organization_director from singlelineedit within u_tabpage_user_org_information
end type
type st_title_title from statictext within u_tabpage_user_org_information
end type
type sle_title from singlelineedit within u_tabpage_user_org_information
end type
type st_user_status from statictext within u_tabpage_user_org_information
end type
type st_user_status_title from statictext within u_tabpage_user_org_information
end type
type st_user_full_name_title from statictext within u_tabpage_user_org_information
end type
type sle_full_name from singlelineedit within u_tabpage_user_org_information
end type
type st_specialty from statictext within u_tabpage_user_org_information
end type
type st_specialty_title from statictext within u_tabpage_user_org_information
end type
end forward

global type u_tabpage_user_org_information from u_tabpage_user_base
string tag = "Organization"
integer width = 2921
integer height = 1312
sle_organization_contact sle_organization_contact
st_contact_title st_contact_title
st_director_title st_director_title
sle_organization_director sle_organization_director
st_title_title st_title_title
sle_title sle_title
st_user_status st_user_status
st_user_status_title st_user_status_title
st_user_full_name_title st_user_full_name_title
sle_full_name sle_full_name
st_specialty st_specialty
st_specialty_title st_specialty_title
end type
global u_tabpage_user_org_information u_tabpage_user_org_information

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

sle_organization_director.text = user.organization_director
sle_title.text = user.title
sle_organization_contact.text = user.organization_contact



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

on u_tabpage_user_org_information.create
int iCurrent
call super::create
this.sle_organization_contact=create sle_organization_contact
this.st_contact_title=create st_contact_title
this.st_director_title=create st_director_title
this.sle_organization_director=create sle_organization_director
this.st_title_title=create st_title_title
this.sle_title=create sle_title
this.st_user_status=create st_user_status
this.st_user_status_title=create st_user_status_title
this.st_user_full_name_title=create st_user_full_name_title
this.sle_full_name=create sle_full_name
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_organization_contact
this.Control[iCurrent+2]=this.st_contact_title
this.Control[iCurrent+3]=this.st_director_title
this.Control[iCurrent+4]=this.sle_organization_director
this.Control[iCurrent+5]=this.st_title_title
this.Control[iCurrent+6]=this.sle_title
this.Control[iCurrent+7]=this.st_user_status
this.Control[iCurrent+8]=this.st_user_status_title
this.Control[iCurrent+9]=this.st_user_full_name_title
this.Control[iCurrent+10]=this.sle_full_name
this.Control[iCurrent+11]=this.st_specialty
this.Control[iCurrent+12]=this.st_specialty_title
end on

on u_tabpage_user_org_information.destroy
call super::destroy
destroy(this.sle_organization_contact)
destroy(this.st_contact_title)
destroy(this.st_director_title)
destroy(this.sle_organization_director)
destroy(this.st_title_title)
destroy(this.sle_title)
destroy(this.st_user_status)
destroy(this.st_user_status_title)
destroy(this.st_user_full_name_title)
destroy(this.sle_full_name)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
end on

type sle_organization_contact from singlelineedit within u_tabpage_user_org_information
integer x = 558
integer y = 276
integer width = 1280
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
	user.organization_contact = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"organization_contact", &
										user.organization_contact)
else
	setnull(user.organization_contact)
end if


end event

type st_contact_title from statictext within u_tabpage_user_org_information
integer x = 69
integer y = 292
integer width = 466
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Contact Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_director_title from statictext within u_tabpage_user_org_information
integer x = 128
integer y = 152
integer width = 407
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Director:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_organization_director from singlelineedit within u_tabpage_user_org_information
integer x = 558
integer y = 136
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
	user.organization_director = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"organization_director", &
										user.organization_director)
else
	setnull(user.organization_director)
end if


end event

type st_title_title from statictext within u_tabpage_user_org_information
integer x = 1591
integer y = 152
integer width = 165
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Title:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_title from singlelineedit within u_tabpage_user_org_information
integer x = 1778
integer y = 136
integer width = 645
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
	user.title = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"title", &
										user.title)
else
	setnull(user.title)
end if


end event

type st_user_status from statictext within u_tabpage_user_org_information
integer x = 2336
integer y = 568
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

type st_user_status_title from statictext within u_tabpage_user_org_information
integer x = 1938
integer y = 584
integer width = 375
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_user_full_name_title from statictext within u_tabpage_user_org_information
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
long backcolor = 7191717
boolean enabled = false
string text = "Display As:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_full_name from singlelineedit within u_tabpage_user_org_information
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

type st_specialty from statictext within u_tabpage_user_org_information
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

type st_specialty_title from statictext within u_tabpage_user_org_information
integer x = 1989
integer y = 448
integer width = 325
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 7191717
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

