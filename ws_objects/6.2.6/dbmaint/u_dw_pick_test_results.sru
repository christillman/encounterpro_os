HA$PBExportHeader$u_dw_pick_test_results.sru
//
//EncounterPRO Open Source Project
//
//Copyright 2010 EncounterPRO Healthcare Resources, Inc.
//
//This program is free software: you can redistribute it and/or modify it under the terms
//of the GNU Affero General Public License as published by  the Free Software Foundation, 
//either version 3 of the License, or (at your option) any later version.
//
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//See the GNU Affero General Public License for more details.
//
//You should have received a copy of the GNU Affero General Public License along with this
//program.  If not, see <http://www.gnu.org/licenses/>.
//
//EncounterPRO Open Source Project (“The Project”) is distributed under the GNU Affero
//General Public License version 3, or any later version.  As such, linking the Project
//statically or dynamically with other components is making a combined work based on the
//Project. Thus, the terms and conditions of the GNU Affero General Public License 
//version 3, or any later version, cover the whole combination. 
//
//However, as an additional permission, the copyright holders of EncounterPRO Open Source 
//Project give you permission to link the Project with independent components, regardless 
//of the license terms of these independent components, provided that all of the following
//are true:
// 
//1) all access from the independent component to persisted data which resides inside any 
//   EncounterPRO Open Source data store (e.g. SQL Server database) be made through a 
//   publically available database driver (e.g. ODBC, SQL Native Client, etc) or through 
//   a service which itself is part of The Project.
//2) the independent component does not create or rely on any code or data structures 
//   within the EncounterPRO Open Source data store unless such code or data structures, 
//   and all code and data structures referred to by such code or data structures, are 
//   themselves part of The Project.
//3) the independent component either a) runs locally on the user's computer, or b) is 
//   linked to at runtime by The Project’s Component Manager object which in turn is 
//   called by code which itself is part of The Project.
//
//An independent component is a component which is not derived from or based on the
//Project. If you modify the Project, you may extend this additional permission to your
//version of the Project, but you are not obligated to do so. If you do not wish to do
//so, delete this additional permission statement from your version. 
forward
global type u_dw_pick_test_results from u_dw_pick_list
end type
end forward

global type u_dw_pick_test_results from u_dw_pick_list
int Width=2208
int Height=1564
string DataObject="dw_pick_result_by_loc"
boolean LiveScroll=false
end type
global u_dw_pick_test_results u_dw_pick_test_results

type variables
u_str_encounter encounter
long treatment_id
string observation_id
string location_domain

string no_loc_text = "Results..."


end variables

forward prototypes
public function integer count_results ()
public function integer display_results (u_str_encounter puo_encounter, long pl_treatment_id, string ps_observation_id, string ps_location_domain)
public function integer display_results_with_loc (long pl_treatment_id, string ps_observation_id, string ps_location_domain)
public function integer display_results_without_loc (long pl_treatment_id, string ps_observation_id)
end prototypes

public function integer count_results ();integer i
integer li_count
integer li_temp

li_count = 0

if location_domain = "NA" then
	li_count = count_selected()
else
	for i = 1 to rowcount()
		li_temp = object.result_count[i]
		li_count += li_temp
	next
end if


return li_count

end function

public function integer display_results (u_str_encounter puo_encounter, long pl_treatment_id, string ps_observation_id, string ps_location_domain);encounter = puo_encounter
treatment_id = pl_treatment_id
observation_id = ps_observation_id
location_domain = ps_location_domain

if location_domain = "NA" then
	return display_results_without_loc(treatment_id, observation_id)
else
	return display_results_with_loc(treatment_id, observation_id, location_domain)
end if

end function

public function integer display_results_with_loc (long pl_treatment_id, string ps_observation_id, string ps_location_domain);integer i, li_result_count, li_location_index, li_sts
boolean lb_loop
string ls_result_list, ls_result_item
string ls_last_location, ls_last_location_description
long ll_row, ll_attachment_id
real lr_result_amount
string ls_result_amount_flag, ls_result_unit
u_str_location_domain luo_location_domain

integer li_result_sequence
string ls_result
integer li_result_sort_sequence
integer li_sort_sequence
string ls_status
string ls_location
string ls_location_description
long ll_encounter_id

 DECLARE lsp_get_results_by_loc PROCEDURE FOR dbo.sp_get_results_by_loc  
         @ps_cpr_id = :current_patient.cpr_id,   
         @pl_treatment_id = :pl_treatment_id,   
         @ps_observation_id = :ps_observation_id  ;

dataobject = "dw_pick_result_by_loc"

luo_location_domain = CREATE u_str_location_domain
li_sts = luo_location_domain.initialize(ps_location_domain)
if li_sts < 0 then
	log.log(this, "display_results_by_loc()", "Invalid location domain (" + ps_location_domain + ")", 4)
	DESTROY luo_location_domain
	return -1
end if

setredraw(false)

reset()

EXECUTE lsp_get_results_by_loc;
if not tf_check() then
	DESTROY luo_location_domain
	return -1
end if

setnull(ls_last_location)
lb_loop = true
li_location_index = 1

