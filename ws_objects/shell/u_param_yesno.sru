HA$PBExportHeader$u_param_yesno.sru
forward
global type u_param_yesno from u_param_base
end type
type st_yes from statictext within u_param_yesno
end type
type st_no from statictext within u_param_yesno
end type
end forward

global type u_param_yesno from u_param_base
st_yes st_yes
st_no st_no
end type
global u_param_yesno u_param_yesno

type variables
string yesno_flag

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
// Created By:Sumathi Chinnasamy										Creation dt: 10/14/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

string ls_intitial_value

ls_intitial_value = get_initial_value(1)

st_yes.backcolor = color_object
st_no.backcolor = color_object

if isnull(ls_intitial_value) or preference_in_use then
	setnull(yesno_flag)
elseif f_string_to_boolean(ls_intitial_value) then
	st_yes.backcolor = color_object_selected
	yesno_flag = "Y"
else 
	st_no.backcolor = color_object_selected
	yesno_flag = "N"
end if

return 1


end function

public function integer check_required ();if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If isnull(yesno_flag) Then
		Openwithparm(w_pop_message,"Please Select Yes or No")
		Return -1
	End if
end if

Return 1

end function

public function integer pick_param ();str_popup popup
str_popup_return popup_return

popup.title = st_helptext.text
openwithparm(w_pop_yes_no, popup)
popup_return = message.powerobjectparm
if popup_return.item = "YES" then
	yesno_flag = "Y"
else
	yesno_flag = "N"
end if

update_param(param_wizard.params.params[param_index].token1, yesno_flag)

if st_required.visible then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_yesno.create
int iCurrent
call super::create
this.st_yes=create st_yes
this.st_no=create st_no
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_yes
this.Control[iCurrent+2]=this.st_no
end on

on u_param_yesno.destroy
call super::destroy
destroy(this.st_yes)
destroy(this.st_no)
end on

type st_preference from u_param_base`st_preference within u_param_yesno
integer y = 1000
end type

type st_preference_title from u_param_base`st_preference_title within u_param_yesno
integer y = 936
end type

type cb_clear from u_param_base`cb_clear within u_param_yesno
end type

event cb_clear::clicked;call super::clicked;setnull(yesno_flag)
st_yes.backcolor = color_object
st_no.backcolor = color_object
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_yesno
integer x = 1641
integer y = 588
end type

type st_helptext from u_param_base`st_helptext within u_param_yesno
end type

type st_title from u_param_base`st_title within u_param_yesno
integer x = 334
integer y = 668
end type

type st_yes from statictext within u_param_yesno
integer x = 1646
integer y = 652
integer width = 210
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_no.backcolor = color_object
yesno_flag = "Y"

f_attribute_add_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				yesno_flag, &
				param_wizard.params.id )

if st_required.visible then
	param_wizard.event POST ue_required(true)
end if

end event

type st_no from statictext within u_param_yesno
integer x = 1883
integer y = 652
integer width = 210
integer height = 108
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;backcolor = color_object_selected
st_yes.backcolor = color_object
yesno_flag = "N"

f_attribute_add_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				yesno_flag, &
				param_wizard.params.id )

if st_required.visible then
	param_wizard.event POST ue_required(true)
end if

end event

