$PBExportHeader$u_tabpage_user_user_information.sru
forward
global type u_tabpage_user_user_information from u_tabpage_user_base
end type
type st_erx_status from statictext within u_tabpage_user_user_information
end type
type st_erx_status_title from statictext within u_tabpage_user_user_information
end type
type sle_email_address from singlelineedit within u_tabpage_user_user_information
end type
type st_email_address_title from statictext within u_tabpage_user_user_information
end type
type st_user_name from statictext within u_tabpage_user_user_information
end type
type cb_access from commandbutton within u_tabpage_user_user_information
end type
type cb_signature_stamp from commandbutton within u_tabpage_user_user_information
end type
type st_username from statictext within u_tabpage_user_user_information
end type
type st_user_status from statictext within u_tabpage_user_user_information
end type
type st_user_status_title from statictext within u_tabpage_user_user_information
end type
type st_6 from statictext within u_tabpage_user_user_information
end type
type st_primary_office_id from statictext within u_tabpage_user_user_information
end type
type st_1 from statictext within u_tabpage_user_user_information
end type
type st_is_provider_title from statictext within u_tabpage_user_user_information
end type
type st_is_provider from statictext within u_tabpage_user_user_information
end type
type st_initial from statictext within u_tabpage_user_user_information
end type
type sle_user_initial from singlelineedit within u_tabpage_user_user_information
end type
type st_super from statictext within u_tabpage_user_user_information
end type
type st_supervisor from statictext within u_tabpage_user_user_information
end type
type st_last from statictext within u_tabpage_user_user_information
end type
type st_pi from statictext within u_tabpage_user_user_information
end type
type st_4 from statictext within u_tabpage_user_user_information
end type
type st_3 from statictext within u_tabpage_user_user_information
end type
type st_2 from statictext within u_tabpage_user_user_information
end type
type st_color from statictext within u_tabpage_user_user_information
end type
type sle_short_name from singlelineedit within u_tabpage_user_user_information
end type
type sle_full_name from singlelineedit within u_tabpage_user_user_information
end type
type cb_clear_supervisor from commandbutton within u_tabpage_user_user_information
end type
type st_specialty from statictext within u_tabpage_user_user_information
end type
type st_specialty_title from statictext within u_tabpage_user_user_information
end type
end forward

global type u_tabpage_user_user_information from u_tabpage_user_base
string tag = "User"
integer width = 2921
integer height = 1312
st_erx_status st_erx_status
st_erx_status_title st_erx_status_title
sle_email_address sle_email_address
st_email_address_title st_email_address_title
st_user_name st_user_name
cb_access cb_access
cb_signature_stamp cb_signature_stamp
st_username st_username
st_user_status st_user_status
st_user_status_title st_user_status_title
st_6 st_6
st_primary_office_id st_primary_office_id
st_1 st_1
st_is_provider_title st_is_provider_title
st_is_provider st_is_provider
st_initial st_initial
sle_user_initial sle_user_initial
st_super st_super
st_supervisor st_supervisor
st_last st_last
st_pi st_pi
st_4 st_4
st_3 st_3
st_2 st_2
st_color st_color
sle_short_name sle_short_name
sle_full_name sle_full_name
cb_clear_supervisor cb_clear_supervisor
st_specialty st_specialty
st_specialty_title st_specialty_title
end type
global u_tabpage_user_user_information u_tabpage_user_user_information

type variables

end variables

forward prototypes
public subroutine set_fields ()
public subroutine refresh ()
end prototypes

public subroutine set_fields ();

return

end subroutine

public subroutine refresh ();string ls_temp
long ll_interfaceserviceid

sle_full_name.text	= user.user_full_name
sle_short_name.text 	= user.user_short_name
sle_user_initial.text= user.user_initial

IF Isnull(user.color) THEN st_color.backcolor = color_background ELSE &
								st_color.backcolor = user.color

IF isnull(user.license_flag) THEN
	st_is_provider.text = "Staff"
end if

st_user_name.text = f_pretty_name(user.last_name, &
											user.first_name, &
											user.middle_name, &
											user.name_suffix, &
											user.name_prefix, &
											user.degree)

