$PBExportHeader$w_physical_exam.srw
forward
global type w_physical_exam from w_observation_base
end type
type st_page from statictext within w_physical_exam
end type
type pb_up from picturebutton within w_physical_exam
end type
type pb_down from picturebutton within w_physical_exam
end type
type cb_done from commandbutton within w_physical_exam
end type
type cb_be_back from commandbutton within w_physical_exam
end type
type st_title from statictext within w_physical_exam
end type
type pb_back from picturebutton within w_physical_exam
end type
type pb_image from picturebutton within w_physical_exam
end type
type pb_tree from picturebutton within w_physical_exam
end type
type pb_top from picturebutton within w_physical_exam
end type
type pb_next from picturebutton within w_physical_exam
end type
type uo_standard_exams from u_standard_exams within w_physical_exam
end type
type cb_clear_all from commandbutton within w_physical_exam
end type
type pb_prev from picturebutton within w_physical_exam
end type
type cb_do_later from commandbutton within w_physical_exam
end type
type dw_physical from u_dw_pick_list within w_physical_exam
end type
type cb_legal_notice from commandbutton within w_physical_exam
end type
end forward

global type w_physical_exam from w_observation_base
integer height = 1840
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 3
st_page st_page
pb_up pb_up
pb_down pb_down
cb_done cb_done
cb_be_back cb_be_back
st_title st_title
pb_back pb_back
pb_image pb_image
pb_tree pb_tree
pb_top pb_top
pb_next pb_next
uo_standard_exams uo_standard_exams
cb_clear_all cb_clear_all
pb_prev pb_prev
cb_do_later cb_do_later
dw_physical dw_physical
cb_legal_notice cb_legal_notice
end type
global w_physical_exam w_physical_exam

type variables
string observation_id[]
long branch_id[]
long observation_sequence[]
long current_page[]
integer child_ordinal[]
string edit_service[]
long question_number
string abnormal_flag = "N"

string composite_icon
string simple_icon
string followon_icon
string comment_icon

u_component_service service

boolean allow_new_result

u_component_observation sources[]
integer source_count

string comment_service
string image_service
string external_service

string result_type
string display_context

u_ds_observation_results results

string legal_notice


end variables

forward prototypes
public subroutine next_simple_observation ()
public function integer display_observation (str_observation_stack pstr_stack)
public function integer do_source (long pl_row)
public function integer initialize ()
public function integer display_results ()
public function integer set_property_result (long pl_row)
public function integer add_external_source (string ps_external_source)
public function integer set_results_for_row (long pl_row, boolean pb_suppress_redraw)
public subroutine set_buttons ()
public subroutine prev_simple_observation ()
public function integer display_observation ()
public subroutine results_entered ()
end prototypes

public subroutine next_simple_observation ();str_observation_tree lstr_tree
long i
string ls_observation_id
integer li_this_index
string ls_composite_flag
long ll_stage

setnull(ll_stage)

// If we're at the top there's nothing to do
if question_number <= 1 then return

lstr_tree = datalist.observation_tree(observation_id[question_number - 1])


// Find where we are in the tree
li_this_index = 0
for i = 1 to lstr_tree.branch_count
	if branch_id[question_number] = lstr_tree.branch[i].branch_id then
		li_this_index = i
		exit
	end if
next

if li_this_index <= 0 or li_this_index > lstr_tree.branch_count then return

for i = li_this_index + 1 to lstr_tree.branch_count
	ls_composite_flag = datalist.observation_composite_flag(lstr_tree.branch[i].child_observation_id)
	if ls_composite_flag = "Y" then continue
	
	current_page[question_number] = 1
	child_ordinal[question_number] = lstr_tree.branch[i].child_ordinal
	edit_service[question_number] = lstr_tree.branch[i].edit_service
	branch_id[question_number] = lstr_tree.branch[i].branch_id
	observation_id[question_number] = lstr_tree.branch[i].child_observation_id
	observation_sequence[question_number] = service.treatment.add_observation( &
																				observation_sequence[question_number - 1], &
																				observation_id[question_number], &
																				lstr_tree.branch[i].child_ordinal, &
																				lstr_tree.branch[i].observation_tag, &
																				ll_stage, &
																				true)
	return
next

// If we didn't find another simple observation, then back up one level
question_number -= 1

return

end subroutine

public function integer display_observation (str_observation_stack pstr_stack);integer i
str_observation_tree_branch lstr_branch
long ll_stage

setnull(ll_stage)

question_number = 1

for i = 1 to pstr_stack.depth
	question_number += 1
	current_page[question_number] = 1
	branch_id[question_number] = pstr_stack.branch_id[i]
	observation_id[question_number] = pstr_stack.observation_id[i]
	child_ordinal[question_number] = pstr_stack.child_ordinal[i]
	lstr_branch = datalist.observation_tree_branch(observation_id[question_number - 1], branch_id[question_number])
	edit_service[question_number] = lstr_branch.edit_service
	observation_sequence[question_number] = service.treatment.add_observation( &
																observation_sequence[question_number - 1], &
																observation_id[question_number], &
																lstr_branch.child_ordinal, &
																lstr_branch.observation_tag, &
																ll_stage, &
																true)
next

return display_observation()



end function

public function integer do_source (long pl_row);integer i
string ls_external_source
long ll_observation_comment_id
string ls_comment_title
str_attributes lstr_state_attributes

ls_external_source = dw_physical.object.external_source[pl_row]
ll_observation_comment_id = dw_physical.object.observation_comment_id[pl_row]
ls_comment_title = dw_physical.object.comment_title[pl_row]

// If we have the external source already instantiated, then call it
for i = 1 to source_count
	if sources[i].external_source = ls_external_source then return sources[i].do_source()
next

// Otherwise, call the "external_service"
lstr_state_attributes.attribute_count = 3
lstr_state_attributes.attribute[1].attribute = "observation_id"
lstr_state_attributes.attribute[1].value = observation_id[question_number]
lstr_state_attributes.attribute[2].attribute = "observation_sequence"
lstr_state_attributes.attribute[2].value = string(observation_sequence[question_number])
lstr_state_attributes.attribute[3].attribute = "treatment_type"
lstr_state_attributes.attribute[3].value = service.treatment.treatment_type

if not isnull(ll_observation_comment_id) then
	lstr_state_attributes.attribute_count += 1
	lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].attribute = "observation_comment_id"
	lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].value = string(ll_observation_comment_id)
end if

if not isnull(ls_external_source) then
	lstr_state_attributes.attribute_count += 1
	lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].value = ls_external_source
	lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].attribute = "external_source"
end if

if not isnull(ls_comment_title) then
	lstr_state_attributes.attribute_count += 1
	lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].attribute = "comment_title"
	lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].value = ls_comment_title
end if

service_list.do_service(current_patient.cpr_id, service.encounter_id, external_service, service.treatment, lstr_state_attributes)

return 0


end function

public function integer initialize ();integer li_sts
long ll_parent_observation_sequence
str_observation_tree_branch lstr_branch
long ll_null

setnull(ll_null)

results = CREATE u_ds_observation_results

display_context = lower(service.get_attribute("display_context"))
if isnull(display_context) then display_context = service.context_object

if display_context = "patient" then
	results.set_dataobject("dw_sp_obstree_patient")
else
	results.set_dataobject("dw_sp_obstree_treatment")
end if

composite_icon = service.get_attribute("composite_icon")
if isnull(composite_icon) then composite_icon = "composite_icon.bmp"

simple_icon = service.get_attribute("simple_icon")
if isnull(simple_icon) then simple_icon = "simple_icon.bmp"

followon_icon = service.get_attribute("followon_icon")
if isnull(followon_icon) then followon_icon = "followon_icon.bmp"

comment_icon = service.get_attribute("comment_icon")
if isnull(comment_icon) then comment_icon = "button18.bmp"

result_type = service.get_attribute("result_type")
if isnull(result_type) then result_type = "PERFORM"

branch_id[1] = 0
setnull(edit_service[1])

observation_id[1] = service.root_observation_id()
if isnull(observation_id[1]) then
	log.log(this, "w_physical_exam.initialize:0039", "No Root observation_id", 4)
	return -1
end if

SELECT legal_notice
INTO :legal_notice
FROM c_Observation
WHERE observation_id = :observation_id[1];
if not tf_check() then return -1
if len(legal_notice) > 0 then
	cb_legal_notice.visible = true
else
	cb_legal_notice.visible = false
end if

observation_sequence[1] = service.get_root_observation()
if isnull(observation_sequence[1]) or observation_sequence[1] <= 0 then
	log.log(this, "w_physical_exam.initialize:0056", "Error getting observation_sequence", 4)
	return -1
end if

question_number = 1

uo_standard_exams.initialize(service)
uo_standard_exams.display_exams()

li_sts = display_observation()
if li_sts <= 0 then return -1

return 1

end function

public function integer display_results ();integer li_sts
long i
string ls_result_type

SetPointer(Hourglass!)

