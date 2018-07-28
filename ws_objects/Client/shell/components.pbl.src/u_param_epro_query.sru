$PBExportHeader$u_param_epro_query.sru
forward
global type u_param_epro_query from u_param_base
end type
type st_popup_values from statictext within u_param_epro_query
end type
end forward

global type u_param_epro_query from u_param_base
st_popup_values st_popup_values
end type
global u_param_epro_query u_param_epro_query

type variables
string query_library_id
string query_object

end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
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
	If Isnull(query_library_id) or isnull(query_object) Then
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
str_drug_definition lstr_drug
integer li_sts
string ls_query_library_id
string ls_query_object
long ll_material_id

setnull(query_library_id)
setnull(query_object)
ls_display = ""

ls_initial_value = get_initial_value(1)

f_split_string(ls_initial_value, ".", ls_query_library_id, ls_query_object)
if len(ls_query_library_id) >= 36 and len(ls_query_object) > 0 then
	// make sure the library id is valid
	SELECT max(material_id)
	INTO :ll_material_id
	FROM c_Patient_Material
	WHERE id = :ls_query_library_id
	AND status = 'OK';
	if not tf_check() then return -1
	if sqlca.sqlnrows = 1 then
		SELECT title
		INTO :ls_display
		FROM c_Patient_Material
		WHERE id = :ls_query_library_id
		AND status = 'OK';
		if not tf_check() then return -1
		
		query_library_id = ls_query_library_id
		query_object = ls_query_object
	end if
end if

st_popup_values.text = ls_display

return 1

end function

on u_param_epro_query.create
int iCurrent
call super::create
this.st_popup_values=create st_popup_values
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_popup_values
end on

on u_param_epro_query.destroy
call super::destroy
destroy(this.st_popup_values)
end on

type cb_clear from u_param_base`cb_clear within u_param_epro_query
end type

event cb_clear::clicked;call super::clicked;setnull(query_library_id)
setnull(query_object)
st_popup_values.text = ""
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_epro_query
integer x = 1358
integer y = 536
end type

type st_helptext from u_param_base`st_helptext within u_param_epro_query
end type

type st_title from u_param_base`st_title within u_param_epro_query
integer x = 46
integer y = 616
integer height = 76
end type

type st_popup_values from statictext within u_param_epro_query
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

event clicked;//str_picked_drugs lstr_drugs
//string ls_observation_id
//string ls_description
//long ll_row
//string ls_composite_flag
//long i
//string ls_treatment_type
//w_pick_patient_material lw_pick
//string ls_display
//long ll_material_id
//
//open(lw_pick, "w_pick_patient_material")
//ll_material_id = message.doubleparm
//if ll_material_id > 0 then
//	SELECT title
//	INTO :ls_display
//	FROM c_Patient_Material
//	WHERE material_id = :ll_material_id;
//	if not tf_check() then return
//	if sqlca.sqlcode = 100 then return
//	
//	param_value = string(ll_material_id)
//else
//	return
//end if
//
//
//f_attribute_add_attribute2( &
//				param_wizard.attributes, &
//				param_wizard.params.params[param_index].token1, &
//				param_value, &
//				param_wizard.params.id )
//
//st_popup_values.text = ls_display
//
//if st_required.visible and not isnull(param_value) then
//	param_wizard.event POST ue_required(true)
//end if
//
end event

