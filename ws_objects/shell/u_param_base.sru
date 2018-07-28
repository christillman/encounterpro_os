HA$PBExportHeader$u_param_base.sru
forward
global type u_param_base from userobject
end type
type st_preference from statictext within u_param_base
end type
type st_preference_title from statictext within u_param_base
end type
type cb_clear from commandbutton within u_param_base
end type
type st_required from statictext within u_param_base
end type
type st_helptext from statictext within u_param_base
end type
type st_title from statictext within u_param_base
end type
end forward

global type u_param_base from userobject
integer width = 2697
integer height = 1120
long backcolor = 33538240
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event type integer ue_required ( string ps_data )
event type integer postopen ( )
event preference_set ( )
st_preference st_preference
st_preference_title st_preference_title
cb_clear cb_clear
st_required st_required
st_helptext st_helptext
st_title st_title
end type
global u_param_base u_param_base

type variables
w_param_base param_wizard
integer param_index
string nested_param_id

boolean preference_in_use
string preference_id

end variables

forward prototypes
public function string sub_token (string ps_string, string ps_token, string ps_value)
public function integer x_initialize ()
public function string substitute_tokens (string ps_string)
public subroutine update_values ()
public subroutine set_values (ref str_params pstr_param, integer pi_index)
public function string get_popup_display (string ps_value)
public function integer check_required ()
public function string get_popup_items (integer pi_item_count, integer pi_item_indexes[])
public function integer load_query_data (string ps_query)
public function str_popup get_popup_selections (string ps_query, ref string psa_keys[])
public function string get_initial_value (integer pi_which)
public function integer initialize (w_param_base pw_param_wizard, integer pi_param_index)
public subroutine set_nested_param_id (string ps_id)
public function integer pick_param ()
public subroutine update_param (string ps_attribute, string ps_value)
public subroutine set_preference (string ps_preference_id)
end prototypes

event ue_required;If Not Isnull(ps_data) Then 
	w_param_wizard.event ue_required(true)
else
	w_param_wizard.event ue_required(false)
end if
return 0
end event

public function string sub_token (string ps_string, string ps_token, string ps_value);string ls_string
integer i, j

ls_string = ps_string
j = 1

DO
	i = pos(ls_string, ps_token, j)
	if i <= 0 then exit
	ls_string = replace(ls_string, i, len(ps_token), ps_value)
	j = i + len(ps_value)
LOOP WHILE true


return ls_string


end function

public function integer x_initialize ();//////////////////////////////////////////////////////////////////////////////////////
//
//	Description: override with decendent to initialize the attribute values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/01/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
return 1

end function

public function string substitute_tokens (string ps_string);return ps_string

end function

public subroutine update_values ();
end subroutine

public subroutine set_values (ref str_params pstr_param, integer pi_index);//////////////////////////////////////////////////////////////////////////////////////
//
//	Description:override this with decendent class to set attribute values
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
Return
end subroutine

public function string get_popup_display (string ps_value);////////////////////////////////////////////////////////////////////////////////////////
////
////	Return: string
////
////	Description: parse the data values and get preselected list of items.
////
//// Created By:Sumathi Chinnasamy										Creation dt: 10/18/99
////
//// Modified:	8/17/00	msc
///////////////////////////////////////////////////////////////////////////////////////
String   ls_display
integer li_values
integer i, j
string lsa_values[]
string lsa_display_items[]
long ll_item_count
//
//if isnull(query_data) then return ""
//
//ll_item_count = query_data.rowcount()
//
//// parse the ';' seperated data list
//li_values = f_parse_string(ps_value, ";", lsa_values)
//
//for i = 1 to ll_item_count
//	lsa_display_items[i] = String(query_data.Object.data[i,1])
//next
//
//// Set the boolean array to preselect the existing attribute values in pstr_popup list
//for i = 1 to ll_item_count
//	for j = 1 to li_values
//		If Trim(lsa_values[j]) = Trim(string(query_data.Object.data[i,2])) Then
//			if ls_display = "" then
//				ls_display = lsa_display_items[i]
//			else
//				ls_display += ", " + lsa_display_items[i]
//			end if
//		End If
//	next
//next 

Return ls_display



end function

public function integer check_required ();// function override at decendent class
Return 1
end function

public function string get_popup_items (integer pi_item_count, integer pi_item_indexes[]);long ll_row
long i
string ls_items
string ls_temp

//for i = 1 to pi_item_count
//	ll_row = pi_item_indexes[i]
//	if ll_row > 0 and ll_row <= query_data.rowcount() then
//		ls_temp = string(query_data.object.data[ll_row,2])
//		if ls_items = "" then
//			ls_items = ls_temp
//		else
//			ls_items += ";" + ls_temp
//		end if
//	end if
//next

return ls_items

end function

