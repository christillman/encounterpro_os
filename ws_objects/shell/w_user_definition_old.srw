HA$PBExportHeader$w_user_definition_old.srw
forward
global type w_user_definition_old from w_window_base
end type
type st_specialty_title from statictext within w_user_definition_old
end type
type st_specialty from statictext within w_user_definition_old
end type
type cb_clear_supervisor from commandbutton within w_user_definition_old
end type
type sle_full_name from singlelineedit within w_user_definition_old
end type
type sle_short_name from singlelineedit within w_user_definition_old
end type
type st_color from statictext within w_user_definition_old
end type
type st_2 from statictext within w_user_definition_old
end type
type st_3 from statictext within w_user_definition_old
end type
type st_4 from statictext within w_user_definition_old
end type
type st_roles_title from statictext within w_user_definition_old
end type
type st_pi from statictext within w_user_definition_old
end type
type sle_first from singlelineedit within w_user_definition_old
end type
type sle_middle from singlelineedit within w_user_definition_old
end type
type sle_last from singlelineedit within w_user_definition_old
end type
type st_first from statictext within w_user_definition_old
end type
type st_mi from statictext within w_user_definition_old
end type
type st_last from statictext within w_user_definition_old
end type
type sle_degree from singlelineedit within w_user_definition_old
end type
type st_degree from statictext within w_user_definition_old
end type
type sle_dea from singlelineedit within w_user_definition_old
end type
type st_dea from statictext within w_user_definition_old
end type
type sle_license from singlelineedit within w_user_definition_old
end type
type st_license from statictext within w_user_definition_old
end type
type st_supervisor from statictext within w_user_definition_old
end type
type st_super from statictext within w_user_definition_old
end type
type st_rx from statictext within w_user_definition_old
end type
type st_certified from statictext within w_user_definition_old
end type
type cb_access from commandbutton within w_user_definition_old
end type
type pb_cancel from u_picture_button within w_user_definition_old
end type
type pb_done from u_picture_button within w_user_definition_old
end type
type cb_priv from commandbutton within w_user_definition_old
end type
type cb_save from commandbutton within w_user_definition_old
end type
type sle_user_initial from singlelineedit within w_user_definition_old
end type
type st_initial from statictext within w_user_definition_old
end type
type dw_roles from datawindow within w_user_definition_old
end type
type st_is_provider from statictext within w_user_definition_old
end type
type st_is_provider_title from statictext within w_user_definition_old
end type
type cb_signature_stamp from commandbutton within w_user_definition_old
end type
type st_1 from statictext within w_user_definition_old
end type
type st_primary_office_id from statictext within w_user_definition_old
end type
type st_title from statictext within w_user_definition_old
end type
type st_6 from statictext within w_user_definition_old
end type
type st_user_status_title from statictext within w_user_definition_old
end type
type st_user_status from statictext within w_user_definition_old
end type
type st_username from statictext within w_user_definition_old
end type
end forward

global type w_user_definition_old from w_window_base
integer width = 2953
integer height = 1856
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
st_specialty_title st_specialty_title
st_specialty st_specialty
cb_clear_supervisor cb_clear_supervisor
sle_full_name sle_full_name
sle_short_name sle_short_name
st_color st_color
st_2 st_2
st_3 st_3
st_4 st_4
st_roles_title st_roles_title
st_pi st_pi
sle_first sle_first
sle_middle sle_middle
sle_last sle_last
st_first st_first
st_mi st_mi
st_last st_last
sle_degree sle_degree
st_degree st_degree
sle_dea sle_dea
st_dea st_dea
sle_license sle_license
st_license st_license
st_supervisor st_supervisor
st_super st_super
st_rx st_rx
st_certified st_certified
cb_access cb_access
pb_cancel pb_cancel
pb_done pb_done
cb_priv cb_priv
cb_save cb_save
sle_user_initial sle_user_initial
st_initial st_initial
dw_roles dw_roles
st_is_provider st_is_provider
st_is_provider_title st_is_provider_title
cb_signature_stamp cb_signature_stamp
st_1 st_1
st_primary_office_id st_primary_office_id
st_title st_title
st_6 st_6
st_user_status_title st_user_status_title
st_user_status st_user_status
st_username st_username
end type
global w_user_definition_old w_user_definition_old

