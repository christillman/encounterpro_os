$PBExportHeader$u_param_enum.sru
forward
global type u_param_enum from u_param_base
end type
type dw_choices from u_dw_pick_list within u_param_enum
end type
end forward

global type u_param_enum from u_param_base
dw_choices dw_choices
end type
global u_param_enum u_param_enum

type variables
string  param_value

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
string ls_find
long ll_row
string lsa_values[]
long ll_count
long i
string ls_description
string ls_value


// The enumerated values are comma delimited.  We will allow for the
// comma deliomited values to have two parts seperated by a vertical bar
// i.e. <value>|<description>
// where <value is the value actually saved and <description> is what gets
// shown to the user on the selection screen

dw_choices.reset()

// First parse the query string and fill the datawindow
ll_count = f_parse_string(param_wizard.params.params[param_index].query, ",", lsa_values)
for i = 1 to ll_count
	f_split_string(trim(lsa_values[i]), "|", ls_value, ls_description)
	if ls_description = "" then ls_description = ls_value
	ll_row = dw_choices.insertrow(0)
	dw_choices.object.value[ll_row] = trim(ls_value)
	dw_choices.object.description[ll_row] = trim(ls_description)
next


// Now find the initial value and select it
ls_intitial_value = get_initial_value(1)
setnull(param_value)
	
if not preference_in_use then
	If trim(ls_intitial_value) <> "" and not isnull(ls_intitial_value) Then
		ls_find = "lower(value)='" + lower(ls_intitial_value) + "'"
		ll_row = dw_choices.find(ls_find, 1, dw_choices.rowcount())
		if ll_row > 0 then
			param_value = ls_intitial_value
			dw_choices.object.selected_flag[ll_row] = 1
		end if
	end if
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
	If Isnull(param_value) Or Len(param_value) = 0 Then
		Openwithparm(w_pop_message,"Please enter a " + st_title.text)
		Return -1
	End if
End If

Return 1
end function

public function integer pick_param ();str_popup popup
str_popup_return popup_return
long i

popup.data_row_count = dw_choices.rowcount()
for i = 1 to popup.data_row_count
	popup.items[i] = dw_choices.object.description[i]
next
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0

param_value = dw_choices.object.value[popup_return.item_indexes[1]]
update_param(param_wizard.params.params[param_index].token1, param_value)


return 1

end function

on u_param_enum.create
int iCurrent
call super::create
this.dw_choices=create dw_choices
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_choices
end on

on u_param_enum.destroy
call super::destroy
destroy(this.dw_choices)
end on

type st_preference from u_param_base`st_preference within u_param_enum
end type

type st_preference_title from u_param_base`st_preference_title within u_param_enum
end type

type cb_clear from u_param_base`cb_clear within u_param_enum
integer x = 914
integer y = 992
end type

event cb_clear::clicked;call super::clicked;dw_choices.clear_selected()
setnull(param_value)
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_enum
integer x = 1298
end type

type st_helptext from u_param_base`st_helptext within u_param_enum
end type

type st_title from u_param_base`st_title within u_param_enum
integer x = 50
integer y = 480
end type

type dw_choices from u_dw_pick_list within u_param_enum
integer x = 1353
integer y = 452
integer width = 1312
integer height = 648
integer taborder = 10
boolean bringtotop = true
string dataobject = "dw_param_enum"
boolean vscrollbar = true
boolean border = false
end type

event selected;call super::selected;param_value = dw_choices.object.value[selected_row]
update_param(param_wizard.params.params[param_index].token1, param_value)

end event

event unselected;call super::unselected;setnull(param_value)
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )

end event

