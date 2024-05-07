$PBExportHeader$w_svc_monitor_result.srw
forward
global type w_svc_monitor_result from w_window_base
end type
type cb_be_back from commandbutton within w_svc_monitor_result
end type
type cb_done from commandbutton within w_svc_monitor_result
end type
type st_title from statictext within w_svc_monitor_result
end type
type st_show_data from statictext within w_svc_monitor_result
end type
type st_show_graph from statictext within w_svc_monitor_result
end type
type dw_results from u_dw_pick_list within w_svc_monitor_result
end type
end forward

global type w_svc_monitor_result from w_window_base
string title = "Retry Posting"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
string button_type = "COMMAND"
integer max_buttons = 2
cb_be_back cb_be_back
cb_done cb_done
st_title st_title
st_show_data st_show_data
st_show_graph st_show_graph
dw_results dw_results
end type
global w_svc_monitor_result w_svc_monitor_result

type variables
u_component_service service

string observation_id
integer result_sequence

string show_which

end variables

forward prototypes
public function integer refresh ()
end prototypes

public function integer refresh ();u_ds_data luo_data
long ll_count
long i
long ll_row
string ls_pretty_result
string ls_result
string ls_location
string ls_location_description
string ls_result_value
string ls_result_unit
string ls_result_amount_flag
string ls_print_result_flag
string ls_print_result_separator
string ls_abnormal_flag
string ls_unit_preference
string ls_display_mask
long ll_row_number
decimal ld_low_normal
decimal ld_high_normal
string ls_graph_unit
decimal ld_graph_min
decimal ld_graph_max
decimal ld_value

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_jmj_get_observation_result_history")
ll_count = luo_data.retrieve(current_patient.cpr_id, observation_id, result_sequence)
if ll_count < 0 then return -1


if show_which = "Data" then
	st_show_data.backcolor = color_object_selected
	st_show_graph.backcolor = color_object
	
	dw_results.dataobject = "dw_observation_result_history_display"
	dw_results.setredraw(false)

	dw_results.reset()
	
	for i = ll_count to 1 step -1
		ls_result = luo_data.object.result[i]
		ls_location = luo_data.object.location[i]
		ls_location_description = luo_data.object.location_description[i]
		ls_result_value = luo_data.object.result_value[i]
		ls_result_unit = luo_data.object.result_unit[i]
		ls_result_amount_flag = luo_data.object.result_amount_flag[i]
		ls_print_result_flag = luo_data.object.print_result_flag[i]
		ls_print_result_separator = luo_data.object.print_result_separator[i]
		ls_abnormal_flag = luo_data.object.abnormal_flag[i]
		ls_unit_preference = luo_data.object.unit_preference[i]
		ls_display_mask = luo_data.object.display_mask[i]
	
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
														false, &
														true )
	
		if len(ls_pretty_result) > 0 then
			ll_row = dw_results.insertrow(0)
			dw_results.object.observation_sequence[ll_row] = luo_data.object.observation_sequence[i]
			dw_results.object.location_result_sequence[ll_row] = luo_data.object.location_result_sequence[i]
			dw_results.object.result_date_time[ll_row] = luo_data.object.result_date_time[i]
			dw_results.object.result[ll_row] = ls_pretty_result
		end if
	next
	
