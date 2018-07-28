HA$PBExportHeader$u_param_workplan.sru
forward
global type u_param_workplan from u_param_base
end type
type st_popup_values from statictext within u_param_workplan
end type
type cb_edit_display_script from commandbutton within u_param_workplan
end type
end forward

global type u_param_workplan from u_param_base
st_popup_values st_popup_values
cb_edit_display_script cb_edit_display_script
end type
global u_param_workplan u_param_workplan

type variables
str_c_workplan workplan

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
	If Isnull(workplan.workplan_id) Then
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
string ls_initial_value
string ls_description
long ll_workplan_id

ll_workplan_id = long(get_initial_value(1))

if preference_in_use then
	ls_display = ""
else
	workplan = datalist.get_workplan(ll_workplan_id)
	if isnull(workplan.workplan_id) then
		ls_display = ""
	else
		ls_display = workplan.description
	end if
end if

st_popup_values.text = ls_display

return 1

end function

public function integer pick_param ();u_user luo_user
str_c_workplan lstr_workplan
w_pick_workplan lw_window
str_workplan_context lstr_workplan_context

lstr_workplan_context.context_object = f_attribute_find_attribute2(param_wizard.attributes, "context_object", param_wizard.params.id)
lstr_workplan_context.in_office_flag = "?" // Let the user pick

openwithparm(lw_window, lstr_workplan_context, "w_pick_workplan")
lstr_workplan = message.powerobjectparm
if isnull(lstr_workplan.workplan_id) then return 0

workplan = lstr_workplan

update_param(param_wizard.params.params[param_index].token1, string(lstr_workplan.workplan_id))

st_popup_values.text = lstr_workplan.description

if st_required.visible and not isnull(lstr_workplan.workplan_id) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_workplan.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
this.cb_edit_display_script=create cb_edit_display_script
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
this.Control[iCurrent+2]=this.cb_edit_display_script
end on

on u_param_workplan.destroy
call super::destroy
destroy(this.st_popup_values)
destroy(this.cb_edit_display_script)
end on

type st_preference from u_param_base`st_preference within u_param_workplan
end type

type st_preference_title from u_param_base`st_preference_title within u_param_workplan
end type

type cb_clear from u_param_base`cb_clear within u_param_workplan
end type

event cb_clear::clicked;call super::clicked;setnull(workplan.workplan_id)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_workplan
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_workplan
end type

type st_title from u_param_base`st_title within u_param_workplan
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_workplan
integer x = 1353
integer y = 596
integer width = 1294
integer height = 224
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

type cb_edit_display_script from commandbutton within u_param_workplan
integer x = 1861
integer y = 836
integer width = 297
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Edit"
end type

event clicked;w_window_base lw_edit_window
str_popup popup
long ll_workplan_id
string ls_id

ll_workplan_id = workplan.workplan_id
if isnull(ll_workplan_id) or ll_workplan_id <= 0 then return

SELECT CAST(id AS varchar(40))
INTO :ls_id
FROM c_workplan
WHERE workplan_id = :ll_workplan_id;
if not tf_check() then return
if sqlca.sqlcode = 100 then return

popup.data_row_count = 2
popup.items[1] = ls_id
popup.items[2] = "true"

openwithparm(lw_edit_window, popup, "w_Workplan_definition_display")

end event