do
	FETCH lsp_get_results_by_loc INTO
		:ps_location_domain,
		:ls_location,
		:ls_location_description,
		:li_sort_sequence,
		:li_result_sequence,
		:ls_result,
		:ls_result_amount_flag,
		:ls_result_unit,
		:li_result_sort_sequence,
		:ls_status,
		:lr_result_amount,
		:ll_attachment_id,
		:ll_encounter_id;
	if not tf_check() then return -1

	if sqlca.sqlcode = 100 then
		lb_loop = false
		setnull(ls_location)
	else
		if ls_result_amount_flag = "Y" then
			ls_result_item = ls_result + "=" + f_pretty_amount_unit(lr_result_amount, ls_result_unit)
		else
			ls_result_item = ls_result
		end if
	end if

	if ls_location = ls_last_location then
		ls_result_list += "~n" + ls_result_item
		li_result_count += 1
	else
		if not isnull(ls_last_location) then
			do while luo_location_domain.location[li_location_index].location <> ls_last_location &
          and li_location_index <= luo_location_domain.location_count
				ll_row = insertrow(0)
				setitem(ll_row, "location", luo_location_domain.location[li_location_index].location)
				setitem(ll_row, "description", luo_location_domain.location[li_location_index].description)
				setitem(ll_row, "location_domain", ps_location_domain)
				setitem(ll_row, "results", no_loc_text)
				setitem(ll_row, "result_count", 0)
				li_location_index += 1
			loop

			ll_row = insertrow(0)
			setitem(ll_row, "location", ls_last_location)
			setitem(ll_row, "description", ls_last_location_description)
			setitem(ll_row, "location_domain", ps_location_domain)
			setitem(ll_row, "results", ls_result_list)
			setitem(ll_row, "result_count", li_result_count)
			setitem(ll_row, "encounter_id", ll_encounter_id)

			if li_location_index <= luo_location_domain.location_count then li_location_index += 1
		end if

		ls_last_location = ls_location
		ls_last_location_description = ls_location_description
		ls_result_list = ls_result_item
		li_result_count = 1
	end if

loop while lb_loop

CLOSE lsp_get_results_by_loc;

do while li_location_index <= luo_location_domain.location_count
	ll_row = insertrow(0)
	setitem(ll_row, "location", luo_location_domain.location[li_location_index].location)
	setitem(ll_row, "description", luo_location_domain.location[li_location_index].description)
	setitem(ll_row, "location_domain", ps_location_domain)
	setitem(ll_row, "results", no_loc_text)
	setitem(ll_row, "result_count", 0)
	li_location_index += 1
loop

setredraw(true)

postevent("redisplay")

DESTROY luo_location_domain

return 1

end function

public function integer display_results_without_loc (long pl_treatment_id, string ps_observation_id);integer i, li_selected_flag
boolean lb_loop
long ll_row
string ls_result_string
long ll_encounter_id
string ls_result_amount_flag
string ls_result_unit
real lr_result_amount
long ll_attachment_id
integer li_result_sequence
string ls_result
integer li_sort_sequence
string ls_location
string ls_pretty_amount_unit

 DECLARE lsp_get_result_list PROCEDURE FOR dbo.sp_get_result_list
         @ps_cpr_id = :encounter.parent_patient.cpr_id,   
         @pl_treatment_id = :pl_treatment_id,   
         @ps_observation_id = :ps_observation_id,
			@ps_location = :ls_location  ;


dataobject = "dw_pick_result_na"

setredraw(false)

reset()

ls_location = "NA"

EXECUTE lsp_get_result_list;
if not tf_check() then return -1

lb_loop = true

do
	FETCH lsp_get_result_list INTO
		:ls_result,
		:ls_result_amount_flag,
		:ls_result_unit,
		:li_result_sequence,
		:li_sort_sequence,
		:lr_result_amount,
		:ll_attachment_id,
		:ll_encounter_id,
		:li_selected_flag,
		:ls_pretty_amount_unit;
	if not tf_check() then return -1

	if sqlca.sqlcode = 100 then
		lb_loop = false
	else
		if ls_result_amount_flag = "Y" then
			if li_selected_flag = 0 then
				ls_result_string = ls_result + "="
			else
				ls_result_string = ls_result + "=" + f_pretty_amount_unit(lr_result_amount, ls_result_unit)
			end if
		else
			ls_result_string = ls_result
		end if
		ll_row = insertrow(0)
		setitem(ll_row, "result_sequence", li_result_sequence)
		setitem(ll_row, "result", ls_result_string)
		setitem(ll_row, "selected_flag", li_selected_flag)
		setitem(ll_row, "result_amount_flag", ls_result_amount_flag)
		setitem(ll_row, "result_unit", ls_result_unit)
		setitem(ll_row, "result_amount", lr_result_amount)
		setitem(ll_row, "encounter_id", ll_encounter_id)
	end if

loop while lb_loop

CLOSE lsp_get_result_list;

setredraw(true)

postevent("redisplay")

return 1

end function

event constructor;modify("locations.alignment='2~tif(location_count=0,2,0)'")
multiselect = true


end event

