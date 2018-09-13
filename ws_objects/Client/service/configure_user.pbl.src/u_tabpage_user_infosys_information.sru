$PBExportHeader$u_tabpage_user_infosys_information.sru
forward
global type u_tabpage_user_infosys_information from u_tabpage_user_base
end type
type st_web_upload_title from statictext within u_tabpage_user_infosys_information
end type
type sle_web_upload from singlelineedit within u_tabpage_user_infosys_information
end type
type sle_web_page from singlelineedit within u_tabpage_user_infosys_information
end type
type st_web_page_title from statictext within u_tabpage_user_infosys_information
end type
type st_type_title from statictext within u_tabpage_user_infosys_information
end type
type sle_information_system_type from singlelineedit within u_tabpage_user_infosys_information
end type
type st_title_title from statictext within u_tabpage_user_infosys_information
end type
type sle_information_system_version from singlelineedit within u_tabpage_user_infosys_information
end type
type st_user_status from statictext within u_tabpage_user_infosys_information
end type
type st_user_status_title from statictext within u_tabpage_user_infosys_information
end type
type st_user_full_name_title from statictext within u_tabpage_user_infosys_information
end type
type sle_full_name from singlelineedit within u_tabpage_user_infosys_information
end type
type st_specialty from statictext within u_tabpage_user_infosys_information
end type
type st_specialty_title from statictext within u_tabpage_user_infosys_information
end type
end forward

global type u_tabpage_user_infosys_information from u_tabpage_user_base
string tag = "Information System"
integer width = 2921
integer height = 1312
st_web_upload_title st_web_upload_title
sle_web_upload sle_web_upload
sle_web_page sle_web_page
st_web_page_title st_web_page_title
st_type_title st_type_title
sle_information_system_type sle_information_system_type
st_title_title st_title_title
sle_information_system_version sle_information_system_version
st_user_status st_user_status
st_user_status_title st_user_status_title
st_user_full_name_title st_user_full_name_title
sle_full_name sle_full_name
st_specialty st_specialty
st_specialty_title st_specialty_title
end type
global u_tabpage_user_infosys_information u_tabpage_user_infosys_information

type variables
long web_page_index
long web_upload_index

end variables

forward prototypes
public subroutine set_fields ()
public subroutine refresh ()
public function integer initialize ()
end prototypes

public subroutine set_fields ();

return

end subroutine

public subroutine refresh ();sle_full_name.text	= user.user_full_name

sle_information_system_type.text = user.information_system_type
sle_information_system_version.text = user.information_system_version



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


sle_web_page.text	= user.communication[web_page_index].communication_value
sle_web_upload.text	= user.communication[web_upload_index].communication_value


end subroutine

public function integer initialize ();web_page_index = user.get_communication_index("URL", "Web Page")
web_upload_index = user.get_communication_index("URL", "Web Upload")

return 1

end function

on u_tabpage_user_infosys_information.create
int iCurrent
call super::create
this.st_web_upload_title=create st_web_upload_title
this.sle_web_upload=create sle_web_upload
this.sle_web_page=create sle_web_page
this.st_web_page_title=create st_web_page_title
this.st_type_title=create st_type_title
this.sle_information_system_type=create sle_information_system_type
this.st_title_title=create st_title_title
this.sle_information_system_version=create sle_information_system_version
this.st_user_status=create st_user_status
this.st_user_status_title=create st_user_status_title
this.st_user_full_name_title=create st_user_full_name_title
this.sle_full_name=create sle_full_name
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_web_upload_title
this.Control[iCurrent+2]=this.sle_web_upload
this.Control[iCurrent+3]=this.sle_web_page
this.Control[iCurrent+4]=this.st_web_page_title
this.Control[iCurrent+5]=this.st_type_title
this.Control[iCurrent+6]=this.sle_information_system_type
this.Control[iCurrent+7]=this.st_title_title
this.Control[iCurrent+8]=this.sle_information_system_version
this.Control[iCurrent+9]=this.st_user_status
this.Control[iCurrent+10]=this.st_user_status_title
this.Control[iCurrent+11]=this.st_user_full_name_title
this.Control[iCurrent+12]=this.sle_full_name
this.Control[iCurrent+13]=this.st_specialty
this.Control[iCurrent+14]=this.st_specialty_title
end on

on u_tabpage_user_infosys_information.destroy
call super::destroy
destroy(this.st_web_upload_title)
destroy(this.sle_web_upload)
destroy(this.sle_web_page)
destroy(this.st_web_page_title)
destroy(this.st_type_title)
destroy(this.sle_information_system_type)
destroy(this.st_title_title)
destroy(this.sle_information_system_version)
destroy(this.st_user_status)
destroy(this.st_user_status_title)
destroy(this.st_user_full_name_title)
destroy(this.sle_full_name)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
end on

type st_web_upload_title from statictext within u_tabpage_user_infosys_information
integer x = 41
integer y = 1044
integer width = 494
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Web Upload:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_web_upload from singlelineedit within u_tabpage_user_infosys_information
integer x = 558
integer y = 1028
integer width = 2290
integer height = 108
integer taborder = 30
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
	user.communication[web_upload_index].communication_value = text
else
	setnull(user.communication[web_upload_index].communication_value)
end if

user.update_communication(web_upload_index)

end event

type sle_web_page from singlelineedit within u_tabpage_user_infosys_information
integer x = 558
integer y = 888
integer width = 2290
integer height = 108
integer taborder = 20
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
	user.communication[web_page_index].communication_value = text
else
	setnull(user.communication[web_page_index].communication_value)
end if

user.update_communication(web_page_index)

end event

type st_web_page_title from statictext within u_tabpage_user_infosys_information
integer x = 41
integer y = 904
integer width = 494
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Web Page:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_type_title from statictext within u_tabpage_user_infosys_information
integer x = 41
integer y = 152
integer width = 494
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "System Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_information_system_type from singlelineedit within u_tabpage_user_infosys_information
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
	user.information_system_type = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"information_system_type", &
										user.information_system_type)
else
	setnull(user.information_system_type)
end if


end event

type st_title_title from statictext within u_tabpage_user_infosys_information
integer x = 1591
integer y = 152
integer width = 251
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Version:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_information_system_version from singlelineedit within u_tabpage_user_infosys_information
integer x = 1861
integer y = 140
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
	user.information_system_version = text
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"information_system_version", &
										user.information_system_version)
else
	setnull(user.information_system_version)
end if


end event

type st_user_status from statictext within u_tabpage_user_infosys_information
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

type st_user_status_title from statictext within u_tabpage_user_infosys_information
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
long backcolor = 33538240
boolean enabled = false
string text = "Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_user_full_name_title from statictext within u_tabpage_user_infosys_information
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
long backcolor = 33538240
boolean enabled = false
string text = "Display As:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_full_name from singlelineedit within u_tabpage_user_infosys_information
integer x = 558
integer y = 12
integer width = 1947
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

event modified;
if len(trim(text)) > 0 then
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

type st_specialty from statictext within u_tabpage_user_infosys_information
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

type st_specialty_title from statictext within u_tabpage_user_infosys_information
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
long backcolor = 33538240
boolean enabled = false
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