public function integer load_query_data (string ps_query);////////////////////////////////////////////////////////////////////////////////////////
////
////	Return: Integer [ -1 - no query  0 - no records     1 - success
////
////	Description: loads the query data into the query_data datastore
////
//// Created By:	Mark Copenhaver							Creation dt: 8/16/00
////
//// Modified By:												Modified On:
///////////////////////////////////////////////////////////////////////////////////////
//Long						ll_rows
//string ls_query
//
//
//ls_query = query
//
//// First do some string substitution on the query string
//
//if not isnull(current_patient) then
//	ls_query = f_string_substitute(ls_query, "%CPR_ID%", current_patient.cpr_id)
//	if not isnull(current_patient.open_encounter_id) then
//		ls_query = f_string_substitute(ls_query, "%ENCOUNTER_ID%", string(current_patient.open_encounter_id))
//	end if
//end if
//
//
//query_data = Create u_ds_data
//query_data.set_database(SQLCA)
//ll_rows = query_data.load_query(ls_query)
//If ll_rows < 0 Then 
//	log.log(This,"clicked()","Unable to load values to prepare popup list..",4)
//	DESTROY query_data
//	setnull(query_data)
//	Return -1
//End If
//If ll_rows = 0 Then
//	log.log(This,"clicked()","Popup query returned no rows",3)
//	DESTROY query_data
//	setnull(query_data)
//	Return 0
//End If
//
Return 1

end function

public function str_popup get_popup_selections (string ps_query, ref string psa_keys[]);//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: string
//
//	Description: parse the data values and get preselected list of items.
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/18/99
//
// Modified:	8/17/00	msc
/////////////////////////////////////////////////////////////////////////////////////
integer li_values
integer i, j
string lsa_values[]
long ll_item_count
str_popup popup
u_ds_data luo_data
long ll_rows
str_attributes lstr_attributes

popup.data_row_count = 0

lstr_attributes = param_wizard.state_attributes
f_attribute_add_attributes(lstr_attributes, param_wizard.attributes)

ps_query = f_string_substitute_attributes(ps_query, lstr_attributes)

luo_data = Create u_ds_data
luo_data.set_database(SQLCA)
ll_rows = luo_data.load_query(ps_query)
If ll_rows < 0 Then 
	log.log(This,"clicked()","Unable to load values to prepare popup list..",4)
	DESTROY luo_data
	Return popup
End If
If ll_rows = 0 Then
//	log.log(This,"clicked()","Popup query returned no rows",3)
	DESTROY luo_data
	Return popup
End If

ll_item_count = luo_data.rowcount()

popup.data_row_count = ll_item_count

for i = 1 to ll_item_count
	popup.items[i] = String(luo_data.Object.data[i,1])
	psa_keys[i] = String(luo_data.Object.data[i,2])
next

DESTROY luo_data

Return popup


end function

public function string get_initial_value (integer pi_which);string ls_intitial_value
string ls_param_initial
string ls_token

CHOOSE CASE pi_which
	CASE 1
		ls_token = param_wizard.params.params[param_index].token1
		ls_param_initial = param_wizard.params.params[param_index].initial1
	CASE 2
		ls_token = param_wizard.params.params[param_index].token2
		ls_param_initial = param_wizard.params.params[param_index].initial2
	CASE 3
		ls_token = param_wizard.params.params[param_index].token3
		ls_param_initial = param_wizard.params.params[param_index].initial3
	CASE 4
		ls_token = param_wizard.params.params[param_index].token4
		ls_param_initial = param_wizard.params.params[param_index].initial4
	CASE ELSE
		setnull(ls_intitial_value)
		return ls_intitial_value
END CHOOSE


// param_wizard.params.attributes		holds the passed in attributes for initializing
// 												the params to previous settings.
// param_wizard.attributes					holds the user selected attributes passed back to the caller
//

// See if this attribute was previously set
ls_intitial_value = f_attribute_find_attribute2(param_wizard.attributes, ls_token, param_wizard.params.id)

if isnull(ls_intitial_value) then
	if len(ls_param_initial) > 0 then
		// If this attribute was not previously set and an initial value exists, then
		// use the initial value setting
		ls_intitial_value = ls_param_initial
		
		// Add the configured initial value to the attributes
		f_attribute_add_attribute2( &
						param_wizard.attributes, &
						ls_token, &
						ls_intitial_value, &
						param_wizard.params.id )
	end if
end if


return ls_intitial_value


end function

public function integer initialize (w_param_base pw_param_wizard, integer pi_param_index);//////////////////////////////////////////////////////////////////////////////////////
//
//	Return: Integer
//
//	Description: initialize all the report attributes and call decendant
//
// Created By:Sumathi Chinnasamy										Creation dt: 10/05/99
//
// Modified By:															Modified On:
/////////////////////////////////////////////////////////////////////////////////////
string ls_attribute
string ls_value
string ls_preference_id

param_wizard = pw_param_wizard
param_index = pi_param_index

//if not isnull(query) then load_query_data()

st_title.text		= param_wizard.params.params[param_index].param_title

