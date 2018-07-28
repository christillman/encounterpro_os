$PBExportHeader$u_dw_observations_pick_results.sru
forward
global type u_dw_observations_pick_results from u_dw_pick_list
end type
end forward

global type u_dw_observations_pick_results from u_dw_pick_list
integer width = 2130
integer height = 1220
string dataobject = "dw_observations_pick_results"
end type
global u_dw_observations_pick_results u_dw_observations_pick_results

type variables
u_component_service service

string observation_id
u_ds_data results
string result_type

long root_observation_sequence

string location = "NA"

end variables

forward prototypes
public function integer load_observations ()
public function integer initialize (u_component_service puo_service)
public function integer initialize (u_component_service puo_service, string ps_result_type)
public function integer load_patient_results ()
private function integer save_result_patient (string ps_observation_id, ref long pl_observation_sequence, string ps_location, integer pi_result_sequence, long pl_result_row, datetime pdt_result_date_time)
public function integer save_result_treatment (long pl_row)
public function integer save_results ()
public function integer load_treatment_results ()
public function integer load_treatment_row_column (long pl_row, integer pi_column)
public subroutine treatment_row_clicked (long pl_row, integer pi_column)
public subroutine patient_row_clicked (long pl_row, integer pi_column)
public function integer load_treatment_row (long pl_row)
public function integer set_all_rows (integer pi_column)
end prototypes

public function integer load_observations ();str_observation_tree lstr_tree
str_observation_results lstr_results
string ls_child_observation_id
long ll_branch_id
string ls_description
string ls_child_composite_flag
string ls_perform_location_domain
long i, j
long ll_row
integer li_result_sequence
string ls_result
integer li_result_count
string ls_exclusive_flag

reset()

ll_row = 0

lstr_tree = datalist.observation_tree(observation_id)
for i = 1 to lstr_tree.branch_count
	ls_child_observation_id = lstr_tree.branch[i].child_observation_id
	ll_branch_id = lstr_tree.branch[i].branch_id
	ls_description = datalist.observation_description(ls_child_observation_id)
	ls_perform_location_domain = datalist.observation_perform_location_domain(ls_child_observation_id)
	ls_child_composite_flag = datalist.observation_composite_flag(ls_child_observation_id)
	ls_exclusive_flag = datalist.observation_exclusive_flag(ls_child_observation_id)
	
	// Skip if composite or location_domain isn't NA
	if ls_child_composite_flag = "Y" or ls_perform_location_domain <> "NA" then continue
	
	ll_row = insertrow(0)
	object.observation_description[ll_row] = ls_description
	object.observation_id[ll_row] = ls_child_observation_id
	object.child_ordinal[ll_row] = lstr_tree.branch[i].child_ordinal
	object.observation_tag[ll_row] = lstr_tree.branch[i].observation_tag
	object.exclusive_flag[ll_row] = ls_exclusive_flag
	
	lstr_results = datalist.observation_results(ls_child_observation_id)
	
	// Then fill the left side
	li_result_count = 0
	for j = 1 to lstr_results.result_count
		// Skip if numeric
		if lstr_results.result[j].result_amount_flag = "Y" then continue
		
		// Skip if wrong result_type
		if result_type = "PERFORM" then
			if upper(lstr_results.result[j].result_type) = "COLLECT" then continue
		else
			if lstr_results.result[j].result_type <> result_type then continue
		end if
		
		li_result_count += 1
		ls_result = lstr_results.result[j].result
		li_result_sequence = lstr_results.result[j].result_sequence

		CHOOSE CASE li_result_count
			CASE 1
				object.result1[ll_row] = ls_result
				object.result_sequence1[ll_row] = li_result_sequence
				object.result1_abnormal_flag[ll_row] = lstr_results.result[j].abnormal_flag
				object.result_definition_1[ll_row] = lstr_results.result[j].result
				object.result_type_1[ll_row] = lstr_results.result[j].result_type
			CASE 2
				object.result2[ll_row] = ls_result
				object.result_sequence2[ll_row] = li_result_sequence
				object.result2_abnormal_flag[ll_row] = lstr_results.result[j].abnormal_flag
				object.result_definition_2[ll_row] = lstr_results.result[j].result
				object.result_type_2[ll_row] = lstr_results.result[j].result_type
			CASE 3
				object.result3[ll_row] = ls_result
				object.result_sequence3[ll_row] = li_result_sequence
				object.result3_abnormal_flag[ll_row] = lstr_results.result[j].abnormal_flag
				object.result_definition_3[ll_row] = lstr_results.result[j].result
				object.result_type_3[ll_row] = lstr_results.result[j].result_type
			CASE 4
				object.result4[ll_row] = ls_result
				object.result_sequence4[ll_row] = li_result_sequence
				object.result4_abnormal_flag[ll_row] = lstr_results.result[j].abnormal_flag
				object.result_definition_4[ll_row] = lstr_results.result[j].result
				object.result_type_4[ll_row] = lstr_results.result[j].result_type
		END CHOOSE

	next
