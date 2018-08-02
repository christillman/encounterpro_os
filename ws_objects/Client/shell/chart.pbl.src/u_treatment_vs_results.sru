$PBExportHeader$u_treatment_vs_results.sru
forward
global type u_treatment_vs_results from userobject
end type
type cb_scroll_left from commandbutton within u_treatment_vs_results
end type
type cb_scroll_right from commandbutton within u_treatment_vs_results
end type
type gr_observations from u_gr_observation_results within u_treatment_vs_results
end type
type uo_timeline from u_treatments_timeline within u_treatment_vs_results
end type
end forward

global type u_treatment_vs_results from userobject
integer width = 2569
integer height = 1516
boolean border = true
long backcolor = 12632256
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_scroll_left cb_scroll_left
cb_scroll_right cb_scroll_right
gr_observations gr_observations
uo_timeline uo_timeline
end type
global u_treatment_vs_results u_treatment_vs_results

type variables
string observation_id
long problem_id
string assessment_id
string assessment_description

integer observation_count
str_observation_result_location observations[]

end variables

forward prototypes
public function integer refresh ()
public function integer initialize_timeline (long pl_problem_id)
public function integer initialize_graph (string ps_observation_id)
public function integer initialize (long pl_problem_id, string ps_observation_id)
end prototypes

public function integer refresh ();
uo_timeline.set_years(uo_timeline.problem_end_date)

return 1



end function

public function integer initialize_timeline (long pl_problem_id);string ls_filter
integer li_min_diagnoses_sequence
integer li_max_diagnoses_sequence

problem_id = pl_problem_id

ls_filter = "problem_id=" + string(problem_id)

// Select the min and max diagnosis_sequence and dates
SELECT min(diagnosis_sequence), max(diagnosis_sequence), min(assessment_id)
INTO :li_min_diagnoses_sequence, :li_max_diagnoses_sequence, :assessment_id
FROM p_Assessment
WHERE cpr_id = :current_patient.cpr_id
AND problem_id = :pl_problem_id;
if not tf_check() then return -1

// If there is more than one diagnosis_sequence, then get the max end_date from the last record
if li_min_diagnoses_sequence <> li_max_diagnoses_sequence then
	SELECT assessment_id
	INTO :assessment_id
	FROM p_Assessment
	WHERE cpr_id = :current_patient.cpr_id
	AND problem_id = :pl_problem_id
	AND diagnosis_sequence = :li_max_diagnoses_sequence;
	if not tf_check() then return -1
end if

// Get the assessment description

SELECT description
INTO :assessment_description
FROM c_Assessment_Definition
WHERE assessment_id = :assessment_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_treatment_vs_results.initialize_timeline.0036", "Assessment not found (" + assessment_id + ")", 4)
	return -1
end if

uo_timeline.initialize(problem_id)

uo_timeline.set_treatment_type("MEDICATION", true)

return 1


end function

public function integer initialize_graph (string ps_observation_id);integer i
str_observation_result_location lstr_observations[]
u_ds_data luo_data
string ls_title

observation_id = ps_observation_id

luo_data = CREATE u_ds_data
luo_data.set_dataobject("dw_obj_list_item_list")

SELECT description
INTO :ls_title
FROM c_observation
WHERE observation_id = :ps_observation_id;
if not tf_check() then return -1
if sqlca.sqlcode = 100 then
	log.log(this, "u_treatment_vs_results.initialize_graph.0017", "Objective list not found (" + string(ps_observation_id) + ")", 3)
	return -1
end if

// If this obj_list doesn't have any constituents, then don't show the graph
observation_count = luo_data.retrieve(ps_observation_id)
if observation_count = 0 then
	gr_observations.reset(All!)
else
	for i = 1 to observation_count
		lstr_observations[i].observation_id = luo_data.object.observation_id[i]
		lstr_observations[i].result_sequence = luo_data.object.result_sequence[i]
		lstr_observations[i].location = luo_data.object.location[i]
		lstr_observations[i].name = luo_data.object.description[i]
	next

	gr_observations.initialize(ls_title, observation_count, lstr_observations)
end if

DESTROY luo_data


return 1


end function

public function integer initialize (long pl_problem_id, string ps_observation_id);long ll_rightgap
integer li_sts

uo_timeline.width = width - 338
uo_timeline.height = 680
uo_timeline.x = 188
uo_timeline.y = height - uo_timeline.height - 20

gr_observations.x = 0
gr_observations.y = 0
gr_observations.width = width
gr_observations.height = uo_timeline.y

cb_scroll_left.x = (uo_timeline.x - cb_scroll_left.width) / 2
cb_scroll_left.y = uo_timeline.y
cb_scroll_left.height = 150

