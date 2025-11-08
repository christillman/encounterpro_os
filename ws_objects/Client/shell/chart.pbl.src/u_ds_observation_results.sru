$PBExportHeader$u_ds_observation_results.sru
forward
global type u_ds_observation_results from u_ds_data
end type
type str_results_for_result from structure within u_ds_observation_results
end type
type str_results_by_result from structure within u_ds_observation_results
end type
type str_results_for_location from structure within u_ds_observation_results
end type
type str_results_by_location from structure within u_ds_observation_results
end type
end forward

type str_results_for_result from structure
	string		result
	integer		row_count
	long		result_rows[]
	string		abnormal_flag
	boolean		is_comment
end type

type str_results_by_result from structure
	integer		result_count
	str_results_for_result		result[]
end type

type str_results_for_location from structure
	string		location
	string		location_description
	integer		row_count
	long		location_rows[]
	boolean		is_comment
end type

type str_results_by_location from structure
	integer		location_count
	str_results_for_location		location[]
end type

global type u_ds_observation_results from u_ds_data
end type
global u_ds_observation_results u_ds_observation_results

type variables
integer default_constituent_count
string default_constituent[]
string default_where[]
string default_how[]
string default_group_separator[]
string default_title_separator[]
string default_item_separator[]
string default_format_command

integer root_count

boolean format_results = false
boolean formatted_numbers = true

// Array of boolean to record whether each row has results
boolean any_results[]

long max_grid_result_length = 80


end variables

forward prototypes
private function string get_display_style (long pl_row)
public function string abnormal_flag (long pl_row)
public function boolean any_abnormal ()
public function integer copy_results (long pl_row, string ps_abnormal_flag, u_component_treatment puo_treatment, long pl_parent_observation_sequence, integer pi_child_ordinal, string ps_observation_tag)
private function integer get_results_by_result (long pl_row, string ps_result_type, string ps_abnormal_flag, ref str_results_by_result pstr_results)
private function integer get_results_by_location (long pl_row, string ps_result_type, string ps_abnormal_flag, ref str_results_by_location pstr_locations)
private function integer display_results (long pl_row, string ps_result_type, boolean pb_continuous, string ps_display_how, string ps_abnormal_flag, string ps_group_sep, string ps_title_sep, string ps_item_sep, u_text_base puo_rte)
private function integer results_by_location (long pl_row, string ps_result_type, boolean pb_continuous, string ps_abnormal_flag, string ps_group_sep, string ps_title_sep, string ps_item_sep, u_text_base puo_rtf)
private function integer parse_display_style (string ps_display_style, ref string psa_constituent[], ref string psa_where[], ref string psa_how[], ref string psa_group_sep[], ref string psa_title_sep[], ref string psa_item_sep[], ref string ps_format_command)
private function integer display_comment (long pl_row, u_text_base puo_rtf)
public function integer display_roots (string ps_result_type, string ps_abnormal_flag, u_rich_text_edit puo_rtf)
public function integer display_grid_date (string ps_result_type, string ps_abnormal_flag, str_rtf_table_attributes pstr_table_attributes, u_rich_text_edit puo_rtf)
public function integer display_grid_stage (string ps_result_type, string ps_abnormal_flag, str_rtf_table_attributes pstr_table_attributes, u_rich_text_edit puo_rtf)
private function integer display_history_sequence (long pl_history_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_text_base puo_rtf)
private function integer display_list (string ps_result_type, string ps_abnormal_flag, string ps_prefix, u_text_base puo_rtf)
private function integer display_observation_row (long pl_row, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_text_base puo_rtf)
private function integer display_observation_sequence (long pl_observation_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_text_base puo_rtf)
public function integer display_observation_sequence (long pl_observation_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, ref string ps_text)
public function integer display_observation_sequence (long pl_observation_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_rich_text_edit puo_rtf)
public function integer display_observation_row (long pl_row, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, ref string ps_text)
public function integer display_observation_row (long pl_row, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_rich_text_edit puo_rtf)
public function integer display_history_sequence (long pl_history_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_rich_text_edit puo_rtf)
public function integer display_history_sequence (long pl_history_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, ref string ps_text)
public function string results_for_result (long pl_parent_history_sequence, integer pi_result_sequence, string ps_abnormal_flag, ref integer pi_severity, string ps_item_sep)
public function integer results_for_location (long pl_parent_history_sequence, string ps_result_type, string ps_location, string ps_abnormal_flag, ref integer pi_severity, string ps_item_sep, u_rich_text_edit puo_rtf)
public function integer results_for_location (long pl_parent_history_sequence, string ps_result_type, string ps_location, string ps_abnormal_flag, ref integer pi_severity, string ps_item_sep, ref string ps_text)
public function integer display_list (string ps_result_type, string ps_abnormal_flag, string ps_prefix, u_rich_text_edit puo_rtf)
public function integer display_list (string ps_result_type, string ps_abnormal_flag, string ps_prefix, ref string ps_text)
private function integer display_observation (long pl_row, string ps_result_type, string ps_title_separator, boolean pb_continuous, boolean pb_have_context, ref boolean pb_context_needed, string ps_abnormal_flag, boolean pb_include_comments, boolean pb_include_attachments, u_text_base puo_rtf)
public function integer display_roots (string ps_result_type, string ps_abnormal_flag, boolean pb_include_comments, boolean pb_include_attachments, u_rich_text_edit puo_rtf)
private function integer display_comments (long pl_row, boolean pb_continuous, string ps_how, string ps_abnormal_flag, boolean pb_include_attachments, u_text_base puo_rtf)
public function long find_result (long pl_observation_sequence, string ps_location, integer pi_result_sequence)
public function long find_comment (long pl_observation_sequence, string ps_comment_type, string ps_comment_title)
public function long find_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, long pl_stage)
private function integer results_for_location (long pl_parent_history_sequence, string ps_result_type, string ps_location, string ps_abnormal_flag, ref integer pi_severity, string ps_item_sep, string ps_first_time_header, u_text_base puo_rtf)
private function integer results_by_result (long pl_row, string ps_result_type, boolean pb_continuous, string ps_abnormal_flag, string ps_group_sep, string ps_title_sep, string ps_item_sep, string ps_first_time_header, u_text_base puo_rtf)
private function integer display_roots (string ps_find, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, boolean pb_include_comments, boolean pb_include_attachments, u_text_base puo_rtf)
public function integer display_roots (string ps_result_type, string ps_abnormal_flag, ref string ps_text)
public function integer display_treatment_roots (long pl_treatment_id, string ps_result_type, string ps_abnormal_flag, ref string ps_text)
public function integer get_seperators (string ps_display_style, string ps_which, ref string ps_group_separator, ref string ps_title_separator, ref string ps_item_separator)
private function integer display_observation_result (string ps_observation_id, string ps_result_type, string ps_abnormal_flag, string ps_location, integer pi_result_sequence, boolean pb_display_result, boolean pb_display_location, boolean pb_display_unit, u_text_base puo_rtf)
public function integer display_observation_result (string ps_observation_id, string ps_result_type, string ps_abnormal_flag, string ps_location, integer pi_result_sequence, boolean pb_display_result, boolean pb_display_location, boolean pb_display_unit, u_rich_text_edit puo_rtf)
public function integer display_observation_result (string ps_observation_id, string ps_result_type, string ps_abnormal_flag, string ps_location, integer pi_result_sequence, boolean pb_display_result, boolean pb_display_location, boolean pb_display_unit, ref string ps_text)
private function string result_title_for_row (long pl_row)
public function string result_value_for_row (long pl_row, boolean pb_display_unit)
public function string result_for_row (long pl_row, boolean pb_print_result, boolean pb_print_location, boolean pb_display_unit)
public function integer display_audit (u_rich_text_edit puo_rtf)
public function str_pretty_results get_pretty_results (string ps_result_type, string ps_abnormal_flag)
public function integer display_grid_lab (string ps_result_type, string ps_abnormal_flag, str_font_settings pstr_abnormal_font_settings, str_font_settings pstr_comment_font_settings, str_rtf_table_attributes pstr_table_attributes, u_rich_text_edit puo_rtf, boolean pb_show_actor_full, boolean pb_latest_root_only)
public function str_grids get_grids (string ps_result_type, string ps_abnormal_flag, boolean pb_latest_root_only, long pl_max_result_length)
public function str_pretty_results get_pretty_results (string ps_result_type, string ps_abnormal_flag, long pl_parent_sequence)
public function string unit_value_for_row (long pl_row)
end prototypes

private function string get_display_style (long pl_row);string ls_display_style
string ls_observation_id
string ls_observation_type

// First get the display style in the datastore
ls_display_style = object.display_style[pl_row]

// If that's null, then get the display style for the observation type
if isnull(ls_display_style) then
	ls_observation_id = object.observation_id[pl_row]
	ls_observation_type = datalist.observation_observation_type(ls_observation_id)
	ls_display_style = datalist.observation_type_display_style(ls_display_style)
end if

//// If it's still null, then use the default display style
//if isnull(ls_display_style) then
//	ls_display_style = default_display_style
//end if

return ls_display_style

end function

public function string abnormal_flag (long pl_row);long ll_row
long ll_history_sequence
string ls_find
long ll_rows
string ls_abnormal_flag
string ls_return_abnormal_flag
string ls_record_type

// Perform a depth-first search to see if any descendent results of the
// given row are abnormal

setnull(ls_return_abnormal_flag)

ll_rows = rowcount()

ll_history_sequence = object.history_sequence[pl_row]
ls_find = "parent_history_sequence=" + string(ll_history_sequence)
ll_row = find(ls_find, 1, ll_rows)
DO WHILE ll_row > 0 and ll_row <= ll_rows
	ls_record_type = lower(string(object.record_type[ll_row]))
	
	if ls_record_type = "result" then
		// For result records, just check the abnormal_flag
		ls_abnormal_flag = object.abnormal_flag[ll_row]
		if isnull(ls_abnormal_flag) then ls_abnormal_flag = "N"
	elseif ls_record_type = "comment" then
		ls_abnormal_flag = "N"
	else
		// For observation and root records, call this method recursively
		ls_abnormal_flag = abnormal_flag(ll_row)
	end if
	
	// As soon as we get an abnormal result we're done
	if ls_abnormal_flag = "Y" then return "Y"
	
	if isnull(ls_return_abnormal_flag) then
		ls_return_abnormal_flag = ls_abnormal_flag
	end if
	
	ll_row = find(ls_find, ll_row + 1, ll_rows + 1)
LOOP

return ls_return_abnormal_flag

end function

public function boolean any_abnormal ();string ls_find
long ll_row

ls_find = "record_type IN ('Result', 'Comment')"
ls_find += " and abnormal_flag='Y'"
ll_row = find(ls_find, 1, rowcount())
if ll_row > 0 then return true

return false

end function

public function integer copy_results (long pl_row, string ps_abnormal_flag, u_component_treatment puo_treatment, long pl_parent_observation_sequence, integer pi_child_ordinal, string ps_observation_tag);string ls_rtf
integer li_sts
long ll_row
string ls_find
long ll_count
boolean lb_context_needed
long ll_history_sequence
string ls_record_type
long ll_child_observation_sequence
string ls_child_observation_id
integer li_child_ordinal
string ls_null
integer i
long ll_location_result_sequence
integer li_result_sequence
string ls_location
datetime ldt_result_date_time
string ls_abnormal_flag
string ls_abnormal_nature
string ls_result_value
string ls_result_unit
string ls_comment_title
integer li_severity
long ll_attachment_id
string ls_comment

string lsa_observation_id[]
integer li_observation_count

setnull(ls_null)

ll_count = rowcount()
li_sts = 0
li_observation_count = 0

ll_history_sequence = object.history_sequence[pl_row]
ls_record_type = object.record_type[pl_row]

if isnull(pi_child_ordinal) or pi_child_ordinal <= 0 then pi_child_ordinal = 1

CHOOSE CASE lower(ls_record_type)
	CASE "root", "observation"
		ls_child_observation_id = object.observation_id[pl_row]
		ll_child_observation_sequence = puo_treatment.add_observation( &
																		pl_parent_observation_sequence, &
																		ls_child_observation_id, &
																		pi_child_ordinal, &
																		ps_observation_tag, &
																		true)
		ls_find = "parent_history_sequence=" + string(ll_history_sequence)
		ll_row = find(ls_find, 1, ll_count)
		DO WHILE ll_row > 0 and ll_row <= ll_count
			// Add this observation to the list
			li_observation_count += 1
			lsa_observation_id[li_observation_count] = object.observation_id[ll_row]
			
			// Count how many times this observation_id occured at this level
			li_child_ordinal = 1
			for i = li_observation_count - 1 to 1 step -1
				if lsa_observation_id[i] = lsa_observation_id[li_observation_count] then
					li_child_ordinal += 1
				end if
			next
			
			copy_results(ll_row, ps_abnormal_flag, puo_treatment, ll_child_observation_sequence, li_child_ordinal, ls_null)
			
			ll_row = find(ls_find, ll_row + 1, ll_count + 1)
		LOOP
	CASE "result"
		li_result_sequence = object.result_sequence[pl_row]
		ls_location = object.location[pl_row]
		ldt_result_date_time = datetime(today(), now())
		ls_result_value = object.result_value[pl_row]
		ls_result_unit = object.result_unit[pl_row]
		ls_abnormal_flag = object.abnormal_flag[pl_row]
		if isnull(ls_abnormal_flag) then ls_abnormal_flag = "N"
		setnull(ls_abnormal_nature)
		
		if ls_abnormal_flag = "Y" or ps_abnormal_flag = "N" then
			ll_location_result_sequence = puo_treatment.add_result(pl_parent_observation_sequence, &
																	li_result_sequence, &
																	ls_location, &
																	ldt_result_date_time, &
																	ls_result_value, &
																	ls_result_unit, &
																	ls_abnormal_flag, &
																	ls_abnormal_nature)
			if ll_location_result_sequence > 0 then li_sts = 1
		end if
	CASE "comment"
		ls_comment_title = object.comment_title[pl_row]
		li_severity = object.severity[pl_row]
		ls_abnormal_flag = object.abnormal_flag[pl_row]
		if isnull(ls_abnormal_flag) then ls_abnormal_flag = "Y"
		ll_attachment_id = object.attachment_id[pl_row]
		ls_comment = object.comment[pl_row]
		
		if ls_abnormal_flag = "Y" or ps_abnormal_flag = "N" then
			ll_location_result_sequence = puo_treatment.add_comment(pl_parent_observation_sequence, &
																	ls_comment_title, &
																	ls_abnormal_flag, &
																	li_severity, &
																	ll_attachment_id, &
																	ls_comment)
			if ll_location_result_sequence > 0 then li_sts = 1
		end if
		
END CHOOSE

return li_sts


end function

private function integer get_results_by_result (long pl_row, string ps_result_type, string ps_abnormal_flag, ref str_results_by_result pstr_results);integer li_sts
long ll_row
long ll_count
string ls_find
long ll_history_sequence
string ls_record_type
string ls_result
boolean lb_found
long i
string ls_abnormal_flag
string ls_result_type
string ls_comment_title
string ls_comment

ll_count = rowcount()

if pl_row <= 0 or pl_row > ll_count then return 0

ll_history_sequence = object.history_sequence[pl_row]

// Construct the child find string
ls_find = "parent_history_sequence=" + string(ll_history_sequence)

// First, perform a depth-first scan of the child observations
ll_row = find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	ls_record_type = object.record_type[ll_row]
	ls_result = object.result[ll_row]
	ls_abnormal_flag = object.abnormal_flag[ll_row]
	ls_result_type = object.result_type[ll_row]
	
	if ls_record_type = "Observation" then
		li_sts = get_results_by_result(ll_row, ps_result_type, ps_abnormal_flag, pstr_results)
	elseif ls_record_type = "Result" then
		// Skip normals if we're looking for abnormals, or if wrong result_type
		if (ps_abnormal_flag <> "Y" or ls_abnormal_flag = "Y") &
		 and upper(ls_result_type) = upper(ps_result_type) then
			// See if we already have this result
			lb_found = false
			for i = 1 to pstr_results.result_count
				if ls_result = pstr_results.result[i].result then
					lb_found = true
					exit
				end if
			next
			// If we don't have this result yet, then add it to the list
			if not lb_found then
				pstr_results.result_count += 1
				i = pstr_results.result_count
				pstr_results.result[i].result = ls_result
				pstr_results.result[i].abnormal_flag = ls_abnormal_flag
			end if
			
			// Then add this row to the row list for the result
			pstr_results.result[i].row_count += 1
			pstr_results.result[i].result_rows[pstr_results.result[i].row_count] = ll_row
		end if
	elseif ls_record_type = "Comment" then
		ls_comment_title = object.comment_title[ll_row]
		ls_comment = object.comment[ll_row]
		
		// Skip normals if we're looking for abnormals, or if wrong result_type
		if upper(ps_result_type) = "PERFORM" and len(ls_comment) > 0 then
			// Make sure there is a comment title
			if isnull(ls_comment_title) or trim(ls_comment_title) = "" then ls_comment_title = "Comment"
			
			// See if we already have this result
			lb_found = false
			for i = 1 to pstr_results.result_count
				if ls_comment_title = pstr_results.result[i].result then
					lb_found = true
					exit
				end if
			next
			// If we don't have this result yet, then add it to the list
			if not lb_found then
				pstr_results.result_count += 1
				i = pstr_results.result_count
				pstr_results.result[i].result = ls_comment_title
				pstr_results.result[i].abnormal_flag = "Y"
				pstr_results.result[i].is_comment = true
			end if
			
			// Then add this row to the row list for the result
			pstr_results.result[i].row_count += 1
			pstr_results.result[i].result_rows[pstr_results.result[i].row_count] = ll_row
		end if
	end if
	
	ll_row = find(ls_find, ll_row + 1, ll_count + 1)
