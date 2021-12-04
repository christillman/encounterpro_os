$PBExportHeader$u_tabpage_hm_class_metrics.sru
forward
global type u_tabpage_hm_class_metrics from u_tabpage_hm_class_base
end type
type st_no_metrics from statictext within u_tabpage_hm_class_metrics
end type
type cb_add_metric from commandbutton within u_tabpage_hm_class_metrics
end type
type tab_metrics from u_tab_hm_class_metrics within u_tabpage_hm_class_metrics
end type
type tab_metrics from u_tab_hm_class_metrics within u_tabpage_hm_class_metrics
end type
end forward

global type u_tabpage_hm_class_metrics from u_tabpage_hm_class_base
st_no_metrics st_no_metrics
cb_add_metric cb_add_metric
tab_metrics tab_metrics
end type
global u_tabpage_hm_class_metrics u_tabpage_hm_class_metrics

type variables

end variables

forward prototypes
public function integer initialize (str_hm_context pstr_hm_context, long pl_index)
public function integer add_metric ()
end prototypes

public function integer initialize (str_hm_context pstr_hm_context, long pl_index);integer li_sts

tab_metrics.width = width
tab_metrics.height = height - cb_add_metric.height - 40

st_no_metrics.x = (width - st_no_metrics.width) / 2
st_no_metrics.y = (height - st_no_metrics.height) / 2

cb_add_metric.x = width - cb_add_metric.width - 20
cb_add_metric.y = height - cb_add_metric.height - 20

li_sts = tab_metrics.initialize(pstr_hm_context)
if li_sts = 0 then
	tab_metrics.visible = false
	st_no_metrics.visible = true
else
	tab_metrics.visible = true
	st_no_metrics.visible = false
end if

return li_sts


end function

public function integer add_metric ();integer li_sts
str_popup popup
str_popup_return popup_return
str_picked_observations lstr_observations
string ls_observation_id
string ls_description
long ll_row
string ls_composite_flag
long i
string ls_treatment_type
w_window_base lw_pick
string ls_observation_description
integer li_result_sequence
string ls_message
string ls_title
long ll_interval
string ls_interval_unit
str_hm_context lstr_hm_context

popup.title = "Select Observations"

setnull(ls_treatment_type)

popup.multiselect = false
//	treatment_type = popup.items[1]
//	dw_observations.specialty_id = popup.items[2]
//	special_top_20_code = popup.items[3]
//	composite_flag = popup.items[4] // 'Y'-Composite , 'N' - Simple
popup.data_row_count = 4
popup.items[1] = "Lab"
popup.items[2] = current_user.specialty_id
popup.items[3] = "HM Metrics"
popup.items[4] = "N"
openwithparm(lw_pick, popup, "w_pick_observations")
lstr_observations = message.powerobjectparm
if lstr_observations.observation_count <> 1 then return 0

ls_observation_description = lstr_observations.description[1]
ls_observation_id = lstr_observations.observation_id[1]

popup.title = "Select Result"
popup.dataobject = "dw_fn_hm_metric_observation_results"
popup.data_row_count = 0
popup.datacolumn = 1
popup.displaycolumn = 2
popup.multiselect = false
popup.argument_count = 1
popup.argument[1] = ls_observation_id
openwithparm(lw_pick, popup, "w_pop_pick")
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then
	if popup_return.choices_count = 0 then
		ls_message = "The selected observation does not have any numeric results, so EncounterPRO will not produce graphs for this metric.  Do you still wish to use ~""
		ls_message += ls_observation_description
		ls_message += "~" as a metric for this class?"
	else
		ls_message = "If you do not select a specific numeric result, then EncounterPRO will not produce graphs for this metric.  Do you wish to use ~""
		ls_message += ls_observation_description
		ls_message += "~" as a metric for this class?"
	end if
	openwithparm(w_pop_yes_no, ls_message)
	popup_return = message.powerobjectparm
	if popup_return.item <> "YES" then return 0
	
	ls_description = ls_observation_description
	setnull(li_result_sequence)
else
	ls_description = ls_observation_description + ":" + popup_return.descriptions[1]
	li_result_sequence = integer(popup_return.items[1])
end if


// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
// displaycolumn		Max Length
popup.title = "Please specify the title for this metric"
popup.item = left(ls_description, 80)
popup.displaycolumn = 80
popup.data_row_count = 0
popup.argument_count = 0
popup.multiselect = false
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0
ls_title = popup_return.item

// title					Screen title/user instructions
// item					Default string value
//	data_row_count		Number of items in the canned selections list
// items[]				list of canned selections
// argument_count		Number of top_20 arguments supplied
// argument[]			List of top_20 arguments
//							argument[1] = specific top_20_code
//							argument[2] = generic top_20_code
// multiselect			True = Allow empty string
//							False = Don't allow empty string
// displaycolumn		Max Length
popup.title = "Please specify the description for this metric"
popup.item = ls_title
popup.displaycolumn = 80
popup.data_row_count = 0
popup.argument_count = 0
popup.multiselect = false
openwithparm(w_pop_prompt_string, popup)
popup_return = message.powerobjectparm
if popup_return.item_count <> 1 then return 0
ls_description = popup_return.item

setnull(ll_interval)
setnull(ls_interval_unit)

li_sts = hmclasstab.add_metric(ls_title, ls_description, ls_observation_id, li_result_sequence, ll_interval, ls_interval_unit)

tab_metrics.hm_class = hmclasstab.hm_class

lstr_hm_context.maintenance_rule_id = hmclasstab.hm_class.maintenance_rule_id
li_sts = tab_metrics.initialize(lstr_hm_context)
if li_sts = 0 then
	tab_metrics.visible = false
	st_no_metrics.visible = true
else
	tab_metrics.visible = true
	st_no_metrics.visible = false
end if

return 1

end function

on u_tabpage_hm_class_metrics.create
int iCurrent
call super::create
this.st_no_metrics=create st_no_metrics
this.cb_add_metric=create cb_add_metric
this.tab_metrics=create tab_metrics
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_no_metrics
this.Control[iCurrent+2]=this.cb_add_metric
this.Control[iCurrent+3]=this.tab_metrics
end on

on u_tabpage_hm_class_metrics.destroy
call super::destroy
destroy(this.st_no_metrics)
destroy(this.cb_add_metric)
destroy(this.tab_metrics)
end on

type st_no_metrics from statictext within u_tabpage_hm_class_metrics
integer x = 823
integer y = 680
integer width = 1033
integer height = 92
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = COLOR_BACKGROUND
string text = "No Metrics are Defined"
boolean focusrectangle = false
end type

type cb_add_metric from commandbutton within u_tabpage_hm_class_metrics
integer x = 1755
integer y = 1380
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Add Metric"
end type

event clicked;add_metric()

end event

type tab_metrics from u_tab_hm_class_metrics within u_tabpage_hm_class_metrics
integer width = 2002
integer height = 1000
end type