for i = 1 to dw_physical.rowcount()
	ls_result_type = upper(dw_physical.object.result_type[i])
	if ls_result_type = "PROPERTY" then
		li_sts = set_property_result(i)
		if li_sts < 0 then return -1
	elseif isnull(ls_result_type) or ls_result_type = "COLLECT" or ls_result_type = "PERFORM" then
		li_sts = set_results_for_row(i, true)
		if li_sts < 0 then return -1
	end if
next

SetPointer(Arrow!)

return 1

end function

public function integer set_property_result (long pl_row);long ll_property_id
string ls_property_value
str_property_value lstr_property_value
string ls_context_object
string ls_property
long ll_object_key
str_attributes lstr_attributes

ls_context_object = dw_physical.object.property_context_object[pl_row]
ls_property = dw_physical.object.property[pl_row]

CHOOSE CASE lower(ls_context_object)
	CASE "encounter"
		ll_object_key = service.encounter_id
	CASE "treatment"
		ll_object_key = service.treatment_id
	CASE ELSE
		setnull(ll_object_key)
END CHOOSE
lstr_property_value = f_get_property(ls_context_object, ls_property, ll_object_key, lstr_attributes)

ls_property_value = lstr_property_value.value
if isnull(ls_property_value) then ls_property_value = "<Not Available>"

dw_physical.object.results[pl_row] = ls_property_value

return 1

end function

public function integer add_external_source (string ps_external_source);u_component_observation luo_source
long ll_rows
long i
string ls_component_id
str_attributes lstr_attributes
u_ds_data luo_data
integer li_count
str_external_source lstr_external_source
integer li_sts

// Find the external source component info
li_sts = common_thread.get_external_source(ps_external_source, lstr_external_source)
if li_sts <= 0 then return li_sts

// See if we already have this external source instantiated
for i = 1 to source_count
	if sources[i].external_source = lstr_external_source.external_source then return i
next


// Let the external source component know what it's external source id is
f_attribute_add_attribute(lstr_attributes, "external_source", lstr_external_source.external_source)

// Instantiate the component
luo_source = component_manager.get_component(lstr_external_source.component_id, lstr_attributes)
if isnull(luo_source) then return -1

// Add the component to the list for this screen
source_count += 1
sources[source_count] = luo_source
sources[source_count].display_window = this

return source_count


end function

public function integer set_results_for_row (long pl_row, boolean pb_suppress_redraw);integer li_sts
string ls_bitmap
long ll_row
long ll_result_count
long ll_observation_sequence
string ls_find
string ls_observation_id
string ls_composite_flag
string ls_exclusive_flag
string ls_default_view
string ls_location_domain
integer li_result_sequence
long ll_location_count
string ls_location
string ls_child_observation_id
long ll_child_observation_sequence
long ll_parent_observation_sequence
string ls_results
string ls_results_rtf
str_observation_tree lstr_tree
long i, j
integer li_child_ordinal
long ll_o_count
integer li_severity
string ls_result_type
string ls_observation_tag
long ll_stage
long ll_rowcount
long ll_history_sequence

setnull(ll_stage)
setnull(ll_parent_observation_sequence)

ll_rowcount = results.rowcount()

if question_number < 1 then
	log.log(this, "w_physical_exam.set_results_for_row:0037", "Invalid Question Number", 4)
	return -1
end if

// Get some info about the displayed observation
ls_observation_id = observation_id[question_number]
ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)
ls_exclusive_flag = datalist.observation_exclusive_flag(ls_observation_id)
ls_default_view = datalist.observation_default_view(ls_observation_id)
if isnull(ls_default_view) then ls_default_view = "R"
if result_type = "COLLECT" then
	ls_location_domain = datalist.observation_collection_location_domain(ls_observation_id)
else
	ls_location_domain = datalist.observation_perform_location_domain(ls_observation_id)
end if
ll_observation_sequence = observation_sequence[question_number]
li_result_sequence = dw_physical.object.result_sequence[pl_row]
ls_location = dw_physical.object.location[pl_row]
ls_result_type = dw_physical.object.result_type[pl_row]
li_child_ordinal = dw_physical.object.child_ordinal[pl_row]
if isnull(li_child_ordinal) or li_child_ordinal <= 0 then li_child_ordinal = 1
ls_observation_tag = dw_physical.object.observation_tag[pl_row]
ls_child_observation_id = dw_physical.object.observation_id[pl_row]

setnull(ll_child_observation_sequence)
setnull(li_severity)

if not pb_suppress_redraw then dw_physical.setredraw(false)

if display_context = "patient" then
	// First find the root record
	ls_find = "lower(record_type)='root'"
	ls_find += " and observation_id='" + ls_observation_id + "'"
	ll_row = results.find(ls_find, 1, ll_rowcount)
else
	// First find the root record
	ls_find = "lower(record_type)='root'"
	ls_find += " and observation_id='" + observation_id[1] + "'"
	ll_row = results.find(ls_find, 1, ll_rowcount)
	if ll_row = 0 then
		ls_find = "lower(record_type) IN ('root', 'observation')"
		ls_find += " and observation_sequence=" + string(observation_sequence[1])
		ll_row = results.find(ls_find, 1, ll_rowcount)
	end if
	if ll_row > 0 then
		// Then navigate down the tree to find the parent observation record
		for i = 2 to question_number
			ll_history_sequence = results.object.history_sequence[ll_row]
			ls_find = "lower(record_type)='observation'"
			ls_find += " and observation_id='" + observation_id[i] + "'"
			ls_find += " and parent_history_sequence=" + string(ll_history_sequence)
			ll_row = 0
			for j = 1 to child_ordinal[i]
				ll_row = results.find(ls_find, ll_row + 1, ll_rowcount + 1)
				if ll_row <= 0 then exit
			next
			if ll_row <= 0 then exit
		next
	end if
end if

if ll_row > 0 and ll_row <= ll_rowcount then
	ll_history_sequence = results.object.history_sequence[ll_row]
	// If the result_sequence and location are both null then this must be a child-observation row
	if isnull(li_result_sequence) and isnull(ls_location) then
		setnull(li_severity)
		setnull(ll_child_observation_sequence)
		if isnull(ls_child_observation_id) then
			// If the child_observation_id is null, then this is a comment row
			ls_results = dw_physical.object.results[pl_row]
		else
			// This is an observation so find the corresponding observation results record
			ls_find = "lower(record_type)='observation'"
			ls_find += " and parent_history_sequence=" + string(ll_history_sequence)
			ls_find += " and observation_id='" + ls_child_observation_id + "'"
			ll_row = 0
			for i = 1 to li_child_ordinal
				ll_row = results.find(ls_find, ll_row + 1, ll_rowcount + 1)
			next
			
			if ll_row > 0 and ll_row <= ll_rowcount then
				ll_child_observation_sequence = results.object.observation_sequence[ll_row]
				ll_parent_observation_sequence = results.object.parent_observation_sequence[ll_row]
				ls_results = ""
				li_sts = results.display_observation_row(ll_row, result_type, abnormal_flag, true, ls_results)
				if trim(ls_results) = "" then setnull(ls_results)
			else
				setnull(ls_results)
			end if
		end if
	elseif not isnull(li_result_sequence) then
		// The left side should be results
		ls_results = results.results_for_result(ll_history_sequence, li_result_sequence, abnormal_flag, li_severity, ";")

		// Set the bitmap according to the highest severity results selected
		if not isnull(li_severity) then
			ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(li_severity))
			if isnull(ls_bitmap) then ls_bitmap = "result_0.bmp"
			dw_physical.object.icon[pl_row] = ls_bitmap
		end if
	elseif not isnull(ls_location) then
		// The left side should be locations
		ls_results = ""
		li_sts = results.results_for_location(ll_history_sequence, result_type, ls_location, abnormal_flag, li_severity, ";", ls_results)
		if trim(ls_results) = "" then setnull(ls_results)
		
		// Set the bitmap according to the highest severity results selected
		if not isnull(li_severity) then
			ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(li_severity))
			if isnull(ls_bitmap) then ls_bitmap = "result_0.bmp"
			dw_physical.object.icon[pl_row] = ls_bitmap
		end if
	end if
else
	setnull(ls_results)
	setnull(li_severity)
end if

// Only set the child observation sequence if it's parent matches the current
// observation sequence.  If it doesn't match, that means that we're displaying
// data from a previous treatment, which is OK except that if the user chooses
// to edit the data we'll need to generate a new child observation sequence.
if ll_parent_observation_sequence = observation_sequence[question_number] then
	dw_physical.object.child_observation_sequence[pl_row] = ll_child_observation_sequence
end if
dw_physical.object.parent_observation_sequence[pl_row] = ll_parent_observation_sequence
dw_physical.object.results[pl_row] = ls_results
dw_physical.object.severity[pl_row] = li_severity