LOOP

return pstr_results.result_count


end function

private function integer get_results_by_location (long pl_row, string ps_result_type, string ps_abnormal_flag, ref str_results_by_location pstr_locations);integer li_sts
long ll_row
long ll_count
string ls_find
long ll_history_sequence
string ls_record_type
string ls_location
boolean lb_found
long i
string ls_abnormal_flag
string ls_result_type
string ls_comment_title
string ls_comment

ll_count = rowcount()

if pl_row <= 0 or pl_row > ll_count then return 0

ll_history_sequence = object.history_sequence[pl_row]

// Construct the child find string
ls_find = "parent_history_sequence=" + string(ll_history_sequence)

// First, perform a depth-first scan of the child observations
ll_row = find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	ls_record_type = object.record_type[ll_row]
	ls_location = object.location[ll_row]
	ls_abnormal_flag = object.abnormal_flag[ll_row]
	ls_result_type = object.result_type[ll_row]
	
	if ls_record_type = "Observation" then
		li_sts = get_results_by_location(ll_row, ps_result_type, ps_abnormal_flag, pstr_locations)
	elseif ls_record_type = "Result" then
		// Skip normals if we're looking for abnormals, or if wrong result_type
		if (ps_abnormal_flag <> "Y" or ls_abnormal_flag = "Y") &
		 and upper(ls_result_type) = upper(ps_result_type) then
			// See if we already have this location
			lb_found = false
			for i = 1 to pstr_locations.location_count
				if ls_location = pstr_locations.location[i].location then
					lb_found = true
					exit
				end if
			next
			// If we don't have this location yet, then add it to the list
			if not lb_found then
				pstr_locations.location_count += 1
				i = pstr_locations.location_count
				pstr_locations.location[i].location = ls_location
			end if
			
			// Then add this row to the row list for the location
			pstr_locations.location[i].row_count += 1
			pstr_locations.location[i].location_rows[pstr_locations.location[i].row_count] = ll_row
		end if
	elseif ls_record_type = "Comment" then
		ls_comment_title = object.comment_title[ll_row]
		ls_comment = object.comment[ll_row]
		
		// Skip normals if we're looking for abnormals, or if wrong result_type
		if upper(ps_result_type) = "PERFORM" and len(ls_comment) > 0 then
			// Make sure there is a comment title
			if isnull(ls_comment_title) or trim(ls_comment_title) = "" then ls_comment_title = "Comment"
			
			// See if we already have this location
			lb_found = false
			for i = 1 to pstr_locations.location_count
				if ls_comment_title = pstr_locations.location[i].location then
					lb_found = true
					exit
				end if
			next
			// If we don't have this location yet, then add it to the list
			if not lb_found then
				pstr_locations.location_count += 1
				i = pstr_locations.location_count
				pstr_locations.location[i].location = ls_comment_title
				pstr_locations.location[i].is_comment = true
			end if
			
			// Then add this row to the row list for the location
			pstr_locations.location[i].row_count += 1
			pstr_locations.location[i].location_rows[pstr_locations.location[i].row_count] = ll_row
		end if
	end if
	
	ll_row = find(ls_find, ll_row + 1, ll_count + 1)
LOOP

return pstr_locations.location_count


end function

private function integer display_results (long pl_row, string ps_result_type, boolean pb_continuous, string ps_display_how, string ps_abnormal_flag, string ps_group_sep, string ps_title_sep, string ps_item_sep, u_text_base puo_rte);long ll_row
string ls_find
long ll_history_sequence
integer li_sts
string ls_display_style
long ll_count
string ls_perform_location_domain

ll_count = rowcount()
ll_history_sequence = object.history_sequence[pl_row]
ls_display_style = object.display_style[pl_row]
ls_perform_location_domain = object.perform_location_domain[pl_row]

// See if there's at least one result for this observation
ls_find = "parent_history_sequence=" + string(ll_history_sequence)
ls_find += " and record_type='Result'"
ll_row = find(ls_find, 1, rowcount())

if ll_row > 0 then
	// If there's at least one result, then check to see if we should display the
	// result by result or by location
	if ps_display_how = "L" and ls_perform_location_domain <> "NA" then
		li_sts = results_by_location(pl_row, ps_result_type, pb_continuous, ps_abnormal_flag, ps_group_sep, ps_title_sep, ps_item_sep, puo_rte)
	else
		li_sts = results_by_result(pl_row, ps_result_type, pb_continuous, ps_abnormal_flag, ps_group_sep, ps_title_sep, ps_item_sep, "", puo_rte)
	end if
else
	li_sts = 0
end if

return li_sts

end function

private function integer results_by_location (long pl_row, string ps_result_type, boolean pb_continuous, string ps_abnormal_flag, string ps_group_sep, string ps_title_sep, string ps_item_sep, u_text_base puo_rtf);integer i
string lsa_location[]
string lsa_location_description[]
integer li_out_count
integer li_location_count
string ls_location_domain
string ls_results
string ls_results_rtf
string ls_observation_id
string ls_find
long ll_row
integer li_sts
long ll_history_sequence
string ls_location_text
integer li_severity
string ls_first_time_header

// Get the perform_location_domain
ls_observation_id = object.observation_id[pl_row]
ls_location_domain = object.perform_location_domain[pl_row]
ll_history_sequence = object.history_sequence[pl_row]

// Get a list of the locations in that domain
li_location_count = datalist.locations_in_domain(ls_location_domain, lsa_location, lsa_location_description)

// Get the results for each location in the domain
li_out_count = 0

for i = 1 to li_location_count
	if pb_continuous then
		// First add the location heading
		if li_out_count > 0 then
			ls_location_text = ps_group_sep
		else
			ls_location_text = ""
		end if
		ls_location_text += lsa_location_description[i] + ps_title_sep
		ls_first_time_header = ls_location_text
	else
		ls_first_time_header = "~r~n" + lsa_location_description[i] + "~t"
	end if
	

	// Then add the results for the location
	li_sts = results_for_location(ll_history_sequence, ps_result_type, lsa_location[i], ps_abnormal_flag, li_severity, ps_item_sep, ls_first_time_header, puo_rtf)
	if li_sts > 0 then
		li_out_count += 1
	end if
next

return li_out_count

end function

private function integer parse_display_style (string ps_display_style, ref string psa_constituent[], ref string psa_where[], ref string psa_how[], ref string psa_group_sep[], ref string psa_title_sep[], ref string psa_item_sep[], ref string ps_format_command);integer i
string ls_group
string ls_the_rest
string ls_separators
integer j

if isnull(ps_display_style) then
	psa_constituent = default_constituent
	psa_where = default_where
	psa_how = default_how
	psa_group_sep = default_group_separator
	psa_title_sep = default_title_separator
	psa_item_sep = default_item_separator
	ps_format_command = default_format_command
	return default_constituent_count
end if

i = 0

ls_the_rest = ps_display_style

DO WHILE true
	// Pick off the next group, using vertical bar as the delimiter
	f_split_string(ls_the_rest, "|", ls_group, ls_the_rest)
	if isnull(ls_group) or trim(ls_group) = "" then exit
	
	if upper(left(ls_group, 1)) = "F" then
		ps_format_command = mid(ls_group, 2)
	else
		if len(ls_group) < 3 then exit
		i += 1
		psa_constituent[i] = upper(left(ls_group, 1))
		psa_where[i] = upper(mid(ls_group, 2, 1))
		psa_how[i] = upper(mid(ls_group, 3, 1))
		ls_separators = mid(ls_group, 4)
		if ls_separators = "" then
			// If no separators were supplied in the display_style, then use the
			// defaults for the appropriate constituent
			for j = 1 to default_constituent_count
				if default_constituent[j] = psa_constituent[i] then
					psa_group_sep[i] = default_group_separator[j]
					psa_title_sep[i] = default_title_separator[j]
					psa_item_sep[i] = default_item_separator[j]
					exit
				end if
			next
		else
			// We found some separators so parse them delimiting with a percent sign
			f_split_string(ls_separators, "%", psa_group_sep[i], ls_separators)
			f_split_string(ls_separators, "%", psa_title_sep[i], ls_separators)
			f_split_string(ls_separators, "%", psa_item_sep[i], ls_separators)
		end if
	end if
LOOP

return i

end function

private function integer display_comment (long pl_row, u_text_base puo_rtf);integer li_sts
string ls_comment
long ll_attachment_id
string ls_fieldtext
string ls_fielddata
str_service_info lstr_service

ls_comment = object.comment[pl_row]
ll_attachment_id = object.attachment_id[pl_row]

if isnull(ls_comment) then
	ls_comment = ""
else
	ls_comment = trim(ls_comment)
end if

if len(ls_comment) <= 0 and isnull(ll_attachment_id) then return 0

if len(ls_comment) > 0 then
	puo_rtf.add_text(ls_comment)
end if

if not isnull(ll_attachment_id) then
	ls_fieldtext = current_patient.attachments.attachment_extension_description(ll_attachment_id)
	if isnull(ls_fieldtext) or trim(ls_fieldtext) = "" then ls_fieldtext = "Attachment"
	ls_fieldtext = "<" + ls_fieldtext + ">"
	
	lstr_service.service = "ATTACHMENT"
	f_attribute_add_attribute(lstr_service.attributes, "attachment_id", string(ll_attachment_id))
	f_attribute_add_attribute(lstr_service.attributes, "action", "display")
	ls_fielddata = f_service_to_field_data(lstr_service)
	
	if len(ls_comment) > 0 then puo_rtf.add_text("  ")
	puo_rtf.add_field(ls_fieldtext, ls_fielddata)
end if
	
return 1


end function

public function integer display_roots (string ps_result_type, string ps_abnormal_flag, u_rich_text_edit puo_rtf);return display_roots(ps_result_type, ps_abnormal_flag, true, true, puo_rtf)

end function

public function integer display_grid_date (string ps_result_type, string ps_abnormal_flag, str_rtf_table_attributes pstr_table_attributes, u_rich_text_edit puo_rtf);string ls_root_find
long ll_root_row
long ll_column_row
string ls_column_find
long ll_rows
string ls_root_observation_id
long ll_root_history_sequence
long ll_column_history_sequence
str_grid lstr_grid
str_observation_tree lstr_tree
string ls_column_observation_id
integer li_column_result_sequence
string ls_column_location
string ls_result_find
long ll_result_row
long i, j
date ld_date
string ls_result
boolean lb_found
string ls_result_type
integer li_property_count
integer lia_property_column[]
long lla_property_row[]
string ls_observation_id
integer li_result_sequence
str_c_observation_result lstr_result
str_attributes lstr_attributes
str_property_value lstr_property_value
str_property lstr_property
long ll_object_key
boolean lb_print_location
string ls_group_sep
string ls_title_sep
string ls_item_sep
string ls_display_style
integer li_sts
long lla_last_observation_sequence[]
long ll_observation_sequence
string ls_cell_sep

// Initialize
setnull(ll_object_key)
li_property_count = 0
lstr_grid.row_count = 0
lstr_grid.column_count = 0
ll_rows = rowcount()

// First find the root for this grid
ls_root_find = "record_type='Root'"
ll_root_row = find(ls_root_find, 1, ll_rows)
if isnull(ll_root_row) or ll_root_row <= 0 then return -1

lstr_grid.row_title = "Date"

ls_root_observation_id = object.observation_id[ll_root_row]
ll_root_history_sequence = object.history_sequence[ll_root_row]

// Loop through the first level children.  These are the columns
ls_column_find = "parent_history_sequence=" + string(ll_root_history_sequence)
ls_column_find += " and lower(record_type)='observation'"
ll_column_row = find(ls_column_find, 1, ll_rows)
// If we didn't find a child of the root then the grid is empty
if isnull(ll_column_row) or ll_column_row <= 0 then return 0

DO WHILE ll_column_row > 0 and ll_column_row <= ll_rows
	// Add the column to the grid
	lstr_grid.column_count += 1
	lstr_grid.column_title[lstr_grid.column_count] = object.observation_description[ll_column_row]
	
	// Initialize the last column of any existing rows
	for i = 1 to lstr_grid.row_count
		setnull(lstr_grid.grid_row[i].column[lstr_grid.column_count].column_text)
	next

	ll_column_history_sequence = object.history_sequence[ll_column_row]
	ls_column_location = object.location[ll_column_row]
	li_column_result_sequence = object.result_sequence[ll_column_row]
	ls_display_style = object.display_style[ll_column_row]
	
	li_sts = get_seperators(ls_display_style, "R", ls_group_sep, ls_title_sep, ls_item_sep)
	if li_sts <= 0 then
		ls_group_sep = "~n"
		ls_title_sep = ":"
		ls_item_sep = ","
	end if
														
	// Now loop the results and add/update the rows
	ls_result_find = "parent_history_sequence=" + string(ll_column_history_sequence)
	ls_result_find += " and lower(record_type)='result'"
	if not isnull(ls_column_location) and ls_column_location <> "NA" then
		ls_result_find += " and lower(location)='" + lower(ls_column_location) + "'"
		lb_print_location = false
	else
		// If the config did not specify a location and one exists, then display it in the cell
		lb_print_location = true
	end if
	if not isnull(li_column_result_sequence) then
		ls_result_find += " and result_sequence=" + string(li_column_result_sequence)
	end if
	
	// Since we're changing columns now, zero out the last observation_sequence array
	for i = 1 to lstr_grid.row_count
		lla_last_observation_sequence[i] = 0
	next

	ll_result_row = find(ls_result_find, 1, ll_rows)
	DO WHILE ll_result_row > 0 and ll_result_row <= ll_rows
		// Get the result type
		ls_result_type = object.result_type[ll_result_row]
		ll_observation_sequence = object.observation_sequence[ll_result_row]
		
		CHOOSE CASE upper(ls_result_type)
			CASE "COLLECT"
			CASE "PERFORM"
				// We found a result for this column, so determine what row it's in
				ls_result = result_for_row(ll_result_row, false, lb_print_location, false)
				ld_date = date(datetime(object.result_date_time[ll_result_row]))
				lb_found = false
				for i = 1 to lstr_grid.row_count
					if lstr_grid.grid_row[i].row_date = ld_date then
						// See if we're working against the same observation sequence as the previous result in this cell
						if lla_last_observation_sequence[i] = ll_observation_sequence then
							ls_cell_sep = ls_group_sep
						else
							ls_cell_sep = "~n"
							lla_last_observation_sequence[i] = ll_observation_sequence
						end if
						// We found a row with the same date
						if len(lstr_grid.grid_row[i].column[lstr_grid.column_count].column_text) > 0 then
							lstr_grid.grid_row[i].column[lstr_grid.column_count].column_text += ls_cell_sep + ls_result
						else
							lstr_grid.grid_row[i].column[lstr_grid.column_count].column_text = ls_result
						end if
						lb_found = true
						exit
					end if
				next
				if not lb_found then
					// If we didn't find a row with the same date then add a new row
					lstr_grid.row_count += 1
					// Initialize the columns
					for i = 1 to lstr_grid.column_count
						setnull(lstr_grid.grid_row[lstr_grid.row_count].column[i].column_text)
					next
					// Set the row data
					lstr_grid.grid_row[lstr_grid.row_count].row_date = ld_date
					lstr_grid.grid_row[lstr_grid.row_count].row_title = string(ld_date)
					lstr_grid.grid_row[lstr_grid.row_count].column[lstr_grid.column_count].column_text = ls_result
					// Record the last observation_sequence for this row
					lla_last_observation_sequence[lstr_grid.row_count] = ll_observation_sequence
				end if
			CASE "PROPERTY"
				li_property_count += 1
				lia_property_column[li_property_count] = lstr_grid.column_count
				lla_property_row[li_property_count] = ll_result_row
		END CHOOSE
		ll_result_row = find(ls_result_find, ll_result_row + 1, ll_rows + 1)
	LOOP
	ll_column_row = find(ls_column_find, ll_column_row + 1, ll_rows + 1)
LOOP

