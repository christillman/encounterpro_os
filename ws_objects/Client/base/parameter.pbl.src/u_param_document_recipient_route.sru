$PBExportHeader$u_param_document_recipient_route.sru
forward
global type u_param_document_recipient_route from u_param_base
end type
type st_popup_values from statictext within u_param_document_recipient_route
end type
type st_purpose from statictext within u_param_document_recipient_route
end type
type st_2 from statictext within u_param_document_recipient_route
end type
type st_document_route from statictext within u_param_document_recipient_route
end type
type st_3 from statictext within u_param_document_recipient_route
end type
end forward

global type u_param_document_recipient_route from u_param_base
st_popup_values st_popup_values
st_purpose st_purpose
st_2 st_2
st_document_route st_document_route
st_3 st_3
end type
global u_param_document_recipient_route u_param_document_recipient_route

type variables
string param_ordered_for
string param_document_route

string report_id
end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public subroutine show_routes (string ps_message)
public function integer pick_recipient ()
public function integer pick_route ()
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
	If Isnull(param_ordered_for) Then
		Openwithparm(w_pop_message,"Please select a " + st_title.text)
		Return -1
	End if
	If Isnull(param_document_route) Then
		Openwithparm(w_pop_message,"Please select a route")
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
string ls_initial_value
string ls_description
string ls_purpose
string ls_context_object
string ls_document_format

ls_context_object = f_attribute_find_attribute(param_wizard.attributes, "context_object")
if isnull(ls_context_object) then
	ls_context_object = f_attribute_find_attribute(param_wizard.state_attributes, "context_object")
	if isnull(ls_context_object) then
		ls_context_object = "Patient"
	end if
end if

ls_purpose = f_attribute_find_attribute(param_wizard.attributes, "purpose")
if isnull(ls_purpose) then
	report_id = f_attribute_find_attribute(param_wizard.attributes, "report_id")
	if isnull(report_id) then
		ls_document_format = "Human"
	else
		SELECT document_format
		INTO :ls_document_format
		FROM c_Report_Definition
		WHERE report_id = :report_id;
		if not tf_check() or sqlca.sqlcode = 100 then
			ls_document_format = "Human"
		end if
	end if
	
	if lower(ls_document_format) = "machine" then
		ls_purpose = ls_context_object + " Data"
	else
		ls_purpose = ls_context_object + " Report"
	end if
end if

st_purpose.text = ls_purpose

// Init ordered_for
ls_initial_value = get_initial_value(1)

ls_description = user_list.user_full_name(ls_initial_value)
if isnull(ls_description) or preference_in_use then
	setnull(param_ordered_for)
	ls_display = ""
else
	param_ordered_for = ls_initial_value
	ls_display = ls_description
end if

st_popup_values.text = ls_display

// Init document_route
ls_initial_value = get_initial_value(2)

ls_description = ls_initial_value
if isnull(ls_description) or preference_in_use then
	setnull(param_document_route)
	ls_display = ""
else
	param_document_route = ls_initial_value
	ls_display = ls_description
end if

st_document_route.text = ls_display

return 1

end function

public subroutine show_routes (string ps_message);str_popup popup


popup.data_row_count = 5
popup.title = ps_message
setnull(popup.items[1]) // ordered_by unknown
popup.items[2] = param_ordered_for
popup.items[3] = st_purpose.text
setnull(popup.items[4]) // cpr_id unknown
popup.items[5] = report_id
openwithparm(w_pop_document_routes, popup)



end subroutine

public function integer pick_recipient ();integer li_sts
str_popup popup
str_popup_return popup_return
string ls_actor_class
str_pick_users lstr_pick_users