else
	st_show_data.backcolor = color_object
	st_show_graph.backcolor = color_object_selected
	
	dw_results.dataobject = "dw_result_history_graph"
	dw_results.setredraw(false)
	
	dw_results.reset()
	
	ll_row_number = 0
	setnull(ls_result_unit)
	setnull(ld_graph_min)
	setnull(ld_graph_max)
	
	SELECT 	TOP 1 low_normal,
						high_normal
	INTO :ld_low_normal,
			:ld_high_normal
	FROM c_Observation_Result_Range
	WHERE observation_id = :observation_id
	AND result_sequence = :result_sequence
	AND (:current_patient.sex IS NULL OR ISNULL(sex, '@') = :current_patient.sex)
	AND (age_range_id IS NULL OR dbo.fn_age_range_compare(age_range_id, :current_patient.date_of_birth, dbo.get_client_datetime()) = 0)
	ORDER BY search_sequence;
	if not tf_check() then return -1
	if sqlca.sqlcode = 100 then
		setnull(ld_low_normal)
		setnull(ld_high_normal)
	else
		ld_graph_min = ld_low_normal
		ld_graph_max = ld_high_normal
	end if
	
	for i = 1 to ll_count
		ls_result = luo_data.object.result[i]
		ls_location = luo_data.object.location[i]
		ls_location_description = luo_data.object.location_description[i]
		ls_result_value = luo_data.object.result_value[i]
		ls_result_unit = luo_data.object.result_unit[i]
		ls_result_amount_flag = luo_data.object.result_amount_flag[i]
		ls_print_result_flag = luo_data.object.print_result_flag[i]
		ls_print_result_separator = luo_data.object.print_result_separator[i]
		ls_abnormal_flag = luo_data.object.abnormal_flag[i]
		ls_unit_preference = luo_data.object.unit_preference[i]
		ls_display_mask = luo_data.object.display_mask[i]
	
		if isnull(ls_graph_unit) then
			ls_graph_unit = ls_result_unit
		end if
	
		if isnumber(ls_result_value) then
			ld_value = dec(ls_result_value)
			
			if isnull(ld_graph_min) or ld_value < ld_graph_min then
				ld_graph_min = ld_value
			end if

			if isnull(ld_graph_max) or ld_value > ld_graph_max then
				ld_graph_max = ld_value
			end if

			ll_row_number += 1
			ll_row = dw_results.insertrow(0)
			dw_results.object.series_name[ll_row] = ls_result
			dw_results.object.row_number[ll_row] = ll_row_number
			dw_results.object.result[ll_row] = ld_value
			
			if not isnull(ld_low_normal) then
				ll_row = dw_results.insertrow(0)
				dw_results.object.series_name[ll_row] = "Low Normal"
				dw_results.object.row_number[ll_row] = ll_row_number
				dw_results.object.result[ll_row] = ld_low_normal
			end if
			
			if not isnull(ld_high_normal) then
				ll_row = dw_results.insertrow(0)
				dw_results.object.series_name[ll_row] = "High Normal"
				dw_results.object.row_number[ll_row] = ll_row_number
				dw_results.object.result[ll_row] = ld_high_normal
			end if
		end if
	next

	dw_results.object.gr_1.Category.Label = ""
	dw_results.object.gr_1.Values.Label = ls_graph_unit
	dw_results.object.gr_1.Values.MinimumValue = string(ld_graph_min)
	dw_results.object.gr_1.Values.MaximumValue = string(ld_graph_max)

end if

DESTROY luo_data

dw_results.setredraw(true)



return 1

end function

on w_svc_monitor_result.create
int iCurrent
call super::create
this.cb_be_back=create cb_be_back
this.cb_done=create cb_done
this.st_title=create st_title
this.st_show_data=create st_show_data
this.st_show_graph=create st_show_graph
this.dw_results=create dw_results
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_be_back
this.Control[iCurrent+2]=this.cb_done
this.Control[iCurrent+3]=this.st_title
this.Control[iCurrent+4]=this.st_show_data
this.Control[iCurrent+5]=this.st_show_graph
this.Control[iCurrent+6]=this.dw_results
end on

on w_svc_monitor_result.destroy
call super::destroy
destroy(this.cb_be_back)
destroy(this.cb_done)
destroy(this.st_title)
destroy(this.st_show_data)
destroy(this.st_show_graph)
destroy(this.dw_results)
end on

event post_open;call super::post_open;String ls_cpr_id
Long ll_encounter_id

ls_cpr_id = current_patient.cpr_id
ll_encounter_id = current_patient.open_encounter_id

UPDATE p_Patient_Encounter
SET billing_posted = "R"
WHERE cpr_id = :ls_cpr_id
AND encounter_id = :ll_encounter_id
AND billing_posted = "E";
if not tf_check() then return -1
if sqlca.sqlcode = 100 then return 0

Close(this)

end event

event open;call super::open;str_popup_return popup_return
long ll_menu_id
integer li_sts
u_user luo_user
string ls_observation
str_c_observation_result lstr_result
string ls_temp

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