type variables
u_user user
u_user supervisor

string original_license_flag


end variables

forward prototypes
public subroutine privileges ()
public function integer save_changes ()
public function integer load_user (string ps_user_id)
public subroutine set_fields ()
end prototypes

public subroutine privileges ();str_popup popup

popup.items[1] = user.user_id
popup.items[2] = sle_full_name.text
popup.data_row_count = 2

openwithparm(w_user_privilege, popup)

end subroutine

public function integer save_changes ();/////////////////////////////////////////////////////////////////////////////////
//
//	Function: save_changes
//
// Arguments: None
//
//	Return: Integer
//
//	Description: Updates information about user into table.
//
// Created On:																Created On:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/24/99
/////////////////////////////////////////////////////////////////////////////////
String			ls_provider_id
Integer			li_sts

IF Isnull(sle_full_name.text) or trim(sle_full_name.text) = "" THEN
	Openwithparm(w_pop_message, "You must enter a full name")
	RETURN 0
END IF

IF Isnull(sle_short_name.text) or trim(sle_short_name.text) = "" THEN
	Openwithparm(w_pop_message, "You must enter a short name")
	RETURN 0
END IF

IF Isnull(sle_user_initial.text) Then sle_user_initial.text = Left(sle_full_name.text,3)


user.user_full_name = sle_full_name.text
user.user_short_name = sle_short_name.text
user.user_initial = sle_user_initial.text
user.color = st_color.backcolor

user.first_name = sle_first.text
user.middle_name = sle_middle.text
user.last_name = sle_last.text
user.degree = sle_degree.text
user.dea_number = sle_dea.text
user.license_number = sle_license.text

user.set_supervisor(supervisor)

//user.update()

if user.user_status = "OK" then
	cb_access.enabled = TRUE
	cb_priv.enabled = TRUE
	dw_roles.visible = true
end if

RETURN 1

end function

public function integer load_user (string ps_user_id);////////////////////////////////////////////////////////////////////////////////////
//
//	Function: load_user
//
// Arguments: string
//
//	Return: Integer
//
//	Description: Show the user information for requested user.
//
// Created On:																Created On:
//
// Modified By:Sumathi Chinnasamy									Modified On:08/27/99
////////////////////////////////////////////////////////////////////////////////////
Integer		li_sts

if isnull(ps_user_id) then
	log.log(this, "load_user()", "Null User_id", 4)
	return -1
end if

user_list.clear_cache()
user = user_list.find_user(ps_user_id)
if isnull(user) then
	log.log(this, "load_user()", "User not found (" + ps_user_id + ")", 4)
	return -1
end if


sle_full_name.text	= user.user_full_name
sle_short_name.text 	= user.user_short_name
sle_user_initial.text= user.user_initial

IF Isnull(user.color) THEN st_color.backcolor = color_background ELSE &
								st_color.backcolor = user.color

IF isnull(user.license_flag) THEN
	st_is_provider.text = "Staff"
end if

sle_first.text = user.first_name
sle_middle.text = user.middle_name
sle_last.text = user.last_name
sle_degree.text = user.degree
sle_dea.text = user.dea_number
sle_license.text = user.license_number
IF isnull(user.username) or user.username = "" then
	st_username.text = "<Username Not Set>"
else
	st_username.text = user.username
end if

supervisor = user.supervisor
if isnull(supervisor) then
	st_supervisor.text = "<None>"
	st_supervisor.backcolor = color_object
	cb_clear_supervisor.visible = false
else
	st_supervisor.text = supervisor.user_full_name
	st_supervisor.backcolor = supervisor.color
	cb_clear_supervisor.visible = true
