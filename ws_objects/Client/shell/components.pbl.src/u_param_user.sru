$PBExportHeader$u_param_user.sru
forward
global type u_param_user from u_param_base
end type
type st_popup_values from statictext within u_param_user
end type
end forward

global type u_param_user from u_param_base
st_popup_values st_popup_values
end type
global u_param_user u_param_user

type variables
string  param_value

string actor_class
end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public function integer pick_param ()
end prototypes

public function integer check_required ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - required column missing  1 - validation success
//
//	Description: validates whether it's required column
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/15/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If Isnull(param_value) Then
		Openwithparm(w_pop_message,"Please enter a " + st_title.text)
		Return -1
	End if
End If

Return 1

end function

public function integer x_initialize ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer
//
// Description:initialize the attribute
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/15/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

string ls_display
string ls_initial_value
string ls_description
string ls_query

ls_initial_value = get_initial_value(1)

ls_query = param_wizard.params.params[param_index].query
if len(ls_query) > 0 then
	actor_class = ls_query
else
	setnull(actor_class)
end if

if preference_in_use then
	setnull(param_value)
	ls_display = ""
else
	ls_description = user_list.user_full_name(ls_initial_value)
	if isnull(ls_description) then
		setnull(param_value)
		ls_display = ""
	else
		param_value = ls_initial_value
		ls_display = ls_description
	end if
end if

st_popup_values.text = ls_display

return 1

end function

public function integer pick_param ();str_pick_users lstr_pick
integer li_sts

if len(actor_class) > 0 then
	lstr_pick.actor_class = actor_class
	lstr_pick.hide_users = true
else
	lstr_pick.allow_roles = true
	lstr_pick.allow_special_users = true
	lstr_pick.allow_system_users = true
end if

if not isnull(current_service) then
	if not isnull(current_service.cpr_id) then
		lstr_pick.cpr_id = current_service.cpr_id
	end if
end if

li_sts = user_list.pick_users(lstr_pick)
if li_sts <= 0 then return 0



param_value = lstr_pick.selected_users.user[1].user_id

update_param(param_wizard.params.params[param_index].token1, param_value)

st_popup_values.text = lstr_pick.selected_users.user[1].user_full_name

if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_user.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
end on

on u_param_user.destroy
call super::destroy
destroy(this.st_popup_values)
end on

type st_preference from u_param_base`st_preference within u_param_user
end type

type st_preference_title from u_param_base`st_preference_title within u_param_user
end type

type cb_clear from u_param_base`cb_clear within u_param_user
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_user
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_user
end type

type st_title from u_param_base`st_title within u_param_user
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_user
integer x = 1353
integer y = 596
integer width = 1294
integer height = 120
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = " "
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;pick_param()
end event