// If this is a result and the location_domain = "NA" then the result is displayed on
// the left instead of the right
if not isnull(li_result_sequence) and ls_location_domain = "NA" then
	if isnull(ls_results) then
		// If there are no results, then reset the left side to the original result text
		dw_physical.object.description[pl_row] = dw_physical.object.result_description[pl_row]
	else
		dw_physical.object.description[pl_row] = ls_results
	end if
end if

// If we have results then turn on the selected_flag 
if isnull(ls_results) then
	dw_physical.object.selected_flag[pl_row] = 0
else
	dw_physical.object.selected_flag[pl_row] = 1
end if

if not pb_suppress_redraw then
	dw_physical.recalc_page(pb_up, pb_down, st_page)
	dw_physical.setredraw(true)
end if

return 1

end function

public subroutine set_buttons ();str_observation_tree lstr_tree
long i
string ls_observation_id
integer li_this_index
string ls_composite_flag
boolean lb_enabled

// First, set the page up/down buttons
dw_physical.last_page=0
dw_physical.set_page(current_page[question_number], pb_up, pb_down, st_page)

// Then, if we're at the top, then we don't need navigation buttons
if question_number <= 1 then
	pb_top.visible = false
	pb_back.visible = false
	pb_next.visible = false
	pb_prev.visible = false
	cb_clear_all.visible = true
	uo_standard_exams.set_enabled()
	return
end if


pb_top.visible = true
pb_back.visible = true
cb_clear_all.visible = false
uo_standard_exams.set_disabled()

// If this is a composite observation, then we don't need the next/prev buttons
ls_composite_flag = datalist.observation_composite_flag(observation_id[question_number])
if ls_composite_flag = "Y" then
	pb_next.visible = false
	pb_prev.visible = false
	return
end if

// If we get here, then we want to show the next/prev buttons
pb_next.visible = true
pb_prev.visible = true

// Now see which next/prev buttons should be enabled

lstr_tree = datalist.observation_tree(observation_id[question_number - 1])

// Find where we are in the tree
li_this_index = 0
for i = 1 to lstr_tree.branch_count
	if branch_id[question_number] = lstr_tree.branch[i].branch_id then
		li_this_index = i
		exit
	end if
next

// See if there's a simple observation before this one
lb_enabled = false
for i = 1 to li_this_index - 1
	ls_composite_flag = datalist.observation_composite_flag(lstr_tree.branch[i].child_observation_id)
	if ls_composite_flag = "Y" then continue
	
	lb_enabled = true
	exit
next

pb_prev.enabled = lb_enabled


// Now see if there's a simple observation after this one
lb_enabled = false
for i = li_this_index + 1 to lstr_tree.branch_count
	ls_composite_flag = datalist.observation_composite_flag(lstr_tree.branch[i].child_observation_id)
	if ls_composite_flag = "Y" then continue
	
	lb_enabled = true
	exit
next

pb_next.enabled = lb_enabled

return

end subroutine

public subroutine prev_simple_observation ();str_observation_tree lstr_tree
long i
string ls_observation_id
integer li_this_index
string ls_composite_flag
long ll_stage

setnull(ll_stage)

// If we're at the top there's nothing to do
if question_number <= 1 then return

lstr_tree = datalist.observation_tree(observation_id[question_number - 1])


// Find where we are in the tree
li_this_index = 0
for i = 1 to lstr_tree.branch_count
	if branch_id[question_number] = lstr_tree.branch[i].branch_id then
		li_this_index = i
		exit
	end if
next

if li_this_index <= 0 or li_this_index > lstr_tree.branch_count then return

for i = li_this_index - 1 to 1 step -1
	ls_composite_flag = datalist.observation_composite_flag(lstr_tree.branch[i].child_observation_id)
	if ls_composite_flag = "Y" then continue
	
	branch_id[question_number] = lstr_tree.branch[i].branch_id
	observation_id[question_number] = lstr_tree.branch[i].child_observation_id
	observation_sequence[question_number] = service.treatment.add_observation( &
																				observation_sequence[question_number - 1], &
																				observation_id[question_number], &
																				lstr_tree.branch[i].child_ordinal, &
																				lstr_tree.branch[i].observation_tag, &
																				ll_stage, &
																				true)
	return
next

// If we didn't find another simple observation, then back up one level
question_number -= 1

return

end subroutine

public function integer display_observation ();integer li_sts
long ll_row
long ll_result_count
long ll_observation_sequence
string ls_find
string ls_observation_id
string ls_composite_flag
string ls_child_composite_flag
string ls_exclusive_flag
string ls_default_view
string ls_location_domain
long i, j, k
string ls_description
string ls_temp
integer li_result_sequence
long ll_location_count
string ls_location
string ls_filter
string ls_child_observation_id
long ll_branch_id
str_observation_tree lstr_tree
str_observation_results lstr_results
str_observation_tree_branch lstr_branch
str_observation_comment_list lstr_comments
string lsa_location[]
string lsa_location_description[]
string ls_bitmap
integer li_comment_max_chars
string ls_external_source
string ls_external_observation
long ll_material_id
string ls_extension_button
string ls_extension
string ls_comment
integer li_index
string ls_result_type
string ls_connected
str_attributes lstr_attributes
str_property lstr_property

SetPointer(Hourglass!)

if question_number < 1 then
	log.log(this, "w_physical_exam.display_observation:0044", "Invalid Question Number", 4)
	return -1
end if

// If the upperbound of the current_page array is less then the question
// number, then set the initial current_page for each missing entry to 1
for i = upperbound(current_page) + 1 to question_number
	current_page[i] = 1
next

if not isnull(edit_service[question_number]) then
	// If we have an edit_service, then call the service
	lstr_attributes.attribute_count = 2
	lstr_attributes.attribute[1].attribute = "treatment_id"
	lstr_attributes.attribute[1].value = string(service.treatment.treatment_id)
	lstr_attributes.attribute[2].attribute = "observation_sequence"
	lstr_attributes.attribute[2].value = string(observation_sequence[question_number])
	
	// Call service with attributes
	li_sts = service_list.do_service( &
												current_patient.cpr_id, &
												service.encounter_id, &
												edit_service[question_number], &
												service.treatment, &
												lstr_attributes )
	
	results_entered()
	return display_observation()
end if

// Refresh the results datastore
if display_context = "patient" then
	results.retrieve(current_patient.cpr_id, observation_id[question_number])
else
	results.retrieve(current_patient.cpr_id, service.treatment.treatment_id)
end if

// Get some info about the displayed observation
ls_observation_id = observation_id[question_number]
ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)
ls_exclusive_flag = datalist.observation_exclusive_flag(ls_observation_id)
ls_default_view = datalist.observation_default_view(ls_observation_id)
if isnull(ls_default_view) then ls_default_view = "R"
if result_type = "COLLECT" then
	ls_location_domain = datalist.observation_collection_location_domain(ls_observation_id)
else
	ls_location_domain = datalist.observation_perform_location_domain(ls_observation_id)
end if
ll_observation_sequence = observation_sequence[question_number]
lstr_branch = datalist.observation_tree_branch(branch_id[question_number])
ll_material_id = datalist.observation_material_id(ls_observation_id)
lstr_results = datalist.observation_results(ls_observation_id)

if isnull(ll_material_id) then
	pb_image.visible = false
else
	pb_image.visible = true
end if

// Clear display
dw_physical.setredraw(false)
dw_physical.reset()

// Calculate observation description
ls_description = service.treatment.get_observation_description(observation_sequence[1])
for i = 2 to question_number
	ls_temp = service.treatment.get_observation_description(observation_sequence[i])
	if not isnull(ls_temp) and trim(ls_temp) <> "" then
		ls_description += " : " + ls_temp
	end if
next
st_title.text = ls_description

setnull(ls_external_source)

// First, show the properties
for i = 1 to lstr_results.result_count
	if upper(lstr_results.result[i].result_type) = "PROPERTY" and not isnull(lstr_results.result[i].property_id) then
		lstr_property = datalist.find_property(lstr_results.result[i].property_id)
		if isnull(lstr_property.property_id) then continue
		ll_row = dw_physical.insertrow(0)
		dw_physical.object.result_type[ll_row] = "PROPERTY"
		dw_physical.object.description[ll_row] = lstr_property.description
		dw_physical.object.edit_service[ll_row] = lstr_results.result[i].service
		dw_physical.object.result_description[ll_row] = lstr_property.description
		dw_physical.object.comment_title[ll_row] = lstr_property.description
		dw_physical.object.result_sequence[ll_row] = lstr_results.result[i].result_sequence
		ls_bitmap = datalist.property_type_icon(lstr_property.property_type)
		if isnull(ls_bitmap) then ls_bitmap = "icon_property.bmp"
		dw_physical.object.icon[ll_row] = ls_bitmap
		dw_physical.object.property_context_object[ll_row] = lstr_property.property_object
		dw_physical.object.property[ll_row] = lstr_property.function_name
	end if
next