IF isnull(user.username) or user.username = "" then
	st_username.text = "<Username Not Set>"
else
	st_username.text = user.username
end if

if isnull(user.supervisor) then
	st_supervisor.text = "<None>"
	st_supervisor.backcolor = color_object
	cb_clear_supervisor.visible = false
else
	st_supervisor.text = user.supervisor.user_full_name
	st_supervisor.backcolor = user.supervisor.color
	cb_clear_supervisor.visible = true
end if

//original_license_flag = user.license_flag
CHOOSE CASE user.license_flag
	CASE "P"
		st_is_provider.text = "Physician"
	CASE "E"
		st_is_provider.text = "Extender"
	CASE ELSE
		st_is_provider.text = "Staff"
		setnull(user.license_flag)
END CHOOSE

if isnull(user.specialty_id) then
	st_specialty.text = "<N/A>"
else
	st_specialty.text = datalist.specialty_description(user.specialty_id)
end if

st_primary_office_id.text = datalist.office_description(user.primary_office_id)

if user.user_status = "OK" then
	st_user_status.text = "Active"
else
	st_user_status.text = "Inactive"
end if

sle_email_address.text = user.email_address



// See if E-Prescribing is enabled
SELECT max(interfaceserviceid)
INTO :ll_interfaceserviceid
FROM dbo.fn_practice_interfaces()
WHERE status = 'OK'
AND document_route = 'SureScripts';
if not tf_check() then setnull(ll_interfaceserviceid)

if ll_interfaceserviceid > 0 and upper(user.actor_class) = "USER" then
	st_erx_status.visible = true
	st_erx_status_title.visible = true
	ls_temp = sqlca.fn_user_property( user.user_id, "ID", "211^SureScript_SPI")
	if isnull(ls_temp) or len(ls_temp) = 0 then
		st_erx_status.text = "Not Registered"
	else
		st_erx_status.text = "Registered"
	end if
else
	st_erx_status.visible = false
	st_erx_status_title.visible = false
end if

	


end subroutine

on u_tabpage_user_user_information.create
int iCurrent
call super::create
this.st_erx_status=create st_erx_status
this.st_erx_status_title=create st_erx_status_title
this.sle_email_address=create sle_email_address
this.st_email_address_title=create st_email_address_title
this.st_user_name=create st_user_name
this.cb_access=create cb_access
this.cb_signature_stamp=create cb_signature_stamp
this.st_username=create st_username
this.st_user_status=create st_user_status
this.st_user_status_title=create st_user_status_title
this.st_6=create st_6
this.st_primary_office_id=create st_primary_office_id
this.st_1=create st_1
this.st_is_provider_title=create st_is_provider_title
this.st_is_provider=create st_is_provider
this.st_initial=create st_initial
this.sle_user_initial=create sle_user_initial
this.st_super=create st_super
this.st_supervisor=create st_supervisor
this.st_last=create st_last
this.st_pi=create st_pi
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_color=create st_color
this.sle_short_name=create sle_short_name
this.sle_full_name=create sle_full_name
this.cb_clear_supervisor=create cb_clear_supervisor
this.st_specialty=create st_specialty
this.st_specialty_title=create st_specialty_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_erx_status
this.Control[iCurrent+2]=this.st_erx_status_title
this.Control[iCurrent+3]=this.sle_email_address
this.Control[iCurrent+4]=this.st_email_address_title
this.Control[iCurrent+5]=this.st_user_name
this.Control[iCurrent+6]=this.cb_access
this.Control[iCurrent+7]=this.cb_signature_stamp
this.Control[iCurrent+8]=this.st_username
this.Control[iCurrent+9]=this.st_user_status
this.Control[iCurrent+10]=this.st_user_status_title
this.Control[iCurrent+11]=this.st_6
this.Control[iCurrent+12]=this.st_primary_office_id
this.Control[iCurrent+13]=this.st_1
this.Control[iCurrent+14]=this.st_is_provider_title
this.Control[iCurrent+15]=this.st_is_provider
this.Control[iCurrent+16]=this.st_initial
this.Control[iCurrent+17]=this.sle_user_initial
this.Control[iCurrent+18]=this.st_super
this.Control[iCurrent+19]=this.st_supervisor
this.Control[iCurrent+20]=this.st_last
this.Control[iCurrent+21]=this.st_pi
this.Control[iCurrent+22]=this.st_4
this.Control[iCurrent+23]=this.st_3
this.Control[iCurrent+24]=this.st_2
this.Control[iCurrent+25]=this.st_color
this.Control[iCurrent+26]=this.sle_short_name
this.Control[iCurrent+27]=this.sle_full_name
this.Control[iCurrent+28]=this.cb_clear_supervisor
this.Control[iCurrent+29]=this.st_specialty
this.Control[iCurrent+30]=this.st_specialty_title
end on

