$PBExportHeader$u_tabpage_allergy_abnormal_results.sru
forward
global type u_tabpage_allergy_abnormal_results from u_tabpage
end type
type dw_results from u_dw_pick_list within u_tabpage_allergy_abnormal_results
end type
end forward

global type u_tabpage_allergy_abnormal_results from u_tabpage
integer width = 1001
long backcolor = 12632256
long tabbackcolor = 12632256
dw_results dw_results
end type
global u_tabpage_allergy_abnormal_results u_tabpage_allergy_abnormal_results

type variables
u_component_treatment treatment

string tests_treatment_type = "AllergyTest"

end variables

forward prototypes
public function integer initialize ()
public subroutine refresh ()
end prototypes

public function integer initialize ();dw_results.width = width
dw_results.height = height


if isnull(parent_tab.service) then
	log.log(this, "initialize()", "No service context", 4)
	return -1
end if

if isnull(parent_tab.service.treatment) then
	log.log(this, "initialize()", "No treatment context", 4)
	return -1
end if

treatment = parent_tab.service.treatment


return 1

end function

public subroutine refresh ();long ll_count
string ls_temp
string ls_top_20_code
datetime ldt_from_date
long i
string ls_result
string ls_result_value
string ls_result_unit
string ls_result_amount_flag
string ls_print_result_flag
string ls_print_result_separator
string ls_abnormal_flag
string ls_unit_preference
string ls_display_mask
string ls_pretty_result
string ls_observation_description
string ls_location
string ls_location_description

setnull(ldt_from_date)

if treatment.problem_count < 1 then
	dw_results.dataobject = "dw_sp_abnormal_results_small"
	dw_results.settransobject(sqlca)
	ll_count = dw_results.retrieve(parent_tab.service.cpr_id, tests_treatment_type, ldt_from_date)
else
	dw_results.dataobject = "dw_sp_abnormal_results_for_assmnt_small"
	dw_results.settransobject(sqlca)
	ll_count = dw_results.retrieve(parent_tab.service.cpr_id, treatment.problem_id())
end if

dw_results.object.t_star.x = width - 150
dw_results.object.result_description.width = width - 155

for i = 1 to ll_count
	ls_result = dw_results.object.result[i]
	ls_location = dw_results.object.location[i]
	ls_location_description = dw_results.object.location_description[i]
	ls_result_value = dw_results.object.result_value[i]
	ls_result_unit = dw_results.object.result_unit[i]
	ls_result_amount_flag = dw_results.object.result_amount_flag[i]
	ls_print_result_flag = dw_results.object.print_result_flag[i]
	ls_print_result_separator = dw_results.object.print_result_separator[i]
	ls_abnormal_flag = dw_results.object.abnormal_flag[i]
	ls_unit_preference = dw_results.object.unit_preference[i]
	ls_display_mask = dw_results.object.display_mask[i]
	
	ls_observation_description = dw_results.object.observation_description[i]
	
	ls_pretty_result = f_pretty_result( ls_result, &
											ls_location, &
											ls_location_description, &
											ls_result_value, &
											ls_result_unit, &
											ls_result_amount_flag, &
											ls_print_result_flag, &
											ls_print_result_separator, &
											ls_abnormal_flag, &
											ls_unit_preference, &
											ls_display_mask, &
											false, &
											true, &
											true )
	
	if len(ls_pretty_result) > 0 then
		ls_observation_description += ":  " + ls_pretty_result
	end if
	
	dw_results.object.result_description[i] = ls_observation_description
next


return


end subroutine

on u_tabpage_allergy_abnormal_results.create
int iCurrent
call super::create
this.dw_results=create dw_results
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_results
end on

on u_tabpage_allergy_abnormal_results.destroy
call super::destroy
destroy(this.dw_results)
end on

type dw_results from u_dw_pick_list within u_tabpage_allergy_abnormal_results
integer width = 905
integer taborder = 10
string dataobject = "dw_sp_abnormal_results_for_assmnt_small"
end type