// Then, show the predefined attachments
for i = 1 to lstr_results.result_count
	if upper(lstr_results.result[i].result_type) = "ATTACHMENT" and not isnull(lstr_results.result[i].external_source) then
		ls_connected = "N"
		li_index = add_external_source(lstr_results.result[i].external_source)
		if li_index > 0 then
			ls_external_source = sources[li_index].external_source
			if sources[li_index].connected then ls_connected = "Y"
		elseif li_index = 0 then
			ls_external_source = lstr_results.result[i].external_source
		else
			continue
		end if
		ls_description = lstr_results.result[i].result
		ll_row = dw_physical.insertrow(0)
		dw_physical.object.observation_id[ll_row] = ls_observation_id
		dw_physical.object.result_type[ll_row] = "ATTACHMENT"
		dw_physical.object.description[ll_row] = ls_description
		dw_physical.object.result_description[ll_row] = ls_description
		dw_physical.object.comment_title[ll_row] = ls_description
		dw_physical.object.result_sequence[ll_row] = lstr_results.result[i].result_sequence
		ls_bitmap = datalist.external_source_button(ls_external_source)
		if isnull(ls_bitmap) then ls_bitmap = "icon_external_source.bmp"
		dw_physical.object.icon[ll_row] = ls_bitmap
		dw_physical.object.external_source[ll_row] = ls_external_source
		dw_physical.object.connected[ll_row] = ls_connected
	end if
next

// Then, show the pre-configured comments
for i = 1 to lstr_results.result_count
	if upper(lstr_results.result[i].result_type) = "COMMENT" then
		ls_description = lstr_results.result[i].result
		ll_row = dw_physical.insertrow(0)
		dw_physical.object.result_type[ll_row] = "COMMENT"
		dw_physical.object.description[ll_row] = ls_description
		dw_physical.object.result_description[ll_row] = ls_description
		dw_physical.object.comment_title[ll_row] = ls_description
		dw_physical.object.result_sequence[ll_row] = lstr_results.result[i].result_sequence
		dw_physical.object.icon[ll_row] = comment_icon
	end if
next


// Fill the left side of the display
if ls_composite_flag = "Y" and result_type = "PERFORM" then
	// If the observation is composite, then the left side contains the constituent observations
	lstr_tree = datalist.observation_tree(ls_observation_id)
	for i = 1 to lstr_tree.branch_count
		ls_child_observation_id = lstr_tree.branch[i].child_observation_id
		ll_branch_id = lstr_tree.branch[i].branch_id
		ls_description = datalist.observation_description(ls_child_observation_id)
		ls_child_composite_flag = datalist.observation_composite_flag(ls_child_observation_id)
		ll_row = dw_physical.insertrow(0)
		dw_physical.object.description[ll_row] = ls_description
		dw_physical.object.observation_id[ll_row] = ls_child_observation_id
		dw_physical.object.child_ordinal[ll_row] = lstr_tree.branch[i].child_ordinal
		dw_physical.object.observation_tag[ll_row] = lstr_tree.branch[i].observation_tag
		dw_physical.object.edit_service[ll_row] = lstr_tree.branch[i].edit_service
		dw_physical.object.branch_id[ll_row] = ll_branch_id
		if ls_child_composite_flag = "Y" then
			dw_physical.object.icon[ll_row] = composite_icon
		else
			dw_physical.object.icon[ll_row] = simple_icon
		end if
		
		// See if this observation matches any external source observation
		for j = 1 to source_count
			ls_external_observation = datalist.external_observation(sources[j].external_source, ls_observation_id)
			if not isnull(ls_external_observation) then
				dw_physical.object.external_source[ll_row] = sources[j].external_source
			end if
		next
	next		
else
	// See if this observation matches any external source observation
	for j = 1 to source_count
		ls_external_observation = datalist.external_observation(sources[j].external_source, ls_observation_id)
		if not isnull(ls_external_observation) then
			ls_external_source = sources[j].external_source
		end if
	next

	// If the observation is simple, then the left side contains either results or locations
	if ls_default_view = "R" OR ls_location_domain = "NA" then
		// If we're displaying "by result", or if there isn't a location domain, then fill the left side
		// from the list of "PERFORM" results
		for i = 1 to lstr_results.result_count
			if upper(lstr_results.result[i].result_type) = result_type then
				ls_description = lstr_results.result[i].result
				if lstr_results.result[i].result_amount_flag = "Y" then ls_description += "="
				li_result_sequence = lstr_results.result[i].result_sequence
				ll_row = dw_physical.insertrow(0)
				dw_physical.object.result_type[ll_row] = result_type
				dw_physical.object.description[ll_row] = ls_description
				dw_physical.object.result_description[ll_row] = ls_description
				dw_physical.object.result_sequence[ll_row] = li_result_sequence
				dw_physical.object.location_domain[ll_row] = ls_location_domain
	//			dw_physical.object.external_source[ll_row] = ls_external_source
	
				ls_bitmap = datalist.domain_item_bitmap("RESULTSEVERITY", string(lstr_results.result[i].severity))
				if isnull(ls_bitmap) then ls_bitmap = "result_0.bmp"
				dw_physical.object.icon[ll_row] = ls_bitmap
			end if
		next
	else
		// Start by getting the c_observation_result records
		ll_location_count = datalist.locations_in_domain(ls_location_domain, lsa_location, lsa_location_description)
		if ll_location_count < 0 then
			log.log(this, "w_physical_exam.display_observation:0248", "error getting locations (" + ls_location_domain + ")", 4)
			return -1
		end if
		
		// Then fill the left side
		for i = 1 to ll_location_count
			ll_row = dw_physical.insertrow(0)
			dw_physical.object.result_type[ll_row] = result_type
			dw_physical.object.description[ll_row] = lsa_location_description[i]
			dw_physical.object.location[ll_row] = lsa_location[i]
			dw_physical.object.location_domain[ll_row] = ls_location_domain
//			dw_physical.object.external_source[ll_row] = ls_external_source
		next
	end if
	
	// If there is a followon observation_id defined, add a record to the top
	if not isnull(lstr_branch.followon_observation_id) then
		ll_row = dw_physical.insertrow(1)
		dw_physical.object.description[ll_row] = datalist.observation_description(lstr_branch.followon_observation_id)
		dw_physical.object.observation_id[ll_row] = lstr_branch.followon_observation_id
		dw_physical.object.branch_id[ll_row] = -ll_branch_id
		dw_physical.object.icon[ll_row] = followon_icon
	end if
end if

// Finally, display the actual attachments/comments
service.get_attribute("comment_max_chars", li_comment_max_chars)
if isnull(li_comment_max_chars) then li_comment_max_chars = 255
lstr_comments = service.treatment.get_comments(ll_observation_sequence, "%")
for i = 1 to lstr_comments.comment_count
	ls_description = lstr_comments.comment[i].comment_title
	if isnull(ls_description) then
		ls_description = user_list.user_short_name(lstr_comments.comment[i].user_id) + " Comments"
	end if
	
	ls_comment = left(lstr_comments.comment[i].comment, li_comment_max_chars)
	
	if isnull(lstr_comments.comment[i].attachment_id) then
		ls_result_type = "COMMENT"
		if isnull(ls_comment) then continue
	else
		ls_result_type = "ATTACHMENT"
		if isnull(ls_comment) then ls_comment = "<Attachment>"
	end if
	
	ls_find = "comment_title='" + ls_description + "'"
	ls_find += " and result_type='" + ls_result_type + "'"
	ll_row = dw_physical.find(ls_find, 1, dw_physical.rowcount())
	if ll_row <= 0 then
		ll_row = dw_physical.insertrow(1)
		dw_physical.object.result_type[ll_row] = ls_result_type
		dw_physical.object.description[ll_row] = ls_description
	end if
	
	if isnull(lstr_comments.comment[i].attachment_id) then
		dw_physical.object.icon[ll_row] = comment_icon
		dw_physical.object.results[ll_row] = ls_comment
	else
		if isnull(ls_comment) then
			dw_physical.object.results[ll_row] = current_patient.attachments.attachment_extension_description(lstr_comments.comment[i].attachment_id)
		else
			dw_physical.object.results[ll_row] = ls_comment
		end if
		ls_extension = current_patient.attachments.attachment_extension(lstr_comments.comment[i].attachment_id)
		ls_extension_button = datalist.extension_button(ls_extension)
		dw_physical.object.icon[ll_row] = ls_extension_button
	end if
	dw_physical.object.observation_comment_id[ll_row] = lstr_comments.comment[i].observation_comment_id
	dw_physical.object.comment_user_id[ll_row] = lstr_comments.comment[i].user_id
	dw_physical.object.comment_title[ll_row] = lstr_comments.comment[i].comment_title
	dw_physical.object.selected_flag[ll_row] = 1
next

li_sts = display_results()
if li_sts < 0 then
	log.log(this, "w_physical_exam.display_observation:0323", "Error displaying results", 4)
	return -1
end if

set_buttons()