// Loop through the property columns and set the property for each row
for i = 1 to li_property_count
	ls_observation_id = object.observation_id[lla_property_row[i]]
	li_result_sequence = object.result_sequence[lla_property_row[i]]
	
	// Find the result structure.  Skip if not found
	lstr_result = datalist.observation_result(ls_observation_id, li_result_sequence)
	if isnull(lstr_result.observation_id) then continue
	
	// Find the property structure.  Skip if not found
	lstr_property = datalist.find_property(lstr_result.property_id)
	if isnull(lstr_property.property_id) then continue
	
	// Get the context associated with the property
	CHOOSE CASE lower(lstr_property.property_object)
		CASE "encounter"
			ll_object_key = puo_rtf.last_encounter.encounter_id
		CASE "assessment"
			ll_object_key = puo_rtf.last_assessment.problem_id
		CASE "treatment"
			ll_object_key = puo_rtf.last_treatment.treatment_id
		CASE ELSE
			setnull(ll_object_key)
	END CHOOSE

	// Now loop through the rows and call the property for each row
	for j = 1 to lstr_grid.row_count
		f_attribute_add_attribute(lstr_attributes, "property_date", string(lstr_grid.grid_row[j].row_date))
		lstr_property_value = f_get_property(lstr_property.property_object, &
														lstr_property.function_name, &
														ll_object_key, &
														lstr_attributes)
		lstr_grid.grid_row[j].column[lia_property_column[i]].column_text = lstr_property_value.display_value
	next
next

lstr_grid.table_attributes = pstr_table_attributes

// Finally, sort the rows by date
f_sort_grid_by_date(lstr_grid)

puo_rtf.add_grid(lstr_grid)

return 1

end function

public function integer display_grid_stage (string ps_result_type, string ps_abnormal_flag, str_rtf_table_attributes pstr_table_attributes, u_rich_text_edit puo_rtf);string ls_root_find
long ll_root_row
long ll_stage_row
string ls_stage_find
long ll_column_row
string ls_column_find
long ll_comment_row
string ls_comment_find
long ll_rows
string ls_root_observation_id
string ls_stage_observation_id
long ll_root_history_sequence
long ll_stage_history_sequence
long ll_column_history_sequence
long ll_stage
str_grid lstr_grid
str_observation_tree lstr_tree
string ls_column_observation_id
integer li_column_result_sequence
string ls_column_location
string ls_result_find
long ll_result_row
long i
string ls_result
string ls_null

setnull(ls_null)

ll_rows = rowcount()

// First find the root for this grid
ls_root_find = "record_type='Root'"
ll_root_row = find(ls_root_find, 1, ll_rows)
if isnull(ll_root_row) or ll_root_row <= 0 then return -1

ls_root_observation_id = object.observation_id[ll_root_row]
ll_root_history_sequence = object.history_sequence[ll_root_row]

// Get the first stage row and determine the columns from its observation_id
ls_stage_find = "parent_history_sequence=" + string(ll_root_history_sequence)
ll_stage_row = find(ls_stage_find, 1, ll_rows)
// If we didn't find a child of the root then the grid is empty
if isnull(ll_stage_row) or ll_stage_row <= 0 then return 0

ls_stage_observation_id = object.observation_id[ll_stage_row]

// Get the children of the row observation_id and set the column headings
lstr_tree = datalist.observation_tree(ls_stage_observation_id)
// If the row observation_id has no children then we're done
if lstr_tree.branch_count <= 0 then return 0

// Initialize the row count
lstr_grid.row_count = 0

// Set the column headings
lstr_grid.column_count = lstr_tree.branch_count + 1
for i = 1 to lstr_tree.branch_count
	lstr_grid.column_title[i] = lstr_tree.branch[i].description
next
lstr_grid.row_title = "Stage"
lstr_grid.column_title[lstr_grid.column_count] = "Comment"

// Now loop through the stage rows
DO WHILE ll_stage_row > 0 and ll_stage_row <= ll_rows
	lstr_grid.row_count += 1
	lstr_grid.grid_row[lstr_grid.row_count].row_stage = object.stage[ll_stage_row]
	lstr_grid.grid_row[lstr_grid.row_count].row_title = object.stage_description[ll_stage_row]
	if isnull(lstr_grid.grid_row[lstr_grid.row_count].row_title) then
		lstr_grid.grid_row[lstr_grid.row_count].row_title = datalist.stage_description( ls_stage_observation_id, &
																									lstr_grid.grid_row[lstr_grid.row_count].row_stage)
	end if
	
	// Now loop through the children of the stage row.  These are the grid columns.
	ll_stage_history_sequence = object.history_sequence[ll_stage_row]
	ls_column_find = "parent_history_sequence=" + string(ll_stage_history_sequence)
	ls_column_find += " and lower(record_type)='observation'"
	
	ll_column_row = find(ls_column_find, 1, ll_rows)
	DO WHILE ll_column_row > 0 and ll_column_row <= ll_rows
		// Now loop through the results for each observation and match the results with the
		// colums using observation_id, location, and result_sequence
		ll_column_history_sequence = object.history_sequence[ll_column_row]
		ls_column_observation_id = object.observation_id[ll_column_row]
		ls_result_find = "parent_history_sequence=" + string(ll_column_history_sequence)
		ls_result_find += " and lower(record_type)='result'"
		ll_result_row = find(ls_column_find, 1, ll_rows)
		DO WHILE ll_result_row > 0 and ll_result_row <= ll_rows
			li_column_result_sequence = object.result_sequence[ll_result_row]
			ls_column_location = object.location[ll_result_row]
			
			// We have a specific result.  Now find which column it belongs in.
		for i = 1 to lstr_tree.branch_count
			if lstr_tree.branch[i].child_observation_id = ls_column_observation_id &
			  and lstr_tree.branch[i].result_sequence = li_column_result_sequence &
			  and lstr_tree.branch[i].location = ls_column_location then
				// We found the column, so render the text and put it into the appropriate grid slot
				ls_result = result_value_for_row(ll_result_row, false)
				lstr_grid.grid_row[lstr_grid.row_count].column[i].column_text = ls_result
			end if
		next
	
			ll_result_row = find(ls_result_find, ll_result_row + 1, ll_rows + 1)
		LOOP

		ll_column_row = find(ls_column_find, ll_column_row + 1, ll_rows + 1)
	LOOP

	// Put the comment in the last column
	ls_comment_find = "parent_history_sequence=" + string(ll_stage_history_sequence)
	ls_comment_find += " and lower(record_type)='comment'"
	ll_comment_row = find(ls_comment_find, 1, ll_rows)
	if ll_comment_row > 0 then
		lstr_grid.grid_row[lstr_grid.row_count].column[lstr_grid.column_count].column_text = object.comment[ll_comment_row]
	else
		lstr_grid.grid_row[lstr_grid.row_count].column[lstr_grid.column_count].column_text = ls_null
	end if
	
	// Get the next stage
	ll_stage_row = find(ls_stage_find, ll_stage_row + 1, ll_rows + 1)
LOOP

lstr_grid.table_attributes = pstr_table_attributes

puo_rtf.add_grid(lstr_grid)


return 1

end function

private function integer display_history_sequence (long pl_history_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_text_base puo_rtf);string ls_rtf
integer li_sts
long ll_row
string ls_find
long ll_count
boolean lb_context_needed
ulong ll_hCursor

format_results = true

SetPointer(HourGlass!)

ll_count = rowcount()
li_sts = 0

puo_rtf.set_level(0)
puo_rtf.wrap_on()

ls_find = "history_sequence=" + string(pl_history_sequence)
ls_find += " and (record_type='Root' OR record_type='Observation')"
ll_row = find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	li_sts += 1
	display_observation(ll_row, ps_result_type, ": ", pb_continuous, true, lb_context_needed, ps_abnormal_flag, true, true, puo_rtf)
	
	ll_row = find(ls_find, ll_row + 1, ll_count + 1)
LOOP

puo_rtf.wrap_off()

return li_sts


end function

private function integer display_list (string ps_result_type, string ps_abnormal_flag, string ps_prefix, u_text_base puo_rtf);u_unit luo_unit
string ls_temp
long ll_row
string ls_find
string ls_result_unit
string ls_result
string ls_result_amount_flag
string ls_abnormal_flag
string ls_result_value
string ls_result_item
string ls_result_text
string ls_location_description
string ls_sep
long ll_r_count
string ls_location
datetime ldt_result_date_time
string ls_print_result_flag
string ls_print_result_separator
string ls_unit_preference
string ls_display_mask
long ll_result_count
ulong ll_hCursor
string ls_record_type
string ls_comment_title
string ls_find_parent
long ll_parent_row
long ll_parent_history_sequence
string ls_display_style
integer li_constituent_count
string lsa_constituent[]
string lsa_where[]
string lsa_how[]
string lsa_group_sep[]
string lsa_title_sep[]
string lsa_item_sep[]
string ls_format_command
integer i
string ls_how
boolean lb_found

format_results = false

SetPointer(HourGlass!)

ll_result_count = 0

ll_r_count = rowcount()

ls_find = "(record_type='Result'"
ls_find += " and upper(result_type)='" + upper(ps_result_type) + "'"
if ps_abnormal_flag = "Y" then
	ls_find += " and abnormal_flag='Y'"
end if
ls_find += ") or record_type='Comment'"

ll_row = find(ls_find, 1, ll_r_count)

DO WHILE ll_row > 0 and ll_row <= ll_r_count
	// Get the display_style from the parent observation record
	ll_parent_history_sequence = object.parent_history_sequence[ll_row]
	ls_find_parent = "parent_history_sequence=" + string(ll_parent_history_sequence)
	ll_parent_row = find(ls_find_parent, 1, ll_r_count)
	if ll_parent_row > 0 then
		ls_display_style = object.display_style[ll_parent_row]
	else
		setnull(ls_display_style)
	end if
	
	// Parse the display_style
	li_constituent_count = parse_display_style(ls_display_style, &
															lsa_constituent, &
															lsa_where, &
															lsa_how, &
															lsa_group_sep, &
															lsa_title_sep, &
															lsa_item_sep, &
															ls_format_command)
	// Find the "C" constituent
	for i = 1 to li_constituent_count
		if lsa_constituent[i] = "C" then
			lb_found = true
			ls_how = lsa_how[i]
		end if
	next
	if not lb_found then
		// Printing the comment title is the default
		ls_how = "T"
	end if
	
	ls_result_text = ""
	
	if ll_result_count > 0 then puo_rtf.add_cr()

	ls_record_type = object.record_type[ll_row]
	if ls_record_type = "Result" then
		ldt_result_date_time = object.result_date_time[ll_row]
		ls_result_amount_flag = object.result_amount_flag[ll_row]
		ls_result = object.result[ll_row]
		ls_location = object.location[ll_row]
		ls_location_description = object.location_description[ll_row]
		ls_result_value = object.result_value[ll_row]
		ls_result_unit = object.result_unit[ll_row]
		ls_print_result_flag = object.print_result_flag[ll_row]
		ls_print_result_separator = object.print_result_separator[ll_row]
		ls_abnormal_flag = object.abnormal_flag[ll_row]
		ls_unit_preference = object.unit_preference[ll_row]
		ls_display_mask = object.display_mask[ll_row]
		
		if isnull(ls_print_result_separator) then ls_print_result_separator = "="

		if ls_result_amount_flag = "Y" and not isnull(ls_result_value) and trim(ls_result_value) <> "" then
			if formatted_numbers then
				luo_unit = unit_list.find_unit(ls_result_unit)
				if isnull(luo_unit) then
					ls_temp = ""
				else
					ls_temp = luo_unit.pretty_amount_unit(ls_result_value, ls_unit_preference, ls_display_mask)
				end if	
			else
				ls_temp = ls_result_value
			end if
		
			if ls_location = "NA" then
				if ls_print_result_flag = "Y" then
					ls_result_text = ls_result + ls_print_result_separator + ls_temp
				else
					ls_result_text = ls_temp
				end if
			else
				if ls_print_result_flag = "Y" then
					ls_result_text = ls_result + " " + ls_location_description + ls_print_result_separator + ls_temp
				else
					ls_result_text = ls_location_description + ls_print_result_separator + ls_temp
				end if
			end if
		else
			if ls_location = "NA" then
				ls_result_text = ls_result
			else
				if ls_print_result_flag = "Y" then
					ls_result_text = ls_result + " " + ls_location_description
				else
					ls_result_text = ls_location_description
				end if
			end if
		end if
		
		puo_rtf.add_text(ps_prefix)
		puo_rtf.add_text(ls_result_text)
	else
		puo_rtf.add_text(ps_prefix)
		
		if ls_how = "T" then
			ls_comment_title = trim(string(object.comment_title[ll_row]))
			if len(ls_comment_title) > 0 then
				puo_rtf.add_text(ls_comment_title)
				puo_rtf.add_text(": ")
			end if
		end if
		display_comment(ll_row, puo_rtf)
	end if
		
	ll_result_count += 1
	ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
LOOP

return ll_result_count

end function

private function integer display_observation_row (long pl_row, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_text_base puo_rtf);integer li_sts
boolean lb_context_needed
ulong ll_hCursor

format_results = true

SetPointer(HourGlass!)

puo_rtf.set_level(0)
puo_rtf.wrap_on()
li_sts = display_observation(pl_row, ps_result_type, ": ", pb_continuous, true, lb_context_needed, ps_abnormal_flag, true, true, puo_rtf)
puo_rtf.wrap_off()

return li_sts


end function

private function integer display_observation_sequence (long pl_observation_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_text_base puo_rtf);string ls_rtf
integer li_sts
long ll_row
string ls_find
long ll_count
boolean lb_context_needed
ulong ll_hCursor

format_results = false

SetPointer(HourGlass!)

ll_count = rowcount()
li_sts = 0

puo_rtf.set_level(0)
puo_rtf.wrap_on()

ls_find = "observation_sequence=" + string(pl_observation_sequence)
ls_find += " and (record_type='Root' OR record_type='Observation')"
ll_row = find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	li_sts += 1
	display_observation(ll_row, ps_result_type, ": ", pb_continuous, true, lb_context_needed, ps_abnormal_flag, true, true, puo_rtf)
	
	ll_row = find(ls_find, ll_row + 1, ll_count + 1)
LOOP

puo_rtf.wrap_off()

return li_sts


end function

public function integer display_observation_sequence (long pl_observation_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, ref string ps_text);u_text_text luo_rtf
integer li_sts

luo_rtf = CREATE u_text_text

if isnull(ps_text) then
	luo_rtf.text = ""
else
	luo_rtf.text = ps_text
end if

li_sts = display_observation_sequence(pl_observation_sequence, &
											ps_result_type, &
											ps_abnormal_flag, &
											pb_continuous, &
											luo_rtf)

ps_text = luo_rtf.text

return li_sts


end function

public function integer display_observation_sequence (long pl_observation_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_rich_text_edit puo_rtf);u_text_rtf luo_rtf

luo_rtf = CREATE u_text_rtf

luo_rtf.rtf = puo_rtf

return display_observation_sequence(pl_observation_sequence, &
											ps_result_type, &
											ps_abnormal_flag, &
											pb_continuous, &
											luo_rtf)

end function

public function integer display_observation_row (long pl_row, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, ref string ps_text);u_text_text luo_rtf
integer li_sts

luo_rtf = CREATE u_text_text

if isnull(ps_text) then
	luo_rtf.text = ""
else
	luo_rtf.text = ps_text
end if

li_sts = display_observation_row(pl_row, &
											ps_result_type, &
											ps_abnormal_flag, &
											pb_continuous, &
											luo_rtf)

ps_text = luo_rtf.text

return li_sts


end function

public function integer display_observation_row (long pl_row, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_rich_text_edit puo_rtf);u_text_rtf luo_rtf

luo_rtf = CREATE u_text_rtf

luo_rtf.rtf = puo_rtf

return display_observation_row(pl_row, &
											ps_result_type, &
											ps_abnormal_flag, &
											pb_continuous, &
											luo_rtf)

end function

public function integer display_history_sequence (long pl_history_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, u_rich_text_edit puo_rtf);u_text_rtf luo_rtf

luo_rtf = CREATE u_text_rtf

luo_rtf.rtf = puo_rtf

return display_history_sequence(pl_history_sequence, &
											ps_result_type, &
											ps_abnormal_flag, &
											pb_continuous, &
											luo_rtf)

end function

public function integer display_history_sequence (long pl_history_sequence, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, ref string ps_text);u_text_text luo_rtf
integer li_sts

luo_rtf = CREATE u_text_text

if isnull(ps_text) then
	luo_rtf.text = ""
else
	luo_rtf.text = ps_text
end if

li_sts = display_history_sequence(pl_history_sequence, &
											ps_result_type, &
											ps_abnormal_flag, &
											pb_continuous, &
											luo_rtf)

ps_text = luo_rtf.text

return li_sts

end function

public function string results_for_result (long pl_parent_history_sequence, integer pi_result_sequence, string ps_abnormal_flag, ref integer pi_severity, string ps_item_sep);u_unit luo_unit
string ls_temp
long ll_row
string ls_find
string ls_result_unit
string ls_result
string ls_result_amount_flag
string ls_abnormal_flag
string ls_result_value
string ls_result_item
string ls_result_list
string ls_location_description
string ls_sep
long ll_r_count
string ls_location
datetime ldt_result_date_time
string ls_print_result_flag
string ls_print_result_separator
string ls_unit_preference
string ls_display_mask
string ls_default_view
string ls_observation_id

if isnull(ps_item_sep) then ps_item_sep = ", "
ls_result_list = ""
ls_sep = ""

