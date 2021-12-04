$PBExportHeader$u_param_popup.sru
forward
global type u_param_popup from u_param_base
end type
type st_popup_values from statictext within u_param_popup
end type
type st_popup_title from statictext within u_param_popup
end type
end forward

global type u_param_popup from u_param_base
st_popup_values st_popup_values
st_popup_title st_popup_title
end type
global u_param_popup u_param_popup

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
str_popup popup
string lsa_keys[]
string ls_query
integer li_value_count
string lsa_values[]
integer i
integer j
string ls_display
string ls_initial_value

ls_initial_value = get_initial_value(1)

// find the existing keys in the keys array and add the corresponding display to the display
ls_display = ""
if not preference_in_use then
	ls_query = param_wizard.params.params[param_index].query
	
	popup = get_popup_selections(ls_query, lsa_keys)
	
	// parse the ';' seperated data list
	li_value_count = f_parse_string(ls_initial_value, ";", lsa_values)
	
	for i = 1 to li_value_count
		for j = 1 to popup.data_row_count
			If Trim(lsa_values[i]) = Trim(lsa_keys[j]) Then
				if ls_display <> "" then
					param_value += ";"
					ls_display += "~r~n"
				end if
				param_value += lsa_values[i]
				ls_display += popup.items[j]
				exit
			End If
		next
	next
end if

st_popup_values.text = ls_display

return 1

end function

public function integer pick_param ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: none
//
//	Description:popup the list and select one or more attribute values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/19/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
str_popup			popup
str_popup_return	popup_return
Long					li_index = 1
String				ls_display
integer li_value_count
string lsa_values[]
string lsa_keys[]
integer i, j
string ls_query

ls_query = param_wizard.params.params[param_index].query

ls_query = f_string_substitute_attributes(ls_query, param_wizard.attributes)

popup = get_popup_selections(ls_query, lsa_keys)
popup.multiselect = True

// parse the ';' seperated data list
li_value_count = f_parse_string(param_value, ";", lsa_values)

// Set the boolean array to preselect the existing attribute values in popup list
for i = 1 to popup.data_row_count
	for j = 1 to li_value_count
		If Trim(lsa_values[j]) = Trim(lsa_keys[i]) Then
			popup.preselected_items[i] = True
		Else
			popup.preselected_items[i] = false
		End If
	next
next 

// Let the user pick the popup items
Openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
If popup_return.item_count <= 0 Then return 0

// Create a semi-colon delimited string of the selected keys
ls_display = ""
param_value = ""
for i = 1 to popup_return.item_count
	if i > 1 then param_value += ";"
	param_value += lsa_keys[popup_return.item_indexes[i]]
	
	if i > 1 then ls_display += "~r~n"
	ls_display += popup.items[popup_return.item_indexes[i]]
next

update_param(param_wizard.params.params[param_index].token1, param_value)

st_popup_values.text = ls_display

if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if


return 1

end function

on u_param_popup.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.st_popup_title=create st_popup_title
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.st_popup_title
end on

on u_param_popup.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.st_popup_title)
end on

type st_preference from u_param_base`st_preference within u_param_popup
integer x = 23
integer y = 892
end type

type st_preference_title from u_param_base`st_preference_title within u_param_popup
integer x = 23
integer y = 824
end type

type cb_clear from u_param_base`cb_clear within u_param_popup
integer x = 2272
integer y = 1000
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_popup
integer x = 1490
integer y = 436
end type

type st_helptext from u_param_base`st_helptext within u_param_popup
end type

type st_title from u_param_base`st_title within u_param_popup
integer x = 155
integer y = 500
end type

type st_popup_values from statictext within u_param_popup
integer x = 1490
integer y = 496
integer width = 1138
integer height = 476
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

type st_popup_title from statictext within u_param_popup
integer x = 411
integer y = 716
integer width = 1051
integer height = 76
boolean bringtotop = true
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = COLOR_BACKGROUND
boolean enabled = false
string text = "Click this button to pick values = >"
boolean focusrectangle = false
end type

