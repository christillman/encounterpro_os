$PBExportHeader$u_param_script.sru
forward
global type u_param_script from u_param_base
end type
type st_script from statictext within u_param_script
end type
end forward

global type u_param_script from u_param_base
st_script st_script
end type
global u_param_script u_param_script

type variables
string script
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
// Created By:Sumathi Chinnasamy										Creation dt: 10/14/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If Isnull(script) Or Len(script) = 0 Then
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
// Description:If no values defined then initialize the fields with initial values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/14/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
string ls_intitial_value

ls_intitial_value = get_initial_value(1)

If trim(ls_intitial_value) <> "" and not isnull(ls_intitial_value) and not preference_in_use Then
	script = ls_intitial_value
Else
	setnull(script)
end if

st_script.text = script

return 1

end function

public function integer pick_param ();str_popup popup
str_popup_return popup_return

popup.title = "Edit " + st_title.text
popup.item = script
openwithparm(w_pop_edit_string_multiline, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

script = popup_return.items[1]

update_param(param_wizard.params.params[param_index].token1, script)

if st_required.visible and not isnull(script) then
	param_wizard.event POST ue_required(true)
end if

st_script.text = script

return 1

end function

on u_param_script.create
int iCurrent
call super::create
this.st_script=create st_script
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_script
end on

on u_param_script.destroy
call super::destroy
destroy(this.st_script)
end on

type st_preference from u_param_base`st_preference within u_param_script
end type

type st_preference_title from u_param_base`st_preference_title within u_param_script
end type

type cb_clear from u_param_base`cb_clear within u_param_script
integer y = 988
integer taborder = 30
end type

event cb_clear::clicked;call super::clicked;st_script.text = ""
setnull(script)

f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_script
integer x = 1358
integer y = 424
end type

type st_helptext from u_param_base`st_helptext within u_param_script
end type

type st_title from u_param_base`st_title within u_param_script
integer y = 480
end type

type st_script from statictext within u_param_script
integer x = 1349
integer y = 476
integer width = 1184
integer height = 488
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;pick_param()

param_wizard.bringtotop = true

end event