on u_tabpage_user_user_information.destroy
call super::destroy
destroy(this.st_erx_status)
destroy(this.st_erx_status_title)
destroy(this.sle_email_address)
destroy(this.st_email_address_title)
destroy(this.st_user_name)
destroy(this.cb_access)
destroy(this.cb_signature_stamp)
destroy(this.st_username)
destroy(this.st_user_status)
destroy(this.st_user_status_title)
destroy(this.st_6)
destroy(this.st_primary_office_id)
destroy(this.st_1)
destroy(this.st_is_provider_title)
destroy(this.st_is_provider)
destroy(this.st_initial)
destroy(this.sle_user_initial)
destroy(this.st_super)
destroy(this.st_supervisor)
destroy(this.st_last)
destroy(this.st_pi)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_color)
destroy(this.sle_short_name)
destroy(this.sle_full_name)
destroy(this.cb_clear_supervisor)
destroy(this.st_specialty)
destroy(this.st_specialty_title)
end on

type st_erx_status from statictext within u_tabpage_user_user_information
integer x = 2327
integer y = 464
integer width = 530
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_service_info lstr_service
integer li_sts
string ls_temp

f_attribute_add_attribute(lstr_service.attributes, "prescriber_user_id", user.user_id)
lstr_service.service = "Register Prescriber"

service_list.do_service(lstr_service)

// Refresh the E-Rx status
ls_temp = sqlca.fn_user_property( user.user_id, "ID", "211^SureScript_SPI")
if isnull(ls_temp) or len(ls_temp) = 0 then
	st_erx_status.text = "Not Registered"
else
	st_erx_status.text = "Registered"
end if

end event

type st_erx_status_title from statictext within u_tabpage_user_user_information
integer x = 1829
integer y = 488
integer width = 475
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "E-Rx Status:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_email_address from singlelineedit within u_tabpage_user_user_information
integer x = 503
integer y = 608
integer width = 1193
integer height = 92
integer taborder = 30
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

event modified;user.email_address = text
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"email_address", &
									user.email_address)

end event

type st_email_address_title from statictext within u_tabpage_user_user_information
integer y = 620
integer width = 498
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Email Address:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_user_name from statictext within u_tabpage_user_user_information
integer x = 512
integer y = 44
integer width = 1445
integer height = 104
integer taborder = 160
integer textsize = -9
integer weight = 700
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

event clicked;str_actor_name lstr_name

lstr_name.last_name = user.last_name
lstr_name.first_name = user.first_name
lstr_name.middle_name = user.middle_name
lstr_name.name_suffix = user.name_suffix
lstr_name.name_prefix = user.name_prefix
lstr_name.degree = user.degree
lstr_name.actor_class = user.actor_class


openwithparm(w_user_name_edit, lstr_name)
lstr_name = message.powerobjectparm
if not lstr_name.changed then return

user.last_name = lstr_name.last_name
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"last_name", &
									user.last_name)

user.first_name = lstr_name.first_name
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"first_name", &
									user.first_name)

user.middle_name = lstr_name.middle_name
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"middle_name", &
									user.middle_name)

user.name_suffix = lstr_name.name_suffix
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"name_suffix", &
									user.name_suffix)

user.name_prefix = lstr_name.name_prefix
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"name_prefix", &
									user.name_prefix)

user.degree = lstr_name.degree
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"degree", &
									user.degree)