state_attributes.attribute_count = 4
state_attributes.attribute[1].attribute = "observation_sequence"
state_attributes.attribute[1].value = string(observation_sequence[question_number])
state_attributes.attribute[2].attribute = "treatment_id"
state_attributes.attribute[2].value = string(service.treatment.treatment_id)
state_attributes.attribute[3].attribute = "treatment_type"
state_attributes.attribute[3].value = service.treatment.treatment_type
state_attributes.attribute[4].attribute = "observation_id"
state_attributes.attribute[4].value = observation_id[question_number]

dw_physical.set_page(current_page[question_number], pb_up, pb_down, st_page)

dw_physical.setredraw(true)

return 1


end function

public subroutine results_entered ();string ls_exclusive_flag
str_observation_tree_branch lstr_branch

ls_exclusive_flag = datalist.observation_exclusive_flag(observation_id[question_number])
lstr_branch = datalist.observation_tree_branch(branch_id[question_number])

CHOOSE CASE upper(lstr_branch.on_results_entered)
	CASE "NEXT"
		next_simple_observation()
	CASE "UP"
		question_number -= 1
	CASE ELSE
		// If we have an edit service then we can't display this observation at
		// this level.  Since the configuration didn't specify "Next", go up
		if not isnull(edit_service[question_number]) then
			question_number -= 1
		end if
END CHOOSE

return

end subroutine

on w_physical_exam.create
int iCurrent
call super::create
this.st_page=create st_page
this.pb_up=create pb_up
this.pb_down=create pb_down
this.cb_done=create cb_done
this.cb_be_back=create cb_be_back
this.st_title=create st_title
this.pb_back=create pb_back
this.pb_image=create pb_image
this.pb_tree=create pb_tree
this.pb_top=create pb_top
this.pb_next=create pb_next
this.uo_standard_exams=create uo_standard_exams
this.cb_clear_all=create cb_clear_all
this.pb_prev=create pb_prev
this.cb_do_later=create cb_do_later
this.dw_physical=create dw_physical
this.cb_legal_notice=create cb_legal_notice
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_page
this.Control[iCurrent+2]=this.pb_up
this.Control[iCurrent+3]=this.pb_down
this.Control[iCurrent+4]=this.cb_done
this.Control[iCurrent+5]=this.cb_be_back
this.Control[iCurrent+6]=this.st_title
this.Control[iCurrent+7]=this.pb_back
this.Control[iCurrent+8]=this.pb_image
this.Control[iCurrent+9]=this.pb_tree
this.Control[iCurrent+10]=this.pb_top
this.Control[iCurrent+11]=this.pb_next
this.Control[iCurrent+12]=this.uo_standard_exams
this.Control[iCurrent+13]=this.cb_clear_all
this.Control[iCurrent+14]=this.pb_prev
this.Control[iCurrent+15]=this.cb_do_later
this.Control[iCurrent+16]=this.dw_physical
this.Control[iCurrent+17]=this.cb_legal_notice
end on

on w_physical_exam.destroy
call super::destroy
destroy(this.st_page)
destroy(this.pb_up)
destroy(this.pb_down)
destroy(this.cb_done)
destroy(this.cb_be_back)
destroy(this.st_title)
destroy(this.pb_back)
destroy(this.pb_image)
destroy(this.pb_tree)
destroy(this.pb_top)
destroy(this.pb_next)
destroy(this.uo_standard_exams)
destroy(this.cb_clear_all)
destroy(this.pb_prev)
destroy(this.cb_do_later)
destroy(this.dw_physical)
destroy(this.cb_legal_notice)
end on

event open;call super::open;long ll_menu_id
str_popup_return popup_return
integer li_sts
integer i

service = Message.powerobjectparm

title = current_patient.id_line()

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

if isnull(service.treatment) or not isvalid(service.treatment) then
	log.log(this, "w_physical_exam:open", "Invalid treatment object", 4)
	closewithreturn(this, popup_return)
	return
end if

li_sts = initialize()
if li_sts <= 0 then
	log.log(this, "w_physical_exam:open", "Initialization failed", 4)
	closewithreturn(this, popup_return)
	return
end if

st_title.text = datalist.observation_description(observation_id[1])

allow_new_result = true

// Don't offer the "I'll Be Back" option for manual services
service.set_service_buttons(cb_done, cb_be_back, cb_do_later)
if cb_do_later.visible then
	if cb_be_back.visible then
		max_buttons = 2
	else
		max_buttons = 3
		cb_do_later.x = cb_be_back.x
	end if
else
	if cb_be_back.visible then
		max_buttons = 3
	else
		max_buttons = 4
	end if
end if

ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)

image_service = service.get_attribute("image_service")
if isnull(image_service) then image_service = "OBSERVATION_ATTACHMENT"

comment_service = service.get_attribute("comment_service")
if isnull(comment_service) then comment_service = "OBSERVATION_COMMENT"

external_service = service.get_attribute("external_service")
if isnull(external_service) then external_service = "EXTERNAL_SOURCE"

long ll_result_width
long ll_result_x
ll_result_width = long(dw_physical.width * 0.55625)
ll_result_x = dw_physical.width - ll_result_width - 27
dw_physical.object.results.x = ll_result_x
dw_physical.object.t_results.x = ll_result_x
dw_physical.object.results.width = ll_result_width
dw_physical.object.t_results.width = ll_result_width
dw_physical.object.description.width = 859 + (ll_result_x - 1038)
dw_physical.object.l_source_status.x2 = 997 + (ll_result_x - 1038)


end event

event results_posted;str_popup popup
str_popup_return popup_return
integer i, j, k, l
string ls_tag
str_external_observation_attachment lstr_attachment
string ls_abnormal_flag
integer li_severity
string ls_composite_flag
string ls_row_composite_flag
string ls_observation_id
string ls_row_observation_id
integer li_child_ordinal
long ll_parent_observation_sequence
long ll_observation_sequence
integer li_sts
str_attachment lstr_new_attachment
long ll_attachment_id
string ls_comment_title
string ls_find
long ll_row
long ll_comment_title_count
string lsa_comment_title[]
string ls_observation_tag
long ll_stage
str_complete_context lstr_context
str_complete_context lstr_document_context
boolean lb_found
integer li_result_sequence

setnull(ls_tag)
setnull(ls_abnormal_flag)
setnull(li_severity)
setnull(ll_stage)

if question_number < 1 then
	log.log(this, "w_physical_exam:resu", "Invalid Question Number", 4)
	return
end if

// Get some info about the displayed observation
ll_parent_observation_sequence = observation_sequence[question_number]
ls_observation_id = observation_id[question_number]
ls_composite_flag = datalist.observation_composite_flag(ls_observation_id)

// Set the attachment fields that we already know
lstr_new_attachment.cpr_id = current_patient.cpr_id
lstr_new_attachment.encounter_id = service.encounter_id
setnull(lstr_new_attachment.problem_id)
lstr_new_attachment.treatment_id = service.treatment.treatment_id
lstr_new_attachment.observation_sequence = ll_parent_observation_sequence
setnull(lstr_new_attachment.attachment_tag)
setnull(lstr_new_attachment.attachment_file_path)