setnull(pi_severity)

ll_r_count = rowcount()

ls_find = "parent_history_sequence=" + string(pl_parent_history_sequence)
ls_find += " and result_sequence=" + string(pi_result_sequence)
ll_row = find(ls_find, 1, ll_r_count)

DO WHILE ll_row > 0 and ll_row <= ll_r_count
	ldt_result_date_time = object.result_date_time[ll_row]
	ls_result_amount_flag = object.result_amount_flag[ll_row]
	
	// If the location is not applicable, then use the result description in the string construction
	ls_result = object.result[ll_row]
	ls_location = object.location[ll_row]
	ls_location_description = object.location_description[ll_row]
	ls_result_value = object.result_value[ll_row]
	ls_result_unit = object.result_unit[ll_row]
	ls_print_result_flag = object.print_result_flag[ll_row]
	ls_print_result_separator = object.print_result_separator[ll_row]
	ls_abnormal_flag = object.abnormal_flag[ll_row]
	ls_unit_preference = object.unit_preference[ll_row]
	ls_display_mask = object.display_mask[ll_row]
	
	if isnull(ls_print_result_separator) then ls_print_result_separator = " "

	if not isnull(ldt_result_date_time) then
		if ps_abnormal_flag = "Y" &
		 and (ls_abnormal_flag <> "Y" or isnull(ls_abnormal_flag)) &
		 and (ls_result_amount_flag <> "Y" or isnull(ls_result_amount_flag)) then
			ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
			continue
		end if
		
		pi_severity = object.severity[ll_row]
		
		ls_result_list += ls_sep
		ls_sep = ps_item_sep
	
		if ls_result_amount_flag = "Y" and not isnull(ls_result_value) and trim(ls_result_value) <> "" then
			if formatted_numbers then
				luo_unit = unit_list.find_unit(ls_result_unit)
				if isnull(luo_unit) then
					ls_temp = ""
				else
					ls_temp = luo_unit.pretty_amount_unit(ls_result_value, ls_unit_preference, ls_display_mask)
				end if	
			else
				ls_temp = ls_result_value
			end if
	
			if ls_location = "NA" then
				if ls_print_result_flag = "Y" then
					ls_result_list += ls_result + ls_print_result_separator + ls_temp
				else
					ls_result_list += ls_temp
				end if
			else
				ls_observation_id = object.observation_id[ll_row]
				ls_default_view = datalist.observation_default_view(ls_observation_id)
				if upper(ls_default_view) = "R" then
					ls_result_list += ls_location_description + ls_print_result_separator + ls_temp
				else
					ls_result_list += ls_temp + ls_print_result_separator + ls_location_description
				end if
			end if
		else
			if ls_location = "NA" then
				ls_result_list += ls_result
			else
				ls_result_list += ls_location_description
			end if
		end if
	end if
	
	// Get the next record and skip ahead until the location changes
	ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
	DO WHILE true
		if ll_row <= 0 then exit
		if ll_row > ll_r_count then exit
		if ls_location <> object.location[ll_row] then exit
		ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
	LOOP
LOOP

if trim(ls_result_list) = "" then setnull(ls_result_list)

return ls_result_list

end function

public function integer results_for_location (long pl_parent_history_sequence, string ps_result_type, string ps_location, string ps_abnormal_flag, ref integer pi_severity, string ps_item_sep, u_rich_text_edit puo_rtf);u_text_rtf luo_rtf

luo_rtf = CREATE u_text_rtf

luo_rtf.rtf = puo_rtf

return results_for_location(pl_parent_history_sequence, &
										ps_result_type, &
										ps_location, &
										ps_abnormal_flag, &
										pi_severity, &
										ps_item_sep, &
										"", &
										luo_rtf)

end function

public function integer results_for_location (long pl_parent_history_sequence, string ps_result_type, string ps_location, string ps_abnormal_flag, ref integer pi_severity, string ps_item_sep, ref string ps_text);u_text_text luo_rtf
integer li_sts

luo_rtf = CREATE u_text_text

if isnull(ps_text) then
	luo_rtf.text = ""
else
	luo_rtf.text = ps_text
end if

li_sts = results_for_location(pl_parent_history_sequence, &
										ps_result_type, &
										ps_location, &
										ps_abnormal_flag, &
										pi_severity, &
										ps_item_sep, &
										"", &
										luo_rtf)


ps_text = luo_rtf.text

return li_sts


end function

public function integer display_list (string ps_result_type, string ps_abnormal_flag, string ps_prefix, u_rich_text_edit puo_rtf);u_text_rtf luo_rtf

luo_rtf = CREATE u_text_rtf

luo_rtf.rtf = puo_rtf

return display_list(ps_result_type, ps_abnormal_flag, ps_prefix, luo_rtf)

end function

public function integer display_list (string ps_result_type, string ps_abnormal_flag, string ps_prefix, ref string ps_text);u_text_text luo_rtf
integer li_sts

luo_rtf = CREATE u_text_text

if isnull(ps_text) then
	luo_rtf.text = ""
else
	luo_rtf.text = ps_text
end if

li_sts = display_list(ps_result_type, &
							ps_abnormal_flag, &
							ps_prefix, &
							luo_rtf)

ps_text = luo_rtf.text

return li_sts

end function

private function integer display_observation (long pl_row, string ps_result_type, string ps_title_separator, boolean pb_continuous, boolean pb_have_context, ref boolean pb_context_needed, string ps_abnormal_flag, boolean pb_include_comments, boolean pb_include_attachments, u_text_base puo_rtf);string ls_temp
string ls_display_style
integer li_sts
long ll_row
integer li_right_count
integer li_below_count
string ls_child_find
long ll_count
string ls_description
long ll_history_sequence
integer li_constituent_count
string lsa_constituent[]
string lsa_where[]
string lsa_how[]
string lsa_group_sep[]
string lsa_title_sep[]
string lsa_item_sep[]
integer i
integer j
integer k
boolean lb_loop_found
str_results_by_result lstr_results
str_results_by_location lstr_locations
string ls_observation_desc
string ls_location
string ls_location_description
string ls_result
string ls_results
string ls_record_type
string ls_in_context_flag
boolean lb_parent_context_needed
boolean lb_child_context_needed
string ls_format_command
boolean lb_abnormal
string ls_comment
string ls_observed_by
datetime ldt_result_date_time
str_font_settings lstr_font_settings
str_charposition lstr_startpos
str_charposition lstr_endpos

if isnull(ps_title_separator) then ps_title_separator = ": "

// Get the initial insertion point
lstr_startpos = puo_rtf.charposition()

ll_count = rowcount()
li_right_count = 0
li_below_count = 0
lb_parent_context_needed = false

if pl_row <= 0 or pl_row > ll_count then return 0

if not any_results[pl_row] then return 0

ls_record_type = wordcap(object.record_type[pl_row])
ls_in_context_flag = object.in_context_flag[pl_row]
ls_description = object.observation_description[pl_row]
// unused ls_composite_flag = object.composite_flag[pl_row]
ll_history_sequence = object.history_sequence[pl_row]
ls_display_style = get_display_style(pl_row)
ls_observed_by = object.observed_by[pl_row]
ldt_result_date_time = object.result_date_time[pl_row]

// Parse the display_style
li_constituent_count = parse_display_style(ls_display_style, &
														lsa_constituent, &
														lsa_where, &
														lsa_how, &
														lsa_group_sep, &
														lsa_title_sep, &
														lsa_item_sep, &
														ls_format_command)

puo_rtf.apply_formatting(ls_format_command)

// Construct the child find string
ls_child_find = "parent_history_sequence=" + string(ll_history_sequence)
ls_child_find += " and record_type='Observation'"
	
// First we need to display the observation description
if ls_record_type = "Root" and lsa_where[1] = "B" then
	// If this is the root description and the children are below, then add the observed_by and date/time
	ls_temp = user_list.user_full_name(ls_observed_by)
	ls_temp += " - " + string(date(ldt_result_date_time))
	if time(ldt_result_date_time) > time("00:00:00") then
		ls_temp += " " + string(time(ldt_result_date_time))
	end if
	if len(ls_temp) > 0 then
		ls_description += " (" + ls_temp + ")"
	end if
	puo_rtf.Add_text(ls_description, true)
else
	puo_rtf.Add_text(ls_description)
end if
if upper(ps_result_type) = "PERFORM" then
	// If we're showing perform results and this observation has a collect result, show it in parenthesis
	li_sts = results_by_result(pl_row, "COLLECT", true, "N", "; ", ": ", ", ", " (", puo_rtf)
	if li_sts > 0 then
		puo_rtf.Add_text(")")
	end if
end if

// Then add either a tab character or a title separator, depending 
// upon whether display continuously or heirarchically
if pb_continuous then
	puo_rtf.Add_text(ps_title_separator)
elseif ls_record_type <> "Root" or lsa_where[1] <> "B" then
	puo_rtf.Add_tab()
end if

// Mark this spot as the end of the observation description
lstr_endpos = puo_rtf.charposition()


// First display the constituents which should go to the right of the observation description
for i = 1 to li_constituent_count
	if pb_continuous or lsa_where[i] = "R" then
		lb_loop_found = false
		if li_right_count > 0 then puo_rtf.Add_text(lsa_group_sep[i])
		
		CHOOSE CASE lsa_constituent[i]
			CASE "O"
				CHOOSE CASE lsa_how[i]
					CASE "O"
						// then display the child observations
						ll_row = find(ls_child_find, 1, ll_count)
						DO WHILE ll_row > 0 and ll_row <= ll_count
							// If we've already added any results in this loop then add a result separator
							if lb_loop_found then
									// If the pb_continuous flag is not set then this is the first
									// set of child observations to be printed to the right.  In that
									// case put a carriage return between them so they all line up at
									// the wrap margin
									if not pb_continuous then
										puo_rtf.add_cr()
										puo_rtf.add_tab()
									else
										puo_rtf.Add_text(lsa_group_sep[i])
									end if
							end if
							li_sts = display_observation(ll_row, ps_result_type, lsa_title_sep[i], true, false, lb_child_context_needed, ps_abnormal_flag, pb_include_comments, pb_include_attachments, puo_rtf)
							if li_sts > 0 then
								if lb_child_context_needed then lb_parent_context_needed = true
								lb_loop_found = true
							elseif lb_loop_found then
								// If we didn't find any results then remove the result separator
								if not pb_continuous then
									puo_rtf.delete_last_chars(1)
									puo_rtf.delete_cr()
								else
									puo_rtf.delete_last_chars(len(lsa_group_sep[i]))
								end if
							end if
							
							ll_row = find(ls_child_find, ll_row + 1, ll_count + 1)
						LOOP
					CASE "R"
						// Get the distinct results
						li_sts = get_results_by_result(pl_row, ps_result_type, ps_abnormal_flag, lstr_results)
						
						// Display the distinct results
						ls_results = ""
						for k = 1 to lstr_results.result_count
							if not lstr_results.result[k].is_comment then
								// If we've already added any results in this loop then add a result separator
								if len(ls_results) > 0 then ls_results += lsa_group_sep[i]
								ls_results += lstr_results.result[k].result
								ls_results += " - "
								
								for j = 1 to lstr_results.result[k].row_count
									if j > 1 then ls_results += lsa_item_sep[i]
									ls_observation_desc = object.observation_description[lstr_results.result[k].result_rows[j]]
									ls_location = object.location[lstr_results.result[k].result_rows[j]]
									ls_location_description = object.location_description[lstr_results.result[k].result_rows[j]]
									
									ls_results += ls_observation_desc
									if ls_location <> "NA" then
										ls_results += " ("
										ls_results += ls_location_description
										ls_results += ")"
									end if
									lb_loop_found = true
									lb_parent_context_needed = true
								next
							end if
						next
						puo_rtf.add_text(ls_results)
						
						// Display the comments
						ls_results = ""
						for k = 1 to lstr_results.result_count
							if lstr_results.result[k].is_comment then
								// If we've already added any results in this loop then add a result separator
								if len(ls_results) > 0 then ls_results += lsa_group_sep[i]
								ls_results += lstr_results.result[k].result
								ls_results += " - "
								
								for j = 1 to lstr_results.result[k].row_count
									if j > 1 then ls_results += lsa_item_sep[i]

									ls_comment = object.comment[lstr_results.result[k].result_rows[j]]
									ls_observation_desc = object.observation_description[lstr_results.result[k].result_rows[j]]
									
									// Display the observation description
									// If the observation description is the same as the comment title, then don't display it
									if lower(lstr_results.result[k].result) <> lower(ls_observation_desc) then
										// Suppress the observation_description
										// ls_results += ls_observation_desc + lsa_title_sep[i]
									end if
									
									// Then display the comment itself
									ls_results += ls_comment
									
									lb_loop_found = true
									lb_parent_context_needed = true
								next
							end if
						next
						puo_rtf.add_text(ls_results)
					CASE "L"
						// Get the distinct locations
						li_sts = get_results_by_location(pl_row, ps_result_type, ps_abnormal_flag, lstr_locations)
						
						// Display the distinct locations
						ls_results = ""
						for k = 1 to lstr_locations.location_count
							if not lstr_locations.location[k].is_comment then
								// If we've already added any locations in this loop then add a location separator
								if len(ls_results) > 0 then ls_results += lsa_group_sep[i]
								if lstr_locations.location[k].location <> "NA" then
									ls_results += lstr_locations.location[k].location_description
									ls_results += " - "
								end if
								
								for j = 1 to lstr_locations.location[k].row_count
									if j > 1 then ls_results += lsa_item_sep[i]
									ls_observation_desc = object.observation_description[lstr_locations.location[k].location_rows[j]]
									ls_result = object.result[lstr_locations.location[k].location_rows[j]]
									
									ls_results += ls_observation_desc
									ls_results += lsa_title_sep[i]
									ls_results += ls_result
									lb_loop_found = true
									lb_parent_context_needed = true
								next
							end if
						next
						puo_rtf.add_text(ls_results)

						// Display the comments
						ls_results = ""
						for k = 1 to lstr_locations.location_count
							if lstr_locations.location[k].is_comment then
								// If we've already added any locations in this loop then add a location separator
								if len(ls_results) > 0 then ls_results += lsa_group_sep[i]
								
								if lstr_locations.location[k].location <> "NA" then
									ls_results += lstr_locations.location[k].location_description
									ls_results += " - "
								end if
								
								for j = 1 to lstr_locations.location[k].row_count
									if j > 1 then ls_results += lsa_item_sep[i]
									
									ls_comment = object.comment[lstr_locations.location[k].location_rows[j]]
									ls_observation_desc = object.observation_description[lstr_locations.location[k].location_rows[j]]
									
									// Display the observation description
									// If the observation description is the same as the comment title, then don't display it
									if lower(lstr_locations.location[k].location_description) <> lower(ls_observation_desc) then
										// Suppress the observation_description
										// ls_results += ls_observation_desc + lsa_title_sep[i]
									end if
									
									// Then display the comment itself
									ls_results += ls_comment
									
									lb_loop_found = true
									lb_parent_context_needed = true
								next
							end if
						next
						puo_rtf.add_text(ls_results)
				END CHOOSE
			CASE "R"
				li_sts = display_results(pl_row, ps_result_type, true, lsa_how[i], ps_abnormal_flag, lsa_group_sep[i], lsa_title_sep[i], lsa_item_sep[i], puo_rtf)
				if li_sts > 0 then
					lb_loop_found = true
					lb_parent_context_needed = true
				end if
			CASE "C"
				if pb_include_comments then
					li_sts = display_comments(pl_row, true, lsa_how[i], ps_abnormal_flag, pb_include_attachments, puo_rtf)
					if li_sts > 0 then
						lb_loop_found = true
	//					lb_parent_context_needed = true
					end if
				end if
		END CHOOSE
		
		if lb_loop_found then
			li_right_count += 1
		elseif li_right_count > 0 then
			// If we didn't find any comments then remove the result separator
			puo_rtf.delete_last_chars(len(lsa_group_sep[i]))
		end if
	end if
next

if pb_continuous then
	// If we didn't find any results in continuous mode, then remove the observation description
	if (li_right_count <= 0) or (not lb_parent_context_needed) or pb_have_context then
		if f_char_position_compare(lstr_startpos, lstr_endpos) <> 0 then
			puo_rtf.delete_range(f_charrange(lstr_startpos, lstr_endpos))
		end if
	end if