next		

return ll_row


end function

public function integer initialize (u_component_service puo_service);return initialize(puo_service, "PERFORM")

end function

public function integer initialize (u_component_service puo_service, string ps_result_type);integer li_sts
long ll_count

service = puo_service

observation_id = service.root_observation_id()
if isnull(observation_id) then
	log.log(this, "initialize()", "No root observation_id", 4)
	return -1
end if

root_observation_sequence = service.get_root_observation()
if not isnull(service.treatment) and isnull(root_observation_sequence) then
	log.log(this, "initialize()", "No root observation_sequence", 4)
	return -1
end if

result_type = ps_result_type

li_sts = load_observations()
if li_sts < 0 then return li_sts

if isnull(service.treatment) then
	li_sts = load_patient_results()
	if li_sts < 0 then return li_sts
else
	li_sts = load_treatment_results()
	if li_sts < 0 then return li_sts
end if

return 1


end function

public function integer load_patient_results ();long ll_row
long ll_rows
long i
string ls_find
string ls_base_find
long ll_result_rows
string ls_observation_id
integer li_result_sequence1
integer li_result_sequence2
integer li_result_sequence3
integer li_result_sequence4

results = CREATE u_ds_data
results.set_dataobject("dw_sp_obstree_patient")
ll_result_rows = results.retrieve(current_patient.cpr_id, observation_id)
if ll_result_rows < 0 then return -1

ll_rows = rowcount()
ll_result_rows = results.rowcount()

for i = 1 to ll_rows
	ls_observation_id = object.observation_id[i]
	li_result_sequence1 = object.result_sequence1[i]
	li_result_sequence2 = object.result_sequence2[i]
	li_result_sequence3 = object.result_sequence3[i]
	li_result_sequence4 = object.result_sequence4[i]
	ls_base_find = "observation_id='" + ls_observation_id + "'"
	ls_base_find += " and location='NA'"
	ls_base_find += " and record_type='Result'"
	
	if not isnull(li_result_sequence1) then
		ls_find = ls_base_find + " and result_sequence=" + string(li_result_sequence1)
		ll_row = results.find(ls_find, 1, ll_result_rows)
		if ll_row > 0 then
			object.result_date_time1[i] = results.object.result_date_time[ll_row]
			object.result_row1[i] = ll_row
			object.result_selected[i] = 1
		end if
	end if
		
	if not isnull(li_result_sequence2) then
		ls_find = ls_base_find + " and result_sequence=" + string(li_result_sequence2)
		ll_row = results.find(ls_find, 1, ll_result_rows)
		if ll_row > 0 then
			object.result_date_time2[i] = results.object.result_date_time[ll_row]
			object.result_row2[i] = ll_row
			object.result_selected[i] = 1
		end if
	end if
		
	if not isnull(li_result_sequence3) then
		ls_find = ls_base_find + " and result_sequence=" + string(li_result_sequence3)
		ll_row = results.find(ls_find, 1, ll_result_rows)
		if ll_row > 0 then
			object.result_date_time3[i] = results.object.result_date_time[ll_row]
			object.result_row3[i] = ll_row
			object.result_selected[i] = 1
		end if
	end if
		
	if not isnull(li_result_sequence4) then
		ls_find = ls_base_find + " and result_sequence=" + string(li_result_sequence4)
		ll_row = results.find(ls_find, 1, ll_result_rows)
		if ll_row > 0 then
			object.result_date_time4[i] = results.object.result_date_time[ll_row]
			object.result_row4[i] = ll_row
			object.result_selected[i] = 1
		end if
	end if