end if

IF user.certified = "Y" THEN
	st_certified.text = "Yes"
	st_certified.backcolor = color_object_selected
ELSE
	st_certified.text = "No"
	st_certified.backcolor = color_object
END IF

original_license_flag = user.license_flag
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

dw_roles.retrieve(user.user_id)

RETURN 1

end function

public subroutine set_fields ();
if user.user_status = "OK" then
	cb_priv.enabled = true
	cb_access.enabled = true
	dw_roles.visible = true
	st_roles_title.visible = true
else
	cb_priv.enabled = false
	cb_access.enabled = false
	dw_roles.visible = false
	st_roles_title.visible = false
end if


end subroutine

on w_user_definition_old.create
int iCurrent
call super::create
this.st_specialty_title=create st_specialty_title
this.st_specialty=create st_specialty
this.cb_clear_supervisor=create cb_clear_supervisor
this.sle_full_name=create sle_full_name
this.sle_short_name=create sle_short_name
this.st_color=create st_color
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.st_roles_title=create st_roles_title
this.st_pi=create st_pi
this.sle_first=create sle_first
this.sle_middle=create sle_middle
this.sle_last=create sle_last
this.st_first=create st_first
this.st_mi=create st_mi
this.st_last=create st_last
this.sle_degree=create sle_degree
this.st_degree=create st_degree
this.sle_dea=create sle_dea
this.st_dea=create st_dea
this.sle_license=create sle_license
this.st_license=create st_license
this.st_supervisor=create st_supervisor
this.st_super=create st_super
this.st_rx=create st_rx
this.st_certified=create st_certified
this.cb_access=create cb_access
this.pb_cancel=create pb_cancel
this.pb_done=create pb_done
this.cb_priv=create cb_priv
this.cb_save=create cb_save
this.sle_user_initial=create sle_user_initial
this.st_initial=create st_initial
this.dw_roles=create dw_roles
this.st_is_provider=create st_is_provider
this.st_is_provider_title=create st_is_provider_title
this.cb_signature_stamp=create cb_signature_stamp
this.st_1=create st_1
this.st_primary_office_id=create st_primary_office_id
this.st_title=create st_title
this.st_6=create st_6
this.st_user_status_title=create st_user_status_title
this.st_user_status=create st_user_status
this.st_username=create st_username
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_specialty_title
this.Control[iCurrent+2]=this.st_specialty
this.Control[iCurrent+3]=this.cb_clear_supervisor
this.Control[iCurrent+4]=this.sle_full_name
this.Control[iCurrent+5]=this.sle_short_name
this.Control[iCurrent+6]=this.st_color
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.st_roles_title
this.Control[iCurrent+11]=this.st_pi
this.Control[iCurrent+12]=this.sle_first
this.Control[iCurrent+13]=this.sle_middle
this.Control[iCurrent+14]=this.sle_last
this.Control[iCurrent+15]=this.st_first
this.Control[iCurrent+16]=this.st_mi
this.Control[iCurrent+17]=this.st_last
this.Control[iCurrent+18]=this.sle_degree
this.Control[iCurrent+19]=this.st_degree
this.Control[iCurrent+20]=this.sle_dea
this.Control[iCurrent+21]=this.st_dea
this.Control[iCurrent+22]=this.sle_license
this.Control[iCurrent+23]=this.st_license
this.Control[iCurrent+24]=this.st_supervisor
this.Control[iCurrent+25]=this.st_super
this.Control[iCurrent+26]=this.st_rx
this.Control[iCurrent+27]=this.st_certified
this.Control[iCurrent+28]=this.cb_access
this.Control[iCurrent+29]=this.pb_cancel
this.Control[iCurrent+30]=this.pb_done
this.Control[iCurrent+31]=this.cb_priv
this.Control[iCurrent+32]=this.cb_save
this.Control[iCurrent+33]=this.sle_user_initial
this.Control[iCurrent+34]=this.st_initial
this.Control[iCurrent+35]=this.dw_roles
this.Control[iCurrent+36]=this.st_is_provider
this.Control[iCurrent+37]=this.st_is_provider_title
this.Control[iCurrent+38]=this.cb_signature_stamp
this.Control[iCurrent+39]=this.st_1
this.Control[iCurrent+40]=this.st_primary_office_id
this.Control[iCurrent+41]=this.st_title
this.Control[iCurrent+42]=this.st_6
this.Control[iCurrent+43]=this.st_user_status_title
this.Control[iCurrent+44]=this.st_user_status
this.Control[iCurrent+45]=this.st_username
end on