else
	// If we're not in continuous mode, then check to see which constituents should
	// be displayed below the observation
	
	
	if ls_record_type = "Root" and li_right_count <= 0 and root_count <= 1 then
		// If this is the root record and we didn't find any "right-side" results and
		// there is only one root record, then suppress the root description
		puo_rtf.delete_from_position(lstr_startpos)
	else
		// Otherwise, add a carriage return and indent one level
		puo_rtf.add_cr()
		puo_rtf.next_level()
	end if
	
	// Now display the constituents which should go below the observation description
	for i = 1 to li_constituent_count
		if lsa_where[i] = "B" then
			
			lb_loop_found = false
			CHOOSE CASE lsa_constituent[i]
				CASE "O"
					CHOOSE CASE lsa_how[i]
						CASE "O"
							// then display the child observations
							ll_row = find(ls_child_find, 1, ll_count)
							DO WHILE ll_row > 0 and ll_row <= ll_count
								li_sts = display_observation(ll_row, ps_result_type, lsa_title_sep[i], false, false, lb_child_context_needed, ps_abnormal_flag, pb_include_comments, pb_include_attachments, puo_rtf)
								if li_sts > 0 then
									if puo_rtf.linelength() > 0 then puo_rtf.add_cr()
									lb_loop_found = true
								end if
								
								ll_row = find(ls_child_find, ll_row + 1, ll_count + 1)
							LOOP
						CASE "R"
							// Get the distinct results
							li_sts = get_results_by_result(pl_row, ps_result_type, ps_abnormal_flag, lstr_results)
							
							// Reset local variables
							lb_abnormal = false
							ls_results = ""

							// Display the distinct results
							for k = 1 to lstr_results.result_count
								if not lstr_results.result[k].is_comment then
									ls_results += lstr_results.result[k].result
									ls_results += "~t"
									if f_string_to_boolean(lstr_results.result[k].abnormal_flag) then lb_abnormal = true
									
									for j = 1 to lstr_results.result[k].row_count
										if j > 1 then ls_results += lsa_item_sep[i]
										ls_observation_desc = object.observation_description[lstr_results.result[k].result_rows[j]]
										ls_location = object.location[lstr_results.result[k].result_rows[j]]
										ls_location_description = object.location_description[lstr_results.result[k].result_rows[j]]
										
										ls_results += ls_observation_desc
										if ls_location <> "NA" then
											ls_results += " ("
											ls_results += ls_location_description
											ls_results += ")"
										end if
										lb_loop_found = true
									next
									ls_results += "~r~n"
								end if
							next

							// Then display the comments
							for k = 1 to lstr_results.result_count
								if lstr_results.result[k].is_comment then
									ls_results += lstr_results.result[k].result
									ls_results += "~t"
									
									for j = 1 to lstr_results.result[k].row_count
										if j > 1 then ls_results += lsa_item_sep[i]

										ls_comment = object.comment[lstr_results.result[k].result_rows[j]]
										ls_observation_desc = object.observation_description[lstr_results.result[k].result_rows[j]]
										
										// Display the observation description
										// If the observation description is the same as the comment title, then don't display it
										if lower(lstr_results.result[k].result) <> lower(ls_observation_desc) then
											// Suppress the observation_description
											// ls_results += ls_observation_desc + lsa_title_sep[i]
										end if
										
										// Then display the comment itself
										ls_results += ls_comment
										
										lb_loop_found = true
									next
									ls_results += "~r~n"
								end if
							next
							puo_rtf.Add_text(ls_results, lb_abnormal)
						CASE "L"
							// Get the distinct locations
							li_sts = get_results_by_location(pl_row, ps_result_type, ps_abnormal_flag, lstr_locations)
							
							ls_results = ""

							// Display the distinct locations
							for k = 1 to lstr_locations.location_count
								if not lstr_locations.location[k].is_comment then
									// If we've already added any locations in this loop then add a location separator
									if lstr_locations.location[k].location <> "NA" then
										ls_results += lstr_locations.location[k].location_description
									end if
									ls_results += "~t"
									
									for j = 1 to lstr_locations.location[k].row_count
										if j > 1 then ls_results += lsa_item_sep[i]
										ls_observation_desc = object.observation_description[lstr_locations.location[k].location_rows[j]]
										ls_result = object.result[lstr_locations.location[k].location_rows[j]]
										
										ls_results += ls_observation_desc
										ls_results += lsa_title_sep[i]
										ls_results += ls_result
										lb_loop_found = true
									next
									ls_results += "~r~n"
								end if
							next

							// Display the comments
							for k = 1 to lstr_locations.location_count
								if lstr_locations.location[k].is_comment then
									// If we've already added any locations in this loop then add a location separator
									if lstr_locations.location[k].location <> "NA" then
										ls_results += lstr_locations.location[k].location_description
									end if
									ls_results += "~t"
									
									for j = 1 to lstr_locations.location[k].row_count
										if j > 1 then ls_results += lsa_item_sep[i]
										
										ls_comment = object.comment[lstr_locations.location[k].location_rows[j]]
										ls_observation_desc = object.observation_description[lstr_locations.location[k].location_rows[j]]
										
										// Display the observation description
										// If the observation description is the same as the comment title, then don't display it
										if lower(lstr_locations.location[k].location_description) <> lower(ls_observation_desc) then
											// Suppress the observation_description
											// ls_results += ls_observation_desc + lsa_title_sep[i]
										end if
										
										// Then display the comment itself
										ls_results += ls_comment

										lb_loop_found = true
									next
									ls_results += "~r~n"
								end if
							next
							
							puo_rtf.Add_text(ls_results)
					END CHOOSE
				CASE "R"
					li_sts = display_results(pl_row, ps_result_type, false, lsa_how[i], ps_abnormal_flag, lsa_group_sep[i], lsa_title_sep[i], lsa_item_sep[i], puo_rtf)
					if li_sts > 0 then
						puo_rtf.add_cr()
						lb_loop_found = true
					end if
				CASE "C"
					if pb_include_comments then
						li_sts = display_comments(pl_row, false, lsa_how[i], ps_abnormal_flag, pb_include_attachments, puo_rtf)
						if li_sts > 0 then
							puo_rtf.add_cr()
							lb_loop_found = true
						end if
					end if
			END CHOOSE
			
			if lb_loop_found then
				li_below_count += 1
			end if
		end if
	next
	
	if ls_record_type = "Root" and li_right_count <= 0 and root_count <= 1 then
	else
		puo_rtf.prev_level()
	
		// If we didn't display anything below the observation then delete the carriage return
		if li_below_count <= 0 then
			puo_rtf.delete_cr()
			if li_right_count <= 0 then
				puo_rtf.delete_from_position(lstr_startpos)
			end if
		end if
	end if
	
end if


if ls_in_context_flag = "Y" then
	pb_context_needed = true
else
	pb_context_needed = false
end if

	
return li_right_count + li_below_count


end function

public function integer display_roots (string ps_result_type, string ps_abnormal_flag, boolean pb_include_comments, boolean pb_include_attachments, u_rich_text_edit puo_rtf);integer li_sts
u_text_rtf luo_rtf

luo_rtf = CREATE u_text_rtf
luo_rtf.rtf = puo_rtf

li_sts = display_roots("", ps_result_type, ps_abnormal_flag, false, pb_include_comments, pb_include_attachments, luo_rtf)

DESTROY luo_rtf

return li_sts

end function

private function integer display_comments (long pl_row, boolean pb_continuous, string ps_how, string ps_abnormal_flag, boolean pb_include_attachments, u_text_base puo_rtf);long ll_row
string ls_find
long ll_history_sequence
integer li_sts
long ll_count
integer li_found_count
string ls_comment
string ls_comment_title
str_font_settings lstr_font_settings
long ll_wrap_margin
long ll_attachment_id

li_found_count = 0
ll_count = rowcount()
ll_history_sequence = object.history_sequence[pl_row]

ls_find = "parent_history_sequence=" + string(ll_history_sequence)
ls_find += " and record_type='Comment'"
if not pb_include_attachments then
	ls_find += " and isnull(attachment_id)"
end if
ll_row = find(ls_find, 1, ll_count)

DO WHILE ll_row > 0 and ll_row <= ll_count
	ls_comment = object.comment[ll_row]
	ll_attachment_id = object.attachment_id[ll_row]
	
	if isnull(ls_comment) then
		ls_comment = ""
	else
		ls_comment = trim(ls_comment)
	end if

	if len(ls_comment) > 0 or not isnull(ll_attachment_id) then
		li_found_count += 1
		ls_comment_title = object.comment_title[ll_row]
		if isnull(ls_comment_title) or trim(ls_comment_title) = "" then
			ls_comment_title = object.observation_description[ll_row]
		end if
		
		if pb_continuous then
			if li_found_count > 1 then
				puo_rtf.add_text(";  ")
			end if
			if upper(ps_how) = "T" then
				puo_rtf.add_text(ls_comment_title)
				puo_rtf.add_text(": ")
			end if
			if len(ls_comment) > 0 then
				display_comment(ll_row, puo_rtf)
			end if
		else
			if upper(ps_how) = "T" then
				puo_rtf.add_text(ls_comment_title)
				puo_rtf.add_tab()
				if len(ls_comment) > 0 then
					display_comment(ll_row, puo_rtf)
					puo_rtf.add_cr()
				end if
			else
				if len(ls_comment) > 0 then
					// Since there's no title, we need to display the entire comment left justified
					// so turn off wrapping and set the wrap margin to zero
					puo_rtf.wrap_off()
					ll_wrap_margin = puo_rtf.wrap_margin()
					puo_rtf.set_margins(puo_rtf.left_margin(), 0, puo_rtf.right_margin())
					display_comment(ll_row, puo_rtf)
					puo_rtf.add_cr()
					puo_rtf.set_margins(puo_rtf.left_margin(), ll_wrap_margin, puo_rtf.right_margin())
					puo_rtf.wrap_on()
				end if
			end if
		end if
	end if
		
	ll_row = find(ls_find, ll_row + 1, ll_count + 1)
LOOP

return li_found_count

end function

public function long find_result (long pl_observation_sequence, string ps_location, integer pi_result_sequence);long ll_row
integer li_sts
long ll_observation_sequence
string ls_find
long i
long ll_p_rows
boolean lb_followon
integer li_found_count

ll_p_rows = rowcount()

// Now, count the total p_observation records under the corresponding
// parent with the same child observation_id
li_found_count = 0

if isnull(pl_observation_sequence) then return 0


ls_find = "record_type='Result'"
ls_find += " and observation_sequence=" + string(pl_observation_sequence)
if not isnull(pi_result_sequence) then
	ls_find += " and result_sequence=" + string(pi_result_sequence)
end if
if not isnull(ps_location) then
	ls_find += " and location='" + ps_location + "'"
end if


ll_row = find(ls_find, 1, ll_p_rows)
if ll_row <= 0 then return 0

return ll_row



end function

public function long find_comment (long pl_observation_sequence, string ps_comment_type, string ps_comment_title);long ll_row
integer li_sts
long ll_observation_sequence
string ls_find
long i
long ll_p_rows
boolean lb_followon
integer li_found_count

ll_p_rows = rowcount()

// Now, count the total p_observation records under the corresponding
// parent with the same child observation_id
li_found_count = 0

if isnull(pl_observation_sequence) then return 0


ls_find = "record_type='Comment'"
ls_find += " and observation_sequence=" + string(pl_observation_sequence)
if not isnull(ps_comment_type) then
	ls_find += " and comment_type='" + ps_comment_type + "'"
end if
if not isnull(ps_comment_title) then
	ls_find += " and comment_title='" + ps_comment_title + "'"
end if

ll_row = find(ls_find, 1, ll_p_rows)
if ll_row <= 0 then return 0

return ll_row



end function

public function long find_observation (long pl_parent_observation_sequence, string ps_observation_id, integer pi_child_ordinal, long pl_stage);long ll_row
integer li_sts
long ll_observation_sequence
string ls_find
long i
long ll_p_rows
boolean lb_followon
integer li_found_count

if pi_child_ordinal <= 0 or isnull(pi_child_ordinal) then pi_child_ordinal = 1

ll_p_rows = rowcount()

// Now, count the total p_observation records under the corresponding
// parent with the same child observation_id
li_found_count = 0

if isnull(pl_parent_observation_sequence) then
	ls_find = "isnull(parent_observation_sequence)"
	// if the parent_observation_sequence is null then don't use the child ordinal
	setnull(pi_child_ordinal)
else
	ls_find = "parent_observation_sequence=" + string(pl_parent_observation_sequence)
end if

ls_find += " and observation_id='" + ps_observation_id + "'"

if not isnull(pl_stage) then
	ls_find += " and stage=" + string(pl_stage)
end if

ls_find += " and record_type='Observation'"

ll_row = find(ls_find, 1, ll_p_rows)
DO WHILE ll_row > 0 and ll_row <= ll_p_rows
	li_found_count += 1
	// If the found count equals the child ordinal, then assume that this is the corresponding p record
	if li_found_count = pi_child_ordinal then return ll_row
	
	ll_row = find(ls_find, ll_row + 1, ll_p_rows + 1)
LOOP

return 0



end function

private function integer results_for_location (long pl_parent_history_sequence, string ps_result_type, string ps_location, string ps_abnormal_flag, ref integer pi_severity, string ps_item_sep, string ps_first_time_header, u_text_base puo_rtf);u_unit luo_unit
string ls_temp
long ll_row
string ls_find
string ls_result_unit
string ls_result
string ls_result_amount_flag
string ls_abnormal_flag
string ls_result_value
string ls_result_item
string ls_print_result_flag
string ls_print_result_separator
string ls_sep
long ll_r_count
string ls_location_description
integer li_result_sequence
datetime ldt_result_date_time
integer li_severity
integer li_out_count
string ls_unit_preference
string ls_display_mask
boolean lb_highlighted
boolean lb_first_time

if isnull(ps_item_sep) then ps_item_sep = ", "
ls_sep = ""

ll_r_count = rowcount()

setnull(pi_severity)
li_out_count = 0
lb_first_time = true

ls_find = "parent_history_sequence=" + string(pl_parent_history_sequence)
ls_find += " and location='" + ps_location + "'"
ls_find += " and upper(result_type)='" + upper(ps_result_type) + "'"
ll_row = find(ls_find, 1, ll_r_count)

DO WHILE ll_row > 0 and ll_row <= ll_r_count
	ldt_result_date_time = object.result_date_time[ll_row]
	li_result_sequence = object.result_sequence[ll_row]
	
	// A null result_date_time indicates "no result"
	if not isnull(ldt_result_date_time) then
		ls_result_amount_flag = object.result_amount_flag[ll_row]
		ls_result = object.result[ll_row]
		ls_result_value = object.result_value[ll_row]
		ls_result_unit = object.result_unit[ll_row]
		ls_print_result_flag = object.print_result_flag[ll_row]
		ls_print_result_separator = object.print_result_separator[ll_row]
		ls_abnormal_flag = object.abnormal_flag[ll_row]
		ls_unit_preference = object.unit_preference[ll_row]
		ls_display_mask = object.display_mask[ll_row]
		
		if isnull(ls_print_result_separator) then ls_print_result_separator = "="
		
		if ps_abnormal_flag = "Y" &
		 and (ls_abnormal_flag <> "Y" or isnull(ls_abnormal_flag)) &
		 and (ls_result_amount_flag <> "Y" or isnull(ls_result_amount_flag)) then
			ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
			continue
		end if
		
		li_severity = object.severity[ll_row]
		if isnull(pi_severity) then
			pi_severity = li_severity
		elseif li_severity > pi_severity then
			pi_severity = li_severity
		end if
		
		// If we get here then we're gonna display something.  First calculate whether it's highlighted
		if format_results and upper(ls_abnormal_flag) = "Y" then
			lb_highlighted = true
		else
			lb_highlighted = false
		end if
		
		li_out_count += 1
		
		if lb_first_time then
			puo_rtf.add_text(ps_first_time_header, false)
			lb_first_time = false
		end if
		
		puo_rtf.add_text(ls_sep)
		ls_sep = ps_item_sep
	
		if ls_result_amount_flag = "Y" and not isnull(ls_result_value) and trim(ls_result_value) <> "" then
			if formatted_numbers then
				luo_unit = unit_list.find_unit(ls_result_unit)
				if isnull(luo_unit) then
					ls_temp = ""
				else
					ls_temp = luo_unit.pretty_amount_unit(ls_result_value, ls_unit_preference, ls_display_mask)
				end if	
			else
				// if we're not supposed to format the numbers, then use the original text
				ls_temp = ls_result_value
			end if
			
			if ls_print_result_flag = "Y" then
				puo_rtf.add_text(ls_result + ls_print_result_separator + ls_temp, lb_highlighted)
			else
				puo_rtf.add_text(ls_temp, lb_highlighted)
			end if
		else
			puo_rtf.add_text(ls_result, lb_highlighted)
		end if
		
	end if
	
	// Get the next record and skip ahead until the result_sequence changes
	ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
	DO WHILE true
		if ll_row <= 0 then exit
		if ll_row > ll_r_count then exit
		if li_result_sequence <> object.result_sequence[ll_row] then exit
		ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
	LOOP
LOOP

return li_out_count


end function

private function integer results_by_result (long pl_row, string ps_result_type, boolean pb_continuous, string ps_abnormal_flag, string ps_group_sep, string ps_title_sep, string ps_item_sep, string ps_first_time_header, u_text_base puo_rtf);u_unit luo_unit
string ls_temp
long ll_row
string ls_find
string lsa_result[]
string ls_result
string ls_abnormal_flag
string ls_result_amount_flag
integer li_result_sequence
long ll_r_count
string lsa_print_result_flag[]
integer li_found_count
integer i
integer lia_result_sequence[]
string lsa_location[]
string ls_results
integer li_out_count
integer li_severity
string lsa_abnormal_flag[]
long ll_history_sequence
boolean lb_highlighted
string ls_header