next

Return 1

end function

private function integer save_result_patient (string ps_observation_id, ref long pl_observation_sequence, string ps_location, integer pi_result_sequence, long pl_result_row, datetime pdt_result_date_time);integer li_sts
string ls_observation_tag


if isnull(pl_result_row) and not isnull(pdt_result_date_time) then
	// If we didn't have a result but we do now...
	if isnull(pl_observation_sequence) then
		pl_observation_sequence = current_patient.add_observation(ps_observation_id)
		if pl_observation_sequence < 0 then return -1
	end if
	li_sts = current_patient.add_observation_result(pl_observation_sequence, ps_location, pi_result_sequence, pdt_result_date_time)
	if li_sts < 0 then return -1
elseif isnull(pdt_result_date_time) and not isnull(pl_result_row) then
	// If we had a result but we don't now...
	pl_observation_sequence = results.object.observation_sequence[pl_result_row]
	li_sts = current_patient.add_observation_result(pl_observation_sequence, ps_location, pi_result_sequence, pdt_result_date_time)
	if li_sts < 0 then return -1
end if
	

return 1

end function

public function integer save_result_treatment (long pl_row);integer li_sts
string ls_observation_id
string ls_observation_tag
integer li_child_ordinal
integer li_result_sequence1
integer li_result_sequence2
integer li_result_sequence3
integer li_result_sequence4
long ll_result_row1
long ll_result_row2
long ll_result_row3
long ll_result_row4
datetime ldt_result_date_time1
datetime ldt_result_date_time2
datetime ldt_result_date_time3
datetime ldt_result_date_time4
string ls_location
long ll_observation_sequence
long ll_stage
datetime ldt_result_date_time

ls_location = "NA"
setnull(ll_stage)

ll_observation_sequence = object.observation_sequence[pl_row]
ls_observation_id = object.observation_id[pl_row]
ls_observation_tag = object.observation_tag[pl_row]
li_child_ordinal = object.child_ordinal[pl_row]
li_result_sequence1 = object.result_sequence1[pl_row]
li_result_sequence2 = object.result_sequence2[pl_row]
li_result_sequence3 = object.result_sequence3[pl_row]
li_result_sequence4 = object.result_sequence4[pl_row]
ll_result_row1 = object.result_row1[pl_row]
ll_result_row2 = object.result_row2[pl_row]
ll_result_row3 = object.result_row3[pl_row]
ll_result_row4 = object.result_row4[pl_row]
ldt_result_date_time1 = object.result_date_time1[pl_row]
ldt_result_date_time2 = object.result_date_time2[pl_row]
ldt_result_date_time3 = object.result_date_time3[pl_row]
ldt_result_date_time4 = object.result_date_time4[pl_row]

// Make sure we have an observation_sequence for this row
if isnull(ll_observation_sequence) then
	ll_observation_sequence = service.treatment.add_observation(root_observation_sequence, &
																					ls_observation_id, &
																					li_child_ordinal, &
																					ls_observation_tag, &
																					ll_stage, &
																					true)
	if isnull(ll_observation_sequence) then
		log.log(this, "save_result_treatment()", "Error adding observation (" + ls_observation_id + ")", 4)
		return -1
	end if
end if


if not isnull(li_result_sequence1) then
	if isnull(ll_result_row1) and not isnull(ldt_result_date_time1) then
		// If we didn't have a result but we do now...
		li_sts = service.treatment.add_result(ll_observation_sequence, li_result_sequence1, ls_location, ldt_result_date_time1)
		if li_sts < 0 then return -1
	elseif isnull(ldt_result_date_time1) and not isnull(ll_result_row1) then
		// If we had a result but we don't now...
		li_sts = service.treatment.remove_result(ll_observation_sequence, li_result_sequence1, ls_location)
		if li_sts < 0 then return -1
	end if
end if
	
if not isnull(li_result_sequence2) then
	if isnull(ll_result_row2) and not isnull(ldt_result_date_time2) then
		// If we didn't have a result but we do now...
		li_sts = service.treatment.add_result(ll_observation_sequence, li_result_sequence2, ls_location, ldt_result_date_time2)
		if li_sts < 0 then return -1
	elseif isnull(ldt_result_date_time2) and not isnull(ll_result_row2) then
		// If we had a result but we don't now...
		li_sts = service.treatment.remove_result(ll_observation_sequence, li_result_sequence2, ls_location)
		if li_sts < 0 then return -1
	end if
