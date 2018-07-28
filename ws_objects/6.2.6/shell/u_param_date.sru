HA$PBExportHeader$u_param_date.sru
forward
global type u_param_date from u_param_base
end type
type st_date from statictext within u_param_date
end type
end forward

global type u_param_date from u_param_base
st_date st_date
end type
global u_param_date u_param_date

type variables
date param_date

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
//	Description:initialize the attribute values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
string ls_intitial_value

ls_intitial_value = get_initial_value(1)

if upper(ls_intitial_value) = "%TODAY%" or upper(ls_intitial_value) = "TODAY" then
	ls_intitial_value = string(today())
	f_attribute_add_attribute2( &
					param_wizard.attributes, &
					param_wizard.params.params[param_index].token1, &
					ls_intitial_value, &
					param_wizard.params.id )
end if

If isdate(ls_intitial_value) and not isnull(ls_intitial_value) and not preference_in_use Then
	param_date = date(ls_intitial_value)
	st_date.text = string(param_date) 
Else
	setnull(param_date)
	st_date.text = "<No Date>"
end if

return 1

end function

public function integer check_required ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - required column missing  1 - validation success
//
//	Description: validates the date
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/11/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
if upper(param_wizard.params.params[param_index].required_flag) = "Y" then
	If isnull(param_date) Then
		Openwithparm(w_pop_message,"Please Select a Date")
		Return -1
	End if
end if

Return 1

end function

public function integer pick_param ();string ls_text

ls_text = f_select_date(param_date, st_title.text)
if isnull(ls_text) then return 0

st_date.text = ls_text
update_param(param_wizard.params.params[param_index].token1, ls_text)

if st_required.visible then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_date.create
int iCurrent
call super::create
this.st_date=create st_date
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_date
end on

on u_param_date.destroy
call super::destroy
destroy(this.st_date)
end on

type st_preference from u_param_base`st_preference within u_param_date
end type

type st_preference_title from u_param_base`st_preference_title within u_param_date
end type

type cb_clear from u_param_base`cb_clear within u_param_date
end type

event cb_clear::clicked;call super::clicked;setnull(param_date)
st_date.text = "<No Date>"
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_date
integer x = 1559
integer y = 572
end type

type st_helptext from u_param_base`st_helptext within u_param_date
end type

type st_title from u_param_base`st_title within u_param_date
integer x = 256
integer y = 648
integer height = 80
end type

type st_date from statictext within u_param_date
integer x = 1559
integer y = 632
integer width = 576
integer height = 116
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "12/12/2000"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;pick_param()

end event

