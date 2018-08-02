$PBExportHeader$u_dw_observation_grid.sru
forward
global type u_dw_observation_grid from u_dw_pick_list
end type
type str_vital_observation from structure within u_dw_observation_grid
end type
end forward

type str_vital_observation from structure
	string		description
	string		observation_id
	string		location
	integer		result_sequence
	string		location_2
	integer		result_sequence_2
	string		collection_location_domain
end type

global type u_dw_observation_grid from u_dw_pick_list
integer width = 2615
integer height = 1036
string dataobject = "dw_observation_grid_edit"
event source_connected ( u_component_observation puo_observation )
event source_disconnected ( u_component_observation puo_observation )
end type
global u_dw_observation_grid u_dw_observation_grid

type variables
u_component_service service
u_component_treatment treatment

long root_observation_sequence
string root_observation_id

// These variables hold the set of external sources which might
// relate to this composite observation
integer source_count
u_component_observation sources[]

integer observation_count
integer observation_count_max = 4


// These arrays describe the simple observations displayed
// in the grid columns
string observation_id[]
integer child_ordinal[]
string observation_tag[]
integer result_sequence[]
string location[]
string display_unit_id[]

// This array holds a pointer for each column to it's corresponding
// external source, if any.
u_component_observation external_source[]


integer rows_per_page

// Comment constants
string comment_title = "Comment"
string comment_abnormal_flag = "N"
integer comment_severity = 0

end variables

forward prototypes
public function integer update_row (long pl_row, integer pi_column, string ps_new_value)
public function integer results_posted (u_component_observation puo_external_observation)
public function long observation_sequence (long pl_row, integer pi_column)
public subroutine load_page (integer pl_page)
public subroutine shutdown ()
public function integer load ()
public function integer initialize (u_component_service puo_service)
public function long parent_observation_sequence (long pl_row)
end prototypes

event source_connected;integer i
long ll_color

ll_color = rgb(64,255,64)

for i = 1 to observation_count
	if puo_observation.external_source = external_source[i].external_source then
		CHOOSE CASE i
			CASE 1
				object.l_1.pen.color = ll_color
			CASE 2
				object.l_2.pen.color = ll_color
			CASE 3
				object.l_3.pen.color = ll_color
			CASE 4
				object.l_4.pen.color = ll_color
		END CHOOSE
	end if
next


end event

event source_disconnected;integer i
long ll_color

ll_color = rgb(255,0,0)

for i = 1 to observation_count
	if puo_observation.external_source = external_source[i].external_source then
		CHOOSE CASE i
			CASE 1
				object.l_1.pen.color = ll_color
			CASE 2
				object.l_2.pen.color = ll_color
			CASE 3
				object.l_3.pen.color = ll_color
			CASE 4
				object.l_4.pen.color = ll_color
		END CHOOSE
	end if
next


end event

public function integer update_row (long pl_row, integer pi_column, string ps_new_value);integer li_sts
long ll_observation_sequence
datetime ldt_result_date_time
string ls_abnormal_flag
string ls_abnormal_nature

ldt_result_date_time = datetime(today(), now())
setnull(ls_abnormal_flag)
setnull(ls_abnormal_nature)

// Get the observation_sequence
ll_observation_sequence = observation_sequence(pl_row, pi_column)
if ll_observation_sequence < 0 then
	log.log(this, "u_dw_observation_grid.update_row.0014", "Error adding observation", 4)
	return -1
end if

// Add the new value to the database
li_sts = treatment.add_result(ll_observation_sequence, &
										result_sequence[pi_column], &
										location[pi_column], &
										ldt_result_date_time, &
										ps_new_value, &
										display_unit_id[pi_column], &
										ls_abnormal_flag, &
										ls_abnormal_nature )
if li_sts <= 0 then return -1


return 1


end function

public function integer results_posted (u_component_observation puo_external_observation);integer i
long ll_rows
string ls_find
integer li_result_sequence
integer li_result_sequence_2
long ll_row
integer j
integer r
string ls_location
string ls_which
long ll_observation_sequence
integer li_sts
string ls_result_amount_flag
string ls_manual_override