li_found_count = 0

ll_r_count = rowcount()

ll_history_sequence = object.history_sequence[pl_row]

ls_find = "parent_history_sequence=" + string(ll_history_sequence)
ls_find += " and upper(result_type)='" + upper(ps_result_type) + "'"
ll_row = find(ls_find, 1, ll_r_count)

DO WHILE ll_row > 0 and ll_row <= ll_r_count
	li_result_sequence = object.result_sequence[ll_row]
	ls_abnormal_flag = object.abnormal_flag[ll_row]
	ls_result_amount_flag = object.result_amount_flag[ll_row]
	
	// If this is not an abnormal result and the ps_abnormal_flag param is "Y" then skip this result
	if ps_abnormal_flag = "Y" &
	 and (ls_abnormal_flag <> "Y" or isnull(ls_abnormal_flag)) &
	 and (ls_result_amount_flag <> "Y" or isnull(ls_result_amount_flag)) then
		ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
	   continue
	end if

	// If this is the same result sequence then skip it
	if li_found_count > 0 then
		if lia_result_sequence[li_found_count] = li_result_sequence then
			ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
			continue
		end if
	end if

	li_found_count += 1

	lia_result_sequence[li_found_count] = li_result_sequence
	lsa_print_result_flag[li_found_count] = object.print_result_flag[ll_row]
	lsa_result[li_found_count] = object.result[ll_row]
	lsa_location[li_found_count] = object.location[ll_row]
	lsa_abnormal_flag[li_found_count] = object.abnormal_flag[ll_row]
	
	ll_row = find(ls_find, ll_row + 1, ll_r_count + 1)
LOOP

li_out_count = 0

for i = 1 to li_found_count
	ls_header = ""
	ls_results = results_for_result(ll_history_sequence, lia_result_sequence[i], ps_abnormal_flag, li_severity, ps_item_sep)
	if isnull(ls_results) then continue
	li_out_count += 1
	
	
	// If we get here then we're gonna display something.  First calculate whether it's highlighted
	if format_results and upper(lsa_abnormal_flag[i]) = "Y" then
		lb_highlighted = true
	else
		lb_highlighted = false
	end if

	// Add the first_time_header
	if li_out_count = 1 then
		ls_header += ps_first_time_header
	end if

	// Add the separation to the front
	if pb_continuous then
		if li_out_count > 1 then ls_header += ps_group_sep
	else
		ls_header += "~r~n"
	end if
	
	if pb_continuous then
		if lsa_print_result_flag[i] = "Y" and lsa_location[i] <> "NA" then
			ls_header += lsa_result[i] + ps_title_sep
		end if
	else
		ls_header = lsa_result[i]
		if lsa_location[i] <> "NA" then
			ls_header += "~t"
		end if
	end if
	
	puo_rtf.add_text(ls_header + ls_results, lb_highlighted)
next

return li_out_count

end function

private function integer display_roots (string ps_find, string ps_result_type, string ps_abnormal_flag, boolean pb_continuous, boolean pb_include_comments, boolean pb_include_attachments, u_text_base puo_rtf);string ls_rtf
integer li_sts
long ll_row
string ls_find
long ll_count
long ll_found_count
boolean lb_context_needed
string ls_title_sep
ulong ll_hCursor
str_font_settings lstr_font_settings_save

format_results = true

setnull(ls_title_sep)

lstr_font_settings_save = puo_rtf.get_font_settings()

ll_count = rowcount()
ll_found_count = 0

if len(ps_find) > 0 then
	ls_find = "(" + ps_find + ") and "
else
	ls_find = ""
end if

ls_find += "record_type='Root'"

// First count the roots
root_count = 0
ll_row = find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	root_count += 1
	ll_row = find(ls_find, ll_row + 1, ll_count + 1)
LOOP

SetPointer(HourGlass!)

// Reset the level
puo_rtf.set_level(0)
puo_rtf.wrap_on()

// Then process the roots
ll_row = find(ls_find, 1, ll_count)
DO WHILE ll_row > 0 and ll_row <= ll_count
	li_sts = display_observation(ll_row, ps_result_type, ls_title_sep, pb_continuous, false, lb_context_needed, ps_abnormal_flag, pb_include_comments, pb_include_attachments, puo_rtf)
	if li_sts > 0 then
		ll_found_count += 1
		if pb_continuous then
			puo_rtf.add_text(", ")
		else
			puo_rtf.add_cr()
		end if
	end if
	
	ll_row = find(ls_find, ll_row + 1, ll_count + 1)
LOOP

// Remove the final comma
if pb_continuous and ll_found_count > 0 then
	puo_rtf.delete_last_chars(2)
end if

puo_rtf.wrap_off()

// Finally restore the font_settings if we changed it
puo_rtf.set_font_settings(lstr_font_settings_save)

return ll_found_count


end function

public function integer display_roots (string ps_result_type, string ps_abnormal_flag, ref string ps_text);u_text_text luo_rtf
integer li_sts

luo_rtf = CREATE u_text_text

if isnull(ps_text) then
	luo_rtf.text = ""
else
	luo_rtf.text = ps_text
end if

li_sts = display_roots("", ps_result_type, ps_abnormal_flag, true, true, true, luo_rtf)

ps_text = luo_rtf.text

DESTROY luo_rtf

return li_sts

end function

public function integer display_treatment_roots (long pl_treatment_id, string ps_result_type, string ps_abnormal_flag, ref string ps_text);u_text_text luo_rtf
integer li_sts
string ls_find

if isnull(pl_treatment_id) then return 0

ls_find = "treatment_id=" + string(pl_treatment_id)

luo_rtf = CREATE u_text_text

if isnull(ps_text) then
	luo_rtf.text = ""
else
	luo_rtf.text = ps_text
end if

li_sts = display_roots(ls_find, ps_result_type, ps_abnormal_flag, true, true, true, luo_rtf)

ps_text = luo_rtf.text

DESTROY luo_rtf

return li_sts

end function

public function integer get_seperators (string ps_display_style, string ps_which, ref string ps_group_separator, ref string ps_title_separator, ref string ps_item_separator);integer i
string ls_group
string ls_the_rest
string ls_separators
integer j

if isnull(ps_display_style) then return 0

i = 0

ls_the_rest = ps_display_style

DO WHILE true
	// Pick off the next group, using vertical bar as the delimiter
	f_split_string(ls_the_rest, "|", ls_group, ls_the_rest)
	if isnull(ls_group) or trim(ls_group) = "" then exit
	
	if upper(left(ls_group, 1)) = upper(ps_which) then
		if len(ls_group) <= 3 then return 0
		ls_separators = mid(ls_group, 4)
		// We found some separators so parse them delimiting with a percent sign
		f_split_string(ls_separators, "%", ps_group_separator, ls_separators)
		f_split_string(ls_separators, "%", ps_title_separator, ls_separators)
		f_split_string(ls_separators, "%", ps_item_separator, ls_separators)
		return 1
	end if
LOOP

return 0



end function

private function integer display_observation_result (string ps_observation_id, string ps_result_type, string ps_abnormal_flag, string ps_location, integer pi_result_sequence, boolean pb_display_result, boolean pb_display_location, boolean pb_display_unit, u_text_base puo_rtf);string ls_rtf
integer li_sts
long ll_row
string ls_find
long ll_count
boolean lb_context_needed
ulong ll_hCursor
long ll_parent_history_sequence
u_unit luo_unit
string ls_result
integer li_severity
string ls_item_sep
string ls_display_how
string ls_group_sep
string ls_title_sep
long ll_parent_row
string ls_display_style
integer li_constituent_count
string lsa_constituent[]
string lsa_where[]
string lsa_how[]
string lsa_group_sep[]
string lsa_title_sep[]
string lsa_item_sep[]
string ls_format_command
boolean lb_found
integer i
string ls_record_type

format_results = false

SetPointer(HourGlass!)

ll_count = rowcount()
li_sts = 0

puo_rtf.set_level(0)
puo_rtf.wrap_on()

ls_display_how = "R"
lb_found = false

ls_find = "observation_id='" + ps_observation_id + "'"
if not isnull(ps_location) then
	ls_find += " and location='" + ps_location + "'"
end if

if not isnull(pi_result_sequence) then
	ls_find += " and result_sequence=" + string(pi_result_sequence)
end if

// Add a check for the record type
if isnull(ps_location) and isnull(pi_result_sequence) then
	ls_find += " and (record_type='Root' OR record_type='Observation')"
else
	ls_find += " and record_type='Result'"
end if

ll_row = find(ls_find, 1, ll_count)
if ll_row > 0 then
	ls_record_type = object.record_type[ll_row]
	// If this is a result record, then get the parent record
	if lower(ls_record_type) = "result" then
		ll_parent_history_sequence = object.parent_history_sequence[ll_row]
		ll_parent_row = find("history_sequence=" + string(ll_parent_history_sequence), 1, ll_count)
	else
		ll_parent_row = ll_row
	end if
	if ll_parent_row > 0 then
		// get the display_style for the parent
		ls_display_style = object.display_style[ll_parent_row]
		// Parse the display_style
		li_constituent_count = parse_display_style(ls_display_style, &
																lsa_constituent, &
																lsa_where, &
																lsa_how, &
																lsa_group_sep, &
																lsa_title_sep, &
																lsa_item_sep, &
																ls_format_command)
		// Find the "R" constituent
		for i = 1 to li_constituent_count
			if lsa_constituent[i] = "R" then
				lb_found = true
				ls_group_sep = lsa_group_sep[i]
				ls_title_sep = lsa_title_sep[i]
				ls_item_sep = lsa_item_sep[i]
			end if
		next
	end if

	// If we didn't find a display style, then set the default separators
	if not lb_found then
		ls_group_sep = "; "
		ls_title_sep = ": "
		ls_item_sep = ", "
	end if

	if not isnull(pi_result_sequence) and not isnull(ps_location) then
		// If we're looking for a specific result and location then just display the result from this row.
		// If the amount_only flag is true, then assume print_location is false
		ls_result = result_for_row(ll_row, pb_display_result, pb_display_location, pb_display_unit)
		puo_rtf.add_text(ls_result)
	elseif not isnull(pi_result_sequence) then
		ls_result = results_for_result(ll_parent_history_sequence, pi_result_sequence, ps_abnormal_flag, li_severity, ls_item_sep)
		puo_rtf.add_text(ls_result)
	elseif not isnull(ps_location) then
		results_for_location(ll_parent_history_sequence, ps_result_type, ps_location, ps_abnormal_flag, li_severity, ls_item_sep, "", puo_rtf)
	else
		CHOOSE CASE upper(ps_result_type)
			CASE "PERFORM"
				display_results(ll_row, ps_result_type, true, ls_display_how, ps_abnormal_flag, ls_group_sep, ls_title_sep, ls_item_sep, puo_rtf)
			CASE "COLLECT"
				display_results(ll_row, ps_result_type, true, ls_display_how, ps_abnormal_flag, ls_group_sep, ls_title_sep, ls_item_sep, puo_rtf)
			CASE "COMMENT"
				display_comments(ll_row, true, ls_display_how, ps_abnormal_flag, false, puo_rtf)
			CASE "ATTACHMENT"
				display_comments(ll_row, true, ls_display_how, ps_abnormal_flag, true, puo_rtf)
			CASE "PROPERTY"
		END CHOOSE
	end if
end if

puo_rtf.wrap_off()

return li_sts


end function

public function integer display_observation_result (string ps_observation_id, string ps_result_type, string ps_abnormal_flag, string ps_location, integer pi_result_sequence, boolean pb_display_result, boolean pb_display_location, boolean pb_display_unit, u_rich_text_edit puo_rtf);u_text_rtf luo_rtf

luo_rtf = CREATE u_text_rtf

luo_rtf.rtf = puo_rtf

return display_observation_result(ps_observation_id, &
											ps_result_type, &
											ps_abnormal_flag, &
											ps_location, &
											pi_result_sequence, &
											pb_display_result, &
											pb_display_location, &
											pb_display_unit, &
											luo_rtf)

end function

public function integer display_observation_result (string ps_observation_id, string ps_result_type, string ps_abnormal_flag, string ps_location, integer pi_result_sequence, boolean pb_display_result, boolean pb_display_location, boolean pb_display_unit, ref string ps_text);u_text_text luo_rtf
integer li_sts

luo_rtf = CREATE u_text_text

if isnull(ps_text) then
	luo_rtf.text = ""
else
	luo_rtf.text = ps_text
end if

li_sts = display_observation_result(ps_observation_id, &
											ps_result_type, &
											ps_abnormal_flag, &
											ps_location, &
											pi_result_sequence, &
											pb_display_result, &
											pb_display_location, &
											pb_display_unit, &
											luo_rtf)

ps_text = luo_rtf.text

return li_sts

end function

private function string result_title_for_row (long pl_row);string ls_result
string ls_result_amount_flag
string ls_result_title
string ls_location_description
string ls_location
string ls_print_result_flag
string ls_null
string ls_default_view

setnull(ls_null)
ls_result_title = ""

if isnull(pl_row) or pl_row <= 0 then return ls_null

// Get the data
ls_result_amount_flag = object.result_amount_flag[pl_row]
ls_result = object.result[pl_row]
ls_location = object.location[pl_row]
ls_location_description = object.location_description[pl_row]
ls_print_result_flag = object.print_result_flag[pl_row]
ls_default_view = object.default_view[pl_row]


if f_string_to_boolean(ls_result_amount_flag) then
	// If we have an an amount then both the result and location can go in the result title
	
	// If the default view is "L"ocation, then swith the location description and result description
	if ls_default_view = "L" then
		// If we have a real location
		if ls_location <> "NA" and len(ls_location_description) > 0 then
			ls_result_title += ls_location_description
		end if
		
		// If we're supposed to print the result description
		if f_string_to_boolean(ls_print_result_flag) then
			if len(ls_result_title) > 0 then ls_result_title += ": "
			ls_result_title += ls_result
		end if
	else
		// If we're supposed to print the result description
		if f_string_to_boolean(ls_print_result_flag) then
			ls_result_title += ls_result
		end if
		
		// If we have a real location
		if ls_location <> "NA" and (len(ls_location_description) > 0) then
			if len(ls_result_title) > 0 then ls_result_title += ": "
			ls_result_title += ls_location_description
		end if
	end if
else
	// If there is no amount then we only have a title if there's both a result and a location
	if ls_location <> "NA" and (len(ls_location_description) > 0) and f_string_to_boolean(ls_print_result_flag) then
		if ls_default_view = "L" then
			ls_result_title = ls_location_description
		else
			ls_result_title = ls_result
		end if
	end if
end if

// If we don't have anything then return null
if trim(ls_result_title) = "" then setnull(ls_result_title)

return ls_result_title


end function

public function string result_value_for_row (long pl_row, boolean pb_display_unit);u_unit luo_unit
string ls_result_amount
string ls_find
string ls_result_unit
string ls_result
string ls_result_amount_flag
string ls_abnormal_flag
string ls_result_value
string ls_result_item
string ls_pretty_result
string ls_location_description
string ls_location
datetime ldt_result_date_time
string ls_print_result_flag
string ls_print_result_separator
string ls_unit_preference
string ls_display_mask
string ls_null
string ls_default_view
string ls_temp

setnull(ls_null)
ls_pretty_result = ""

if isnull(pl_row) or pl_row <= 0 then return ls_null

ldt_result_date_time = object.result_date_time[pl_row]
ls_result_amount_flag = object.result_amount_flag[pl_row]

// If the location is not applicable, then use the result description in the string construction
ls_result = object.result[pl_row]
ls_location = object.location[pl_row]
ls_location_description = object.location_description[pl_row]
ls_result_value = object.result_value[pl_row]
ls_result_unit = object.result_unit[pl_row]
ls_print_result_flag = object.print_result_flag[pl_row]
ls_print_result_separator = object.print_result_separator[pl_row]
ls_abnormal_flag = object.abnormal_flag[pl_row]
ls_unit_preference = object.unit_preference[pl_row]
ls_display_mask = object.display_mask[pl_row]
ls_default_view = object.default_view[pl_row]

if isnull(ls_print_result_separator) then ls_print_result_separator = "="


if f_string_to_boolean(ls_result_amount_flag) then
	// If we have an an amount then only the amount goes in the value
	if not isnull(ls_result_value) and trim(ls_result_value) <> "" then
		if formatted_numbers then
			luo_unit = unit_list.find_unit(ls_result_unit)
			if isnull(luo_unit) then
				ls_pretty_result = ""
			else
				if pb_display_unit then
					ls_pretty_result = luo_unit.pretty_amount_unit(ls_result_value, ls_unit_preference, ls_display_mask)
				else
					ls_pretty_result = luo_unit.pretty_amount(ls_result_value, ls_unit_preference, ls_display_mask)
				end if
			end if	
		else
			ls_pretty_result = ls_result_value
		end if
	end if
elseif f_string_to_boolean(ls_print_result_flag) then
	if ls_default_view = "R" &
	  and ls_location <> "NA" &
	  and len(ls_location_description) > 0 then
		ls_pretty_result = ls_location_description
	else
		ls_pretty_result = ls_result
	end if