end if
	
if not isnull(li_result_sequence3) then
	if isnull(ll_result_row3) and not isnull(ldt_result_date_time3) then
		// If we didn't have a result but we do now...
		li_sts = service.treatment.add_result(ll_observation_sequence, li_result_sequence3, ls_location, ldt_result_date_time3)
		if li_sts < 0 then return -1
	elseif isnull(ldt_result_date_time3) and not isnull(ll_result_row3) then
		// If we had a result but we don't now...
		li_sts = service.treatment.remove_result(ll_observation_sequence, li_result_sequence3, ls_location)
		if li_sts < 0 then return -1
	end if
end if
	
if not isnull(li_result_sequence4) then
	if isnull(ll_result_row4) and not isnull(ldt_result_date_time4) then
		// If we didn't have a result but we do now...
		li_sts = service.treatment.add_result(ll_observation_sequence, li_result_sequence4, ls_location, ldt_result_date_time4)
		if li_sts < 0 then return -1
	elseif isnull(ldt_result_date_time4) and not isnull(ll_result_row4) then
		// If we had a result but we don't now...
		li_sts = service.treatment.remove_result(ll_observation_sequence, li_result_sequence4, ls_location)
		if li_sts < 0 then return -1
	end if
end if
	
	

return 1

end function

public function integer save_results ();long ll_rows
long i
string ls_observation_id
integer li_result_sequence
long ll_result_row
datetime ldt_result_date_time
string ls_location
long ll_observation_sequence
integer li_sts

ls_location = "NA"

ll_rows = rowcount()

// If this is a treatment screen then the results have already been saved
if not isnull(service.treatment) then return 1
for i = 1 to ll_rows
	ls_observation_id = object.observation_id[i]
	ll_observation_sequence = object.observation_sequence[i]
	
	li_result_sequence = object.result_sequence1[i]
	ll_result_row = object.result_row1[i]
	ldt_result_date_time = object.result_date_time1[i]
	save_result_patient(ls_observation_id, ll_observation_sequence, ls_location, li_result_sequence, ll_result_row, ldt_result_date_time)
	
	li_result_sequence = object.result_sequence2[i]
	ll_result_row = object.result_row2[i]
	ldt_result_date_time = object.result_date_time2[i]
	save_result_patient(ls_observation_id, ll_observation_sequence, ls_location, li_result_sequence, ll_result_row, ldt_result_date_time)
	
	li_result_sequence = object.result_sequence3[i]
	ll_result_row = object.result_row3[i]
	ldt_result_date_time = object.result_date_time3[i]
	save_result_patient(ls_observation_id, ll_observation_sequence, ls_location, li_result_sequence, ll_result_row, ldt_result_date_time)
	
	li_result_sequence = object.result_sequence4[i]
	ll_result_row = object.result_row4[i]
	ldt_result_date_time = object.result_date_time4[i]
	save_result_patient(ls_observation_id, ll_observation_sequence, ls_location, li_result_sequence, ll_result_row, ldt_result_date_time)
next


return 1

end function

public function integer load_treatment_results ();integer li_sts
long ll_rows
long i
string ls_observation_id
string ls_observation_tag
integer li_child_ordinal
long ll_observation_sequence
long ll_stage

setnull(ll_stage)

// First refresh the treatment object
li_sts = service.treatment.load_observations()

ll_rows = rowcount()

for i = 1 to ll_rows
	ls_observation_id = object.observation_id[i]
	ls_observation_tag = object.observation_tag[i]
	li_child_ordinal = object.child_ordinal[i]
	
	ll_observation_sequence = service.treatment.find_observation( root_observation_sequence, &
																						ls_observation_id, &
																						li_child_ordinal, &
																						ls_observation_tag, &
																						ll_stage)

	object.observation_sequence[i] = ll_observation_sequence

	li_sts = load_treatment_row(i)
	if li_sts < 0 then return -1
next

Return 1

end function

