$PBExportHeader$u_tab_history_parents.sru
forward
global type u_tab_history_parents from u_tab_manager
end type
type tabpage_by_treatment from u_tabpage_history_parents_treatments within u_tab_history_parents
end type
type tabpage_by_treatment from u_tabpage_history_parents_treatments within u_tab_history_parents
end type
type tabpage_encounter from u_tabpage_history_parents_encounter within u_tab_history_parents
end type
type tabpage_encounter from u_tabpage_history_parents_encounter within u_tab_history_parents
end type
type tabpage_patient from u_tabpage_history_parents_patient within u_tab_history_parents
end type
type tabpage_patient from u_tabpage_history_parents_patient within u_tab_history_parents
end type
end forward

global type u_tab_history_parents from u_tab_manager
integer width = 1179
integer height = 1264
long backcolor = 33538240
boolean boldselectedtext = true
tabposition tabposition = tabsonbottom!
integer selectedtab = 3
tabpage_by_treatment tabpage_by_treatment
tabpage_encounter tabpage_encounter
tabpage_patient tabpage_patient
end type
global u_tab_history_parents u_tab_history_parents

type variables
string default_edit_service
string default_comment_service
string edit_service
string observation_id

string abnormal_flag = "N"

u_dw_pick_list pretty_results_display

end variables
forward prototypes
public subroutine history_clicked ()
public function boolean get_treatment (string ps_observation_id, ref u_component_treatment puo_treatment)
public function integer initialize (u_component_service puo_service, u_dw_pick_list puo_datawindow)
public subroutine refresh_display (str_pretty_results pstr_results)
end prototypes

public subroutine history_clicked ();U_tabpage_history_parents luo_tab

if selectedtab > 0 then
	luo_tab = pages[selectedtab]
	luo_tab.history_clicked()
end if


end subroutine

public function boolean get_treatment (string ps_observation_id, ref u_component_treatment puo_treatment);// This method checks to see if the appropriate treatment object already exists
// and returns it if it does.  If it does not exist, this method creates a new
// treatment object.
//
//  Returns:	True	=	The treatment object was created specifically for this call
//					False	=	The treatment object already existed for this call
//
//

integer li_page
integer li_sts
Integer						i
datetime						ldt_begin_date
date							ld_begin_date
String						ls_treatment_type,ls_temp
str_popup popup
str_popup_return popup_return
u_ds_data luo_data
long ll_count
integer li_treatment_count
str_treatment_description lstra_treatments[]
string ls_find
boolean lb_my_treatment

setnull(puo_treatment)
lb_my_treatment = false

// First determine the treatment type.  If one is not specified in this
// service, then select one from the treatment types associated with
// this observation
ls_treatment_type = service.get_attribute("treatment_type")
if isnull(ls_treatment_type) Then
	luo_data = CREATE u_ds_data
	luo_data.set_dataobject("dw_observation_treatment_type_display")
	ll_count = luo_data.retrieve(ps_observation_id)
	if ll_count <= 0 then
		DESTROY luo_data
		return false
	end if
	if ll_count = 1 then
		ls_treatment_type = luo_data.object.treatment_type[1]
	else
		popup.title = "Select Treatment type"
		popup.data_row_count = ll_count
		for i = 1 to ll_count
			popup.items[i] = luo_data.object.description[i]
		next
		openwithparm(w_pop_pick, popup)
		popup_return = message.powerobjectparm
		if popup_return.item_count <> 1 then return false
		
		ls_treatment_type = luo_data.object.treatment_type[popup_return.item_indexes[1]]
	end if
	DESTROY luo_data
end if

// See if we have a treatment context
puo_treatment = service.get_treatment_context()
if not isnull(puo_treatment) then
	if puo_treatment.treatment_type <> ls_treatment_type then
		setnull(puo_treatment)
	end if
end if

