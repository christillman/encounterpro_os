HA$PBExportHeader$u_param_config_object_base.sru
forward
global type u_param_config_object_base from u_param_base
end type
type st_popup_values from statictext within u_param_config_object_base
end type
type cb_configure from commandbutton within u_param_config_object_base
end type
end forward

global type u_param_config_object_base from u_param_base
st_popup_values st_popup_values
cb_configure cb_configure
end type
global u_param_config_object_base u_param_config_object_base

type variables
string  param_value
boolean config_object_configurable

// In the descendent class this should be assigned to the correct config_object_type
string config_object_type


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
string ls_config_object_id
string ls_classname
string ls_configuration_service

// Make sure we have a config_object_type
if isnull(config_object_type) or trim(config_object_type) = "" then
	// First use SQL
	if len(param_wizard.params.params[param_index].query) > 0 then
		config_object_type = param_wizard.params.params[param_index].query
	else
		ls_classname = this.classname
		if lower(left(ls_classname, 22)) = "u_param_config_object_" then
			config_object_type = mid(ls_classname, 23, 100)
			config_object_type = Wordcap(f_string_substitute(config_object_type, "_", " "))
		end if
	end if
end if

// Make sure we have a valid config_object_type
SELECT configuration_service
INTO :ls_configuration_service
FROM c_Config_Object_Type
WHERE config_object_type = :config_object_type;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "x_initialize()", "Invalid config_object_type (" + config_object_type + ")", 4)
	return -1
end if

if len(ls_configuration_service) > 0 then
	config_object_configurable = true
else
	config_object_configurable = false
end if


ls_config_object_id = get_initial_value(1)

if isnull(ls_config_object_id) or preference_in_use then
	setnull(ls_description)
else
	SELECT description
	INTO :ls_description
	FROM c_config_object
	WHERE config_object_id = :ls_config_object_id;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then setnull(ls_description)
end if

cb_configure.visible = false

if isnull(ls_description) or preference_in_use then
	setnull(param_value)
	ls_display = ""
else
	param_value = ls_config_object_id
	ls_display = ls_description
	set_nested_param_id(param_value)
	
	if config_object_configurable then
		cb_configure.visible = true
	end if
end if

st_popup_values.text = ls_display

return 1

end function

public function integer pick_param ();str_popup_return	popup_return
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_window_base lw_pick
string ls_display
str_pick_config_object lstr_pick_config_object


lstr_pick_config_object.config_object_type = config_object_type
lstr_pick_config_object.context_object = f_attribute_find_attribute2(param_wizard.attributes, "context_object", param_wizard.params.id)

openwithparm(lw_pick, lstr_pick_config_object, "w_pick_config_object")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

ls_display = popup_return.descriptions[1]
param_value = popup_return.items[1]
set_nested_param_id(param_value)

update_param(param_wizard.params.params[param_index].token1, param_value)

st_popup_values.text = ls_display

if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if

if len(param_value) > 0 and config_object_configurable then
	cb_configure.visible = true
else
	cb_configure.visible = false
end if

return 1

end function

on u_param_config_object_base.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.cb_configure=create cb_configure
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.cb_configure
end on

on u_param_config_object_base.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.cb_configure)
end on

type st_preference from u_param_base`st_preference within u_param_config_object_base
end type

type st_preference_title from u_param_base`st_preference_title within u_param_config_object_base
end type

type cb_clear from u_param_base`cb_clear within u_param_config_object_base
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_config_object_base
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_config_object_base
end type

type st_title from u_param_base`st_title within u_param_config_object_base
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_config_object_base
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

type cb_configure from commandbutton within u_param_config_object_base
boolean visible = false
integer x = 1815
integer y = 732
integer width = 366
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Configure"
end type

event clicked;f_configure_config_object(param_value)

end event