public function integer load_treatment_row_column (long pl_row, integer pi_column);long ll_row
long ll_rows
string ls_find
long ll_result_rows
string ls_observation_id
string ls_observation_tag
integer li_child_ordinal
integer li_result_sequence1
integer li_result_sequence2
integer li_result_sequence3
integer li_result_sequence4
long ll_observation_sequence
long ll_stage
datetime ldt_result_date_time
string ls_result_value
string ls_result_unit
string ls_abnormal_flag
string ls_abnormal_nature
integer li_sts
str_observation_comment lstr_comment
string ls_comment_title
string ls_result_type
datetime ldt_null

setnull(ldt_null)
setnull(ll_stage)

// If we have no observation sequence then we can't have any results
ll_observation_sequence = object.observation_sequence[pl_row]
if isnull(ll_observation_sequence) then return 0

ls_observation_id = object.observation_id[pl_row]
ls_observation_tag = object.observation_tag[pl_row]
li_child_ordinal = object.child_ordinal[pl_row]

li_result_sequence1 = object.result_sequence1[pl_row]
li_result_sequence2 = object.result_sequence2[pl_row]
li_result_sequence3 = object.result_sequence3[pl_row]
li_result_sequence4 = object.result_sequence4[pl_row]

if not isnull(li_result_sequence1) then
	ls_result_type = object.result_type_1[pl_row]
	CHOOSE CASE upper(ls_result_type)
		CASE "PERFORM"
			li_sts = service.treatment.get_result(ll_observation_sequence, &
																li_result_sequence1, &
																location, &
																ldt_result_date_time, &
																ls_result_value, &
																ls_result_unit, &
																ls_abnormal_flag, &
																ls_abnormal_nature)
			// if the result_date_time is null then treat it like the result doesn't exist
			if li_sts > 0 and not isnull(ldt_result_date_time) then
				object.result_date_time1[pl_row] = ldt_result_date_time
			else
				object.result_date_time1[pl_row] = ldt_null
				object.result1[pl_row] = object.result_definition_1[pl_row]
			end if
		CASE "ATTACHMENT", "COMMENT"
			ls_comment_title = object.result_definition_1[pl_row]
			li_sts = service.treatment.get_comment(ll_observation_sequence, &
																ls_comment_title, &
																lstr_comment)
			if li_sts > 0 then
				object.result_date_time1[pl_row] = lstr_comment.comment_date_time
				object.result1[pl_row] = lstr_comment.comment
			else
				object.result_date_time1[pl_row] = ldt_null
				object.result1[pl_row] = object.result_definition_1[pl_row]
			end if
	END CHOOSE
end if
	
if not isnull(li_result_sequence2) then
	ls_result_type = object.result_type_2[pl_row]
	CHOOSE CASE upper(ls_result_type)
		CASE "PERFORM"
			li_sts = service.treatment.get_result(ll_observation_sequence, &
																li_result_sequence2, &
																"NA", &
																ldt_result_date_time, &
																ls_result_value, &
																ls_result_unit, &
																ls_abnormal_flag, &
																ls_abnormal_nature)
			// if the result_date_time is null then treat it like the result doesn't exist
			if li_sts > 0 and not isnull(ldt_result_date_time) then
				object.result_date_time2[pl_row] = ldt_result_date_time
			else
				object.result_date_time2[pl_row] = ldt_null
				object.result2[pl_row] = object.result_definition_2[pl_row]
			end if
		CASE "ATTACHMENT", "COMMENT"
			ls_comment_title = object.result_definition_2[pl_row]
			li_sts = service.treatment.get_comment(ll_observation_sequence, &
																ls_comment_title, &
																lstr_comment)
			if li_sts > 0 then
				object.result_date_time2[pl_row] = lstr_comment.comment_date_time
				object.result2[pl_row] = lstr_comment.comment
			else
				object.result_date_time2[pl_row] = ldt_null
				object.result2[pl_row] = object.result_definition_2[pl_row]
			end if
	END CHOOSE
end if
	