if isnull(puo_treatment) then
	// See if the desired treatment already exists
	if isnull(service.encounter_id) then
		li_treatment_count = 0
	else
		ls_find = "treatment_type='" + ls_treatment_type + "'"
		ls_find += " and observation_id='" + observation_id + "'"
		ls_find += " and open_encounter_id=" + string(service.encounter_id)
		ls_find += " and ordered_by='" + current_user.user_id + "'"
		
		li_treatment_count = current_patient.treatments.get_treatments(ls_find, lstra_treatments)
	end if
	
	if li_treatment_count > 0 then
		li_sts = current_patient.treatments.treatment(puo_treatment, lstra_treatments[li_treatment_count].treatment_id)
	else
		puo_treatment = f_get_treatment_component(ls_treatment_type)
		If isnull(puo_treatment) Then Return false
		
		puo_treatment.reset()
		puo_treatment.parent_patient = current_patient
		puo_treatment.open_encounter_id = service.encounter_id
		puo_treatment.treatment_type = ls_treatment_type
		Setnull(puo_treatment.treatment_id)
		puo_treatment.ordered_by = current_user.user_id
		puo_treatment.created_by = current_scribe.user_id
		puo_treatment.past_treatment = true
		puo_treatment.observation_id = observation_id
		
		puo_treatment.treatment_description = datalist.observation_description(ps_observation_id)
		
		li_sts = current_patient.treatments.new_treatment(puo_treatment, false)
		lb_my_treatment = true
	end if
	
	if li_sts <= 0 then
		setnull(puo_treatment)
		return false
	end if
end if

return lb_my_treatment


end function

public function integer initialize (u_component_service puo_service, u_dw_pick_list puo_datawindow);integer i
u_tabpage_history_parents luo_tab

setnull(edit_service)

service = puo_service
pretty_results_display = puo_datawindow

observation_id = service.root_observation_id()
if isnull(observation_id) then
	log.log(this, "u_tab_history_parents.initialize:0011", "No observation_id", 4)
	return -1
end if

default_edit_service = service.get_attribute("edit_service")
default_comment_service = service.get_attribute("comment_service")

page_count = upperbound(control)

for i = 1 to page_count
	pages[i] = control[i]
	luo_tab = pages[i]
	luo_tab.tab_parents = this
	luo_tab.service = service
	luo_tab.initialize()
next

return 1

end function

public subroutine refresh_display (str_pretty_results pstr_results);long ll_row
long i

pretty_results_display.setredraw(false)
pretty_results_display.reset( )
for i = 1 to pstr_results.result_count
	ll_row = pretty_results_display.insertrow(0)
	pretty_results_display.object.test_name[ll_row] = pstr_results.result[i].test_name
	pretty_results_display.object.result[ll_row] = pstr_results.result[i].result
	pretty_results_display.object.result_date_time[ll_row] = pstr_results.result[i].result_date_time
	pretty_results_display.object.location_result_sequence[ll_row] = pstr_results.result[i].location_result_sequence
	pretty_results_display.object.observation_sequence[ll_row] = pstr_results.result[i].observation_sequence
	pretty_results_display.object.sort_sequence[ll_row] = pstr_results.result[i].sort_sequence
	pretty_results_display.object.abnormal_flag[ll_row] = pstr_results.result[i].abnormal_flag
	pretty_results_display.object.normal_range[ll_row] = pstr_results.result[i].normal_range
	pretty_results_display.object.observed_by[ll_row] = pstr_results.result[i].observed_by
	pretty_results_display.object.observed_by_name[ll_row] = user_list.user_full_name(pstr_results.result[i].observed_by)
	pretty_results_display.object.parent_sequence[ll_row] = pstr_results.result[i].parent_sequence
	pretty_results_display.object.parent_observation_description[ll_row] = pstr_results.result[i].parent_observation_description
next
pretty_results_display.sort()
pretty_results_display.groupcalc()
pretty_results_display.expandall()
pretty_results_display.setredraw(true)

end subroutine

on u_tab_history_parents.create
this.tabpage_by_treatment=create tabpage_by_treatment
this.tabpage_encounter=create tabpage_encounter
this.tabpage_patient=create tabpage_patient
call super::create
this.Control[]={this.tabpage_by_treatment,&
this.tabpage_encounter,&
this.tabpage_patient}
end on

on u_tab_history_parents.destroy
call super::destroy
destroy(this.tabpage_by_treatment)
destroy(this.tabpage_encounter)
destroy(this.tabpage_patient)
end on

type tabpage_by_treatment from u_tabpage_history_parents_treatments within u_tab_history_parents
integer x = 18
integer y = 16
integer width = 1143
integer height = 1136
string text = "By Date"
end type

type tabpage_encounter from u_tabpage_history_parents_encounter within u_tab_history_parents
boolean visible = false
integer x = 18
integer y = 16
integer width = 1143
integer height = 1136
string text = "This Encounter"
end type

type tabpage_patient from u_tabpage_history_parents_patient within u_tab_history_parents
integer x = 18
integer y = 16
integer width = 1143
integer height = 1136
string text = "By Observation"
end type