ll_rows = rowcount()


//// For each observation in received from the external source
//for i = 1 to puo_external_observation.observation_count
//	// For each row in the datawindow which matches the external observation_id
//	ls_find = "observation_id='" + puo_external_observation.observations[i].observation_id + "'"
//	ll_row = find(ls_find, 1, ll_rows)
//	DO WHILE ll_row > 0 and ll_row <= ll_rows
//		ls_location = object.location[ll_row]
//		li_result_sequence = object.result_sequence[ll_row]
//		li_result_sequence_2 = object.result_sequence_2[ll_row]
//		
//		// If this row has already been entered manually, then skip it
//		ls_manual_override = object.manual_override[ll_row]
//		if ls_manual_override = "N" then
//			// Since we just got results for this row, the external source must be connected
//			object.connected[ll_row] = "Y"
//			
//			ls_result_amount_flag = object.result_amount_flag[ll_row]
//			ll_observation_sequence = observation_sequence(ll_row)
//			if ll_observation_sequence < 0 then
//				log.log(this, "u_dw_observation_grid.update_row.0014", "Error adding observation", 4)
//				return -1
//			end if
//	
//			// Loop through the results
//			for j = 1 to puo_external_observation.observations[i].result_count
//				// If the result needs an amount and it's a perform result then look
//				// to see if it goes in one of the display fields
//				if ls_result_amount_flag = "Y" &
//				  and puo_external_observation.observations[i].result[j].result_type = "PERFORM" then
//					// Make sure the location matches
//					if isnull(ls_location) or (puo_external_observation.observations[i].result[j].location = ls_location) then
//						// Make sure the new result is either result_sequence or result_sequence_2
//						if puo_external_observation.observations[i].result[j].result_sequence = li_result_sequence &
//						 or puo_external_observation.observations[i].result[j].result_sequence = li_result_sequence_2 then
//							// Post the new result
//							update_row(ll_row, &
//											puo_external_observation.observations[i].result[j].result_sequence, &
//											puo_external_observation.observations[i].result[j].location, &
//											puo_external_observation.observations[i].result[j].result_value, &
//											puo_external_observation.observations[i].result[j].result_unit, &
//											puo_external_observation.observations[i].result[j].result_date_time, &
//											puo_external_observation.observations[i].result[j].abnormal_flag, &
//											puo_external_observation.observations[i].result[j].abnormal_nature)
//						end if
//					end if
//				else
//					// If we're not looking for a specific result, or if we have a COLLECT result,
//					// then just add it
//					li_sts = treatment.add_result(ll_observation_sequence, &
//															puo_external_observation.observations[i].result[j].result_sequence, &
//															puo_external_observation.observations[i].result[j].location, &
//															puo_external_observation.observations[i].result[j].result_date_time, &
//															puo_external_observation.observations[i].result[j].result_value, &
//															puo_external_observation.observations[i].result[j].result_unit, &
//															puo_external_observation.observations[i].result[j].abnormal_flag, &
//															puo_external_observation.observations[i].result[j].abnormal_nature)
//					if li_sts <= 0 then return -1
//				end if
//			next
//			
//			// refresh the row to display the updates
////			refresh_row(ll_row)
//		end if
//		
//		ll_row = find(ls_find, ll_row + 1, ll_rows + 1)
//	LOOP
//next
//


return 1

end function

public function long observation_sequence (long pl_row, integer pi_column);long ll_parent_observation_sequence
long ll_observation_sequence
long ll_stage
string ls_stage_description
string ls_observation_tag

setnull(ls_observation_tag)
ll_stage = object.stage[pl_row]
ls_stage_description = object.stage_description[pl_row]

// First make sure the row has an observation_sequence
ll_parent_observation_sequence = parent_observation_sequence(pl_row)
if ll_parent_observation_sequence <= 0 then return -1