popup.dataobject = "dw_actor_class_for_purpose"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.auto_singleton = true
popup.argument_count = 1
popup.argument[1] = st_purpose.text
popup.title = "Select Recipient Class"
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	// If there were any choices then the user clicked "Cancel"
	if popup_return.choices_count > 0 then return 0
	
	// If there were no choices, then have the user pick between user and patient
	popup.dataobject = ""
	popup.datacolumn = 0
	popup.displaycolumn = 0
	popup.auto_singleton = false
	popup.argument_count = 0
	popup.title = "Select Recipient Class"
	popup.data_row_count = 2
	popup.items[1] = "User"
	popup.items[2] = "Patient"
	openwithparm(w_pop_pick, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count <> 1 then return 0
end if
ls_actor_class = popup_return.items[1]


if lower(ls_actor_class)  = "patient" then
	param_ordered_for = "#PATIENT"
else
//	lstr_pick_users.cpr_id = service.cpr_id
	lstr_pick_users.hide_users = true
	lstr_pick_users.actor_class = ls_actor_class
	lstr_pick_users.pick_screen_title = "Select " + wordcap(ls_actor_class)
	li_sts = user_list.pick_users(lstr_pick_users)
	if li_sts <= 0 then return 0
	
	param_ordered_for = lstr_pick_users.selected_users.user[1].user_id
end if


update_param(param_wizard.params.params[param_index].token1, param_ordered_for)

st_popup_values.text = user_list.user_full_name(param_ordered_for)

if st_required.visible and not isnull(param_ordered_for) then
	param_wizard.event POST ue_required(true)
end if


return 1

end function

public function integer pick_route ();integer li_sts
str_popup popup
str_popup_return popup_return
string ls_actor_class
str_pick_users lstr_pick_users

popup.dataobject = "dw_document_valid_routes_pick"
popup.datacolumn = 1
popup.displaycolumn = 1
popup.auto_singleton = true
popup.argument_count = 5
setnull(popup.argument[1]) // ordered_by unknown
popup.argument[2] = param_ordered_for
popup.argument[3] = st_purpose.text
setnull(popup.argument[4]) // cpr_id unknown
popup.argument[5] = report_id
openwithparm(w_pop_pick, popup)
popup_return = message.powerobjectparm
if popup_return.item_count = 1 then
	param_document_route = popup_return.items[1]
else
	if popup_return.choices_count > 0 then return 0
	
	// Show the available routes and reasons for not being valid
	show_routes("No valid Routes")
	return 0
end if

update_param(param_wizard.params.params[param_index].token2, param_document_route)

st_document_route.text = param_document_route

if st_required.visible and not isnull(param_document_route) then
	param_wizard.event POST ue_required(true)
end if


return 1

end function

public function integer pick_param ();integer li_sts

li_sts = pick_recipient()
if li_sts <= 0 then return li_sts

li_sts = pick_route()
if li_sts <= 0 then return li_sts

return 1

end function

on u_param_document_recipient_route.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.st_purpose=create st_purpose
this.st_2=create st_2
this.st_document_route=create st_document_route
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.st_purpose
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_document_route
this.Control[iCurrent+5]=this.st_3
end on

on u_param_document_recipient_route.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.st_purpose)
destroy(this.st_2)
destroy(this.st_document_route)
destroy(this.st_3)
end on

type st_preference from u_param_base`st_preference within u_param_document_recipient_route
integer y = 896
end type

type st_preference_title from u_param_base`st_preference_title within u_param_document_recipient_route
integer y = 828
end type

type cb_clear from u_param_base`cb_clear within u_param_document_recipient_route
end type

event cb_clear::clicked;call super::clicked;setnull(param_ordered_for)
setnull(param_document_route)
st_popup_values.text = ""
st_document_route.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token2, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_document_recipient_route
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_document_recipient_route
end type

type st_title from u_param_base`st_title within u_param_document_recipient_route
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_document_recipient_route
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

event clicked;pick_recipient()

end event

type st_purpose from statictext within u_param_document_recipient_route
integer x = 1189
integer y = 452
integer width = 864
integer height = 68
boolean bringtotop = true
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean focusrectangle = false
end type

type st_2 from statictext within u_param_document_recipient_route
integer x = 585
integer y = 452
integer width = 594
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Document Purpose:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_document_route from statictext within u_param_document_recipient_route
integer x = 1353
integer y = 776
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

event clicked;pick_route()
end event

type st_3 from statictext within u_param_document_recipient_route
integer x = 873
integer y = 800
integer width = 448
integer height = 76
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Via Route"
alignment alignment = right!
boolean focusrectangle = false
end type