user.actor_class = lstr_name.actor_class
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"actor_class", &
									user.actor_class)

refresh()

end event

type cb_access from commandbutton within u_tabpage_user_user_information
integer x = 1326
integer y = 468
integer width = 489
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reset Password"
end type

event clicked;integer li_sts

li_sts = user_list.resetpassword(user.user_id)

return


end event

type cb_signature_stamp from commandbutton within u_tabpage_user_user_information
integer x = 2107
integer y = 668
integer width = 759
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Manage User Stamps"
end type

event clicked;openwithparm(w_user_manage_stamps, user)


end event

type st_username from statictext within u_tabpage_user_user_information
integer x = 512
integer y = 468
integer width = 745
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_new_username
str_popup popup
str_popup_return popup_return

popup.data_row_count = 2
popup.items[1] = "Assign Existing Username To This User"
popup.items[2] = "Create New Username"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.item_indexes[1] = 1 then
	popup.title = "Enter Username"
	popup.data_row_count = 0
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return

	ls_new_username = popup_return.items[1]
	
	openwithparm(w_pop_yes_no, "Are you sure you want to assign the username ~"" + ls_new_username + "~" to this user?")
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
	
	sqlca.jmj_set_username(user.user_id, ls_new_username)
	if not tf_check() then return
else
	ls_new_username = user_list.establishcredentials(user.user_id)
end if

if len(ls_new_username) > 0 then
	user.username = ls_new_username
	text = user.username
end if


end event

type st_user_status from statictext within u_tabpage_user_user_information
integer x = 2327
integer y = 184
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
		if upper(ls_license_flag) = "P" or upper(ls_license_flag) = "E" then
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

type st_user_status_title from statictext within u_tabpage_user_user_information
integer x = 1929
integer y = 200
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

type st_6 from statictext within u_tabpage_user_user_information
integer x = 18
integer y = 488
integer width = 480
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Username:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_primary_office_id from statictext within u_tabpage_user_user_information
integer x = 512
integer y = 184
integer width = 978
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 0
popup.dataobject = "dw_office_pick"
popup.datacolumn = 1
popup.displaycolumn = 2

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

user.primary_office_id = popup_return.items[1]
text = popup_return.descriptions[1]

user_list.set_user_progress( user.user_id, &
									"Modify", &
									"office_id", &
									user.primary_office_id)

end event

type st_1 from statictext within u_tabpage_user_user_information
integer x = 27
integer y = 196
integer width = 475
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Primary Office:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_is_provider_title from statictext within u_tabpage_user_user_information
integer x = 1829
integer y = 344
integer width = 475
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Provider Class:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_is_provider from statictext within u_tabpage_user_user_information
integer x = 2327
integer y = 324
integer width = 530
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;str_popup popup
str_popup_return popup_return

popup.data_row_count = 3
popup.items[1] = "Physician"
popup.items[2] = "Extender"
popup.items[3] = "Staff"

openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm

if popup_return.item_count <> 1 then return

CHOOSE CASE popup_return.item_indexes[1]
	CASE 1
		user.license_flag = "P"
	CASE 2 
		user.license_flag = "E"
	CASE ELSE
		setnull(user.license_flag)
END CHOOSE
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"license_flag", &
									user.license_flag)

text = popup_return.items[1]


end event

type st_initial from statictext within u_tabpage_user_user_information
integer x = 1723
integer y = 1004
integer width = 224
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Initials:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_user_initial from singlelineedit within u_tabpage_user_user_information
integer x = 1957
integer y = 992
integer width = 219
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
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;if len(text) > 3 then
	openwithparm(w_pop_message, "User Initials can be up to three characters")
	text = left(text, 3)
end if

user.user_initial = text
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"user_initial", &
									user.user_initial)

end event

type st_super from statictext within u_tabpage_user_user_information
integer x = 155
integer y = 340
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Supervisor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_supervisor from statictext within u_tabpage_user_user_information
integer x = 512
integer y = 328
integer width = 745
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

event clicked;str_pick_users lstr_pick_users
integer li_sts
u_user luo_user

