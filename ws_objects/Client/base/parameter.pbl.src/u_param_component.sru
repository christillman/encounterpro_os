$PBExportHeader$u_param_component.sru
forward
global type u_param_component from u_param_base
end type
type st_popup_values from statictext within u_param_component
end type
type st_component_type from statictext within u_param_component
end type
type st_component_type_title from statictext within u_param_component
end type
end forward

global type u_param_component from u_param_base
st_popup_values st_popup_values
st_component_type st_component_type
st_component_type_title st_component_type_title
end type
global u_param_component u_param_component

type variables
string  param_value

string component_type

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
string ls_description
string ls_component_id
string ls_id
string ls_component_type_description

ls_component_id = get_initial_value(1)

setnull(component_type)

if len(param_wizard.params.params[param_index].query) > 0 then
	component_type = param_wizard.params.params[param_index].query
end if

if isnull(component_type) then
	component_type = f_attribute_find_attribute2(param_wizard.attributes, "component_type", param_wizard.params.id)
end if

// If that doesn't work then try to figure out the component_type from this attribute name (token1)
if isnull(component_type) and lower(right(param_wizard.params.params[param_index].token1, 10)) = "_component" then
	component_type = left(param_wizard.params.params[param_index].token1, len(param_wizard.params.params[param_index].token1) - 10)
end if

if isnull(component_type) and lower(right(param_wizard.params.params[param_index].token1, 13)) = "_component_id" then
	component_type = left(param_wizard.params.params[param_index].token1, len(param_wizard.params.params[param_index].token1) - 13)
end if

if len(component_type) > 0 then
	SELECT description
	INTO :ls_component_type_description
	FROM c_Component_Type
	WHERE component_type = :component_type;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		setnull(ls_component_id)
	end if
	st_component_type.text = ls_component_type_description
else
	setnull(component_type)
	st_component_type.text = ""
end if



if isnull(ls_component_id) then
	setnull(ls_description)
else
	SELECT c.description, CAST(c.id AS varchar(40))
	INTO :ls_description, :ls_id
	FROM dbo.fn_components() c
	WHERE c.component_id = :ls_component_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then setnull(ls_description)
end if

if isnull(ls_description) or preference_in_use then
	setnull(param_value)
	ls_display = ""
else
	param_value = ls_component_id
	ls_display = ls_description
	set_nested_param_id(ls_id)
end if

st_popup_values.text = ls_display

return 1

end function

public function integer pick_param ();str_popup_return	popup_return
str_popup	popup
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_display
string ls_component_id
string ls_id
string ls_component_type_description

if len(component_type) > 0 then
	SELECT description
	INTO :ls_component_type_description
	FROM c_Component_Type
	WHERE component_type = :component_type;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		setnull(ls_component_id)
	end if
else
	setnull(component_type)
end if

// If we still don't have a component_type then prompt the user for one
if isnull(component_type) then
	popup.dataobject = "dw_components_of_type_pick_list"
	popup.datacolumn = 1
	popup.displaycolumn = 2
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 0
	
	component_type = popup_return.items[1]
	ls_component_type_description = popup_return.descriptions[1]
end if

st_component_type.text = ls_component_type_description

popup.dataobject = "dw_components_of_only_type_pick"
popup.datacolumn = 1
popup.displaycolumn = 4
popup.argument_count = 1
popup.argument[1] = component_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_component_id = popup_return.items[1]
ls_display = popup_return.descriptions[1]

SELECT CAST(id AS varchar(40))
INTO :ls_id
FROM dbo.fn_components()
WHERE component_id = :ls_component_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_param_component.pick_param.0059", "component not found (" + ls_component_id + ")", 4)
	setnull(ls_component_id)
	setnull(ls_id)
	ls_display = ""
end if

param_value = ls_component_id
set_nested_param_id(ls_id)
st_popup_values.text = ls_display

update_param(param_wizard.params.params[param_index].token1, param_value)


if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_component.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.st_component_type=create st_component_type
this.st_component_type_title=create st_component_type_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.st_component_type
this.Control[iCurrent+3]=this.st_component_type_title
end on

on u_param_component.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.st_component_type)
destroy(this.st_component_type_title)
end on

type st_preference from u_param_base`st_preference within u_param_component
end type

type st_preference_title from u_param_base`st_preference_title within u_param_component
end type

type cb_clear from u_param_base`cb_clear within u_param_component
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
set_nested_param_id(param_value)
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_component
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_component
end type

type st_title from u_param_base`st_title within u_param_component
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_component
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

type st_component_type from statictext within u_param_component
integer x = 1353
integer y = 472
integer width = 1294
integer height = 68
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Document Creator"
boolean focusrectangle = false
end type

type st_component_type_title from statictext within u_param_component
integer x = 379
integer y = 472
integer width = 942
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
string text = "Component Type:"
alignment alignment = right!
boolean focusrectangle = false
end type

