$PBExportHeader$u_param_popup_single.sru
forward
global type u_param_popup_single from u_param_base
end type
type st_popup_values from statictext within u_param_popup_single
end type
end forward

global type u_param_popup_single from u_param_base
st_popup_values st_popup_values
end type
global u_param_popup_single u_param_popup_single

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
string ls_display
string ls_initial_value

ls_initial_value = get_initial_value(1)
setnull(param_value)


// find the existing keys in the keys array
ls_display = ""
if not preference_in_use then
	ls_query = param_wizard.params.params[param_index].query
	
	popup = get_popup_selections(ls_query, lsa_keys)
	
	for i = 1 to popup.data_row_count
		If Trim(ls_initial_value) = Trim(lsa_keys[i]) Then
			param_value = ls_initial_value
			ls_display = popup.items[i]
			exit
		End If
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
String				ls_display
string lsa_keys[]
integer i
string ls_query

ls_query = param_wizard.params.params[param_index].query

ls_query = f_string_substitute_attributes(ls_query, param_wizard.attributes)

popup = get_popup_selections(ls_query, lsa_keys)
popup.multiselect = false

// Set the boolean array to preselect the existing attribute values in popup list
for i = 1 to popup.data_row_count
	If Trim(param_value) = Trim(lsa_keys[i]) Then
		popup.preselected_items[i] = True
	Else
		popup.preselected_items[i] = false
	End If
next 

// Let the user pick the popup items
Openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
If popup_return.item_count <> 1 Then return 0

// Create a semi-colon delimited string of the selected keys
ls_display = popup.items[popup_return.item_indexes[1]]
param_value = lsa_keys[popup_return.item_indexes[1]]

update_param(param_wizard.params.params[param_index].token1, param_value)

st_popup_values.text = ls_display

if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if


return 1

end function

on u_param_popup_single.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
end on

on u_param_popup_single.destroy
call super::destroy
destroy(this.st_popup_values)
end on

event postopen;//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer [ -1 - no query  0 - no records     1 - success
//
//	Description: loads all display column and set the boolean array for selected items
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/18/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////

//st_popup_values.text = get_popup_display(old_data)

Return 1
end event

type st_preference from u_param_base`st_preference within u_param_popup_single
end type

type st_preference_title from u_param_base`st_preference_title within u_param_popup_single
end type

type cb_clear from u_param_base`cb_clear within u_param_popup_single
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_popup_single
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_popup_single
end type

type st_title from u_param_base`st_title within u_param_popup_single
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_popup_single
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