ll_rightgap = (width - uo_timeline.x - uo_timeline.width - cb_scroll_right.width ) / 2
cb_scroll_right.x = width - cb_scroll_right.width - ll_rightgap
cb_scroll_right.y = uo_timeline.y
cb_scroll_right.height = 150

li_sts = initialize_graph(ps_observation_id)
if li_sts <= 0 then return -1

li_sts = initialize_timeline(pl_problem_id)
if li_sts <= 0 then return -1

return 1


end function

on u_treatment_vs_results.create
this.cb_scroll_left=create cb_scroll_left
this.cb_scroll_right=create cb_scroll_right
this.gr_observations=create gr_observations
this.uo_timeline=create uo_timeline
this.Control[]={this.cb_scroll_left,&
this.cb_scroll_right,&
this.gr_observations,&
this.uo_timeline}
end on

on u_treatment_vs_results.destroy
destroy(this.cb_scroll_left)
destroy(this.cb_scroll_right)
destroy(this.gr_observations)
destroy(this.uo_timeline)
end on

type cb_scroll_left from commandbutton within u_treatment_vs_results
integer x = 50
integer y = 1024
integer width = 128
integer height = 196
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<<"
end type

event clicked;uo_timeline.scroll_left()

end event

type cb_scroll_right from commandbutton within u_treatment_vs_results
integer x = 2290
integer y = 1036
integer width = 123
integer height = 196
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">>"
end type

event clicked;uo_timeline.scroll_right()

end event

type gr_observations from u_gr_observation_results within u_treatment_vs_results
integer width = 2565
boolean enabled = true
end type

event clicked;str_popup popup
str_picked_observations lstr_observations
w_pick_observations lw_pick

integer li_sts
string ls_treatment_type,ls_observation_id

Setnull(ls_treatment_type)

popup.data_row_count = 4
popup.items[1] = ls_treatment_type
popup.items[2] = current_user.specialty_id
popup.items[3] = 'ASST_TIMELINE|'+assessment_id
popup.items[4] = 'Y'
popup.multiselect = false

openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
If  lstr_observations.observation_count <> 1 Then Return
ls_observation_id =  lstr_observations.observation_id[1]
li_sts = initialize_graph(ls_observation_id)
if li_sts > 0 then gr_observations.refresh(uo_timeline.begin_date, uo_timeline.end_date)


end event

type uo_timeline from u_treatments_timeline within u_treatment_vs_results
integer x = 192
integer y = 1036
integer width = 2071
integer height = 200
integer taborder = 10
boolean bringtotop = true
end type

on uo_timeline.destroy
call u_treatments_timeline::destroy
end on

event date_selected;str_popup popup
str_popup_return popup_return
string buttons[]
integer button_pressed, li_sts, li_service_count
window lw_pop_buttons
long ll_total_days
long ll_zoom
date ld_begin_date
date ld_end_date


if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Show Years"
	popup.button_titles[popup.button_count] = "Show Years"
	buttons[popup.button_count] = "YEARS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Show Quarters"
	popup.button_titles[popup.button_count] = "Show Quarters"
	buttons[popup.button_count] = "QUARTERS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button17.bmp"
	popup.button_helps[popup.button_count] = "Show Months"
	popup.button_titles[popup.button_count] = "Show Months"
	buttons[popup.button_count] = "MONTHS"
end if

if true then
	popup.button_count = popup.button_count + 1
	popup.button_icons[popup.button_count] = "button11.bmp"
	popup.button_helps[popup.button_count] = "Cancel"
	popup.button_titles[popup.button_count] = "Cancel"
	buttons[popup.button_count] = "CANCEL"
end if

popup.button_titles_used = true

if popup.button_count > 1 then
	openwithparm(lw_pop_buttons, popup, "w_pop_buttons")
	button_pressed = message.doubleparm
	if button_pressed < 1 or button_pressed > popup.button_count then return
elseif popup.button_count = 1 then
	button_pressed = 1
else
	return
end if

CHOOSE CASE buttons[button_pressed]
	CASE "YEARS"
		uo_timeline.set_years(date_selected)
	CASE "QUARTERS"
		uo_timeline.set_quarters(date_selected)
	CASE "MONTHS"
		uo_timeline.set_months(date_selected)
	CASE "CANCEL"
		return
	CASE ELSE
END CHOOSE


return






end event

event treatments_selected;str_popup popup
str_popup_return popup_return

popup.data_row_count = 4
popup.items[1] = string(problem_id)
popup.items[2] = assessment_id
popup.items[3] = assessment_description
popup.items[4] = string(date_selected, date_format_string)
popup.anyparm = current_treatments

openwithparm(w_treatment_timeline_clicked, popup)

end event

event date_range_changed;gr_observations.refresh(new_begin_date, new_end_date)

end event