elseif ls_location <> "NA" and len(ls_location_description) > 0 then
	ls_pretty_result = ls_location_description
else
	// If we get here then the only thing we can possibly print is the result, so
	// we'll ignore the print_result_flag and just print the result
	ls_pretty_result = ls_result
end if

// If we don't have anything then return null
if trim(ls_pretty_result) = "" then setnull(ls_pretty_result)

return ls_pretty_result

end function

public function string result_for_row (long pl_row, boolean pb_print_result, boolean pb_print_location, boolean pb_display_unit);string ls_result_value
string ls_pretty_result
string ls_print_result_separator
string ls_null

setnull(ls_null)
ls_pretty_result = ""

if isnull(pl_row) or pl_row <= 0 then return ls_null

ls_print_result_separator = object.print_result_separator[pl_row]

if isnull(ls_print_result_separator) then ls_print_result_separator = "="

// Get the result title
if pb_print_result then
	if pb_print_location then
		ls_pretty_result = result_title_for_row(pl_row)
	else
		if f_string_to_boolean(object.print_result_flag[pl_row]) then
			ls_pretty_result = object.result[pl_row]
		end if
	end if
elseif pb_print_location and string(object.location[pl_row]) <> "NA" then
	ls_pretty_result = object.location_description[pl_row]
end if

// Get the result value
ls_result_value = result_value_for_row(pl_row, pb_display_unit)

// If we have both a title and a value then seperate them with the seperator
if len(ls_pretty_result) > 0 then
	if len(ls_result_value) > 0 then
		ls_pretty_result += ls_print_result_separator + ls_result_value
	end if
else
	// If there's no title, then just print the result
	ls_pretty_result = ls_result_value
end if

// If we don't have anything then return null
if trim(ls_pretty_result) = "" then setnull(ls_pretty_result)

return ls_pretty_result

end function

public function integer display_audit (u_rich_text_edit puo_rtf);string ls_find
long ll_rowcount
long ll_row
long ll_parent_history_sequence
string ls_observation
string ls_in_context_flag
string ls_result
long ll_result_count
long ll_root_sequence
long ll_parent_sequence
string ls_record_type
string ls_parent_record_type
string lsa_observed_by[]
long ll_observed_by_count
string ls_observed_by
long ll_index
long i
long ll_comment_count
string lsa_comment[]
str_grid lstr_grid
long ll_last_root_sequence
string ls_root_description
boolean lb_in_context
str_service_info lstr_service
string ls_fieldtext
string ls_result_title
datetime ldt_result_date_time

ll_rowcount = rowcount()
ll_observed_by_count = 0
ll_comment_count = 0
lstr_grid.row_count = 0

ls_find = "record_type = 'Root'"
ll_row = find(ls_find, 1, ll_rowcount)
if ll_row > 0 then
	ls_root_description = object.observation_description[ll_row]
else
	return 0
end if

ls_find = "record_type IN ('Result', 'Comment')"
ll_row = find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	lstr_grid.row_count += 1
	
	// Figure out the observation description
	ls_observation = object.observation_description[ll_row]

	// Calculate Result
	ls_record_type = object.record_type[ll_row]
	if ls_record_type = "Result" then
		ls_result_title = result_title_for_row(ll_row)
		ls_result = result_value_for_row(ll_row, true)
		if len(ls_result_title) > 0 then
			if len(ls_observation) > 0 then ls_observation += ": "
			ls_observation += ls_result_title
		end if
	else
		ls_result_title = object.comment_title[ll_row]
		ls_result = object.comment[ll_row]
		if len(ls_result_title) > 0 then
			if len(ls_observation) > 0 then ls_observation += ": "
			ls_observation += ls_result_title
		end if
	end if

	lstr_grid.grid_row[lstr_grid.row_count].column[1].column_text = ls_observation
	lstr_grid.grid_row[lstr_grid.row_count].column[2].column_text = ls_result

	// Add the observed_by to the list and put the index into the results grid
	ls_observed_by = object.observed_by[ll_row]
	if len(ls_observed_by) > 0 then
		lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = user_list.user_full_name(ls_observed_by)
	else
		lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = "Unknown"
	end if
	
	ldt_result_date_time = object.result_date_time[ll_row]
	lstr_grid.grid_row[lstr_grid.row_count].column[4].column_text = string(ldt_result_date_time)
	
	ll_row = find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP



// Add data to grid structure
//lstr_grid.table_attributes = pstr_table_attributes
lstr_grid.table_attributes.bold_headings = true
lstr_grid.column_count = 4
lstr_grid.column_title[1] = "Observation"
lstr_grid.column_title[2] = "Result"
lstr_grid.column_title[3] = "Who"
lstr_grid.column_title[4] = "When"

// If there are any rows in the grid here, then display it
puo_rtf.add_text(ls_root_description)
puo_rtf.add_cr()
puo_rtf.add_grid(lstr_grid)

return lstr_grid.row_count



end function

public function str_pretty_results get_pretty_results (string ps_result_type, string ps_abnormal_flag);return get_pretty_results(ps_result_type, ps_abnormal_flag, 0)

end function

public function integer display_grid_lab (string ps_result_type, string ps_abnormal_flag, str_font_settings pstr_abnormal_font_settings, str_font_settings pstr_comment_font_settings, str_rtf_table_attributes pstr_table_attributes, u_rich_text_edit puo_rtf, boolean pb_show_actor_full, boolean pb_latest_root_only);string ls_find
u_ds_data luo_data
long ll_rowcount
long ll_row
long ll_root_sequence
string lsa_observed_by[]
long ll_observed_by_count
long ll_comment_count
string lsa_comment[]
str_grid lstr_grid
long ll_last_root_sequence
string ls_root_description
str_service_info lstr_service
string ls_fieldtext
string ls_grid_test_name
string ls_grid_result
string ls_unit
str_pretty_results lstr_results
string ls_observed_by
long i, j
long ll_index
long ll_root_observation_sequence
str_font_settings lstr_font_settings_save
str_property_value lstr_property_value
str_attributes lstr_attributes
date ld_min_result_date
date ld_max_result_date
string ls_date_suffix
date ld_temp_date
str_grid_row lstr_empty_row

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_results_grid_lab")

ll_rowcount = rowcount()
ll_observed_by_count = 0
ll_comment_count = 0


lstr_results = get_pretty_results(ps_result_type, ps_abnormal_flag)

for i = 1 to lstr_results.result_count
	// Create a new datastore row
	ll_row = luo_data.insertrow(0)
	
	// If the result is too long for the grid then display it below the grid
	ls_grid_result = lstr_results.result[i].result
	if len(ls_grid_result) > max_grid_result_length then
		ll_comment_count += 1
		lsa_comment[ll_comment_count] = ls_grid_result
		ls_grid_result = "See Below (#" + string(ll_comment_count) + ")"
	end if
	
	// put the test_name and result into the grid datastore
	luo_data.object.test_name[ll_row] = lstr_results.result[i].test_name
	luo_data.object.result[ll_row] = ls_grid_result
	luo_data.object.unit[ll_row] = lstr_results.result[i].unit
	
	// Transfer other data to results grid
	luo_data.object.abnormal_flag[ll_row] = lstr_results.result[i].abnormal_flag
	luo_data.object.abnormal_nature[ll_row] = lstr_results.result[i].abnormal_nature
	luo_data.object.normal_range[ll_row] = lstr_results.result[i].normal_range
	luo_data.object.result_date[ll_row] = date(lstr_results.result[i].result_date_time)
	
	// Transfer sort info
	luo_data.object.root_sequence[ll_row] = lstr_results.result[i].root_sequence
	luo_data.object.parent_sequence[ll_row] = lstr_results.result[i].parent_sequence
	luo_data.object.sort_sequence[ll_row] = lstr_results.result[i].sort_sequence
	
	// Add the observed_by to the list and put the index into the results grid
	ls_observed_by = lstr_results.result[i].observed_by
	if len(ls_observed_by) > 0 then
		ll_index = 0
		for j = 1 to ll_observed_by_count
			if ls_observed_by = lsa_observed_by[j] then
				ll_index = j
				exit
			end if
		next
		if ll_index = 0 then
			ll_observed_by_count += 1
			lsa_observed_by[ll_observed_by_count] = ls_observed_by
			ll_index = ll_observed_by_count
		end if
		
		luo_data.object.observed_by_index[ll_row] = Char(asc("A") + ll_index - 1)
	end if
next

luo_data.sort()

// Remove abnormal column and Who, add Unit column per Ciru 27/9/2025
// Add data to grid structure
lstr_grid.table_attributes = pstr_table_attributes
lstr_grid.table_attributes.bold_headings = true
lstr_grid.table_attributes.suppress_title_column = true
lstr_grid.column_count = 4
lstr_grid.column_title[1] = "Test Name"
lstr_grid.column_title[2] = "Result"
// lstr_grid.column_title[3] = "Abn"
lstr_grid.column_title[3] = "Unit"
lstr_grid.column_title[4] = "Ref Range"
// lstr_grid.column_title[5] = "Who"

lstr_grid.row_count = 0
ll_last_root_sequence = -1
setnull(ld_min_result_date)
setnull(ld_max_result_date)

// Loop through the results in the datastore and print a different grid for each root_sequence we encounter
for i = 1 to luo_data.rowcount()
	ll_root_sequence = luo_data.object.root_sequence[i]
	if ll_root_sequence <> ll_last_root_sequence then
		// If we're changing the root sequence, then display what we have and start a new grid
		if lstr_grid.row_count > 0 then
			if pb_latest_root_only then
				exit
			else
				// Append the min/max result dates to the root description
				ls_date_suffix = ""
				if not isnull(ld_min_result_date) then
					ls_date_suffix = string(ld_min_result_date)
				end if
				if not isnull(ld_max_result_date) and ld_max_result_date <> ld_min_result_date then
					ls_date_suffix += " - " + string(ld_max_result_date)
				end if
				if len(ls_date_suffix) > 0 then
					ls_root_description += "   " + ls_date_suffix
				end if
				
				puo_rtf.add_text(ls_root_description)
				puo_rtf.add_cr()
				puo_rtf.add_grid(lstr_grid)
				
				// Reset the min/max result dates
				setnull(ld_min_result_date)
				setnull(ld_max_result_date)
			end if
		end if
		
		ls_find = "history_sequence=" + string(ll_root_sequence)
		ll_row = find(ls_find, 1, ll_rowcount)
		if ll_row > 0 then
			ll_root_observation_sequence = object.observation_sequence[ll_row]
			ls_root_description = sqlca.fn_patient_object_description( current_patient.cpr_id, "Observation",ll_root_observation_sequence )
			if not tf_check() OR ISNULL(ls_root_description) OR trim(ls_root_description) = "" then
				ls_root_description = object.observation_description[ll_row]
			end if
		end if
		
		lstr_grid.row_count = 0
		ll_last_root_sequence = ll_root_sequence
	end if
	
	lstr_grid.row_count += 1
	lstr_grid.grid_row[lstr_grid.row_count] = lstr_empty_row  // reset row so data doesn't bleed over from previous root

	lstr_grid.grid_row[lstr_grid.row_count].column[1].column_text = luo_data.object.test_name[i]
	lstr_grid.grid_row[lstr_grid.row_count].column[2].column_text = luo_data.object.result[i]
	lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = luo_data.object.unit[i]
	if f_string_to_boolean(luo_data.object.abnormal_flag[i]) then
		lstr_grid.grid_row[lstr_grid.row_count].abnormal_flag = true
//		if len(string(luo_data.object.abnormal_nature[i])) > 0 then
//			lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = luo_data.object.abnormal_nature[i]
//		else
//			lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = luo_data.object.abnormal_flag[i]
//		end if
		lstr_grid.grid_row[lstr_grid.row_count].column[1].use_font_settings = true
		lstr_grid.grid_row[lstr_grid.row_count].column[1].font_settings = pstr_abnormal_font_settings
		lstr_grid.grid_row[lstr_grid.row_count].column[2].use_font_settings = true
		lstr_grid.grid_row[lstr_grid.row_count].column[2].font_settings = pstr_abnormal_font_settings
		lstr_grid.grid_row[lstr_grid.row_count].column[3].use_font_settings = true
		lstr_grid.grid_row[lstr_grid.row_count].column[3].font_settings = pstr_abnormal_font_settings
		lstr_grid.grid_row[lstr_grid.row_count].column[4].use_font_settings = true
		lstr_grid.grid_row[lstr_grid.row_count].column[4].font_settings = pstr_abnormal_font_settings
//		lstr_grid.grid_row[lstr_grid.row_count].column[5].use_font_settings = true
//		lstr_grid.grid_row[lstr_grid.row_count].column[5].font_settings = pstr_abnormal_font_settings
	end if
	lstr_grid.grid_row[lstr_grid.row_count].column[4].column_text = luo_data.object.normal_range[i]
//	lstr_grid.grid_row[lstr_grid.row_count].column[5].column_text = luo_data.object.observed_by_index[i]
	
	// Set min/max result date
	if luo_data.object.result_date[i] < ld_min_result_date or isnull(ld_min_result_date) then ld_min_result_date = luo_data.object.result_date[i]
	if luo_data.object.result_date[i] > ld_max_result_date or isnull(ld_max_result_date) then ld_max_result_date = luo_data.object.result_date[i]
next

// If there are any rows in the grid here, then display it
if lstr_grid.row_count > 0 then
	// Append the min/max result dates to the root description
	ls_date_suffix = ""
	if not isnull(ld_min_result_date) then
		ls_date_suffix = string(ld_min_result_date)
	end if
	if not isnull(ld_max_result_date) and ld_max_result_date <> ld_min_result_date then
		ls_date_suffix += " - " + string(ld_max_result_date)
	end if
	if len(ls_date_suffix) > 0 then
		ls_root_description += "   " + ls_date_suffix
	end if
	
	puo_rtf.add_text(ls_root_description)
	puo_rtf.add_cr()
	puo_rtf.add_grid(lstr_grid)
end if

// Get ready to display the comments section

// Start by setting the font different, if desired
lstr_font_settings_save = puo_rtf.get_font_settings()
puo_rtf.set_font_settings(pstr_comment_font_settings)

if ll_comment_count > 0 then
	for i = 1 to ll_comment_count
		puo_rtf.add_text("#" + string(i) + ":  " + lsa_comment[i])
		puo_rtf.add_cr()
		puo_rtf.add_cr()
	next
end if

// Add the list of observed-by entries, linking them to the "Show Actor" service
lstr_service.service = "Show Actor"
if ll_observed_by_count > 0 then
	puo_rtf.add_cr()
	puo_rtf.add_text("Who Produced These Results:")
	puo_rtf.add_cr()
	for i = 1 to ll_observed_by_count
		if pb_show_actor_full then
			// Add another blank line between multiple observes
			if i > 1 then puo_rtf.add_cr()
			puo_rtf.add_text(Char(asc("A") + i - 1) + ")  " + user_list.user_full_name(lsa_observed_by[i]))
			puo_rtf.add_cr()
			// Display Address
			lstr_property_value = f_edas_interpret_address( "actor(" +lsa_observed_by[i] + ").address" , &
																			f_get_complete_context(), &
																			lstr_attributes)
			if len(lstr_property_value.display_value) > 0 then
				puo_rtf.add_text(lstr_property_value.display_value)
				puo_rtf.add_cr()
			end if
			// Display Phone Number
			lstr_property_value = f_edas_interpret_address( "actor(" +lsa_observed_by[i] + ").PhoneNumber(-1)" , &
																			f_get_complete_context(), &
																			lstr_attributes)
			if len(lstr_property_value.display_value) > 0 then
				puo_rtf.add_text(lstr_property_value.display_value)
				puo_rtf.add_cr()
			end if
		else
			ls_fieldtext = Char(asc("A") + i - 1) + ")  " + user_list.user_full_name(lsa_observed_by[i])
			f_attribute_add_attribute(lstr_service.attributes, "user_id", lsa_observed_by[i])
			puo_rtf.add_field(ls_fieldtext, lstr_service)
			puo_rtf.add_cr()
		end if
	next
end if

// Finally restore the font_settings if we changed it
puo_rtf.set_font_settings(lstr_font_settings_save)


DESTROY u_ds_data

return 1


end function

public function str_grids get_grids (string ps_result_type, string ps_abnormal_flag, boolean pb_latest_root_only, long pl_max_result_length);string ls_find
u_ds_data luo_data
long ll_rowcount
long ll_row
long ll_root_sequence
string lsa_observed_by[]
long ll_observed_by_count
long ll_comment_count
string lsa_comment[]
str_grid lstr_grid
long ll_last_root_sequence
string ls_root_description
str_service_info lstr_service
string ls_fieldtext
string ls_grid_test_name
string ls_grid_result
str_pretty_results lstr_results
string ls_observed_by
long i, j
long ll_index
long ll_root_observation_sequence
str_font_settings lstr_font_settings_save
str_property_value lstr_property_value
str_attributes lstr_attributes
date ld_min_result_date
date ld_max_result_date
string ls_date_suffix
date ld_temp_date
str_grid_row lstr_empty_row
str_grids lstr_return_grids

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_results_grid_lab")

