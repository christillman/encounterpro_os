HA$PBExportHeader$u_param_color.sru
forward
global type u_param_color from u_param_base
end type
type st_color from statictext within u_param_color
end type
end forward

global type u_param_color from u_param_base
st_color st_color
end type
global u_param_color u_param_color

type variables
long color

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
	color = long(ls_intitial_value)
	st_color.text = ""
	st_color.backcolor = color
Else
	setnull(color)
	st_color.text = "<No Color>"
	st_color.backcolor = color_object
end if

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
	If Isnull(color) Then
		Openwithparm(w_pop_message,"Please enter a " + st_title.text)
		Return -1
	End if
End If

Return 1
end function

public function integer pick_param ();long ll_color
integer li_sts

if isnull(color) then
	ll_color = color_object
else
	ll_color = color
end if

//ll_color = common_thread.mm.select_color(ll_color)
li_sts = choosecolor(ll_color)
if li_sts <= 0 then return 0

color = ll_color
st_color.backcolor = ll_color
st_color.text = ""

update_param(param_wizard.params.params[param_index].token1, string(color))

if st_required.visible and not isnull(color) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_color.create
int iCurrent
call super::create
this.st_color=create st_color
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_color
end on

on u_param_color.destroy
call super::destroy
destroy(this.st_color)
end on

type st_preference from u_param_base`st_preference within u_param_color
end type

type st_preference_title from u_param_base`st_preference_title within u_param_color
end type

type cb_clear from u_param_base`cb_clear within u_param_color
end type

event cb_clear::clicked;call super::clicked;st_color.text = "<No Color>"
st_color.backcolor = color_object

f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_color
integer x = 1358
integer y = 532
end type

type st_helptext from u_param_base`st_helptext within u_param_color
end type

type st_title from u_param_base`st_title within u_param_color
integer x = 27
integer y = 584
end type

type st_color from statictext within u_param_color
integer x = 1344
integer y = 580
integer width = 786
integer height = 108
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;pick_param()

end event