for i = 1 to puo_observation.observation_count
	// If we have an observation_id then we might have some structured results
	if not isnull(puo_observation.observations[i].observation_id) then
		if ls_composite_flag = "Y" then
			// If we're looking at a composite observation then match up the results
			// posted with the displayed children
			for j = 1 to dw_physical.rowcount()
				ls_row_observation_id = dw_physical.object.observation_id[j]
				li_child_ordinal = dw_physical.object.child_ordinal[j]
				ls_observation_tag = dw_physical.object.observation_tag[j]
				ls_row_composite_flag = datalist.observation_composite_flag(ls_row_observation_id)
				if isnull(ls_row_composite_flag) or ls_row_composite_flag = "N" then
					// Loop through the results and see if any of the observation_id's match
					for k = 1 to puo_observation.observations[i].result_count
						lb_found = false
						// Loop through the keys and see if any match
						for l = 1 to puo_observation.observations[i].result[k].id_count
							if ls_row_observation_id = puo_observation.observations[i].result[k].observation_id[l] then
								li_result_sequence = puo_observation.observations[i].result[k].result_sequence[l]
								lb_found = true
								exit
							end if
						next
						
						// If we found a match, then post the result
						if lb_found then
							ll_observation_sequence = service.treatment.add_observation(ll_parent_observation_sequence, &
																											ls_row_observation_id, &
																											li_child_ordinal, &
																											ls_observation_tag, &
																											ll_stage, &
																											true)
							if ll_observation_sequence <= 0 then continue
							
							li_sts = service.treatment.add_result(ll_parent_observation_sequence, &
																	li_result_sequence, &
																	puo_observation.observations[i].result[k].location, &
																	puo_observation.observations[i].result[k].result_date_time, &
																	puo_observation.observations[i].result[k].result_value, &
																	puo_observation.observations[i].result[k].result_unit, &
																	puo_observation.observations[i].result[k].abnormal_flag, &
																	puo_observation.observations[i].result[k].abnormal_nature )
							if li_sts <= 0 then continue
						end if
					next
				end if
			next
		else
			// If we're looking at a simple observation then post the results if
			// they're for this observation
			for k = 1 to puo_observation.observations[i].result_count
				lb_found = false
				// Loop through the keys and see if any match
				for l = 1 to puo_observation.observations[i].result[k].id_count
					if ls_observation_id = puo_observation.observations[i].result[k].observation_id[l] then
						li_result_sequence = puo_observation.observations[i].result[k].result_sequence[l]
						lb_found = true
						exit
					end if
				next
			
				if lb_found then
					// Loop through the results and add them
					li_sts = service.treatment.add_result(ll_parent_observation_sequence, &
															li_result_sequence, &
															puo_observation.observations[i].result[k].location, &
															puo_observation.observations[i].result[k].result_date_time, &
															puo_observation.observations[i].result[k].result_value, &
															puo_observation.observations[i].result[k].result_unit, &
															puo_observation.observations[i].result[k].abnormal_flag, &
															puo_observation.observations[i].result[k].abnormal_nature )
					if li_sts <= 0 then continue
				end if
			next
		end if
	end if
	
	// Now post the attachments
	for j = 1 to puo_observation.observations[i].attachment_list.attachment_count
		lstr_attachment = puo_observation.observations[i].attachment_list.attachments[j]
		
		// If there are XML results, then process the xml results instead of
		// attaching a file
		if not isnull(lstr_attachment.xml_document) and isvalid(lstr_attachment.xml_document) then
			lstr_context = f_get_complete_context()
			lstr_context.observation_sequence = ll_parent_observation_sequence
			li_sts = lstr_attachment.xml_document.interpret(lstr_context, lstr_document_context)
			continue
		end if
		
		
		ls_comment_title = lstr_attachment.attachment_comment_title
		if trim(ls_comment_title) = "" then setnull(ls_comment_title)
		if isnull(ls_comment_title) then
			// If the comment_title is null then see how many pre-defined
			// external sources match this source
			ls_find = "upper(result_type)='ATTACHMENT'"
			ls_find += " and external_source='" + puo_observation.external_source + "'"
			ll_comment_title_count = 0
			ll_row = dw_physical.find(ls_find, 1, dw_physical.rowcount())
			DO WHILE ll_row > 0 and ll_row <= dw_physical.rowcount()
				ll_comment_title_count += 1
				lsa_comment_title[ll_comment_title_count] = dw_physical.object.comment_title[ll_row]
				
				ll_row = dw_physical.find(ls_find, ll_row + 1, dw_physical.rowcount() + 1)
			LOOP
			
			if ll_comment_title_count <= 0 then
				// We didn't find any, so use the source description
				ls_comment_title = datalist.external_source_description(puo_observation.external_source)
			elseif ll_comment_title_count = 1 then
				// We found exactly one, so link to it
				ls_comment_title = lsa_comment_title[1]
			else
				// We found more than one so prompt the user to pick one
				popup.data_row_count = ll_comment_title_count + 1
				popup.items = lsa_comment_title
				popup.items[popup.data_row_count] = "<None Of The Above>"
				openwithparm(w_pop_pick, popup)
				popup_return = message.powerobjectparm
				if popup_return.item_count <> 1 then
					setnull(ls_comment_title)
				elseif popup_return.item_indexes[1] > ll_comment_title_count then
					setnull(ls_comment_title)
				else
					ls_comment_title = lsa_comment_title[popup_return.item_indexes[1]]
				end if
			end if
		end if
		
		// First add the attachment to the database
		lstr_new_attachment.extension = lstr_attachment.extension
		lstr_new_attachment.attachment_type = lstr_attachment.attachment_type
		lstr_new_attachment.attachment_tag = ls_comment_title
		lstr_new_attachment.attachment_file = ls_comment_title
		if not isnull(lstr_attachment.attachment_comment) and (trim(lstr_attachment.attachment_comment) <> "") then
			lstr_new_attachment.attachment_text = trim(lstr_attachment.attachment_comment)
		else
			setnull(lstr_new_attachment.attachment_text)
		end if
		ll_attachment_id = current_patient.attachments.new_attachment(lstr_new_attachment, lstr_attachment.attachment)
		if ll_attachment_id <= 0 then
			log.log(this, "w_physical_exam:resu", "Error creating attachment", 4)
			return
		end if

		// Then create the p_observation_comment record
		service.treatment.add_attachment(ll_parent_observation_sequence, &
												ls_comment_title, &
												ll_attachment_id )
	next
next

display_observation()


end event

event source_connected;call super::source_connected;string ls_find
long ll_row
long ll_rows

ll_rows = dw_physical.rowcount()

ls_find = "external_source='" + puo_observation.external_source + "'"
ll_row = dw_physical.find(ls_find, 1, ll_rows)
DO WHILE ll_row > 0 and ll_row <= ll_rows
	dw_physical.object.connected[ll_row] = "Y"
	
	ll_row = dw_physical.find(ls_find, ll_row + 1, ll_rows + 1)
LOOP


end event

event source_disconnected;string ls_find
long ll_row
long ll_rows

ll_rows = dw_physical.rowcount()

ls_find = "external_source='" + puo_observation.external_source + "'"
ll_row = dw_physical.find(ls_find, 1, ll_rows)
DO WHILE ll_row > 0 and ll_row <= ll_rows
	dw_physical.object.connected[ll_row] = "N"
	
	ll_row = dw_physical.find(ls_find, ll_row + 1, ll_rows + 1)
LOOP


end event

event button_pressed;call super::button_pressed;str_popup_return popup_return

// If we return from a button press and the treatment has been cancelled, then
// just cancel this service
if upper(service.treatment.treatment_status) = "CANCELLED" then
	f_destroy_observation_sources(source_count, sources)
	
	popup_return.item_count = 1
	popup_return.items[1] = "CANCEL"
	
	closewithreturn(this, popup_return)
	return
end if

service.treatment.load_observations()
display_observation()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_physical_exam
boolean visible = true
integer x = 2441
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_physical_exam
end type

type st_page from statictext within w_physical_exam
integer x = 1879
integer y = 1488
integer width = 197
integer height = 56
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "99 of 99"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_up from picturebutton within w_physical_exam
integer x = 2235
integer y = 1488
integer width = 137
integer height = 116
integer taborder = 10
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_up.bmp"
string disabledname = "icon_upx.bmp"
end type

event clicked;integer li_page

li_page = dw_physical.current_page

dw_physical.set_page(li_page - 1, st_page.text)

if li_page <= 2 then enabled = false
pb_down.enabled = true
current_page[question_number] = dw_physical.current_page

end event

type pb_down from picturebutton within w_physical_exam
integer x = 2085
integer y = 1488
integer width = 137
integer height = 116
integer taborder = 40
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_down.bmp"
string disabledname = "icon_downx.bmp"
end type

event clicked;integer li_page
integer li_last_page

li_page = dw_physical.current_page
li_last_page = dw_physical.last_page

dw_physical.set_page(li_page + 1, st_page.text)

if li_page >= li_last_page - 1 then enabled = false
pb_up.enabled = true
current_page[question_number] = dw_physical.current_page

end event

type cb_done from commandbutton within w_physical_exam
integer x = 2427
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 140
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Finished"
end type

event clicked;str_popup_return popup_return
integer li_sts

f_destroy_observation_sources(source_count, sources)

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)

end event

type cb_be_back from commandbutton within w_physical_exam
integer x = 1961
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 110
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Be Back"
end type

event clicked;str_popup_return popup_return

f_destroy_observation_sources(source_count, sources)

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_physical_exam
integer x = 201
integer y = 8
integer width = 2217
integer height = 176
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
boolean enabled = false
string text = "Composite Observation"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_back from picturebutton within w_physical_exam
integer x = 2432
integer y = 1456
integer width = 174
integer height = 148
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_go_up.bmp"
string disabledname = "icon_go_up.bmp"
end type

event clicked;integer li_sts

if question_number > 1 then question_number -= 1

li_sts = display_observation()
if li_sts <= 0 then return


end event

type pb_image from picturebutton within w_physical_exam
integer x = 2711
integer y = 20
integer width = 174
integer height = 148
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_image.bmp"
end type

event clicked;integer li_sts


li_sts = service_list.do_service(current_patient.cpr_id, &
											service.encounter_id, &
											image_service, &
											service.treatment, &
											state_attributes)

service.treatment.load_observations()
display_observation()

end event

type pb_tree from picturebutton within w_physical_exam
integer x = 27
integer y = 20
integer width = 174
integer height = 148
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_tree.bmp"
end type

event clicked;str_popup popup
str_observation_stack lstr_stack

popup.data_row_count = 2
popup.items[1] = observation_id[1]
popup.items[2] = "N"
openwithparm(w_observation_tree_navigate, popup)
lstr_stack = message.powerobjectparm

