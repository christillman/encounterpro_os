$PBExportHeader$u_param_drug_multiple.sru
forward
global type u_param_drug_multiple from u_param_base
end type
type lb_drugs from listbox within u_param_drug_multiple
end type
type cb_add_more from commandbutton within u_param_drug_multiple
end type
end forward

global type u_param_drug_multiple from u_param_base
lb_drugs lb_drugs
cb_add_more cb_add_more
end type
global u_param_drug_multiple u_param_drug_multiple

type variables
string  param_value
string drug_type
end variables

forward prototypes
public function integer check_required ()
public function integer x_initialize ()
public function integer refresh ()
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

string ls_initial_value
str_drug_definition lstr_drug
integer li_sts
string lsa_drug_id[]
long ll_count
long i

param_value = get_initial_value(1)

drug_type = f_attribute_find_attribute(param_wizard.state_attributes, "drug_type")
if isnull(drug_type) then
	// If not state variable for drug_type, use the query field
	drug_type = param_wizard.params.params[param_index].query
end if

refresh()

return 1

end function

public function integer refresh ();str_drug_definition lstr_drug
integer li_sts
string lsa_drug_id[]
long ll_count
long i

lb_drugs.reset()

if len(param_value) > 0 and not preference_in_use then
	ll_count = f_parse_string(param_value, ",", lsa_drug_id)
else
	ll_count = 0
end if

for i = 1 to ll_count
	li_sts = drugdb.get_drug_definition(lsa_drug_id[i], lstr_drug)
	if li_sts > 0 then
		lb_drugs.additem(lstr_drug.common_name)
		if len(param_value) > 0 then
			param_value += "," + lsa_drug_id[i]
		else
			param_value = lsa_drug_id[i]
		end if
	end if
next

return 1

end function

public function integer pick_param ();str_picked_drugs lstr_drugs
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_pick_drugs lw_pick

openwithparm(lw_pick, "w_pick_drugs", drug_type)
lstr_drugs = message.powerobjectparm
if lstr_drugs.drug_count < 1 then return 0

for i = 1 to lstr_drugs.drug_count
	lb_drugs.additem(lstr_drugs.drugs[1].description)
	if len(param_value) > 0 then
		param_value += "," + lstr_drugs.drugs[1].drug_id
	else
		param_value = lstr_drugs.drugs[1].drug_id
	end if
next

update_param(param_wizard.params.params[param_index].token1, param_value)

if st_required.visible and not isnull(param_value) then
	param_wizard.event POST ue_required(true)
end if

return 1

end function

on u_param_drug_multiple.create
int iCurrent
call super::create
this.lb_drugs=create lb_drugs
this.cb_add_more=create cb_add_more
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_drugs
this.Control[iCurrent+2]=this.cb_add_more
end on

on u_param_drug_multiple.destroy
call super::destroy
destroy(this.lb_drugs)
destroy(this.cb_add_more)
end on

type st_preference from u_param_base`st_preference within u_param_drug_multiple
end type

type st_preference_title from u_param_base`st_preference_title within u_param_drug_multiple
end type

type cb_clear from u_param_base`cb_clear within u_param_drug_multiple
end type

event cb_clear::clicked;call super::clicked;setnull(param_value)
lb_drugs.reset( )
f_attribute_remove_attribute2( &
				param_wizard.attributes, &
				param_wizard.params.params[param_index].token1, &
				param_wizard.params.id )


end event

type st_required from u_param_base`st_required within u_param_drug_multiple
integer x = 1358
end type

type st_helptext from u_param_base`st_helptext within u_param_drug_multiple
end type

type st_title from u_param_base`st_title within u_param_drug_multiple
integer x = 46
integer y = 520
integer height = 76
end type

type lb_drugs from listbox within u_param_drug_multiple
integer x = 1353
integer y = 500
integer width = 1298
integer height = 428
integer taborder = 10
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean vscrollbar = true
end type

event selectionchanged;str_popup_return popup_return
string lsa_drug_id[]
long ll_count
long i
string ls_new_param_value

openwithparm(w_pop_yes_no, "Do you wish to remove " + item[index] + " from the list?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

ls_new_param_value = ""

ll_count = f_parse_string(param_value, ",", lsa_drug_id)
for i = 1 to ll_count
	if i = index then continue
	if len(ls_new_param_value) > 0 then
		ls_new_param_value += "," + lsa_drug_id[i]
	else
		ls_new_param_value = lsa_drug_id[i]
	end if
next

if len(ls_new_param_value) > 0 then
	param_value = ls_new_param_value
else
	setnull(param_value)
end if

refresh()

end event

type cb_add_more from commandbutton within u_param_drug_multiple
integer x = 969
integer y = 844
integer width = 357
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add More"
end type

event clicked;pick_param()
end event