// Then make sure the column has an observation_sequence
ll_observation_sequence = getitemnumber(pl_row, "observation_sequence_" + string(pi_column))
if isnull(ll_observation_sequence) then
	// We don't have an observation record yet, so create one
	ll_observation_sequence = treatment.add_observation_stage(ll_parent_observation_sequence, &
										observation_id[pi_column], &
										child_ordinal[pi_column], &
										observation_tag[pi_column], &
										ll_stage, &
										ls_stage_description, &
										true)
	if ll_observation_sequence < 0 then
		log.log(this, "u_dw_observation_grid.update_row.0014", "Error adding observation", 4)
		return -1
	end if
	setitem(pl_row, "observation_sequence_" + string(pi_column), ll_observation_sequence)
end if

return ll_observation_sequence

end function

public subroutine load_page (integer pl_page);long ll_rows

if isnull(pl_page) or pl_page <= 0 then return

if isnull(rows_per_page) or rows_per_page <= 0 then
	reset()
	// If we don't know how many rows are on each page then load the first page
	DO
		ll_rows = insertrow(0)
		object.stage[ll_rows] = ll_rows - 1
		object.stage_description[ll_rows] = datalist.stage_description(root_observation_id, ll_rows - 1)
		rows_per_page = integer(object.DataWindow.LastRowOnPage)
		last_page = 1
	LOOP UNTIL rows_per_page < ll_rows
	
	// Remove the last row because it's off the page
	deleterow(ll_rows)
	ll_rows -= 1
	current_page = 1
end if

ll_rows = rowcount()

// Add the necessary rows to get the desired number of pages
DO WHILE ll_rows < (pl_page * rows_per_page)
	ll_rows = insertrow(0)
	object.stage[ll_rows] = ll_rows - 1
	object.stage_description[ll_rows] = datalist.stage_description(root_observation_id, ll_rows - 1)
LOOP

if last_page < pl_page then last_page = pl_page

end subroutine

public subroutine shutdown ();
f_destroy_observation_sources(source_count, sources)

end subroutine

public function integer load ();long i, j
long ll_child
long ll_result
long ll_null
string ls_result
string ls_result_amount_flag
long ll_rows
str_p_observation_stages lstr_stages
str_p_observation_stage  lstr_stage
integer li_count
string ls_result_value
string ls_result_unit
string ls_location
integer li_result_sequence
string ls_suffix
u_unit luo_unit
long ll_row
long ll_needed_page
str_observation_comment lstr_comment
integer li_sts
boolean lb_found
long ll_child_observation_sequence

setnull(ll_null)

// First load the first page
load_page(1)

li_count = treatment.get_stage_observations(root_observation_sequence, lstr_stages)
ll_rows = rowcount()

for i = 1 to lstr_stages.stage_count
	lstr_stage = lstr_stages.observation_stage[i]
	ll_row = lstr_stage.stage + 1
	ll_needed_page = ll_row / rows_per_page
	if (ll_needed_page * rows_per_page) < ll_row then ll_needed_page += 1
	
	// First, make sure we have enough pages loaded
	load_page(ll_needed_page)
	
	object.parent_observation_sequence[ll_row] = lstr_stage.parent_observation.observation_sequence

	// Load the comment, if any
	li_sts = treatment.get_comment(lstr_stage.parent_observation.observation_sequence, comment_title, lstr_comment)
	if li_sts > 0 then
		object.comments[ll_row] = lstr_comment.comment
	end if

	// Then, loop through the columns and see if there are any applicable results
	for j = 1 to observation_count
		ls_suffix = "_" + string(j)
		setnull(ls_result_value)
		setnull(ls_result_unit)
		setnull(ls_location)
		setnull(li_result_sequence)
		setnull(ll_child_observation_sequence)
		lb_found = false
		for ll_child = 1 to lstr_stage.child_observation_count
			// See if this child matches this column
			if lstr_stage.child_observation[ll_child].observation_id = observation_id[j] then
				// If the child observation matches the column, then see if any of the
				// results match this column
				for ll_result = 1 to lstr_stage.child_observation[ll_child].result_count
					// See if the result_sequence and location matches
					if lstr_stage.child_observation[ll_child].results[ll_result].result_sequence <> result_sequence[j] then continue
					if lstr_stage.child_observation[ll_child].results[ll_result].location <> location[j] then continue
	
					// Found a relevent result
					li_result_sequence = lstr_stage.child_observation[ll_child].results[ll_result].result_sequence
					ls_location = lstr_stage.child_observation[ll_child].results[ll_result].location
					ls_result_value = lstr_stage.child_observation[ll_child].results[ll_result].result_value
					ls_result_unit = lstr_stage.child_observation[ll_child].results[ll_result].result_unit
					ll_child_observation_sequence = lstr_stage.child_observation[ll_child].observation_sequence
					lb_found = true
					exit
				next
			end if
			if lb_found then exit
		next
		
		// If we found a result then display it
		if not isnull(li_result_sequence) then
			luo_unit = unit_list.find_unit(ls_result_unit)
			if isnull(luo_unit) then continue

			ls_result = luo_unit.convert(display_unit_id[j], ls_result_value)

			setitem(ll_row, "result" + ls_suffix, ls_result)
			setitem(ll_row, "observation_sequence" + ls_suffix, ll_child_observation_sequence)
		end if
	next