if lstr_stack.root_observation_id = observation_id[1] then display_observation(lstr_stack)


end event

type pb_top from picturebutton within w_physical_exam
integer x = 2432
integer y = 1304
integer width = 174
integer height = 148
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "icon_top.bmp"
end type

event clicked;integer li_sts

question_number = 1

li_sts = display_observation()
if li_sts <= 0 then return


end event

type pb_next from picturebutton within w_physical_exam
integer x = 2619
integer y = 1304
integer width = 251
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "sbutton_next.bmp"
string disabledname = "sbutton_next_disabled.bmp"
end type

event clicked;integer li_sts

results_entered()

li_sts = display_observation()
if li_sts <= 0 then return


end event

type uo_standard_exams from u_standard_exams within w_physical_exam
integer x = 2427
integer y = 192
integer height = 1116
integer taborder = 110
end type

on uo_standard_exams.destroy
call u_standard_exams::destroy
end on

event exam_selected;call super::exam_selected;integer li_sts
string ls_exam_description
string ls_temp
long ll_null
str_popup_return popup_return

setnull(ll_null)

if service.treatment.any_results(observation_sequence[question_number], result_type) then
	ls_exam_description = datalist.exam_description(pl_exam_sequence)
	if isnull(ls_exam_description) then
		log.log(this, "w_physical_exam.uo_standard_exams.exam_selected:0012", "Exam not found (" + string(pl_exam_sequence) + ")", 4)
		return
	end if
	
	ls_temp = "Results have already been recorded for this " + service.treatment.treatment_description
	ls_temp += "  Are you sure you wish to apply the '" + ls_exam_description
	ls_temp += "' standard exam results?"
	openwithparm(w_pop_yes_no, ls_temp)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

li_sts = service.treatment.set_exam_defaults(pl_exam_sequence, ll_null, observation_sequence[question_number])

display_observation()

end event

event previous_exam_selected;integer li_sts
string ls_temp
str_popup_return popup_return
long ll_root_history_sequence
string ls_find
string ls_status
long ll_parent_observation_sequence
integer li_child_ordinal
long ll_row
u_ds_observation_results luo_results

if service.treatment.any_results(observation_sequence[question_number], result_type) then
	ls_temp = "Results have already been recorded for this " + service.treatment.treatment_description
	ls_temp += "  Are you sure you wish to apply the results from a previous exam?"
	openwithparm(w_pop_yes_no, ls_temp)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return
end if

// Retrieve all the results from the previous treatment
luo_results = CREATE u_ds_observation_results
luo_results.set_dataobject("dw_sp_obstree_treatment")
li_sts = luo_results.retrieve(current_patient.cpr_id, pl_treatment_id)
if li_sts <= 0 then return

setnull(ll_parent_observation_sequence)
li_child_ordinal = 1

// Copy the first root we find in the results datastore
ls_find = "record_type='Root'"
ll_row = luo_results.find(ls_find, 1, results.rowcount())
if ll_row > 0 then
	luo_results.copy_results(ll_row, &
								"N", &
								treatment, &
								ll_parent_observation_sequence, &
								li_child_ordinal, &
								service.observation_tag)
end if

display_observation()

end event

event set_exam_defaults;call super::set_exam_defaults;long ll_branch_id
 
 DECLARE lsp_set_exam_defaults_from_actuals PROCEDURE FOR dbo.sp_set_exam_defaults_from_actuals  
         @ps_user_id = :ps_user_id,   
         @pl_exam_sequence = :pl_exam_sequence,   
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_observation_sequence = :observation_sequence[question_number],   
         @pl_branch_id = :branch_id[question_number]  ;


EXECUTE lsp_set_exam_defaults_from_actuals;
if not tf_check() then return

end event

event clear_exam_defaults;call super::clear_exam_defaults;long ll_branch_id
 
 DECLARE lsp_clear_exam_defaults PROCEDURE FOR dbo.sp_clear_exam_defaults  
         @ps_user_id = :ps_user_id,   
         @pl_exam_sequence = :pl_exam_sequence,   
         @pl_branch_id = :branch_id[question_number]  ;


EXECUTE lsp_clear_exam_defaults;
if not tf_check() then return

end event

type cb_clear_all from commandbutton within w_physical_exam
integer x = 2505
integer y = 1412
integer width = 288
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Clear All"
end type

event clicked;string ls_temp

ls_temp = "Are you sure you wish to clear all the results?"
openwithparm(w_pop_ok, ls_temp)
if message.doubleparm <> 1 then return

service.treatment.remove_results(observation_sequence[question_number])

display_observation()

end event

type pb_prev from picturebutton within w_physical_exam
integer x = 2619
integer y = 1492
integer width = 251
integer height = 112
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "ssbutton_prev.bmp"
string disabledname = "ssbutton_prev_disabled.bmp"
end type

event clicked;integer li_sts

prev_simple_observation()

li_sts = display_observation()
if li_sts <= 0 then return


end event

type cb_do_later from commandbutton within w_physical_exam
integer x = 1495
integer y = 1620
integer width = 443
integer height = 108
integer taborder = 120
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "I~'ll Do Later"
end type

event clicked;str_popup_return popup_return

f_destroy_observation_sources(source_count, sources)

popup_return.item_count = 1
popup_return.items[1] = "DOLATER"

closewithreturn(parent, popup_return)

end event

type dw_physical from u_dw_pick_list within w_physical_exam
integer x = 27
integer y = 192
integer width = 2400
integer height = 1280
integer taborder = 20
string dataobject = "dw_physical_exam"
boolean border = false
end type

event clicked;string ls_result_type
string ls_composite_flag
string ls_default_view
integer li_child_ordinal
integer li_result_sequence
string ls_location
str_popup popup
str_popup_return popup_return
string ls_description
integer li_sts
integer li_selected_flag
string ls_location_domain
string ls_results
string ls_column
string ls_child_observation_id
long ll_child_observation_sequence
long ll_branch_id
string ls_temp
string ls_comment_user_id
integer li_comment_max_chars
str_attributes lstr_state_attributes
string ls_comment_title
string ls_external_source
string ls_exclusive_flag
long ll_observation_comment_id
w_physical_exam lw_this
string ls_observation_tag
long ll_stage
string ls_edit_service
str_attributes lstr_attributes
long ll_exam_sequence
long ll_parent_observation_sequence
string ls_property_context_object
string ls_property
str_property lstr_property
string ls_null

setnull(ls_null)

lw_this = parent

setnull(ll_stage)

// make sure dwo is valid
if isnull(dwo) or not isvalid(dwo) then return
if row <= 0 or isnull(row) then return
//if isnull(lasttype) or lasttype <> "column" then return

ll_branch_id = object.branch_id[row]
ls_child_observation_id = object.observation_id[row]
ll_child_observation_sequence = object.child_observation_sequence[row]
ll_parent_observation_sequence = object.parent_observation_sequence[row]
li_child_ordinal = object.child_ordinal[row]
if isnull(li_child_ordinal) or li_child_ordinal <= 0 then li_child_ordinal = 1
ls_observation_tag = object.observation_tag[row]
ls_description = object.description[row]
ll_observation_comment_id = object.observation_comment_id[row]
ls_result_type = object.result_type[row]
ls_location = object.location[row]
li_result_sequence = object.result_sequence[row]
ls_location_domain = object.location_domain[row]
ls_external_source = object.external_source[row]
ls_comment_title = object.comment_title[row]
ls_edit_service = object.edit_service[row]
ls_property_context_object = object.property_context_object[row]
ls_property = object.property[row]

ls_composite_flag = datalist.observation_composite_flag(observation_id[question_number])
ls_exclusive_flag = datalist.observation_exclusive_flag(observation_id[question_number])
ls_default_view = datalist.observation_default_view(observation_id[question_number])
if isnull(ls_default_view) then ls_default_view = "R"

ls_column = upper(dwo.name)

if isnull(ll_parent_observation_sequence) or (ll_parent_observation_sequence = observation_sequence[question_number]) then
	li_selected_flag = object.selected_flag[row]
else
	li_selected_flag = 0
end if

