$PBExportHeader$u_stage_list.sru
forward
global type u_stage_list from nonvisualobject
end type
end forward

global type u_stage_list from nonvisualobject
end type
global u_stage_list u_stage_list

type variables
integer stage_count
u_str_development_stage stage[]


end variables

forward prototypes
public function integer load_stages ()
public function u_str_development_stage find_stage (string ps_stage_id)
public function u_str_development_item find_item (string ps_stage_id, string ps_item_type, integer pi_item_sequence)
public function integer get_stage_index (string ps_stage_id)
public function integer determine_stage_index (date pd_birthdate, date pd_stage_date)
public subroutine add_stage (string ps_stage_id, string ps_description, real pr_age_months, integer pi_sort_order, string ps_well_assessment_id, string ps_new_procedure_id, string ps_est_procedure_id, string ps_medicaid_normal_procedure_id, string ps_medicaid_abnormal_procedure_id)
end prototypes

public function integer load_stages ();string ls_stage_id
string ls_stage_description
real lr_age_months
integer li_sort_order
string ls_well_assessment_id
string ls_new_procedure_id
string ls_est_procedure_id
string ls_medicaid_normal_procedure_id
string ls_medicaid_abnormal_procedure_id
string ls_item_type
integer li_item_sequence
string ls_item_description  

string ls_last_stage_id
boolean lb_loop

 DECLARE lc_load_stages CURSOR FOR  
  SELECT c_Development_Stage.stage_id,   
         c_Development_Stage.description,   
         c_Development_Stage.age_months,   
         c_Development_Stage.sort_order,
			c_Development_Stage.well_assessment_id,  
			c_Development_Stage.new_procedure_id,
			c_Development_Stage.est_procedure_id,
			c_Development_Stage.medicaid_normal_procedure_id,
			c_Development_Stage.medicaid_abnormal_procedure_id,
         c_Development_Item.item_type,   
         c_Development_Item.item_sequence,   
         c_Development_Item.description
    FROM c_Development_Stage,   
         c_Development_Item  
   WHERE ( c_Development_Stage.stage_id = c_Development_Item.stage_id ) and  
         ( ( c_Development_Item.item_type = 'DEVELOP' ) )   
ORDER BY c_Development_Stage.sort_order ASC,   
         c_Development_Stage.stage_id ASC,   
         c_Development_Item.item_type ASC,   
         c_Development_Item.item_sequence ASC  ;


log.log(this, "load_stages", "Loading development stages...", 1)

tf_begin_transaction(this, "")

OPEN lc_load_stages;
if not tf_check() then return -1

lb_loop = true
ls_last_stage_id = ""

DO
	FETCH lc_load_stages INTO
		:ls_stage_id,
		:ls_stage_description,
		:lr_age_months,
		:li_sort_order,
		:ls_well_assessment_id,
		:ls_new_procedure_id,
		:ls_est_procedure_id,
		:ls_medicaid_normal_procedure_id,
		:ls_medicaid_abnormal_procedure_id,
		:ls_item_type,
		:li_item_sequence,
		:ls_item_description;
	if not tf_check() then return -1


	if sqlca.sqlcode = 0 and sqlca.sqlnrows > 0 then
		if ls_stage_id <> ls_last_stage_id then
			ls_last_stage_id = ls_stage_id
			add_stage(	ls_stage_id, &
							ls_stage_description, &
							lr_age_months, &
							li_sort_order, &
							ls_well_assessment_id, &
							ls_new_procedure_id, &
							ls_est_procedure_id, &
							ls_medicaid_normal_procedure_id, &
							ls_medicaid_abnormal_procedure_id &
						)
		end if

		stage[stage_count].add_item(ls_item_type, li_item_sequence, ls_item_description)

	else
		lb_loop = false
	end if
LOOP WHILE lb_loop

CLOSE lc_load_stages;

tf_commit()

log.log(this, "load_stages", "Stages loaded", 1)

return 1
end function

public function u_str_development_stage find_stage (string ps_stage_id);integer i
u_str_development_stage luo_null

for i = 1 to stage_count
	if stage[i].stage_id = ps_stage_id then return stage[i]
next

setnull(luo_null)
return luo_null


end function

public function u_str_development_item find_item (string ps_stage_id, string ps_item_type, integer pi_item_sequence);integer i, j
u_str_development_item luo_null

for i = 1 to stage_count
	if stage[i].stage_id = ps_stage_id then
		for j = 1 to stage[i].item_count
			if stage[i].item[j].item_type = ps_item_type &
					and stage[i].item[j].item_sequence = pi_item_sequence &
					then return stage[i].item[j]
		next
		exit
	end if
next

setnull(luo_null)
return luo_null


end function

public function integer get_stage_index (string ps_stage_id);integer i

for i = 1 to stage_count
	if stage[i].stage_id = ps_stage_id then return i
next

return 0


end function

public function integer determine_stage_index (date pd_birthdate, date pd_stage_date);integer i, li_stage_index
date ld_temp, ld_highest_date

ld_highest_date = date("1/1/1776")
li_stage_index = 1

for i = 1 to stage_count
	ld_temp = f_add_months(pd_birthdate, stage[i].age_months)
	if ld_temp <= pd_stage_date &
	 and ld_temp > ld_highest_date then
		ld_highest_date = ld_temp
		li_stage_index = i
	end if
next

return li_stage_index

end function

public subroutine add_stage (string ps_stage_id, string ps_description, real pr_age_months, integer pi_sort_order, string ps_well_assessment_id, string ps_new_procedure_id, string ps_est_procedure_id, string ps_medicaid_normal_procedure_id, string ps_medicaid_abnormal_procedure_id);stage_count = stage_count + 1
stage[stage_count] = CREATE u_str_development_stage

stage[stage_count].stage_id = ps_stage_id
stage[stage_count].description = ps_description
stage[stage_count].age_months = pr_age_months
stage[stage_count].sort_order = pi_sort_order
stage[stage_count].well_assessment_id = ps_well_assessment_id
stage[stage_count].new_procedure_id = ps_new_procedure_id
stage[stage_count].est_procedure_id = ps_est_procedure_id
stage[stage_count].medicaid_normal_procedure_id = ps_medicaid_normal_procedure_id
stage[stage_count].medicaid_abnormal_procedure_id = ps_medicaid_abnormal_procedure_id

end subroutine

on u_stage_list.create
TriggerEvent( this, "constructor" )
end on

on u_stage_list.destroy
TriggerEvent( this, "destructor" )
end on

