$PBExportHeader$u_dw_parent_observation_list.sru
forward
global type u_dw_parent_observation_list from u_dw_pick_list
end type
end forward

global type u_dw_parent_observation_list from u_dw_pick_list
integer width = 1115
integer height = 1220
string dataobject = "dw_parent_observation_list"
borderstyle borderstyle = stylelowered!
end type
global u_dw_parent_observation_list u_dw_parent_observation_list

type variables
u_ds_data results
long result_count

string observation_id

u_rich_text_edit rtf

end variables

forward prototypes
public function integer initialize (string ps_observation_id, u_rich_text_edit puo_rtf)
public function integer display_history (long pl_row)
public function integer display_history_simple (long pl_parent_history_sequence)
public function integer display_history_composite (long pl_parent_history_sequence)
end prototypes

public function integer initialize (string ps_observation_id, u_rich_text_edit puo_rtf);string ls_find
long ll_root
long ll_row
long ll_parent_history_sequence
long ll_history_sequence
string ls_observation_id
string ls_description
long ll_parent_row

observation_id = ps_observation_id
rtf = puo_rtf

result_count = results.retrieve(observation_id)
if result_count < 0 then return -1

if result_count = 0 then return 0

ls_find = "record_type='Root'"
ll_root = results.find(ls_find, 1, result_count)
if ll_root <= 0 then
	log.log(this, "u_dw_parent_observation_list.initialize:0021", "root result not found", 4)
	return -1
end if

ll_parent_history_sequence = results.object.history_sequence[ll_root]
ls_find = "parent_history_sequence=" + string(ll_parent_history_sequence)
ll_row = results.find(ls_find, 1, result_count)
DO WHILE ll_row > 0 and ll_row <= result_count
	ls_observation_id = results.object.observation_id[ll_row]
	ls_description = results.object.observation_description[ll_row]
	ll_history_sequence = results.object.history_sequence[ll_row]

	ll_parent_row = insertrow(0)
	object.observation_id[ll_parent_row] = ls_observation_id
	object.observation_description[ll_parent_row] = ls_description
	object.history_sequence[ll_parent_row] = ll_history_sequence

	ll_row = results.find(ls_find, ll_row + 1, result_count + 1)
LOOP

return 1

end function

public function integer display_history (long pl_row);long ll_history_sequence
string ls_rtf
string ls_composite_flag
integer li_sts
long ll_row
string ls_find

ll_history_sequence = object.history_sequence[pl_row]

rtf.clear_rtf()

ls_find = "history_sequence=" + string(ll_history_sequence)
ll_row = results.find(ls_find, 1, result_count)
if ll_row > 0 then
	ls_composite_flag = results.object.composite_flag[ll_row]
	if ls_composite_flag = "Y" then
		li_sts = display_history_composite(ll_history_sequence)
	else
		li_sts = display_history_simple(ll_history_sequence)
	end if
else
	li_sts = 0
end if

return li_sts

end function

public function integer display_history_simple (long pl_parent_history_sequence);long ll_row
string ls_find
string ls_record_type
string ls_composite_flag
long ll_history_sequence
string ls_observation_description
integer li_sts
integer li_count


// Get the observation description from the parent observation
ls_find = "history_sequence=" + string(pl_parent_history_sequence)
ll_row = results.find(ls_find, 1, result_count)
if ll_row > 0 then
	ls_observation_description = results.object.observation_description[ll_row]
else
	return 0
end if

// Now find all the result children
ls_find = "parent_history_sequence=" + string(pl_parent_history_sequence)
ls_find += " and record_type='Result'"
ll_row = results.find(ls_find, 1, result_count)

// If we found at least one result then go ahead and add the observation description
// to the rtf control
if ll_row > 0 then
	rtf.add_text(ls_observation_description)
	rtf.add_tab()
end if

DO WHILE ll_row > 0 and ll_row <= result_count
	
	ll_row = results.find(ls_find, ll_row + 1, result_count + 1)
LOOP

return li_count

end function

public function integer display_history_composite (long pl_parent_history_sequence);long ll_row
string ls_find
string ls_record_type
string ls_composite_flag
long ll_history_sequence
string ls_observation_description
integer li_sts
integer li_count

li_count = 0

// Get the observation description from the parent observation
ls_find = "history_sequence=" + string(pl_parent_history_sequence)
ll_row = results.find(ls_find, 1, result_count)
if ll_row > 0 then
	ls_observation_description = results.object.observation_description[ll_row]
else
	return 0
end if

ls_find = "parent_history_sequence=" + string(pl_parent_history_sequence)
ll_row = results.find(ls_find, 1, result_count)

// If we found at least one result then go ahead and add the observation description
// to the rtf control
if ll_row <= 0 then return 0

rtf.add_text(ls_observation_description)
rtf.add_cr()
rtf.next_level()

DO WHILE ll_row > 0 and ll_row <= result_count
	ls_composite_flag = results.object.composite_flag[ll_row]
	ll_history_sequence = results.object.history_sequence[ll_row]
	
	if ls_composite_flag = "Y" then
		li_sts = display_history_composite(ll_history_sequence)
	else
		li_sts = display_history_simple(ll_history_sequence)
	end if
	
	if li_sts > 0 then li_count += 1

	ll_row = results.find(ls_find, ll_row + 1, result_count + 1)
LOOP

// If we didn't find any children with results then remove this observation
if li_count <= 0 then rtf.delete_last_line()

// return to previous level before returning
rtf.prev_level()

return li_count

end function

on u_dw_parent_observation_list.create
end on

on u_dw_parent_observation_list.destroy
end on

event constructor;results = CREATE u_ds_data
results.set_dataobject("dw_sp_obstree_patient")


end event

event destructor;DESTROY u_ds_data

end event

event selected;call super::selected;
display_history(selected_row)

end event

event unselected;rtf.clear_rtf()

end event