next

return 1


end function

public function integer initialize (u_component_service puo_service);boolean lb_external
long ll_row
integer i, j
string ls_composite_flag
string ls_external_observation
string ls_description
integer li_lastrow
integer li_result_sequence
string ls_location
str_observation_tree lstr_tree
str_c_observation_result lstr_result
long ll_stage_description_count

if isnull(puo_service.treatment) then
	log.log(this, "u_dw_observation_grid.initialize.0015", "Null treatment object", 4)
	return -1
end if

service = puo_service
treatment = service.treatment

root_observation_id = service.root_observation_id()
if isnull(root_observation_id) then
	log.log(this, "u_dw_observation_grid.initialize.0015", "No Root Observation_id", 4)
	return -1
end if

root_observation_sequence = service.get_root_observation()
if isnull(root_observation_sequence) then
	log.log(this, "u_dw_observation_grid.initialize.0015", "Error getting root observation", 4)
	return -1
end if

// First, get any applicable external sources and set their display windows
source_count = f_get_observation_sources(root_observation_id, sources)
for j = 1 to source_count
	sources[j].display_window = parent
next

ls_composite_flag = datalist.observation_composite_flag(root_observation_id)
if isnull(ls_composite_flag) or ls_composite_flag <> "Y" then
	log.log(this, "u_dw_observation_grid.initialize.0015", "Parent observation not composite (" + root_observation_id + ")", 4)
	return -1
end if

lstr_tree = datalist.observation_tree(root_observation_id)
if lstr_tree.branch_count <= 0 then
	log.log(this, "u_dw_observation_grid.initialize.0015", "No children found (" + root_observation_id + ")", 4)
	return -1
end if

observation_count = 0

for i = 1 to lstr_tree.branch_count
	li_result_sequence = lstr_tree.branch[i].result_sequence
	ls_location = lstr_tree.branch[i].location
	
	// We will only display simple children where both the result_sequence
	// and location are specified
	if isnull(li_result_sequence) or isnull(ls_location) then continue
	
	observation_count += 1
	
	observation_id[observation_count] = lstr_tree.branch[i].child_observation_id
	result_sequence[observation_count] = li_result_sequence
	location[observation_count] = ls_location
	observation_tag[observation_count] = lstr_tree.branch[i].observation_tag
	
	// Set the display unit to the result_unit
	lstr_result = datalist.observation_result(lstr_tree.branch[i].child_observation_id, li_result_sequence)
	display_unit_id[observation_count] = lstr_result.result_unit
	
	// Calculate the child_ordinal
	child_ordinal[observation_count] = 1
	for j = observation_count - 1 to 1 step -1
		if observation_id[observation_count] = observation_id[j] then
			child_ordinal[observation_count] = child_ordinal[j] + 1
			exit
		end if
	next
	
	ls_description = lstr_tree.branch[i].description
	
	// Check for an external source
	lb_external = false
	for j = 1 to source_count
		ls_external_observation = datalist.external_observation(sources[j].external_source, observation_id[observation_count])
		if not isnull(ls_external_observation) then
			external_source[observation_count] = sources[j]
			lb_external = true
		end if
	next

	// Set the column titles
	CHOOSE CASE observation_count
		CASE 1
			object.t_1.text = ls_description
			if lb_external then
				object.l_1.visible = 1
			else
				object.l_1.visible = 0
			end if
		CASE 2
			object.t_2.text = ls_description
			if lb_external then
				object.l_2.visible = 1
			else
				object.l_2.visible = 0
			end if
		CASE 3
			object.t_3.text = ls_description
			if lb_external then
				object.l_3.visible = 1
			else
				object.l_3.visible = 0
			end if
		CASE 4
			object.t_4.text = ls_description
			if lb_external then
				object.l_4.visible = 1
			else
				object.l_4.visible = 0
			end if
	END CHOOSE