ll_rowcount = rowcount()
ll_observed_by_count = 0
ll_comment_count = 0


lstr_results = get_pretty_results(ps_result_type, ps_abnormal_flag)

for i = 1 to lstr_results.result_count
	// Create a new datastore row
	ll_row = luo_data.insertrow(0)
	
	// If the result is too long for the grid then display it below the grid
	ls_grid_result = lstr_results.result[i].result
	if len(ls_grid_result) > pl_max_result_length and pl_max_result_length > 0 then
		ll_comment_count += 1
		lsa_comment[ll_comment_count] = ls_grid_result
		ls_grid_result = "See Below (#" + string(ll_comment_count) + ")"
	end if
	
	// put the test_name and result into the grid datastore
	luo_data.object.test_name[ll_row] = lstr_results.result[i].test_name
	luo_data.object.result[ll_row] = left(ls_grid_result, 32000)
	
	// Transfer other data to results grid
	luo_data.object.abnormal_flag[ll_row] = lstr_results.result[i].abnormal_flag
	luo_data.object.abnormal_nature[ll_row] = lstr_results.result[i].abnormal_nature
	luo_data.object.normal_range[ll_row] = lstr_results.result[i].normal_range
	luo_data.object.result_date[ll_row] = date(lstr_results.result[i].result_date_time)
	
	// Transfer sort info
	luo_data.object.root_sequence[ll_row] = lstr_results.result[i].root_sequence
	luo_data.object.parent_sequence[ll_row] = lstr_results.result[i].parent_sequence
	luo_data.object.sort_sequence[ll_row] = lstr_results.result[i].sort_sequence
	
	// Add the observed_by to the list and put the index into the results grid
	ls_observed_by = lstr_results.result[i].observed_by
	if len(ls_observed_by) > 0 then
		ll_index = 0
		for j = 1 to ll_observed_by_count
			if ls_observed_by = lsa_observed_by[j] then
				ll_index = j
				exit
			end if
		next
		if ll_index = 0 then
			ll_observed_by_count += 1
			lsa_observed_by[ll_observed_by_count] = ls_observed_by
			ll_index = ll_observed_by_count
		end if
		
		luo_data.object.observed_by_index[ll_row] = Char(asc("A") + ll_index - 1)
	end if
next

luo_data.sort()


// Add data to grid structure
lstr_grid.table_attributes.bold_headings = true
lstr_grid.table_attributes.suppress_title_column = true
lstr_grid.column_count = 5
lstr_grid.column_title[1] = "Test Name"
lstr_grid.column_title[2] = "Result"
lstr_grid.column_title[3] = "Abn"
lstr_grid.column_title[4] = "Normal Range"
lstr_grid.column_title[5] = "Who"

lstr_grid.row_count = 0
ll_last_root_sequence = -1
setnull(ld_min_result_date)
setnull(ld_max_result_date)

// Loop through the results in the datastore and print a different grid for each root_sequence we encounter
for i = 1 to luo_data.rowcount()
	ll_root_sequence = luo_data.object.root_sequence[i]
	if ll_root_sequence <> ll_last_root_sequence then
		// If we're changing the root sequence, then display what we have and start a new grid
		if lstr_grid.row_count > 0 then
			if pb_latest_root_only then
				exit
			else
				// Append the min/max result dates to the root description
				ls_date_suffix = ""
				if not isnull(ld_min_result_date) then
					ls_date_suffix = string(ld_min_result_date)
				end if
				if not isnull(ld_max_result_date) and ld_max_result_date <> ld_min_result_date then
					ls_date_suffix += " - " + string(ld_max_result_date)
				end if
				if len(ls_date_suffix) > 0 then
					ls_root_description += "   " + ls_date_suffix
				end if
				
				lstr_grid.description = ls_root_description
				lstr_return_grids.grid_count++
				lstr_return_grids.grid[lstr_return_grids.grid_count] = lstr_grid
				
				// Reset the min/max result dates
				setnull(ld_min_result_date)
				setnull(ld_max_result_date)
			end if
		end if
		
		ls_find = "history_sequence=" + string(ll_root_sequence)
		ll_row = find(ls_find, 1, ll_rowcount)
		if ll_row > 0 then
			ll_root_observation_sequence = object.observation_sequence[ll_row]
			ls_root_description = sqlca.fn_patient_object_description( current_patient.cpr_id, "Observation",ll_root_observation_sequence )
			if not tf_check() OR ISNULL(ls_root_description) OR trim(ls_root_description) = "" then
				ls_root_description = object.observation_description[ll_row]
			end if
		end if
		
		lstr_grid.row_count = 0
		ll_last_root_sequence = ll_root_sequence
	end if
	
	lstr_grid.row_count += 1
	lstr_grid.grid_row[lstr_grid.row_count] = lstr_empty_row  // reset row so data doesn't bleed over from previous root

	lstr_grid.grid_row[lstr_grid.row_count].column[1].column_text = luo_data.object.test_name[i]
	lstr_grid.grid_row[lstr_grid.row_count].column[2].column_text = luo_data.object.result[i]
	if f_string_to_boolean(luo_data.object.abnormal_flag[i]) then
		lstr_grid.grid_row[lstr_grid.row_count].abnormal_flag = true
		if len(string(luo_data.object.abnormal_nature[i])) > 0 then
			lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = luo_data.object.abnormal_nature[i]
		else
			lstr_grid.grid_row[lstr_grid.row_count].column[3].column_text = luo_data.object.abnormal_flag[i]
		end if
	end if
	lstr_grid.grid_row[lstr_grid.row_count].column[4].column_text = luo_data.object.normal_range[i]
	lstr_grid.grid_row[lstr_grid.row_count].column[5].column_text = luo_data.object.observed_by_index[i]
	
	// Set min/max result date
	if luo_data.object.result_date[i] < ld_min_result_date or isnull(ld_min_result_date) then ld_min_result_date = luo_data.object.result_date[i]
	if luo_data.object.result_date[i] > ld_max_result_date or isnull(ld_max_result_date) then ld_max_result_date = luo_data.object.result_date[i]
next

// If there are any rows in the grid here, then display it
if lstr_grid.row_count > 0 then
	// Append the min/max result dates to the root description
	ls_date_suffix = ""
	if not isnull(ld_min_result_date) then
		ls_date_suffix = string(ld_min_result_date)
	end if
	if not isnull(ld_max_result_date) and ld_max_result_date <> ld_min_result_date then
		ls_date_suffix += " - " + string(ld_max_result_date)
	end if
	if len(ls_date_suffix) > 0 then
		ls_root_description += "   " + ls_date_suffix
	end if
	
	lstr_grid.description = ls_root_description
	lstr_return_grids.grid_count++
	lstr_return_grids.grid[lstr_return_grids.grid_count] = lstr_grid
end if

// Get ready to display the comments section

// Set the long results if any
lstr_return_grids.long_result_count = ll_comment_count
lstr_return_grids.long_result = lsa_comment

// Set the observed_by if any
lstr_return_grids.observed_by_count = ll_observed_by_count
lstr_return_grids.observed_by = lsa_observed_by


DESTROY u_ds_data

return lstr_return_grids


end function

public function str_pretty_results get_pretty_results (string ps_result_type, string ps_abnormal_flag, long pl_parent_sequence);string ls_find
long ll_rowcount
long ll_row
long ll_parent_history_sequence
long ll_obsrow
string ls_observation
string ls_in_context_flag
string ls_result
string ls_unit
long ll_result_count
long ll_root_sequence
long ll_parent_sequence
string ls_record_type
string ls_parent_record_type
string lsa_observed_by[]
long ll_observed_by_count
string ls_observed_by
long ll_index
long i
long ll_comment_count
string lsa_comment[]
str_grid lstr_grid
long ll_last_root_sequence
string ls_root_description
boolean lb_in_context
str_service_info lstr_service
string ls_fieldtext
string ls_result_title
string ls_grid_test_name
string ls_grid_result
str_pretty_results lstr_results
boolean lb_skip
string ls_sep
long ll_1st_level_history_sequence
string ls_parent_observation_description

ll_rowcount = rowcount()
ll_observed_by_count = 0
ll_comment_count = 0
ll_result_count = 0

ls_find = "record_type IN ('Result', 'Comment')"
if ps_abnormal_flag = "Y" then
	ls_find += " and abnormal_flag='Y'"
end if
ll_row = find(ls_find, 1, ll_rowcount)
DO WHILE ll_row > 0 and ll_row <= ll_rowcount
	
	// Figure out the observation description
	ls_observation = ""
	ll_obsrow = ll_row
	ll_root_sequence = -1
	lb_in_context = true
	
	// Follow the result up to the root
	DO WHILE ll_obsrow > 0
		ll_1st_level_history_sequence = object.history_sequence[ll_obsrow]
		ls_parent_observation_description = object.observation_description[ll_obsrow]
		ll_parent_history_sequence = object.parent_history_sequence[ll_obsrow]
		if isnull(ll_parent_history_sequence) or ll_parent_history_sequence <= 0 then exit
		
		ll_obsrow = find("history_sequence=" + string(ll_parent_history_sequence), 1, ll_rowcount)
		if ll_obsrow > 0 then
			// Stop when we hit the root
			ls_parent_record_type = object.record_type[ll_obsrow]
			if ls_parent_record_type = "Root" then
				// When we find the root we're done
				ll_root_sequence = ll_parent_history_sequence
				ls_root_description = object.observation_description[ll_obsrow]
				exit
			end if
			
			if lb_in_context then
				// Construct the observation description
				if ls_observation = "" then
					ls_observation = object.observation_description[ll_obsrow]
				else
					ls_observation = object.observation_description[ll_obsrow] + ": " + ls_observation
				end if
				
				// If we hit an observation_description with in_context_flag = "N", then stop constructing the observation
				lb_in_context = f_string_to_boolean(object.in_context_flag[ll_obsrow])
			end if
		else
			exit
		end if
	LOOP


	// If we didn't find the root observation for this result, then it's a malformed tree so skip the result
	if ll_root_sequence >= 0 then
		// Calculate Result title and result
		ls_record_type = object.record_type[ll_row]
		if ls_record_type = "Result" then
			ls_result_title = result_title_for_row(ll_row)
			ls_result = result_value_for_row(ll_row, true)
			ls_unit = unit_value_for_row(ll_row)
			ls_observed_by = object.observed_by[ll_row]
		else
			ls_result_title = object.comment_title[ll_row]
			if isnull(ls_result_title) or trim(ls_result_title) = "" then
				ls_result_title = "Comment"
			end if
			ls_result = object.comment[ll_row]
			ls_unit = ""
			ls_observed_by = object.comment_user_id[ll_row]
		end if
	
	
		// OK, we have 4 data elements and two cells to put them in.  The elements are, from left to right:
		//		1 root observation description
		//		2 observation description
		//		3 result title
		//		4 result
		//
		// Here are the rules
		// 1) if the result is present then it goes in the result cell
		//		a) if there is both an observation and result_title and they are not
		//			the same, then concatenate them together into the test_name cell.
		//		b) Otherwise, put which ever value is present into the test_name cell.
		//		c) If neither the result_title nor observation are present, then put the root observation into the test_name cell
		// 2) if the result is missing then the result_title goes into the result cell
		//		a) if the observation is present then it goes into the test_name cell
		//		b) if the observation is missing then the root observation goes into the test_name cell
		// 3) if both the result_title and result are missing, then skip the row
		//
		ls_grid_result = ""
		ls_grid_test_name = ""
		ls_sep = ": "
		// trim the observation
		ls_observation = trim(ls_observation)
		if right(ls_observation, 1) = ":" then
			ls_observation = left(ls_observation, len(ls_observation) - 1)
		end if
		if len(ls_result) > 0 then
			ls_grid_result = ls_result
			if len(ls_result_title) > 0 then
				if len(ls_observation) > 0 and ls_observation <> ls_result_title then
					// Check for some common redundancies
					lb_skip = false
					if pos(lower(ls_observation), "comment") > 0 and left(lower(ls_result_title), 7) = "comment" then
						lb_skip = true
					end if
					
					if lb_skip then
						ls_grid_test_name = ls_observation
					else
						ls_grid_test_name = ls_observation + ls_sep + ls_result_title
					end if
				else
					ls_grid_test_name = ls_result_title
				end if
			elseif len(ls_observation) > 0 then
				ls_grid_test_name = ls_observation
			else
				ls_grid_test_name = ls_root_description
			end if
		elseif len(ls_result_title) > 0 then
			ls_grid_result = ls_result_title
			if len(ls_observation) > 0 then
				ls_grid_test_name = ls_observation
			else
				ls_grid_test_name = ls_root_description
			end if
		end if
	
		// If we have a grid result then post it into the results datastore
		if len(ls_grid_result) > 0 and (isnull(pl_parent_sequence) or pl_parent_sequence <= 1 or pl_parent_sequence = ll_1st_level_history_sequence) then
			// Create a new datastore row
			ll_result_count += 1
			
			// put the key into the results datastore
			lstr_results.result[ll_result_count].cpr_id = current_patient.cpr_id
			lstr_results.result[ll_result_count].observation_sequence = object.observation_sequence[ll_row]
			lstr_results.result[ll_result_count].location_result_sequence = object.location_result_sequence[ll_row]

			// put the test_name and result into the results datastore
			lstr_results.result[ll_result_count].test_name = ls_grid_test_name
			lstr_results.result[ll_result_count].result = ls_grid_result
			lstr_results.result[ll_result_count].unit = ls_unit
			
			// Transfer other data to results grid
			lstr_results.result[ll_result_count].abnormal_flag = object.abnormal_flag[ll_row]
			lstr_results.result[ll_result_count].abnormal_nature = object.abnormal_nature[ll_row]
			lstr_results.result[ll_result_count].normal_range = object.normal_range[ll_row]
			lstr_results.result[ll_result_count].observed_by = ls_observed_by
			lstr_results.result[ll_result_count].result_date_time = object.result_date_time[ll_row]
			
			// Sorting fields
			lstr_results.result[ll_result_count].root_sequence = ll_root_sequence
			lstr_results.result[ll_result_count].parent_sequence = ll_1st_level_history_sequence
			lstr_results.result[ll_result_count].parent_observation_description = ls_parent_observation_description
			lstr_results.result[ll_result_count].sort_sequence = object.history_sequence[ll_row]
		end if
	end if

	// Get the next result/comment record
	ll_row = find(ls_find, ll_row + 1, ll_rowcount + 1)
LOOP

lstr_results.result_count = ll_result_count

return lstr_results



end function

public function string unit_value_for_row (long pl_row);u_unit luo_unit
string ls_find
string ls_result_unit
string ls_result_value
string ls_pretty_result
//string ls_unit_preference
string ls_null

setnull(ls_null)
ls_pretty_result = ""

if isnull(pl_row) or pl_row <= 0 then return ls_null

// If the location is not applicable, then use the result description in the string construction
ls_result_value = object.result_value[pl_row] // needed to determine wheter to add plural designation s or ies
ls_result_unit = object.result_unit[pl_row]
// unit_preference is either METRIC or ENGLISH (reference luo_unit.pretty_amount_unit)
// not used here, we are only wanting the unit as recorded
// ls_unit_preference = object.unit_preference[pl_row]

luo_unit = unit_list.find_unit(ls_result_unit)
if isnull(luo_unit) then
	ls_pretty_result = ""
else
	ls_pretty_result = luo_unit.pretty_unit(ls_result_value)
end if	

// If we don't have anything then return null
if trim(ls_pretty_result) = "" then setnull(ls_pretty_result)

return ls_pretty_result

end function

on u_ds_observation_results.create
call super::create
end on

on u_ds_observation_results.destroy
call super::destroy
end on

event constructor;call super::constructor;string ls_default_display_style

if len(common_thread.default_display_style) > 0 then
	ls_default_display_style = common_thread.default_display_style
else
	ls_default_display_style = "OBO; %: %, |RRR; %: %, |CBN; %: %, "
end if 

default_constituent_count = parse_display_style(ls_default_display_style, &
																default_constituent, &
																default_where, &
																default_how, &
																default_group_separator, &
																default_title_separator, &
																default_item_separator, &
																default_format_command)



end event

event retrieveend;call super::retrieveend;long i
long ll_history_sequence
long ll_parent_history_sequence
boolean lba_parents[10000]

for i = rowcount to 1 step -1
	ll_history_sequence = object.history_sequence[i]
	ll_parent_history_sequence = object.parent_history_sequence[i]
	
	CHOOSE CASE lower(string(object.record_type[i]))
		CASE "root", "observation"
			if ll_history_sequence > 0 then
				any_results[i] = lba_parents[ll_history_sequence]
			else
				any_results[i] = false
			end if
			
			if ll_parent_history_sequence > 0 and any_results[i] then
				lba_parents[ll_parent_history_sequence] = true
			end if
		CASE "result", "comment"
			any_results[i] = true
			if ll_history_sequence > 0 then
				any_results[ll_history_sequence] = true
			end if
			
			if ll_parent_history_sequence > 0 then
				lba_parents[ll_parent_history_sequence] = true
			end if
	END CHOOSE
next

end event

