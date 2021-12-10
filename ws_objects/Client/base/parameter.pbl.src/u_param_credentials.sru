$PBExportHeader$u_param_credentials.sru
forward
global type u_param_credentials from u_param_base
end type
type sle_password from singlelineedit within u_param_credentials
end type
type st_username_title from statictext within u_param_credentials
end type
type st_password_title from statictext within u_param_credentials
end type
type sle_username from singlelineedit within u_param_credentials
end type
end forward

global type u_param_credentials from u_param_base
sle_password sle_password
st_username_title st_username_title
st_password_title st_password_title
sle_username sle_username
end type
global u_param_credentials u_param_credentials

type variables

end variables

forward prototypes
public function integer x_initialize ()
public function integer check_required ()
public function integer pick_param ()
end prototypes

public function integer x_initialize ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer
//
// Description:If no values defined then initialize the fields with initial values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
string ls_intitial_value

ls_intitial_value = get_initial_value(1)

If trim(ls_intitial_value) <> "" and not isnull(ls_intitial_value) and not preference_in_use Then
	sle_username.text = ls_intitial_value
Else
	sle_username.text = ""
end if

ls_intitial_value = get_initial_value(2)

If trim(ls_intitial_value) <> "" and not isnull(ls_intitial_value) and not preference_in_use Then
	sle_password.text = ls_intitial_value
Else
	sle_password.text = ""
end if

sle_username.function POST setfocus( )

return 1

end function

public function integer check_required ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - required column missing  1 - validation success
//
//	Description: validates whether it's required column
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/11/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If Isnull(sle_username.text) Or Len(sle_username.text) = 0 Then
		Openwithparm(w_pop_message,"Please enter a username")
		Return -1
	End if
End If

Return 1
end function

public function integer pick_param ();str_popup popup
str_popup_return popup_return
string ls_text

// Parameters (popup.):
// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
// displaycolumn		Max Length
popup.title = "Enter Username"
popup.item = sle_username.text
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

sle_username.text = popup_return.items[1]

if isnull(sle_username.text) or trim(sle_username.text) = "" then
	setnull(ls_text)
else
	ls_text = sle_username.text
end if

update_param(param_wizard.params.params[param_index].token1, ls_text)

popup.title = "Enter Username"
popup.item = sle_password.text
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

sle_password.text = popup_return.items[1]

if isnull(sle_password.text) or trim(sle_password.text) = "" then
	setnull(ls_text)
else
	ls_text = sle_password.text
end if

update_param(param_wizard.params.params[param_index].token1, ls_text)

if st_required.visible and not isnull(ls_text) then
	param_wizard.event POST ue_required(true)
end if

sle_username.setfocus()

return 1

end function

on u_param_credentials.create
int iCurrent
call super::create
this.sle_password=create sle_password
this.st_username_title=create st_username_title
this.st_password_title=create st_password_title
this.sle_username=create sle_username
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_password
this.Control[iCurrent+2]=this.st_username_title
this.Control[iCurrent+3]=this.st_password_title
this.Control[iCurrent+4]=this.sle_username
end on

on u_param_credentials.destroy
call super::destroy
destroy(this.sle_password)
destroy(this.st_username_title)
destroy(this.st_password_title)
destroy(this.sle_username)
end on

type st_preference from u_param_base`st_preference within u_param_credentials
integer x = 18
integer y = 976
end type

type st_preference_title from u_param_base`st_preference_title within u_param_credentials
integer x = 18
integer y = 908
end type

type cb_clear from u_param_base`cb_clear within u_param_credentials
integer taborder = 20
end type

event cb_clear::clicked;call super::clicked;sle_username.text = ""
sle_password.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token2, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_credentials
integer x = 886
integer y = 540
end type

type st_helptext from u_param_base`st_helptext within u_param_credentials
end type

type st_title from u_param_base`st_title within u_param_credentials
integer x = 704
integer y = 452
alignment alignment = center!
end type

type sle_password from singlelineedit within u_param_credentials
integer x = 878
integer y = 732
integer width = 1198
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean password = true
integer limit = 255
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_text

if isnull(text) or trim(text) = "" then
	setnull(ls_text)
else
	ls_text = text
end if

f_attribute_add_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token2, &
				ls_text, &
				param_wizard.params.id )

if st_required.visible and not isnull(ls_text) then
	param_wizard.event POST ue_required(true)
end if

end event

type st_username_title from statictext within u_param_credentials
integer x = 430
integer y = 604
integer width = 425
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Username"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_password_title from statictext within u_param_credentials
integer x = 430
integer y = 752
integer width = 425
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Password"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_username from singlelineedit within u_param_credentials
integer x = 878
integer y = 584
integer width = 1198
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 255
borderstyle borderstyle = stylelowered!
end type

event modified;string ls_text

if isnull(text) or trim(text) = "" then
	setnull(ls_text)
else
	ls_text = text
end if

f_attribute_add_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				ls_text, &
				param_wizard.params.id )

if st_required.visible and not isnull(ls_text) then
	param_wizard.event POST ue_required(true)
end if

end event