// To adjust height and width of display
st_helptext.height = 352
st_helptext.width = 2647

If Len(param_wizard.params.params[param_index].helptext) > 0 Then
	st_helptext.text	= param_wizard.params.params[param_index].helptext
	st_helptext.Visible = True
Else
	st_helptext.Visible = False
end if

If Upper(param_wizard.params.params[param_index].required_flag) = "Y" Then
	st_required.Visible = True
Else
	st_required.Visible = False
end if

setnull(nested_param_id)

if param_wizard.allow_preference then
	st_preference.visible = true
	st_preference_title.visible = true
	ls_attribute = param_wizard.params.params[param_index].token1
	ls_value = f_attribute_find_attribute2(param_wizard.attributes, ls_attribute, param_wizard.params.id)
	if len(ls_value) > 2 and left(ls_value, 1) = "%" and right(ls_value, 1) = "%" then
		ls_preference_id = mid(ls_value, 2, len(ls_value) - 2)
		if left(lower(ls_preference_id), 8) = "general " then
			ls_preference_id = mid(ls_preference_id, 9)
		end if
	else
		setnull(ls_preference_id)
	end if
	set_preference(ls_preference_id)
else
	st_preference.visible = false
	st_preference_title.visible = false
end if

return x_initialize()


end function

public subroutine set_nested_param_id (string ps_id);if len(ps_id) > 0 then
	nested_param_id = ps_id
else
	setnull(nested_param_id)
end if

param_wizard.set_buttons()

end subroutine

public function integer pick_param ();

return 0

end function

public subroutine update_param (string ps_attribute, string ps_value);string ls_preference_id

// Add the configured initial value to the attributes
f_attribute_add_attribute2( &
				param_wizard.attributes, &
				ps_attribute, &
				ps_value, &
				param_wizard.params.id )


if param_wizard.allow_preference then
	if len(ps_value) > 2 and left(ps_value, 1) = "%" and right(ps_value, 1) = "%" then
		ls_preference_id = mid(ps_value, 2, len(ps_value) - 2)
		if left(lower(ls_preference_id), 8) = "general " then
			ls_preference_id = mid(ls_preference_id, 9)
		end if
	else
		setnull(ls_preference_id)
	end if
	set_preference(ls_preference_id)
end if



end subroutine

public subroutine set_preference (string ps_preference_id);
if len(ps_preference_id) > 0 then
	preference_id = ps_preference_id
	preference_in_use = true
	st_preference.text = wordcap(ps_preference_id)
	st_preference.alignment = Left!
else
	setnull(preference_id)
	preference_in_use = false
	st_preference.text = "<Pick Preference>"
	st_preference.alignment = Center!
end if



end subroutine

on u_param_base.create
this.st_preference=create st_preference
this.st_preference_title=create st_preference_title
this.cb_clear=create cb_clear
this.st_required=create st_required
this.st_helptext=create st_helptext
this.st_title=create st_title
this.Control[]={this.st_preference,&
this.st_preference_title,&
this.cb_clear,&
this.st_required,&
this.st_helptext,&
this.st_title}
end on

on u_param_base.destroy
destroy(this.st_preference)
destroy(this.st_preference_title)
destroy(this.cb_clear)
destroy(this.st_required)
destroy(this.st_helptext)
destroy(this.st_title)
end on

event constructor;//setnull(query_data)

end event

event destructor;//if not isnull(query_data) and isvalid(query_data) then
//	DESTROY query_data
//	setnull(query_data)
//end if
//
end event

type st_preference from statictext within u_param_base
boolean visible = false
integer x = 27
integer y = 764
integer width = 1061
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "<Pick Preference>"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;string ls_preference_id
string ls_value

openwithparm(w_pick_preference, "FAVORITES")
ls_preference_id = message.stringparm
if len(ls_preference_id) > 0 then
	ls_value = "%General " + ls_preference_id + "%"
	update_param(param_wizard.params.params[param_index].token1, ls_value)
	x_initialize()
end if

	

end event

type st_preference_title from statictext within u_param_base
boolean visible = false
integer x = 27
integer y = 696
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
string text = "Preference"
boolean focusrectangle = false
end type

type cb_clear from commandbutton within u_param_base
integer x = 2267
integer y = 964
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear"
end type

event clicked;string ls_null

setnull(ls_null)

f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )

set_preference(ls_null)

end event

type st_required from statictext within u_param_base
integer x = 1394
integer y = 440
integer width = 55
integer height = 44
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 33538240
boolean enabled = false
string text = "*"
boolean focusrectangle = false
end type

type st_helptext from statictext within u_param_base
integer x = 18
integer y = 72
integer width = 2647
integer height = 352
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_title from statictext within u_param_base
integer x = 37
integer y = 476
integer width = 1275
integer height = 116
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 33538240
boolean enabled = false
string text = "Param Title"
alignment alignment = right!
boolean focusrectangle = false
end type

