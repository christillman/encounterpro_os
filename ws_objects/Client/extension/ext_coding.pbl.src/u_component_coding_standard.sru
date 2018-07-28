$PBExportHeader$u_component_coding_standard.sru
forward
global type u_component_coding_standard from u_component_coding
end type
type str_assessment_types from structure within u_component_coding_standard
end type
end forward

type str_assessment_types from structure
	string		assessment_type
	string		bill_flag
end type

global type u_component_coding_standard from u_component_coding
end type
global u_component_coding_standard u_component_coding_standard

type variables

end variables

forward prototypes
public function integer other_encounter (ref string psa_procedure_id[])
protected function integer xx_encounter_procedure (ref string psa_procedure_id[])
public function long well_encounter (ref string psa_procedure_id[])
end prototypes

public function integer other_encounter (ref string psa_procedure_id[]);long ll_visit_level
string ls_procedure_id


//CWW, BEGIN
u_ds_data luo_sp_get_default_encounter_proc
integer li_spdw_count
// DECLARE lsp_get_default_encounter_proc PROCEDURE FOR dbo.sp_get_default_encounter_proc  
//         @ps_encounter_type = :encounter_type,   
//         @ps_new_flag = :new_flag,   
//         @pl_visit_level = :ll_visit_level,   
//         @ps_procedure_id = :ls_procedure_id OUT
//	USING cprdb;
//CWW, END

ll_visit_level = f_current_visit_level(cpr_id, encounter_id)

//CWW, BEGIN
//EXECUTE lsp_get_default_encounter_proc;
//if not cprdb.check() then return -1
//FETCH lsp_get_default_encounter_proc INTO :ls_procedure_id;
//if not cprdb.check() then return -1
//CLOSE lsp_get_default_encounter_proc;
luo_sp_get_default_encounter_proc = CREATE u_ds_data
luo_sp_get_default_encounter_proc.set_dataobject("dw_sp_get_default_encounter_proc", cprdb)
li_spdw_count = luo_sp_get_default_encounter_proc.retrieve(encounter_type, new_flag, ll_visit_level)
if li_spdw_count <= 0 then
	setnull(ls_procedure_id)
else
	ls_procedure_id = luo_sp_get_default_encounter_proc.object.procedure_id[1]
end if

destroy luo_sp_get_default_encounter_proc

//CWW, END

if isnull(ls_procedure_id) then return 0

psa_procedure_id[1] = ls_procedure_id

return 1

end function

protected function integer xx_encounter_procedure (ref string psa_procedure_id[]);
CHOOSE CASE lower(coding_mode)
	CASE "well"
			return well_encounter(psa_procedure_id)
	CASE "sick"
			return other_encounter(psa_procedure_id)
	CASE ELSE
		if is_billed("WELL") then
			return well_encounter(psa_procedure_id)
		else
			return other_encounter(psa_procedure_id)
		end if
END CHOOSE


end function

public function long well_encounter (ref string psa_procedure_id[]);integer li_count
u_ds_data luo_data
integer li_sts
string ls_list_id

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_procedures_by_age_range_list_id")

if new_flag = "Y" then
	if len(new_list_id) > 0 then
		ls_list_id = new_list_id
	else
		ls_list_id = get_attribute("list_id_new")
	end if
	if isnull(ls_list_id) then ls_list_id = "Well Visit New"
else
	if len(new_list_id) > 0 then
		ls_list_id = est_list_id
	else
		ls_list_id = get_attribute("list_id_established")
	end if
	if isnull(ls_list_id) then ls_list_id = "Well Visit Established"
end if

li_count = luo_data.retrieve(cpr_id, ls_list_id)
if li_count > 0 then
	psa_procedure_id[1] = luo_data.object.procedure_id[li_count]
	li_sts = 1
else
	li_sts = 0
end if

DESTROY luo_data

return li_sts

end function

on u_component_coding_standard.create
call super::create
end on

on u_component_coding_standard.destroy
call super::destroy
end on