if not isnull(li_result_sequence3) then
	ls_result_type = object.result_type_3[pl_row]
	CHOOSE CASE upper(ls_result_type)
		CASE "PERFORM"
			li_sts = service.treatment.get_result(ll_observation_sequence, &
																li_result_sequence3, &
																"NA", &
																ldt_result_date_time, &
																ls_result_value, &
																ls_result_unit, &
																ls_abnormal_flag, &
																ls_abnormal_nature)
			// if the result_date_time is null then treat it like the result doesn't exist
			if li_sts > 0 and not isnull(ldt_result_date_time) then
				object.result_date_time3[pl_row] = ldt_result_date_time
			else
				object.result_date_time3[pl_row] = ldt_null
				object.result3[pl_row] = object.result_definition_3[pl_row]
			end if
		CASE "ATTACHMENT", "COMMENT"
			ls_comment_title = object.result_definition_3[pl_row]
			li_sts = service.treatment.get_comment(ll_observation_sequence, &
																ls_comment_title, &
																lstr_comment)
			if li_sts > 0 then
				object.result_date_time3[pl_row] = lstr_comment.comment_date_time
				object.result3[pl_row] = lstr_comment.comment
			else
				object.result_date_time3[pl_row] = ldt_null
				object.result3[pl_row] = object.result_definition_3[pl_row]
			end if
	END CHOOSE
end if
	
if not isnull(li_result_sequence4) then
	ls_result_type = object.result_type_4[pl_row]
	CHOOSE CASE upper(ls_result_type)
		CASE "PERFORM"
			li_sts = service.treatment.get_result(ll_observation_sequence, &
																li_result_sequence4, &
																"NA", &
																ldt_result_date_time, &
																ls_result_value, &
																ls_result_unit, &
																ls_abnormal_flag, &
																ls_abnormal_nature)
			// if the result_date_time is null then treat it like the result doesn't exist
			if li_sts > 0 and not isnull(ldt_result_date_time) then
				object.result_date_time4[pl_row] = ldt_result_date_time
			else
				object.result_date_time4[pl_row] = ldt_null
				object.result4[pl_row] = object.result_definition_4[pl_row]
			end if
		CASE "ATTACHMENT", "COMMENT"
			ls_comment_title = object.result_definition_4[pl_row]
			li_sts = service.treatment.get_comment(ll_observation_sequence, &
																ls_comment_title, &
																lstr_comment)
			if li_sts > 0 then
				object.result_date_time4[pl_row] = lstr_comment.comment_date_time
				object.result4[pl_row] = lstr_comment.comment
			else
				object.result_date_time4[pl_row] = ldt_null
				object.result4[pl_row] = object.result_definition_4[pl_row]
			end if
	END CHOOSE
end if

Return 1

end function

public subroutine treatment_row_clicked (long pl_row, integer pi_column);string ls_exclusive_flag
datetime ldt_null
datetime ldt_result_date_time1
datetime ldt_result_date_time2
datetime ldt_result_date_time3
datetime ldt_result_date_time4
long ll_observation_sequence
integer li_result_sequence1
integer li_result_sequence2
integer li_result_sequence3
integer li_result_sequence4
string ls_result_type_1
string ls_result_type_2
string ls_result_type_3
string ls_result_type_4
integer li_sts
string ls_observation_id
long ll_stage
string ls_observation_tag
integer li_child_ordinal
string ls_clicked_result_type

setnull(ldt_null)

ll_observation_sequence = object.observation_sequence[pl_row]

if isnull(ll_observation_sequence) then
	setnull(ll_stage)
	ll_observation_sequence = object.observation_sequence[pl_row]
	ls_observation_id = object.observation_id[pl_row]
	ls_observation_tag = object.observation_tag[pl_row]
	li_child_ordinal = object.child_ordinal[pl_row]
	
	ll_observation_sequence = service.treatment.add_observation(root_observation_sequence, &
																					ls_observation_id, &
																					li_child_ordinal, &
																					ls_observation_tag, &
																					ll_stage, &
																					true)
	if isnull(ll_observation_sequence) then
		log.log(this, "treatment_row_clicked", "Error adding observation (" + ls_observation_id + ")", 4)
		return
	else
		object.observation_sequence[pl_row] = ll_observation_sequence
	end if
end if

ls_exclusive_flag = object.exclusive_flag[pl_row]
li_result_sequence1 = object.result_sequence1[pl_row]
li_result_sequence2 = object.result_sequence2[pl_row]
li_result_sequence3 = object.result_sequence3[pl_row]
li_result_sequence4 = object.result_sequence4[pl_row]