CHOOSE CASE ls_column
	CASE "DESCRIPTION"
		CHOOSE CASE upper(ls_result_type)
			CASE "PROPERTY"
				// clear the property specified by the function name
				current_patient.treatments.set_treatment_progress( service.treatment.treatment_id, "Property", ls_property, ls_null)
			CASE "COLLECT", "PERFORM"
				if not isnull(li_result_sequence) and ls_location_domain = "NA" then
					// If we're only showing results then toggle it on and off
					if li_selected_flag = 1 then
						li_sts = service.treatment.remove_results(observation_sequence[question_number], li_result_sequence)
						if li_sts <= 0 then return
					else
						li_sts = service.treatment.set_result(observation_sequence[question_number], li_result_sequence, "NA")
						if li_sts <= 0 then return
						// If the exclusive flag is set then automatically go to the next simple observation
						if ls_exclusive_flag = "Y" then
							results_entered()
						end if
					end if
				else
					if li_selected_flag = 1 then
						ls_temp = "Are you sure you wish to remove all the results for '" + ls_description + "'?"
						openwithparm(w_pop_yes_no, ls_temp)
						popup_return = message.powerobjectparm
						if popup_return.item <> "YES" then return
						
						// remove all the results from this location or all the locations from this result
						if not isnull(li_result_sequence) then
							li_sts = service.treatment.remove_results(observation_sequence[question_number], li_result_sequence)
							if li_sts <= 0 then return
						elseif not isnull(ls_location) then
							li_sts = service.treatment.remove_results(observation_sequence[question_number], ls_location)
							if li_sts <= 0 then return
						end if
					else
						// If we're not selected then set the appropriate defaults
						ll_exam_sequence = uo_standard_exams.exam_sequence
						if isnull(ll_exam_sequence) or ll_exam_sequence <= 0 then
							ll_exam_sequence = datalist.observation_default_exam_sequence(observation_id[1])
						end if
						service.treatment.set_exam_defaults( ll_exam_sequence, branch_id[question_number], observation_sequence[question_number], li_result_sequence, ls_location)
					end if
				end if
			CASE "COMMENT"
				if li_selected_flag = 1 then
					if not isnull(ll_observation_comment_id) then
						ls_temp = "Are you sure you wish to remove this comment?"
						openwithparm(w_pop_yes_no, ls_temp)
						popup_return = message.powerobjectparm
						if popup_return.item <> "YES" then return
						
						service.treatment.remove_comment(observation_sequence[question_number], ll_observation_comment_id)
					end if
				end if
			CASE "ATTACHMENT"
				if li_selected_flag = 1 then
					if not isnull(ll_observation_comment_id) then
						popup.data_row_count = 2
						popup.items[1] = "Remove Attachment"
						popup.items[2] = "Reacquire Attachment"
						openwithparm(w_pop_pick, popup)
						popup_return = message.powerobjectparm
						if popup_return.item_count <> 1 then return
						
						if popup_return.item_indexes[1] = 1 then
							service.treatment.remove_comment(observation_sequence[question_number], ll_observation_comment_id)
							display_observation()
							return
						else
							do_source(row)
						end if
					end if
				else
					do_source(row)
				end if
						
			CASE ELSE
				// If there's no result_type then this is probabaly a composite observation
				if ls_composite_flag = "Y" then
					if li_selected_flag = 1 then
						if display_context = "patient" then
							openwithparm(w_pop_message, "EncounterPRO is not able to remove results from composite observations in history mode.  Please drill down and remove the results individually.")
						else
							ls_temp = "Are you sure you wish to remove all the results for '" + ls_description + "'?"
							openwithparm(w_pop_yes_no, ls_temp)
							popup_return = message.powerobjectparm
							if popup_return.item <> "YES" then return
	
							// results were selected, so unselect them
							if not isnull(ll_child_observation_sequence) then
								service.treatment.remove_results(ll_child_observation_sequence)
							end if
						end if
					else
						// Results weren't yet selected, so set the defaults
						if isnull(ll_child_observation_sequence) then
							// If the datawindow didn't have the child_observation_sequence, then find/add it
							ll_child_observation_sequence = service.treatment.add_observation( &
																					observation_sequence[question_number], &
																					ls_child_observation_id, &
																					li_child_ordinal, &
																					ls_observation_tag, &
																					ll_stage, &
																					true)
							if ll_child_observation_sequence <= 0 then
								log.log(this, "w_physical_exam.dw_physical.clicked:0187", "Error adding/finding child observation_sequence", 4)
								return
							end if
						end if
						
						ll_exam_sequence = uo_standard_exams.exam_sequence
						if isnull(ll_exam_sequence) or ll_exam_sequence <= 0 then
							ll_exam_sequence = datalist.observation_default_exam_sequence(observation_id[1])
						end if
						service.treatment.set_exam_defaults( ll_exam_sequence, ll_branch_id, ll_child_observation_sequence)
					end if
				end if
		END CHOOSE
	CASE "RESULTS", "T_RESULTS"
		// We clicked the right side so first let's see what we clicked
		CHOOSE CASE upper(ls_result_type)
			CASE "PROPERTY"
				lstr_property = datalist.find_property(ls_property_context_object, ls_property)
				if not isnull(ls_edit_service) then
					// If we have an edit_service, then call the service
					lstr_attributes.attribute_count = 5
					lstr_attributes.attribute[1].attribute = "treatment_id"
					lstr_attributes.attribute[1].value = string(service.treatment.treatment_id)
					lstr_attributes.attribute[2].attribute = "observation_sequence"
					lstr_attributes.attribute[2].value = string(ll_child_observation_sequence)
					lstr_attributes.attribute[3].attribute = "result_sequence"
					lstr_attributes.attribute[3].value = string(li_result_sequence)
					lstr_attributes.attribute[4].attribute = "location"
					lstr_attributes.attribute[4].value = string(ls_location)
					lstr_attributes.attribute[5].attribute = "progress_key"
					lstr_attributes.attribute[5].value = lstr_property.function_name
					
					// Call service with attributes
					li_sts = service_list.do_service( &
																current_patient.cpr_id, &
																service.encounter_id, &
																ls_edit_service, &
																service.treatment, &
																lstr_attributes )
				end if
			CASE "PERFORM"
				popup.data_row_count = 5
				popup.objectparm = service.treatment
				popup.items[1] = string(observation_sequence[question_number])
				popup.items[2] = observation_id[question_number]
				popup.items[3] = ls_default_view
				if ls_default_view = "R" then
					li_result_sequence = object.result_sequence[row]
					popup.items[4] = string(li_result_sequence)
				else
					ls_location = object.location[row]
					popup.items[4] = ls_location
				end if
				popup.items[5] = result_type
				
				openwithparm(w_observation_result_pick, popup)
			CASE "COLLECT"
			CASE "COMMENT", "ATTACHMENT"
				lstr_state_attributes.attribute_count = 4
				lstr_state_attributes.attribute[1].attribute = "observation_id"
				lstr_state_attributes.attribute[1].value = observation_id[question_number]
				lstr_state_attributes.attribute[2].attribute = "observation_sequence"
				lstr_state_attributes.attribute[2].value = string(observation_sequence[question_number])
				lstr_state_attributes.attribute[3].attribute = "treatment_type"
				lstr_state_attributes.attribute[3].value = service.treatment.treatment_type
				lstr_state_attributes.attribute[3].attribute = "treatment_id"
				lstr_state_attributes.attribute[3].value = string(service.treatment.treatment_id)
				
				if isnull(ll_observation_comment_id) then
					if ls_result_type = "ATTACHMENT" then
						// if this is an attachment record and there isn't an attachment yet, then
						// use the external_source service instead of the comment service
						do_source(row)
						display_observation()
						return
					end if
				else
					lstr_state_attributes.attribute_count += 1
					lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].attribute = "observation_comment_id"
					lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].value = string(ll_observation_comment_id)
				end if
				
				if not isnull(ls_external_source) then
					lstr_state_attributes.attribute_count += 1
					lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].value = ls_external_source
					lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].attribute = "external_source"
				end if

				if not isnull(ls_comment_title) then
					lstr_state_attributes.attribute_count += 1
					lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].attribute = "comment_title"
					lstr_state_attributes.attribute[lstr_state_attributes.attribute_count].value = ls_comment_title
				end if
				
				service_list.do_service(current_patient.cpr_id, service.encounter_id, comment_service, service.treatment, lstr_state_attributes)
			CASE ELSE
				// First get the observation_sequence of the row just clicked
				if isnull(ll_child_observation_sequence) then
					ll_child_observation_sequence = service.treatment.add_observation( &
																					observation_sequence[question_number], &
																					ls_child_observation_id, &
																					li_child_ordinal, &
																					ls_observation_tag, &
																					ll_stage, &
																					true)
					if isnull(ll_child_observation_sequence) then
						log.log(this, "w_physical_exam.dw_physical.clicked:0293", "Unable to get child_observation_sequence", 4)
						return
					end if
				end if
				// We don't have a result type so see if we have an edit_service
				// or a branch_id
				// If we found a branch_id then drill down
				question_number += 1
				lw_this.current_page[question_number] = 1
				branch_id[question_number] = ll_branch_id
				observation_id[question_number] = ls_child_observation_id
				observation_sequence[question_number] = ll_child_observation_sequence
				child_ordinal[question_number] = li_child_ordinal
				edit_service[question_number] = ls_edit_service
		END CHOOSE
		
END CHOOSE

display_observation()


end event

event constructor;call super::constructor;multiselect = true

end event

type cb_legal_notice from commandbutton within w_physical_exam
integer x = 1216
integer y = 1496
integer width = 416
integer height = 92
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Legal Notice"
end type

event clicked;openwithparm(w_pop_message, legal_notice)

end event