on w_user_definition_old.destroy
call super::destroy
destroy(this.st_specialty_title)
destroy(this.st_specialty)
destroy(this.cb_clear_supervisor)
destroy(this.sle_full_name)
destroy(this.sle_short_name)
destroy(this.st_color)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_roles_title)
destroy(this.st_pi)
destroy(this.sle_first)
destroy(this.sle_middle)
destroy(this.sle_last)
destroy(this.st_first)
destroy(this.st_mi)
destroy(this.st_last)
destroy(this.sle_degree)
destroy(this.st_degree)
destroy(this.sle_dea)
destroy(this.st_dea)
destroy(this.sle_license)
destroy(this.st_license)
destroy(this.st_supervisor)
destroy(this.st_super)
destroy(this.st_rx)
destroy(this.st_certified)
destroy(this.cb_access)
destroy(this.pb_cancel)
destroy(this.pb_done)
destroy(this.cb_priv)
destroy(this.cb_save)
destroy(this.sle_user_initial)
destroy(this.st_initial)
destroy(this.dw_roles)
destroy(this.st_is_provider)
destroy(this.st_is_provider_title)
destroy(this.cb_signature_stamp)
destroy(this.st_1)
destroy(this.st_primary_office_id)
destroy(this.st_title)
destroy(this.st_6)
destroy(this.st_user_status_title)
destroy(this.st_user_status)
destroy(this.st_username)
end on

event open;call super::open;str_popup popup
str_popup_return popup_return
integer li_sts
string ls_email_domain

popup = message.powerobjectparm
popup_return.item_count = 0

if popup.data_row_count = 0 then
	user = CREATE u_user
	user.user_status = "OK"
	st_user_status.text = "Active"
	setnull(user.supervisor_user_id)
	setnull(user.supervisor)
	setnull(user.user_id)
	user.primary_office_id = office_id
	st_primary_office_id.text = office_description
	setnull(original_license_flag)
	st_color.backcolor = color_background
	user.certified = "N"
	cb_priv.enabled = false
	cb_access.enabled = false
	dw_roles.visible = false
	setnull(supervisor)
elseif popup.data_row_count = 1 then
	li_sts = load_user(popup.items[1])
	if li_sts <= 0 then
		log.log(this, "open", "Invalid User ID (" + popup.item + ")", 4)
		closewithreturn(this, popup_return)
		return
	end if
	// Existing users can't change their name
	sle_full_name.enabled = false
	sle_first.enabled = false
	sle_middle.enabled = false
	sle_last.enabled = false
	
	set_fields()
end if



end event

