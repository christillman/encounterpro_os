$PBExportHeader$w_svc_treatment_highlight_results.srw
forward
global type w_svc_treatment_highlight_results from w_svc_generic
end type
type st_1 from statictext within w_svc_treatment_highlight_results
end type
type st_abnormal_flag_yes from statictext within w_svc_treatment_highlight_results
end type
type st_abnormal_flag_no from statictext within w_svc_treatment_highlight_results
end type
type dw_results from u_dw_pick_list within w_svc_treatment_highlight_results
end type
end forward

global type w_svc_treatment_highlight_results from w_svc_generic
st_1 st_1
st_abnormal_flag_yes st_abnormal_flag_yes
st_abnormal_flag_no st_abnormal_flag_no
dw_results dw_results
end type
global w_svc_treatment_highlight_results w_svc_treatment_highlight_results

type variables
long highlight_color

string result_type = "PERFORM"
string abnormal_flag

string highlight_progress_type = "Highlight"
string highlight_progress_key = "Highlight"

end variables

forward prototypes
public function integer refresh ()
public function integer set_highlight (string ps_cpr_id, long pl_observation_sequence, long pl_location_result_sequence, long pl_encounter_id, string ps_progress)
end prototypes

public function integer refresh ();u_ds_observation_results luo_results
u_ds_data luo_highights
long ll_count
string ls_root_observation_id
string ls_root_observation_tag
string ls_child_observation_id
string ls_child_observation_tag
string ls_exclude_observation_tag
str_pretty_results lstr_results
long ll_highlight_count
long i
long ll_result_row
long ll_highlight_row
string ls_find
long ll_highlight_color
string ls_highlight_value


setnull(ls_root_observation_id)
setnull(ls_root_observation_tag)
setnull(ls_child_observation_id)
setnull(ls_child_observation_tag)
setnull(ls_exclude_observation_tag)

st_title.text = service.treatment.treatment_description
if abnormal_flag = "Y" then
	st_abnormal_flag_yes.backcolor = color_object_selected
	st_abnormal_flag_no.backcolor = color_object
else
	st_abnormal_flag_yes.backcolor = color_object
	st_abnormal_flag_no.backcolor = color_object_selected
end if


luo_results = CREATE u_ds_observation_results
luo_results.set_dataobject("dw_sp_obstree_treatment_all")
ll_count = luo_results.retrieve(current_patient.cpr_id, &
											service.treatment_id, &
											ls_root_observation_id, &
											ls_root_observation_tag, &
											ls_child_observation_id, &
											ls_child_observation_tag, &
											ls_exclude_observation_tag)
if ll_Count < 0 then return -1
if ll_Count = 0 then
	openwithparm(w_pop_message, "This treatment has no results")
	return 0
end if

lstr_results = luo_results.get_pretty_results(result_type, abnormal_flag)

luo_highights = CREATE u_ds_data
luo_highights.set_dataobject("dw_treatment_result_progress")
ll_highlight_count = luo_highights.retrieve(current_patient.cpr_id, &
															service.treatment_id, &
															highlight_progress_type, &
															highlight_progress_key)
if ll_highlight_count < 0 then return -1


dw_results.reset()

for i = 1 to lstr_results.result_count
	ll_result_row = dw_results.insertrow(0)
	
	dw_results.object.test_name[ll_result_row] = lstr_results.result[i].test_name
	dw_results.object.result[ll_result_row] = lstr_results.result[i].result
	dw_results.object.abnormal_flag[ll_result_row] = lstr_results.result[i].abnormal_flag
	dw_results.object.abnormal_nature[ll_result_row] = lstr_results.result[i].abnormal_nature
	dw_results.object.normal_range[ll_result_row] = lstr_results.result[i].normal_range
	dw_results.object.observed_by[ll_result_row] = lstr_results.result[i].observed_by
	dw_results.object.root_sequence[ll_result_row] = lstr_results.result[i].root_sequence
	dw_results.object.parent_sequence[ll_result_row] = lstr_results.result[i].parent_sequence
	dw_results.object.sort_sequence[ll_result_row] = lstr_results.result[i].sort_sequence
	dw_results.object.cpr_id[ll_result_row] = lstr_results.result[i].cpr_id
	dw_results.object.observation_sequence[ll_result_row] = lstr_results.result[i].observation_sequence
	dw_results.object.location_result_sequence[ll_result_row] = lstr_results.result[i].location_result_sequence
	
	// Now set the highlight
	setnull(ll_highlight_color)
	ls_find = "location_result_sequence=" + string(lstr_results.result[i].location_result_sequence)
	ll_highlight_row = luo_highights.find(ls_find, 1, ll_highlight_count)
	if ll_highlight_row > 0 then
		ls_highlight_value = luo_highights.object.progress_value[ll_highlight_row]
		if f_string_to_boolean(ls_highlight_value) then
			ll_highlight_color = highlight_color
		end if
	end if
	dw_results.object.highlight_color[ll_result_row] = ll_highlight_color
next

DESTROY luo_results

return 1



end function

public function integer set_highlight (string ps_cpr_id, long pl_observation_sequence, long pl_location_result_sequence, long pl_encounter_id, string ps_progress);datetime ldt_progress_date_time

ldt_progress_date_time = datetime(today(), now())

sqlca.sp_set_observation_result_progress ( ps_cpr_id, &
														pl_observation_sequence , &
														pl_location_result_sequence , &
														pl_encounter_id , &
														highlight_progress_type , &
														highlight_progress_key , &
														ps_progress , &
														ldt_progress_date_time , &
														current_user.user_id , &
														current_scribe.user_id )
if not tf_check() then return -1


return 1

end function