//lstr_pick_users.allow_roles = false
//lstr_pick_users.allow_system_users = false
//lstr_pick_users.allow_special_users = false
//lstr_pick_users.allow_multiple = false
lstr_pick_users.pick_screen_title = "Select Supervisor for " + sle_full_name.text

li_sts = user_list.pick_users(lstr_pick_users)

if lstr_pick_users.selected_users.user_count <= 0 then return

luo_user = user_list.find_user(lstr_pick_users.selected_users.user[1].user_id)
if isnull(luo_user) then return

if isnull(luo_user.license_flag) or luo_user.license_flag <> "P" then
	openwithparm(w_pop_message, "Only a user whose provider class is ~"Physician~" may be a supervisor")
	return
end if

// Check for a supervisor loop
if f_is_supervisor_loop(user.user_id, luo_user.user_id) then return

text = luo_user.user_full_name
backcolor = luo_user.color
user.supervisor = luo_user
user.supervisor_user_id = luo_user.user_id

user_list.set_user_progress( user.user_id, &
									"Modify", &
									"supervisor_user_id", &
									user.supervisor_user_id)

cb_clear_supervisor.visible = true

end event

type st_last from statictext within u_tabpage_user_user_information
integer x = 73
integer y = 60
integer width = 421
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "User Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_pi from statictext within u_tabpage_user_user_information
integer x = 1056
integer y = 776
integer width = 823
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Display Format"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within u_tabpage_user_user_information
integer x = 690
integer y = 1128
integer width = 384
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Color:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within u_tabpage_user_user_information
integer x = 654
integer y = 1004
integer width = 421
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Short Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within u_tabpage_user_user_information
integer x = 722
integer y = 888
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
string text = "Full Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_color from statictext within u_tabpage_user_user_information
integer x = 1083
integer y = 1116
integer width = 384
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;long ll_color
integer li_sts

//ll_color = common_thread.mm.select_color(backcolor)
ll_color = backcolor
li_sts = choosecolor(ll_color)
if li_sts > 0 then
	backcolor = ll_color
	
	user.color = ll_color
	user_list.set_user_progress( user.user_id, &
										"Modify", &
										"color", &
										string(user.color))
end if

end event

type sle_short_name from singlelineedit within u_tabpage_user_user_information
integer x = 1079
integer y = 992
integer width = 599
integer height = 92
integer taborder = 20
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

event modified;string ls_user_id
string ls_name
str_popup_return popup_return

if len(text) > 12 then
	openwithparm(w_pop_message, "The maximum length for the short name is 12 characters.  The short name has been truncated.")
	text = left(text, 12)
end if

SELECT min(user_id)
INTO :ls_user_id
FROM c_User
WHERE user_short_name = :text
AND user_status = 'OK'
AND actor_class = :user.actor_class
AND user_id <> :user.user_id;
if not tf_check() then return

if len(ls_user_id) > 0 then
	ls_name = user_list.user_full_name(ls_user_id)
	openwithparm(w_pop_message, "The short name entered is already in use by " + ls_name + ".  Please enter a different short name for this user.")
	text = user.user_short_name
end if

user.user_short_name = text
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"user_short_name", &
									user.user_short_name)

end event

type sle_full_name from singlelineedit within u_tabpage_user_user_information
integer x = 1079
integer y = 876
integer width = 960
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

event modified;user.user_full_name = text
user_list.set_user_progress( user.user_id, &
									"Modify", &
									"user_full_name", &
									user.user_full_name)

end event

type cb_clear_supervisor from commandbutton within u_tabpage_user_user_information
integer x = 1275
integer y = 356
integer width = 201
integer height = 72
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
setnull(user.supervisor)
setnull(user.supervisor_user_id)

st_supervisor.text = "<None>"
st_supervisor.backcolor = color_object

user_list.set_user_progress( user.user_id, &
									"Modify", &
									"supervisor_user_id", &
									user.supervisor_user_id)

visible = false

end event

type st_specialty from statictext within u_tabpage_user_user_information
integer x = 2327
integer y = 44
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

type st_specialty_title from statictext within u_tabpage_user_user_information
integer x = 1979
integer y = 64
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