type pb_epro_help from w_window_base`pb_epro_help within w_user_definition_old
boolean visible = true
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_user_definition_old
end type

type st_specialty_title from statictext within w_user_definition_old
integer x = 1829
integer y = 304
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
string text = "Specialty:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_specialty from statictext within w_user_definition_old
integer x = 2222
integer y = 284
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

event clicked;str_popup popup
str_popup_return popup_return

popup.dataobject = "dw_specialty_list"
popup.datacolumn = 2
popup.displaycolumn = 1
popup.add_blank_row = true
popup.blank_text = "<N/A>"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return

if popup_return.items[1] = "" then
	text = "<N/A>"
	setnull(user.specialty_id)
else
	text = popup_return.descriptions[1]
	user.specialty_id = popup_return.items[1]
end if

end event

type cb_clear_supervisor from commandbutton within w_user_definition_old
integer x = 1367
integer y = 1388
integer width = 201
integer height = 72
integer taborder = 150
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;
setnull(supervisor)

st_supervisor.text = "<None>"
st_supervisor.backcolor = color_object

visible = false

end event

type sle_full_name from singlelineedit within w_user_definition_old
integer x = 526
integer y = 212
integer width = 960
integer height = 92
integer taborder = 40
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

type sle_short_name from singlelineedit within w_user_definition_old
integer x = 526
integer y = 340
integer width = 599
integer height = 92
integer taborder = 50
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
AND (:user.user_id IS NULL OR user_id <> :user.user_id);
if not tf_check() then return

if len(ls_user_id) > 0 then
	ls_name = user_list.user_full_name(ls_user_id)
	openwithparm(w_pop_message, "The short name entered is already in use by " + ls_name + ".  Please enter a different short name for this user.")
	text = user.user_short_name
end if

return 0

end event

type st_color from statictext within w_user_definition_old
integer x = 526
integer y = 468
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

ll_color = common_thread.mm.select_color(backcolor)
backcolor = ll_color


end event

type st_2 from statictext within w_user_definition_old
integer x = 160
integer y = 224
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
string text = "Full Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_user_definition_old
integer x = 91
integer y = 352
integer width = 421
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Short Name:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_user_definition_old
integer x = 128
integer y = 480
integer width = 384
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Color:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_roles_title from statictext within w_user_definition_old
integer x = 1929
integer y = 552
integer width = 274
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Roles:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_pi from statictext within w_user_definition_old
integer x = 914
integer y = 864
integer width = 1070
integer height = 100
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 33538240
boolean enabled = false
string text = "Provider Information"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_first from singlelineedit within w_user_definition_old
integer x = 530
integer y = 1008
integer width = 512
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_middle from singlelineedit within w_user_definition_old
integer x = 1216
integer y = 1008
integer width = 197
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_last from singlelineedit within w_user_definition_old
integer x = 1701
integer y = 1008
integer width = 667
integer height = 92
integer taborder = 100
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_first from statictext within w_user_definition_old
integer x = 315
integer y = 1024
integer width = 206
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "First:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_mi from statictext within w_user_definition_old
integer x = 1065
integer y = 1024
integer width = 142
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "MI:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_last from statictext within w_user_definition_old
integer x = 1490
integer y = 1024
integer width = 206
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Last:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_degree from singlelineedit within w_user_definition_old
integer x = 530
integer y = 1172
integer width = 343
integer height = 92
integer taborder = 110
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_degree from statictext within w_user_definition_old
integer x = 279
integer y = 1184
integer width = 242
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Degree:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_dea from singlelineedit within w_user_definition_old
integer x = 1161
integer y = 1172
integer width = 512
integer height = 92
integer taborder = 140
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_dea from statictext within w_user_definition_old
integer x = 987
integer y = 1184
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "DEA:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_license from singlelineedit within w_user_definition_old
integer x = 2053
integer y = 1172
integer width = 672
integer height = 92
integer taborder = 150
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_license from statictext within w_user_definition_old
integer x = 1792
integer y = 1184
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "License:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_supervisor from statictext within w_user_definition_old
integer x = 603
integer y = 1356
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

text = luo_user.user_full_name
backcolor = luo_user.color

supervisor = luo_user

cb_clear_supervisor.visible = true

end event

type st_super from statictext within w_user_definition_old
integer x = 247
integer y = 1372
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Supervisor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_rx from statictext within w_user_definition_old
integer x = 1783
integer y = 1372
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
string text = "Rx Certified:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_certified from statictext within w_user_definition_old
integer x = 2171
integer y = 1356
integer width = 261
integer height = 104
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;if user.certified = "Y" then
	st_certified.text = "No"
	st_certified.backcolor = color_object
	user.certified = "N"
else
	st_certified.text = "Yes"
	st_certified.backcolor = color_object_selected
	user.certified = "Y"
end if


end event

type cb_access from commandbutton within w_user_definition_old
integer x = 1463
integer y = 1596
integer width = 489
integer height = 108
integer taborder = 120
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

type pb_cancel from u_picture_button within w_user_definition_old
integer x = 146
integer y = 1544
integer taborder = 20
boolean cancel = true
string picturename = "button11.bmp"
string disabledname = "b_push11.bmp"
end type

event clicked;call super::clicked;str_popup_return popup_return

popup_return.item_count = 0

closewithreturn(parent, popup_return)

end event

type pb_done from u_picture_button within w_user_definition_old
integer x = 2528
integer y = 1544
integer taborder = 10
string picturename = "button26.bmp"
string disabledname = "b_push26.bmp"
end type

event clicked;call super::clicked;str_popup_return		popup_return
Integer					li_sts

li_sts = save_changes()
IF li_sts <= 0 THEN RETURN


popup_return.item_count = 1
popup_return.items[1] = user.user_id
popup_return.descriptions[1] = sle_full_name.text
Closewithreturn(Parent, popup_return)


end event

type cb_priv from commandbutton within w_user_definition_old
event clicked pbm_bnclicked
integer x = 955
integer y = 1596
integer width = 489
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Privileges"
end type

event clicked;privileges()

end event

type cb_save from commandbutton within w_user_definition_old
event clicked pbm_bnclicked
integer x = 1970
integer y = 1596
integer width = 489
integer height = 108
integer taborder = 130
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Save"
end type

event clicked;integer li_sts

li_sts = save_changes()
if li_sts <= 0 then return

end event

type sle_user_initial from singlelineedit within w_user_definition_old
integer x = 1390
integer y = 340
integer width = 219
integer height = 92
integer taborder = 60
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

end event

type st_initial from statictext within w_user_definition_old
integer x = 1157
integer y = 352
integer width = 224
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Initials:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_roles from datawindow within w_user_definition_old
integer x = 2222
integer y = 536
integer width = 530
integer height = 408
integer taborder = 80
boolean bringtotop = true
string dataobject = "dw_user_role_display_list"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

event constructor;settransobject(sqlca)

end event

event clicked;str_popup popup

popup.data_row_count = 2
popup.items[1] = user.user_id
popup.items[2] = sle_full_name.text

openwithparm(w_user_role_definition, popup)

retrieve(user.user_id)

end event

type st_is_provider from statictext within w_user_definition_old
integer x = 2222
integer y = 408
integer width = 530
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

text = popup_return.items[1]


end event

type st_is_provider_title from statictext within w_user_definition_old
integer x = 1728
integer y = 428
integer width = 475
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Provider Class:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_signature_stamp from commandbutton within w_user_definition_old
integer x = 448
integer y = 1596
integer width = 489
integer height = 108
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Signature Stamp"
end type

event clicked;openwithparm(w_user_signature_stamp, user)


end event

type st_1 from statictext within w_user_definition_old
integer x = 37
integer y = 608
integer width = 475
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Primary Office:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_primary_office_id from statictext within w_user_definition_old
integer x = 526
integer y = 596
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


end event

type st_title from statictext within w_user_definition_old
integer width = 2926
integer height = 136
integer textsize = -24
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "User Definition"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_6 from statictext within w_user_definition_old
integer x = 27
integer y = 760
integer width = 480
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 33538240
boolean enabled = false
string text = "Username:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_user_status_title from statictext within w_user_definition_old
integer x = 1829
integer y = 180
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

type st_user_status from statictext within w_user_definition_old
integer x = 2222
integer y = 160
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

type st_username from statictext within w_user_definition_old
integer x = 526
integer y = 740
integer width = 777
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


ls_new_username = user_list.establishcredentials(user.user_id)

if len(ls_new_username) > 0 then
	user.username = ls_new_username
	text = user.username
end if


end event