on w_svc_treatment_highlight_results.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_abnormal_flag_yes=create st_abnormal_flag_yes
this.st_abnormal_flag_no=create st_abnormal_flag_no
this.dw_results=create dw_results
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_abnormal_flag_yes
this.Control[iCurrent+3]=this.st_abnormal_flag_no
this.Control[iCurrent+4]=this.dw_results
end on

on w_svc_treatment_highlight_results.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_abnormal_flag_yes)
destroy(this.st_abnormal_flag_no)
destroy(this.dw_results)
end on

event open;call super::open;str_popup_return popup_return

//dw_assessments.multiselect = true

popup_return.item_count = 1
popup_return.items[1] = "ERROR"

if isnull(service.treatment) then
	log.log(this, "w_svc_treatment_highlight_results:open", "No treatment context", 4)
	closewithreturn(this, popup_return)
end if

//dw_assessments.object.description.width = dw_assessments.width - 247

service.get_attribute("highlight_color", highlight_color)
if isnull(highlight_color) then highlight_color = rgb(255, 255, 128)


result_type = service.get_attribute("result_type")
if isnull(result_type) then result_type = "PERFORM"

abnormal_flag = service.get_attribute("abnormal_flag")
if isnull(abnormal_flag) then abnormal_flag = "N"

highlight_progress_type = service.get_attribute("highlight_progress_type")
if isnull(highlight_progress_type) then highlight_progress_type = "Highlight"

highlight_progress_key = service.get_attribute("highlight_progress_key")
if isnull(highlight_progress_key) then highlight_progress_key = "Highlight"

// Move fields to the right
dw_results.object.t_highlight_result_title.x = dw_results.width - 681
dw_results.object.b_highlight_no.x = dw_results.width - 612
dw_results.object.b_highlight_yes.x = dw_results.width - 379
dw_results.object.b_more.x = dw_results.width - 827
dw_results.object.l_title.x2 = dw_results.width - 132

long ll_delta

ll_delta = (dw_results.width - 2889) / 2

// Move and widen
dw_results.object.compute_result.x = ll_delta + 1029
dw_results.object.compute_result.width = ll_delta + 1024
dw_results.object.t_result_title.x = ll_delta + 1029

// Just widen
dw_results.object.test_name.width = ll_delta + 978


refresh()

return 1

end event

type pb_epro_help from w_svc_generic`pb_epro_help within w_svc_treatment_highlight_results
end type

type st_config_mode_menu from w_svc_generic`st_config_mode_menu within w_svc_treatment_highlight_results
boolean visible = true
integer x = 14
integer y = 1568
end type

type cb_finished from w_svc_generic`cb_finished within w_svc_treatment_highlight_results
end type

type cb_be_back from w_svc_generic`cb_be_back within w_svc_treatment_highlight_results
end type

type cb_cancel from w_svc_generic`cb_cancel within w_svc_treatment_highlight_results
end type

type st_title from w_svc_generic`st_title within w_svc_treatment_highlight_results
integer textsize = -14
string text = "Hightlight Results"
end type

type st_1 from statictext within w_svc_treatment_highlight_results
integer x = 2021
integer y = 156
integer width = 503
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "Abnormals Only:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_abnormal_flag_yes from statictext within w_svc_treatment_highlight_results
integer x = 2542
integer y = 148
integer width = 165
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Yes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;abnormal_flag = 'Y'

refresh()

end event

type st_abnormal_flag_no from statictext within w_svc_treatment_highlight_results
integer x = 2734
integer y = 148
integer width = 165
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "No"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

event clicked;abnormal_flag = 'N'

refresh()

end event

type dw_results from u_dw_pick_list within w_svc_treatment_highlight_results
integer x = 14
integer y = 260
integer width = 2889
integer height = 1308
integer taborder = 10
string dataobject = "dw_highlight_results"
boolean vscrollbar = true
boolean livescroll = false
borderstyle borderstyle = stylelowered!
end type

event unselected;call super::unselected;long ll_problem_id
integer li_sts

ll_problem_id = object.problem_id[unselected_row]
li_sts = current_patient.treatments.set_treatment_assessment(service.treatment.treatment_id, ll_problem_id, false)

return

end event

event selected;call super::selected;long ll_problem_id
integer li_sts

ll_problem_id = object.problem_id[selected_row]
li_sts = current_patient.treatments.set_treatment_assessment(service.treatment.treatment_id, ll_problem_id, true)

return

end event

event buttonclicked;call super::buttonclicked;long ll_observation_sequence
long ll_location_result_sequence
long ll_encounter_id
integer li_sts
string ls_result
long ll_null
long ll_rowcount
long ll_lastrowonpage

setnull(ll_null)

ll_observation_sequence = object.observation_sequence[row]
ll_location_result_sequence = object.location_result_sequence[row]
ll_encounter_id = service.encounter_id
ls_result = object.result[row]
ll_lastrowonpage = long(object.DataWindow.LastRowOnPage)
ll_rowcount = rowcount()

CHOOSE CASE lower(dwo.name)
	CASE "b_more"
		openwithparm(w_pop_message, ls_result)
	CASE "b_highlight_no"
		li_sts = set_highlight(current_patient.cpr_id, &
										ll_observation_sequence, &
										ll_location_result_sequence, &
										ll_encounter_id, &
										"N")
		object.highlight_color[row] = ll_null
		if ll_lastrowonpage = row and ll_rowcount > ll_lastrowonpage then ScrollNextPage()
	CASE "b_highlight_yes"
		li_sts = set_highlight(current_patient.cpr_id, &
										ll_observation_sequence, &
										ll_location_result_sequence, &
										ll_encounter_id, &
										"Y")
		object.highlight_color[row] = highlight_color
		if ll_lastrowonpage = row and ll_rowcount > ll_lastrowonpage then ScrollNextPage()
END CHOOSE

end event

