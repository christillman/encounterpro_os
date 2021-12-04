$PBExportHeader$u_tab_hm_class.sru
forward
global type u_tab_hm_class from u_tab_manager
end type
end forward

global type u_tab_hm_class from u_tab_manager
integer width = 3369
integer height = 1580
long backcolor = COLOR_BACKGROUND
boolean boldselectedtext = true
boolean createondemand = false
tabposition tabposition = tabsonbottom!
end type
global u_tab_hm_class u_tab_hm_class

type variables
str_hm_class_definition hm_class
long initial_tab = 1
str_hm_context last_hm_context

end variables

forward prototypes
public function integer save_changes ()
public function integer initialize (str_hm_context pstr_hm_context)
public function long criteria_index (string ps_property)
public function integer set_criterion (string ps_property, string ps_operation, string ps_value)
public function integer update_class ()
public function integer add_metric (string ps_title, string ps_description, string ps_observation_id, integer pi_result_sequence, long pl_interval, string ps_interval_unit)
end prototypes

public function integer save_changes ();integer i
u_tabpage_hm_class_base luo_tab
integer li_sts

page_count = upperbound(control)

//for i = 1 to page_count
//	pages[i] = control[i]
//	luo_tab = pages[i]
//	li_sts = luo_tab.save_changes()
//	if li_sts < 0 then return -1
//next

return 1

end function

public function integer initialize (str_hm_context pstr_hm_context);last_hm_context = pstr_hm_context

return 1

end function

public function long criteria_index (string ps_property);long ll_index
boolean lb_found


lb_found = false
for ll_index = 1 to hm_class.criteria_count
	if lower(hm_class.criteria[ll_index].property) = lower(ps_property) then
		lb_found = true
		exit
	end if
next

if not lb_found then return 0

return ll_index

end function

public function integer set_criterion (string ps_property, string ps_operation, string ps_value);long ll_index
long ll_age_range_id

ll_index = criteria_index(ps_property)
if ll_index > 0 then
	hm_class.criteria[ll_index].operation = ps_operation
	hm_class.criteria[ll_index].value = ps_value
else
	hm_class.criteria_count += 1
	ll_index = hm_class.criteria_count
	hm_class.criteria[ll_index].property = ps_property
	hm_class.criteria[ll_index].operation = ps_operation
	hm_class.criteria[ll_index].value = ps_value
end if


// We don't have the criteria in a separate table yet so just use a CASE statement for now
CHOOSE CASE lower(hm_class.criteria[ll_index].property)
	CASE "sex"
		UPDATE c_Maintenance_Patient_Class
		SET sex = :ps_value
		WHERE maintenance_rule_id = :hm_class.maintenance_rule_id;
		if not tf_check() then return -1
	CASE "race"
		UPDATE c_Maintenance_Patient_Class
		SET race = :ps_value
		WHERE maintenance_rule_id = :hm_class.maintenance_rule_id;
		if not tf_check() then return -1
	CASE "age_range"
		ll_age_range_id = long(ps_value)
		UPDATE c_Maintenance_Patient_Class
		SET age_range_id = :ll_age_range_id
		WHERE maintenance_rule_id = :hm_class.maintenance_rule_id;
		if not tf_check() then return -1
END CHOOSE


return 1

end function

public function integer update_class ();

UPDATE c
SET 	compliance_ok_percent = :hm_class.compliance_ok_percent,
		compliance_warning_percent = :hm_class.compliance_warning_percent,
		measured_ok_percent = :hm_class.measured_ok_percent,
		measured_warning_percent = :hm_class.measured_warning_percent,
		controlled_ok_percent = :hm_class.controlled_ok_percent,
		controlled_warning_percent = :hm_class.controlled_warning_percent
FROM c_Maintenance_Patient_Class c
WHERE maintenance_rule_id = :hm_class.maintenance_rule_id;
if not tf_check() then return -1

return 1

end function

public function integer add_metric (string ps_title, string ps_description, string ps_observation_id, integer pi_result_sequence, long pl_interval, string ps_interval_unit);long ll_index
long i

// See if we already have it
ll_index = 0
for i = 1 to hm_class.metric_count
	if lower(hm_class.metric[i].observation_id) = lower(ps_observation_id) and hm_class.metric[i].result_sequence = pi_result_sequence then
		ll_index = i
		exit
	end if
next

if ll_index = 0 then
	hm_class.metric_count += 1
	ll_index = hm_class.metric_count
end if

hm_class.metric[ll_index].observation_id = ps_observation_id
hm_class.metric[ll_index].result_sequence = pi_result_sequence
hm_class.metric[ll_index].title = ps_title
hm_class.metric[ll_index].description = ps_description
hm_class.metric[ll_index].interval = pl_interval
hm_class.metric[ll_index].interval_unit = ps_interval_unit

sqlca.jmj_hm_set_class_metric(hm_class.maintenance_rule_id, ps_observation_id, pi_result_sequence, ps_title, ps_description, pl_interval, ps_interval_unit, current_scribe.user_id)
if not tf_check() then return -1

return 1

end function