service = message.powerobjectparm

title = current_patient.id_line()

// Don't offer the "I'll Be Back" option for manual services
max_buttons = 2
//if service.manual_service then
//	cb_be_back.visible = false
//	max_buttons = 3
//end if

// Paint the menu
ll_menu_id = long(service.get_attribute("menu_id"))
paint_menu(ll_menu_id)


service.get_attribute("observation_id", observation_id)
if isnull(observation_id) then
	if not isnull(service.treatment) then
		observation_id = service.treatment.observation_id
	end if
	if isnull(observation_id) then
		log.log(this, "w_svc_monitor_result:open", "No observation_id found", 4)
		closewithreturn(this, popup_return)
		return
	end if
end if

service.get_attribute("result_sequence", result_sequence)
if isnull(result_sequence) then
	if not isnull(service.treatment) then
		ls_temp = f_get_progress_value(current_patient.cpr_id, &
												"Treatment", &
												service.treatment.treatment_id, &
												"Property", &
												"result_sequence")
		if isnumber(ls_temp) then result_sequence = integer(ls_temp)
	end if
	if isnull(result_sequence) then
		log.log(this, "w_svc_monitor_result:open", "No result_sequence found", 4)
		closewithreturn(this, popup_return)
		return
	end if
end if

ls_observation = datalist.observation_description(observation_id)
if isnull(ls_observation) then
	log.log(this, "w_svc_monitor_result:open", "Invalid observation_id (" + observation_id + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

st_title.text = ls_observation

lstr_result = datalist.observation_result(observation_id, result_sequence)
if isnull(lstr_result.result_sequence) then
	log.log(this, "w_svc_monitor_result:open", "Invalid result_sequence (" + observation_id + ", " + string(result_sequence) + ")", 4)
	closewithreturn(this, popup_return)
	return
end if

// If the result description is not included in the observation description then add it to the title
if lower(left(ls_observation, len(lstr_result.result))) <> lower(lstr_result.result) then
	st_title.text += " - " + lstr_result.result
end if

st_title.text += " History"

show_which = service.get_attribute("initial_view")
if lower(show_which) = "graph" then
	show_which = "Graph"
else
	show_which = "Data"
end if


refresh()

end event

type pb_epro_help from w_window_base`pb_epro_help within w_svc_monitor_result
boolean visible = true
integer x = 2656
integer y = 32
end type

type st_config_mode_menu from w_window_base`st_config_mode_menu within w_svc_monitor_result
integer x = 23
end type

type cb_be_back from commandbutton within w_svc_monitor_result
integer x = 2167
integer y = 1596
integer width = 695
integer height = 108
integer taborder = 70
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Continue Monitoring"
end type

event clicked;str_popup_return popup_return

popup_return.item_count = 0
closewithreturn(parent, popup_return)


end event

type cb_done from commandbutton within w_svc_monitor_result
integer x = 1541
integer y = 1596
integer width = 581
integer height = 108
integer taborder = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Stop Monitoring"
end type

event clicked;str_popup_return popup_return

openwithparm(w_pop_yes_no, "Are you sure you want to stop monitoring this observation?")
popup_return = message.powerobjectparm
if popup_return.item <> "YES" then return

popup_return.item_count = 1
popup_return.items[1] = "OK"

closewithreturn(parent, popup_return)


end event

type st_title from statictext within w_svc_monitor_result
integer width = 2921
integer height = 120
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 7191717
string text = "Patient Monitor History"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_show_data from statictext within w_svc_monitor_result
integer x = 942
integer y = 1436
integer width = 448
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Data"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;show_which = "Data"
refresh()

end event

type st_show_graph from statictext within w_svc_monitor_result
integer x = 1522
integer y = 1436
integer width = 448
integer height = 112
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Graph"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;show_which = "Graph"
refresh()

end event

type dw_results from u_dw_pick_list within w_svc_monitor_result
integer x = 87
integer y = 176
integer width = 2747
integer taborder = 11
boolean bringtotop = true
string dataobject = "dw_observation_result_history_display"
boolean vscrollbar = true
end type