next

// Make any unused columns invisible
for i = observation_count + 1 to observation_count_max
	CHOOSE CASE i
		CASE 1
			object.t_1.visible = 0
			object.l_1.visible = 0
			object.result_1.visible = 0
		CASE 2
			object.t_2.visible = 0
			object.l_2.visible = 0
			object.result_2.visible = 0
		CASE 3
			object.t_3.visible = 0
			object.l_3.visible = 0
			object.result_3.visible = 0
		CASE 4
			object.t_4.visible = 0
			object.l_4.visible = 0
			object.result_4.visible = 0
	END CHOOSE
next

return 1

end function

public function long parent_observation_sequence (long pl_row);long ll_parent_observation_sequence
long ll_stage
string ls_observation_tag
string ls_stage_description

setnull(ls_observation_tag)
ll_stage = object.stage[pl_row]
ls_stage_description = object.stage_description[pl_row]

// First make sure the row has an observation_sequence
ll_parent_observation_sequence = object.parent_observation_sequence[pl_row]
if isnull(ll_parent_observation_sequence) then
	// We don't have an observation record yet, so create one
	ll_parent_observation_sequence = treatment.add_observation_stage(root_observation_sequence, &
										root_observation_id, &
										1, &
										ls_observation_tag, &
										ll_stage, &
										ls_stage_description, &
										true)
	if ll_parent_observation_sequence < 0 then
		log.log(this, "u_dw_observation_grid.update_row.0014", "Error adding observation", 4)
		return -1
	end if
	object.parent_observation_sequence[pl_row] = ll_parent_observation_sequence
end if

return ll_parent_observation_sequence

end function

event itemchanged;
CHOOSE CASE dwo.name
	CASE "result_1"
		update_row(row, 1, data)
	CASE "result_2"
		update_row(row, 2, data)
	CASE "result_3"
		update_row(row, 3, data)
	CASE "result_4"
		update_row(row, 4, data)
END CHOOSE


end event

event losefocus;call super::losefocus;accepttext()

end event

on u_dw_observation_grid.create
end on

on u_dw_observation_grid.destroy
end on

event destructor;call super::destructor;integer i

for i = 1 to source_count
	component_manager.destroy_component(sources[i])
next

end event

event selected;call super::selected;str_popup popup
str_popup_return popup_return
string ls_comment
long ll_parent_observation_sequence
string ls_observation_tag
long ll_stage

// Comment field
if lastcolumn = 12 then
	popup.title = "Please enter a comment"
	popup.item = object.comments[selected_row]
	popup.argument_count = 1
	popup.argument[1] = "OBSGRID|" + root_observation_id
	
	openwithparm(w_pop_prompt_string, popup)
	popup_return = message.powerobjectparm
	if popup_return.item_count = 1 then
		ls_comment = popup_return.items[1]
		
		ll_parent_observation_sequence = parent_observation_sequence(selected_row)
		if ll_parent_observation_sequence <= 0 then return

		treatment.add_comment(ll_parent_observation_sequence, comment_title, comment_abnormal_flag, comment_severity, ls_comment)
		object.comments[selected_row] = ls_comment
	end if
end if


end event

