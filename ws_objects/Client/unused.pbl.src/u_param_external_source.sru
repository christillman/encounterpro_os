$PBExportHeader$u_param_external_source.sru
forward
global type u_param_external_source from u_param_base
end type
type st_popup_values from statictext within u_param_external_source
end type
end forward

global type u_param_external_source from u_param_base
st_popup_values st_popup_values
end type
global u_param_external_source u_param_external_source

type variables
string  param_value


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
string ls_external_source
string ls_id

ls_external_source = get_initial_value(1)

if isnull(ls_external_source) then
	setnull(ls_description)
else
	SELECT e.description, CAST(c.id AS varchar(40))
	INTO :ls_description, :ls_id
	FROM c_External_Source e
		INNER JOIN (SELECT component_id, description, id FROM dbo.fn_components()) c
		ON e.component_id = c.component_id
	WHERE e.external_source = :ls_external_source;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then setnull(ls_description)
end if

if isnull(ls_description) or preference_in_use then
	setnull(param_value)
	ls_display = ""
else
	param_value = ls_external_source
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
string ls_treatment_type
string ls_display
string ls_external_source_type
string ls_external_source
string ls_id

ls_external_source_type = f_attribute_find_attribute2(param_wizard.attributes, "external_source_type", param_wizard.params.id)
if isnull(ls_external_source_type) then ls_external_source_type = "%"

popup.dataobject = "dw_external_source_of_type_pick"
popup.datacolumn = 1
popup.displaycolumn = 3
popup.argument_count = 1
popup.argument[1] = ls_external_source_type
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_external_source = popup_return.items[1]

SELECT e.description, CAST(c.id as varchar(40))
INTO :ls_display, :ls_id
FROM c_External_Source e
	INNER JOIN (SELECT component_id, description, id FROM dbo.fn_components()) c
	ON e.component_id = c.component_id
WHERE e.external_source = :ls_external_source;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_param_external_source.pick_param:0036", "external source component not found (" + ls_external_source + ")", 4)
	setnull(ls_external_source)
	setnull(ls_id)
	ls_display = ""
end if

param_value = ls_external_source
set_nested_param_id(ls_id)
st_popup_values.text = ls_display

update_param(param_wizard.params.params[param_index].token1, param_value)


if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_external_source.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
end on

on u_param_external_source.destroy
call super::destroy
destroy(this.st_popup_values)
end on

type st_preference from u_param_base`st_preference within u_param_external_source
end type

type st_preference_title from u_param_base`st_preference_title within u_param_external_source
end type

type cb_clear from u_param_base`cb_clear within u_param_external_source
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
set_nested_param_id(param_value)
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_external_source
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_external_source
end type

type st_title from u_param_base`st_title within u_param_external_source
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_external_source
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

