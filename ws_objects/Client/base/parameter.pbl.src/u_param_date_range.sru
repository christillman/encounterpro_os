$PBExportHeader$u_param_date_range.sru
forward
global type u_param_date_range from u_param_base
end type
type st_from_date from statictext within u_param_date_range
end type
type st_from_title from statictext within u_param_date_range
end type
type st_to_title from statictext within u_param_date_range
end type
type st_to_date from statictext within u_param_date_range
end type
end forward

global type u_param_date_range from u_param_base
st_from_date st_from_date
st_from_title st_from_title
st_to_title st_to_title
st_to_date st_to_date
end type
global u_param_date_range u_param_date_range

type variables
date param_from_date
date param_to_date


end variables

forward prototypes
public function integer x_initialize ()
public function integer check_required ()
public function integer pick_from_date ()
public function integer pick_to_date ()
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
if upper(ls_intitial_value) = "%TODAY%" then ls_intitial_value = string(today())

If isdate(ls_intitial_value) and not isnull(ls_intitial_value) and not preference_in_use Then
	param_from_date = date(ls_intitial_value)
	st_from_date.text = string(param_from_date) 
Else
	setnull(param_from_date)
	st_from_date.text = "<No Date>"
end if

ls_intitial_value = get_initial_value(2)
if upper(ls_intitial_value) = "%TODAY%" then ls_intitial_value = string(today())

If isdate(ls_intitial_value) and not isnull(ls_intitial_value) and not preference_in_use Then
	param_to_date = date(ls_intitial_value)
	st_to_date.text = string(param_to_date) 
Else
	setnull(param_to_date)
	st_to_date.text = "<No Date>"
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
	If isnull(param_from_date) or isnull(param_to_date) Then
		Openwithparm(w_pop_message,"Please Select a Date")
		Return -1
	End if
end if

Return 1

end function

public function integer pick_from_date ();string ls_text

ls_text = f_select_date(param_from_date, st_title.text + " From Date")
if isnull(ls_text) then return 0

st_from_date.text = ls_text

update_param(param_wizard.params.params[param_index].token1, ls_text)

if st_required.visible and not isnull(param_to_date) then
	param_wizard.event POST ue_required(true)
end if


return 1

end function

public function integer pick_to_date ();string ls_text

ls_text = f_select_date(param_to_date, st_title.text + " To Date")
if isnull(ls_text) then return 0

st_to_date.text = ls_text

update_param(param_wizard.params.params[param_index].token2, ls_text)

if st_required.visible and not isnull(param_from_date) then
	param_wizard.event POST ue_required(true)
end if


return 1

end function

public function integer pick_param ();integer li_sts

li_sts = pick_from_date()
if li_sts <= 0 then return li_sts

li_sts = pick_to_date()
if li_sts <= 0 then return li_sts

return 1

end function

on u_param_date_range.create
int iCurrent
call super::create
this.st_from_date=create st_from_date
this.st_from_title=create st_from_title
this.st_to_title=create st_to_title
this.st_to_date=create st_to_date
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_from_date
this.Control[iCurrent+2]=this.st_from_title
this.Control[iCurrent+3]=this.st_to_title
this.Control[iCurrent+4]=this.st_to_date
end on

on u_param_date_range.destroy
call super::destroy
destroy(this.st_from_date)
destroy(this.st_from_title)
destroy(this.st_to_title)
destroy(this.st_to_date)
end on

type st_preference from u_param_base`st_preference within u_param_date_range
end type

type st_preference_title from u_param_base`st_preference_title within u_param_date_range
end type

type cb_clear from u_param_base`cb_clear within u_param_date_range
end type

event cb_clear::clicked;call super::clicked;setnull(param_from_date)
setnull(param_to_date)
st_from_date.text = "<No Date>"
st_to_date.text = "<No Date>"
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token2, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_date_range
integer x = 1883
integer y = 572
end type

type st_helptext from u_param_base`st_helptext within u_param_date_range
end type

type st_title from u_param_base`st_title within u_param_date_range
integer x = 114
integer y = 656
integer width = 1417
integer height = 124
end type

type st_from_date from statictext within u_param_date_range
integer x = 1883
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

event clicked;pick_from_date()
end event

type st_from_title from statictext within u_param_date_range
integer x = 1646
integer y = 656
integer width = 215
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "From:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_to_title from statictext within u_param_date_range
integer x = 1646
integer y = 844
integer width = 215
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "To:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_to_date from statictext within u_param_date_range
integer x = 1883
integer y = 820
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

event clicked;pick_to_date()
end event