ls_result_type_1 = object.result_type_1[pl_row]
ls_result_type_2 = object.result_type_2[pl_row]
ls_result_type_3 = object.result_type_3[pl_row]
ls_result_type_4 = object.result_type_4[pl_row]

ldt_result_date_time1 = object.result_date_time1[pl_row]
ldt_result_date_time2 = object.result_date_time2[pl_row]
ldt_result_date_time3 = object.result_date_time3[pl_row]
ldt_result_date_time4 = object.result_date_time4[pl_row]


CHOOSE CASE pi_column
	CASE 1
		ls_clicked_result_type = ls_result_type_1
		
		if isnull(ldt_result_date_time1) or upper(ls_clicked_result_type) = "COMMENT" then
			li_sts = service.treatment.set_result( ll_observation_sequence, &
																li_result_sequence1, &
																location )
		else
			li_sts = service.treatment.remove_result( ll_observation_sequence, &
																	li_result_sequence1, &
																	location )
		end if
	CASE 2
		ls_clicked_result_type = ls_result_type_2
		
		if isnull(ldt_result_date_time2) or upper(ls_clicked_result_type) = "COMMENT" then
			li_sts = service.treatment.set_result( ll_observation_sequence, &
																li_result_sequence2, &
																location )
		else
			li_sts = service.treatment.remove_result( ll_observation_sequence, &
																	li_result_sequence2, &
																	location )
		end if
	CASE 3
		ls_clicked_result_type = ls_result_type_3
		
		if isnull(ldt_result_date_time3) or upper(ls_clicked_result_type) = "COMMENT" then
			li_sts = service.treatment.set_result( ll_observation_sequence, &
																li_result_sequence3, &
																location )
		else
			li_sts = service.treatment.remove_result( ll_observation_sequence, &
																	li_result_sequence3, &
																	location )
		end if
	CASE 4
		ls_clicked_result_type = ls_result_type_4
		
		if isnull(ldt_result_date_time4) or upper(ls_clicked_result_type) = "COMMENT" then
			li_sts = service.treatment.set_result( ll_observation_sequence, &
																li_result_sequence4, &
																location )
		else
			li_sts = service.treatment.remove_result( ll_observation_sequence, &
																	li_result_sequence4, &
																	location )
		end if
END CHOOSE

load_treatment_row_column(pl_row, pi_column)

// Now clear the other columns if this is exclusive
if ls_exclusive_flag = "Y" and upper(ls_clicked_result_type) = upper(result_type) then
	if not isnull(ldt_result_date_time1) &
	  and pi_column <> 1 &
	  and upper(ls_result_type_1) = upper(result_type) then
		object.result_date_time1[pl_row] = ldt_null
		object.result1[pl_row] = object.result_definition_1[pl_row]
		li_sts = service.treatment.remove_result( ll_observation_sequence, &
																li_result_sequence1, &
																location )
	end if

	if not isnull(ldt_result_date_time2) &
	  and pi_column <> 2 &
	  and upper(ls_result_type_2) = upper(result_type) then
		object.result_date_time2[pl_row] = ldt_null
		object.result2[pl_row] = object.result_definition_2[pl_row]
		li_sts = service.treatment.remove_result( ll_observation_sequence, &
																li_result_sequence2, &
																location )
	end if

	if not isnull(ldt_result_date_time3) &
	  and pi_column <> 3 &
	  and upper(ls_result_type_3) = upper(result_type) then
		object.result_date_time3[pl_row] = ldt_null
		object.result3[pl_row] = object.result_definition_3[pl_row]
		li_sts = service.treatment.remove_result( ll_observation_sequence, &
																li_result_sequence3, &
																location )
	end if

	if not isnull(ldt_result_date_time4) &
	  and pi_column <> 4 &
	  and upper(ls_result_type_4) = upper(result_type) then
		object.result_date_time4[pl_row] = ldt_null
		object.result4[pl_row] = object.result_definition_4[pl_row]
		li_sts = service.treatment.remove_result( ll_observation_sequence, &
																li_result_sequence4, &
																location )
	end if

end if

li_sts = load_treatment_row(pl_row)

return



end subroutine

public subroutine patient_row_clicked (long pl_row, integer pi_column);string ls_exclusive_flag
datetime ldt_null
datetime ldt_result_date_time

setnull(ldt_null)

