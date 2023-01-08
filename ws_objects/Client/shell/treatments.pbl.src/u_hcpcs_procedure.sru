$PBExportHeader$u_hcpcs_procedure.sru
forward
global type u_hcpcs_procedure from statictext
end type
type str_hcpcs from structure within u_hcpcs_procedure
end type
end forward

type str_hcpcs from structure
	long		hcpcs_sequence
	real		administer_amount
	string		administer_unit
	string		procedure_id
	string		description
	string		cpt_code
end type

global type u_hcpcs_procedure from statictext
integer width = 690
integer height = 88
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15780004
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type
global u_hcpcs_procedure u_hcpcs_procedure

type variables
string drug_id
private str_hcpcs hcpcs[]
integer hcpcs_count

string procedure_id
end variables

forward prototypes
public function integer get_default (string ps_administer_method)
public function integer set_value (string ps_procedure_id)
public function integer set_value (string ps_procedure_id, string ps_description)
public function integer initialize (string ps_drug_id)
public function integer set_value (real pr_administer_amount, string ps_administer_unit)
end prototypes

public function integer get_default (string ps_administer_method);string ls_procedure_id
integer li_sts

li_sts = tf_get_default_admin_procedure(ps_administer_method, ls_procedure_id)

if li_sts > 0 then
	set_value(ls_procedure_id)
end if

return li_sts
end function

public function integer set_value (string ps_procedure_id);string ls_procedure_description
integer li_sts

if isnull(ps_procedure_id) or ps_procedure_id = "" then
	setnull(procedure_id)
	text = "N/A"
	return 1
end if

li_sts = tf_get_procedure_description(ps_procedure_id, ls_procedure_description)
if li_sts > 0 then
	text = ls_procedure_description
	procedure_id = ps_procedure_id
end if

return li_sts
end function

public function integer set_value (string ps_procedure_id, string ps_description);string ls_procedure_description
integer li_sts

procedure_id = ps_procedure_id
if procedure_id = "" then setnull(procedure_id)

if isnull(procedure_id) then
	text = "N/A"
else
	text = ps_description
end if

return 1

end function

public function integer initialize (string ps_drug_id);boolean lb_loop
long ll_hcpcs_sequence
real lr_administer_amount
string ls_administer_unit
string ls_procedure_id
string ls_description
string ls_cpt_code
string ls_null
integer li_selected_flag
u_ds_data lds 
integer li_row
integer li_attribute_count

lds = CREATE u_ds_data
lds.set_DataObject("dw_sp_get_hcpcs")

setnull(ls_null)

drug_id = ps_drug_id

// DECLARE lsp_get_hcpcs PROCEDURE FOR dbo.sp_get_hcpcs  
//         @ps_drug_id = :drug_id  ;

//EXECUTE lsp_get_hcpcs;
//if not tf_check() then return -1
//
//lb_loop = true
//DO
//	FETCH lsp_get_hcpcs INTO
//		:ll_hcpcs_sequence,
//		:lr_administer_amount,
//		:ls_administer_unit,
//		:ls_procedure_id,
//		:ls_description,
//		:ls_cpt_code,
//		:li_selected_flag;
//	if not tf_check() then return -1
//	
//	if sqlca.sqlcode = 0 then
//		hcpcs_count++
//		hcpcs[hcpcs_count].hcpcs_sequence = ll_hcpcs_sequence
//		hcpcs[hcpcs_count].administer_amount = lr_administer_amount
//		hcpcs[hcpcs_count].administer_unit = ls_administer_unit
//		hcpcs[hcpcs_count].procedure_id = ls_procedure_id
//		hcpcs[hcpcs_count].description = ls_description
//		hcpcs[hcpcs_count].cpt_code = ls_cpt_code
//	else
//		lb_loop = false
//	end if
//LOOP while lb_loop
//
//CLOSE lsp_get_hcpcs;

hcpcs_count = lds.Retrieve(drug_id)
FOR li_row = 1 TO hcpcs_count
	hcpcs[hcpcs_count].hcpcs_sequence = lds.Object.hcpcs_sequence[li_row]
	hcpcs[hcpcs_count].administer_amount = lds.Object.administer_amount[li_row]
	hcpcs[hcpcs_count].administer_unit = lds.Object.administer_unit[li_row]
	hcpcs[hcpcs_count].procedure_id = lds.Object.hcpcs_procedure_id[li_row]
	hcpcs[hcpcs_count].description = lds.Object.description[li_row]
	hcpcs[hcpcs_count].cpt_code = lds.Object.cpt_code[li_row]
NEXT

set_value(ls_null)

return 1

end function

public function integer set_value (real pr_administer_amount, string ps_administer_unit);integer i
integer li_sts
real lr_amount
integer li_found
string ls_null

setnull(ls_null)
li_found = 0

for i = 1 to hcpcs_count
	li_sts = f_unit_convert(pr_administer_amount, ps_administer_unit, hcpcs[i].administer_unit, lr_amount)
	if li_sts > 0 then
		if lr_amount >= hcpcs[i].administer_amount then li_found = i
	end if
next

if li_found > 0 then
	set_value(hcpcs[li_found].procedure_id, hcpcs[li_found].description)
	return 1
else
	if hcpcs_count > 0 then
		set_value(hcpcs[1].procedure_id, hcpcs[1].description)
	else
		set_value(ls_null)
	end if
	return 0
end if

end function

on u_hcpcs_procedure.create
end on

on u_hcpcs_procedure.destroy
end on