ls_exclusive_flag = object.exclusive_flag[pl_row]

CHOOSE CASE pi_column
	CASE 1
		ldt_result_date_time = object.result_date_time1[pl_row]
		if isnull(ldt_result_date_time) then
			object.result_date_time1[pl_row] = datetime(today(), now())
			object.result_selected[pl_row] = 1
			if ls_exclusive_flag = "Y" then
				object.result_date_time2[pl_row] = ldt_null
				object.result_date_time3[pl_row] = ldt_null
				object.result_date_time4[pl_row] = ldt_null
			end if
		else
				object.result_date_time1[pl_row] = ldt_null
				object.result_selected[pl_row] = 0
		end if
	CASE 2
		ldt_result_date_time = object.result_date_time2[pl_row]
		if isnull(ldt_result_date_time) then
			object.result_date_time2[pl_row] = datetime(today(), now())
			object.result_selected[pl_row] = 1
			if ls_exclusive_flag = "Y" then
				object.result_date_time1[pl_row] = ldt_null
				object.result_date_time3[pl_row] = ldt_null
				object.result_date_time4[pl_row] = ldt_null
			end if
		else
				object.result_selected[pl_row] = 0
				object.result_date_time2[pl_row] = ldt_null
		end if
	CASE 3
		ldt_result_date_time = object.result_date_time3[pl_row]
		if isnull(ldt_result_date_time) then
			object.result_date_time3[pl_row] = datetime(today(), now())
			object.result_selected[pl_row] = 1
			if ls_exclusive_flag = "Y" then
				object.result_date_time2[pl_row] = ldt_null
				object.result_date_time1[pl_row] = ldt_null
				object.result_date_time4[pl_row] = ldt_null
			end if
		else
				object.result_date_time3[pl_row] = ldt_null
				object.result_selected[pl_row] = 0
		end if
	CASE 4
		ldt_result_date_time = object.result_date_time4[pl_row]
		if isnull(ldt_result_date_time) then
			object.result_date_time4[pl_row] = datetime(today(), now())
			object.result_selected[pl_row] = 1
			if ls_exclusive_flag = "Y" then
				object.result_date_time2[pl_row] = ldt_null
				object.result_date_time3[pl_row] = ldt_null
				object.result_date_time1[pl_row] = ldt_null
			end if
		else
				object.result_date_time4[pl_row] = ldt_null
				object.result_selected[pl_row] = 0
		end if
END CHOOSE
end subroutine

public function integer load_treatment_row (long pl_row);integer li_sts

li_sts = load_treatment_row_column(pl_row, 1)
if li_sts < 0 then return -1

li_sts = load_treatment_row_column(pl_row, 2)
if li_sts < 0 then return -1

li_sts = load_treatment_row_column(pl_row, 3)
if li_sts < 0 then return -1

li_sts = load_treatment_row_column(pl_row, 4)
if li_sts < 0 then return -1


Return 1


end function

public function integer set_all_rows (integer pi_column);long ll_rows
long i
datetime ldt_result_date_time
string ls_column
w_pop_please_wait lw_wait


ll_rows = rowcount()


ls_column = "result_date_time" + string(pi_column)
if not is_column(ls_column) then return 0

open(lw_wait, "w_pop_please_wait")
lw_wait.initialize(0, ll_rows)

for i = 1 to ll_rows
	ldt_result_date_time = getitemdatetime(i, ls_column)
	if isnull(ldt_result_date_time) then
		if isnull(service.treatment) then
			patient_row_clicked(i, pi_column)
		else
			treatment_row_clicked(i, pi_column)
		end if
	end if
	lw_wait.bump_progress()
next

close(lw_wait)

return 1


end function

on u_dw_observations_pick_results.create
call super::create
end on

on u_dw_observations_pick_results.destroy
call super::destroy
end on

event destructor;call super::destructor;if isvalid(results) and not isnull(results) then DESTROY results
end event

event clicked;integer li_column

if not isvalid(dwo) then return
if row <= 0 or isnull(row) then return
if lower(dwo.type) <> "column" then return

li_column = integer(right(trim(dwo.name), 1))
if isnull(li_column) or li_column <= 0 then return

if isnull(service.treatment) then
	patient_row_clicked(row, li_column)
else
	treatment_row_clicked(row, li_column)
end if


end event

